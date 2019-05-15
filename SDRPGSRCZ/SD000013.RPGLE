     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Watch List Bulk Data Checking module (LE)')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000013 - Watch List Bulk Data Checking Component for       *
      *             Lending                                           *
      *                                                               *
      *  Function:  This module will perform watch list checking  on  *
      *             lending files.                                    *
      *                                                               *
      *  Component of: SDC000013 (Watch List Bulk Data Checking       *
      *                Component for Lending)                         *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR702741           Date 02Feb11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CLE042             Date 06Sep05               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSD015   *CREATE   Date 14Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7+U8      Database Error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SrCloancl     - Process CLOANCL                               *
      * SrWtchCloancl - Send Details to Compliance Watch Engine for   *
      *                 Live Record Read on CLOANCL                   *
      * SrLefeed      - Process LEFEED                                *
      * SrWtchLefeed  - Send Details to Compliance Watch Engine for   *
      *                 Live Record Read on LEFEED                    *
      * SrLefeead     - Process LEFEEAD                               *
      * SrWtchLefeead - Send Details to Compliance Watch Engine for   *
      *                 Every Live Record Read on LEFEEAD             *
      * SrCloanck     - Process CLOANCK                               *
      * SRWtchCloanck - Send Details to Compliance Watch Engine for   *
      *                 Every Live Record Read on CLOANCK             *
      * SrLoamsdk     - Process LOAMSDK                               *
      * SrWtchLoamsdk - Send Details to Compliance Watch Engine  for  *
      *                 Every Live Record Read on LOAMSDK             *
      * SrFormat      - Convert Settlement Details to Customer Name   *
      *                 and Address                                   *
      * SrUpdWlcc     - Update Watch List Checking Details by         *
      *                 Function                                      *
      * SrCurrDet     - Retrieve Currency Details                     *
      * SrCustDet     - Retrieve Customer Details                     *
      * SrCvtDate     - Convert dates to be used for Watch Engine     *
      *                 Program                                       *
      * SrCvtAmt      - Convert amounts for Watch Engine Program      *
      * SrInitParm    - Initialize 1st and 2nd Parameters of Watch    *
      *                 List Engine                                   *
      * *PSSR         - Error processing                              *
      * *INZSR        - Initialise                                    *
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
 
     FSDCWHTL0  IF   E           K DISK    INFSR(*PSSR)
     ** Midas Compliance Watch Hit List(FType/Identifier/Branch)
 
     FLELOANL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     ** Midas LE Live loan details
 
     FLEFEEDL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      ** Midas LE Fee details - active
 
     FLEFEEAL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      ** Midas LE Fee adjustment details - active
 
     FLELOANL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      **  Midas LE Live rollover details
 
     FLELOAML0  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      **  Midas LE Live loan amendment details
 
     FSDWLCCL0  UF   E           K DISK    INFSR(*PSSR)
      **  Watch List Checking Details by Function Code
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
 
 
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** WATCH LIST FIELDS's OPEN AND CLOSE TAGS
     D Opentag         S             25    CTDATA DIM(13) PERRCD(1)
     D Clostag         S             25    CTDATA DIM(13) PERRCD(1)
 
      ** Data structure for data area SDSTAT
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Externally described DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Externally described DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Externally described DS for General Ledger Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Midas SD Watch List Configuration Data File
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)
 
      ** Externally described DS for Functions for Watch List Checking
      ** Details File
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Data Structure used as parameters for the Compliance Engine
     D PDSWLTD       E DS                  EXTNAME(SDWLTDPD)
     D P_XML           DS         30000
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
      ** Parameter for AOBANKR0/AOSARDR0/AOCUSTR0/AOWLCCR0
     D PReturnCode     S              7
     D POption         S              7
     D PSard           S              6
     D PKey1           S             10A
     D PKyst           S              7A
     D PFuncCode       S              8A
 
      ** Parameters for ZFREQB
      ** Return Code
      ** Rate Change Frequency
      ** MIDAS day number
      ** Currency code passed
      ** Rate frequency day
      ** Location code
     D  PRetCodeOut    S             10A
     D  PZFREQ         S              1A
     D  PZDAYNO        S              5  0
     D  PZCCY          S              3A
     D  PZLOC          S              3A                                                    AR702741
     D  PZMDAY         S              2  0
 
      ** Parameter for 'SDCWLFMT'
     D  PInput1        S             35A
     D  PInput2        S             35A
     D  PInput3        S             35A
     D  PInput4        S             35A
     D  PInput5        S             35A
     D  PInput6        S             35A
     D  PCurrency      S              3A
     D  POutput1       S            216A
     D  POutput2       S              6A
 
      ** Concord Interface Development
     D CCF001          S              1A
 
      ** Watch List Checking Details by Function Code Key Field
     D KFuncCode       S              8A
 
      ** Key Fields for SDCWHTL0
     D KFunt           S              8A
     D KIden           S             40A
     D KBrch           S              3A
 
      ** Parameter for ZACVTDATE
     D PInDate         S              5A
     D POutDate        S               D
     D PCvtdDate       S             10A
 
      ** Parameter for ZACVTAMT
     D PCcy            S              3
     D PInAmt          S             15
     D POutAmt         S             18  3
     D PCvtdAmt        S             16
 
      ** Parameter for AOCURRR0
     D PmRetn          S              7
     D PmOption        S              7
     D PmCcy           S              3
 
      ** Work Variables - LEFEED Identifier
     D WCNUM           S              6
     D WFACL           S              5
     D WFSEQ           S              2
     D WLOAN           S              6
 
      ** Work Variables - LOAMSDK Identifier
     D WLNRF           S              6
     D WVDAT           S              5
     D WLASN           S              3
 
      ** Work Variables - Processing Type
     D WWPTYP          S              2
 
     D PRetCode        S              7A
     D PMsg            S            132A
     D PMsgId          S              7A
     D PMsgF           S             10A
     D PMsgQ           S             10A
     D PSrvContext     S               *
     D WDBASE          S              3  0
     D WDBNUM          S              3  0
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
 
      ** Open OFAC server
 
     C                   CALL      'SDOFACOP'
     C                   PARM      *BLANK        PRetCode
     C                   PARM                    PSrvContext
 
      ** Error calling SDOFACOP
 
     C                   IF        PRetCode <> *BLANK
 
     C                   SELECT
 
     C                   WHEN      PRetCode = '*INIT  '
     C                   EVAL      WDBASE = 67
     C                   EVAL      PMsgId = 'USR9686'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*OPEN  '
     C                   EVAL      WDBASE = 68
     C                   EVAL      PMsgID = 'USR9687'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*NREADY'
     C                   EVAL      WDBASE = 69
     C                   EVAL      PMsgID = 'USR9688'
     C                   EXSR      SRSndErr
 
     C                   ENDSL
 
      ** Perform database error
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = WDBASE
     C                   EVAL      DBKEY = PRetCode
     C                   EVAL      DBFile = 'SDOFACOP'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If watch list checking for 'Lending' is installed
 
     C                   IF        W1FUNC = 'LENDING '
 
      ** If perodic watch list checking frequency is not blank and next periodic
      ** check date is less than or equals rundate, process lending files
 
     C                   IF        W1PFRQ <> *BLANKS AND W1NPCD <= BJRDNB
 
      ** Process Customer Loans Details File
 
     C                   EXSR      SrCloancl
 
      ** Process Lending Fees Details File
 
     C                   EXSR      SrLefeed
 
      ** Process Fees Settlement/Adjustment Detail
 
     C                   EXSR      SrLefeead
 
      ** Process Loans Detail 2
 
     C                   EXSR      SrCloanck
 
      ** Process Loan amendments file
 
     C                   EXSR      SrLoamsdk
 
      ** Update Watch List Checking Details by Function Code
 
     C                   EXSR      SrUpdWlcc
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Close connection with the server
 
     C                   CALL      'SDOFACCL'
     C                   PARM      *BLANK        PRetCode
     C                   PARM                    PSrvContext
 
      ** Return to the calling program.
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCloancl - Process CLOANCL                                   *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrWtchCloancl                                          *
      *                                                               *
      *****************************************************************
 
     C     SrCloancl     BEGSR
 
     C                   EVAL      DBPROC =  'SrCloancl'
 
      ** Open Customer Loans Details File
 
     C                   OPEN      LELOANL0
 
      ** For every live record read on CLOANCL, send details to Compliance
      *** Watch Engine by calling SDWLENGN.
 
     C                   READ      LELOANL0
 
     C                   DOW       NOT %EOF (LELOANL0)
 
      ** Access record in PF/SDCWHTL0.
 
     C                   EVAL      KFunt = *BLANKS
     C                   EVAL      KIden = *BLANKS
     C                   EVAL      KBrch = *BLANKS
 
     C                   MOVEL     'CLOANCL'     KFunt
     C                   MOVEL     LNRF          KIden
     C                   MOVEL     BRCA          KBrch
 
     C     KSDCWHT       CHAIN     SDCWHTL0
 
      ** If record is not found
 
     C                   IF        NOT %FOUND(SDCWHTL0)
 
      ** If the last periodic check date < last watch list upload date,
      ** send details to Compliance Watch engine.
 
     C                   IF        W1LPCD < W1LUDT
 
     C                   EXSR      SRWtchCloancl
 
     C                   ENDIF
 
      ** Else, record already exist
 
     C                   ELSE
 
      ** If the last watch list check date < last watch list upload date,
      ** send details to Compliance Watch engine.
 
     C                   IF        W3LWCD < W1LUDT
 
     C                   EXSR      SRWtchCloancl
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      LELOANL0
     C                   ENDDO
 
      ** Close Customer Loans Details File
 
     C                   CLOSE     LELOANL0
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrWtchCloancl - Send Details to Compliance Watch Engine for   *
      *                 Live Record Read on CLOANCL                   *
      *                                                               *
      * Called by: SrCloancl                                          *
      *                                                               *
      * Calls: SrCustDet, SrCvtDate, SrCurrDet, SrCvtAmt, SrFormat    *
      *        SrEngine                                               *
      *                                                               *
      *****************************************************************
 
     C     SrWtchCloancl BEGSR
 
     C                   EVAL      DBPROC =  'SrWtchCloancl'
 
      ** Set-up parameter for Compliance Engine Program
 
     C                   EXSR      SrInitParm
 
      ** 2nd Parameter
 
      ** Receipt Nostro
 
     C                   IF        RONS <> *BLANKS
     C                   EVAL      PInput1 = RONS
     C                   EVAL      PCurrency= CCY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(1):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(1):0  P_XML
     C                   ENDIF
 
      ** Receipt Intermediary Bank + Account Line
 
     C                   IF        RIBN <> *BLANKS OR RIBA <> *BLANKS
     C                   EVAL      PInput1 = RIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(2):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RIBA:0        P_XML
     C     P_XML         CAT       ClosTag(2):0  P_XML
     C                   ENDIF
 
      ** Receipt Ordering Bank
 
     C**********         IF        ROBN <> *ZERO                                              CSD027
     C                   IF        ROBN <> *BLANKS                                            CSD027
     C                   MOVEL     ROBN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(3):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(3):0  P_XML
     C                   ENDIF
 
      ** Receipt Ordering Customer
 
     C**********         IF        ROCN <> *ZERO                                              CSD027
     C                   IF        ROCN <> *BLANKS                                            CSD027
     C                   MOVEL     ROCN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(4):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(4):0  P_XML
     C                   ENDIF
 
      ** Pay Nostro
 
     C                   IF        PONS <> *BLANKS
     C                   EVAL      PInput1 = PONS
     C                   EVAL      PCurrency = CCY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(5):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(5):0  P_XML
     C                   ENDIF
 
      ** Pay Intermediary Bank + Account Line
 
     C                   IF        PIBN <> *BLANKS OR PIBA <> *BLANKS
     C                   EVAL      PInput1 = PIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(6):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       PIBA:0        P_XML
     C     P_XML         CAT       ClosTag(6):0  P_XML
     C                   ENDIF
 
      ** Pay Ordering Bank
 
     C**********         IF        POBN <> *ZERO                                              CSD027
     C                   IF        POBN <> *BLANKS                                            CSD027
     C                   MOVEL     POBN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(7):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(7):0  P_XML
     C                   ENDIF
 
      ** Pay Ordering Customer
 
     C**********         IF        POCN <> *ZERO                                              CSD027
     C                   IF        POCN <> *BLANKS                                            CSD027
     C                   MOVEL     POCN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(8):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(8):0  P_XML
     C                   ENDIF
 
      ** Receiver Correspondent + Account Line
 
     C                   IF        RCRN <> *BLANKS OR RCRA <> *BLANKS
     C                   EVAL      PInput1 = RCRN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(9):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RCRA:0        P_XML
     C     P_XML         CAT       ClosTag(9):0  P_XML
     C                   ENDIF
 
      ** Receiver
 
     C                   IF        RVNO <> *BLANKS
     C                   EVAL      PInput1 = RVNO
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(10):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(10):0 P_XML
     C                   ENDIF
 
      ** Account with Bank + Account Line
 
     C                   IF        AWBN <> *BLANKS OR AWBA <> *BLANKS
     C                   EVAL      PInput1 = AWBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(11):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       AWBA:0        P_XML
     C     P_XML         CAT       ClosTag(11):0 P_XML
     C                   ENDIF
 
      ** Beneficiary + Account Line
 
     C                   IF        BENN <> *BLANKS OR BENA <> *BLANKS
     C                   EVAL      PInput1 = BENN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(12):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       BENA:0        P_XML
     C     P_XML         CAT       ClosTag(12):0 P_XML
     C                   ENDIF
 
      ** Details of Payment
 
     C                   IF        DTP1 <> *BLANKS OR DTP2 <> *BLANKS
     C                             OR DTP3 <> *BLANKS OR DTP4 <> *BLANKS
     C     P_XML         CAT       OpenTag(13):0 P_XML
     C     P_XML         CAT       DTP1:0        P_XML
     C     P_XML         CAT       DTP2:0        P_XML
     C     P_XML         CAT       DTP3:0        P_XML
     C     P_XML         CAT       DTP4:0        P_XML
     C     P_XML         CAT       ClosTag(13):0 P_XML
     C                   ENDIF
 
      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine
 
     C                   IF        P_XML <> *BLANKS
 
      ** First Parameter
 
      ** Identifier
 
     C                   MOVEL     LNRF          W4IDEN
 
      ** If generated by Principal Transfer, Item Type Code is 'LEPTFR'.
      ** Otherwise, LE + PTYP.
 
     C                   IF        GPRT = 'Y'
     C                   EVAL      W4ITEM = 'LEPTFR'
     C                   ELSE
     C                   MOVEL     PTYP          WWPTYP
     C     'LE'          CAT       WWPTYP:0      W4ITEM
     C                   ENDIF
 
      ** Branch
 
     C                   EVAL      W4BRCH = BRCA
 
      ** System
 
     C                   EVAL      W4SYSM = LIBR
 
      ** Function Type
 
     C                   EVAL      W4FUNT = 'CLOANCL '
 
      ** Counter Party Number
 
     C                   MOVEL     CNUM          W4CNUM
 
      ** Get Customer Detail
 
     C                   MOVEL     CNUM          PKey1
 
     C                   EXSR      SrCustDet
 
      ** If Customer detail not found, issue DB error.
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Counterparty Type
 
      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'
 
     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
 
     C                   ELSE
 
      **
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.
 
     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5
 
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
 
     C                   ENDIF
 
      ** Counter Party Name
 
     C     BBCRNM        CAT       BBCRTN        W4CUST
 
      ** Deal Date
 
     C                   MOVEL     DDAT          PInDate
     C                   EXSR      SrCvtDate
 
      ** DB Error Processing
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  006
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4DDAT = POutDate
 
      ** Value Date
 
     C                   MOVEL     VDAT          PInDate
     C                   EXSR      SrCvtDate
 
      ** DB Error Processing
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  007
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4VDAT = POutDate
 
      ** Maturity Date
 
     C                   MOVEL     MDAT          PInDate
     C                   EXSR      SrCvtDate
 
      ** DB Error Processing
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  008
     C                   EVAL      DBPROC =  'SrWtchCloancl'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4MDAT = POutDate
 
 
      ** Denomination Side 1
 
     C                   EVAL      W4DEN1 = CCY
 
      ** Denomination Side 2
 
     C                   EVAL      W4DEN2 = *BLANKS
 
      ** Amount Side 1
 
      ** Access currency details to check if denomination is a valid ccy
 
     C                   EVAL      PmCcy = W4DEN1
 
     C                   EXSR      SrCurrDet
 
      ** Format Amount 1
 
     C                   IF        PmRetn = *BLANK
     C                   EVAL      PCcy = W4DEN1
     C                   ELSE
     C                   EVAL      PCcy = *BLANKS
     C                   ENDIF
 
     C                   MOVE      CPAM          PInAmt
     C                   EXSR      SrCvtAmt
 
      ** DB Error Processing
 
     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  009
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4AMT1 = PoutAmt
 
      ** Amount Side 2
 
     C                   EVAL      W4AMT2 = *ZERO
 
 
      ** Send Transaction Details to Compliance Watch by Calling the
      ** Engine Program.
 
     C                   EVAL      WDBNUM = 37
     C                   EXSR      SREngine
 
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrLefeed - Process LEFEED                                     *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrWtchLefeed                                           *
      *                                                               *
      *****************************************************************
 
     C     SrLefeed      BEGSR
 
     C                   EVAL      DBPROC =  'SrLefeed'
 
      ** Open Lending Fees Details File
 
     C                   OPEN      LEFEEDL0
 
      ** For every live record read on LEFEEDL0, send details to Compliance
      *** Watch Engine by calling SDWLENGN.
 
     C                   READ      LEFEEDL0
 
     C                   DOW       NOT %EOF (LEFEEDL0)
 
      ** Access record in LF/SDCWHTL0.
 
     C                   EVAL      KFunt = *BLANKS
     C                   EVAL      KIden = *BLANKS
     C                   EVAL      KBrch = *BLANKS
 
     C                   MOVEL     'LEFEED'      KFunt
 
     C                   MOVEL     FECNUM        WCNUM
     C                   MOVEL     FEFACL        WFACL
     C                   MOVEL     FEFSEQ        WFSEQ
     C                   MOVEL     FELOAN        WLOAN
 
     C**********         IF        FELOAN = *ZERO                                             CLE148
     C                   IF        FELOAN = *BLANKS                                           CLE148
     C                   EVAL      KIden = WCNUM + WFACL + WFSEQ
     C                   ELSE
     C                   EVAL      KIden = WLOAN + WFSEQ
     C                   ENDIF
 
     C                   MOVEL     FEBRCA        KBrch
 
     C     KSDCWHT       CHAIN     SDCWHTL0
 
      ** If record is not found
 
     C                   IF        NOT %FOUND(SDCWHTL0)
 
      ** If the last periodic check date < last watch list upload date,
      ** send details to Compliance Watch engine.
 
     C                   IF        W1LPCD < W1LUDT
 
     C                   EXSR      SrWtchLefeed
 
     C                   ENDIF
 
      ** Else, record already exist
 
     C                   ELSE
 
      ** If the last watch list check date < last watch list upload date,
      ** send details to Compliance Watch engine.
 
     C                   IF        W3LWCD < W1LUDT
 
     C                   EXSR      SrWtchLefeed
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      LEFEEDL0
     C                   ENDDO
 
      ** Close LE Fees Master Detail
 
     C                   CLOSE     LEFEEDL0
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrWtchLefeed - Send Details to Compliance Watch Engine for    *
      *                Live Record Read on LEFEED                     *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrEngine                                               *
      *                                                               *
      *****************************************************************
 
     C     SrWtchLefeed  BEGSR
 
     C                   EVAL      DBPROC =  'SrWtchLefeed'
 
      ** Set-up parameter for Compliance Engine Program
 
     C                   EXSR      SrInitParm
 
      ** 2nd Parameter
 
      ** Receipt Nostro
 
     C                   IF        RONS <> *BLANKS
     C                   EVAL      PInput1 = RONS
     C                   EVAL      PCurrency = FEFCCY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(1):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(1):0  P_XML
     C                   ENDIF
 
      ** Receipt Intermediary Bank + Account Line
 
     C                   IF        RIBN <> *BLANKS OR RIBA <> *BLANKS
     C                   EVAL      PInput1 = RIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(2):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RIBA:0        P_XML
     C     P_XML         CAT       ClosTag(2):0  P_XML
     C                   ENDIF
 
      ** Receipt Ordering Bank
 
     C**********         IF        ROBN <> *ZERO                                              CSD027
     C                   IF        ROBN <> *BLANKS                                            CSD027
     C                   MOVEL     ROBN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(3):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(3):0  P_XML
     C                   ENDIF
 
      ** Receipt Ordering Customer
 
     C**********         IF        ROCN <> *ZERO                                              CSD027
     C                   IF        ROCN <> *BLANKS                                            CSD027
     C                   MOVEL     ROCN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(4):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(4):0  P_XML
     C                   ENDIF
 
      ** Pay Nostro
 
     C                   IF        PONS <> *BLANKS
     C                   EVAL      PInput1 = PONS
     C                   EVAL      PCurrency = FEFCCY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(5):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(5):0  P_XML
     C                   ENDIF
 
      ** Pay Intermediary Bank + Account Line
 
     C                   IF        PIBN <> *BLANKS OR PIBA <> *BLANKS
     C                   EVAL      PInput1 = PIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(6):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       PIBA:0        P_XML
     C     P_XML         CAT       ClosTag(6):0  P_XML
     C                   ENDIF
 
      ** Pay Ordering Bank
 
     C**********         IF        POBN <> *ZERO                                              CSD027
     C                   IF        POBN <> *BLANKS                                            CSD027
     C                   MOVEL     POBN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(7):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(7):0  P_XML
     C                   ENDIF
 
      ** Pay Ordering Customer
 
     C**********         IF        POCN <> *ZERO                                              CSD027
     C                   IF        POCN <> *BLANKS                                            CSD027
     C                   MOVEL     POCN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(8):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(8):0  P_XML
     C                   ENDIF
 
      ** Receiver Correspondent + Account Line
 
     C                   IF        RCRN <> *BLANKS OR RCRA <> *BLANKS
     C                   EVAL      PInput1 = RCRN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(9):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RCRA:0        P_XML
     C     P_XML         CAT       ClosTag(9):0  P_XML
     C                   ENDIF
 
      ** Receiver
 
     C                   IF        RVNO <> *BLANKS
     C                   EVAL      PInput1 = RVNO
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(10):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(10):0 P_XML
     C                   ENDIF
 
      ** Account with Bank + Account Line
 
     C                   IF        AWBN <> *BLANKS OR AWBA <> *BLANKS
     C                   EVAL      PInput1 = AWBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(11):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       AWBA:0        P_XML
     C     P_XML         CAT       ClosTag(11):0 P_XML
     C                   ENDIF
 
      ** Beneficiary + Account Line
 
     C                   IF        BENN <> *BLANKS OR BENA <> *BLANKS
     C                   EVAL      PInput1 = BENN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(12):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       BENA:0        P_XML
     C     P_XML         CAT       ClosTag(12):0 P_XML
     C                   ENDIF
 
      ** Details of Payment
 
     C                   IF        DTP1 <> *BLANKS OR DTP2 <> *BLANKS
     C                             OR DTP3 <> *BLANKS OR DTP4 <> *BLANKS
     C     P_XML         CAT       OpenTag(13):0 P_XML
     C     P_XML         CAT       DTP1:0        P_XML
     C     P_XML         CAT       DTP2:0        P_XML
     C     P_XML         CAT       DTP3:0        P_XML
     C     P_XML         CAT       DTP4:0        P_XML
     C     P_XML         CAT       ClosTag(13):0 P_XML
     C                   ENDIF
 
      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine
 
     C                   IF        P_XML <> *BLANKS
 
      ** First Parameter
 
      ** Identifier
      **
 
     C                   MOVEL     FECNUM        WCNUM
     C                   MOVEL     FEFACL        WFACL
     C                   MOVEL     FEFSEQ        WFSEQ
     C                   MOVEL     FELOAN        WLOAN
 
     C**********         IF        FELOAN = *ZERO                                             CLE148
     C                   IF        FELOAN = *BLANKS                                           CLE148
     C                   EVAL      W4IDEN = WCNUM + WFACL + WFSEQ
     C                   ELSE
     C                   EVAL      W4IDEN = WLOAN + WFSEQ
     C                   ENDIF
 
      ** Item Type Code
 
     C                   EVAL      W4ITEM = 'LEFEE'
 
      ** Branch
 
     C                   EVAL      W4BRCH = FEBRCA
 
      ** System
 
     C                   EVAL      W4SYSM = LIBR
 
      ** Function Type
 
     C                   EVAL      W4FUNT = 'LEFEED  '
 
      ** Counter Party Number
 
     C                   MOVEL     FECNUM        W4CNUM
 
      ** Get Customer Detail
 
     C                   MOVEL     FECNUM        PKey1
 
     C                   EXSR      SrCustDet
 
      ** If Customer detail not found, issue DB error.
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  011
     C                   EVAL      DBMOD  =  PSProcMod
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Counterparty Type
 
      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'
 
     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
 
     C                   ELSE
 
      ** ELSE,
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.
 
     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
 
     C                   ENDIF
 
      ** Counter Party Name
 
     C     BBCRNM        CAT       BBCRTN        W4CUST
 
      ** Deal Date
 
     C                   MOVEL     '00000'       PInDate
     C                   EXSR      SrCvtDate
 
      ** DB Error Processing
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  012
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4DDAT = POutDate
 
      ** Value Date
 
     C                   MOVEL     FEPSTD        PInDate
     C                   EXSR      SrCvtDate
 
      ** DB Error Processing
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  013
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4VDAT = POutDate
 
      ** Maturity Date
 
     C                   MOVEL     FEPEND        PInDate
     C                   EXSR      SrCvtDate
 
      ** DB Error Processing
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  014
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4MDAT = POutDate
 
      ** Denomination Side 1
 
     C                   EVAL      W4DEN1 = FEFCCY
 
      ** Denomination Side 2
 
     C                   EVAL      W4DEN2 = *BLANKS
 
      ** Amount Side 1
 
      ** Access currency details to check if denomination is a valid ccy
 
     C                   EVAL      PmCcy = W4DEN1
 
     C                   EXSR      SrCurrDet
 
      ** Format Amount 1
 
     C                   IF        PmRetn = *BLANK
     C                   EVAL      PCcy = W4DEN1
     C                   ELSE
     C                   EVAL      PCcy = *BLANKS
     C                   ENDIF
 
     C                   MOVE      FEFAMT        PInAmt
     C                   EXSR      SrCvtAmt
 
      ** DB Error Processing
 
     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  015
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4AMT1 = PoutAmt
 
      ** Amount Side 2 (W4AMT2)
 
     C                   EVAL      W4AMT2 = *ZERO
 
 
      ** Send Transaction Details to Compliance Watch by Calling the
      ** Engine Program.
 
     C                   EVAL      WDBNUM = 43
     C                   EXSR      SREngine
 
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrLefeead - Process LEFEEAD                                   *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrWtchLefeead                                          *
      *                                                               *
      *****************************************************************
 
     C     SrLefeead     BEGSR
 
     C                   EVAL      DBPROC =  'SrLefeead'
 
      ** Open Fee Adjustment Details File
 
     C                   OPEN      LEFEEAL0
 
      ** For every live record read on LEFEEAL0, send details to Compliance
      *** Watch Engine by calling SDWLENGN.
 
     C                   READ      LEFEEAL0
 
     C                   DOW       NOT %EOF (LEFEEAL0)
 
      ** Access record in LF/SDCWHTL0.
 
     C                   EVAL      KFunt = *BLANKS
     C                   EVAL      KIden = *BLANKS
     C                   EVAL      KBrch = *BLANKS
 
     C                   MOVEL     'LEFEEAD'     KFunt
 
     C                   MOVEL     FACNUM        WCNUM
     C                   MOVEL     FAFACL        WFACL
     C                   MOVEL     FAFSEQ        WFSEQ
     C                   MOVEL     FALOAN        WLOAN
 
     C**********         IF        FALOAN = *ZERO                                             CLE148
     C                   IF        FALOAN = *BLANKS                                           CLE148
     C                   EVAL      KIden = WCNUM + WFACL + WFSEQ
     C                   ELSE
     C                   EVAL      KIden = WLOAN + WFSEQ
     C                   ENDIF
 
     C                   EVAL      KBrch = FABRCA
 
     C     KSDCWHT       CHAIN     SDCWHTL0
 
      ** If record is not found
 
     C                   IF        NOT %FOUND(SDCWHTL0)
 
      ** If the last periodic check date < last watch list upload date,
      ** send details to Compliance Watch engine.
 
     C                   IF        W1LPCD < W1LUDT
 
     C                   EXSR      SRWtchLefeead
 
     C                   ENDIF
 
      ** Else, record already exist
 
     C                   ELSE
 
      ** If the last watch list check date < last watch list upload date,
      ** send details to Compliance Watch engine.
 
     C                   IF        W3LWCD < W1LUDT
 
     C                   EXSR      SRWtchLefeead
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      LEFEEAL0
     C                   ENDDO
 
      ** Close Fee Adjustment Details File
 
     C                   CLOSE     LEFEEAL0
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrWtchLefeead - Send Details to Compliance Watch Engine for   *
      *                 Every Live Record Read on LEFEEAD             *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrEngine                                               *
      *                                                               *
      *****************************************************************
 
     C     SrWtchLefeead BEGSR
 
     C                   EVAL      DBPROC =  'SrWtchLefeead'
 
      ** Set-up parameter for Compliance Engine Program
 
     C                   EXSR      SrInitParm
 
 
      ** 2nd Parameter
 
      ** Receipt Nostro
 
     C                   IF        RONS <> *BLANKS
     C                   EVAL      PInput1 = RONS
     C                   EVAL      PCurrency = FAFCCY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(1):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(1):0  P_XML
     C                   ENDIF
 
      ** Receipt Intermediary Bank + Account Line
 
     C                   IF        RIBN <> *BLANKS OR RIBA <> *BLANKS
     C                   EVAL      PInput1 = RIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(2):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RIBA:0        P_XML
     C     P_XML         CAT       ClosTag(2):0  P_XML
     C                   ENDIF
 
      ** Receipt Ordering Bank
 
     C**********         IF        ROBN <> *ZERO                                              CSD027
     C                   IF        ROBN <> *BLANKS                                            CSD027
     C                   MOVEL     ROBN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(3):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(3):0  P_XML
     C                   ENDIF
 
      ** Receipt Ordering Customer
 
     C**********         IF        ROCN <> *ZERO                                              CSD027
     C                   IF        ROCN <> *BLANKS                                            CSD027
     C                   MOVEL     ROCN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(4):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(4):0  P_XML
     C                   ENDIF
 
      ** Pay Nostro
 
     C                   IF        PONS <> *BLANKS
     C                   EVAL      PInput1 = PONS
     C                   EVAL      PCurrency = FAFCCY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(5):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(5):0  P_XML
     C                   ENDIF
 
      ** Pay Intermediary Bank + Account Line
 
     C                   IF        PIBN <> *BLANKS OR PIBA <> *BLANKS
     C                   EVAL      PInput1 = PIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(6):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       PIBA:0        P_XML
     C     P_XML         CAT       ClosTag(6):0  P_XML
     C                   ENDIF
 
      ** Pay Ordering Bank
 
     C**********         IF        POBN <> *ZERO                                              CSD027
     C                   IF        POBN <> *BLANKS                                            CSD027
     C                   MOVEL     POBN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(7):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(7):0  P_XML
     C                   ENDIF
 
      ** Pay Ordering Customer
 
     C**********         IF        POCN <> *ZERO                                              CSD027
     C                   IF        POCN <> *BLANKS                                            CSD027
     C                   MOVEL     POCN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(8):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(8):0  P_XML
     C                   ENDIF
 
      ** Receiver Correspondent + Account Line
 
     C                   IF        RCRN <> *BLANKS OR RCRA <> *BLANKS
     C                   EVAL      PInput1 = RCRN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(9):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RCRA:0        P_XML
     C     P_XML         CAT       ClosTag(9):0  P_XML
     C                   ENDIF
 
      ** Receiver
 
     C                   IF        RVNO <> *BLANKS
     C                   EVAL      PInput1 = RVNO
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(10):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(10):0 P_XML
     C                   ENDIF
 
      ** Account with Bank + Account Line
 
     C                   IF        AWBN <> *BLANKS OR AWBA <> *BLANKS
     C                   EVAL      PInput1 = AWBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(11):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       AWBA:0        P_XML
     C     P_XML         CAT       ClosTag(11):0 P_XML
     C                   ENDIF
 
      ** Beneficiary + Account Line
 
     C                   IF        BENN <> *BLANKS OR BENA <> *BLANKS
     C                   EVAL      PInput1 = BENN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(12):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       BENA:0        P_XML
     C     P_XML         CAT       ClosTag(12):0 P_XML
     C                   ENDIF
 
      ** Details of Payment
 
     C                   IF        DTP1 <> *BLANKS OR DTP2 <> *BLANKS
     C                             OR DTP3 <> *BLANKS OR DTP4 <> *BLANKS
     C     P_XML         CAT       OpenTag(13):0 P_XML
     C     P_XML         CAT       DTP1:0        P_XML
     C     P_XML         CAT       DTP2:0        P_XML
     C     P_XML         CAT       DTP3:0        P_XML
     C     P_XML         CAT       DTP4:0        P_XML
     C     P_XML         CAT       ClosTag(13):0 P_XML
     C                   ENDIF
 
      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine
 
     C                   IF        P_XML <> *BLANKS
 
      ** First Parameter
 
      ** Identifier
 
     C                   MOVEL     FACNUM        WCNUM
     C                   MOVEL     FAFACL        WFACL
     C                   MOVEL     FAFSEQ        WFSEQ
     C                   MOVEL     FALOAN        WLOAN
 
     C**********         IF        FALOAN = *ZERO                                             CLE148
     C                   IF        FALOAN = *BLANKS                                           CLE148
     C                   EVAL      W4IDEN = WCNUM + WFACL + WFSEQ
     C                   ELSE
     C                   EVAL      W4IDEN = WLOAN + WFSEQ
     C                   ENDIF
 
      ** Item Type Code
 
     C                   EVAL      W4ITEM = 'LEFESA'
 
      ** Branch
 
     C                   EVAL      W4BRCH = FABRCA
 
      ** System
 
     C                   EVAL      W4SYSM = LIBR
 
      ** Function Type
 
     C                   EVAL      W4FUNT = 'LEFEEAD '
 
      ** Counter Party Number
 
     C                   MOVEL     FACNUM        W4CNUM
 
      ** Get Customer Detail
 
     C                   MOVEL     FACNUM        PKey1
 
     C                   EXSR      SrCustDet
 
      ** If Customer detail not found, issue DB error.
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  017
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Counterparty Type
 
      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'
 
     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
 
     C                   ELSE
 
      ** ELSE,
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.
 
     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
 
     C                   ENDIF
 
      ** Counter Party Name
 
     C     BBCRNM        CAT       BBCRTN        W4CUST
 
      ** Deal Date
 
     C                   MOVEL     '00000'       PInDate
     C                   EXSR      SrCvtDate
 
      ** DB Error Processing
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  018
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4DDAT = POutDate
 
      ** Value Date
 
     C                   MOVEL     FASADD        PInDate
     C                   EXSR      SrCvtDate
 
      ** DB Error Processing
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  019
     C                   EVAL      DBPROC =  'SrWtchCloancl'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4VDAT = POutDate
 
      ** Maturity Date
 
     C                   MOVEL     '00000'       PInDate
     C                   EXSR      SrCvtDate
 
      ** DB Error Processing
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  020
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4MDAT = POutDate
 
      ** Denomination Side 1
 
     C                   EVAL      W4DEN1 = FAFCCY
 
      ** Denomination Side 2
 
     C                   EVAL      W4DEN2 = *BLANKS
 
      ** Amount Side 1
 
      ** Access currency details to check if denomination is a valid ccy
 
     C                   EVAL      PmCcy = W4DEN1
 
     C                   EXSR      SrCurrDet
 
      ** Format Amount 1
 
     C                   IF        PmRetn = *BLANK
     C                   EVAL      PCcy = W4DEN1
     C                   ELSE
     C                   EVAL      PCcy = *BLANKS
     C                   ENDIF
 
     C                   MOVE      FASADJ        PInAmt
     C                   EXSR      SrCvtAmt
 
      ** DB Error Processing
 
     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  021
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4AMT1 = PoutAmt
 
      ** Amount Side 2 (W4AMT2)
 
     C                   EVAL      W4AMT2 = *ZERO
 
      ** Send Transaction Details to Compliance Watch by Calling the
      ** Engine Program.
 
     C                   EVAL      WDBNUM = 49
     C                   EXSR      SREngine
 
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCloanck - Process CLOANCK                                   *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrWtchCloanck                                          *
      *                                                               *
      *****************************************************************
 
     C     SrCloanck     BEGSR
 
     C                   EVAL      DBPROC =  'SrCloanck'
 
      ** Open Customer Loans Secondary Details File
 
     C                   OPEN      LELOANL2
     C                   OPEN      LELOANL0
 
      ** For every live record read on CLOANCK, read its corresponding record
      ** in CLOANCL and send details to Compliance Watch Engine by calling
      ** SDWLENGN.
 
     C                   READ      LELOANL2
 
     C                   DOW       NOT %EOF (LELOANL2)
 
     C     LNRF          CHAIN     LELOANL0
 
     C                   IF        NOT %FOUND(LELOANL0)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile= 'LELOANL0'
     C                   MOVEL     LNRF          DBKey
     C                   EVAL      DBase = 023
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access record in PF/SDCWHTL0.
 
     C                   EVAL      KFunt = *BLANKS
     C                   EVAL      KIden = *BLANKS
     C                   EVAL      KBrch = *BLANKS
 
     C                   MOVEL     'CLOANCK'     KFunt
     C                   MOVEL     LNRF          KIden
     C                   MOVEL     BRCA          KBrch
 
     C     KSDCWHT       CHAIN     SDCWHTL0
 
      ** If record is not found
 
     C                   IF        NOT %FOUND(SDCWHTL0)
 
      ** If the last periodic check date < last watch list upload date,
      ** send details to Compliance Watch engine.
 
     C                   IF        W1LPCD < W1LUDT
 
     C                   EXSR      SRWtchCloanck
 
     C                   ENDIF
 
      ** Else, record already exist
 
     C                   ELSE
 
      ** If the last watch list check date < last watch list upload date,
      ** send details to Compliance Watch engine.
 
     C                   IF        W3LWCD < W1LUDT
 
     C                   EXSR      SRWtchCloanck
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      LELOANL2
     C                   ENDDO
 
      ** Close Customer Loans Secondary Details File
 
     C                   CLOSE     LELOANL2
     C                   CLOSE     LELOANL0
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWtchCloanck - Send Details to Compliance Watch Engine for   *
      *                 Every Live Record Read on CLOANCK             *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrEngine                                               *
      *                                                               *
      *****************************************************************
 
     C     SRWtchCloanck BEGSR
 
     C                   EVAL      DBPROC =  'SrWtchCloanck'
 
      ** Set-up parameter for Compliance Engine Program
 
     C                   EXSR      SrInitParm
 
      ** 2nd Parameter
 
      ** Receipt Nostro
 
     C                   IF        RRON <> *BLANKS
     C                   EVAL      PInput1 = RRON
     C                   EVAL      PCurrency = CCY
     C                   IF        NCCY <> *BLANKS
     C                   IF        PTYP = 66 OR PTYP = 67 OR PTYP = 69
     C                   EVAL      PCurrency = NCCY
     C                   ENDIF
     C                   ENDIF
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(1):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(1):0  P_XML
     C                   ENDIF
 
      ** Receipt Intermediary Bank + Account Line
 
     C                   IF        RRIB <> *BLANKS OR RRBA <> *BLANKS
     C                   EVAL      PInput1 = RRIB
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(2):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RRBA:0        P_XML
     C     P_XML         CAT       ClosTag(2):0  P_XML
     C                   ENDIF
 
      ** Receipt Ordering Bank
 
     C**********         IF        RROB <> *ZERO                                              CSD027
     C                   IF        RROB <> *BLANKS                                            CSD027
     C                   MOVEL     RROB          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(3):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(3):0  P_XML
     C                   ENDIF
 
      ** Receipt Ordering Customer
 
     C**********         IF        RROC <> *ZERO                                              CSD027
     C                   IF        RROC <> *BLANKS                                            CSD027
     C                   MOVEL     RROC          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(4):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(4):0  P_XML
     C                   ENDIF
 
      ** Pay Nostro
 
     C                   IF        RPON <> *BLANKS
     C                   EVAL      PInput1 = RPON
     C                   EVAL      PCurrency = CCY
     C                   IF        NCCY <> *BLANKS
     C                             AND PTYP <> 66 AND PTYP <> 67 AND PTYP <> 69
     C                   EVAL      PCurrency = NCCY
     C                   ENDIF
 
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(5):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(5):0  P_XML
     C                   ENDIF
 
      ** Pay Intermediary Bank + Account Line
 
     C                   IF        RPIB <> *BLANKS OR RPBA <> *BLANKS
     C                   EVAL      PInput1 = RPIB
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(6):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RPBA:0        P_XML
     C     P_XML         CAT       ClosTag(6):0  P_XML
     C                   ENDIF
 
      ** Pay Ordering Bank
 
     C**********         IF        RPOB <> *ZERO                                              CSD027
     C                   IF        RPOB <> *BLANKS                                            CSD027
     C                   MOVEL     RPOB          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(7):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(7):0  P_XML
     C                   ENDIF
 
      ** Pay Ordering Customer
 
     C**********         IF        RPOC <> *ZERO                                              CSD027
     C                   IF        RPOC <> *BLANKS                                            CSD027
     C                   MOVEL     RPOC          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(8):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(8):0  P_XML
     C                   ENDIF
 
      ** Receiver Correspondent + Account Line
 
     C                   IF        RRCR <> *BLANKS OR RRCA <> *BLANKS
     C                   EVAL      PInput1 = RRCR
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(9):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RRCA:0        P_XML
     C     P_XML         CAT       ClosTag(9):0  P_XML
     C                   ENDIF
 
      ** Receiver
 
     C                   IF        RRVN <> *BLANKS
     C                   EVAL      PInput1 = RRVN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(10):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(10):0 P_XML
     C                   ENDIF
 
      ** Account with Bank + Account Line
 
     C                   IF        RAWB <> *BLANKS OR RAWA <> *BLANKS
     C                   EVAL      PInput1 = RAWB
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(11):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RAWA:0        P_XML
     C     P_XML         CAT       ClosTag(11):0 P_XML
     C                   ENDIF
 
      ** Beneficiary + Account Line
 
     C                   IF        RBEN <> *BLANKS OR RBNA <> *BLANKS
     C                   EVAL      PInput1 = RBEN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(12):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RBNA:0        P_XML
     C     P_XML         CAT       ClosTag(12):0 P_XML
     C                   ENDIF
 
      ** Details of Payment
 
     C                   IF        RDP1 <> *BLANKS OR RDP2 <> *BLANKS
     C                             OR RDP3 <> *BLANKS OR RDP4 <> *BLANKS
     C     P_XML         CAT       OpenTag(13):0 P_XML
     C     P_XML         CAT       RDP1:0        P_XML
     C     P_XML         CAT       RDP2:0        P_XML
     C     P_XML         CAT       RDP3:0        P_XML
     C     P_XML         CAT       RDP4:0        P_XML
     C     P_XML         CAT       ClosTag(13):0 P_XML
     C                   ENDIF
 
      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine
 
     C                   IF        P_XML <> *BLANKS
 
      ** First Parameter
 
      ** Identifier
 
     C                   MOVEL     LNRF          W4IDEN
 
      ** Item Type Code
 
     C                   EVAL      W4ITEM = 'LEROLL'
 
      ** Branch
 
     C                   EVAL      W4BRCH = BRCA
 
      ** System
 
     C                   EVAL      W4SYSM = LIBR
 
      ** Function Type
 
     C                   EVAL      W4FUNT = 'CLOANCK '
 
      ** Counter Party Number
 
     C                   MOVEL     CNUM          W4CNUM
 
      ** Get Customer Detail
 
     C                   MOVEL     CNUM          PKey1
 
     C                   EXSR      SrCustDet
 
      ** If Customer detail not found, issue DB error.
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  024
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Counterparty Type
 
      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'
 
     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
 
     C                   ELSE
 
      ** ELSE,
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.
 
     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
 
     C                   ENDIF
 
      ** Counter Party Name
 
     C     BBCRNM        CAT       BBCRTN        W4CUST
 
      ** Deal Date
 
     C                   MOVEL     '00000'       PInDate
     C                   EXSR      SrCvtDate
 
      ** DB Error Processing
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  025
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4DDAT = POutDate
 
      ** Value Date
 
     C                   MOVEL     RLDT          PInDate
     C                   EXSR      SrCvtDate
 
      ** DB Error Processing
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  026
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4VDAT = POutDate
 
      ** Maturity Date
 
     C                   IF        NMDT <> *ZERO
     C                   MOVEL     NMDT          PInDate
     C                   ELSE
     C                   MOVEL     MDAT          PInDate
     C                   ENDIF
 
     C                   EXSR      SrCvtDate
 
      ** DB Error Processing
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  027
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4MDAT = POutDate
 
      ** Denomination Side 1
 
     C                   IF        NCCY <> *BLANKS
     C                   EVAL      W4DEN1 = NCCY
     C                   ELSE
     C                   EVAL      W4DEN1 = CCY
     C                   ENDIF
 
      ** Denomination Side 2 (W4DEN2)
 
     C                   EVAL      W4DEN2 = *BLANKS
 
      ** Amount Side 1
 
      ** Access currency details to check if denomination is a valid ccy
 
     C                   EVAL      PmCcy = W4DEN1
 
     C                   EXSR      SrCurrDet
 
      ** Format Amount 1
 
     C                   IF        PmRetn = *BLANK
     C                   EVAL      PCcy = W4DEN1
     C                   ELSE
     C                   EVAL      PCcy = *BLANKS
     C                   ENDIF
 
     C                   IF        (PTYP = 63 OR PTYP = 65 OR PTYP = 67)
     C                             AND NCCY = *BLANKS
     C                   MOVE      NPRAM         PInAmt
     C                   ELSE
     C                   IF        NCCY <> *BLANKS
     C                   MOVE      NCPA          PInAmt
     C                   ENDIF
     C                   ENDIF
 
     C                   EXSR      SrCvtAmt
 
      ** DB Error Processing
 
     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  028
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4AMT1 = PoutAmt
 
      ** Amount Side 2
 
     C                   EVAL      W4AMT2 = *ZERO
 
      ** Send Transaction Details to Compliance Watch by Calling the
      ** Engine Program.
 
     C                   EVAL      WDBNUM = 55
     C                   EXSR      SREngine
 
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrLoamsdk - Process LOAMSDK                                   *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrWtchLoamsdk                                          *
      *                                                               *
      *****************************************************************
 
     C     SrLoamsdk     BEGSR
 
     C                   EVAL      DBPROC =  'SrLoamsdk'
 
      ** Open Live loan amendment details
 
     C                   OPEN      LELOAML0
 
      ** For every live record read on LOAMSDK, send details to Compliance Watch
      ** Engine by calling SDWLENGN.
 
     C                   READ      LELOAML0
 
     C                   DOW       NOT %EOF (LELOAML0)
 
     C                   IF        AMTP = 'PI' or AMTP = 'MR' or AMTP = 'RE' or
     C                             AMTP = 'PT' or AMTP = 'PF'
 
      ** Access record in PF/SDCWHTL0.
 
     C                   EVAL      KFunt = *BLANKS
     C                   EVAL      KIden = *BLANKS
     C                   EVAL      KBrch = *BLANKS
 
     C                   MOVEL     'LOAMSDK'     KFunt
 
     C                   MOVEL     LNRF          WLNRF
     C                   MOVEL     VDAT          WVDAT
     C                   MOVEL     LASN          WLASN
 
     C                   EVAL      KIden = WLNRF + WVDAT + WLASN
     C                   MOVEL     BRCA          KBrch
 
     C     KSDCWHT       CHAIN     SDCWHTL0
 
      ** If record is not found
 
     C                   IF        NOT %FOUND(SDCWHTL0)
 
      ** If the last periodic check date < last watch list upload date,
      ** send details to Compliance Watch engine.
 
     C                   IF        W1LPCD < W1LUDT
 
     C                   EXSR      SRWtchLoamsdk
 
     C                   ENDIF
 
      ** Else, record already exist
 
     C                   ELSE
 
      ** If the last watch list check date < last watch list upload date,
      ** send details to Compliance Watch engine.
 
     C                   IF        W3LWCD < W1LUDT
 
     C                   EXSR      SRWtchLoamsdk
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      LELOAML0
     C                   ENDDO
 
      ** Close Customer Loans Secondary Details File
 
     C                   CLOSE     LELOAML0
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrWtchLoamsdk - Send Details to Compliance Watch Engine  for  *
      *                 Every Live Record Read on LOAMSDK             *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrEngine                                               *
      *                                                               *
      *****************************************************************
 
     C     SrWtchLoamsdk BEGSR
 
     C                   EVAL      DBPROC =  'SrWtchLoamsdk'
 
      ** Set-up parameter for Compliance Engine Program
 
     C                   EXSR      SrInitParm
 
      ** 2nd Parameter
 
      ** Receipt Nostro
 
     C                   IF        RONS <> *BLANKS
     C                   EVAL      PInput1 = RONS
     C                   EVAL      PCurrency = CCY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(1):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(1):0  P_XML
     C                   ENDIF
 
      ** Receipt Intermediary Bank + Account Line
 
     C                   IF        RIBN <> *BLANKS OR RIBA <> *BLANKS
     C                   EVAL      PInput1 = RIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(2):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RIBA:0        P_XML
     C     P_XML         CAT       ClosTag(2):0  P_XML
     C                   ENDIF
 
      ** Receipt Ordering Bank
 
     C**********         IF        ROBN <> *ZERO                                              CSD027
     C                   IF        ROBN <> *BLANKS                                            CSD027
     C                   MOVEL     ROBN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(3):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(3):0  P_XML
     C                   ENDIF
 
      ** Receipt Ordering Customer
 
     C**********         IF        ROCN <> *ZERO                                              CSD027
     C                   IF        ROCN <> *BLANKS                                            CSD027
     C                   MOVEL     ROCN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(4):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(4):0  P_XML
     C                   ENDIF
 
      ** Pay Nostro
 
     C                   IF        PONS <> *BLANKS
     C                   EVAL      PInput1 = PONS
     C                   EVAL      PCurrency = CCY
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(5):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(5):0  P_XML
     C                   ENDIF
 
      ** Pay Intermediary Bank + Account Line
 
     C                   IF        PIBN <> *BLANKS OR PIBA <> *BLANKS
     C                   EVAL      PInput1 = PIBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(6):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       PIBA:0        P_XML
     C     P_XML         CAT       ClosTag(6):0  P_XML
     C                   ENDIF
 
 
      ** Pay Ordering Bank
 
     C**********         IF        POBN <> *ZERO                                              CSD027
     C                   IF        POBN <> *BLANKS                                            CSD027
     C                   MOVEL     POBN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(7):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(7):0  P_XML
     C                   ENDIF
 
      ** Pay Ordering Customer
 
     C**********         IF        POCN <> *ZERO                                              CSD027
     C                   IF        POCN <> *BLANKS                                            CSD027
     C                   MOVEL     POCN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(8):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(8):0  P_XML
     C                   ENDIF
 
      ** Receiver Correspondent + Account Line
 
     C                   IF        RCRN <> *BLANKS OR RCRA <> *BLANKS
     C                   EVAL      PInput1 = RCRN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(9):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       RCRA:0        P_XML
     C     P_XML         CAT       ClosTag(9):0  P_XML
     C                   ENDIF
 
      ** Receiver
 
     C                   IF        RVNO <> *BLANKS
     C                   EVAL      PInput1 = RVNO
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(10):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(10):0 P_XML
     C                   ENDIF
 
      ** Account with Bank + Account Line
 
     C                   IF        AWBN <> *BLANKS OR AWBA <> *BLANKS
     C                   EVAL      PInput1 = AWBN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(11):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       AWBA:0        P_XML
     C     P_XML         CAT       ClosTag(11):0 P_XML
     C                   ENDIF
 
      ** Beneficiary + Account Line
 
     C                   IF        BENN <> *BLANKS OR BENA <> *BLANKS
     C                   EVAL      PInput1 = BENN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(12):0 P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       BENA:0        P_XML
     C     P_XML         CAT       ClosTag(12):0 P_XML
     C                   ENDIF
 
      ** Details of Payment
 
     C                   IF        DTP1 <> *BLANKS OR DTP2 <> *BLANKS
     C                             OR DTP3 <> *BLANKS OR DTP4 <> *BLANKS
     C     P_XML         CAT       OpenTag(13):0 P_XML
     C     P_XML         CAT       DTP1:0        P_XML
     C     P_XML         CAT       DTP2:0        P_XML
     C     P_XML         CAT       DTP3:0        P_XML
     C     P_XML         CAT       DTP4:0        P_XML
     C     P_XML         CAT       ClosTag(13):0 P_XML
     C                   ENDIF
 
      ** If the 2nd Parameter is blank,  no need to call the Compliance
      ** Watch Engine
 
     C                   IF        P_XML <> *BLANKS
 
      ** First Parameter
 
      ** Identifier
 
     C                   MOVEL     LNRF          WLNRF
     C                   MOVEL     VDAT          WVDAT
     C                   MOVEL     LASN          WLASN
 
     C                   EVAL      W4Iden = WLNRF + WVDAT + WLASN
 
      ** Item Type Code
 
     C                   SELECT
     C                   WHEN      AMTP = 'PI'
     C                   EVAL      W4ITEM = 'LEAMD '
     C                   WHEN      AMTP = 'MR'
     C                   EVAL      W4ITEM = 'LERPAY'
     C                   WHEN      AMTP = 'RE'
     C                   EVAL      W4ITEM = 'LESCHD'
     C                   WHEN      AMTP = 'PT' or AMTP = 'PF'
     C                   EVAL      W4ITEM = 'LEPTFR'
     C                   ENDSL
 
      ** Branch
 
     C                   EVAL      W4BRCH = BRCA
 
      ** System
 
     C                   EVAL      W4SYSM = LIBR
 
      ** Function Type
 
     C                   EVAL      W4FUNT = 'LOAMSDK '
 
      ** Counter Party Number
 
     C                   MOVEL     CNUM          W4CNUM
 
      ** Get Customer Detail
 
     C                   MOVEL     CNUM          PKey1
 
     C                   EXSR      SrCustDet
 
      ** If Customer detail not found, issue DB error.
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBASE  =  030
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Counterparty Type
 
      ** If Concord Interface Development is installed
      **    If Corporate Customer is 'Y', set Counterparty Type to 'C'
      **    Else, Counterparty Type to 'I'
 
     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
 
     C                   ELSE
 
      ** ELSE,
      **    If Local Industry Code is not blank and it is not equal to a
      **    any of the five Private Customer Industry Code, set CounterParty
      **    Type to 'C'
      **     Else, set Counterparty Type to 'I'.
 
     C                   IF        BBLICD <> *BLANKS AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND4 AND BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
 
     C                   ENDIF
 
      ** Counter Party Name
 
     C     BBCRNM        CAT       BBCRTN        W4CUST
 
 
      ** Deal Date
 
     C                   MOVEL     '00000'       PInDate
     C                   EXSR      SrCvtDate
 
      ** DB Error Processing
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  031
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4DDAT = POutDate
 
      ** Value Date
 
     C                   MOVEL     VDAT          PInDate
     C                   EXSR      SrCvtDate
 
      ** DB Error Processing
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  032
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4VDAT = POutDate
 
      ** Maturity Date
 
     C                   MOVEL     '00000'       PInDate
     C                   EXSR      SrCvtDate
 
      ** DB Error Processing
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTDATE'
     C                   EVAL      DBKEY  =  PInDate
     C                   EVAL      DBASE  =  033
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4MDAT = POutDate
 
      ** Denomination Side 1
 
     C                   EVAL      W4DEN1 = CCY
 
      ** Denomination Side 2
 
     C                   EVAL      W4DEN2 = *BLANKS
 
      ** Amount Side 1
 
      ** Access currency details to check if denomination is a valid ccy
 
     C                   EVAL      PmCcy = W4DEN1
 
     C                   EXSR      SrCurrDet
 
      ** Format Amount 1
 
     C                   IF        PmRetn = *BLANK
     C                   EVAL      PCcy = W4DEN1
     C                   ELSE
     C                   EVAL      PCcy = *BLANKS
     C                   ENDIF
 
     C                   MOVE      TAMT          PInAmt
     C                   EXSR      SrCvtAmt
 
      ** DB Error Processing
 
     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZACVTAMT'
     C                   EVAL      DBKEY  =  PInAmt
     C                   EVAL      DBASE  =  034
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W4AMT1 = PoutAmt
 
      ** Amount Side 2
 
     C                   EVAL      W4AMT2 = *ZERO
 
      ** Send Transaction Details to Compliance Watch by Calling the
      ** Engine Program.
 
     C                   EVAL      WDBNUM = 61
     C                   EXSR      SREngine
 
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrEngine   - Calls Watch List Engine                          *
      *                                                               *
      * Called by: SrWtchCloancl, SrWtchLefeed, SrWtchLefeead,        *
      *            SrWtchCloanck, SrWtchLoamsdk                       *
      *                                                               *
      * Calls: SDWLENGN                                               *
      *                                                               *
      *****************************************************************
 
     C     SrEngine      BEGSR
 
     C                   CALL      'SDWLENGN'
     C                   PARM      *BLANK        PRetCode
     C                   PARM                    PSrvContext
     C                   PARM                    PDSWLTD
     C                   PARM                    P_XML
 
      ** Error calling SDWLENGN
 
     C                   IF        PRetCode <> *BLANK
     C                   SELECT
 
     C                   WHEN      PRetCode = '*ERROR '
     C                   EVAL      WDBASE = WDBNUM
 
     C                   WHEN      PRetCode = '*FOFEXE'
     C                   EVAL      WDBASE = WDBNUM + 1
     C                   EVAL      PMsgId = 'USR9680'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*SRVNAM'
     C                   EVAL      WDBASE = WDBNUM + 2
     C                   EVAL      PMsgId = 'USR9681'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*DBNAME'
     C                   EVAL      WDBASE = WDBNUM + 3
     C                   EVAL      PMsgId = 'USR9682'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*USRNAM'
     C                   EVAL      WDBASE = WDBNUM + 4
     C                   EVAL      PMsgId = 'USR9683'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*PASSWD'
     C                   EVAL      WDBASE = WDBNUM + 5
     C                   EVAL      PMsgId = 'USR9684'
     C                   EXSR      SRSndErr
 
     C                   OTHER
     C                   EVAL      PMsgId = 'USR9685'
     C                   EXSR      SRSndErr
     C                   ENDSL
 
      ** Perform database error either of the following return code is true
 
     C                   IF        PRetCode = '*ERROR ' OR
     C                             PRetCode = '*FOFEXE' OR
     C                             PRetCode = '*SRVNAM' OR
     C                             PRetCode = '*DBNAME' OR
     C                             PRetCode = '*USRNAM' OR
     C                             PRetCode = '*PASSWD'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = WDBASE
     C                   EVAL      DBKey = PDSWLTD
     C                   EVAL      DBFile = 'SDWLENGN'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFormat   - Convert Settlement Details to Customer Name and  *
      *              Address                                          *
      *                                                               *
      * Called by: SrWtchCloancl, SrWtchLefeed, SrWtchLefeead,        *
      *            SrWtchCloanck, SrWtchLoamsdk                       *
      *                                                               *
      * Calls: SDCWLFMT                                               *
      *                                                               *
      *****************************************************************
 
     C     SrFormat      BEGSR
 
     C                   EVAL      DBPROC =  'SrFormat'
 
     C                   EVAL      POutput1 = *BLANKS
     C                   EVAL      POutput2 = *BLANKS
 
     C                   CALL      'SDCWLFMT'
     C                   PARM                    PReturnCode
     C                   PARM                    PInput1
     C                   PARM                    PInput2
     C                   PARM                    PInput3
     C                   PARM                    PInput4
     C                   PARM                    PInput5
     C                   PARM                    PInput6
     C                   PARM                    PCurrency
     C                   PARM                    POutput1
     C                   PARM                    POutput2
 
      ** Initialize to blanks the input parameters.
 
     C                   EVAL      PInput1 = *BLANKS
     C                   EVAL      PInput2 = *BLANKS
     C                   EVAL      PInput3 = *BLANKS
     C                   EVAL      PInput4 = *BLANKS
     C                   EVAL      PInput5 = *BLANKS
     C                   EVAL      PInput6 = *BLANKS
     C                   EVAL      PCurrency = *BLANKS
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrUpdWlcc - Update Watch List Checking Details by Function    *
      *             Code                                              *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: ZFREQB                                                 *
      *                                                               *
      *****************************************************************
 
     C     SrUpdWlcc     BEGSR
 
     C                   EVAL      DBPROC =  'SrUpdWlcc'
 
     C                   EVAL      KFuncCode = W1FUNC
 
     C     KFuncCode     CHAIN     SDWLCCL0
 
 
      ** Set Last Periodic Check Date = Run date
 
     C                   EVAL      W1LPCD = BJRDNB
 
      ** Determine Next Periodic Check Date
 
     C                   EVAL      PZFREQ = W1PFRQ
     C                   EVAL      PZDAYNO = W1NPCD
     C                   EVAL      PZCCY = BJLCCY
     C                   EVAL      PZMDAY = W1PDYN
 
     C                   CALLB     'ZFREQB'
     C                   PARM                    PRetCodeOut
     C                   PARM                    PZFREQ
     C                   PARM                    PZDAYNO
     C                   PARM                    PZCCY
     C                   PARM      *BLANKS       PZLOC                                      AR702741
     C                   PARM                    PZMDAY
     C                   PARM                    BJDFIN
     C     SDGELR        PARM                    SDGELR
 
     C                   IF        PRetCodeOut <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ZFREQB'
     C                   MOVEL     PZDAYNO       DBKEY
     C                   EVAL      DBASE  =  036
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W1NPCD = PZDAYNO
 
     C                   UPDATE    SDWLCCD0
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SrCurrDet - Retrieve Currency Details                         *
      *                                                               *
      * Called by: SrWtchCloancl, SrWtchLefeed, SrWtchLefeead,        *
      *            SrWtchCloanck, SrWtchLoamsdk                       *
      *                                                               *
      * Calls: AOCUSTR0                                               *
      *                                                               *
      *****************************************************************
     C     SrCurrDet     BEGSR
 
     C                   EVAL      DBPROC =  'SrCurrDet'
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        PmRetn
     C                   PARM      '*KEY'        PmOption
     C                   PARM                    PmCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SrCustDet - Retrieve Customer Details                         *
      *                                                               *
      * Called by: SrWtchCloancl, SrWtchLefeed, SrWtchLefeead,        *
      *            SrWtchCloanck, SrWtchLoamsdk                       *
      *                                                               *
      * Calls: AOCUSTR0                                               *
      *                                                               *
      *****************************************************************
     C     SrCustDet     BEGSR
 
     C                   EVAL      DBPROC =  'SrCustDet'
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PReturnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PKey1
     C                   PARM      *BLANK        PKyst
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SrCvtDate - Convert dates to be used for Watch Engine Program *
      *                                                               *
      * Called by: SrWtchCloancl, SrWtchLefeed, SrWtchLefeead,        *
      *            SrWtchCloanck, SrWtchLoamsdk                       *
      *                                                               *
      * Calls: ZaCvtDate                                              *
      *                                                               *
      *****************************************************************
     C     SrCvtDate     BegSr
 
     C                   EVAL      DBPROC =  'SrCvtDate'
 
     C                   CALL      'ZACVTDATE'
     C                   PARM      *Blanks       PReturncode
     C                   PARM                    PInDate
     C                   PARM                    POutDate
     C                   PARM                    PCvtdDate
 
     C                   Endsr
 
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SrCvtAmt - Convert amounts for Watch Engine Program           *
      *                                                               *
      * Called by: SrWtchCloancl, SrWtchLefeed, SrWtchLefeead,        *
      *            SrWtchCloanck, SrWtchLoamsdk                       *
      *                                                               *
      * Calls: ZaCvtAmt                                               *
      *                                                               *
      *****************************************************************
     C     SrCvtAmt      BegSr
 
     C                   EVAL      DBPROC =  'SrCvtAmt'
     C                   EVAL      POutAmt = *ZERO
     C                   EVAL      PCvtdAmt = *BLANKS
 
     C                   CALL      'ZACVTAMT'
     C                   PARM      *Blanks       ReturnCode
     C                   PARM                    PCcy
     C                   PARM                    PInAmt
     C                   PARM                    POutAmt
     C                   PARM                    PCvtdAmt
 
     C                   Endsr
      *********************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SrInitParm - Initialize 1st and 2nd Parameters of Watch List  *
      *              Engine                                           *
      *                                                               *
      * Called by: SrWtchCloancl, SrWtchLefeed, SrWtchLefeead,        *
      *            SrWtchCloanck, SrWtchLoamsdk                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrInitParm    BEGSR
 
     C                   EVAL      DBPROC =  'SrInitParm'
 
     C                   EVAL      W4IDEN = *BLANKS
     C                   EVAL      W4ITEM = *BLANKS
     C                   EVAL      W4BRCH = *BLANKS
     C                   EVAL      W4SYSM = *BLANKS
     C                   EVAL      W4FUNT = *BLANKS
     C                   EVAL      W4CNUM = *BLANKS
     C                   EVAL      W4CTYP = *BLANKS
     C                   EVAL      W4CUST = *BLANKS
     C                   EVAL      W4DEN1 = *BLANKS
     C                   EVAL      W4DEN2 = *BLANKS
     C                   EVAL      W4AMT1 = *ZERO
     C                   EVAL      W4AMT2 = *ZERO
     C                   EVAL      P_XML = *BLANKS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSndErr - Send error message to *SYSOPR                      *
      *                                                               *
      *****************************************************************
 
     C     SRSndErr      BEGSR
 
     C                   CALLB     'ZAMSGTOMSQ'
     C                   PARM                    RetCodeOut
     C                   PARM      'SD000013'    PMsg
     C                   PARM                    PMsgId
     C                   PARM      'GBSDUSRMSG'  PMsgF
     C                   PARM      'MOPERQ    '  PMsgQ
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0, AOCWCDR0, AOSARDR0                           *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  '*INZSR'
 
     C                   IN        SDSTAT
 
      ** Access bank details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PReturnCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile= 'SDBANKPD'
     C                   EVAL      DBKey = POption
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access SAR Details to see if Concord Interface Development (CCF001)
      ** is installed.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PReturnCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CCF001'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
 
     C                   IF        PReturnCode <> *BLANKS
     C                             AND PReturnCode <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY = 'CCF001'
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PReturnCode = *BLANKS
     C                   EVAL      CCF001 = 'Y'
     C                   ELSE
     C                   EVAL      CCF001 = 'N'
     C                   ENDIF
 
      ** Retrieve compliance watch configuration data file
 
     C                   CALL      'AOCWCDR0'
     C                   PARM      *BLANKS       PReturnCode
     C                   PARM      '*FIRST '     POption
     C     SDCWCD        PARM      SDCWCD        DSSDY
 
      ** Database error
 
     C                   IF        PReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile= 'SDCWCDPD'
     C                   EVAL      DBKey = POption
     C                   EVAL      DBase = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if function code 'LENDING' is to be processed for Bulk
      ** Checking today.
 
     C                   CALL      'AOWLCCR0'
     C                   PARM      *BLANKS       PReturnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      'LENDING '    PFuncCode
     C     SDWLCC        PARM      SDWLCC        DSFDY
 
     C                   IF        PReturnCode <> *BLANKS AND
     C                             PReturnCode <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDWLCCPD'
     C                   EVAL      DBKEY  =  PFuncCode
     C                   EVAL      DBASE  =  004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Key List for SDCWHTL0
 
     C     KSDCWHT       KLIST
     C                   KFLD                    KFunt
     C                   KFLD                    KIden
     C                   KFLD                    KBrch
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: SrWtchCloancl, SrWtchLefeed, SrWtchLefeead,            *
      *            SrWtchCloanck, SrWtchLoamsdk, *INZSR                   *
      *                                                                   *
      * Calls: DBERRCTL                                                   *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
      ** Close connection with the server
 
     C                   CALL      'SDOFACCL'
     C                   PARM      *BLANK        PRetCode
     C                   PARM                    PSrvContext
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
** Opentag - Open tags for XML
<Receipt Nostro>
<Receipt Intermed Bank>
<Receipt Ordering Bank>
<Receipt Ordering Cust>
<Payment Nostro>
<Payment Intermed Bank>
<Payment Ordering Bank>
<Payment Ordering Cust>
<Receiver Correspondent>
<Receiver>
<Account With Bank>
<Beneficiary>
<Details Of Payment>
** Closetag - Close tags for XML
</Receipt Nostro>
</Receipt Intermed Bank>
</Receipt Ordering Bank>
</Receipt Ordering Cust>
</Payment Nostro>
</Payment Intermed Bank>
</Payment Ordering Bank>
</Payment Ordering Cust>
</Receiver Correspondent>
</Receiver>
</Account With Bank>
</Beneficiary>
</Details Of Payment>
