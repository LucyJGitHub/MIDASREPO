     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Extract Shadow Postings from RSACMTPD')       *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE000192 - Extract Shadow Postings from RSACMTPD             *
      *                                                               *
      *  Function:  This program writes records to new file REBNODPD  *
      *             when a record is written to RSACMTPD file         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Note: Any change on this program should also be applied on   *
      *        RE000193.                                              *
      *                                                               *
      *  Last Amend No. MD025559           Date 18Mar14               *
      *  Prev Amend No. CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26106           Date 18Sep09               *
      *                 BUG26497           Date 21Oct09               *
      *                 BUG21528           Date 04Nov08               *
      *                 CER037  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD025559 - A Serious Midas Error encountered when completing *
      *             a Time Deposit Deal. Increase PMQString length to *
      *             12000.                                            *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26106 - UAT testing of German Features has shown an error *
      *             with missing records on the REBNODPD file.        *
      *             Added notes on the maintenance log. (Recompile)   *
      *  BUG26497 - A Serious Midas Error encountered when completing *
      *             a Time Deposit Deal; Deal number outside range    *
      *             for manual deal numbers                           *
      *  BUG21528 - System does not write data to message queue.      *
      *  CER037 - Creation of the Extract File for the Online         *
      *           Dispo Module                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7+U8 - Database Error Indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRRtvrn - Retrieve account details                           *
      *  SRGlshm - Subroutine to extract Shadow postings              *
      *  *PSSR - Program exception error routine                      *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas Extract Shadow Postings file
      *
     FREBNODPD  O    E           K DISK    INFSR(*PSSR)
     F                                     COMMIT(CMTLCK)
      *
      ** Midas Extract Shadow Postings file logical
      *
     FREBNODL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REBNODD0:REBNODD1)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically Included D-Specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Array used to define fields composed of multiple sub-fields
      *
     D FLD             S              1    DIM(50)
      *
      ** Local data area for database error details.
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines :                    142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D LDA           E DS
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Local data area for Run Date Informations.
      *
     D RUNDAT        E DS
      *
      ** +--------------------------------------+
      ** ¦ End Of Automatically Included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** Constant to define maximum NUMKEY
      *
     DCNUMKEY          C                   '999999999999999'
      *
      ** Constant to define Send Extracted to Destination
      *
     D WSysVal1        C                   CONST('GFExtract')
      *
      ** Constant to define MQ Message Queue
      *
     D WSysVal2        C                   CONST('GFMessageQueue')
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
     D  ACLCD        E                     EXTFLD(LCD)
     D  AACNO        E                     EXTFLD(ACNO)
      *
      ** Data structure for Retail Details
      *
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
      *
      ** Data structure for Switchable Features Details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** Data structure for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Data structure for Currency Details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Data structure for narrative Details
      *
     D SDNARR        E DS                  EXTNAME(SDNARRPD)
      *
      ** Data structure for SD Modules
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** First DS for access programs, long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Second DS for access programs, short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
     D PARM1           DS
      *
      ** Physical file name
      *
     D  FNAME                        10
      *
      ** Physical file library
      *
     D  LNAME                        10
      *
      ** Member name
      *
     D  MNAME                        10
      *
      ** Trigger event 1=Ins, 2=Del, 3=Upd
      *
     D  TEVEN                         1
      *
      ** Trigger time  1=After, 2=Before
      *
     D  TTIME                         1
      *
      ** Commit lock level
      *
     D  CMTLCK                        1
      *
      ** Reserved
      *
     D  FILL1                         3
      *
      ** CCSID
      *
     D  CCSID                         9B 0
      *
      ** Reserved
      *
     D  FILL2                         8
      *
      ** Offset to the original record (Add 1|)
      *
     D  OLDOFF                        9B 0
      *
      ** Length of the original record
      *
     D  OLDLEN                        9B 0
      *
      ** Offset to the original record null byte map (Add 1|)
      *
     D  ONOFF                         9B 0
      *
      ** Length of the null byte map
      *
     D  ONLEN                         9B 0
      *
      ** Offset to the new record (Add 1|)
      *
     D  NEWOFF                        9B 0
      *
      ** Length of the new record
      *
     D  NEWLEN                        9B 0
      *
      ** Offset to the new record null byte map (Add 1|)
      *
     D  NNOFF                         9B 0
      *
      ** Length of the null byte map
      *
     D  NNLEN                         9B 0
      *
      ** Reserved
      *
     D  RESV3                        16
      *
      ** Records
      *
     D  RECS                        630
      *
      ** Trigger Buffer Length
      *
     D PARM2           DS
      *
      ** Reserved
      *
     D  LENG                          9B 0
      *
      ** DS to split posting narrative
      *
     D DSPNAR          DS            30
     D  DSTRYP                 1      2
     D  DSTNMR                 6     11
      *
     D RSAC          E DS                  EXTNAME(RSACMTPD)
     D  RSBRCA       E                     EXTFLD(BRCA)
     D  RSVUDT       E                     EXTFLD(VUDT)
     D  RSPTDT       E                     EXTFLD(PTDT)
     D  RSCCYD       E                     EXTFLD(CCYD)
     D  RSMVAM       E                     EXTFLD(MVAM)
     D  RSDORC       E                     EXTFLD(DORC)
     D  RSNRTD       E                     EXTFLD(NRTD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D REUNIQKY        S             15S 0
      *
      ** Parameter variables
      *
     D PRtcd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D PAcno           S             10A
     D PBrch           S              3A
     D PCusn           S              6A
     D PCurr           S              3A
     D PCode           S             10A
     D PSequ           S              2A
     D PKey            S              3A
     D PDate6          S              6A
     D PDate8          S              8A
      *
      ** Work variables
      *
     D WRun            S              1A
     D WCpy            S             80A
     D WTryp           S              1A
     D WNumkey         S             15S 0
     D KNumkey         S             15A
      *
      ** Parameters for AOSVALR0
      *
     D PSysValK1       S             20A
     D PCurSet1        S            200A
     D PSysValK2       S             20A
     D PCurSet2        S            200A
     D PSysValK3       S             20A
     D PCurSet3        S            200A
     D PSysValK4       S             20A
     D PCurSet4        S            200A
     D PSysValK5       S             20A
     D PCurSet5        S            200A
     D PSysValK6       S             20A
     D PCurSet6        S            200A
     D PSysValK7       S             20A
     D PCurSet7        S            200A
     D PSysValK8       S             20A
     D PCurSet8        S            200A
     D PSysValK9       S             20A
     D PCurSet9        S            200A
     D PSysValK10      S             20A
     D PCurSet10       S            200A
      *
      ** This string is passed to the Message Queue
      *
     D WRenbod       E DS                  EXTNAME(REBNODPD) PREFIX(MQ)
      *
      ** Parameters for ZAMSGTOFO
      *
     D PRetCode        S             10A
     D***PMQueue         S             48A                                      BUG26497
     D***PMQString       S           1102A                                      BUG26497
     D PMQueue         S             20A                                        BUG26497
     D***PMQString       S           6000A                                         BUG26497 MD025559
     D PMQString       S          12000A                                                    MD025559
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
     C                   IF        FNAME = 'RSACMTPD'
     C                   IF        TEVEN = '1' OR TEVEN = '3'
     C                   EVAL      RSAC = %SUBST(PARM1:NEWOFF+1:NEWLEN)
     C                   ELSEIF    TEVEN = '2'
     C                   EVAL      RSAC = %SUBST(PARM1:OLDOFF+1:OLDLEN)
     C                   ENDIF
     C                   EVAL      *IN70 = *OFF
     C                   ENDIF
      *
      ** Access Account Master File to retrieve Retail Number if used
      *
     C                   IF        BMRANR = 'Y'
      *
     C                   EVALR     PBrch = RSBRCA
     C                   EVALR     PCurr = RSCCYD
     C**********         EVALR     PCusn = %CHAR(CUSN)                                        CER059
     C                   EVALR     PCusn = CUSN                                               CER059
     C                   EVALR     PCode = %CHAR(ACDE)
     C                   EVALR     PSequ = %CHAR(ASNC)
     C                   EXSR      SRRtvrn
      *
     C                   ELSE
     C                   EVAL      *INLR = *ON
      *
     C                   ENDIF
      *
      ** Execute only if account is Retail
      *
     C                   IF        ATYP = 'R'
     C                   EXSR      SRGlshm
     C                   ENDIF
      *
      ** Exit from program
      *
     C                   EVAL      *INLR = *ON
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGlshm - Subroutine to extract Shadow postings              *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRGlshm       BEGSR
      *
      ** Check value date
      *
     C                   IF        (RSPTDT >= BJRDNB) AND
     C                             (RSPTDT < BJDNWD) AND
     C                             (TRYP <> 'BN')
      *
      ** Unique key
      *
     C     *DTAARA       DEFINE                  REUNIQKY
     C                   IN        REUNIQKY
      *
     C                   EVAL      REUNIQKY = REUNIQKY + 1
     C                   IF        REUNIQKY = 0
     C                   EVAL      REUNIQKY = REUNIQKY + 1
     C                   ENDIF
     C                   EVAL      WNumkey = REUNIQKY
     C                   EVAL      KNumkey = *BLANKS
     C                   MOVE      REUNIQKY      KNumkey
      *
     C     KNumkey       SETLL     REBNODL0
     C     KNumkey       READE     REBNODL0
      *
     C                   DOW       NOT %EOF(REBNODL0)
     C                   EVAL      WNumkey = WNumkey + 1
     C                   IF        WNumkey = 0
     C                   EVAL      WNumkey = WNumkey + 1
     C                   ENDIF
     C                   EVAL      KNumkey = *BLANKS
     C                   MOVE      WNumkey       KNumkey
      *
     C     KNumkey       READE     REBNODL0
     C                   ENDDO
      *
     C                   EVAL      NUMKEY = *BLANKS
     C                   EVAL      NUMKEY = KNumkey
     C     *LOCK         IN        REUNIQKY
     C                   EVAL      REUNIQKY = *ZEROS
     C                   MOVE      KNumkey       REUNIQKY
     C                   OUT       REUNIQKY
      *
      ** Branch code
      *
     C                   EVAL      BRCA = RSBRCA
      *
      ** RE account number
      *
     C                   EVAL      ACNO = AACNO
      *
      ** Posting date
      *
     C                   CALL      'ZM0065'
     C                   PARM                    RSPTDT
     C                   PARM                    PDate6
     C                   PARM                    PDate8
     C                   EVAL      PTDT = *ZEROS
     C                   MOVE      PDate8        PTDT
      *
      ** Value date
      *
     C                   CALL      'ZM0065'
     C                   PARM                    RSVUDT
     C                   PARM                    PDate6
     C                   PARM                    PDate8
     C                   EVAL      VUDT = *ZEROS
     C                   MOVE      PDate8        VUDT
      *
      ** Swift ccy
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      RSCCYD        PKey
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 15
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      CCYD = A6SWCY
      *
      ** Amount
      *
     C                   IF        A6NBDP = 0
     C                   EVAL      MVAM = RSMVAM
     C                   ENDIF
      *
     C                   IF        A6NBDP = 1
     C                   EVAL(H)   MVAM = RSMVAM/10
     C                   ENDIF
      *
     C                   IF        A6NBDP = 2
     C                   EVAL(H)   MVAM = RSMVAM/100
     C                   ENDIF
      *
     C                   IF        A6NBDP = 3
     C                   EVAL(H)   MVAM = RSMVAM/1000
     C                   ENDIF
      *
      ** DR/CR
      *
     C                   IF        TEVEN = '2'
     C                   IF        RSDORC = 0
     C                   EVAL      RSDORC = 1
     C                   ELSE
     C                   EVAL      RSDORC = 0
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        RSDORC = 0
     C                   EVAL      DORC = 'D'
     C                   ELSE
     C                   EVAL      DORC = 'C'
     C                   ENDIF
      *
      ** Narrative
      *
     C                   EVAL      NRTD = *BLANKS
     C                   IF        (NRTC = *BLANKS) OR
     C                             (NRTC = '00')
      *
      ** Set-up narrative based on the transaction number and type if
      ** the posting is DL, LE or SE.
      *
     C                   EVAL      WTryp = *BLANKS
     C                   EVAL      WTryp = TRYP
      *
      ** Dealing:
      *
     C                   IF        TRYP = 'FS' OR
     C                             TRYP = 'FP' OR
     C                             TRYP = 'CX' OR
     C                             TRYP = 'OP' AND
     C                             FUND = *BLANKS OR
     C                             TRYP = 'OT' OR
     C                             TRYP = 'SW' OR
     C                             TRYP = 'SI' OR
     C                             TRYP = 'PI' OR
     C                             TRYP = 'IT' OR
     C                             TRYP = 'IP' OR
     C                             TRYP = 'TD' OR
     C                             TRYP = 'TI' OR
     C                             TRYP = 'CI' OR
     C                             TRYP = 'CD' OR
     C                             TRYP = 'CL' OR
     C                             TRYP = 'DL' OR
     C                             TRYP = 'FL' OR
     C                             TRYP = 'FT' OR
     C                             TRYP = 'DT' OR
     C                             TRYP = 'LT' OR
     C                             TRYP = 'DP' OR
     C                             TRYP = 'LP' OR
     C                             TRYP = 'C1' OR
     C                             TRYP = 'C2' OR
     C                             TRYP = 'BP' OR
     C                             TRYP = 'BD' OR
     C                             TRYP = 'TB' OR
     C                             TRYP = 'DA' OR
     C                             TRYP = 'TA' OR
     C                             TRYP = 'CS' OR
     C                             TRYP = 'BS' OR
     C                             TRYP = 'BR' OR
     C                             TRYP = 'TS' OR
     C                             TRYP = 'RA' OR
     C                             TRYP = 'TR' OR
     C                             TRYP = 'PI' OR
     C                             TRYP = 'PD' OR
     C                             TRYP = 'SC' OR
     C                             TRYP = 'SI' OR
     C                             TRYP = 'CI' OR
      *
      ** Securities Trading:
      *
     C                             TRYP = 'TS' OR
     C                             TRYP = 'TP' OR
     C                             TRYP = 'WI' OR
     C                             TRYP = 'WO' OR
      *
     C                             TRYP = 'LN' OR
     C                             TRYP = 'PS' OR
      *
      ** Customer Lending:
      *
     C                             TRYP = 'F1' OR
     C                             TRYP = 'F2' OR
     C                             WTryp = 'H' OR
     C                             WTryp = 'J' OR
     C                             WTryp = 'K'
      *
     C                   IF        TNMR <> *BLANKS
     C                   EVAL      DSPNAR = *BLANKS
     C                   EVALR     DSTRYP = TRYP
     C                   EVALR     DSTNMR = TNMR
     C                   EVALR     NRTD = DSPNAR
     C                   ELSE
     C                   EVAL      NRTD = RSNRTD
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   EVAL      NRTD = RSNRTD
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   CALL      'AONARRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY    '    POptn
     C                   PARM                    NRTC
     C     SDNARR        PARM      SDNARR        DSSDY
      *
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      NRTD = ALDON
     C                   ELSE
     C                   EVAL      NRTD = RSNRTD
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Batch number and item
      *
     C                   IF        TRYP = 'ME' OR
     C                             TRYP = 'BN'
     C                   EVAL      TBID = TNMR
     C                   EVALR     BINB = TNMR
     C                   ELSE
     C                   EVAL      TBID = *BLANKS
     C                   EVAL      BINB = *BLANKS
     C                   ENDIF
      *
     C                   SELECT
      *
     C                   WHEN      PCurset1 = 'F'
     C                   WRITE     REBNODD0
      *
     C                   WHEN      PCurset1 = 'M'
     C                   EXSR      SRSndMQ
      *
     C                   WHEN      PCurset1 = 'B'
     C                   WRITE     REBNODD0
     C                   EXSR      SRSndMQ
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvrn - Subroutine to retrieve Account Retail Number       *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRRtvrn       BEGSR
      *
      ** Retrieve Retail Number
      *
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PAcno
     C                   PARM                    PCusn
     C                   PARM                    PCurr
     C                   PARM                    PCode
     C                   PARM                    PSequ
     C                   PARM                    PBrch
     C     ACCNT         PARM      ACCNT         DSSDY
      *
      ** If no record found in ACCNTAB, handle Database Error
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = PSProcPgm
     C                   EVAL      DBASE = 13
     C                   EVAL      DBKEY = '*FIRST '
     C                   EVAL      DBFILE = 'ACCNTAB'
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndMQ - Send Message to the Messgae Queue                  *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: SRGlshm                                               *
      *                                                               *
      *****************************************************************
      *
     C     SRSndMQ       BEGSR
      *
     C                   EVAL      MQBRCA = BRCA
     C                   EVAL      MQACNO = ACNO
     C                   EVAL      MQPTDT = PTDT
     C                   EVAL      MQVUDT = VUDT
     C                   EVAL      MQCCYD = CCYD
     C                   EVAL      MQMVAM = MVAM
     C                   EVAL      MQDORC = DORC
     C                   EVAL      MQNRTD = NRTD
     C                   EVAL      MQTBID = TBID
     C                   EVAL      MQBINB = BINB
     C                   EVAL      MQNUMKEY = NUMKEY
      *
     C**********         MOVEL     WRENBOD       PMQString                                  BUG26497
     C                   EVAL      PMQString = WRENBOD                                      BUG26497
     C                   EVAL      PMQueue   = PCurSet2                                     BUG26497
      *
     C**********         CALLB     'ZAMSGTOFO'                                              BUG21528
     C                   CALLB     'ZA000001'                                               BUG21528
     C                   PARM                    PRetCode
     C**********         PARM      PCurSet2      PMQueue                                    BUG26497
     C                   PARM                    PMQueue                                    BUG26497
     C                   PARM                    PMQString
      *
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = PSProcPgm
     C                   EVAL      DBASE = 17
     C                   EVAL      DBKEY = PCurSet2
     C**********         EVAL      DBFILE = 'ZAMSGTOFO'                                     BUG21528
     C                   EVAL      DBFILE = 'ZA000001'                                      BUG21528
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initialization Subroutine                           *
      *                                                               *
      *  Called by: Automatically as the program starts               *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** List of parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    PARM1
     C                   PARM                    PARM2
      *
      ** Define the LDA for error handling
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Define the Data Area for Run Date
      *
     C     *DTAARA       DEFINE                  RUNDAT
      *
      ** Retrieve Run Date Number
      *
     C                   IN        RUNDAT
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 14
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check if Retail Number required or not
      *
     C                   CALL      'AORETLR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDRETL        PARM      SDRETL        DSFDY
      *
      ** If no record found in SDRETLPD, handle Database Error
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = PSProcPgm
     C                   EVAL      DBASE = 01
     C                   EVAL      DBKEY = '*FIRST '
     C                   EVAL      DBFILE = 'SDRETLPD'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Midas SD Modules to check if UDC is installed
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** If Midas SD Modules ICD does not exist, handle Database Error
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = PSProcPgm
     C                   EVAL      DBASE = 02
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Call to AOSVALR0 to verify GFExtract
      *
     C                   CALL      'AOSVALR0'
     C                   PARM                    PRtcd
     C                   PARM      WSysVal1      PSysValK1
     C                   PARM      *Blanks       PCurset1
     C                   PARM      WSysVal2      PSysValK2
     C                   PARM      *Blanks       PCurset2
     C                   PARM      *Blanks       PSysValK3
     C                   PARM      *Blanks       PCurset3
     C                   PARM      *Blanks       PSysValK4
     C                   PARM      *Blanks       PCurset4
     C                   PARM      *Blanks       PSysValK5
     C                   PARM      *Blanks       PCurset5
     C                   PARM      *Blanks       PSysValK6
     C                   PARM      *Blanks       PCurset6
     C                   PARM      *Blanks       PSysValK7
     C                   PARM      *Blanks       PCurset7
     C                   PARM      *Blanks       PSysValK8
     C                   PARM      *Blanks       PCurset8
     C                   PARM      *Blanks       PSysValK9
     C                   PARM      *Blanks       PCurset9
     C                   PARM      *Blanks       PSysValK10
     C                   PARM      *Blanks       PCurset10
      *
     C                   IF        PRtcd <> *Blanks and
     C                             PRtcd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = PSProcPgm
     C                   EVAL      DBASE = 16
     C                   EVAL      DBKEY = WSysVal1
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program, and performs     *
      *           a ROLLBACK.                                         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
      *
     C     *LOCK         IN        LDA
      *
      ** If subroutine is automatically called
      *
     C                   IF        DBFILE = *BLANKS
     C                   EVAL      DBPGM = PSProcPgm
     C                   EVAL      DBKEY = '*FILE'
     C                   EVAL      DBFILE = PSLastFile
     C                   END
     C                   OUT       LDA
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
      *
      ** Force abnormal end, external indicators (U7 and U8) are
      ** not copied back into storage
      *
     C                   ENDSR     '*CANCL'
      *****************************************************************
      /EJECT
      *****************************************************************
