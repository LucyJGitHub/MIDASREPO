     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Watch list bulk data checking module (FF)')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000012 - Watch List Bulk Data Checking Component for       *
      *             Futures and Options                               *
      *                                                               *
      *  Function:  This module will perform watch list checking on   *
      *             Futures and Options file.                         *
      *                                                               *
      *  Component of: SDC000012 (Watch List Bulk Data Checking       *
      *                Component for Futures and Options)             *
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
      *  Use of indicators                                            *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SrTrans       - Process TRANS                                 *
      * SrWtchTrans   - Send Details to Compliance Watch Engine for   *
      *                 Live Record Read on TRANS                     *
      * SrFormat      - Convert Settlement Details to Customer Name   *
      *                 and Address                                   *
      * SrUpdWlcc     - Update Watch List Checking Details by         *
      *                 Function                                      *
      * SrCvtDate     - Convert dates to be used for Watch Engine     *
      *                 Program                                       *
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
     F                                     USROPN
     ** Midas Compliance Watch Hit List(FType/Identifier/Branch)
 
     FTRANS2    IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      ** Midas FF Transaction details
 
     FSDWLCCL0  UF   E           K DISK    INFSR(*PSSR)
      ** Watch List Checking Details by Function Code
 
     FTRSET1    IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      ** Midas FF Transaction Settlement details
 
     FMKCTL     IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      ** Midas FF Market Control details
 
     FINTYP     IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      ** Midas FF Instrument Types
 
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
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D Opentag         S             25    CTDATA DIM(6) PERRCD(1)
     D Clostag         S             25    CTDATA DIM(6) PERRCD(1)
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
     D PFunc           S              8
     D PKey1           S             10
     D PKyst           S              7
 
      ** Rate Change Frequency passed to ZFREQB
     D  PZFREQ         S              1
 
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
 
      ** 24X7 Availability  and CCF001
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
     D PAMFlot         S             18  3
     D PCurr           S              3A
     D PInAmt          S             15A
     D POutAmt         S             16A
     D PRtnCode        S              7A
 
      ** Parameter for AOCURRR0
     D PmRetn          S              7
     D PmOption        S              7
     D PmCcy           S              3
 
     D WITEM           S              2
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
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
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
 
     C                   IF        W1FUNC = 'FUTURES '
 
      ** When Periodic Watch List Checking Frequency is not equal to blanks and
      ** Next Periodic Check Date is less than or equal to run day number
 
     C                   IF        W1PFRQ <> *Blanks AND W1NPCD <= BJRDNB
 
      ** Process FF Transaction Details
 
     C                   EXSR      SrTrans
 
      ** Update Watch List Checking Details by Function Code
 
     C                   EXSR      SRUPDWLCC
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Close connection with the server
 
     C                   CALL      'SDOFACCL'
     C                   PARM      *BLANK        PRetCode
     C                   PARM                    PSrvContext
 
      ** Return to the calling program
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrTrans - Process TRANS                                       *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRWtchTrans                                            *
      *                                                               *
      *****************************************************************
 
     C     SrTrans       BEGSR
 
      ** Open Futures and Options Transaction details file
 
     C                   OPEN      SDCWHTL0
     C                   OPEN      TRANS2
     C                   OPEN      TRSET1
     C                   OPEN      MKCTL
     C                   OPEN      INTYP
 
      ** For every live record read on TRANS, send details to Compliance Watch
      ** Engine by calling SDWLENGN
 
     C                   READ      TRANS2
 
     C                   DOW       NOT %EOF (TRANS2)
 
     C                   IF        RECI = 'D'
 
      ** Access record in PF/SDCWHTL0
      ** Access record in PF/SDCWHTL0
 
     C                   MOVEL     'TRANSD  '    KFunt
     C                   MOVEL     TNBR          KIden
     C                   MOVEL     BRCA          KBrch
 
     C     KCWHT         CHAIN     SDCWHTL0
 
      ** If record is not found
 
     C                   IF        NOT %FOUND(SDCWHTL0)
 
      ** If the last periodic check date < last watch list upload date,
      ** send details to Compliance Watch engine
 
     C                   IF        W1LPCD < W1LUDT
 
     C                   EXSR      SRWtchTrans
 
     C                   ENDIF
 
      ** Else, record already exists
 
     C                   ELSE
 
      ** If the last watch list check date < last watch list upload date,
      ** send details to Compliance Watch engine
 
     C                   IF        W3LWCD < W1LUDT
 
     C                   EXSR      SRWtchTrans
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      TRANS2
 
     C                   ENDDO
 
      ** Close Futures and Options Transaction details file
 
     C                   CLOSE     SDCWHTL0
     C                   CLOSE     TRANS2
     C                   CLOSE     TRSET1
     C                   CLOSE     MKCTL
     C                   CLOSE     INTYP
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrWtchTrans - Send Details to Compliance Watch Engine  for    *
      *               Every Live Record Read on TRANS                 *
      *                                                               *
      * Called by: SRTrans                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrWtchTrans   BEGSR
 
      ** Set-up parameter for Compliance Engine Program
 
      ** First Parameter
 
     C                   EXSR      SrInitParm
 
      ** Select Item Type Code
 
     C                   SELECT
 
      ** For item types - Exercised Trades
     C                   WHEN      TRTY = 'E'
     C                   EVAL      W4ITEM = 'FFXER'
 
     C                   OTHER
 
      ** For item types - Exchange Traded
     C                   MOVEL     ISTT          WITEM
     C     WITEM         CHAIN     MKCTL
 
     C                   IF        %FOUND(MKCTL)
     C                   EVAL      W4ITEM = 'FFEFO'
     C                   ELSE
 
      ** For item types - Non-ccy OTC
     C     ISTT          CHAIN     INTYP
 
     C                   IF        %FOUND(INTYP)
     C                   IF        ISPT = 4 OR ISPT = 6
     C                   EVAL      W4ITEM = 'FFOTCO'
     C                   ENDIF
 
      ** For item types - Currency OTC
     C                   IF        ISPT = 5
     C                   EVAL      W4ITEM = 'FFOTC'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSL
 
      ** Identifier
 
     C                   MOVEL     TNBR          W4IDEN
 
      ** Branch
 
     C                   EVAL      W4BRCH = BRCA
 
      ** System
 
     C                   IF        CSC011 = 'Y'
     C                   EVAL      W4SYSM = S1MAIN
     C                   ELSE
     C                   EVAL      W4SYSM = LIBR
     C                   ENDIF
 
      ** Function Type
 
     C                   EVAL      W4FUNT = 'TRANSD '
 
      ** Counter Party Number
 
     C**********         IF        CUSC <> 0                                                  CSD027
     C                   IF        CUSC <> *BLANKS                                            CSD027
 
     C                   MOVEL     CUSC          W4CNUM
 
      ** Get Customer Detail
 
     C                   MOVEL     CUSC          PKey1
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PKey1
     C                   PARM      *BLANK        PKyst
     C     SDCUST        PARM      SDCUST        DSSDY
 
      ** If Customer detail not found, issue DB error
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  PKey1
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  005
     C                   EVAL      DBMOD  =  PSProcMod
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
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
      **     Else, set Counterparty Type to 'I'
 
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
 
     C                   ENDIF
 
      ** Deal Date
 
     C                   MOVE      TRSD          PInDate
     C                   EXSR      SrCvtDate
     C                   EVAL      W4DDAT = POutDate
 
      ** Value Date
 
     C                   MOVE      VALD          PInDate
     C                   EXSR      SrCvtDate
     C                   EVAL      W4VDAT = POutDate
 
      ** Maturity Date
 
     C                   MOVE      '00000'       PInDate
     C                   EXSR      SrCvtDate
     C                   EVAL      W4MDAT = POutDate
 
      ** Denomination Side 1
 
     C                   EVAL      W4DEN1 = ISTT
 
      ** Denomination Side 2
 
     C                   EVAL      W4DEN2 = *Blanks
 
      ** Amount Side 1
 
     C                   MOVE      NUCO          PInAmt
     C                   EVAL      PCurr = *BLANKS
     C                   EXSR      SrCvtAmt
     C                   EVAL      W4AMT1 = PAMFlot
 
      ** Amount Side 2
 
     C                   EVAL      W4AMT2 = *Zeros
 
      ** 2nd Parameter
 
     C                   EVAL      P_XML = *Blanks
 
     C     TNBR          CHAIN     TRSET1
 
     C                   IF        %FOUND(TRSET1)
 
      ** Broker Settlement Account
 
     C                   IF        BSLA <> *Blanks
     C                   EVAL      PInput1 = BSLA
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(1):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(1):0  P_XML
     C                   ENDIF
 
      ** Broker for Account Of
 
     C                   IF        BFAO <> *Blanks
     C                   EVAL      PInput1 = BFAO
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(2):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(2):0  P_XML
     C                   ENDIF
 
      ** Broker Counterparty Nostro
 
     C                   IF        BCPN <> *Blanks
     C                   EVAL      PInput1 = BCPN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(3):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(3):0  P_XML
     C                   ENDIF
 
      ** Customer Settlement Account
 
     C                   IF        CSLA <> *Blanks
     C                   EVAL      PInput1 = CSLA
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(4):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(4):0  P_XML
     C                   ENDIF
 
      ** Customer for Account Of
 
     C                   IF        CFAO <> *Blanks
     C                   EVAL      PInput1 = CFAO
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(5):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(5):0  P_XML
     C                   ENDIF
 
      ** Customer Counterparty Nostro
 
     C                   IF        CCPN <> *Blanks
     C                   EVAL      PInput1 = CCPN
     C                   EXSR      SrFormat
     C     P_XML         CAT       OpenTag(6):0  P_XML
     C     P_XML         CAT       POutput1:0    P_XML
     C     P_XML         CAT       ClosTag(6):0  P_XML
     C                   ENDIF
 
     C                   ENDIF
 
      ** Send Transaction Details to Compliance Watch by Calling the
      ** Engine Program
 
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
      * SrFormat - Convert Settlement details to Customer Name and    *
      *            Address                                            *
      *                                                               *
      * Called by: SrWtchTrans                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrFormat      BEGSR
 
     C                   EVAL      POutput1 = *Blanks
     C                   EVAL      POutput2 = *Blanks
 
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
      * SrUpdWlcc - Update Watch List Checking Details by Function    *
      *             Code                                              *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrUpdWlcc     BEGSR
 
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
 
     C                   CALLB     'ZACVTDATE'
     C                   Parm      *Blanks       Returncode
     C                   Parm                    PInDate
     C                   Parm                    POutDate
     C                   Parm                    PCvtdDate
 
     C                   Endsr
 
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      *  SrCvtAmt - Convert amounts for Watch Engine Program          *
      *                                                               *
      *****************************************************************
     C     SrCvtAmt      BEGSR
 
     C                   CALL      'ZACVTAMT'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM                    PCurr
     C                   PARM                    PInAmt
     C                   PARM                    PAMFLOT
     C                   PARM      *ZEROS        POutAmt
 
     C                   ENDSR
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
     C                   PARM      'SD000012'    PMsg
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
 
      **  Used for SDCWHTL1
 
     C     KCWHT         KLIST
     C                   KFLD                    KFunt
     C                   KFLD                    KIden
     C                   KFLD                    KBrch
 
      ** Access bank details
 
     C                   CALLB     'AOBANKR0'
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
 
     C                   CALLB     'AOCWCDR0'
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
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CCF001'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
 
     C                   IF        PRtcd <> *Blanks AND PRtcd <> '*NRF   '
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
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC011'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
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
 
     C                   CALLB     'AOWLCCR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      'FUTURES '    PFUNC
     C     SDWLCC        PARM      SDWLCC        DSFDY
 
     C                   IF        PRtcd <> '*NRF    ' AND PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDWLCCPD'
     C                   EVAL      DBASE = 006
     C                   EVAL      DBKEY = PFUNC
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
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
** Opentag - Open tags for XML
<Broker Settlement Acct>
<Broker for Account Of>
<Broker Counter Nostro>
<Cust Settlement Acct>
<Cust for Account Of>
<Cust Counter Nostro>
** Closetag - Close tags for XML
</Broker Settlement Acct>
</Broker for Account Of>
</Broker Counter Nostro>
</Cust Settlement Acct>
</Cust for Account Of>
</Cust Counter Nostro>
