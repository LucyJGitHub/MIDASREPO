     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Hedge effectiveness assessment program')      *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standards Module                          *
      *                                                               *
      *  AS000003 - Hedge Effectiveness Assessment Program            *
      *                                                               *
      *  Function:  This module will assess each hedge in the system. *
      *             Hedge Effectiveness will be measured by 'De       *
      *             Minimis Ruling' and 'Effectiveness Boundaries'.   *
      *                                                               *
      *  Component of: AS000003                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR702741           Date 02Feb11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 228948             Date 27Sep04               *
      *                 228011             Date 24Jun04               *
      *                 227695             Date 17Jun04               *
      *                 CAS008             Date 11May04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 217825             Date 10Apr03               *
      *                 212408             Date 24Sep02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS003             Date 14Jan02               *
      *                 CAS002  *CREATE    Date 14Jan02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  228948 - Add 'Exclude Accrued Interest in Unrealized Profit  *
      *           or Loss' (Recompile).                               *
      *  228011 - Error on percentage reported by AS001003P1          *
      *  227695 - For MM deals, check liquidity premium instead of    *
      *           base rate and spread rate to determine whether to   *
      *           use all-in-rate or net treasury rate file.          *
      *  CAS008 - Delayed Hedge Assessment                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  217825 - Incorrect percentage of effectivess being stored in *
      *           ASHGLKPD                                            *
      *  212408 - Array index is out of range                         *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  CAS003 - Hedge Strategy/Linkage for Futures and Options      *
      *  CAS002 - Hedge Strategy/Linkage                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    25         Record Found Indicator (ASHTRNL1)               *
      *    26         Record Found Indicator (ASHTRNLB)               *                       CAS005
      *                                                               *
      *    LR         Last Record Indicator (program termination)     *
      *    U7 and U8  DB Error Processing Indicator                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRInitAcc - Initializes Accumulators                         *
      *  SRChkHInt - Checks if Hedging Internal Contracts             *
      *  SRDerivat - Retrieves the Hedging Instruments Transactions   *
      *              Under Each Hedge ID and Sum the NPV Amounts for  *
      *              All Retrieved Hedging Instrument                 *
      *  SRDerivDL - Retrieves the Hedging Instrument's NPV           *
      *              Information of Dealing Transactions              *
      *  SRDerivFF - Retrieves the Hedging Instrument's NPV           *                       CAS003
      *              Information for Futures & Options Transactions   *                       CAS003
      *  SRChkHdgI - Check Hedged Items if there is a need to chain   *                       CAS005
      *              the Base Rate version of the NPV files of the    *                       CAS005
      *              current derivative                               *                       CAS005
      *  SRHedgedI - Retrieves the Hedged Items Transactions Under    *
      *              Each Hedge ID and Sum the NPV Amounts for All    *
      *              Retrieved Hedged Items                           *
      *  SRHedgeDL - Retrieves the Hedged Item's NPV Information of   *
      *              Dealing Transactions                             *
      *  SRHedgeLE - Retrieves the Hedged Item's NPV Information of   *
      *              Lending Transactions                             *
      *  SRHedgeSE - Retrieves the Hedged Item's NPV Information of   *
      *              Securities Trading                               *
      *  SRAccuAmt - Sum All Hedging/Hedged NPV Amounts Under Each    *
      *              Hedge ID                                         *
      *  SRCalcuHE - Calculate Hedge Effectiveness                    *
      *  SRCvtMthF - Convert MMM Month Format to MM                   *                       CAS003
      *  SrSummat  - Summation of Data from Historic Data File        *                       CAS006
      *  SrNotaSum - Compute for Notations based on the Sums of       *                       CAS006
      *              Squares                                          *                       CAS006
      *  SrRegAsse - Assess Linkages using the Regression Analysis    *                       CAS006
      * *INZSR - Initialise                                           *
      * *PSSR - Error processing                                      *
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
     FASHGLKL0  UF   E           K DISK    INFSR(*PSSR)
      ** Midas AS Hedge Linkage File Update by Hedge ID
 
     FASHTRNL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas AS Hedge Transaction File Retrieval
 
     FASHTRNLB  IF   E           K DISK    INFSR(*PSSR)                                       CAS005
     F                                     RENAME(ASHTRND0:ASHTRND1)                          CAS005
     F                                     PREFIX(HI)                                         CAS005
      ** Midas AS Hedge Transaction File Retrieval                                            CAS005
                                                                                              CAS005
     F***IRNPVLL0  IF   E           K DISK    INFSR(*PSSR)                                    CAS005
     FIRNPVAL0  IF   E           K DISK    INFSR(*PSSR)                                       CAS005
      ** Midas IR Revalued SIRS File                                                          CAS005
      ***Midas*IR*Revalued*FRAs*and*IRSs*File*************************                        CAS005
 
     FIRNPVBL0  IF   E           K DISK    INFSR(*PSSR)                                       CAS005
     F                                     RENAME(IRNPVAD0:IRNPVBD0)                          CAS005
     F                                     PREFIX(SB)                                         CAS005
      ** Midas IR Revalued SIRS Using Base Rate                                               CAS005
                                                                                              CAS005
     FRXNPVAL1  IF   E           K DISK    INFSR(*PSSR)                                       CAS005
     F                                     PREFIX(RX)                                         CAS005
      ** Midas IR Revalued CIRS File                                                          CAS005
                                                                                              CAS005
     FRXNPVBL1  IF   E           K DISK    INFSR(*PSSR)                                       CAS005
     F                                     RENAME(RXNPVAD0:RXNPVBD0)                          CAS005
     F                                     PREFIX(CB)                                         CAS005
      ** Midas IR Revalued CIRS Using Base Rate                                               CAS005
                                                                                              CAS005
     FFRNPVAL0  IF   E           K DISK    INFSR(*PSSR)                                       CAS006
     F                                     PREFIX(FR)                                         CAS006
      ** Midas IR Revalued FRA File                                                           CAS006
                                                                                              CAS006
     FFRNPVLL0  IF   E           K DISK    INFSR(*PSSR)                                       CAS006
     F                                     RENAME(FRNPVAD0:FRNPVLD0)                          CAS006
     F                                     PREFIX(FB)                                         CAS006
      ** Midas IR Revalued FRA Using Net Treasury File                                        CAS006
                                                                                              CAS006
     FMMNPVLL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas MM Revalued Deals by Deal Number
 
     FLENPVLL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas LE Revalued Customer Loans by Loan Number
 
     FSDHEDGL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Hedging ICD File Retrieval
 
     FSDHGSTL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Hedge Strategy by Shortname Master File
 
      ** Retrieve details from PF/SEMKVLPD for hedged SE book positions                       CAS006
      ** instead of from PF/SENPVLPD.                                                         CAS006
     F***SENPVLL0  IF   E           K DISK    INFSR(*PSSR)                                    CAS006
      ***Midas*SE*Revalued*Security*Positions*File*********************                       CAS006
                                                                                              CAS006
     FSEMKVLL0  IF   E           K DISK    INFSR(*PSSR)                                       CAS006
      ** Midas SE Market Values Using Net-Treasury-Prices                                     CAS006
 
     FDLNPVLL3  IF   E           K DISK    INFSR(*PSSR)
      ** Midas DL Forward Commitments File
 
     FDLDLDBL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas FX Deals by DLNO for Forward Reval NPV Mtd
 
     FSDDEALL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Dealing data retrieval
 
     FDEALALL   IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDGF)
     F                                     IGNORE(DEALSDFF)
      ** Midas DL All deals
                                                                                              CAS004
     FDRSDEALS  IF   E           K DISK    INFSR(*PSSR)                                       CAS004
     F                                     RENAME(DEALSDBF:DEALSB)                            CAS004
     F                                     IGNORE(DEALSDAF)                                   CAS004
     F                                     IGNORE(DEALSDCF)                                   CAS004
     F                                     IGNORE(DEALSDDF)                                   CAS004
     F                                     IGNORE(DEALSDEF)                                   CAS004
     F                                     IGNORE(DEALSDGF)                                   CAS004
     F                                     IGNORE(DEALSDFF)                                   CAS004
     F                                     PREFIX(D)                                          CAS004
      ** Midas DL All deals                                                                   CAS004
                                                                                              CAS005
     FDEALS     IF   E           K DISK    INFSR(*PSSR)                                       CAS005
     F                                     RENAME(DEALSDCF:DEALSC5)                           CAS005
     F                                     RENAME(DEALSDDF:DEALSD5)                           CAS005
     F                                     IGNORE(DEALSDAF)                                   CAS005
     F                                     IGNORE(DEALSDBF)                                   CAS005
     F                                     IGNORE(DEALSDEF)                                   CAS005
     F                                     IGNORE(DEALSDGF)                                   CAS005
     F                                     IGNORE(DEALSDFF)                                   CAS005
     F                                     PREFIX(CD)                                         CAS005
      ** Midas DL All deals                                                                   CAS005
                                                                                              CAS005
     FDLDLDGLE  IF   E           K DISK    INFSR(*PSSR)                                       CAS005
     F                                     PREFIX(DG)                                         CAS005
      ** Midas FRA/IRS Deals                                                                  CAS005
                                                                                              CAS005
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)                                       CAS005
     F                                     IGNORE(CLOANHHF)                                   CAS005
     F                                     IGNORE(CLOANCKF)                                   CAS005
     F                                     IGNORE(CLOANZ1F)                                   CAS005
     F                                     PREFIX(L1)                                         CAS005
      ** Midas Loans                                                                          CAS005
                                                                                              CAS006
     FBKPHD     IF   E           K DISK    INFSR(*PSSR)                                       CAS006
     F                                     PREFIX(B2)                                         CAS006
      ** Midas SE Book Position Headers                                                       CAS006
 
     FTRANS2    IF   E           K DISK    INFSR(*PSSR)                                       CAS003
      ** Midas FF Transaction details                                                         CAS003
                                                                                              CAS003
     FFFNPVLL0  IF   E           K DISK    INFSR(*PSSR)                                       CAS003
      ** Midas FF Revalued FF Positions File                                                  CAS003
                                                                                              CAS003
     FASDLHML2  IF   E           K DISK    INFSR(*PSSR)                                       CAS006
     F                                     PREFIX(D2:2)                                       CAS006
      ** Midas AS Dealing Historic Market Data File                                           CAS006
      ** by Deal number and Value date - LIVE                                                 CAS006
                                                                                              CAS006
     FASDLHML3  IF   E           K DISK    INFSR(*PSSR)                                       CAS006
     F                                     PREFIX(D3:2)                                       CAS006
     F                                     RENAME(ASDLHMD0:ASDLHMD3)                          CAS006
      ** Midas AS Dealing Historic Market Data File                                           CAS006
      ** by Deal number and Value date - LIVE                                                 CAS006
                                                                                              CAS006
     FASSEHML0  IF   E           K DISK    INFSR(*PSSR)                                       CAS006
     F                                     PREFIX(SC:2)                                       CAS006
      ** Midas AS Securities Historic Market Data File                                        CAS006
      ** by Security shortname and Value date - LIVE                                          CAS006
                                                                                              CAS006
     FASLEHML2  IF   E           K DISK    INFSR(*PSSR)                                       CAS006
     F                                     PREFIX(LE:2)                                       CAS006
      ** Midas AS Lending Historic Market Data File                                           CAS006
      ** by Loan number and value date - LIVE                                                 CAS006
                                                                                              CAS006
     FSDTDTBL0  IF   E           K DISK    INFSR(*PSSR)                                       CAS006
      ** Midas SD T Distribution Table File Retrieval                                         CAS006
      *                                                                                       CAS008
     FASHTRNLE  IF   E           K DISK    INFSR(*PSSR)                                       CAS008
     F                                     RENAME(ASHTRND0:ASHTRNHI)                          CAS008
     F                                     PREFIX(L)                                          CAS008
      ** Midas AS Hedge Transaction File Retrieval                                            CAS008
     FPRICM     IF   E           K DISK    INFSR(*PSSR)                                       CAS008
     F                                     PREFIX(P)                                          CAS008
                                                                                              CAS008
     FIRSNHVL0  IF   E           K DISK    INFSR(*PSSR)                                       CAS008
     FFRANHVL0  IF   E           K DISK    INFSR(*PSSR)                                       CAS008
     FRXSNHVL1  IF   E           K DISK    INFSR(*PSSR)                                       CAS008
     FDLNHVLL3  IF   E           K DISK    INFSR(*PSSR)                                       CAS008
      ** Midas Delayed Value Derivatives File                                                 CAS008
     FSEMKVDL1  IF   E           K DISK    INFSR(*PSSR)                                       CAS008
                                                                                              CAS006
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
                                                                                              CAS003
      ** External data structure for Switchable Features Details                              CAS003
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS003
 
      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for General Ledger ICD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D                 DS                                                                     CAS003
     D  WDSfpse                1     10                                                       CAS003
     D  WDSistt                1      5                                                       CAS003
     D  WDSmnth                6      8                                                       CAS003
     D  WDSyear                9     10  0                                                    CAS003
                                                                                              CAS003
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for AOBANKR0/AOCURRR0
     D PRetrnCde       S              7A
     D POption         S              7A
     D PCurrency       S              3A
                                                                                              CAS003
      ** Parameters for AOSARDR0                                                              CAS003
     D PRtrnCode       S              7A                                                      CAS003
     D POptn           S              7A                                                      CAS003
     D PSard           S              6A                                                      CAS003
 
      ** Parameters for ZFREQB
     D***PRetCodeIn      S              7A                                                    212408
     D PRetCodeIn      S             10A                                                      212408
     D PZFreq          S              1A
     D***PZDayno         S              5P 0                                                  212408
     D PZDayno         S              5  0                                                    212408
     D PZCcy           S              3A
     D PZLoc           S              3A                                                    AR702741
     D***PZMday          S              2P 0                                                  212408
     D PZMday          S              2  0                                                    212408
     D PBJDFIN         S              1A
 
      ** Parameters for ZDATE2                                                                CAS004
     D PzDayNo2        S              5  0                                                    CAS004
     D PBJDFIN2        S              1                                                       CAS004
     D PzDateB2        S              6  0                                                    CAS004
     D PZADate2        S              7                                                       CAS004
                                                                                              CAS004
      ** Parameters for ZBKDT                                                                 CAS004
     D PzDayNo3        S              5  0                                                    CAS004
     D PzCCY3          S              3                                                       CAS004
     D PZLoc3          S              3                                                       CAS004
     D PZNRdys3        S              2  0                                                    CAS004
     D PZDyNbr3        S              5  0                                                    CAS004
                                                                                              CAS004
      ** Fields used to define Key List for Midas DL Forward Commitment File
     D KDLnpvm         S              1A
     D KDLdlno         S              6P 0
     D KDLcycd         S              3A
 
      ** Fields used to define Key List for Midas AS Hedge Transaction File
      ** Retrieval
     D KAShedi         S              6P 0
     D KASdhin         S              1A
     D KAShed5         S              6P 0                                                    CAS005
     D KASdhi5         S              1A                                                      CAS005
 
      ** Fields used to define Key List for Midas SE Revalued Security
      ** Positions File
     D KSEsesn         S             10A
     D KSEbrca         S              3A
     D KSEbokc         S              2A
     D KSEmkti         S              1A
     D KSEbhtv         S              1A
 
      ** Fields used to define Key List for Midas FF Revalued FF Positions                    CAS003
      ** File                                                                                 CAS003
     D KFFbrca         S              3A                                                      CAS003
     D KFFbkcd         S              2A                                                      CAS003
     D KFFistt         S              5A                                                      CAS003
     D KFFyrno         S              2P 0                                                    CAS003
     D KFFmthn         S              2P 0                                                    CAS003
     D KFFpcal         S              1A                                                      CAS003
                                                                                              CAS003
                                                                                              CAS006
      ** Fields used to define Key List for Midas SD T Distribution Table                     CAS006
     D KXXDfrd         S                   LIKE(XXDfrd)                                       CAS006
     D KXXArea         S                   LIKE(XXArea)                                       CAS006
      ** Fields used to define Key List for Midas Delay Hedge                                 CAS008
     D KDealNo         S              6P 0                                                    CAS008
     D KABInd          S              1A                                                      CAS008
     D KDEffd          S              5P 0                                                    CAS008
                                                                                              CAS006
     D WAmount         S             13P 0
     D WUnrealPL       S             13P 0
     D WUnrealPLye     S             13P 0
     D WWCYCD          S              3A
     D WBaseCCY        S              3A
     D WDerivAmtA      S             15P 0
     D WDerivURPLA     S             15P 0
     D WDerivURPLyeA   S             15P 0
     D WHedgeAmtA      S             15P 0
     D WHedgeURPLA     S             15P 0
     D WHedgeURPLyeA   S             15P 0
     D WDerivDiff      S             20P 5
     D WHedgeDiff      S             20P 5
     D WChange         S             20P 5
     D***WChngPerc       S              7P 4                                                  217825
     D WChngPerc       S              9P 4                                                    217825
     D WDerivDeMin     S             20P 5
     D WHedgeDeMin     S             20P 5
     D WNoRec          S              1A
     D WLinkedDLNO     S              6P 0
     D WRun            S              1A
     D WkEvCtDt        S              5P 0                                                    CAS004
     D Wmnth           S              2P 0                                                    CAS003
     D WMnth1          S              2  0                                                    CAS004
     D WMnth2          S              2  0                                                    CAS004
     D WMnthT          S              4  0                                                    CAS004
     D CAS003          S              1                                                       CAS003
     D CAS004          S              1                                                       CAS004
     D CAS005          S              1A                                                      CAS005
     D CAS006          S              1A                                                      CAS006
     D CAS008          S              1A                                                      CAS008
     D WkPRTP          S              2A                                                      CAS005
     D WkBase          S              1A                                                      CAS005
     D WkFound         S              1A                                                      CAS005
     D WkCYCD          S              3A                                                      CAS005
     D KRXCyCd         S              3A                                                      CAS005
     D***KRXDlNo         S                   LIKE(FSDLNO)                              CAS005 CLE148
     D KRXDlNo         S              6P 0                                                    CLE148
     D WkRInd          S                   LIKE(FSRIND)                                       CAS005
     D WTYPE           S              2A                                                      CAS005
     D KDerivHEDI      S                   LIKE(FSHEDI)                                       CAS006
     D KDerivDLNO      S                   LIKE(FSDLNO)                                       CAS006
     D KHedgdHEDI      S                   LIKE(FSHEDI)                                       CAS006
     D KHedgdDLNO      S                   LIKE(FSDLNO)                                       CAS006
     D KHedgdSESN      S                   LIKE(FSFPSE)                                       CAS006
     D KHedgdBRCA      S                   LIKE(FSBRCA)                                       CAS006
     D KHedgdBKCD      S                   LIKE(FSBKCD)                                       CAS006
     D KHedgdMKTI      S                   LIKE(FSMKTI)                                       CAS006
     D KHedgdBHTV      S                   LIKE(FSBHTV)                                       CAS006
     D WDf             S                   LIKE(XXDFRD)                                       CAS006
     D WAlpha          S                   LIKE(XXAREA)                                       CAS006
     D WCounter        S                   LIKE(FSDPTS)                                       CAS006
     D WTVALUE         S                   LIKE(XXTVAL)                                       CAS006
     D WDerivHMDRead   S              1A                                                      CAS006
     D WHedgdHMDRead   S              1A                                                      CAS006
     D WDerivHMD       S             12  0                                                    CAS006
     D WHedgdHMD       S             12  0                                                    CAS006
     D WD2Mval12       S             12S 0                                                    CAS006
     D WD2Mvca12       S             12S 0                                                    CAS006
     D WD2Mrat12       S             12S 8                                                    CAS006
     D WD3Mval12       S             12S 0                                                    CAS006
     D WD3Mvca12       S             12S 0                                                    CAS006
     D WD3Mrat12       S             12S 8                                                    CAS006
     D WLEMval12       S             12S 0                                                    CAS006
     D WLEMvca12       S             12S 0                                                    CAS006
     D WLEMrat12       S             12S 8                                                    CAS006
     D WSCMval12       S             12S 0                                                    CAS006
     D WSCMvca12       S             12S 0                                                    CAS006
     D WSCMrat12       S             12S 8                                                    CAS006
     D WTs             S             16  4                                                    CAS006
     D WSSE            S             30  3                                                    CAS006
     D WSUMX           S             15  0                                                    CAS006
     D WSumXSqrd       S             27  0                                                    CAS006
     D WWxx            S             30  3                                                    CAS006
     D WSUMXY          S             27  0                                                    CAS006
     D WWxy            S             30  3                                                    CAS006
     D WSUMY           S             15  0                                                    CAS006
     D WSumYSqrd       S             27  0                                                    CAS006
     D WWyy            S             30  3                                                    CAS006
     D WSxx            S             30  3                                                    CAS006
     D WSxy            S             30  3                                                    CAS006
     D WSyy            S             30  3                                                    CAS006
     D WWse            S             30 10                                                    CAS006
     D WTsNum          S             30  8                                                    CAS006
     D WTsDen          S             30  8                                                    CAS006
     D WTsDen1         S             30  8                                                    CAS006
     D WTsDen2         S             30  8                                                    CAS006
     D WRSqrd          S              9  7                                                    CAS006
     D WSlopeCoeff     S             15  3                                                    CAS006
     D WHedgdPCTG      S              5  4                                                    CAS006
     D WDerivPCTG      S              5  4                                                    CAS006
     D WXXDfrd         S              3A                                                      CAS006
     D WXXArea         S              5A                                                      CAS006
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
     ISDHGSTD0
     I              FSDVT10                     FSDVT0
     I              FSDST10                     FSDST0
     I              FSDBK10                     FSDBK0
     I              FSHDT10                     FSHDT0
     I              FSHST10                     FSHST0
     I              FSHBK10                     FSHBK0
     IDLNPVLD0
     I              FSDAMT                      DLDAMT
     I              FSDLNO                      DLDLNO                                        CLE148
     IDLNHVLD0                                                                                CAS008
     I              FSDAMT                      DLDAMT                                        CAS008
     I              FSDLNO                      DLDLNO                                        CLE148
     IDEALSDBF                                                                                CAS004
     I              FSEFUP                      FSEFUPB                                       CAS004
     IDEALSDCF                                                                                CAS004
     I              FSEFUP                      FSEFUPC                                       CAS004
 
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
 
      **  Read Midas SD Hedging ICD File Retrieval
 
     C                   READ      SDHEDGL1
 
      ** Database error
 
     C                   IF        %EOF(SDHEDGL1)
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'SDHEDGL1'
     C                   EVAL      DBKEY  =  '*CALL'
     C                   EVAL      DBASE  =  002
     C                   EVAL      DBPROC =  'SR/Main'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **  Read Midas SD Dealing data retrieval
 
     C                   READ      SDDEALL1
 
      ** If record found
 
     C                   IF        Not %EOF(SDDEALL1)
 
      ** If Reval NPV method is blank,
 
     C                   IF        BNNPVM = *BLANKS
     C                   EVAL      KDLnpvm = 'N'
 
      ** else,
 
     C                   ELSE
     C                   EVAL      KDLnpvm = BNNPVM
     C                   ENDIF
 
     C                   ENDIF
                                                                                              CAS004
      ** Set the event control date                                                           CAS004
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
     C                   EVAL      WkEvCtDt = BJDNWD - 1                                      CAS004
     C                   IF        BKAPDT < WkEvCtDt                                          CAS004
     C                   EVAL      WkEvCtDt = BKAPDT                                          CAS004
     C                   ENDIF                                                                CAS004
     C                   ENDIF                                                                CAS004
 
      ** Read all hedges in the system.
 
     C                   READ      ASHGLKL0
 
      ** Do while not end of file
 
     C                   DOW       NOT %EOF(ASHGLKL0)
                                                                                              CAS008
      ** If Delayed Hedge Assesment is on and delay days are defined                          CAS008
      ** for securities, then assessment should be done if effective                          CAS008
      ** date + delay days is equal to rundate or if a latest price                           CAS008
      ** change took place before assessment date for the delay.                              CAS008
                                                                                              CAS008
     C                   IF        CAS008 = 'Y'                                               CAS008
     C                             and FSSECR = 'Y'                                           CAS008
     C                             and FSNDDP <> 0                                            CAS008
                                                                                              CAS008
     C                   Z-ADD     FSEFFD        XFSEFFD           5 0                        CAS008
                                                                                              CAS008
     C                   CALLB     'ZFWDT'                                                    CAS008
     C                   PARM      FSEFFD        PzDayNo3                                     CAS008
     C                   PARM      FSNDDP        PZNRdys3                                     CAS008
     C                   PARM                    PZDyNbr3                                     CAS008
     C                   PARM      BJCYCD        PzCCY3                                       CAS008
     C                   PARM                    PZLoc3                                       CAS008
                                                                                              CAS008
     C                   EVAL      FSEFFD = PZDyNbr3                                          CAS008
                                                                                              CAS008
     C                   ENDIF                                                                CAS008
 
      ** For every record in ASHGLKPD, check if the effective date is equal
      ** to rundate.  If so, perform hedge effectiveness assessment.
 
     C                   IF        FSRECI = 'D'
     C                             and FSEFFD = BJRDNB
     C                             AND CAS004 = 'N'                                           CAS004
     C                             OR  FSRECI = 'D' AND FSEFFD <= WkEvCtDt                    CAS004
     C                             AND CAS004 = 'Y'                                           CAS004
                                                                                              CAS008
      **  After conditions were satisfied make sure to return original                        CAS008
      **  effective date for processing.                                                      CAS008
                                                                                              CAS008
     C                   IF        CAS008 = 'Y'                                               CAS008
     C                             and FSSECR = 'Y'                                           CAS008
     C                             and FSNDDP <> 0                                            CAS008
     C                   Z-ADD     XFSEFFD       FSEFFD                                       CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS005
     C                   EVAL      WkRInd = *BLANKS                                           CAS005
 
      ** Initialize Accumulators
 
     C                   EXSR      SRInitAcc
 
      ** Check if not hedging forecast transactions
 
     C                   EVAL      KAShedi = FSHEDI
     C                   EVAL      KASdhin = 'H'
     C     KASHTRN       CHAIN     ASHTRNL1
      *
     C                   IF        %FOUND(ASHTRNL1)
     C                             and FSMOD <> 'FH'
 
      ** Check if hedging internal contracts
 
     C                   EXSR      SRChkHInt
 
      ** DERIVATIVES - hedging instruments
 
     C                   EXSR      SRDerivat
 
      ** Hedged Items
 
     C                   IF        WNoRec <> 'Y'
 
     C                   EXSR      SRHedgedI
 
     C                   ENDIF
 
      ** Assess Effectiveness
 
     C                   EXSR      SRCalcuHE
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Read next record on LF/ASHGLKL0
 
     C                   READ      ASHGLKL0
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInitAcc - Initializes Accumulators                         *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRInitAcc     BEGSR
 
     C                   EVAL      WDerivAmtA = *ZERO
     C                   EVAL      WDerivURPLA = *ZERO
     C                   EVAL      WDerivURPLyeA = *ZERO
     C                   EVAL      WHedgeAmtA = *ZERO
     C                   EVAL      WHedgeURPLA = *ZERO
     C                   EVAL      WHedgeURPLyeA = *ZERO
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkHInt - Checks if Hedging Internal Contracts             *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRChkHInt     BEGSR
 
     C                   EVAL      WLinkedDLNO = *ZERO
 
     C*****FSDLNO        CHAIN     DLDLDBL1                                                   CLE148
     C                   MOVEL     FSDLNO        FSDLNO2           6 0                        CLE148
     C     FSDLNO2       CHAIN     DLDLDBL1                                                   CLE148
 
     C                   IF        %FOUND(DLDLDBL1)
     C                             and LNKDN <> *ZERO
 
     C                   EVAL      WLinkedDLNO = LNKDN
 
      ** For Derivatives, access the linked internal contract deal                            CAS004
     C                   IF        FSDHIN = 'D'                                               CAS004
                                                                                              CAS004
     C     LNKDN         CHAIN     DRSDEALS                                                   CAS004
     C                   IF        %FOUND(DRSDEALS)                                           CAS004
     C                             and DLNKDN <> *ZERO                                        CAS004
     C                   EVAL      LNKDN = DLNKDN                                             CAS004
     C                   EVAL      WLinkedDLNO = LNKDN                                        CAS004
     C                   ELSE                                                                 CAS004
     C                   EVAL      WLinkedDLNO = *ZERO                                        CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C     LNKDN         CHAIN     DEALALL
     C                   IF        %FOUND(DEALALL)
     C                   EVAL      KDLcycd = CCY
     C                   ELSE
     C                   EVAL      WLinkedDLNO = *ZERO
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDerivat - Retrieves the Hedging Instruments Transactions   *
      *              Under Each Hedge ID and Sum the NPV Amounts for  *
      *              All Retrieved Hedging Instruments                *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: SRDerivDL                                             *
      *         SRDerivFF                                             *                       CAS003
      *                                                               *
      *****************************************************************
 
     C     SRDerivat     BEGSR
 
     C                   EVAL      KAShedi = FSHEDI
     C                   EVAL      KASdhin = 'D'
     C                   EVAL      WNoRec = *BLANK
 
     C     KASHTRN       CHAIN     ASHTRNL1                           25
 
     C                   DOW       *IN25 = *OFF
 
     C                   EVAL      WAmount = *ZERO
     C                   EVAL      WUnrealPL = *ZERO
     C                   EVAL      WUnrealPLye = *ZERO
     C                   EVAL      WWCYCD = *BLANKS
 
      ** Retrieve NPV Amounts
 
     C                   IF        FSMOD = 'DL'
                                                                                              CAS008
     C                   IF        CAS008 = 'Y'                                               CAS008
     C                             And FSSECR = 'Y'                                           CAS008
     C                             And FSNDDP <> 0                                            CAS008
     C                   EXSR      SRDelayDL                                                  CAS008
     C                   ELSE                                                                 CAS008
     C                   EXSR      SRDerivDL
     C                   ENDIF                                                                CAS008
     C                   ENDIF
                                                                                              CAS003
     C                   IF        FSMOD = 'FF' AND CAS003 = 'Y'                              CAS003
     C                   EXSR      SRDerivFF                                                  CAS003
     C                   ENDIF                                                                CAS003
 
     C     KASHTRN       READE     ASHTRNL1                               25
     C                   ENDDO
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDerivDL - Retrieves the Hedging Instrument's NPV           *
      *              Information of Dealing Transactions              *
      *                                                               *
      *  Called by: SRDerivat                                         *
      *                                                               *
      *  Calls: SRAccuAmt                                             *
      *                                                               *
      *****************************************************************
 
     C     SRDerivDL     BEGSR
 
     C                   EVAL      WTYPE = *BLANKS                                            CAS005
                                                                                              CAS005
      ** If Enhancements to CAS001, CAS002 and CAS004 is installed, check                     CAS005
      ** hedged item                                                                          CAS005
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
                                                                                              CAS005
      ** Call subroutines that check for hedged item whether All-in-Rate                      CAS005
      ** or Base Rate File must be used                                                       CAS005
                                                                                              CAS005
     C                   EXSR      SRChkHdgI                                                  CAS005
     C                   EVAL      WkFound = 'N'                                              CAS005
                                                                                              CAS005
      ** Check deal type of the derivative                                                    CAS005
                                                                                              CAS005
     C*****FSDLNO        CHAIN     DLDLDGLE                                            CAS005 CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     DLDLDGLE                                                   CLE148
     C                   IF        %FOUND(DLDLDGLE)                                           CAS005
                                                                                              CAS005
     C                   SELECT                                                               CAS005
                                                                                              CAS005
      ** Revalued SIRS using All-in-Rate File                                                 CAS005
                                                                                              CAS005
     C                   WHEN      DGDTYP = 'RS' AND WkBase <> 'Y'                            CAS005
     C*****FSDLNO        CHAIN     IRNPVAL0                                            CAS005 CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     IRNPVAL0                                                   CLE148
     C                   IF        %FOUND(IRNPVAL0)                                           CAS005
     C                   EVAL      WAmount = IRPAMT                                           CAS005
     C                   EVAL      WUnrealPL = IRURPL                                         CAS005
     C                   EVAL      WUnrealPLye = IRYUPL                                       CAS005
     C                   EVAL      WWCYCD = IRCYCD                                            CAS005
     C                   EVAL      WkRInd = 'L'                                               CAS005
     C                   EVAL      WkFound = 'Y'                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Revalued SIRS using Base Rate File                                                   CAS005
                                                                                              CAS005
     C                   WHEN      DGDTYP = 'RS' AND WkBase = 'Y'                             CAS005
     C*****FSDLNO        CHAIN     IRNPVBL0                                            CAS005 CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     IRNPVBL0                                                   CLE148
     C                   IF        %FOUND(IRNPVBL0)                                           CAS005
     C                   EVAL      WAmount = SBIRPAMT                                         CAS005
     C                   EVAL      WUnrealPL = SBIRURPL                                       CAS005
     C                   EVAL      WUnrealPLye = SBIRYUPL                                     CAS005
     C                   EVAL      WWCYCD = SBIRCYCD                                          CAS005
     C                   EVAL      WkRInd = 'B'                                               CAS005
     C                   EVAL      WkFound = 'Y'                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Revalued CIRS using All-in-Rate File                                                 CAS005
                                                                                              CAS005
     C                   WHEN      DGDTYP = 'RX' AND WkBase <> 'Y'                            CAS005
                                                                                              CAS005
     C                   EVAL      WTYPE = 'RX'                                               CAS005
     C**********         EVAL      KRXDlNo = FSDLNO                                    CAS005 CLE148
     C                   EVAL      KRXDlNo = FSDLNO2                                          CLE148
     C                   EVAL      KRXCyCd = WkCYCD                                           CAS005
     C     KRXNPV        CHAIN     RXNPVAL1                                                   CAS005
     C                   IF        %FOUND(RXNPVAL1)                                           CAS005
     C                   EVAL      WAmount = RXIRPAMT                                         CAS005
     C                   EVAL      WUnrealPL = RXIRURPL                                       CAS005
     C                   EVAL      WUnrealPLye = RXIRYUPL                                     CAS005
     C                   EVAL      WWCYCD = RXIRCYCD                                          CAS005
     C                   EVAL      WkRInd = 'L'                                               CAS005
     C                   EVAL      WkFound = 'Y'                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Revalued CIRS using Base Rate File                                                   CAS005
                                                                                              CAS005
     C                   WHEN      DGDTYP = 'RX' AND WkBase = 'Y'                             CAS005
     C                   EVAL      WTYPE = 'RX'                                               CAS005
     C**********         EVAL      KRXDlNo = FSDLNO                                    CAS005 CLE148
     C                   EVAL      KRXDlNo = FSDLNO2                                          CLE148
     C                   EVAL      KRXCyCd = WkCYCD                                           CAS005
     C     KRXNPV        CHAIN     RXNPVBL1                                                   CAS005
     C                   IF        %FOUND(RXNPVBL1)                                           CAS005
     C                   EVAL      WAmount = CBIRPAMT                                         CAS005
     C                   EVAL      WUnrealPL = CBIRURPL                                       CAS005
     C                   EVAL      WUnrealPLye = CBIRYUPL                                     CAS005
     C                   EVAL      WWCYCD = CBIRCYCD                                          CAS005
     C                   EVAL      WkRInd = 'B'                                               CAS005
     C                   EVAL      WkFound = 'Y'                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS006
      ** Revalued FRA using All-in-Rate File                                                  CAS006
                                                                                              CAS006
     C                   WHEN      DGDTYP = 'FR' AND WkBase <> 'Y'                            CAS006
     C                             AND CAS006 = 'Y'                                           CAS006
     C*****FSDLNO        CHAIN     FRNPVAL0                                            CAS006 CLE148
     C     FSDLNO2       CHAIN     FRNPVAL0                                                   CLE148
     C                   IF        %FOUND(FRNPVAL0)                                           CAS006
     C                   EVAL      WAmount = FRIRPAMT                                         CAS006
     C                   EVAL      WUnrealPL = FRIRURPL                                       CAS006
     C                   EVAL      WUnrealPLye = FRIRYUPL                                     CAS006
     C                   EVAL      WWCYCD = FRIRCYCD                                          CAS006
     C                   EVAL      WkRInd = 'L'                                               CAS006
     C                   EVAL      WkFound = 'Y'                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Revalued FRA using Net Treasury Rate File                                            CAS006
                                                                                              CAS006
     C                   WHEN      DGDTYP = 'FR' AND WkBase = 'Y'                             CAS006
     C                             AND CAS006 = 'Y'                                           CAS006
     C*****FSDLNO        CHAIN     FRNPVLL0                                            CAS006 CLE148
     C     FSDLNO2       CHAIN     FRNPVLL0                                                   CLE148
     C                   IF        %FOUND(FRNPVLL0)                                           CAS006
     C                   EVAL      WAmount = FBIRPAMT                                         CAS006
     C                   EVAL      WUnrealPL = FBIRURPL                                       CAS006
     C                   EVAL      WUnrealPLye = FBIRYUPL                                     CAS006
     C                   EVAL      WWCYCD = FBIRCYCD                                          CAS006
     C                   EVAL      WkRInd = 'B'                                               CAS006
     C                   EVAL      WkFound = 'Y'                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS005
     C                   ENDSL                                                                CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** FRA/IRS
 
     C*****FSDLNO        CHAIN     IRNPVLL0                                                   CAS005
     C*****FSDLNO        CHAIN     IRNPVAL0                                            CAS005 CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     IRNPVAL0                                                   CLE148
     C**********         IF        %FOUND(IRNPVLL0)                                           CAS005
     C                   IF        %FOUND(IRNPVAL0)                                           CAS005
     C                             AND CAS005 = 'N' OR                                        CAS005
                                                                                              CAS005
      ** This next condition, if satisfied, actually does not do anything.                    CAS005
      ** However, if not satisfied, must do the ELSE part                                     CAS005
                                                                                              CAS005
     C                             CAS005 = 'Y' AND WkFound = 'Y'                             CAS005
 
      ** Move transaction details,
 
     C                   IF        %FOUND(IRNPVAL0) AND CAS005 = 'N'                          CAS005
     C                   EVAL      WAmount = IRPAMT
     C                   EVAL      WUnrealPL = IRURPL
     C                   EVAL      WUnrealPLye = IRYUPL
     C                   EVAL      WWCYCD = IRCYCD
     C                   ENDIF                                                                CAS005
 
     C                   ELSE
 
      ***Cross*Currency*Deals**********************************************                   CAS005
      ** Internal Contracts                                                                   CAS005
 
     C                   IF        WLinkedDLNO <> *ZERO
 
     C**********         EVAL      KDLdlno = FSDLNO                                           CLE148
     C                   EVAL      KDLdlno = FSDLNO2                                          CLE148
 
     C     KDLNPVL       CHAIN     DLNPVLL3
     C                   IF        %FOUND(DLNPVLL3)
 
      ** Move transaction details,
 
     C                   MOVE      DLDLNO        FSDLNO                                       CLE148
     C                   EVAL      WAmount = DLDAMT
     C                   EVAL      WUnrealPL = FSPRLA
     C                   IF        KDLcycd  = PUCY                                            CAS004
     C                   EVAL      WUnrealPLye = FSYUPL
     C                   ELSE                                                                 CAS004
     C                   EVAL      WUnrealPLye = FSSYPL                                       CAS004
     C                   ENDIF                                                                CAS004
     C                   EVAL      WWCYCD = FSCYCD
 
     C                   ELSE
     C                   EVAL      WNoRec = 'Y'
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      WNoRec = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EXSR      SRAccuAmt
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************                       CAS008
      *                                                               *                       CAS008
      *  SRDelayDL - Retrieves Historic Hedging Instrument's NPV      *                       CAS008
      *              Information of dealing transactions on effective *                       CAS008
      *              date.                                            *                       CAS008
      *                                                               *                       CAS008
      *  Called by: SRDerivat                                         *                       CAS008
      *                                                               *                       CAS008
      *  Calls: SRAccuAmt                                             *                       CAS008
      *                                                               *                       CAS008
      *****************************************************************                       CAS008
                                                                                              CAS008
     C     SRDelayDL     BEGSR                                                                CAS008
                                                                                              CAS008
     C                   EVAL      WTYPE = *BLANKS                                            CAS008
     C                   EVAL      KDEffd = FSEFFD                                            CAS008
                                                                                              CAS008
      ** If Enhancements to CAS001, CAS002 and CAS004 is installed, check                     CAS008
      ** hedged item                                                                          CAS008
                                                                                              CAS008
     C                   IF        CAS005 = 'Y'                                               CAS008
                                                                                              CAS008
      ** Call subroutines that check for hedged item whether All-in-Rate                      CAS008
      ** or Base Rate File must be used                                                       CAS008
                                                                                              CAS008
     C                   EXSR      SRChkHdgI                                                  CAS008
     C                   EVAL      WkFound = 'N'                                              CAS008
                                                                                              CAS008
      ** Check deal type of the derivative                                                    CAS008
                                                                                              CAS008
     C*****FSDLNO        CHAIN     DLDLDGLE                                            CAS008 CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     DLDLDGLE                                                   CLE148
     C                   IF        %FOUND(DLDLDGLE)                                           CAS008
                                                                                              CAS008
     C**********         EVAL      KDealno = FSDLNO                                    CAS008 CLE148
     C                   EVAL      KDealno = FSDLNO2                                          CLE148
     C                   SELECT                                                               CAS008
                                                                                              CAS008
      ** Revalued SIRS using All-in-Rate File                                                 CAS008
                                                                                              CAS008
     C                   WHEN      DGDTYP = 'RS' AND WkBase <> 'Y'                            CAS008
     C                   EVAL      KABInd = 'A'                                               CAS008
     C     KDlyHV        CHAIN     IRSNHVL0                                                   CAS008
     C                   IF        %FOUND(IRSNHVL0)                                           CAS008
     C                   EVAL      WAmount = IRPAMT                                           CAS008
     C                   EVAL      WUnrealPL = IRURPL                                         CAS008
     C                   EVAL      WUnrealPLye = IRYUPL                                       CAS008
     C                   EVAL      WWCYCD = IRCYCD                                            CAS008
     C                   EVAL      WkRInd = 'L'                                               CAS008
     C                   EVAL      WkFound = 'Y'                                              CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
      ** Revalued SIRS using Base Rate File                                                   CAS008
                                                                                              CAS008
     C                   WHEN      DGDTYP = 'RS' AND WkBase = 'Y'                             CAS008
     C                   EVAL      KABInd = 'B'                                               CAS008
     C     KDlyHV        CHAIN     IRSNHVL0                                                   CAS008
     C                   IF        %FOUND(IRSNHVL0)                                           CAS008
     C                   EVAL      WAmount = IRPAMT                                           CAS008
     C                   EVAL      WUnrealPL = IRURPL                                         CAS008
     C                   EVAL      WUnrealPLye = IRYUPL                                       CAS008
     C                   EVAL      WWCYCD = IRCYCD                                            CAS008
     C                   EVAL      WkRInd = 'B'                                               CAS008
     C                   EVAL      WkFound = 'Y'                                              CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
      ** Revalued CIRS using All-in-Rate File                                                 CAS008
                                                                                              CAS008
     C                   WHEN      DGDTYP = 'RX' AND WkBase <> 'Y'                            CAS008
                                                                                              CAS008
     C                   EVAL      WTYPE = 'RX'                                               CAS008
     C                   EVAL      KABInd = 'A'                                               CAS008
     C**********         EVAL      KRXDlNo = FSDLNO                                    CAS008 CLE148
     C                   EVAL      KRXDlNo = FSDLNO2                                          CLE148
     C                   EVAL      KRXCyCd = WkCYCD                                           CAS008
     C     KDlyHVR       CHAIN     RXSNHVL1                                                   CAS008
     C                   IF        %FOUND(RXSNHVL1)                                           CAS008
     C                   EVAL      WAmount = IRPAMT                                           CAS008
     C                   EVAL      WUnrealPL = IRURPL                                         CAS008
     C                   EVAL      WUnrealPLye = IRYUPL                                       CAS008
     C                   EVAL      WWCYCD = IRCYCD                                            CAS008
     C                   EVAL      WkRInd = 'L'                                               CAS008
     C                   EVAL      WkFound = 'Y'                                              CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
      ** Revalued CIRS using Base Rate File                                                   CAS008
                                                                                              CAS008
     C                   WHEN      DGDTYP = 'RX' AND WkBase = 'Y'                             CAS008
     C                   EVAL      KABInd = 'B'                                               CAS008
     C                   EVAL      WTYPE = 'RX'                                               CAS008
     C**********         EVAL      KRXDlNo = FSDLNO                                    CAS008 CLE148
     C                   EVAL      KRXDlNo = FSDLNO2                                          CLE148
     C                   EVAL      KRXCyCd = WkCYCD                                           CAS008
     C     KDlyHVR       CHAIN     RXSNHVL1                                                   CAS008
     C                   IF        %FOUND(RXSNHVL1)                                           CAS008
     C                   EVAL      WAmount = IRPAMT                                           CAS008
     C                   EVAL      WUnrealPL = IRURPL                                         CAS008
     C                   EVAL      WUnrealPLye = IRYUPL                                       CAS008
     C                   EVAL      WWCYCD = IRCYCD                                            CAS008
     C                   EVAL      WkRInd = 'B'                                               CAS008
     C                   EVAL      WkFound = 'Y'                                              CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
      ** Revalued FRA using All-in-Rate File                                                  CAS008
                                                                                              CAS008
     C                   WHEN      DGDTYP = 'FR' AND WkBase <> 'Y'                            CAS008
     C                             AND CAS006 = 'Y'                                           CAS008
     C                   EVAL      KABInd  = 'A'                                              CAS008
     C     KDlyHV        CHAIN     FRANHVL0                                                   CAS008
     C                   IF        %FOUND(FRANHVL0)                                           CAS008
     C                   EVAL      WAmount = IRPAMT                                           CAS008
     C                   EVAL      WUnrealPL = IRURPL                                         CAS008
     C                   EVAL      WUnrealPLye = IRYUPL                                       CAS008
     C                   EVAL      WWCYCD = IRCYCD                                            CAS008
     C                   EVAL      WkRInd = 'L'                                               CAS008
     C                   EVAL      WkFound = 'Y'                                              CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
      ** Revalued FRA using Net Treasury Rate File                                            CAS008
                                                                                              CAS008
     C                   WHEN      DGDTYP = 'FR' AND WkBase = 'Y'                             CAS008
     C                             AND CAS006 = 'Y'                                           CAS008
     C                   EVAL      KABInd  = 'B'                                              CAS008
     C     KDlyHV        CHAIN     FRANHVL0                                                   CAS008
     C                   IF        %FOUND(FRANHVL0)                                           CAS008
     C                   EVAL      WAmount = IRPAMT                                           CAS008
     C                   EVAL      WUnrealPL = IRURPL                                         CAS008
     C                   EVAL      WUnrealPLye = IRYUPL                                       CAS008
     C                   EVAL      WWCYCD = IRCYCD                                            CAS008
     C                   EVAL      WkRInd = 'B'                                               CAS008
     C                   EVAL      WkFound = 'Y'                                              CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   ENDSL                                                                CAS008
                                                                                              CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
      ** FRA/IRS                                                                              CAS008
                                                                                              CAS008
     C                   EVAL      KABInd = 'A'                                               CAS008
     C     KDlyHV        CHAIN     IRSNHVL0                                                   CAS008
     C                   IF        %FOUND(IRSNHVL0)                                           CAS008
     C                             AND CAS005 = 'N' OR                                        CAS008
                                                                                              CAS008
      ** This next condition, if satisfied, actually does not do anything.                    CAS008
      ** However, if not satisfied, must do the ELSE part                                     CAS008
                                                                                              CAS008
     C                             CAS005 = 'Y' AND WkFound = 'Y'                             CAS008
                                                                                              CAS008
      ** Move transaction details,                                                            CAS008
                                                                                              CAS008
     C                   IF        %FOUND(IRSNHVL0) AND CAS005 = 'N'                          CAS008
     C                   EVAL      WAmount = IRPAMT                                           CAS008
     C                   EVAL      WUnrealPL = IRURPL                                         CAS008
     C                   EVAL      WUnrealPLye = IRYUPL                                       CAS008
     C                   EVAL      WWCYCD = IRCYCD                                            CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   ELSE                                                                 CAS008
                                                                                              CAS008
      ** Internal Contract                                                                    CAS008
     C                   IF        WLinkedDLNO <> *ZERO                                       CAS008
                                                                                              CAS008
     C**********         EVAL      KDLdlno = FSDLNO                                    CAS008 CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C                   EVAL      KDLdlno = FSDLNO2                                          CLE148
                                                                                              CAS008
     C     KDLNHVL       CHAIN     DLNHVLL3                                                   CAS008
     C                   IF        %FOUND(DLNHVLL3)                                           CAS008
                                                                                              CAS008
      ** Move transaction details,                                                            CAS008
                                                                                              CAS008
     C                   MOVE      DLDLNO        FSDLNO                                       CLE148
     C                   EVAL      WAmount = DLDAMT                                           CAS008
     C                   EVAL      WUnrealPL = FSPRLA                                         CAS008
     C                   IF        KDLcycd  = PUCY                                            CAS008
     C                   EVAL      WUnrealPLye = FSYUPL                                       CAS008
     C                   ELSE                                                                 CAS008
     C                   EVAL      WUnrealPLye = FSSYPL                                       CAS008
     C                   ENDIF                                                                CAS008
     C                   EVAL      WWCYCD = FSCYCD                                            CAS008
                                                                                              CAS008
     C                   ELSE                                                                 CAS008
     C                   EVAL      WNoRec = 'Y'                                               CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   ELSE                                                                 CAS008
     C                   EVAL      WNoRec = 'Y'                                               CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   EXSR      SRAccuAmt                                                  CAS008
                                                                                              CAS008
     C                   ENDSR                                                                CAS008
      *****************************************************************                       CAS008
      /EJECT                                                                                  CAS008
      *****************************************************************                       CAS003
      *                                                               *                       CAS003
      *  SRDerivFF - Retrieves the Hedging Instrument's NPV           *                       CAS003
      *              Information for Futures & Options Transactions   *                       CAS003
      *                                                               *                       CAS003
      *  Called by: SRDerivat                                         *                       CAS003
      *                                                               *                       CAS003
      *  Calls: SRCvtMthF, SRAccuAmt                                  *                       CAS003
      *                                                               *                       CAS003
      *****************************************************************                       CAS003
                                                                                              CAS003
     C     SRDerivFF     BEGSR                                                                CAS003
                                                                                              CAS003
     C                   EVAL      WTYPE = *BLANKS                                            CAS005
                                                                                              CAS005
     C**********         IF        FSDLNO <> 0                                         CAS003 CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C                   IF        FSDLNO2 <> 0                                               CLE148
                                                                                              CAS003
     C*****FSDLNO        CHAIN     TRANS2                                              CAS003 CLE148
     C     FSDLNO2       CHAIN     TRANS2                                                     CLE148
     C                   IF        %FOUND(TRANS2)                                             CAS003
     C                   EVAL      WAmount = NUCO                                             CAS003
     C                   EVAL      WUnrealPL = FSURPL                                         CAS003
     C                   EVAL      WUnrealPLye = FSYUPL                                       CAS003
     C                   EVAL      WWCYCD = ISCY                                              CAS003
     C                   ELSE                                                                 CAS003
     C                   EVAL      WNoRec = 'Y'                                               CAS003
     C                   ENDIF                                                                CAS003
                                                                                              CAS003
     C                   ELSE                                                                 CAS003
                                                                                              CAS003
      **  Move Midas AS Hedge Transaction File Retrieval Fields to                            CAS003
      **  Key List for Midas FF Revalued FF Position File                                     CAS003
                                                                                              CAS003
     C                   EVAL      KFFbrca = FSBRCA                                           CAS003
     C                   EVAL      KFFbkcd = FSBKCD                                           CAS003
     C                   EVAL      KFFpcal = FSPCAL                                           CAS003
     C                   EVAL      WDSfpse = FSFPSE                                           CAS003
     C                   EVAL      KFFistt = WDSistt                                          CAS003
     C                   EVAL      KFFyrno = WDSyear                                          CAS003
                                                                                              CAS003
     C                   EXSR      SRCvtMthF                                                  CAS003
                                                                                              CAS003
     C                   EVAL      KFFmthn = Wmnth                                            CAS003
                                                                                              CAS003
     C     KFFNPVL       CHAIN     FFNPVLL0                                                   CAS003
     C                   IF        %FOUND(FFNPVLL0)                                           CAS003
     C                   EVAL      WAmount = FFCUTV                                           CAS003
     C                   EVAL      WUnrealPL = FFURPL                                         CAS003
     C                   EVAL      WUnrealPLye = FFYUPL                                       CAS003
     C                   EVAL      WWCYCD = FFCCY                                             CAS003
     C                   ELSE                                                                 CAS003
     C                   EVAL      WNoRec = 'Y'                                               CAS003
     C                   ENDIF                                                                CAS003
                                                                                              CAS003
     C                   ENDIF                                                                CAS003
                                                                                              CAS003
     C                   EXSR      SRAccuAmt                                                  CAS003
                                                                                              CAS003
     C                   ENDSR                                                                CAS003
                                                                                              CAS003
      **********************************************************************                  CAS003
      /EJECT                                                                                  CAS003
      *****************************************************************                       CAS005
      *                                                               *                       CAS005
      *  SRChkHdgI - Check Hedged Items if there is a need to chain   *                       CAS005
      *              the Base Rate version of the NPV files of the    *                       CAS005
      *              current derivative                               *                       CAS005
      *                                                               *                       CAS005
      *  Called by: SRDerivDL                                         *                       CAS005
      *                                                               *                       CAS005
      *  Calls: None                                                  *                       CAS005
      *                                                               *                       CAS005
      *****************************************************************                       CAS005
                                                                                              CAS005
     C     SRChkHdgI     BEGSR                                                                CAS005
                                                                                              CAS005
     C                   EVAL      KAShed5 = FSHEDI                                           CAS005
     C                   EVAL      KASdhi5 = 'H'                                              CAS005
     C                   EVAL      WkBase = 'N'                                               CAS005
                                                                                              CAS005
     C     KASHTR5       CHAIN     ASHTRNLB                           26                      CAS005
                                                                                              CAS005
     C                   DOW       *IN26 = *OFF AND WkBase = 'N'                              CAS005
                                                                                              CAS005
     C                   IF        HIFSHTID = 'D'                                             CAS005
                                                                                              CAS005
     C                   SELECT                                                               CAS005
                                                                                              CAS005
     C                   WHEN      HIFSMOD = 'DL'                                             CAS005
                                                                                              CAS005
     C*****HIFSDLNO      CHAIN     DEALS                                               CAS005 CLE148
     C                   MOVEL     HIFSDLNO      FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     DEALS                                                      CLE148
                                                                                              CAS005
      ** If hedged item is a deal, check spread                                               CAS005
                                                                                              CAS005
     C                   IF        %FOUND(DEALS)                                              CAS005
                                                                                              CAS005
      ***For*Loans*and*Deposits*records,*check*spread*rate*and*base*rate*code          CAS005 227695
      ** For Loans and Deposits records, check liquidity premium                              227695
                                                                                              CAS005
     C                   IF        RCDT = 'C'                                                 CAS005
     C**********         IF        CDRTSP <> 0 AND CDBRTT <> 0                         CAS005 227695
     C                   IF        CDFSLQPR <> 0                                              227695
     C                   EVAL      WkBase = 'Y'                                               CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** For Negotiable Assets Purchased records, check liquidity premium                     CAS005
                                                                                              CAS005
     C                   IF        RCDT = 'D'                                                 CAS005
     C                   IF        CDFSLQPR <> 0                                              CAS005
     C                   EVAL      WkBase = 'Y'                                               CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Store currency code, to be checked later when derivative is a cross                  CAS005
      ** currency swap                                                                        CAS005
                                                                                              CAS005
     C*****HIFSDLNO      CHAIN     MMNPVLL0                                            CAS005 CLE148
     C     FSDLNO2       CHAIN     MMNPVLL0                                                   CLE148
     C                   IF        %FOUND(MMNPVLL0)                                           CAS005
     C                   EVAL      WkCYCD = MMCYCD                                            CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      WkCYCD = *BLANKS                                           CAS005
     C                   ENDIF                                                                CAS005
     C                                                                                        CAS005
     C                   ENDIF                                                                CAS005
     C                                                                                        CAS005
     C                   WHEN      HIFSMOD = 'LE'                                             CAS005
                                                                                              CAS005
     C     HIFSDLNO      CHAIN     CLOAN                                                      CAS005
                                                                                              CAS005
      ** If hedged item is a loan, check margin                                               CAS005
                                                                                              CAS005
     C                   IF        %FOUND(CLOAN)                                              CAS005
                                                                                              CAS005
     C                   IF        L1MARG <> 0                                                CAS005
     C                   EVAL      WkBase = 'Y'                                               CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Store currency code, to be checked later when derivative is a cross                  CAS005
      ** currency swap                                                                        CAS005
                                                                                              CAS005
     C     HIFSDLNO      CHAIN     LENPVLL0                                                   CAS005
     C                   IF        %FOUND(LENPVLL0)                                           CAS005
     C                   EVAL      WkCYCD = LECYCD                                            CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      WkCYCD = *BLANKS                                           CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   WHEN      HIFSMOD = 'SE'                                             CAS005
                                                                                              CAS005
      ** Populate key fields to be used in chaining in the book position file                 CAS005
                                                                                              CAS005
     C                   EVAL      KSEsesn = HIFSFPSE                                         CAS005
     C                   EVAL      KSEbrca = HIFSBRCA                                         CAS005
     C                   EVAL      KSEbokc = HIFSBKCD                                         CAS005
     C                   EVAL      KSEmkti = HIFSMKTI                                         CAS005
     C                   EVAL      KSEbhtv = HIFSBHTV                                         CAS005
                                                                                              CAS006
      ** Chain to book position file to get the Latest Average Price and the                  CAS006
      ** Latest Net Treasury Average Price                                                    CAS006
                                                                                              CAS006
     C     KSENPVL       CHAIN     BKPHD                                                      CAS006
                                                                                              CAS006
     C                   IF        %FOUND(BKPHD)                                              CAS006
                                                                                              CAS006
     C                   DOW       (B2RECI <> 'D') AND (NOT %EOF(BKPHD))                      CAS006
     C     KSENPVL       READE     BKPHD                                                      CAS006
     C                   ENDDO                                                                CAS006
                                                                                              CAS006
      ** If the Latest Average Price is not equal to the Latest Net Treasury                  CAS006
      ** Average Price, use base rate file                                                    CAS006
                                                                                              CAS006
     C                   IF        (NOT %EOF(BKPHD)) AND (B2LAVP <> B2LAVN)                   CAS006
     C                   EVAL      WkBase = 'Y'                                               CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS005
      ** Retrieve details from PF/SEMKVLPD for hedged SE book positions                       CAS006
      ** instead of from PF/SENPVLPD.                                                         CAS006
                                                                                              CAS006
     C     KSENPVL       CHAIN     SEMKVLL0                                                   CAS006
     C*****KSENPVL       CHAIN     SENPVLL0                                            CAS005 CAS006
     C**********         IF        %FOUND(SENPVLL0)                                    CAS005 CAS006
     C                   IF        %FOUND(SEMKVLL0)                                           CAS006
     C                   EVAL      WkCYCD = SECCY                                             CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      WkCYCD = *BLANKS                                           CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDSL                                                                CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C     KASHTR5       READE     ASHTRNLB                               26                  CAS005
     C                   ENDDO                                                                CAS005
                                                                                              CAS005
     C                   ENDSR                                                                CAS005
                                                                                              CAS005
      *****************************************************************                       CAS005
      /EJECT                                                                                  CAS005
      *****************************************************************
      *                                                               *
      *  SRHedgedI - Retrieves the Hedged Items Transactions Under    *
      *              Each Hedge ID and Sum the NPV Amounts for All    *
      *              Retrieved Hedged Items                           *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: SRHedgeDL, SRHedgeLE, SRHedgeSE                       *
      *                                                               *
      *****************************************************************
 
     C     SRHedgedI     BEGSR
 
     C                   EVAL      KAShedi = FSHEDI
     C                   EVAL      KASdhin = 'H'
 
     C     KASHTRN       CHAIN     ASHTRNL1                           25
 
     C                   DOW       *IN25 = *OFF
      *
     C                   EVAL      WAmount = *ZERO
     C                   EVAL      WUnrealPL = *ZERO
     C                   EVAL      WUnrealPLye = *ZERO
     C                   EVAL      WWCYCD = *BLANKS
 
      ** Retrieve NPV Amounts
 
     C                   SELECT
 
     C                   WHEN      FSMOD = 'DL'
 
     C                   EXSR      SRHedgeDL
 
     C                   WHEN      FSMOD = 'LE'
 
     C                   EXSR      SRHedgeLE
 
     C                   WHEN      FSMOD = 'SE'
 
     C                   IF        CAS008 = 'Y'                                               CAS008
     C                             And FSSECR = 'Y'                                           CAS008
     C                             And FSNDDP <> 0                                            CAS008
     C                   EXSR      SRDlyHgSE                                                  CAS008
     C                   ELSE                                                                 CAS008
     C                   EXSR      SRHedgeSE
     C                   ENDIF                                                                CAS008
 
     C                   ENDSL
 
     C     KASHTRN       READE     ASHTRNL1                               25
     C                   ENDDO
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHedgeDL - Retrieves the Hedged Item's NPV Information of   *
      *              Dealing Transactions                             *
      *                                                               *
      *  Called by: SRHedgedI                                         *
      *                                                               *
      *  Calls: SRAccuAmt                                             *
      *                                                               *
      *****************************************************************
 
     C     SRHedgeDL     BEGSR
 
     C                   EVAL      WTYPE = *BLANKS                                            CAS005
                                                                                              CAS005
      ** Money Market
 
     C*****FSDLNO        CHAIN     MMNPVLL0                                                   CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     MMNPVLL0                                                   CLE148
     C                   IF        %FOUND(MMNPVLL0)
 
      ** Move transaction details,
 
     C                   EVAL      WAmount = MMDAMT
     C                   EVAL      WUnrealPL = MMURPL
     C                   EVAL      WUnrealPLye = MMYUPL
     C                   EVAL      WWCYCD = MMCYCD
 
     C                   ELSE
 
      ** Internal Deals
 
     C                   IF        WLinkedDLNO <> *ZERO
 
     C**********         EVAL      KDLdlno = FSDLNO                                           CLE148
     C                   EVAL      KDLdlno = FSDLNO2                                          CLE148
 
     C     KDLNPVL       CHAIN     DLNPVLL3
     C                   IF        %FOUND(DLNPVLL3)
 
      ** Move transaction details,
 
     C                   MOVE      DLDLNO        FSDLNO                                       CLE148
     C                   EVAL      WAmount = DLDAMT
     C                   EVAL      WUnrealPL = FSPRLA
     C                   IF        KDLcycd  = PUCY                                            CAS004
     C                   EVAL      WUnrealPLye = FSYUPL
     C                   ELSE                                                                 CAS004
     C                   EVAL      WUnrealPLye = FSSYPL                                       CAS004
     C                   ENDIF                                                                CAS004
     C                   EVAL      WWCYCD = FSCYCD
 
     C                   ELSE
     C                   EVAL      WNoRec = 'Y'
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      WNoRec = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   EXSR      SRAccuAmt
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHedgeLE - Retrieves the Hedged Item's NPV Information of   *
      *              Lending Transactions                             *
      *                                                               *
      *  Called by: SRHedgedI                                         *
      *                                                               *
      *  Calls: SRAccuAmt                                             *
      *                                                               *
      *****************************************************************
 
     C     SRHedgeLE     BEGSR
 
     C                   EVAL      WTYPE = *BLANKS                                            CAS005
                                                                                              CAS005
     C     FSDLNO        CHAIN     LENPVLL0
 
     C                   IF        %FOUND(LENPVLL0)
 
      ** Move transaction details,
 
     C                   EVAL      WAmount = LELAMT
     C                   EVAL      WUnrealPL = LEURPL
     C                   EVAL      WUnrealPLye = LEYUPL
     C                   EVAL      WWCYCD = LECYCD
     C                   EXSR      SRAccuAmt
 
     C                   ELSE
     C                   EVAL      WNoRec = 'Y'
     C                   ENDIF
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHedgeSE - Retrieves the Hedged Item's NPV Information of   *
      *              Securities Trading                               *
      *                                                               *
      *  Called by: SRHedgedI                                         *
      *                                                               *
      *  Calls: SRAccuAmt                                             *
      *                                                               *
      *****************************************************************
 
     C     SRHedgeSE     BEGSR
 
     C                   EVAL      WTYPE = *BLANKS                                            CAS005
                                                                                              CAS005
      **  Move Midas AS Hedge Transaction File Retrieval Fields to
      **  Key List for Midas SE Revalued Security Positions File
 
     C                   EVAL      KSEsesn = FSFPSE
     C                   EVAL      KSEbrca = FSBRCA
     C                   EVAL      KSEbokc = FSBKCD
     C                   EVAL      KSEmkti = FSMKTI
     C                   EVAL      KSEbhtv = FSBHTV
 
      ** Retrieve details from PF/SEMKVLPD for hedged SE book positions                       CAS006
      ** instead of from PF/SENPVLPD.                                                         CAS006
                                                                                              CAS006
     C     KSENPVL       CHAIN     SEMKVLL0                                                   CAS006
     C*****KSENPVL       CHAIN     SENPVLL0                                                   CAS006
 
     C**********         IF        %FOUND(SENPVLL0)                                           CAS006
     C                   IF        %FOUND(SEMKVLL0)                                           CAS006
 
      ** Move transaction details,
 
     C                   EVAL      WAmount = SENAMT
     C                   EVAL      WUnrealPL = SEURPL
     C                   EVAL      WUnrealPLye = SEYUPL
     C                   EVAL      WWCYCD = SECCY
     C                   EXSR      SRAccuAmt
 
     C                   ELSE
     C                   EVAL      WNoRec = 'Y'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************                       CAS008
      /EJECT                                                                                  CAS008
      *****************************************************************                       CAS008
      *                                                               *                       CAS008
      *  SRDlyHgSE - Retrieves the Hedged Item's Historic Value       *                       CAS008
      *              information of Securities Trading                *                       CAS008
      *                                                               *                       CAS008
      *  Called by: SRHedgedI                                         *                       CAS008
      *                                                               *                       CAS008
      *  Calls: SRAccuAmt                                             *                       CAS008
      *                                                               *                       CAS008
      *****************************************************************                       CAS008
                                                                                              CAS008
     C     SRDlyHgSE     BEGSR                                                                CAS008
                                                                                              CAS008
     C                   EVAL      WTYPE = *BLANKS                                            CAS008
                                                                                              CAS008
      **  Move Midas AS Hedge Transaction File Retrieval Fields to                            CAS008
      **  Key List for Midas SE Revalued Security Positions File                              CAS008
                                                                                              CAS008
     C                   EVAL      KSEsesn = FSFPSE                                           CAS008
     C                   EVAL      KSEbrca = FSBRCA                                           CAS008
     C                   EVAL      KSEbokc = FSBKCD                                           CAS008
     C                   EVAL      KSEmkti = FSMKTI                                           CAS008
     C                   EVAL      KSEbhtv = FSBHTV                                           CAS008
     C                   EVAL      KDEffd = FSEFFD                                            CAS008
                                                                                              CAS008
                                                                                              CAS008
     C     KSEHMVL       CHAIN     SEMKVDL1                                                   CAS008
                                                                                              CAS008
     C                   IF        %FOUND(SEMKVDL1)                                           CAS008
                                                                                              CAS008
      ** Move transaction details                                                             CAS008
                                                                                              CAS008
     C                   EVAL      WAmount = SENAMT                                           CAS008
     C                   EVAL      WUnrealPL = SEURPL                                         CAS008
     C                   EVAL      WUnrealPLye = SEYUPL                                       CAS008
     C                   EVAL      WWCYCD = SECCY                                             CAS008
     C                   EXSR      SRAccuAmt                                                  CAS008
                                                                                              CAS008
     C                   ELSE                                                                 CAS008
     C                   EVAL      WNoRec = 'Y'                                               CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   ENDSR                                                                CAS008
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAccuAmt - Sum All Hedging or Hedged NPV Amounts Under Each *
      *              Hedge ID                                         *
      *                                                               *
      *  Called by: SRDerivDL, SRHedgeSE, SRHedgeDL, SRHedgeLE,       *
      *             SRDerivFF                                         *                       CAS003
      *                                                               *
      *  Calls: AOCURRR0, *PSSR                                       *
      *                                                               *
      *****************************************************************
 
     C     SRAccuAmt     BEGSR
 
     C                   IF        WNoRec <> 'Y'
 
      ** If only a percentage is hedged,
 
     C                   IF        FSPCTG <> 0
     C                   MULT(H)   FSPCTG        WAmount
     C                   DIV(H)    100           WAmount
     C                   MULT(H)   FSPCTG        WUnrealPL
     C                   DIV(H)    100           WUnrealPL
     C                   MULT(H)   FSPCTG        WUnrealPLye
     C                   DIV(H)    100           WUnrealPLye
     C                   ENDIF
 
      ** Retrieve Currency details
 
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     PRetrnCde
     C                   PARM      '*KEY   '     POption
     C                   PARM      WWCYCD        PCurrency
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database error
 
     C                   IF        PRetrnCde <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'SDCURRPD'
     C                   EVAL      DBKEY  =  '*CALL'
     C                   EVAL      DBASE  =  003
     C                   EVAL      DBPROC =  'SR/SRAccuAmt'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Convert Transaction Amounts to base currency at spot rate
 
     C                   IF        WTYPE = *BLANKS                                            CAS005
                                                                                              CAS005
     C                   IF        A6MDIN = 'M'
     C                   MULT(H)   A6SPRT        WAmount
     C                   MULT(H)   A6SPRT        WUnrealPL
     C                   MULT(H)   A6SPRT        WUnrealPLye
     C                   ELSE
     C                   DIV(H)    A6SPRT        WAmount
     C                   DIV(H)    A6SPRT        WUnrealPL
     C                   DIV(H)    A6SPRT        WUnrealPLye
     C                   ENDIF
 
     C                   ENDIF                                                                CAS005
      ** Accumulate Amounts
 
     C                   SELECT
 
      ** HEDGING AMOUNTS
 
     C                   WHEN      FSDHIN = 'D'
 
      ** Accumulate Current Principal/Face Value
 
     C                   ADD       WAmount       WDerivAmtA
 
      ** Accumulate Unrealized Profit/Loss
 
     C                   ADD       WUnrealPL     WDerivURPLA
 
      ** Accumulate Unrealized P/L As of Yearend
 
     C                   ADD       WUnrealPLye   WDerivURPLyeA
 
      ** Hedged Amounts
 
     C                   WHEN      FSDHIN = 'H'
 
      ** Accumulate Current Principal
 
     C                   ADD       WAmount       WHedgeAmtA
 
      ** Accumulate Unrealized Profit/Loss
 
     C                   ADD       WUnrealPL     WHedgeURPLA
 
      ** Accumulate Unrealized P/L As of Yearend
 
     C                   ADD       WUnrealPLye   WHedgeURPLyeA
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCalcuHE - Calculate Hedge Effectiveness                    *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: *PSSR, ZFREQB                                         *
      *                                                               *
      *****************************************************************
 
     C     SRCalcuHE     BEGSR
 
     C                   IF        WNoRec <> 'Y'
                                                                                              CAS005
      ** Retrieve Product Type                                                                CAS005
                                                                                              CAS005
     C                   EVAL      WkPRTP = *BLANKS                                           CAS005
     C     FSHGST        CHAIN     SDHGSTL1                                                   CAS005
     C                   IF        %FOUND(SDHGSTL1)                                           CAS005
     C                   EVAL      WkPRTP = FSPRTP                                            CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS006
      ** If Hedge Accounting Phase B is installed, assess linkages                            CAS006
      ** using the Regression Analysis as its method of hedge assessment.                     CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y' AND FSMEFF = 'R'                              CAS006
                                                                                              CAS006
      ** When the linkage is using Regression Analysis as the method of                       CAS006
      ** assessment, only one hedge derivative and hedged item will be                        CAS006
      ** allowed for now.  Retrieve the transaction numbers or Security                       CAS006
      ** Position Details.                                                                    CAS006
                                                                                              CAS006
     C                   EVAL      KAShedi = FSHEDI                                           CAS006
     C                   EVAL      KASdhin = 'D'                                              CAS006
     C     KASHTRN       CHAIN     ASHTRNL1                                                   CAS006
                                                                                              CAS006
      ** For now, we only use 'RS', 'RX' AND 'FR' as hedge derivatives.                       CAS006
                                                                                              CAS006
     C                   EVAL      KDerivHEDI = FSHEDI                                        CAS006
     C                   EVAL      KDerivDLNO = FSDLNO                                        CAS006
     C                   EVAL      WDerivPCTG = FSPCTG / 100                                  CAS006
                                                                                              CAS006
      ** Hedged Item                                                                          CAS006
                                                                                              CAS006
     C                   EVAL      KASdhin = 'H'                                              CAS006
     C     KASHTRN       CHAIN     ASHTRNL1                                                   CAS006
                                                                                              CAS006
     C                   SELECT                                                               CAS006
                                                                                              CAS006
     C                   WHEN      FSMOD = 'DL' OR FSMOD = 'LE'                               CAS006
                                                                                              CAS006
     C                   EVAL      KHedgdHEDI = FSHEDI                                        CAS006
     C                   EVAL      KHedgdDLNO = FSDLNO                                        CAS006
     C                   EVAL      WHedgdPCTG = FSPCTG / 100                                  CAS006
                                                                                              CAS006
     C                   WHEN      FSMOD = 'SE'                                               CAS006
                                                                                              CAS006
     C                   EVAL      KHedgdHEDI = FSHEDI                                        CAS006
     C                   EVAL      KHedgdSESN = FSFPSE                                        CAS006
     C                   EVAL      KHedgdBRCA = FSBRCA                                        CAS006
     C                   EVAL      KHedgdBKCD = FSBKCD                                        CAS006
     C                   EVAL      KHedgdMKTI = FSMKTI                                        CAS006
     C                   EVAL      KHedgdBHTV = FSBHTV                                        CAS006
     C                   EVAL      WHedgdPCTG = FSPCTG / 100                                  CAS006
                                                                                              CAS006
     C                   ENDSL                                                                CAS006
                                                                                              CAS006
      ** Sum up Data from Historic Data File                                                  CAS006
                                                                                              CAS006
     C                   EXSR      SrSummat                                                   CAS006
                                                                                              CAS006
      ** Compute for Notations based on the Sums of Squares                                   CAS006
                                                                                              CAS006
     C                   EXSR      SrNotaSum                                                  CAS006
                                                                                              CAS006
      ** Compute for Coefficient of Determination, T-Statistic and                            CAS006
      ** Slope Coefficient.  Assess Linkages using the Regression                             CAS006
      ** Analysis.                                                                            CAS006
                                                                                              CAS006
     C                   EXSR      SrRegAsse                                                  CAS006
                                                                                              CAS006
     C                   ELSE                                                                 CAS006
 
      **  If Hedge Linkage starts after previous year end, disregard
      **  Year end Unrealized Profit and Loss
 
     C                   IF        FSSTDT <= BJPEYD
     C                             AND (CAS005 = 'N' OR WkPRTP <> 'CF')                       CAS005
     C     WDerivURPLA   SUB       WDerivURPLyeA WDerivDiff
     C     WHedgeURPLA   SUB       WHedgeURPLyeA WHedgeDiff
     C                   ELSE
     C                   Z-ADD     WDerivURPLA   WDerivDiff
     C                   Z-ADD     WHedgeURPLA   WHedgeDiff
     C                   ENDIF
 
     C                   IF        WHedgeDiff = *ZERO
     C                   Z-ADD     *ZERO         WChange
     C                   ELSE
     C     WDerivDiff    DIV       WHedgeDiff    WChange
     C                   ENDIF
 
     C     WChange       MULT(H)   -100          WChngPerc
 
      ** Assess Hedge Effectiveness by virtue of de minimis ruling
      ** i.e. Change difference from yearend is less than or equal
      **      to the Override de minimis percentage.
 
     C     WDerivAmtA    MULT(H)   FSOPCT        WDerivDeMin
     C                   DIV(H)    100           WDerivDeMin
     C     WHedgeAmtA    MULT(H)   FSOPCT        WHedgeDeMin
     C                   DIV(H)    100           WHedgeDeMin
 
      ** Convert to absolute value
 
     C                   IF        WDerivDeMin < *ZERO
     C                   Z-SUB     WDerivDeMin   WDerivDeMin
     C                   ENDIF
     C                   IF        WHedgeDeMin < *ZERO
     C                   Z-SUB     WHedgeDeMin   WHedgeDeMin
     C                   ENDIF
     C                   IF        WDerivDiff < *ZERO
     C                   Z-SUB     WDerivDiff    WDerivDiff
     C                   ENDIF
     C                   IF        WHedgeDiff < *ZERO
     C                   Z-SUB     WHedgeDiff    WHedgeDiff
     C                   ENDIF
 
      ** If the change in Unrealized P/L is less than or equal to the De
      ** Minimis Portion of the Principal/Face Value for both the Hedging
      ** and Hedged Items, then the Hedge is outright effective.
 
     C                   IF        WDerivDiff <= WDerivDeMin
     C                             and WHedgeDiff <= WHedgeDeMin
 
      ** Hedge Effectiveness Percentage
 
     C                   Z-ADD     FSOPCT        FSHEFP
 
     C                   ELSE
 
      ** Change in Unrealized P/L should go the opposite direction
      ** i.e. If hedged items gain, hedging instruments should lose
      **      Otherwise, the hedge is considered ineffective and thus
      **      should be discontinued.
 
     C                   IF        WChange > *ZERO
     C                   EVAL      FSRECI = 'X'
     C                   EVAL      FSHEFP = *ZERO
 
     C                   ELSE
 
      ** Otherwise, Assess Hedge Effectiveness if within the boundaries
      ** set for the strategy.
 
      ** Retrieve Upper and Lower Effectiveness Percentage
 
     C     FSHGST        CHAIN     SDHGSTL1
     C                   IF        NOT %FOUND(SDHGSTL1)
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'SDHGSTL1'
     C                   EVAL      DBKEY  =  FSHGST
     C                   EVAL      DBASE  =  004
     C                   EVAL      DBPROC =  'SR/SRCalcuHe'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If effectiveness is not within the boundary, the hedge is
      ** considered considered ineffective and thus should be
      ** discontinued.
 
     C                   IF        WChngPerc > FSEFUP
     C                             or WChngPerc < FSEFLO
     C                   EVAL      FSRECI = 'X'
     C                   ENDIF
 
     C**********         Z-ADD     WChngPerc     FSHEFP                                       228011
     C                   Z-ADD(H)  WChngPerc     FSHEFP                                       228011
 
     C                   ENDIF
 
     C                   ENDIF
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
 
      ** Set Next Assessment Date
 
     C     FSRECI        IFEQ      'D'
 
     C                   IF        FSEFFQ <> 'D'                                              CAS004
     C                   EVAL      Pzfreq = FSEFFQ
     C                   EVAL      Pzdayno = FSEFFD
     C                   EVAL      Pzmday = 31
     C                   EVAL      Pzccy = BJCYCD
     C                   EVAL      PBJDFIN = BJDFIN
 
     C                   CALLB     'ZFREQB'
     C                   PARM      *BLANKS       PRetCodeIn
     C                   PARM                    PZFreq
     C                   PARM                    PZDayno
     C                   PARM                    PZCcy
     C                   PARM      *BLANKS       PZLoc                                      AR702741
     C                   PARM                    PZMday
     C                   PARM                    PBJDFIN
     C     SDGELR        PARM                    SDGELR
 
     C                   IF        PRetCodeIn <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBPGM = PSProcPgm
     C                   EVAL      DBMOD = PSProcMod
     C                   EVAL      DBFILE =  'ZFREQB'
     C                   EVAL      DBKEY  =  '*CALL'
     C                   EVAL      DBASE  =  005
     C                   EVAL      DBPROC =  'SR/SRCalcuHe'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
                                                                                              CAS004
     C                   EVAL      PBJDFIN2  = BJDFIN                                         CAS004
     C                   EVAL      PzDayNo2  = Pzdayno                                        CAS004
     C                   EXSR      SRZDATE2                                                   CAS004
                                                                                              CAS004
     C                   IF        BJDFIN = 'M'                                               CAS004
     C                   MOVEL     PZDateB2      WMnth1                                       CAS004
     C                   ELSE                                                                 CAS004
     C                   MOVE      PZDateB2      WMnthT                                       CAS004
     C                   MOVEL     WMnthT        WMnth1                                       CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C                   CALLB     'ZBKDT'                                                    CAS004
     C                   PARM      PzDayNo       PzDayNo3                                     CAS004
     C                   PARM      BJCYCD        PzCCY3                                       CAS004
     C                   PARM                    PZLoc3                                       CAS004
     C                   PARM      1             PZNRdys3                                     CAS004
     C                   PARM                    PZDyNbr3                                     CAS004
                                                                                              CAS004
     C                   EVAL      PzDayNo2  = PZDyNbr3                                       CAS004
     C                   EXSR      SRZDATE2                                                   CAS004
                                                                                              CAS004
     C                   IF        BJDFIN = 'M'                                               CAS004
     C                   MOVEL     PZDateB2      WMnth2                                       CAS004
     C                   ELSE                                                                 CAS004
     C                   MOVE      PZDateB2      WMnthT                                       CAS004
     C                   MOVEL     WMnthT        WMnth2                                       CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C                   IF        WMnth1 = WMnth2                                            CAS004
     C                   EVAL      FSEFFD = Pzdayno
     C                   ELSE                                                                 CAS004
     C                   EVAL      FSEFFD = PZDyNbr3                                          CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C                   ENDIF
 
     C                   ELSE                                                                 CAS004
     C                   EVAL      FSEFFD = WkEvCtDt + 1                                      CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C                   ENDIF
 
     C                   EVAL      FSDAMT = WDerivAmtA
     C                   EVAL      FSDUPL =WDerivURPLA
     C                   EVAL      FSHAMT = WHedgeAmtA
     C                   EVAL      FSHUPL = WHedgeURPLA
 
     C                   IF        FSSTDT <= BJPEYD
     C                   EVAL      FSDYPL = WDerivURPLyeA
     C                   EVAL      FSHYPL = WHedgeURPLyeA
     C                   ELSE
     C                   EVAL      FSDYPL = *ZERO
     C                   EVAL      FSHYPL = *ZERO
     C                   ENDIF
 
     C                   EVAL      FSCYCD = BJCYCD
 
     C                   ELSE
     C                   EVAL      FSRECI = 'X'
     C                   EVAL      FSHEFP = *ZERO
     C                   ENDIF
 
     C**********         EVAL      FSLASD = BJRDNB                                            CAS004
     C                   EVAL      FSLASD = WkEvCtDt                                          CAS004
      *                                                                                       CAS008
     C                   IF        CAS008 = 'Y'                                               CAS008
     C                             and FSSECR = 'Y'                                           CAS008
     C                             and FSNDDP <> 0                                            CAS008
     C                   EVAL      FSLASD = XFSEFFD                                           CAS008
     C                   Endif                                                                CAS008
      *                                                                                       CAS008
     C                   EVAL      FSRIND = WkRInd                                            CAS005
     C                   UPDATE    ASHGLKD0
 
     C                   ENDSR
 
      **********************************************************************                  CAS004
      /EJECT                                                                                  CAS004
      *****************************************************************                       CAS004
      *                                                               *                       CAS004
      *  SRZDATE2  - Convert Midas Date to MMDDYY format.             *                       CAS004
      *                                                               *                       CAS004
      *  Called by: SRCalcuHE                                         *                       CAS004
      *                                                               *                       CAS004
      *  Calls: ZDATE2                                                *                       CAS004
      *                                                               *                       CAS004
      *****************************************************************                       CAS004
                                                                                              CAS004
     C     SRZDATE2      BEGSR                                                                CAS004
                                                                                              CAS004
     C                   CALLB     'ZDATE2'                                                   CAS004
     C                   PARM                    PzDayNo2                                     CAS004
     C                   PARM                    PBJDFIN2                                     CAS004
     C                   PARM      *Zero         PzDateB2                                     CAS004
     C                   PARM      *Blanks       PZADate2                                     CAS004
                                                                                              CAS004
     C                   ENDSR                                                                CAS004
                                                                                              CAS004
      **********************************************************************
      /EJECT
      *****************************************************************                       CAS003
      *                                                               *                       CAS003
      *  SRCvtMthF - Convert MMM Month Format to MM                   *                       CAS003
      *                                                               *                       CAS003
      *  Called by: SRDerivFF                                         *                       CAS003
      *                                                               *                       CAS003
      *  Calls: None                                                  *                       CAS003
      *                                                               *                       CAS003
      *****************************************************************                       CAS003
                                                                                              CAS003
     C     SRCvtMthF     BEGSR                                                                CAS003
                                                                                              CAS003
     C                   SELECT                                                               CAS003
                                                                                              CAS003
     C                   WHEN      WDSmnth = 'JAN'                                            CAS003
     C                   EVAL      Wmnth = 01                                                 CAS003
                                                                                              CAS003
     C                   WHEN      WDSmnth = 'FEB'                                            CAS003
     C                   EVAL      Wmnth = 02                                                 CAS003
                                                                                              CAS003
     C                   WHEN      WDSmnth = 'MAR'                                            CAS003
     C                   EVAL      Wmnth = 03                                                 CAS003
                                                                                              CAS003
     C                   WHEN      WDSmnth = 'APR'                                            CAS003
     C                   EVAL      Wmnth = 04                                                 CAS003
                                                                                              CAS003
     C                   WHEN      WDSmnth = 'MAY'                                            CAS003
     C                   EVAL      Wmnth = 05                                                 CAS003
                                                                                              CAS003
     C                   WHEN      WDSmnth = 'JUN'                                            CAS003
     C                   EVAL      Wmnth = 06                                                 CAS003
                                                                                              CAS003
     C                   WHEN      WDSmnth = 'JUL'                                            CAS003
     C                   EVAL      Wmnth = 07                                                 CAS003
                                                                                              CAS003
     C                   WHEN      WDSmnth = 'AUG'                                            CAS003
     C                   EVAL      Wmnth = 08                                                 CAS003
                                                                                              CAS003
     C                   WHEN      WDSmnth = 'SEP'                                            CAS003
     C                   EVAL      Wmnth = 09                                                 CAS003
                                                                                              CAS003
     C                   WHEN      WDSmnth = 'OCT'                                            CAS003
     C                   EVAL      Wmnth = 10                                                 CAS003
                                                                                              CAS003
     C                   WHEN      WDSmnth = 'NOV'                                            CAS003
     C                   EVAL      Wmnth = 11                                                 CAS003
                                                                                              CAS003
     C                   WHEN      WDSmnth = 'DEC'                                            CAS003
     C                   EVAL      Wmnth = 12                                                 CAS003
                                                                                              CAS003
     C                   ENDSL                                                                CAS003
                                                                                              CAS003
     C                   ENDSR                                                                CAS003
                                                                                              CAS003
      **********************************************************************                  CAS003
      /EJECT                                                                                  CAS003
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SrSummat  - Summation of Data from Historic Data File        *                       CAS006
      *                                                               *                       CAS006
      *  Called by: SRCalcuHE                                         *                       CAS006
      *                                                               *                       CAS006
      *  Calls: None                                                  *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
                                                                                              CAS006
     C     SrSummat      BEGSR                                                                CAS006
                                                                                              CAS006
      ** Initialize Variables                                                                 CAS006
                                                                                              CAS006
      ** Summation Variable for Hedge Derivative (Dependent)                                  CAS006
                                                                                              CAS006
     C                   EVAL      WSumY = *ZERO                                              CAS006
     C                   EVAL      WSumYSqrd = *ZERO                                          CAS006
                                                                                              CAS006
      ** Summation Variable for Hedged Item (Independent)                                     CAS006
                                                                                              CAS006
     C                   EVAL      WSumX = *ZERO                                              CAS006
     C                   EVAL      WSumXSqrd = *ZERO                                          CAS006
                                                                                              CAS006
     C                   EVAL      WSumXY = *ZERO                                             CAS006
                                                                                              CAS006
      ** Counter                                                                              CAS006
                                                                                              CAS006
     C                   EVAL      WCounter= *ZERO                                            CAS006
                                                                                              CAS006
      ** Hedge Derivative Historic Market Data                                                CAS006
                                                                                              CAS006
     C     KDerivHMD     SETLL     ASDLHML2                                                   CAS006
                                                                                              CAS008
     C                   IF        CAS008 ='Y'                                                CAS008
     C                             And FSSECR ='Y'                                            CAS008
     C                             And FSNDDP <> 0                                            CAS008
     C                   Z-ADD     FSEFFD        KValueDat         5 0                        CAS008
     C     KDLDHdg       SETLL     ASDLHML2                                                   CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS006
     C                   SELECT                                                               CAS006
      ** Dealing                                                                              CAS006
     C                   WHEN      FSMOD = 'DL'                                               CAS006
     C     KHedgdHMD     SETLL     ASDLHML3                                                   CAS006
                                                                                              CAS006
      ** Lending                                                                              CAS006
     C                   WHEN      FSMOD = 'LE'                                               CAS006
     C     KHedgdHMD     SETLL     ASLEHML2                                                   CAS006
                                                                                              CAS006
      ** Securities                                                                           CAS006
     C                   WHEN      FSMOD = 'SE'                                               CAS006
     C     KAssehm       SETLL     ASSEHML0                                                   CAS006
                                                                                              CAS008
     C                   IF        CAS008 ='Y'                                                CAS008
     C                             And FSSECR ='Y'                                            CAS008
     C                             And FSNDDP <> 0                                            CAS008
     C                   Z-ADD     FSEFFD        KValueDat         5 0                        CAS008
     C     KDAssehm      SETLL     ASSEHML0                                                   CAS008
     C                   ENDIF                                                                CAS008
     C                   ENDSL                                                                CAS006
                                                                                              CAS006
      ** Historic Market Data Read Flag                                                       CAS006
                                                                                              CAS006
     C                   EVAL      WDerivHMDRead = 'Y'                                        CAS006
     C                   EVAL      WHedgdHMDRead = 'Y'                                        CAS006
                                                                                              CAS006
     C                   DOW       WCounter < FSDPTS AND WDerivHMDRead = 'Y'                  CAS006
     C                             AND WHedgdHMDRead = 'Y'                                    CAS006
                                                                                              CAS006
      ** Historic Market Data Read Flag                                                       CAS006
                                                                                              CAS006
     C                   EVAL      WDerivHMDRead = *BLANKS                                    CAS006
     C                   EVAL      WHedgdHMDRead = *BLANKS                                    CAS006
                                                                                              CAS006
      ** Hedge Derivative Historic Market Data                                                CAS006
                                                                                              CAS006
     C     KDerivHMD     READE     ASDLHML2                                                   CAS006
                                                                                              CAS006
     C                   IF        NOT %EOF(ASDLHML2)                                         CAS006
     C                   EVAL      WDerivHMDRead = 'Y'                                        CAS006
     C                   SELECT                                                               CAS006
                                                                                              CAS006
     C                   WHEN      FSDTTP = 'V'                                               CAS006
     C                   MOVE      D2MVAL        WD2Mval12                                    CAS006
     C                   EVAL(H R) WDerivHMD = WD2Mval12 * WDerivPCTG                         CAS006
     C                   WHEN      FSDTTP = 'C'                                               CAS006
     C                   MOVE      D2MVCA        WD2Mvca12                                    CAS006
     C                   EVAL(H R) WDerivHMD = WD2Mvca12 * WDerivPCTG                         CAS006
     C                   WHEN      FSDTTP = 'R'                                               CAS006
     C                   MOVE      D2MRAT        WD2Mrat12                                    CAS006
     C                   EVAL(H R) WDerivHMD =WD2Mrat12 * (10 ** 8) * WDerivPCTG              CAS006
     C                   ENDSL                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Hedged Item Historic Market Data                                                     CAS006
                                                                                              CAS006
      ** Dealing                                                                              CAS006
                                                                                              CAS006
     C                   IF        FSMOD = 'DL'                                               CAS006
                                                                                              CAS006
     C     KHedgdHMD     READE     ASDLHML3                                                   CAS006
                                                                                              CAS006
     C                   IF        NOT %EOF(ASDLHML3)                                         CAS006
     C                   EVAL      WHedgdHMDRead = 'Y'                                        CAS006
                                                                                              CAS006
     C                   SELECT                                                               CAS006
                                                                                              CAS006
     C                   WHEN      FSDTTP = 'V'                                               CAS006
     C                   MOVE      D3MVAL        WD3Mval12                                    CAS006
     C                   EVAL(H R) WHedgdHMD = WD3Mval12 * WHedgdPCTG                         CAS006
     C                   WHEN      FSDTTP = 'C'                                               CAS006
     C                   MOVE      D3MVCA        WD3Mvca12                                    CAS006
     C                   EVAL(H R) WHedgdHMD = WD3Mvca12 * WHedgdPCTG                         CAS006
     C                   WHEN      FSDTTP = 'R'                                               CAS006
     C                   MOVE      D3MRAT        WD3Mrat12                                    CAS006
     C                   EVAL(H R) WHedgdHMD =WD3Mrat12 * (10 ** 8) * WHedgdPCTG              CAS006
                                                                                              CAS006
     C                   ENDSL                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Lending                                                                              CAS006
                                                                                              CAS006
     C                   IF        FSMOD = 'LE'                                               CAS006
                                                                                              CAS006
     C     KHedgdHMD     READE     ASLEHML2                                                   CAS006
                                                                                              CAS006
     C                   IF        NOT %EOF(ASLEHML2)                                         CAS006
     C                   EVAL      WHedgdHMDRead = 'Y'                                        CAS006
                                                                                              CAS006
     C                   SELECT                                                               CAS006
                                                                                              CAS006
     C                   WHEN      FSDTTP = 'V'                                               CAS006
     C                   MOVE      LEMVAL        WLEMval12                                    CAS006
     C                   EVAL(H R) WHedgdHMD = WLEMval12 * WHedgdPCTG                         CAS006
     C                   WHEN      FSDTTP = 'C'                                               CAS006
     C                   MOVE      LEMVCA        WLEMvca12                                    CAS006
     C                   EVAL(H R) WHedgdHMD = WLEMvca12 * WHedgdPCTG                         CAS006
     C                   WHEN      FSDTTP = 'R'                                               CAS006
     C                   MOVE      LEMRAT        WLEMrat12                                    CAS006
     C                   EVAL(H R) WHedgdHMD =WLEMrat12 * (10 ** 8) * WHedgdPCTG              CAS006
                                                                                              CAS006
     C                   ENDSL                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Securities                                                                           CAS006
                                                                                              CAS006
     C                   IF        FSMOD = 'SE'                                               CAS006
                                                                                              CAS006
     C     KAssehm       READE     ASSEHML0                                                   CAS006
                                                                                              CAS006
     C                   IF        NOT %EOF(ASSEHML0)                                         CAS006
     C                   EVAL      WHedgdHMDRead = 'Y'                                        CAS006
                                                                                              CAS006
     C                   SELECT                                                               CAS006
                                                                                              CAS006
     C                   WHEN      FSDTTP = 'V'                                               CAS006
     C                   MOVE      SCMVAL        WSCMval12                                    CAS006
     C                   EVAL(H R) WHedgdHMD = WSCMval12 * WHedgdPCTG                         CAS006
     C                   WHEN      FSDTTP = 'C'                                               CAS006
     C                   MOVE      SCMVCA        WSCMvca12                                    CAS006
     C                   EVAL(H R) WHedgdHMD = WSCMvca12 * WHedgdPCTG                         CAS006
     C                   WHEN      FSDTTP = 'R'                                               CAS006
     C                   MOVE      SCMRAT        WSCMrat12                                    CAS006
     C                   EVAL(H R) WHedgdHMD =WSCMrat12 * (10 ** 8) * WHedgdPCTG              CAS006
                                                                                              CAS006
     C                   ENDSL                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Increment the Counter of Historic Market Data Read and                               CAS006
      ** sum up Data from Historic Data File.                                                 CAS006
                                                                                              CAS006
     C                   IF        WDerivHMDRead = 'Y' AND WHedgdHMDRead = 'Y'                CAS006
                                                                                              CAS006
     C                   EVAL      WCounter= WCounter + 1                                     CAS006
                                                                                              CAS006
     C                   EVAL(R)   WSumY = WSumY + WDerivHMD                                  CAS006
     C                   EVAL(R)   WSumYSqrd = WSumYSqrd +                                    CAS006
     C                                      (WDerivHMD * WDerivHMD)                           CAS006
                                                                                              CAS006
     C                   EVAL(R)   WSumX = WSumX + WHedgdHMD                                  CAS006
     C                   EVAL(R)   WSumXSqrd = WSumXSqrd +                                    CAS006
     C                                      (WHedgdHMD * WHedgdHMD)                           CAS006
     C                   EVAL(R)   WSumXY = WSumXY + (WDerivHMD * WHedgdHMD)                  CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDDO                                                                CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
                                                                                              CAS006
      **********************************************************************                  CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SrNotaSum - Compute for Notations based on the Sums of       *                       CAS006
      *              Squares                                          *                       CAS006
      *                                                               *                       CAS006
      *  Called by: SRCalcuHE                                         *                       CAS006
      *                                                               *                       CAS006
      *  Calls: None                                                  *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
                                                                                              CAS006
     C     SrNotaSum     BEGSR                                                                CAS006
                                                                                              CAS006
     C                   IF        WCounter = FSDPTS                                          CAS006
     C                   EVAL      WSxy = *ZERO                                               CAS006
     C                   EVAL      WSxx = *ZERO                                               CAS006
     C                   EVAL      WSyy = *ZERO                                               CAS006
     C                   EVAL      WSse = *ZERO                                               CAS006
                                                                                              CAS006
     C                   EVAL(R)   WWxy = (WSumX * WSumY)/FSDPTS                              CAS006
     C                   EVAL(R)   WSxy = WSumXY - WWxy                                       CAS006
     C                   EVAL(R)   WWxx = (WSumX * WSumX)/FSDPTS                              CAS006
     C                   EVAL(R)   WSxx = WSumXSqrd - WWxx                                    CAS006
     C                   EVAL(R)   WWyy = (WSumY * WSumY)/FSDPTS                              CAS006
     C                   EVAL(R)   WSyy = WSumYSqrd - WWyy                                    CAS006
                                                                                              CAS006
      ** Sum of Squares for Error measures the amount of variation.                           CAS006
                                                                                              CAS006
     C                   IF        WSxy <> *ZERO AND WSxx <> *ZERO                            CAS006
     C                   EVAL(R)   WWse = (WSyy/WSxy) - (WSxy/WSxx)                           CAS006
     C                   EVAL(R)   WSse = WSxy * WWse                                         CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
                                                                                              CAS006
      **********************************************************************                  CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SrRegAsse - Assess Linkages using the Regression Analysis    *                       CAS006
      *                                                               *                       CAS006
      *  Called by: SRCalcuHE                                         *                       CAS006
      *                                                               *                       CAS006
      *  Calls: None                                                  *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
                                                                                              CAS006
     C     SrRegAsse     BEGSR                                                                CAS006
                                                                                              CAS006
     C                   EVAL      WRSqrd = *ZERO                                             CAS006
     C                   EVAL      WTs = *ZERO                                                CAS006
     C                   EVAL      WSlopeCoeff = *ZERO                                        CAS006
                                                                                              CAS006
      ** When there is insufficient data to be regressed based on the                         CAS006
      ** number of data points for the linkage or when either of the                          CAS006
      ** hedged item HMD variance or derivative HMV variance is zero,                         CAS006
      ** the hedge linkage will automatically go into ineffective                             CAS006
      ** status.                                                                              CAS006
                                                                                              CAS006
     C                   IF        WCounter < FSDPTS                                          CAS006
     C                             OR WSxx = *ZERO OR WSyy = *ZERO                            CAS006
     C                             OR WSxy = *ZERO                                            CAS006
     C                   EVAL      FSRECI = 'X'                                               CAS006
     C                   EVAL      FSRSQR = WRSqrd                                            CAS006
     C                   EVAL      FSTSTA = WTs                                               CAS006
     C                   EVAL      FSSLCO = WSlopeCoeff                                       CAS006
     C                   EVAL      FSDPTR = WCounter                                          CAS006
     C                   EVAL      FSHEFP = *ZERO                                             CAS006
     C                   GOTO      ESrRegAsse                                                 CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** A hedge will be effective using this method when all of the                          CAS006
      ** three factors listed below fall within the bounds specified                          CAS006
      ** for each.                                                                            CAS006
                                                                                              CAS006
      ** 1. R-Squared - coefficient of determination which is used as                         CAS006
      **    a measure of correlation should be 80% (.8) or greater.                           CAS006
                                                                                              CAS006
     C                   EVAL(H R) WRSqrd = (WSxy / WSxx) * (WSxy / WSyy)                     CAS006
     C                   IF        WRSqrd < .8                                                CAS006
     C                   EVAL      FSRECI = 'X'                                               CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** 2. T-Statistic should be significant at Greater Confidence                           CAS006
      **    Level. When the hedging derivative has a perfect inverse                          CAS006
      **    relationship w/ the hedged item (SSE = 0), automatically                          CAS006
      **    Hedged Item has a significant relationship with Hedge                             CAS006
      **    Derivative.                                                                       CAS006
                                                                                              CAS006
     C                   IF        WSse <> *ZERO                                              CAS006
                                                                                              CAS006
      ** Degrees of Freedom (n-2)                                                             CAS006
                                                                                              CAS006
     C                   EVAL      WDf = FSDPTS - 2                                           CAS006
                                                                                              CAS006
      ** Alpha                                                                                CAS006
                                                                                              CAS006
     C                   EVAL      WAlpha = (100- FSCLVL)/100                                 CAS006
                                                                                              CAS006
     C                   EVAL(R)   WTsNum = WSxy/WSxx                                         CAS006
     C                   EVAL(R)   WTsDen1 = %SQRT(WSse/WDf)                                  CAS006
     C                   EVAL(R)   WTsDen2 = %SQRT(WSxx)                                      CAS006
     C                   EVAL(R)   WTsDen = WTsDen1/WTsDen2                                   CAS006
                                                                                              CAS006
      ** Compute for T-Statistics.                                                            CAS006
                                                                                              CAS006
     C                   EVAL(H R) WTs = WTsNum/WTsDen                                        CAS006
                                                                                              CAS006
      ** Retrieve the T Value from the T Distribution Table.                                  CAS006
                                                                                              CAS006
     C                   EVAL      KXXDfrd = WDf                                              CAS006
     C                   EVAL      KXXArea = WAlpha / 2                                       CAS006
                                                                                              CAS006
     C     KSdtdtb       CHAIN     SDTDTBL0                                                   CAS006
                                                                                              CAS006
     C                   IF        %FOUND(SDTDTBL0)                                           CAS006
     C                   EVAL      WTValue = XXTVAL                                           CAS006
                                                                                              CAS006
      ** If the computed T-Statistics is greater than or equal to                             CAS006
      ** - T Value and less than or equal to T Value,  the hedged item                        CAS006
      ** has no significant relationship with the derivative item.                            CAS006
      ** Thus, ineffective.                                                                   CAS006
                                                                                              CAS006
     C                   If        WTs >= -WTValue AND WTs <= WTValue                         CAS006
     C                   EVAL      FSRECI = 'X'                                               CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ELSE                                                                 CAS006
     C     *LOCK         IN        LDA                                                        CAS006
     C                   EVAL      DBFILE =  'SDTDTBL0'                                       CAS006
     C                   MOVEL     KXXDfrd       WXXDfrd                                      CAS006
     C                   MOVEL     KXXArea       WXXArea                                      CAS006
     C                   EVAL      DBKEY  =  WXXDfrd + WXXArea                                CAS006
     C                   EVAL      DBASE  =  011                                              CAS006
     C                   EVAL      DBPROC =  'SR/SrRegAsse'                                   CAS006
     C                   OUT       LDA                                                        CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** 3. The slope coefficient which is the change in the derivative                       CAS006
      **    value (dependent variable) over the change in the hedged item                     CAS006
      **    value (independent variable) or  "rise" over "run" must be                        CAS006
      **    between -.8 and -1.25.                                                            CAS006
                                                                                              CAS006
     C                   EVAL(H R) WSlopeCoeff = WSxy/WSxx                                    CAS006
                                                                                              CAS006
     C                   IF        WSlopeCoeff < -1.25 OR WSlopeCoeff > -.8                   CAS006
     C                   EVAL      FSRECI = 'X'                                               CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   EVAL      FSRSQR = WRSqrd                                            CAS006
     C                   EVAL      FSTSTA = WTs                                               CAS006
     C                   EVAL      FSSLCO = WSlopeCoeff                                       CAS006
     C                   EVAL      FSDPTR = WCounter                                          CAS006
     C                   EVAL      FSHEFP = *ZERO                                             CAS006
                                                                                              CAS006
     C     ESrRegAsse    ENDSR                                                                CAS006
                                                                                              CAS006
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0, *PSSR                                        *
      *        AOSARDR0                                               *                       CAS003
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Define LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = PSProcPgm
     C                   EVAL      DBMOD = PSProcMod
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBASE = *ZERO
     C                   OUT       LDA
 
      **  Use access program to read bank details file
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRetrnCde
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRetrnCde <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  '*CALL'
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBPROC =  'SR/*INZSR'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CAS004
     C**********         CALL      'AOGELRR0'                                          CAS004 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *Blanks       PRtrnCode                                    CAS004
     C                   PARM      '*FIRST '     POptn                                        CAS004
     C*****SDGELR        PARM      SDGELR        DSFDY                                 CAS004 CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
                                                                                              CAS004
     C                   IF        PRtrnCode <> *Blanks                                       CAS004
     C     *LOCK         IN        LDA                                                        CAS004
     C                   EVAL      *INU7 = *ON                                                CAS004
     C                   EVAL      *INU8 = *ON                                                CAS004
     C                   EVAL      DBFILE =  'SDGELRPD'                                       CAS004
     C                   EVAL      DBKEY  =  '*CALL'                                          CAS004
     C                   EVAL      DBASE  =  008                                              CAS004
     C                   EVAL      DBPROC =  'SR/*INZSR'                                      CAS004
     C                   OUT       LDA                                                        CAS004
     C                   EXSR      *PSSR                                                      CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS003
      ** Check if enhancement CAS003 is switched on.                                          CAS003
                                                                                              CAS003
     C                   CALL      'AOSARDR0'                                                 CAS003
     C                   PARM      *BLANKS       PRtrnCode                                    CAS003
     C                   PARM      '*VERIFY'     POptn                                        CAS003
     C                   PARM      'CAS003'      PSard                                        CAS003
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS003
                                                                                              CAS003
     C                   IF        PRtrnCode = *BLANKS                                        CAS003
     C                   EVAL      CAS003 = 'Y'                                               CAS003
                                                                                              CAS003
     C                   ELSE                                                                 CAS003
     C                   EVAL      CAS003 = 'N'                                               CAS003
                                                                                              CAS003
     C                   IF        PRtrnCode <> '*NRF   '                                     CAS003
     C     *LOCK         IN        LDA                                                        CAS003
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS003
     C                   EVAL      DBKEY = 'CAS003'                                           CAS003
     C                   EVAL      DBASE = 006                                                CAS003
     C                   EVAL      DBPROC =  'SR/*INZSR'                                      CAS003
     C                   OUT       LDA                                                        CAS003
     C                   EXSR      *PSSR                                                      CAS003
     C                   ENDIF                                                                CAS003
     C                   ENDIF                                                                CAS003
                                                                                              CAS004
      ** Check if enhancement CAS004 is switched on.                                          CAS004
                                                                                              CAS004
     C                   CALL      'AOSARDR0'                                                 CAS004
     C                   PARM      *BLANKS       PRtrnCode                                    CAS004
     C                   PARM      '*VERIFY'     POptn                                        CAS004
     C                   PARM      'CAS004'      PSard                                        CAS004
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS004
                                                                                              CAS004
     C                   IF        PRtrnCode = *BLANKS                                        CAS004
     C                   EVAL      CAS004 = 'Y'                                               CAS004
                                                                                              CAS004
     C                   ELSE                                                                 CAS004
     C                   EVAL      CAS004 = 'N'                                               CAS004
                                                                                              CAS004
     C                   IF        PRtrnCode <> '*NRF   '                                     CAS004
     C     *LOCK         IN        LDA                                                        CAS004
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS004
     C                   EVAL      DBKEY = 'CAS004'                                           CAS004
     C                   EVAL      DBASE = 007                                                CAS004
     C                   EVAL      DBPROC =  'SR/*INZSR'                                      CAS004
     C                   OUT       LDA                                                        CAS004
     C                   EXSR      *PSSR                                                      CAS004
     C                   ENDIF                                                                CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS005
      ** Check if Enhancements to CAS001, CAS002 and CAS004 is installed                      CAS005
                                                                                              CAS005
     C                   CALL      'AOSARDR0'                                                 CAS005
     C                   PARM      *BLANKS       PRtrnCode                                    CAS005
     C                   PARM      '*VERIFY'     POptn                                        CAS005
     C                   PARM      'CAS005'      PSard                                        CAS005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS005
                                                                                              CAS005
     C                   IF        PRtrnCode = *BLANKS                                        CAS005
     C                   EVAL      CAS005 = 'Y'                                               CAS005
                                                                                              CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      CAS005 = 'N'                                               CAS005
                                                                                              CAS005
     C                   IF        PRtrnCode <> '*NRF   '                                     CAS005
     C     *LOCK         IN        LDA                                                        CAS005
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS005
     C                   EVAL      DBKEY = 'CAS005'                                           CAS005
     C                   EVAL      DBASE = 009                                                CAS005
     C                   EVAL      DBPROC =  'SR/*INZSR'                                      CAS005
     C                   OUT       LDA                                                        CAS005
     C                   EXSR      *PSSR                                                      CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS006
      ** Check if Hedge Accounting Phase B is installed.                                      CAS006
                                                                                              CAS006
     C                   CALL      'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRtrnCode                                    CAS006
     C                   PARM      '*VERIFY'     POptn                                        CAS006
     C                   PARM      'CAS006'      PSard                                        CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
     C                   IF        PRtrnCode = *BLANKS                                        CAS006
                                                                                              CAS006
     C                   EVAL      CAS006 = 'Y'                                               CAS006
                                                                                              CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
     C                   EVAL      CAS006 = 'N'                                               CAS006
                                                                                              CAS006
     C                   IF        PRtrnCode <> '*NRF   '                                     CAS006
     C     *LOCK         IN        LDA                                                        CAS006
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS006
     C                   EVAL      DBKEY = 'CAS006'                                           CAS006
     C                   EVAL      DBASE = 010                                                CAS006
     C                   EVAL      DBPROC =  'SR/*INZSR'                                      CAS006
     C                   OUT       LDA                                                        CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
 
      ** Check if Delayed Hedge Assessment is installed.                                      CAS008
                                                                                              CAS008
     C                   CALL      'AOSARDR0'                                                 CAS008
     C                   PARM      *BLANKS       PRtrnCode                                    CAS008
     C                   PARM      '*VERIFY'     POptn                                        CAS008
     C                   PARM      'CAS008'      PSard                                        CAS008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS008
                                                                                              CAS008
     C                   IF        PRtrnCode = *BLANKS                                        CAS008
                                                                                              CAS008
     C                   EVAL      CAS008 = 'Y'                                               CAS008
                                                                                              CAS008
     C                   ELSE                                                                 CAS008
                                                                                              CAS008
     C                   EVAL      CAS008 = 'N'                                               CAS008
                                                                                              CAS008
     C                   IF        PRtrnCode <> '*NRF   '                                     CAS008
     C     *LOCK         IN        LDA                                                        CAS008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS008
     C                   EVAL      DBKEY = 'CAS008'                                           CAS008
     C                   EVAL      DBASE = 011                                                CAS008
     C                   EVAL      DBPROC =  'SR/*INZSR'                                      CAS008
     C                   OUT       LDA                                                        CAS008
     C                   EXSR      *PSSR                                                      CAS008
     C                   ENDIF                                                                CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C     KDLYHV        KLIST                                                                CAS008
     C                   KFLD                    KDealno                                      CAS008
     C                   KFLD                    KABInd                                       CAS008
     C                   KFLD                    KDEffd                                       CAS008
                                                                                              CAS008
     C     KDLYHVR       KLIST                                                                CAS008
     C                   KFLD                    KRXDlNo                                      CAS008
     C                   KFLD                    KRXCyCd                                      CAS008
     C                   KFLD                    KABInd                                       CAS008
     C                   KFLD                    KDEffd                                       CAS008
                                                                                              CAS008
     C     KDLNHVL       KLIST                                                                CAS008
     C                   KFLD                    KDLnpvm                                      CAS008
     C                   KFLD                    KDLdlno                                      CAS008
     C                   KFLD                    KDLcycd                                      CAS008
     C                   KFLD                    KDeffd                                       CAS008
                                                                                              CAS008
      ** Key List for Midas DL Forward Commitments File
 
     C     KDLNPVL       KLIST
     C                   KFLD                    KDLnpvm
     C                   KFLD                    KDLdlno
     C                   KFLD                    KDLcycd
 
      ** Key List for Midas AS Hedge Transaction File Retrieval
 
     C     KASHTRN       KLIST
     C                   KFLD                    KAShedi
     C                   KFLD                    KASdhin
                                                                                              CAS005
     C     KASHTR5       KLIST                                                                CAS005
     C                   KFLD                    KAShed5                                      CAS005
     C                   KFLD                    KASdhi5                                      CAS005
                                                                                              CAS005
      ** Key List for Revalued CIRS Files                                                     CAS005
                                                                                              CAS005
     C     KRXNPV        KLIST                                                                CAS005
     C                   KFLD                    KRXDlNo                                      CAS005
     C                   KFLD                    KRXCyCd                                      CAS005
 
      ** Key List for Midas SE Revalued Security Positions File
 
     C     KSENPVL       KLIST
     C                   KFLD                    KSEsesn
     C                   KFLD                    KSEbrca
     C                   KFLD                    KSEbokc
     C                   KFLD                    KSEmkti
     C                   KFLD                    KSEbhtv
                                                                                              CAS008
     C     KSEHMVL       KLIST                                                                CAS008
     C                   KFLD                    KSEsesn                                      CAS008
     C                   KFLD                    KSEbrca                                      CAS008
     C                   KFLD                    KSEbokc                                      CAS008
     C                   KFLD                    KSEmkti                                      CAS008
     C                   KFLD                    KSEbhtv                                      CAS008
     C                   KFLD                    KDEffd                                       CAS008
                                                                                              CAS003
      ** Key List for Midas FF Revalued FF Positions File                                     CAS003
                                                                                              CAS003
     C     KFFNPVL       KLIST                                                                CAS003
     C                   KFLD                    KFFbrca                                      CAS003
     C                   KFLD                    KFFbkcd                                      CAS003
     C                   KFLD                    KFFistt                                      CAS003
     C                   KFLD                    KFFyrno                                      CAS003
     C                   KFLD                    KFFmthn                                      CAS003
     C                   KFLD                    KFFpcal                                      CAS003
                                                                                              CAS006
      ** Key List for idas AS SE Historic Mrkt Dta by Sec Posit/ValueDt                       CAS006
                                                                                              CAS006
     C     KAssehm       KLIST                                                                CAS006
     C                   KFLD                    KHedgdHEDI                                   CAS006
     C                   KFLD                    KHedgdSESN                                   CAS006
     C                   KFLD                    KHedgdBRCA                                   CAS006
     C                   KFLD                    KHedgdBKCD                                   CAS006
     C                   KFLD                    KHedgdMKTI                                   CAS006
     C                   KFLD                    KHedgdBHTV                                   CAS006
                                                                                              CAS008
     C     KDAssehm      KLIST                                                                CAS008
     C                   KFLD                    KHedgdHEDI                                   CAS008
     C                   KFLD                    KHedgdSESN                                   CAS008
     C                   KFLD                    KHedgdBRCA                                   CAS008
     C                   KFLD                    KHedgdBKCD                                   CAS008
     C                   KFLD                    KHedgdMKTI                                   CAS008
     C                   KFLD                    KHedgdBHTV                                   CAS008
     C                   KFLD                    KValueDat                                    CAS008
                                                                                              CAS006
      ** Key List for Midas AS DL Historic Mrkt Dta by Hedge Id/Deal No/                      CAS006
      ** Value Date - Derivative item                                                         CAS006
                                                                                              CAS006
     C     KDerivHMD     KLIST                                                                CAS006
     C                   KFLD                    KDerivHEDI                                   CAS006
     C                   KFLD                    KDerivDLNO                                   CAS006
                                                                                              CAS006
      ** Key List for Midas AS DL Historic Mrkt Dta by Hedge Id/Deal No/                      CAS006
      ** Value Date and Midas AS LE Historic Mrkt Dta by Hedge Id/Loan No/                    CAS006
      ** Value Date - Hedged Item                                                             CAS006
                                                                                              CAS006
     C     KHedgdHMD     KLIST                                                                CAS006
     C                   KFLD                    KHedgdHEDI                                   CAS006
     C                   KFLD                    KHedgdDLNO                                   CAS006
                                                                                              CAS008
     C     KDLDHdg       KLIST                                                                CAS008
     C                   KFLD                    KDerivHEDI                                   CAS008
     C                   KFLD                    KDerivDLNO                                   CAS008
     C                   KFLD                    KValueDat                                    CAS008
                                                                                              CAS006
      ** Key List for Midas FF Revalued FF Positions File                                     CAS006
                                                                                              CAS006
     C     KSdtdtb       KLIST                                                                CAS006
     C                   KFLD                    KXXDfrd                                      CAS006
     C                   KFLD                    KXXArea                                      CAS006
 
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
      * Called by: Main Processing, SRAccuAmt, SRCalcuHe, *INZSR          *
      *                                                                   *
      * Calls: DBERRCTL                                                   *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
