     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Account Postings for Stopped Cheques')
      *****************************************************************
      *                                                               *
      *  Midas - Retail module                                        *
      *                                                               *
      *  RE004211 - Account Postings for Stopped Cheques              *
      *                                                               *
      *  Function:  This module will check whether any of the postings*
      *             processed for an account hold a reference to a    *
      *             stopped cheque.  If so, the posting will instead  *
      *             be applied to the computer suspense account for   *
      *             the same branch internal customer and computer    *
      *             suspense account code with account sequence 01.   *
      *             The associate customer will refer to the original *
      *             customer on posting.                              *
      *                                                               *
      *             At the same time, details of the posting,         *
      *             including the original account reference, posting *
      *             amount, posting narrative and cheque number will  *
      *             be printed.                                       *
      *                                                               *
      *  Component of: RE004211                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL014             Date 20Oct03               *
      *                 CRE019  *CREATE    Date 12Jan04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CRE019 - Cheque Processing and Maintenance                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         EOF SACPO                                       *
      *    37         MBIN is on                                      *
      *    LR         End Pgm                                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrInit   -                                                   *
      *  SrProcDet-                                                   *
      *  SrAudit  -                                                   *
      *  *PSSR    - Error processing                                  *
      *  *INZSR   - Initialise                                        *
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
 
     FSACPO     UF   F  620    18AIDISK    INFSR(*PSSR)
      ** Midas GL Accounts postings - post 6
 
     FRE004211P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
      ** PRT: Printer file for Stopped Cheques Accounting Exception Report
 
     FRE004211AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
      ** AUD: Printer file for Stopped Cheques Accounting Audit
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Today's Date
     D RUNDAT          DS
     D  MBIN                  13     13
 
      ** Account Reference DS
     D AccntRef        DS
     D  WBranch                1      3
     D  WSlash1                4      4    INZ('-')
     D  WCustomer              5     10
     D  WSlash2               11     11    INZ('-')
     D  WCurrency             12     14
     D  WSlash3               15     15    INZ('-')
     D  WAccntCode            16     25
     D  WSlash4               26     26    INZ('-')
     D  WAccntSeq             27     28
 
      ** File Information Data Structure for RE004211P1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0
 
      **  File Information Data Structure for RE004211AU.
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External data structure for bank details
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External data structure for general ledger details
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** External data structure for branch details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structure for currency details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  First DS for access programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Second DS for access programs, long data structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry parameter
     D PMode           S              1
 
      ** Parameters for Access Object
     D PRtcd           S              7
     D POptn           S              7
     D PBrca           S              3
 
      ** Parameters for ZSFILE
     D PSeqs           S              5
     D PSEnty          S              3
     D PZSNum          S              6  0
     D PZSNumU         S              6  0
     D PZSErr          S              1
 
      ** Parameters for AOSTOPV0
     D PChqAm          S             13  0
     D PChqNo          S              8
     D PRetAc          S             10  0
     D PCNum           S              6
     D PCcy            S              3
     D PACod           S             10
     D PASeq           S              2
     D PBrcd           S              3
 
      ** Parameters for ZSEDIT
     D PFld15          S             15  0
     D PDecs           S              1  0
     D PEcode          S              1
     D POut21          S             21
 
      ** Parameters for ZEDIT/ZALIGN
     D PzField         S             16A
     D PzADec          S              1P 0
 
     D RqdLn1          S              3P 0
     D DifLn1          S              4P 0
 
     D WRecRead        S              5  0
     D WRecUpdt        S              5  0
 
     D WTotPSTA        S             17  0
 
     D P1Open          S              1
     D WUpdFlg         S              1
 
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ I-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     ISACPO     NS  01    1 CP
     I**********                        2    7 0CNUM                                          CSD027
     I                                  2    7  CNUM                                          CSD027
     I                                  8   10  CCY
     I                                 15   16 0ACSQ
     I                                 23   32 0ACNO
     I                                 44   73  PNAR
     I                             P   74   80 0PSTA
     I                                 81   81 0DRCR
     I**********                       82   87 0ASOC                                          CSD027
     I                                 82   87  ASOC                                          CSD027
     I                                 88   95 0CHQN
     I                                103  105  BRCA
     I                                590  599 0ACOD
 
     ISACPO     NS  02    1 CT
     I                                  1    1  RECI
     I                                  2    6 0NORE1
     I                             P    7   14 0HRWN
     I                             P   15   16 0HRDC
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Perform Initialisation.
 
     C                   EXSR      SrInit
 
      ** Perform Detail Processing.
 
     C                   EXSR      SrProcDet
 
      ** Output audit report and end program.
 
     C                   EXSR      SRAudit
 
      *****************************************************************
      *                                                               *
      *  SrInit - Initialise fields and indicators used in program    *
      *                                                               *
      *****************************************************************
 
     C     SrInit        BEGSR
 
      ** RCF Processing for Audit File.
 
     C                   EXSR      SRRcfAu
 
      ** Initialise work fields
 
     C                   EVAL      P1Open   = 'N'
     C                   EVAL      WRecRead = 0
     C                   EVAL      WRecUpdt = 0
     C                   EVAL      WTotPSTA = 0
     C                   EVAL      RqdLn1   = 0
     C                   EVAL      DifLn1   = 0
     C                   EVAL      WUpdFlg = 'N'
     C     *LIKE         DEFINE    ACOD          WSavACOD
     C     *LIKE         DEFINE    ACSQ          WSavACSQ
     C     *LIKE         DEFINE    BRCA          WSavBRCD
     C     *LIKE         DEFINE    CNUM          WSavCNUM
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SrProcDet - Read through all records in SACPO                *
      *                                                               *
      *****************************************************************
 
     C     SrProcDet     BEGSR
 
     C                   READ      SACPO                                  05
 
      ** No Records to Report
 
     C                   IF        %EOF(SACPO) or *IN02 = *ON
     C                   ELSE
 
      ** Do while not End of file
 
     C                   DOW       NOT %EOF(SACPO) and *IN02 = *OFF
 
     C                   EVAL      WRecRead = WRecRead + 1
 
      ** Get Branch details
 
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG   '     PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BRCA          PBrca
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
      ** Database Error
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBase  = 3
     C                   EVAL      DBFile = 'SDBRCHPD'
     C                   EVAL      DBKey  = PBrca
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Call to Access Program - AOSTOPV0 Verify Stoppped Cheque
      ** Access Account Details file for the file fields
 
     C                   Z-ADD     PSTA          PChqAm
     C                   MOVE      CHQN          PChqNo
     C                   Z-ADD     ACNO          PRetAc
     C                   MOVE      CNUM          PCNum
     C                   MOVE      CCY           PCcy
     C                   MOVE      ACOD          PACod
     C                   MOVE      ACSQ          PASeq
     C                   MOVE      BRCA          PBrcd
 
     C                   CALL      'AOSTOPV0'
     C                   PARM      *BLANKS       PRtCd                           7 B:Return Cd
     C                   PARM                    PChqAm                         130I:Cheque Amount
     C                   PARM                    PChqNo                          8 I:Cheque Number
     C                   PARM                    PRetAc                         100I:Retail Account
     C                   PARM                    PCNum                           6 I:Customer Number
     C                   PARM                    PCcy                            3 I:Currency Code
     C                   PARM                    PACod                           4 I:Account Code
     C                   PARM                    PASeq                           2 I:Acount Sequence
     C                   PARM                    PBrcd                           3 I:Branch Code
 
     C                   IF        PRtCd = '*STOP  '
     C                   EVAL      WSavCNUM = CNUM
     C                   EVAL      WSavACOD = ACOD
     C                   EVAL      WSavACSQ = ACSQ
 
     C                   MOVE      A8BICN        CNUM
     C                   MOVE      BKACCD        ACOD
     C                   EVAL      ACSQ = 01
     C                   EVAL      ASOC = WSavCNUM
 
     C                   EVAL      WRecUpdt = WRecUpdt + 1
     C                   EVAL      WUpdFlg = 'Y'
 
     C                   ENDIF
 
     C                   IF        WUpdFlg = 'Y'
     C                   IF        MBIN = 'Y'
     C                   IF        WSavBRCD <> BRCA
 
     C                   EVAL      WSavBRCD = BRCA
 
     C                   IF        WRecUpdt > 1
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   WRITE     TRAILP1
 
     C                   CLOSE     RE004211P1
     C                   EVAL      P1Open   = 'N'
 
     C                   ENDIF
 
     C                   EXSR      SrRcfP1
 
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Multibranching is off
 
     C                   ELSE
 
      ** This should be run only once at the start
 
     C                   IF        WRecUpdt = 1
     C                   EXSR      SrRcfP1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EXCEPT
 
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   EXSR      SRPrint
     C                   EVAL      WTotPSTA = WTotPSTA + PSTA
     C                   EVAL      WUpdFlg = 'N'
 
     C                   ENDIF
 
     C                   READ      SACPO                                  05
 
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
 
      *****************************************************************
      *                                                               *
      *  SRPrint - Print details to printer file                      *
      *                                                               *
      *****************************************************************
 
     C     SRPrint       BEGSR
 
      ** Format Original Account reference
 
     C                   EVAL      WBranch    = BRCA
     C                   MOVE      WSavCNUM      WCustomer
     C                   EVAL      WCurrency  = CCY
     C                   MOVE      WSavACOD      WAccntCode
     C                   MOVE      WSavACSQ      WAccntSeq
 
     C                   EVAL      ROACRF     = AccntRef
 
      ** Format New Account reference
 
     C                   EVAL      WBranch    = BRCA
     C                   MOVE      CNUM          WCustomer
     C                   EVAL      WCurrency  = CCY
     C                   MOVE      ACOD          WAccntCode
     C                   MOVE      ACSQ          WAccntSeq
 
     C                   EVAL      RNACRF     = AccntRef
 
      ** Format Cheque Number
 
     C                   MOVE      CHQN          RCHQUE
 
      ** Format Posting Amount
 
     C                   EVAL      PCcy = CCY
     C                   EXSR      SRCurrency
 
     C                   MOVE      PSTA          PFld15
     C                   Z-ADD     A6NBDP        PDecs
     C                   EVAL      PECode = 'J'
     C                   EXSR      SRCvtAmt
     C                   MOVE      POut21        RPAMNT
 
      ** Format Debit/Credit indicator
 
     C                   IF        DRCR = 0
     C                   EVAL      RDRCR  = 'D'
     C                   ELSE
     C                   EVAL      RDRCR  = 'C'
     C                   ENDIF
 
      ** Format Narrative
 
     C                   EVAL      RNARR  = PNAR
 
     C                   WRITE     DETAIL1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRcfP1 - Subroutine to register the P1 Printer File via RCF *
      *                                                               *
      *****************************************************************
     C     SrRcfP1       BEGSR
 
     C                   OPEN      RE004211P1
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      PZSnum = PSFNum1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeqs
     C                   PARM      BRCA          PSEnty
     C                   PARM                    PSFile1
     C                   PARM                    PZSNum
     C                   PARM      *BLANKS       PZSErr
 
     C                   IF        PZSErr = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   EVAL      P1Open = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRcfAU - Subroutine to register the AU Printer File via RCF *
      *                                                               *
      *****************************************************************
     C     SrRcfAU       BEGSR
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   EVAL      PZSnumU = PSFNumU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeqs
     C                   PARM      BRCA          PSEnty
     C                   PARM                    PSFileU
     C                   PARM                    PZSNumU
     C                   PARM      *BLANKS       PZSErr
 
     C                   IF        PZSErr = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Subroutine to Output audit details                 *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
      ** If P1 is open then close it
 
     C                   IF        P1Open   = 'Y'
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   WRITE     TRAILP1
 
     C                   CLOSE     RE004211P1
     C                   EVAL      P1Open   = 'N'
     C                   ENDIF
 
      ** Output Report Header and File Controls.
 
     C                   WRITE     HEADAU
 
      ** If there is a DB Error, Output the DB Error Information.
 
     C                   IF        *INU7 = True
     C                   WRITE     DBERROR
     C                   ELSE
 
     C                   MOVE      *BLANKS       PzField
     C                   MOVE      WRecRead      PzField
     C                   EVAL      PzADec = 0
     C                   EXSR      SRZEdit
     C                   MOVE      PzField       RCNT1
 
     C                   MOVE      *BLANKS       PzField
     C                   MOVE      WRecUpdt      PzField
     C                   EVAL      PzADec = 0
     C                   EXSR      SRZEdit
     C                   MOVE      PzField       RCNT2
 
     C                   MOVE      *BLANKS       PzField
     C                   MOVE      WTotPSTA      PzField
     C                   EVAL      PzADec = 0
     C                   EXSR      SRZEdit
     C                   MOVE      PzField       RCNT3
 
     C                   WRITE     CONTROL
 
     C                   ENDIF
 
      ** End Program and Return.
 
     C                   EVAL      *INLR = True
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
 
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCvtAmt - Convert Amount before printing                    *
      *                                                               *
      *****************************************************************
     C     SRCvtAmt      BEGSR
 
     C                   CALL      'ZSEDIT'
     C                   PARM                    PFld15
     C                   PARM                    PDecs
     C                   PARM                    PEcode
     C                   PARM      *BLANKS       POut21
 
     C                   ENDSR
      *****************************************************************
 
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZEdit    - Format Numeric Fields                           *
      *                                                               *
      *****************************************************************
 
     C     SRZEdit       BEGSR
 
     C                   CALL      'ZEDIT'
     C                   PARM                    PzField
     C                   PARM                    PzADec
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCurrency - Access currency details                         *
      *                                                               *
      *****************************************************************
     C     SrCurrency    BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database Error
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBase  = 4
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBKey = PCcy
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
 
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PMode
 
     C                   IF        PMode = '2'
     C                   EVAL      *IN21 = *ON
     C                   ELSE
     C                   EVAL      *IN21 = *OFF
     C                   ENDIF
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'RE004211'
 
      **  Access Bank Details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*BLANK '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** If error on access to bank details.
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **  Access General Ledger details
 
     C                   CALL      'AOGELRR0'
     C                   PARM      '*BLANK '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDGELR        PARM      SDGELR        DSFDY
 
      ** If error on access to general ledger details
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
      ** Check multibranch function
 
     C     MBIN          IFEQ      'Y'
     C                   EVAL      *IN37 = *ON
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
      ** Check to see that *PSSR has not already been called.
 
     C                   IF        RunBefore = *BLANK
     C                   EVAL      RunBefore = 'Y'
     C                   EVAL      *INU7 = True
     C                   EVAL      *INU8 = True
     C                   EVAL      *INLR = True
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF
 
      ** If *PSSR already run, then just end the program here.
 
     C                   EVAL      *INU7 = True
     C                   EVAL      *INU8 = True
     C                   EVAL      *INLR = True
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
 
     OSACPO     E
     O                       CNUM                 7
     O                       ACSQ                16
     O                       ASOC                87
     O                       ACOD               599
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
