     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Security details supp log setup module')      *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECSLOG - Security Details Support Log Setup Module        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 26May05               *
      *                 CGL014             Date 20Oct03               *
      *                 CAS006             Date 21Jan03               *
      *                 CSE037             Date 29Apr02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE074 - Const. Yield Amort. on Mortgage backed assets       *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  CGL014 - Collaterals Processing                              *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CSE037 - Countervalue rounding - recompile only              *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * SRPROC - Detail Processing                                    *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Securities Detail File
     D SECSFilFmt    E DS                  EXTNAME(SECTYD)
 
      ** SECS API screen 1 format definition
     D SEC1ScnFmt    E DS                  EXTNAME(SESEC1PD)
 
      ** SECS API screen 2 format definition
     D SEC2ScnFmt    E DS                  EXTNAME(SESEC2PD)
 
      ** SECS API screen 3 format definition
     D SEC3ScnFmt    E DS                  EXTNAME(SESEC3PD)
                                                                                              CAS006
      ** SECS API screen 4 format definition                                                  CAS006
     D SEC4ScnFmt    E DS                  EXTNAME(SESEC4PD)                                  CAS006
                                                                                              CAS006
      ** SECS API screen 5 format definition                                                  CAS006
     D SEC5ScnFmt    E DS                  EXTNAME(SESEC5PD)                                  CAS006
                                                                                              CSE071
      ** SECS API screen 6 format definition                                                  CSE071
     D SEC6ScnFmt    E DS                  EXTNAME(SESEC6PD)                                  CSE071
 
      ** Securities extra data layout
     D SECSExtDta    E DS                  EXTNAME(SESEEXPD)
 
      ** Securities Investment Type
     D INVSTPD       E DS                  EXTNAME(INVTPD)
     D                                     PREFIX(I)
 
      ** Bank Details ICD file
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Midas Modules
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Switchable features file
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  SCLCD        E                     EXTFLD(LCD)
 
      ** Dummy Data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D TRANSDTL        S           5800A
 
      ** Entry Parameters for SESECSCVT
     D POthInf         S            156A
     D POldSec         S             10A
     D PParmLink       S              1A
     D CEU018          S              1A
     D CSE005          S              1A
     D S01401          S              1A
     D CSE023          S              1A
     D CSD006          S              1A
     D CAP060          S              1A
     D CSE031          S              1A                                                      CAS006
     D CAS006          S              1A                                                      CAS006
     D CSE037          S              1A                                                      CSE037
     D CGL014          S              1A                                                      CGL014
     D CSE071          S              1A                                                      CSE071
     D CGL031          S              1A                                                      CGL031
     D PLCPN           S              6A
     D PNCD            S              6A
 
     D PRetCode        S              7A
     D PCcyI           S              3A
     D PInvt           S              3A
     D PKey            S              6A
     D POption         S              7A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   EXSR      SRPROC
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Detail Processing                                   *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     AOINVTR0, SESECSCVT                               *
      *                                                               *
      *****************************************************************
 
     C     SRPROC        BEGSR
 
      ** Initialise Transaction Detail Record
 
     C                   EVAL      TRANSDTL = *Blanks
 
      ** Access Investment Type Detials
 
     C                   CALL      'AOINVTR0'
     C                   PARM      *Blanks       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      SITP          PInvt
     C                   PARM      NMCY          PCcyI
     C     INVSTPD       PARM      INVSTPD       DSFDY
 
     C                   IF        PRetCode <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'INVTPD'
     C                   EVAL      DBKEY  = PCcyI + ' ' + PInvt
     C                   EVAL      DBASE  = 909
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CALLB     'SESECSCVT'
     C                   PARM                    ReturnCode
     C                   PARM                    SECSFilFmt
     C                   PARM                    IPROT
     C                   PARM                    CHTP
     C                   PARM                    POthInf
     C                   PARM      *Blanks       POldSec
     C                   PARM                    BJDFIN
     C                   PARM                    BJRDNB
     C                   PARM                    BGRKMG
     C                   PARM                    BGN2ST
     C                   PARM                    BGN4ST
     C                   PARM                    CEU018
     C                   PARM                    CSE005
     C                   PARM                    S01401
     C                   PARM                    CSE023
     C                   PARM                    CSD006
     C                   PARM                    CAP060
     C                   PARM                    CSE031                                       CAS006
     C                   PARM                    CAS006                                       CAS006
     C                   PARM                    CSE037                                       CSE037
     C                   PARM                    CGL014                                       CGL014
     C                   PARM                    CSE071                                       CSE071
     C                   PARM                    SEC1ScnFmt
     C                   PARM                    SEC2ScnFmt
     C                   PARM                    SEC3ScnFmt
     C                   PARM                    SEC4ScnFmt                                   CAS006
     C                   PARM                    SEC5ScnFmt                                   CAS006
     C                   PARM                    SEC6ScnFmt                                   CSE071
     C                   PARM      *Blanks       PLCPN
     C                   PARM      *Blanks       PNCD
     C                   PARM                    PParmLink
 
     C                   IF        ReturnCode = *Blanks
     C                   EVAL      TRANSDTL = SEC1ScnFmt + SEC2ScnFmt +
     C**********                              SEC3SCNFMT + SECSExtDta                         CAS006
     C                                        SEC3ScnFmt + SEC4ScnFmt +                       CAS006
     C**********                              SEC5ScnFmt + SECSExtDta                   CAS006CSE071
     C                                        SEC5ScnFmt + SEC6ScnFmt +                       CSE071
     C                                        SECSExtDta                                      CSE071
     C                   ELSE
     C                   EVAL      RetCodeIn = '*ERROR'
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
 
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Securities Detail File Format
 
     C                   PARM                    SECSFilFmt
 
      ** Transaction Detail - Screen Format
 
     C                   PARM                    TRANSDTL
 
      ** The following /COPY sets the program, module and procedure
      ** names for database error processing.
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRetCode <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = '*KEY'
     C                   EVAL      DBASE  = 901
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Midas Module
 
     C                   CALL      'AOMMODR0'
     C                   PARM      *Blanks       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
     C                   IF        PRetCode <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBKEY  = '*KEY'
     C                   EVAL      DBASE  = 902
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if CEU018 is installed
 
     C                   EVAL      CEU018 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CEU018'      PKey
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRetCode = *Blanks
     C                   EVAL      CEU018 = 'Y'
     C                   ELSE
     C                   IF        PRetCode <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDR0'
     C                   EVAL      DBKEY  = 'CEU018'
     C                   EVAL      DBASE  = 903
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** Check if CSE005 is installed
 
     C                   EVAL      CSE005 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CSE005'      PKey
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRetCode = *Blanks
     C                   EVAL      CSE005 = 'Y'
     C                   ELSE
     C                   IF        PRetCode <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDR0'
     C                   EVAL      DBKEY  = 'CSE005'
     C                   EVAL      DBASE  = 904
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** Check if S01401 is installed
 
     C                   EVAL      S01401 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'S01401'      PKey
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRetCode = *Blanks
     C                   EVAL      S01401 = 'Y'
     C                   ELSE
     C                   IF        PRetCode <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDR0'
     C                   EVAL      DBKEY  = 'S01401'
     C                   EVAL      DBASE  = 905
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** Check if CSE023 is installed
 
     C                   EVAL      CSE023 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CSE023'      PKey
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRetCode = *Blanks
     C                   EVAL      CSE023 = 'Y'
     C                   ELSE
     C                   IF        PRetCode <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDR0'
     C                   EVAL      DBKEY  = 'CSE023'
     C                   EVAL      DBASE  = 906
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** Check if CAP060 is installed
 
     C                   EVAL      CAP060 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CAP060'      PKey
     C     SCSARD        PARM      SCSARD        DSFDY
     C
     C                   IF        PRetCode = *Blanks
     C                   EVAL      CAP060 = 'Y'
     C                   ELSE
     C                   IF        PRetCode <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDR0'
     C                   EVAL      DBKEY  = 'CAP060'
     C                   EVAL      DBASE  = 907
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** Check if CSD006 is installed
 
     C                   EVAL      CSD006 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CSD006'      PKey
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRetCode = *Blanks
     C                   EVAL      CSD006 = 'Y'
     C                   ELSE
     C                   IF        PRetCode <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDR0'
     C                   EVAL      DBKEY  = 'CSD006'
     C                   EVAL      DBASE  = 908
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** Check if CSE031 is enabled.                                                          CAS006
                                                                                              CAS006
     C                   CALLB     'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRetCode                                     CAS006
     C                   PARM      '*VERIFY'     POption                                      CAS006
     C                   PARM      'CSE031'      PKey                                         CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
     C                   EVAL      CSE031 = 'N'                                               CAS006
     C                   IF        PRetCode = *Blanks                                         CAS006
     C                   EVAL      CSE031 = 'Y'                                               CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
     C                   IF        PRetCode <> '*NRF'                                         CAS006
     C     *LOCK         IN        LDA                                                        CAS006
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAS006
     C                   EVAL      DBKey  = 'CSE031'                                          CAS006
     C                   EVAL      DBase  = 910                                               CAS006
     C                   OUT       LDA                                                        CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Check if CAS006 is enabled.                                                          CAS006
                                                                                              CAS006
     C                   CALLB     'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRetCode                                     CAS006
     C                   PARM      '*VERIFY'     POption                                      CAS006
     C                   PARM      'CAS006'      PKey                                         CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
     C                   EVAL      CAS006 = 'N'                                               CAS006
     C                   IF        PRetCode = *Blanks                                         CAS006
     C                   EVAL      CAS006 = 'Y'                                               CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
     C                   IF        PRetCode <> '*NRF'                                         CAS006
     C     *LOCK         IN        LDA                                                        CAS006
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAS006
     C                   EVAL      DBKey  = 'CAS006'                                          CAS006
     C                   EVAL      DBase  = 911                                               CAS006
     C                   OUT       LDA                                                        CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
      ** Check if enhancement CGL014 (Collaterals Processing) is on                           CGL014
                                                                                              CGL014
     C                   CALLB     'AOSARDR0'                                                 CGL014
     C                   PARM      *BLANKS       PRetCode                                     CGL014
     C                   PARM      '*VERIFY'     POption                                      CGL014
     C                   PARM      'CGL014'      PKey                                         CGL014
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL014
                                                                                              CGL014
     C                   IF        PRetCode <> *BLANKS  AND                                   CGL014
     C                             PRetCode <> '*NRF   '                                      CGL014
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL014
     C                   EVAL      DBKEY  = 'CGL014'                                          CGL014
     C                   EVAL      DBASE  = 1                                                 CGL014
     C                   EXSR      *PSSR                                                      CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        PRetCode = *BLANKS                                         CGL014
     C                   EVAL      CGL014 = 'Y'                                               CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      CGL014 = 'N'                                               CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CAS006
      ** Check if enhancement CSE071 (Multiple Holidays) is on                                CSE071
                                                                                              CSE071
     C                   CALLB     'AOSARDR0'                                                 CSE071
     C                   PARM      *BLANKS       PRetCode                                     CSE071
     C                   PARM      '*VERIFY'     POption                                      CSE071
     C                   PARM      'CSE071'      PKey                                         CSE071
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE071
                                                                                              CSE071
     C                   IF        PRetCode = *BLANKS                                         CSE071
     C                   EVAL      CSE071 = 'Y'                                               CSE071
     C                   ELSE                                                                 CSE071
     C                   EVAL      CSE071 = 'N'                                               CSE071
     C                   ENDIF                                                                CSE071
                                                                                              CSE071
      ** Check if CGL031 is enabled.                                                          CGL031
                                                                                              CGL031
     C                   CALLB     'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRetCode                                     CGL031
     C                   PARM      '*VERIFY'     POption                                      CGL031
     C                   PARM      'CGL031'      PKey                                         CGL031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
                                                                                              CGL031
     C                   EVAL      CGL031 = 'N'                                               CGL031
     C                   IF        PRetCode = *Blanks                                         CGL031
     C                   EVAL      CGL031 = 'Y'                                               CGL031
     C                   ELSE                                                                 CGL031
                                                                                              CGL031
     C                   IF        PRetCode <> '*NRF'                                         CGL031
     C     *LOCK         IN        LDA                                                        CGL031
     C                   EVAL      DBFile = 'SCSARDPD'                                        CGL031
     C                   EVAL      DBKey  = 'CGL031'                                          CGL031
     C                   EVAL      DBase  = 912                                               CGL031
     C                   OUT       LDA                                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **-------------------------------------------------------------------+
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **-------------------------------------------------------------------+
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
