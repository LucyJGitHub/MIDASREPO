     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE COB Extract Shadow Postings from RSACMTPD')   *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE000193 - COB Extract Shadow Postings from RSACMTPD         *
      *                                                               *
      *  Function:  This program writes records of RSACMTPD processed *
      *             after COB to REBNODPD                             *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Note: Any change on this program should also be applied on   *
      *        RE000192.                                              *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26106 *CREATE   Date 18Sep09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26106 - UAT testing of German Features has shown an error *
      *             with missing records on the REBNODPD file         *
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
      *  SRProcess - Process Records                                  *
      *  SRGlshm - Subroutine to extract Shadow postings              *
      *  SRRtvrn - Retrieve account details                           *
      *  SRSndMQ - Send Message to the Messgae Queue                  *
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
      ** Midas Account movements File
      *
     FRSACMTPD  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(RS)
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
      **
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
      ** DS to split posting narrative
      *
     D DSPNAR          DS            30
     D  DSTRYP                 1      2
     D  DSTNMR                 6     11
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
     D PMQueue         S             48A
     D PMQString       S           1102A
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
     C                   READ      RSACMTPD
      *
     C                   DOW       NOT(%EOF)
      *
     C                   EXSR      SRProcess
      *
     C                   READ      RSACMTPD
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Process Records                                  *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: SRRtvrn                                               *
      *         SRGlshm                                               *
      *                                                               *
      *****************************************************************
     C     SRProcess     BEGSR
      *
      ** Access Account Master File to retrieve Retail Number if used
      *
     C                   IF        BMRANR = 'Y'
      *
     C                   EVALR     PBrch = RSBRCA
     C                   EVALR     PCurr = RSCCYD
     C**********         EVALR     PCusn = %CHAR(RSCUSN)                                      CER059
     C                   EVALR     PCusn = RSCUSN                                             CER059
     C                   EVALR     PCode = %CHAR(RSACDE)
     C                   EVALR     PSequ = %CHAR(RSASNC)
     C                   EXSR      SRRtvrn
      *
     C                   ELSE
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDIF
      *
      ** Execute only if account is Retail
      *
     C                   IF        ATYP = 'R'
     C                   EXSR      SRGlshm
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGlshm - Subroutine to extract Shadow postings              *
      *                                                               *
      *  Called by: SRProcess                                         *
      *                                                               *
      *  Calls: SRSndMQ                                               *
      *                                                               *
      *****************************************************************
      *
     C     SRGlshm       BEGSR
      *
      ** Check value date
      *
     C                   IF        (RSPTDT >= BJRDNB) AND
     C                             (RSPTDT < BJDNWD) AND
     C                             (RSTRYP <> 'BN')
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
     C                   IF        RSDORC = 0
     C                   EVAL      DORC = 'D'
     C                   ELSE
     C                   EVAL      DORC = 'C'
     C                   ENDIF
      *
      ** Narrative
      *
     C                   EVAL      NRTD = *BLANKS
     C                   IF        (RSNRTC = *BLANKS) OR
     C                             (RSNRTC = '00')
      *
      ** Set-up narrative based on the transaction number and type if
      ** the posting is DL, LE or SE.
      *
     C                   EVAL      WTryp = *BLANKS
     C                   EVAL      WTryp = RSTRYP
      *
      ** Dealing:
      *
     C                   IF        RSTRYP = 'FS' OR
     C                             RSTRYP = 'FP' OR
     C                             RSTRYP = 'CX' OR
     C                             RSTRYP = 'OP' AND
     C                             RSFUND = *BLANKS OR
     C                             RSTRYP = 'OT' OR
     C                             RSTRYP = 'SW' OR
     C                             RSTRYP = 'SI' OR
     C                             RSTRYP = 'PI' OR
     C                             RSTRYP = 'IT' OR
     C                             RSTRYP = 'IP' OR
     C                             RSTRYP = 'TD' OR
     C                             RSTRYP = 'TI' OR
     C                             RSTRYP = 'CI' OR
     C                             RSTRYP = 'CD' OR
     C                             RSTRYP = 'CL' OR
     C                             RSTRYP = 'DL' OR
     C                             RSTRYP = 'FL' OR
     C                             RSTRYP = 'FT' OR
     C                             RSTRYP = 'DT' OR
     C                             RSTRYP = 'LT' OR
     C                             RSTRYP = 'DP' OR
     C                             RSTRYP = 'LP' OR
     C                             RSTRYP = 'C1' OR
     C                             RSTRYP = 'C2' OR
     C                             RSTRYP = 'BP' OR
     C                             RSTRYP = 'BD' OR
     C                             RSTRYP = 'TB' OR
     C                             RSTRYP = 'DA' OR
     C                             RSTRYP = 'TA' OR
     C                             RSTRYP = 'CS' OR
     C                             RSTRYP = 'BS' OR
     C                             RSTRYP = 'BR' OR
     C                             RSTRYP = 'TS' OR
     C                             RSTRYP = 'RA' OR
     C                             RSTRYP = 'TR' OR
     C                             RSTRYP = 'PI' OR
     C                             RSTRYP = 'PD' OR
     C                             RSTRYP = 'SC' OR
     C                             RSTRYP = 'SI' OR
     C                             RSTRYP = 'CI' OR
      *
      ** Securities Trading:
      *
     C                             RSTRYP = 'TS' OR
     C                             RSTRYP = 'TP' OR
     C                             RSTRYP = 'WI' OR
     C                             RSTRYP = 'WO' OR
      *
     C                             RSTRYP = 'LN' OR
     C                             RSTRYP = 'PS' OR
      *
      ** Customer Lending:
      *
     C                             RSTRYP = 'F1' OR
     C                             RSTRYP = 'F2' OR
     C                             WTryp = 'H' OR
     C                             WTryp = 'J' OR
     C                             WTryp = 'K'
      *
     C                   IF        RSTNMR <> *BLANKS
     C                   EVAL      DSPNAR = *BLANKS
     C                   EVALR     DSTRYP = RSTRYP
     C                   EVALR     DSTNMR = RSTNMR
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
     C                   PARM                    RSNRTC
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
     C                   IF        RSTRYP = 'ME' OR
     C                             RSTRYP = 'BN'
     C                   EVAL      TBID = RSTNMR
     C                   EVALR     BINB = RSTNMR
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
      *  Called by: SRProcess                                         *
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
      *  Called by: SRGlshm                                           *
      *                                                               *
      *  Calls: None                                                  *
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
     C                   MOVEL     WRENBOD       PMQString
      *
     C                   CALLB     'ZA000001'
     C                   PARM                    PRetCode
     C                   PARM      PCurSet2      PMQueue
     C                   PARM                    PMQString
      *
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = PSProcPgm
     C                   EVAL      DBASE = 17
     C                   EVAL      DBKEY = PCurSet2
     C                   EVAL      DBFILE = 'ZA000001'
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
