     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AP API initialisation program')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Application Programming Interface Module             *
      *                                                               *
      *  AP000010 - API Initialisation Program                        *
      *                                                               *
      *  Function:  This module initialises the Front Office ID of    *
      *             all API files.                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CLE141             Date 08Feb16               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CFT120             Date 28Sep12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSW212             Date 03May12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER055             Date 06Dec10               *
      *                 CAP207             Date 10Feb11               *
      *                 CLE139             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      *                 CER030             Date 09Jul08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CGL035             Date 01Mar05               *
      *                 CSE075             Date 17Nov05               *
      *                 CLE106             Date 01Aug04               *
      *                 CDL038             Date 10May05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS009             Date 16May05               *
      *                 CSC024             Date 07Feb05               *
      *                 CDL028             Date 07Feb05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 208221             Date 17Dec02               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 204452             Date 03May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *           (Recompile)                                         *
      *  CAP207 - Account Balance Check extended to other APIs        *
      *           (Recompile)                                         *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *               (Recompile)                                     *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CGL035 - EUSD Upgrade to MidasPlus                           *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CLE106 - Syndication Manager (Recompile)                     *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAS009 - EIR/AC Accounting (Recompile)                       *
      *  CSC024 - Open Month End (Recompile)                          *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  208221 - Recompiled due to changed PF/ACCNTBXC               *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it. Recompile due to changes in FXDEALPP*
      *           ,MMDEAMPP, MMDELDPP, MMDENBPP and MMDENSPP .        *
      *  204452 - Recompiled due to changed PF/LEFEED.                *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Internal Funding (ABFUND), Negotiable Assets Sold (MMNASS),
      ** Negotiable Assets Purchased (MMNASP), Loans/Deposits (MMLDNI)
     FMMDEAULL  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
 
      ** Internal Contracts (ABINTC)
     FABDEAULL  UF   E           K DISK    USROPN
     F                                     INCLUDE(ABDEALP0)
     F                                     INFSR(*PSSR)
 
      ** Forward Rates (FDFWRT)
     FFWDRT     UF   E           K DISK    USROPN
     F                                     INCLUDE(FWDRTFEF)
     F                                     INFSR(*PSSR)
 
      ** MM Interest Rates (FDINTR)
     FFDINTULL  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
 
      ** Futures and Options file (FFTRAN)
     FTRANS     UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
 
      ** FF Settlements (FFSETL)
     FTRSET     UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
 
      ** Incoming Payments Detail file (FTIPAY)
     FINPAY     UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
 
      ** Incoming Payments Extension file (FTIPAY)
     FINPAYXL0  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
 
      * Outgoing Payments Detail file (FTOPAY)
     FOTPAY     UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
 
      * Outgoing Payments Extension file (FTOPAY)
     FOTPAYXL0  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
 
      * Foreign Exchange (FXFXDL)
     FFXDEAULL  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
 
      * Account Movements Detail file (GLAMAD)
     FACCBR     UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
 
      * Account Movements Extension file (GLAMAD)
     FACCNTBY0  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
 
      ** Journal Entry Header (GLBITH)
     FGLJENHL3  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
 
      ** Journal Entry Items file (GLBITP)
     FGLJENPL4  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
 
      ** Forward Rate Agreements/Interest Rate Swaps (IRFRA/IRCIRS/IRSIRS)
     FDEALALL   UF   E           K DISK    USROPN
     F                                     INCLUDE(DEALSDGF)
     F                                     INFSR(*PSSR)
 
      ** Deal Amendments (MMDEAM)
     FMMDAMULL  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
 
      ** Portfolio Definitions (PMPFDM)
     FPMPORTPD  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
 
      ** Base Rate (SDBSRT)
     FSDBSRTL0  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
 
      ** Customer Details (SDCUSD)
     FSDCUSTL0  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
 
      ** Private Banking Details (SDCUSD)
     FSDPBDSL0  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
 
      ** Securities Clients (SDSECD)
     FSDSECSL1  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
 
      ** Currencies (SDCURR)
     FSDCURRL0  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
 
      ** Depot Movements (SEDPMV)
     FDPTMV     UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
 
      ** Prices (SEPRCS)
     FPRICE     UF   E           K DISK    USROPN
     F                                     PREFIX(PC_)
     F                                     INFSR(*PSSR)
 
      ** Price Details (SEPRCS)
     FSEPRICPD  UF   E           K DISK    USROPN
     F                                     PREFIX(SP_)
     F                                     INFSR(*PSSR)
 
      ** Securities (SESECS)
     FSECTY     UF   E           K DISK    USROPN
     F                                     PREFIX(SY_)
     F                                     INFSR(*PSSR)
 
      ** Diary Events (SESEDE)
     FSEDEV     UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
 
      ** Trades (SETRAD)
     FTRADS     UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
 
      ** Trades Extension file (SETRAD)
     FTRADSDY1  UF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
 
      ** LE Facility Details
     FFCLTYFM   UF   E             DISK    USROPN
     F                                     INFSR(*PSSR)
 
      ** LE Participant Details
     FLEPARTPD  UF   E             DISK    USROPN
     F                                     INFSR(*PSSR)
 
      ** LE Facility Amendments
     FLEFCAMPD  UF   E             DISK    USROPN
     F                                     INFSR(*PSSR)
 
      ** LE Fees Settlement/Adjustment Detail
     FLEFEEAD   UF   E             DISK    USROPN
     F                                     INFSR(*PSSR)
 
      ** LE Customer Loans
     FCLOANCL   UF   E             DISK    USROPN
     F                                     INFSR(*PSSR)
 
      ** LE Fees Detail
     FLEFEED    UF   E             DISK    USROPN
     F                                     INFSR(*PSSR)
 
      ** LE Loan Amendments
     FLOAMSDK   UF   E             DISK    USROPN
     F                                     INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** QCommands
     D QCmd            S            100    DIM(2) CTDATA PERRCD(1)
 
      ** Data Structure for QCmd
     D Command         DS           100
     D  DSCmd                  1    100
     D  DSCmd1                13     22
     D  DSCmd2                29     38
 
      ** Local data area for database error details
     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
 
      ** Standing data - Currencies
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Standing data - Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Short DS for Access objects
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Long DS for Access objects
     D DSLDY         E DS                  EXTNAME(DSLDY)
 
      ** DS for calculating PC reference
     D LEALLO        E DS                  EXTNAME(LEALLO)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @Run            S              1A
     D CommandLen      S             15P 5
     D CAP059          S              1A
 
     D POptn           S              7A
     D PRtCd           S              7A
     D PSard           S              6A
     D PCust           S             10A
     D PFile           S             10A
     D PCurrent        S             10A
     D PNext           S             10A
 
     D***WAcod**         S              4A                                                    CGL029
     D WAcod           S             10A                                                      CGL029
     D WAcsq           S              2A
     D WCust           S              6A
     D WDate           S              5A
     D WDay            S              2A
     D WDealNo         S              6A
     D PKyST           S              7A
     D WMonth          S              2A
     D WSeqNo          S              3A
     D WYear           S              4A
 
     ITRADSDF                                                                                 CAS006
     I              CRSK                        ASCRSK                                        CAS006
                                                                                              CAS006
     IDPTMVDF                                                                                 CGL035
     I              OPIN                        EUOPIN                                        CGL035
                                                                                              CGL035
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
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Currencies
     C                   EXSR      SR_SDCURR
 
      ** Internal Funding and Loans/Deposits
     C                   EXSR      SR_ABFUND
 
      ** Internal Contracts
     C                   EXSR      SR_ABINTC
 
      ** Forward Rates
     C                   EXSR      SR_FDFWRT
 
      ** MM Interest Rates
     C                   EXSR      SR_FDINTR
 
      ** Futures and Options
     C                   EXSR      SR_FUTOPT
 
      ** FF Settlements
     C                   EXSR      SR_FFSETL
 
      ** Incoming Payments
     C                   EXSR      SR_FTIPAY
 
      ** Outgoing Payments
     C                   EXSR      SR_FTOPAY
 
      ** Foreign Exchange
     C                   EXSR      SR_FXFXDL
 
      ** Account Movements
     C                   EXSR      SR_GLAMAD
 
      ** Journal Entry Header
     C                   EXSR      SR_GLBITH
 
      ** Journal Entry Items
     C                   EXSR      SR_GLBITP
 
      ** Forward Rate Agreements/Interest Rate Swaps
     C                   EXSR      SR_FRAIRS
 
      ** Deal Amendments
     C                   EXSR      SR_MMDEAM
 
      ** Negotiable Assets Purchased
     C                   EXSR      SR_MMNASP
 
      ** Negotiable Assets Sold
     C                   EXSR      SR_MMNASS
 
      ** Portfolio Definitions
     C                   EXSR      SR_PMPFDM
 
      ** Base Rate
     C                   EXSR      SR_SDBSRT
 
      ** Customer Details
     C                   EXSR      SR_SDCUSD
 
      ** Securities Clients
     C                   EXSR      SR_SDSECD
 
      ** Securities
     C                   EXSR      SR_SESECS
 
      ** Depot Movements
     C                   EXSR      SR_SEDPMV
 
      ** Prices
     C                   EXSR      SR_SEPRCS
 
      ** Diary Events
     C                   EXSR      SR_SESEDE
 
      ** Trades
     C                   EXSR      SR_SETRAD
 
      ** Facility details
     C                   EXSR      SR_LEFACD
 
      ** Participant details
     C                   EXSR      SR_LEPARD
 
      ** Facility amendments
     C                   EXSR      SR_LEFACA
 
      ** Fees settlement/adjustment detail
     C                   EXSR      SR_LEFEES
 
      ** Customer loans
     C                   EXSR      SR_LECUSL
 
      ** Fees detail
     C                   EXSR      SR_LEFEED
 
      ** Loan amendments
     C                   EXSR      SR_LELOAM
 
      ** End program
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_ABFUND - Initialisation for Internal Funding and Loans/   *
      *              Deposits                                         *
      *                                                               *
      *****************************************************************
     C     SR_ABFUND     BEGSR
 
     C                   OPEN      MMDEAULL
     C     *LOVAL        SETLL     MMDEAULL
     C                   READ      MMDELDP0                               80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        HKRCID = 'HK' AND
     C                             HKFRNT = *BLANKS
     C                   IF        HKMTYP = 'ID'
     C                   MOVE      HKDADN        WDealNo
     C                   ELSE
     C                   MOVE      HKDN38        WDealNo
     C                   ENDIF
     C                   EVAL      HKFRNT = 'MD' + WDealNo
     C                   UPDATE    MMDELDP0
     C                   ENDIF
 
     C                   READ      MMDELDP0                               80
     C                   ENDDO
     C                   CLOSE     MMDEAULL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_ABINTC - Initialisation for Internal Contracts            *
      *                                                               *
      *****************************************************************
     C     SR_ABINTC     BEGSR
 
     C                   OPEN      ABDEAULL
     C     *LOVAL        SETLL     ABDEAULL
     C                   READ      ABDEALP0                               80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        JPRCID = 'JP' AND
     C                             JPFRNT = *BLANKS
     C                   MOVE      JPFD38        WDealNo
     C                   EVAL      JPFRNT = 'MD' + WDealNo
     C                   IF        JPAFRT = *BLANKS
     C                   EVAL      JPAFRT = 'MD' + WDealNo
     C                   ENDIF
     C                   UPDATE    ABDEALP0
     C                   ENDIF
 
     C                   READ      ABDEALP0                               80
     C                   ENDDO
     C                   CLOSE     ABDEAULL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_FDFWRT - Initialisation for Forward Rates                 *
      *                                                               *
      *****************************************************************
     C     SR_FDFWRT     BEGSR
 
     C                   OPEN      FWDRT
     C     *LOVAL        SETLL     FWDRT
     C                   READ      FWDRTFEF                               80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        RECI = 'D' AND
     C                             FRFRNT = *BLANKS
     C                   IF        CAP059 = 'Y'
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    CCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = CCY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      FRFRNT = A6FRNT
     C                   UPDATE    FWDRTFEF
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      FWDRTFEF                               80
     C                   ENDDO
     C                   CLOSE     FWDRT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_FDINTR - Initialisation for MM Interest Rates             *
      *                                                               *
      *****************************************************************
     C     SR_FDINTR     BEGSR
 
     C                   OPEN      FDINTULL
     C     *LOVAL        SETLL     FDINTULL
     C                   READ      FDINTRP0                               80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        HWRCID = 'HW' AND
     C                             HWBOFR = *BLANKS AND HWLEFR = *BLANKS
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    HWCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 002
     C                   EVAL      DBKEY = HWCCY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        A6BOID = *BLANKS AND A6LEID = *BLANKS
     C                   EVAL      HWBOFR = 'MD' + HWCCY
     C                   EVAL      HWLEFR = 'MD' + HWCCY
     C                   ELSE
     C                   EVAL      HWBOFR = A6BOID
     C                   EVAL      HWLEFR = A6LEID
     C                   ENDIF
     C                   UPDATE    FDINTRP0
     C                   ENDIF
 
     C                   READ      FDINTRP0                               80
     C                   ENDDO
     C                   CLOSE     FDINTULL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_FUTOPT - Initialisation for Futures and Options           *
      *                                                               *
      *****************************************************************
     C     SR_FUTOPT     BEGSR
 
      ** Retrieve the next member
 
     C                   EVAL      PFile = 'TRANS'
     C                   EVAL      PCurrent = *BLANKS
     C                   EVAL      PNext = *BLANKS
 
     C                   DOW       PNext <> '*NONE'
 
     C                   CALL      'ZACRTVMBR'
     C                   PARM                    PFile
     C                   PARM                    PCurrent
     C                   PARM                    PNext
 
     C                   IF        PNext = '*ERROR'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = PFile
     C                   EVAL      DBASE = 004
     C                   EVAL      DBKEY = PCurrent
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Override with the correct member
 
     C                   IF        PNext <> '*NONE'
     C                   EVAL      Command = QCmd(1)
     C                   EVAL      DSCmd1 = PFile
     C                   EVAL      DSCmd2 = PNext
     C                   EVAL      CommandLen = 39
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
 
      ** Initialise the current member
 
     C                   OPEN      TRANS
     C     *LOVAL        SETLL     TRANS
     C                   READ      TRANSDF                                80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        RECI = 'D' AND
     C                             FRNT = *BLANKS
     C                   MOVE      TNBR          WDealNo
     C                   EVAL      FRNT = 'MD' + WDealNo
     C                   UPDATE    TRANSDF
     C                   ENDIF
 
     C                   READ      TRANSDF                                80
     C                   ENDDO
     C                   CLOSE     TRANS
 
     C                   ENDIF
 
     C                   EVAL      PCurrent = PNext
     C                   ENDDO
 
      ** Delete the file override
 
     C                   EVAL      Command = QCmd(2)
     C                   EVAL      CommandLen = 17
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_FFSETL - Initialisation for FF Settlements                *
      *                                                               *
      *****************************************************************
     C     SR_FFSETL     BEGSR
 
      ** Retrieve the next member
 
     C                   EVAL      PFile = 'TRSET'
     C                   EVAL      PCurrent = *BLANKS
     C                   EVAL      PNext = *BLANKS
 
     C                   DOW       PNext <> '*NONE'
 
     C                   CALL      'ZACRTVMBR'
     C                   PARM                    PFile
     C                   PARM                    PCurrent
     C                   PARM                    PNext
 
     C                   IF        PNext = '*ERROR'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = PFile
     C                   EVAL      DBASE = 005
     C                   EVAL      DBKEY = PCurrent
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Override with the correct member
 
     C                   IF        PNext <> '*NONE'
     C                   EVAL      Command = QCmd(1)
     C                   EVAL      DSCmd1 = PFile
     C                   EVAL      DSCmd2 = PNext
     C                   EVAL      CommandLen = 39
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
 
      ** Initialise the current member
 
     C                   OPEN      TRSET
     C     *LOVAL        SETLL     TRSET
     C                   READ      TRSETDF                                80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        RECI = 'D' AND
     C                             FRNT = *BLANKS
     C                   MOVE      TNBR          WDealNo
     C                   EVAL      FRNT = 'MD' + WDealNo
     C                   UPDATE    TRSETDF
     C                   ENDIF
 
     C                   READ      TRSETDF                                80
     C                   ENDDO
     C                   CLOSE     TRSET
 
     C                   ENDIF
 
     C                   EVAL      PCurrent = PNext
     C                   ENDDO
 
      ** Delete the file override
 
     C                   EVAL      Command = QCmd(2)
     C                   EVAL      CommandLen = 17
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_FTIPAY - Initialisation for Incoming Payments             *
      *                                                               *
      *****************************************************************
     C     SR_FTIPAY     BEGSR
 
      ** Detail file
 
     C                   OPEN      INPAY
     C     *LOVAL        SETLL     INPAY
     C                   READ      INPAYDDF                               80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        FRNT = *BLANKS
     C                   EVAL      FRNT = 'MD' + PREF
     C                   UPDATE    INPAYDDF
     C                   ENDIF
 
     C                   READ      INPAYDDF                               80
     C                   ENDDO
     C                   CLOSE     INPAY
 
      ** Extension file
 
     C                   OPEN      INPAYXL0
     C     *LOVAL        SETLL     INPAYXL0
     C                   READ      INPAYXDF                               80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        INFRNT = *BLANKS
     C                   EVAL      INFRNT = 'MD' + INPREF
     C                   UPDATE    INPAYXDF
     C                   ENDIF
 
     C                   READ      INPAYXDF                               80
     C                   ENDDO
     C                   CLOSE     INPAYXL0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_FTOPAY - Initialisation for Outgoing Payments             *
      *                                                               *
      *****************************************************************
     C     SR_FTOPAY     BEGSR
 
      ** Detail file
 
     C                   OPEN      OTPAY
     C     *LOVAL        SETLL     OTPAY
     C                   READ      OTPAYDDF                               80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        FRNT = *BLANKS
     C                   EVAL      FRNT = 'MD' + PREF
     C                   UPDATE    OTPAYDDF
     C                   ENDIF
 
     C                   READ      OTPAYDDF                               80
     C                   ENDDO
     C                   CLOSE     OTPAY
 
      ** Extension file
 
     C                   OPEN      OTPAYXL0
     C     *LOVAL        SETLL     OTPAYXL0
     C                   READ      OTPAYXDF                               80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        OPFRNT = *BLANKS
     C                   EVAL      OPFRNT = 'MD' + OPPREF
     C                   UPDATE    OTPAYXDF
     C                   ENDIF
 
     C                   READ      OTPAYXDF                               80
     C                   ENDDO
     C                   CLOSE     OTPAYXL0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_FXFXDL - Initialisation for Foreign Exchange              *
      *                                                               *
      *****************************************************************
     C     SR_FXFXDL     BEGSR
 
     C                   OPEN      FXDEAULL
     C     *LOVAL        SETLL     FXDEAULL
     C                   READ      FXDEALP0                               80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        FHRCID = 'FH' AND
     C                             FHFRNT = *BLANKS
     C                   MOVE      FHDN38        WDealNo
     C                   EVAL      FHFRNT = 'MD' + WDealNo
     C                   IF        FHAFRT = *BLANKS
     C                   IF        FHDADN <> *BLANKS
     C                   EVAL      FHAFRT = 'MD' + FHDADN
     C                   ENDIF
     C                   ENDIF
     C                   UPDATE    FXDEALP0
     C                   ENDIF
 
     C                   READ      FXDEALP0                               80
     C                   ENDDO
     C                   CLOSE     FXDEAULL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_GLAMAD - Initialisation for Account Movements             *
      *                                                               *
      *****************************************************************
     C     SR_GLAMAD     BEGSR
 
      ** Detail file
 
     C                   OPEN      ACCBR
     C     *LOVAL        SETLL     ACCBR
     C                   READ      ACCNTABF                               80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        RECI = 'D' AND
     C                             FRNT = *BLANKS
     C                   MOVE      CNUM          WCust
     C                   MOVE      ACOD          WAcod
     C                   MOVE      ACSQ          WAcsq
     C**********         EVAL      FRNT = 'MD' + BRCA + WCust +                               CGL029
     C**********                           CCY +  WAcod + WAcsq                               CGL029
     C                   EVAL      FRNT = 'MD' + BRCA + WCust +                               CGL029
     C                                     CCY +  %SUBST(WAcod:1:6)                           CGL029
                                                                                              CGL029
      ** Set associated front office id to the last 4 characters of the account               CGL029
      ** code and account sequence                                                            CGL029
     C                   EVAL      AFRT = %SUBST(WAcod:7:4) + WAcsq                           CGL029
     C                   UPDATE    ACCNTABF
     C                   ENDIF
 
     C                   READ      ACCNTABF                               80
     C                   ENDDO
     C                   CLOSE     ACCBR
 
      ** Extension file
 
     C                   OPEN      ACCNTBY0
     C     *LOVAL        SETLL     ACCNTBY0
     C                   READ      ACCNTBD0                               80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        ATFRNT = *BLANKS
     C                   MOVE      ATCNUM        WCust
     C                   MOVE      ATACOD        WAcod
     C                   MOVE      ATACSQ        WAcsq
     C**********         EVAL      ATFRNT = 'MD' + ATBRCA +                                   CGL029
     C**********                   WCust + ATCCY + WAcod + WAcsq                              CGL029
     C                   EVAL      ATFRNT = 'MD' + ATBRCA +                                   CGL029
     C                             WCust + ATCCY + %SUBST(WAcod:1:6)                          CGL029
                                                                                              CGL029
      ** Set associated front office id to the last 4 characters of the account               CGL029
      ** code and account sequence                                                            CGL029
     C                   EVAL      ATAFRT = %SUBST(WAcod:7:4) + WAcsq                         CGL029
     C                   UPDATE    ACCNTBD0
     C                   ENDIF
 
     C                   READ      ACCNTBD0                               80
     C                   ENDDO
     C                   CLOSE     ACCNTBY0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_GLBITH - Initialisation for Journal Entry Header          *
      *                                                               *
      *****************************************************************
     C     SR_GLBITH     BEGSR
 
     C                   OPEN      GLJENHL3
     C     *LOVAL        SETLL     GLJENHL3
     C                   READ      @BRREMA                                80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        BRFRNT = *BLANKS
     C                   EVAL      BRFRNT = 'MD' + BRBTNB
     C                   UPDATE    @BRREMA
     C                   ENDIF
 
     C                   READ      @BRREMA                                80
     C                   ENDDO
     C                   CLOSE     GLJENHL3
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_GLBITP - Initialisation for Journal Entry Items           *
      *                                                               *
      *****************************************************************
     C     SR_GLBITP     BEGSR
 
     C                   OPEN      GLJENPL4
     C     *LOVAL        SETLL     GLJENPL4
     C                   READ      @BTREMG                                80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        BTFRNT = *BLANKS
     C                   EVAL      BTFRNT = 'MD' + BTBTNB
     C                   UPDATE    @BTREMG
     C                   ENDIF
 
     C                   READ      @BTREMG                                80
     C                   ENDDO
     C                   CLOSE     GLJENPL4
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_FRAIRS - Initialisation for FRA/IRS                       *
      *                                                               *
      *****************************************************************
     C     SR_FRAIRS     BEGSR
 
     C                   OPEN      DEALALL
     C     *LOVAL        SETLL     DEALALL
     C                   READ      DEALSDGF                               80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        DTYP = 'FR' OR DTYP = 'RS'
     C                             OR DTYP = 'RX'
     C                   IF        FRNT = *BLANKS
     C                   MOVE      DLNO          WDealNo
     C                   EVAL      FRNT = 'MD' + WDealNo
     C                   UPDATE    DEALSDGF
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      DEALSDGF                               80
     C                   ENDDO
     C                   CLOSE     DEALALL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_MMDEAM - Initialisation for Deal Amendments               *
      *                                                               *
      *****************************************************************
     C     SR_MMDEAM     BEGSR
 
     C                   OPEN      MMDAMULL
     C     *LOVAL        SETLL     MMDAMULL
     C                   READ      MMDEAMP0                               80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        HNRCID = 'HN' AND
     C                             HNFRNT = *BLANKS
     C                   MOVE      HNDA38        WDealNo
     C                   MOVE      HNVDYY        WYear
     C                   MOVE      HNVDMM        WMonth
     C                   MOVE      HNVDDD        WDay
     C                   MOVE      HNDS38        WSeqNo
     C                   EVAL      HNFRNT = 'MD' + WDealNo + WYear +
     C                                      WMonth + WDay + WSeqNo
     C                   UPDATE    MMDEAMP0
     C                   ENDIF
 
     C                   READ      MMDEAMP0                               80
     C                   ENDDO
     C                   CLOSE     MMDAMULL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_MMNASP - Initialisation for Negotiable Assets Purchased   *
      *                                                               *
      *****************************************************************
     C     SR_MMNASP     BEGSR
 
     C                   OPEN      MMDEAULL
     C     *LOVAL        SETLL     MMDEAULL
     C                   READ      MMDENBP0                               80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        HLRCID = 'HL' AND
     C                             HLFRNT = *BLANKS
     C                   MOVE      HLDN38        WDealNo
     C                   EVAL      HLFRNT = 'MD' + WDealNo
     C                   UPDATE    MMDENBP0
     C                   ENDIF
 
     C                   READ      MMDENBP0                               80
     C                   ENDDO
     C                   CLOSE     MMDEAULL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_MMNASS - Initialisation for Negotiable Assets Sold        *
      *                                                               *
      *****************************************************************
     C     SR_MMNASS     BEGSR
 
     C                   OPEN      MMDEAULL
     C     *LOVAL        SETLL     MMDEAULL
     C                   READ      MMDENSP0                               80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        HMRCID = 'HM' AND
     C                             HMFRNT = *BLANKS
     C                   MOVE      HMDN38        WDealNo
     C                   EVAL      HMFRNT = 'MD' + WDealNo
     C                   IF        HMAFRT = *BLANKS
     C                   EVAL      HMAFRT = 'MD' + HMDADN
     C                   ENDIF
     C                   UPDATE    MMDENSP0
     C                   ENDIF
 
     C                   READ      MMDENSP0                               80
     C                   ENDDO
     C                   CLOSE     MMDEAULL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_PMPFDM - Initialisation for Portfolio Definitions         *
      *                                                               *
      *****************************************************************
     C     SR_PMPFDM     BEGSR
 
     C                   OPEN      PMPORTPD
     C     *LOVAL        SETLL     PMPORTPD
     C                   READ      PMPORTP0                               80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        PNRECI = 'D' AND
     C                             PNFRNT = *BLANKS
     C                   MOVE      PNCNUM        WCust
     C                   EVAL      PNFRNT = 'MD' + WCust + PNPTFR +
     C                                      PNPTCY
     C                   UPDATE    PMPORTP0
     C                   ENDIF
 
     C                   READ      PMPORTP0                               80
     C                   ENDDO
     C                   CLOSE     PMPORTPD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_SDBSRT - Initialisation for Base Rates                    *
      *                                                               *
      *****************************************************************
     C     SR_SDBSRT     BEGSR
 
     C                   OPEN      SDBSRTL0
     C     *LOVAL        SETLL     SDBSRTL0
     C                   READ      @BAREDG                                80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        BAFRNT = *BLANKS
     C                   EVAL      BAFRNT = 'MD' + BACYCD + BABSRC
     C                   UPDATE    @BAREDG
     C                   ENDIF
 
     C                   READ      @BAREDG                                80
     C                   ENDDO
     C                   CLOSE     SDBSRTL0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_SDCUSD - Initialisation for Customer Details              *
      *                                                               *
      *****************************************************************
     C     SR_SDCUSD     BEGSR
 
      ** Customer details
 
     C                   OPEN      SDCUSTL0
     C     *LOVAL        SETLL     SDCUSTL0
     C                   READ      @BBREBG                                80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        BBDTDL = *ZERO AND BBCLST <> 'Y' AND
     C                             BBFRNT = *BLANKS
     C                   EVAL      BBFRNT = 'MD' + BBCUST
     C                   UPDATE    @BBREBG
     C                   ENDIF
 
     C                   READ      @BBREBG                                80
     C                   ENDDO
     C                   CLOSE     SDCUSTL0
 
      ** Private Banking details
 
     C                   OPEN      SDPBDSL0
     C     *LOVAL        SETLL     SDPBDSL0
     C                   READ      SDPBDSD0                               80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        PBRECI = 'D' AND
     C                             PBFRNT = *BLANKS
     C                   EVAL      PCust = *BLANKS
     C                   MOVE      PBCNUM        PCust
 
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCust
     C                   PARM      *BLANKS       PKyST
     C     SDCUST        PARM      SDCUST        DSLDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 003
     C                   EVAL      DBKEY = WCust
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      PBFRNT = BBFRNT
     C                   UPDATE    SDPBDSD0
     C                   ENDIF
 
     C                   READ      SDPBDSD0                               80
     C                   ENDDO
     C                   CLOSE     SDPBDSL0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_SDSECD - Initialisation for Securities Clients            *
      *                                                               *
      *****************************************************************
     C     SR_SDSECD     BEGSR
 
     C                   OPEN      SDSECSL1
     C     *LOVAL        SETLL     SDSECSL1
     C                   READ      @BFREDQ                                80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        BFFRNT = *BLANKS
     C                   EVAL      BFFRNT = 'MD' + BFCUST
     C                   UPDATE    @BFREDQ
     C                   ENDIF
 
     C                   READ      @BFREDQ                                80
     C                   ENDDO
     C                   CLOSE     SDSECSL1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_SDCURR - Initialisation for Currencies                    *
      *                                                               *
      *****************************************************************
     C     SR_SDCURR     BEGSR
 
     C                   OPEN      SDCURRL0
     C     *LOVAL        SETLL     SDCURRL0
     C                   READ      @A6REA4                                80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        A6RECI = 'D' AND
     C                             (A6SRID = *BLANKS OR A6FRNT = *BLANKS OR
     C                             A6BOID = *BLANKS OR A6LEID = *BLANKS)
     C                   IF        A6SRID = *BLANKS
     C                   EVAL      A6SRID = 'MD' + A6CYCD + 'SPOT'
     C                   ENDIF
     C                   IF        A6FRNT = *BLANKS
     C                   EVAL      A6FRNT = 'MD' + A6CYCD + 'FORWARD'
     C                   ENDIF
     C                   IF        A6BOID = *BLANKS
     C                   EVAL      A6BOID = 'MD' + A6CYCD + 'BORROWING'
     C                   ENDIF
     C                   IF        A6LEID = *BLANKS
     C                   EVAL      A6LEID = 'MD' + A6CYCD + 'LENDING'
     C                   ENDIF
     C                   UPDATE    @A6REA4
     C                   ENDIF
 
     C                   READ      @A6REA4                                80
     C                   ENDDO
     C                   CLOSE     SDCURRL0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_SEDPMV - Initialisation for Depot Movements               *
      *                                                               *
      *****************************************************************
     C     SR_SEDPMV     BEGSR
 
     C                   OPEN      DPTMV
     C     *LOVAL        SETLL     DPTMV
     C                   READ      DPTMVDF                                80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        DMFRNT = *BLANKS
     C                   EVAL      DMFRNT = 'MD' + DPRN
     C                   UPDATE    DPTMVDF
     C                   ENDIF
 
     C                   READ      DPTMVDF                                80
     C                   ENDDO
     C                   CLOSE     DPTMV
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_SEPRCS - Initialisation for Prices                        *
      *                                                               *
      *****************************************************************
     C     SR_SEPRCS     BEGSR
 
      ** Prices
 
     C                   OPEN      PRICE
     C                   OPEN      SECTY
     C     *LOVAL        SETLL     PRICE
     C                   READ      PRICEDF                                80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        PC_PRFRNT = *BLANKS
     C     PC_PSSN       CHAIN     SECTY                              81
     C                   IF        *IN81 = *OFF
     C                   EVAL      PC_PRFRNT = SY_SPID
     C                   ENDIF
     C                   UPDATE    PRICEDF
     C                   ENDIF
 
     C                   READ      PRICEDF                                80
     C                   ENDDO
     C                   CLOSE     PRICE
 
      ** Price details
 
     C                   OPEN      SEPRICPD
     C     *LOVAL        SETLL     SEPRICPD
     C                   READ      SEPRICD0                               80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        SP_PRFRNT = *BLANKS
     C     SP_PSSN       CHAIN     SECTY                              81
     C                   IF        *IN81 = *OFF
     C                   EVAL      SP_PRFRNT = SY_SPID
     C                   ENDIF
     C                   UPDATE    SEPRICD0
     C                   ENDIF
 
     C                   READ      SEPRICD0                               80
     C                   ENDDO
     C                   CLOSE     SEPRICPD
     C                   CLOSE     SECTY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_SESECS - Initialisation for Securities                    *
      *                                                               *
      *****************************************************************
     C     SR_SESECS     BEGSR
 
     C                   OPEN      SECTY
     C     *LOVAL        SETLL     SECTY
     C                   READ      SECTYDF                                80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        SY_FRNT = *BLANKS OR SY_SPID = *BLANKS
     C                   IF        SY_FRNT = *BLANKS
     C                   EVAL      SY_FRNT = 'MD' + SY_SESN
     C                   ENDIF
 
     C                   IF        SY_SPID = *BLANKS
     C                   EVAL      SY_SPID = SY_FRNT
     C                   ENDIF
     C                   UPDATE    SECTYDF
     C                   ENDIF
 
     C                   READ      SECTYDF                                80
     C                   ENDDO
     C                   CLOSE     SECTY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_SESEDE - Initialisation for Diary Events                  *
      *                                                               *
      *****************************************************************
     C     SR_SESEDE     BEGSR
 
     C                   OPEN      SEDEV
     C     *LOVAL        SETLL     SEDEV
     C                   READ      SEDEVDF                                80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        FRNT = *BLANKS
     C                   MOVE      SDED          WDate
     C                   EVAL      FRNT = 'MD' + SDSN + WDate + SDET
     C                   UPDATE    SEDEVDF
     C                   ENDIF
 
     C                   READ      SEDEVDF                                80
     C                   ENDDO
     C                   CLOSE     SEDEV
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_SETRAD - Initialisation for Trades                        *
      *                                                               *
      *****************************************************************
     C     SR_SETRAD     BEGSR
 
      ** Trades
 
     C                   OPEN      TRADS
     C     *LOVAL        SETLL     TRADS
     C                   READ      TRADSDF                                80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        FRNT = *BLANKS
     C                   EVAL      FRNT = 'MD' + TDRF
     C                   UPDATE    TRADSDF
     C                   ENDIF
 
     C                   READ      TRADSDF                                80
     C                   ENDDO
     C                   CLOSE     TRADS
 
      ** Trades Extension file
 
     C                   OPEN      TRADSDY1
     C     *LOVAL        SETLL     TRADSDY1
     C                   READ      TRADSDD1                               80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        T1FRNT = *BLANKS
     C                   EVAL      T1FRNT = 'MD' + T1TDRF
     C                   UPDATE    TRADSDD1
     C                   ENDIF
 
     C                   READ      TRADSDD1                               80
     C                   ENDDO
     C                   CLOSE     TRADSDY1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_LEFACD - Initialisation for Facility Details              *
      *                                                               *
      *****************************************************************
     C     SR_LEFACD     BEGSR
 
     C                   OPEN      FCLTYFM
     C     1             SETLL     FCLTYFM
     C                   READ      FCLTYFM                                80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        PCRF = *BLANKS AND RECI = 'D'
     C******LOCK         IN        LEALLO                                                     CLE148
     C*****PCLAST        ADD       1             PCNEXT            8 0                        CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD             7                          CLE148
     C                   PARM      'Y'           PUPDT             1                          CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT            8                          CLE148
                                                                                              CLE148
     C                   MOVE      PCNEXT        W1ST11           11
     C                   MOVEL     BRCA          W1ST11
     C                   MOVEL     W1ST11        PCRF
     C                   MOVE      '0001'        PCRF
     C**********         Z-ADD     PCNEXT        PCLAST                                       CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C                   UPDATE    FCLTYFMF
     C                   ENDIF
 
     C                   READ      FCLTYFM                                80
     C                   ENDDO
     C                   CLOSE     FCLTYFM
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_LEPARD - Initialisation for Participant Details           *
      *                                                               *
      *****************************************************************
     C     SR_LEPARD     BEGSR
 
     C                   OPEN      LEPARTPD
     C     1             SETLL     LEPARTPD
     C                   READ      LEPARTPD                               80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        PCRF = *BLANKS
     C******LOCK         IN        LEALLO                                                     CLE148
     C*****PCLAST        ADD       1             PCNEXT                                       CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD                                        CLE148
     C                   PARM      'Y'           PUPDT                                        CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT                                       CLE148
                                                                                              CLE148
     C                   MOVE      PCNEXT        W1ST11
     C                   MOVEL     BRCA          W1ST11
     C                   MOVEL     W1ST11        PCRF
     C                   MOVE      '0001'        PCRF
     C**********         Z-ADD     PCNEXT        PCLAST                                       CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C                   UPDATE    LEPARTD0
     C                   ENDIF
 
     C                   READ      LEPARTPD                               80
     C                   ENDDO
     C                   CLOSE     LEPARTPD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_LEFACA - Initialisation for Facility Amendments           *
      *                                                               *
      *****************************************************************
     C     SR_LEFACA     BEGSR
 
     C                   OPEN      LEFCAMPD
     C     1             SETLL     LEFCAMPD
     C                   READ      LEFCAMPD                               80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        PCRF = *BLANKS AND RECI = 'D'
     C******LOCK         IN        LEALLO                                                     CLE148
     C*****PCLAST        ADD       1             PCNEXT                                       CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD                                        CLE148
     C                   PARM      'Y'           PUPDT                                        CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT                                       CLE148
                                                                                              CLE148
     C                   MOVE      PCNEXT        W1ST11
     C                   MOVEL     BRCA          W1ST11
     C                   MOVEL     W1ST11        PCRF
     C                   MOVE      '0001'        PCRF
     C**********         Z-ADD     PCNEXT        PCLAST                                       CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C                   UPDATE    LEFCAMPF
     C                   ENDIF
 
     C                   READ      LEFCAMPD                               80
     C                   ENDDO
     C                   CLOSE     LEFCAMPD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_LEFEES - Initialisation for Fees Settlement/Adjustment    *
      *              Detail                                           *
      *                                                               *
      *****************************************************************
     C     SR_LEFEES     BEGSR
 
     C                   OPEN      LEFEEAD
     C     1             SETLL     LEFEEAD
     C                   READ      LEFEEAD                                80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        PCRF = *BLANKS AND FARECI = 'D'
     C******LOCK         IN        LEALLO                                                     CLE148
     C*****PCLAST        ADD       1             PCNEXT                                       CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD                                        CLE148
     C                   PARM      'Y'           PUPDT                                        CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT                                       CLE148
                                                                                              CLE148
     C                   MOVE      PCNEXT        W1ST11
     C                   MOVEL     FABRCA        W1ST11
     C                   MOVEL     W1ST11        PCRF
     C                   MOVE      '0001'        PCRF
     C**********         Z-ADD     PCNEXT        PCLAST                                       CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C                   UPDATE    LEFEEADF
     C                   ENDIF
 
     C                   READ      LEFEEAD                                80
     C                   ENDDO
     C                   CLOSE     LEFEEAD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_LECUSL - Initialisation for Customer Loans                *
      *                                                               *
      *****************************************************************
     C     SR_LECUSL     BEGSR
 
     C                   OPEN      CLOANCL
     C     1             SETLL     CLOANCL
     C                   READ      CLOANCL                                80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        PCRF = *BLANKS AND RECI = 'D'
     C******LOCK         IN        LEALLO                                                     CLE148
     C*****PCLAST        ADD       1             PCNEXT                                       CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD                                        CLE148
     C                   PARM      'Y'           PUPDT                                        CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT                                       CLE148
                                                                                              CLE148
     C                   MOVE      PCNEXT        W1ST11
     C                   MOVEL     BRCA          W1ST11
     C                   MOVEL     W1ST11        PCRF
     C                   MOVE      '0001'        PCRF
     C**********         Z-ADD     PCNEXT        PCLAST                                       CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C                   UPDATE    CLOANCLF
     C                   ENDIF
 
     C                   READ      CLOANCL                                80
     C                   ENDDO
     C                   CLOSE     CLOANCL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_LEFEED - Initialisation for Fees Detail                   *
      *                                                               *
      *****************************************************************
     C     SR_LEFEED     BEGSR
 
     C                   OPEN      LEFEED
     C     1             SETLL     LEFEED
     C                   READ      LEFEED                                 80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        PCRF = *BLANKS AND FERECI = 'D'
     C******LOCK         IN        LEALLO                                                     CLE148
     C*****PCLAST        ADD       1             PCNEXT                                       CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD                                        CLE148
     C                   PARM      'Y'           PUPDT                                        CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT                                       CLE148
                                                                                              CLE148
     C                   MOVE      PCNEXT        W1ST11
     C                   MOVEL     FEBRCA        W1ST11
     C                   MOVEL     W1ST11        PCRF
     C                   MOVE      '0001'        PCRF
     C**********         Z-ADD     PCNEXT        PCLAST                                       CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C                   UPDATE    LEFEEDF
     C                   ENDIF
 
     C                   READ      LEFEED                                 80
     C                   ENDDO
     C                   CLOSE     LEFEED
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_LELOAM - Initialisation for Loan Amendments               *
      *                                                               *
      *****************************************************************
     C     SR_LELOAM     BEGSR
 
     C                   OPEN      LOAMSDK
     C     1             SETLL     LOAMSDK
     C                   READ      LOAMSDK                                80
 
     C                   DOW       *IN80 = *OFF
 
     C                   IF        PCRF = *BLANKS AND RECI = 'D'
     C******LOCK         IN        LEALLO                                                     CLE148
     C*****PCLAST        ADD       1             PCNEXT                                       CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD                                        CLE148
     C                   PARM      'Y'           PUPDT                                        CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT                                       CLE148
                                                                                              CLE148
     C                   MOVE      PCNEXT        W1ST11
     C                   MOVEL     BRCA          W1ST11
     C                   MOVEL     W1ST11        PCRF
     C                   MOVE      '0001'        PCRF
     C**********         Z-ADD     PCNEXT        PCLAST                                       CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C                   UPDATE    LOAMSDKF
     C                   ENDIF
 
     C                   READ      LOAMSDK                                80
     C                   ENDDO
     C                   CLOSE     LOAMSDK
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Initialise Local data area
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
     C                   OUT       LDA
 
      ** Check if Forward Rates API is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CAP059'      PSard
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CAP059 = 'Y'
     C                   ELSE
     C                   EVAL      CAP059 = 'N'
     C                   ENDIF
 
     C******DTAARA       DEFINE                  LEALLO                                       CLE148
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        @Run = *BLANK
     C                   EVAL      @Run = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
**  QCmd
OVRDBF FILE(          ) MBR(          )
DLTOVR FILE(*ALL)
