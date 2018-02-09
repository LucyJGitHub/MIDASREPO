     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Watch List Bulk Data Checking module (RE)')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000011 - Watch List Bulk Data Checking Component for       *
      *             Retail                                            *
      *                                                               *
      *  Function:  This module will perform watch list checking on   *
      *             Retail files.                                     *
      *                                                               *
      *  Component of: SDC000011 (Watch List Bulk Data Checking       *
      *                Component for Retail)                          *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR702741           Date 02Feb11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
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
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
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
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
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
 
     FSTANDSB   IF   E             DISK    INFSR(*PSSR)
     F                                     USROPN
      ** Midas RE Standing Orders Detail
 
     FSDWLCCL0  UF   E           K DISK    INFSR(*PSSR)
      ** Watch List Checking Details by Function Code
 
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
 
     D Opentag         S             25    CTDATA DIM(8) PERRCD(1)
     D Clostag         S             25    CTDATA DIM(8) PERRCD(1)
      ** Watch List fields Open and Close tags
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Externally described DS for bank details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Externally described DS for Customer Details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** Externally described DS for SAR details
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** Externally described DS for General Ledger Details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Externally described DS for Currency Details
 
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)
      ** Midas SD Watch List Configuration Data File
 
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)
      ** Midas SD Functions for Watch List Checking details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access programs - short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS for access objects - long data structure
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** Data structure for data area SDSTAT
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** Data structure for data area SC24X7
 
     D PDSWLTD       E DS                  EXTNAME(SDWLTDPD)
 
     D P_XML           DS         30000
      ** Data Structure used as parameters for the Compliance Engine
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
      ** Parameter for AOBANKR0/AOSARDR0/AOCUSTR0
     D PRtcd           S              7
     D POptn           S              7
     D PSard           S              6
     D PKey1           S             10A
     D PKyst           S              7A
 
      ** Rate Change Frequency passed to ZFREQB
     D  PZFREQ         S              1A
 
      ** MIDAS day number
     D  PZDAYNO        S              5  0
 
      ** Currency code passed passed to ZFREQB
     D  PZCCY          S              3A
 
      ** Rate frequency day passed to ZFREQB
     D  PZMDAY         S              2  0
 
      ** Location code passed to ZFREQB
     D  ZLOC           S              3A
 
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
 
      ** 24X7 Availability
     D CSC011          S              1A
     D CCF001          S              1A
 
      ** Watch List Checking Details by Function Code Key Field
     D KFuncCode       S              8A
 
      ** Key Fields for SDCWHTL1
     D KFunt           S              8A
     D KIden           S             40A
     D KBrch           S              3A
 
      ** Parameter for ZACVTDATE
     D PInDate         S              5
     D POutDate        S               D
     D PCvtdDate       S             10
 
      ** Parameter for ZACVTAMT
     D PCcy            S              3
     D PInAmt          S             15
     D POutAmt         S             18  3
     D PCvtdAmt        S             16
 
      ** Parameter for AOCURRR0
     D PmRetn          S              7
     D PmOption        S              7
     D PmCcy           S              3
 
     D PFUNC           S              8
     D PRetCode        S              7A
     D PMsg            S            132A
     D PMsgId          S              7A
     D PMsgF           S             10A
     D PMsgQ           S             10A
     D PSrvContext     S               *
     D WDBASE          S              3  0
 
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
     C                   EVAL      WDBASE = 13
     C                   EVAL      PMsgId = 'USR9686'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*OPEN  '
     C                   EVAL      WDBASE = 14
     C                   EVAL      PMsgID = 'USR9687'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*NREADY'
     C                   EVAL      WDBASE = 15
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
 
      ** If watch list checking for 'Retail' is installed
 
     C                   IF        W1FUNC = 'STANDORD'
 
      ** When Periodic Watch List Checking Frequency is not equal to blanks and
      ** Next Periodic Check Date is less than or equal to run day number
 
     C                   IF        W1PFRQ <> *Blanks AND W1NPCD <= BJRDNB
 
      ** Process RE Transaction Details
 
     C                   EXSR      SrStand
 
      ** Update Watch List Checking Details by Function Code
 
     C                   EXSR      SRUPDWLCC
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Close connection with the server
 
     C                   CALL      'SDOFACCL'
     C                   PARM      *BLANK        PRetCode
     C                   PARM                    PSrvContext
 
      ** Return to the calling program.
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrStand - Process STANDSB                                     *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrStand       BEGSR
 
      ** Open Retail Transaction details file
 
     C                   OPEN      STANDSB
 
      ** For every live record read on STANDSB, send details to Compliance Watch
      ** Engine by calling SDWLENGN
 
     C                   READ      STANDSB
 
     C                   DOW       NOT %EOF (STANDSB)
 
     C                   IF        RECI <> '*'
      ** Access record in PF/SDCWHTL0
 
     C                   MOVEL     'STANDSB'     KFunt
 
     C                   MOVEL     STOR          KIden
     C                   MOVEL     BRCA          KBrch
 
     C     KCWHT         CHAIN     SDCWHTL0
 
      ** If record is not found
 
     C                   IF        NOT %FOUND(SDCWHTL0)
 
      ** If the last periodic check date < last watch list upload date,
      ** send details to Compliance Watch engine.
 
     C                   IF        W1LPCD < W1LUDT
 
     C                   EXSR      SRWtchStand
 
     C                   ENDIF
 
      ** Else, record already exist
 
     C                   ELSE
 
      ** If the last watch list check date < last watch list upload date,
      ** send details to Compliance Watch engine.
 
     C                   IF        W3LWCD < W1LUDT
 
     C                   EXSR      SRWtchStand
 
     C                   ENDIF
 
     C                   ENDIF
 
 
     C                   ENDIF
 
     C                   READ      STANDSB
     C                   ENDDO
 
      ** Close Futures and Options Transaction details file
 
     C                   CLOSE     STANDSB
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrWtchStand - Send Details to Compliance Watch Engine  for    *
      *               Every Live Record Read on STANDSB               *
      *                                                               *
      * Called by: SRStand                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrWtchStand   BEGSR
 
      ** Set-up parameter for Compliance Engine Program
 
     C                   EXSR      SrInitParm
 
      ** First Parameter
 
      ** Item Type Code
 
     C                   EVAL      W4ITEM = 'RESORD'
 
      ** Identifier
 
     C                   MOVEL     STOR          W4IDEN
 
      ** Branch
 
     C                   EVAL      W4BRCH = BRCA
 
      ** System
 
     C                   IF        CSC011 = 'Y'
     C                   EVAL      W4SYSM = S1MAIN
     C                   ELSE
     C                   EVAL      W4SYSM = LIBR
     C                   ENDIF
 
      ** Function Type
 
     C                   EVAL      W4FUNT = 'STANDSB'
 
      ** Counter Party Number
 
     C                   MOVEL     *Zeros        W4CNUM
 
      ** Get Customer Detail
 
     C                   MOVEL     CCUS          PKey1
     C                   CALL      'AOCUSTR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PKey1
     C                   PARM      *BLANK        PKyst
     C     SDCUST        PARM      SDCUST        DSSDY
 
      ** If Customer detail not found, issue DB error.
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  005
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SrWtchStand'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     BBCUST        W4CNUM
 
      ** Counterparty Type
 
      ** If Concord Interface Development is installed
      ** If Corporate Customer is 'Y', set Counterparty Type to 'C'
      ** Else, Counterparty Type to 'I'
 
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
 
     C                   IF        BBLICD <> *Blanks AND BBLICD <> W1IND1 AND
     C                             BBLICD <> W1IND2 AND BBLICD <> W1IND3 AND
     C                             BBLICD <> W1IND3 AND BBLICD <> W1IND4 AND
     C                             BBLICD <> W1IND5
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
 
     C                   ENDIF
 
      ** Counter Party Name
 
     C     BBCRNM        CAT       BBCRTN        W4CUST
 
      ** Deal Date
 
     C                   MOVE      '00000'       PInDate
     C                   EXSR      SrCvtDate
     C                   EVAL      W4DDAT = POutDate
 
      ** Value Date
 
     C                   MOVE      DFPY          PInDate
     C                   EXSR      SrCvtDate
     C                   EVAL      W4VDAT = POutDate
 
      ** Maturity Date
 
     C                   MOVE      '00000'       PInDate
     C                   EXSR      SrCvtDate
     C                   EVAL      W4MDAT = POutDate
 
      ** Denomination Side 1
 
     C                   EVAL      W4DEN1 = CCY
 
      ** Denomination Side 2
 
     C                   EVAL      W4DEN2 = *Blanks
 
      ** Amount Side 1
 
      ** Access currency details to check if denomination is a valid ccy
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        PmRetn
     C                   PARM      '*KEY'        PmOption
     C                   PARM      W4DEN1        PmCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Format Amount 1
 
     C                   IF        PmRetn = *BLANK
     C                   EVAL      PCcy = W4DEN1
     C                   ELSE
     C                   EVAL      PCcy = *Blanks
     C                   ENDIF
 
     C                   MOVE      AFPY          PInAmt
     C                   EXSR      SrCvtAmt
     C                   EVAL      W4AMT1 = PoutAmt
 
      ** Amount Side 2
 
      ** Access currency details to check if denomination is a valid ccy
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        PmRetn
     C                   PARM      '*KEY'        PmOption
     C                   PARM      W4DEN2        PmCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Format Amount 2
 
     C                   IF        PmRetn = *BLANK
     C                   EVAL      PCcy = W4DEN2
     C                   ELSE
     C                   EVAL      PCcy = *Blanks
     C                   ENDIF
 
     C                   EVAL      PInAmt = *Blanks
     C                   MOVE      *Blanks       PInAmt
     C                   EXSR      SrCvtAmt
     C                   EVAL      W4AMT2 = PoutAmt
 
      ** 2nd Parameter
 
     C                   EVAL      P_XML = *Blanks
 
      ** DR Account
 
     C                   IF        DACS <> *Zeros
     C                   MOVEL     DACS          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(1):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(1):0  P_XML
     C                   ENDIF
 
      ** DR Retail Account
 
     C                   IF        DRAN <> *Zeros
     C                   MOVEL     DRAN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(2):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(2):0  P_XML
     C                   ENDIF
 
      ** CR Account
 
     C                   IF        CACD <> *Zeros
     C                   MOVEL     CACD          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(3):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(3):0  P_XML
     C                   ENDIF
 
      ** CR Retail Account
 
     C                   IF        CRAN <> *Zeros
     C                   MOVEL     CRAN          PInput1
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(4):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(4):0  P_XML
     C                   ENDIF
 
      ** Payee
 
     C                   IF        PNAM <> *Blanks
     C                   EVAL      PInput1 = PNAM
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(5):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(5):0  P_XML
     C                   ENDIF
 
      ** Reference
 
     C                   IF        PAYR <> *Blanks
     C                   EVAL      PInput1 = PAYR
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(6):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(6):0  P_XML
     C                   ENDIF
 
      ** Payee Bank
 
     C                   IF        PAYB <> *Blanks
     C                   EVAL      PInput1 = PAYB
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(7):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(7):0  P_XML
     C                   ENDIF
 
      ** Payee Account
 
     C                   IF        PAYA <> *Blanks
     C                   EVAL      PInput1 = PAYA
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(8):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(8):0  P_XML
     C                   ENDIF
 
      ** Send Transaction Details to Compliance Watch by Calling the
      ** Engine Program.
 
     C                   CALL      'SDWLENGN'
     C                   PARM      *BLANK        PRetCode
     C                   PARM                    PSrvContext
     C                   PARM                    PDSWLTD
     C                   PARM                    P_XML
 
      ** Error calling SDWLENGN
 
     C                   IF        PRetCode <> *BLANK
     C                   SELECT
 
     C                   WHEN      PRetCode = '*ERROR '
     C                   EVAL      WDBASE = 7
 
     C                   WHEN      PRetCode = '*FOFEXE'
     C                   EVAL      WDBASE = 8
     C                   EVAL      PMsgId = 'USR9680'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*SRVNAM'
     C                   EVAL      WDBASE = 9
     C                   EVAL      PMsgId = 'USR9681'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*DBNAME'
     C                   EVAL      WDBASE = 10
     C                   EVAL      PMsgId = 'USR9682'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*USRNAM'
     C                   EVAL      WDBASE = 11
     C                   EVAL      PMsgId = 'USR9683'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*PASSWD'
     C                   EVAL      WDBASE = 12
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
      * Called by:                                                    *
      *                                                               *
      * Calls: SDCWLFMT                                               *
      *                                                               *
      *****************************************************************
 
     C     SrFormat      BEGSR
 
     C                   EVAL      POutput1 = *BLANKS
     C                   EVAL      POutput2 = *BLANKS
 
     C                   CALL      'SDCWLFMT'
     C                   PARM                    PRtcd
     C                   PARM                    PInput1
     C                   PARM                    PInput2
     C                   PARM                    PInput3
     C                   PARM                    PInput4
     C                   PARM                    PInput5
     C                   PARM                    PInput6
     C                   PARM                    PCurrency
     C                   PARM                    POutput1
     C                   PARM                    POutput2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUPDWLCC - Update Watch List Checking Details by Function    *
      *             Code                                              *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRUPDWLCC     BEGSR
 
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
     C                   PARM                    PRtcd
     C                   PARM                    PZFREQ
     C                   PARM                    PZDAYNO
     C                   PARM                    PZCCY
     C                   PARM      *BLANKS       ZLOC                                       AR702741
     C                   PARM                    PZMDAY
     C                   PARM                    BJDFIN
     C     SDGELR        PARM                    SDGELR
 
     C                   EVAL      W1NPCD = PZDAYNO
 
     C                   UPDATE    SDWLCCD0
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SrCvtDate - Convert dates to be used for Watch Engine Program *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: ZaCvtDate                                              *
      *                                                               *
      *****************************************************************
     C     SrCvtDate     BegSr
 
     C                   CALL      'ZACVTDATE'
     C                   Parm      *Blanks       Returncode
     C                   Parm                    PInDate
     C                   Parm                    POutDate
     C                   Parm                    PCvtdDate
 
     C                   Endsr
 
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SrCvtAmt - Convert amounts for Watch Engine Program           *
      *                                                               *
      * Called by:                                                    *
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
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SrInitParm - Initialize 1st and 2nd Parameters of Watch List  *
      *              Engine                                           *
      *                                                               *
      * Called by: SRWtchStand                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrInitParm    BEGSR
 
     C                   EVAL      W4IDEN = *Blanks
     C                   EVAL      W4ITEM = *Blanks
     C                   EVAL      W4BRCH = *Blanks
     C                   EVAL      W4SYSM = *Blanks
     C                   EVAL      W4FUNT = *Blanks
     C                   EVAL      W4CNUM = *Blanks
     C                   EVAL      W4CTYP = *Blanks
     C                   EVAL      W4CUST = *Blanks
     C                   EVAL      W4DEN1 = *Blanks
     C                   EVAL      W4DEN2 = *Blanks
     C                   EVAL      W4AMT1 = *Zeros
     C                   EVAL      W4AMT2 = *Zeros
     C                   EVAL      P_XML = *Blanks
 
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
     C                   PARM      'SD000011'    PMsg
     C                   PARM                    PMsgId
     C                   PARM      'GBSDUSRMSG'  PMsgF
     C                   PARM      'MOPERQ    '  PMsgQ
 
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
 
     C                   IN        SDSTAT
 
      ** Access bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile= 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrieve compliance watch configuration data file
 
     C                   CALL      'AOCWCDR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDCWCD        PARM      SDCWCD        DSSDY
 
      ** Database error
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile= 'SDCWCDPD'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access SAR Details to see if Concord Interface Development (CCF001)
      ** is installed.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CCF001'      PSard
     C     SCSARD        PARM      SCSARD        DSSDY
 
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
 
     C                   IF        PRtcd <> *Blanks AND PRtcd <> '*NRF  '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY = 'CCF001'
     C                   EVAL      DBASE = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *Blanks
     C                   EVAL      CCF001 = 'Y'
     C                   ELSE
     C                   EVAL      CCF001 = 'N'
     C                   ENDIF
 
      ** Access SAR Details to see if 24x7 Midas Availability (CSC011)
      ** is installed.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC011'      PSard
     C     SCSARD        PARM      SCSARD        DSSDY
 
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
 
     C                   IF        PRtcd <> *Blanks AND PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBASE = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *Blanks
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SC24X7
     C                   ELSE
     C                   EVAL      CSC011 = 'N'
     C                   ENDIF
 
      ** Check if function code is being monitored by compliance watch.
 
     C                   CALL      'AOWLCCR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      'STANDORD'    PFUNC
     C     SDWLCC        PARM      SDWLCC        DSFDY
 
     C                   IF        PRtcd <> '*NRF    ' AND PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDWLCCPD'
     C                   EVAL      DBASE = 006
     C                   EVAL      DBKEY = PFUNC
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **  Used for SDCWHTL1
     C     KCWHT         KLIST
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
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
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
** OpenTag - OPEN TAGS for XML
<DR Account>
<DR Retail Account>
<CR Account>
<CR Retail Account>
<Payee>
<Reference>
<Payee Bank>
<Payee Account>
** CloseTag - CLOSE TAGS for XML
</DR Account>
</DR Retail Account>
</CR Account>
</CR Retail Account>
</Payee>
</Reference>
</Payee Bank>
</Payee Account>
