     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas DL CLS Schedule Events File Creation')           *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL0404 - Midas DL CLS Schedule Events File Creation          *
      *                                                               *
      *  Function:  This program is called by DLC0607 to generate     *
      *             Events for CLS Pay-in Schedule.                   *
      *                                                               *
      *  Called By: DLC0607  - Events File Creation                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3644            Date 12Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 02Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008  *CREATE    Date 02May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CAP084 - Synchronous calling of APIs                         *
      *  CDL008 - Continuous Linked Settlement                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End of file                                     *
      *    02         No record found                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * SRDBErr - Database error processing                           *
      * SRMapFld - Map CLS fields to Events file                      *
      * SRWrite  - Write record to Events creation detail file.       *
      * SRUpdTrl - Update/Write Events creation trailer file.         *
      * SRAudit  - Generate audit report.                             *
      * SRNost -  Access nostro details                               *
      * SRCycd -  Access Currency code details                        *
      * SRCust -  Access Customer details                             *
      * SRBrch -  Access Branch code details                          *
      * SRCtry -  Access Country code details                         *
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
      ** CLS pay schedule header file
     FFXCLSPSHL1IF   E           K DISK    INFSR(*PSSR)
      *
      ** DL Events creation file trailer
     FEVNTXZZ   UF A E             DISK    INFSR(*PSSR)
      *
      ** DL Events creation file header
     FEVNTXEC   UF A E             DISK    INFSR(*PSSR)
      *
      ** DL Events creation file detail
     FEVNTXED   O    E             DISK    INFSR(*PSSR)
      *
      ** CLS Schedule Events file creation - audit
     FDL0404AU  O    E             PRINTER
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS for nostro details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      *
      ** External DS for general ledger ICD details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  W7ACD1       E                     EXTFLD(QQACCD)                                     CGL029
      *
      ** External DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** External DS for customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** External DS for Country code details
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      *
      ** External DS for Branch code details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  W7DFAC       E                     EXTFLD(QQDFAC)                                     CGL029
      *
      ** External DS for modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** External DS for account details
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(A)
      *
      ** External DS for Dealing Details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D  W7ACD2       E                     EXTFLD(QQACCD)                                     CGL029
      *
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             01     01
     D  NoRecFnd              02     02
      *
      ** Hash totalling fields
     D                 DS
     D  WWAmt                  1     15  3
     D  WWAmtI                16     30  0
     D  WWAmtD                31     33  0
     D  WWTotD                34     36  0
     D  WWTotI                37     51  0
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Work parameters
     D PPNOI           S              1A
     D PAcSn           S              2A
     D PNoNb           S              2A
     D PBrCd           S              3A
     D PCyCd           S              3A
     D*PAccn****       S              4A                                                      CGL029
     D PAccn           S             10A                                                      CGL029
     D PCust           S              6A
     D PRtCd           S              7A
     D POptn           S              7A
     D PCsSn           S             10A
     D PRetl           S             10A
     D PCnum           S             10A
     D PKyst           S              7A
     D PBrch           S              3A
     D PCnCd           S              2A
      *
      ** Work variable
     D WRun            S              1A
     D WDumNostro      S              1A
     D WDecimal        S              4P 0 INZ(*ZEROS)
     D WDecSum         S              4P 0 INZ(*ZEROS)
     D WGenRec         S              5S 0 INZ(*ZEROS)
     D WControlDat     S              5P 0
     D WAmt            S             15P 3
     D WInteger        S             15P 0 INZ(*ZEROS)
     D N               S              1  0
     D WCDP            S              1  0
     D WMDI            S              1
     D Wrk159          S             15P 9
     D WBCXR           S             13P 8
     D WERLC           S             13P 8
      *
      ** Pointer for the indicator array
     D IndicatorP      S               *   INZ(%Addr(*IN))
 
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
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Position pointer to the first record.
      *
     C     *LOVAL        SETLL     FXCLSPSHL1
      *
      ** Read pay schedule header record.
      *
     C                   READ      FXCLSPSHL1                             01
      *
      ** Repeat while valid record.
      *
     C                   DOW       EndOfFile = False
 
     C                   IF        PYVALD > WControlDat AND PYRECI = 'D'
     C                             AND (PYTOTP <> *ZERO OR PYTOTR <> *ZERO)                   CAP084
      *
      ** Access nostro detail to retrieve CLS dummy nostro.
      *
     C                   EVAL      PNonb = PYNOST
     C                   EXSR      SRNost
      *
      ** Access currency details
      *
     C                   EVAL      PCyCd = PYCCY
     C                   EXSR      SRCyCd
      *
      ** Access Customer details
      *
     C                   MOVE      *BLANKS       PCnum
     C                   MOVE      A7CUST        PCnum
     C                   EXSR      SRCust
      *
      ** Access branch details
      *
     C                   EXSR      SRBrch
      *
      ** Access Country code details
      *
     C                   EXSR      SRCtry
      *
     C                   CLEAR                   EVNTXEDF
      *
      ** CLS PAYMENT
      ** ===========
     C                   IF        PYTOTP <> *ZEROS
     C                   Z-ADD     PYTOTP        EAMT
     C                   MOVE      'I'           INOI
     C                   MOVE      'CPV1'        ETYP
     C                   ENDIF
      *
      ** CLS RECEIPT
      ** ===========
     C                   IF        PYTOTR <> *ZEROS
     C                   Z-ADD     PYTOTR        EAMT
     C                   MOVE      'O'           INOI
     C                   MOVE      'CRV1'        ETYP
     C                   ENDIF
      *
     C                   EVAL      WDumNostro = 'Y'
      *
      ** Map fields to event file for CLS dummy nostro
      *
     C                   EXSR      SRMapFld
      *
      ** Write record to Events file for dummy nostro
      *
     C                   EXSR      SRWrite
      *
      ** Access nostro with CLS currency and pay/receive nostro
      *
     C                   EVAL      PNonb = A7LPR
     C                   EXSR      SRNost
      *
      ** Access currency details
      *
     C                   EVAL      PCyCd = PYCCY
     C                   EXSR      SRCyCd
      *
      ** Access customer details for CLS Pay/Rcv Nostro
      *
     C                   MOVE      *BLANKS       PCnum
     C                   MOVE      A7CUST        PCnum
     C                   EXSR      SRCust
      *
      ** Access branch details for CLS Pay/Rcv Nostro
      *
     C                   EXSR      SRBrch
      *
      ** Access Country code details
      *
     C                   EXSR      SRCtry
      *
     C                   CLEAR                   EVNTXEDF
      *
      ** CLS PAYMENT
      ** ===========
     C                   IF        PYTOTP <> *ZEROS
     C                   Z-ADD     PYTOTP        EAMT
     C                   MOVE      'O'           INOI
     C                   MOVE      'CPV1'        ETYP
     C                   ENDIF
      *
      ** CLS RECEIPT
      ** ===========
     C                   IF        PYTOTR <> *ZEROS
     C                   Z-ADD     PYTOTR        EAMT
     C                   MOVE      'I'           INOI
     C                   MOVE      'CRV1'        ETYP
     C                   ENDIF
      *
     C                   EVAL      WDumNostro = 'N'
      *
      ** Map fields to event file for CLS Pay/Rcv Nostro
      *
     C                   EXSR      SRMapFld
      *
      ** Write record to Events file for dummy nostro
      *
     C                   EXSR      SRWrite
 
     C                   ENDIF
      *
      ** Read next pay schedule header record.
     C                   READ      FXCLSPSHL1                             01
 
     C                   ENDDO
      *
      ** Update Events creation trailer file.
      *
     C                   EXSR      SRUpdTrl
      *
      ** Write audit report
      *
     C                   EXSR      SRAudit
      *
      ** Terminate program
      *
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMapFld - Map fields to CLS Events file                     *
      *                                                               *
      *****************************************************************
     C     SRMapFld      BEGSR
      *
      ** Record id.
     C                   EVAL      RECI = 'D'
      *
      ** Deal number
     C                   EVAL      DLNO = 999999
      *
      ** Customer number
     C                   EVAL      CUNR = A7CUST
      *
      ** Event date
     C                   EVAL      EDAT = PYVALD
      *
      ** Event currency
     C                   EVAL      ECCY = PYCCY
      *
      ** Event Sort sequence
     C                   EVAL      ECSS = A6SSNB
      *
      ** Branch code
     C                   EVAL      BRCA = A7BRCD
      *
      ** Event Branch
     C                   EVAL      EBRC = A7BRCD
      *
      ** Exchange Rate
     C                   Z-ADD     1             EXRT
      *
      ** Dealt base ccy equivalent of event amount
     C                   EVAL      WCDP = A6NBDP
     C                   EVAL      WMDI = A6MDIN
     C                   EVAL      WBCXR = A6SPRT
     C                   EVAL      WERLC = A6ERLC
     C                   EVAL      PCyCd = BJCYCD
     C                   EXSR      SrCyCd
      *
     C                   IF        ECCY <> BJCYCD
     C                   EVAL      N = WCDP - A6NBDP
     C                   EVAL      N = N + 4
     C                   IF        WMDI = 'M'
     C                   EVAL      WRK159 = WBCXR/POWER(N)
     C                   EVAL      DBCE = EAMT * WRK159
     C                   ELSE
     C                   EVAL      WRK159 = WBCXR * POWER(N)
     C                   EVAL      DBCE = EAMT/WRK159
     C                   ENDIF
     C                   EVAL      BCEQ = DBCE
     C                   ELSE
     C                   Z-ADD     EAMT          DBCE
     C                   Z-ADD     EAMT          BCEQ
     C                   ENDIF
     C                   EVAL      DBCR = WBCXR
      *
      ** Determine Spot Limit ccy equivalent of event amount
     C                   IF        ECCY <> BNCYCD
     C                   EVAL      PCyCd = BNCYCD
     C                   EXSR      SrCyCd
     C                   EVAL      N = WCDP - A6NBDP + 4
     C                   IF        WMDI = 'M'
     C                   EVAL      WRK159 = WERLC/POWER(N)
     C                   EVAL      LCEQ = EAMT * WRK159
     C                   ELSE
     C                   EVAL      WRK159 = WERLC * POWER(N)
     C                   EVAL      LCEQ = EAMT/WRK159
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     EAMT          LCEQ
     C                   ENDIF
      *
      ** Settlement type
     C                   EVAL      SETP = 08
     C                   EVAL      OSAC1 = PNonb
      *
      ** Full instruction present indicator
     C                   EVAL      FIPI = 'Y'
      *
      ** Facility type indicator
     C                   EVAL      FCTI = 'N'
      *
      ** Rollover indicator
     C                   EVAL      RLVI = 'N'
      *
      ** Parent Customer Number
     C                   EVAL      PTNU = BBPCNB
      *
      ** Parent Indicator
     C                   IF        BBPAIN = 'P'
     C                   Z-ADD     1             PARI
     C                   ELSE
     C                   Z-ADD     0             PARI
     C                   ENDIF
      *
      ** Customer Report Name
     C                   EVAL      CRNM = BBCRNM
      *
      ** Customer Report Town
     C                   EVAL      CTWN = BBCRTN
      *
      ** Customer Alpha Sort key
     C                   EVAL      CASK = BBCASC
      *
      ** Country of citizenship
     C                   EVAL      CCTZ = BBCNCZ
      *
      ** Country of location
     C                   EVAL      CLOC = BBCOLC
      *
      ** Access Customer details for Parent if not blank for Parent's
      ** report name, town and alpha sort key
      *
     C                   IF        BBPCNB <> *BLANKS
     c                   MOVE      *BLANKS       PCnum
     C                   MOVE      BBPCNB        PCnum
     C                   EXSR      SrCust
     C                   EVAL      PRNM = BBCRNM
     C                   EVAL      PTWN = BBCRTN
     C                   EVAL      PASK = BBCASC
     C                   ENDIF
      *
      ** Region Code
     C                   EVAL      REGC = A4RGCD
      *
      ** Federal Funds Value date
     C                   EVAL      FFVD = PYVALD
      *
      ** Counterparty Customer
     C                   MOVE      A7CUST        CPCN
      *
      ** Originating branch
     C                   EVAL      ORBR = A7BRCD
      *
      ** Company originating branch, booking branch, originating branch
     C                   EVAL      COBB = A8CMCD
     C                   EVAL      COOB = A8CMCD
     C                   EVAL      ECPY = A8CMCD
      *
      ** Multi-branching Event
     C                   EVAL      IBRE = 'N'
      *
      ** Inter Company Event flag
     C                   EVAL      ICYE = 'Y'
      *
      ** Branch Entity level
     C                   EVAL      ELVB = 'B'
      *
      ** Company Entity level
     C                   EVAL      ELVC = 'C'
      *
      ** System Entity Level
     C                   EVAL      ELVS = 'S'
      *
      ** Our Settlement branch
     C                   EVAL      OSBR = A7BRCD
      *
      *
      ** Profit centre
     C                   IF        WDumNostro = 'Y' AND
     C                             BGN0ST = 'Y'
     C                   MOVE      *BLANKS       PAcSn
     C                   MOVE      A7ACSN        PAcSn
      *
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      *BLANKS       PRetl
     C                   PARM      A7CUST        PCust
     C                   PARM      A7CYCD        PCyCd
     C                   PARM      A7ACCD        PAccn
     C                   PARM                    PAcSn
     C                   PARM      A7BRCD        PBrCd
     C     SDACCT        PARM      SDACCT        DSSDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PBrCd + PCust + PCyCd + PAccn + PAcSn
     C                   EVAL      DBFILE = 'ACCNTAB'
     C                   EVAL      DBASE = 010
     C                   OUT       LDA
     C                   EXSR      SRDBErr
     C                   ELSE
     C                   EVAL      PRFC = APRFC
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      PRFC = PYPRFC
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrite - Write record to Events file.                       *
      *                                                               *
      *****************************************************************
     C     SRWrite       BEGSR
      *
      ** Keep running total of records generated for trailer.
      *
     C                   EVAL      WGenRec = WGenRec + 1
      *
      ** Hash total
      *
     C                   EVAL      WAmt = 0
     C                   EVAL      WAmt = EAMT / 1000
     C                   EVAL      WWAmt = WAmt
 
     C                   Z-ADD     WInteger      WWTotI
     C                   Z-ADD     WDecimal      WWTotD
 
     C                   IF        WWAmt < 0
     C                   Z-SUB     WWAmt         WWAmt
     C                   ENDIF
 
     C                   Z-ADD     WWAmt         WWAmtI
     C                   MOVE      WWAmt         WWAmtD
     C                   ADD       WWAmtD        WWTotD
 
     C                   IF        WWTotD < WWAmtD
     C                   ADD       1             WWTotI
     C                   ENDIF
 
     C                   ADD       WWAmtI        WWTotI
     C                   Z-ADD     WWTotI        WInteger
     C                   Z-ADD     WWTotD        WDecimal
      *
      ** Write record to Events creation detail file.
      *
     C                   WRITE     EVNTXEDF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdTrl - Update Events creation file - Trailer.            *
      *                                                               *
      *****************************************************************
     C     SRUpdTrl      BEGSR
      *
      ** Update trailer record if found, otherwise write record.
      *
     C     1             CHAIN     EVNTXZZ                            02
 
     C                   IF        NoRecFnd = False
     C                   EVAL      NORE = NORE + WGenRec
     C                   EVAL      HRWN  = HRWN  + WInteger
     C                   EVAL      WDecSum = HRDC + WDecimal
      *
      ** If decimal exceeds 1000, carry 1 to integer. Amount in
      ** excess of 1000 is moved back on decimal.
      *
     C                   IF        WDecSum > 1000
     C                   EVAL      HRDC = WDecSum - 1000
     C                   EVAL      HRWN = HRWN + 1
     C                   ELSE
     C                   Z-ADD     WDecSum       HRDC
     C                   ENDIF
      *
     C                   UPDATE    EVNTXZZF
     C                   ELSE
     C                   EVAL      RECI = 'T'
     C                   Z-ADD     WGenRec       NORE
     C                   ADD       2             NORE
     C                   Z-ADD     WInteger      HRWN
     C                   Z-ADD     WDecimal      HRDC
     C                   WRITE     EVNTXZZF
     C                   EVAL      RECI = 'A'
     C                   WRITE     EVNTXECF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNost - Access nostro details                               *
      *                                                               *
      *****************************************************************
     C     SRNost        BEGSR
      *
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      *BLANKS       PCust
     C                   PARM      PYCCY         PCyCd
     C                   PARM      *BLANKS       PAccn
     C                   PARM      *BLANKS       PAcSn
     C                   PARM                    PNoNb
     C                   PARM      *BLANKS       PBrCd
     C                   PARM      *BLANKS       PCsSn
     C                   PARM      *BLANKS       PPNOI
     C     SDNOST        PARM      SDNOST        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PCyCd + PNoNb
     C                   EVAL      DBFILE = 'SDNOSTPD'
     C                   EVAL      DBASE = 005
     C                   OUT       LDA
     C                   EXSR      SRDBErr
 
     C                   ENDIF
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCyCd - Access Currency code details                        *
      *                                                               *
      *****************************************************************
     C     SRCyCd        BEGSR
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCyCd
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtCd <> *BLANKS
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PCyCd
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 006
     C                   OUT       LDA
     C                   EXSR      SRDBErr
 
     C                   ENDIF
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCust - Access Customer details                             *
      *                                                               *
      *****************************************************************
     C     SRCust        BEGSR
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCnum
     C                   PARM      *BLANKS       PKyst
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        PRtCd <> *BLANKS
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PCnum
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 007
     C                   OUT       LDA
     C                   EXSR      SRDBErr
 
     C                   ENDIF
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBrch - Access Branch Code details                          *
      *                                                               *
      *****************************************************************
     C     SRBrch        BEGSR
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      A7BRCD        PBrch
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
     C                   IF        PRtCd <> *BLANKS
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PBrch
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBASE = 008
     C                   OUT       LDA
     C                   EXSR      SRDBErr
 
     C                   ENDIF
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCtry - Access Country code details                         *
      *                                                               *
      *****************************************************************
     C     SRCtry        BEGSR
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BBCNCZ        PCnCd
     C     SDCTRY        PARM      SDCTRY        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PCnCd
     C                   EVAL      DBFILE = 'SDCTRYPD'
     C                   EVAL      DBASE = 009
     C                   OUT       LDA
     C                   EXSR      SRDBErr
 
     C                   ENDIF
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Generate audit report processing.                  *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
     C                   IF        WGenRec <> 0
     C                   Z-ADD     WGenRec       RCOUNT
     C                   Z-ADD     WInteger      RINTEGER
     C                   Z-ADD     WDecimal      RDECIMAL
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
     C                   ELSE
     C                   WRITE     HEADAU
     C                   WRITE     NODTLS
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
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
      *
      ** Access bank details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      SRDBErr
     C                   ENDIF
      *
      ** Access general ledger ICD details.
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDGELR        PARM      SDGELR        DSSDY
      *
      ** Database error.
      *
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      SRDBErr
     C                   ENDIF
      *
      ** Access Midas Modules details.
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Database error.
      *
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBASE = 003
     C                   OUT       LDA
     C                   EXSR      SRDBErr
     C                   ENDIF
      *
      ** Access Dealing Details
      *
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      ** Database Error
      *
     C     PRtcd         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDDEALPD'
     C                   EVAL      DBASE = 004
     C                   OUT       LDA
     C                   EXSR      SRDBErr
     C                   ENDIF
      *
      ** Setup control date
      *
     C                   EVAL      WControlDat = BJDNWD - 1
     C                   IF        BKANWD = '2'
     C                   IF        BKAPDT <= WControlDat
     C                   Z-ADD     BKAPDT        WControlDat
     C                   ELSE
     C                   Z-ADD     BJRDNB        WControlDat
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDBErr - Database error processing                          *
      *                                                               *
      *****************************************************************
     C     SRDBErr       BEGSR
 
     C                   WRITE     HEADAU
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   WRITE     DBERROR
 
     C                   EXSR      *PSSR
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**   POWER - ARRAY OF POWERS OF 10 FOR CURRENCY CONVERSIONS
0000001
0000010
0000100
0001000
0010000
0100000
1000000
