     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas AP API extract invalid transactions')            *
      *****************************************************************
      *                                                               *
      *  Midas - API                                                  *
      *                                                               *
      *  AP0005 - Extract Invalid Transactions                        *
      *                                                               *
      *  Function:  This program will extract all invalid transactions*
      *             still on the various invalid transaction files    *
      *                                                               *
      *  Called By: APC0002 - Transactions Awaiting Repair component  *
      *             APC0003 - Transactions Repaired component         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL133             Date 01May13               *
      *  Prev Amend No. CGL132             Date 01May13               *
      *                 CFT039             Date 28Sep12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR787620           Date 10Jun11               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 CER034A            Date 19May08               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 249071             Date 31Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CAP183             Date 05Jan06               *
      *                 233205             Date 25Apr05               *
      *                 232543             Date 01Apr05               *
      *                 CGL032             Date 05Jul04               *
      *                 CDL038             Date 10May05               *
      *                 CSE071             Date 19Jul05               *
      *                 CDL028             Date 07Feb05               *
      *                 CSW037A            Date 02May05               *
      *                 CAS011             Date 16May05               *
      *                 CAS009             Date 04May04               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG2254            Date 06May04               *
      *                 CAP084             Date 03May04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP079             Date 19Aug02               *
      *                 CAP078             Date 31Oct02               *
      *                 CAP077             Date 19Aug02               *
      *                 CAP076             Date 24May02               *
      *                 CAP075             Date 12Aug02               *
      *                 CAP074             Date 26Mar02               *
      *                 CAP073             Date 14May02               *
      *                 CSE031             Date 13Dec01               *  PART - reinstate at 4.01
      *                 CSE040             Date 28Mar03               *
      *                 CAP182             Date 14Mar03               *
      *                 CSE039             Date 10Mar03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP055             Date 13Mar02               *
      *                 CSC011             Date 01May01               *
      *                 CAP069             Date 28Mar02               *
      *                 CAP072             Date 28Mar02               *
      *                 CAP071             Date 22Mar02               *
      *                 CAP068             Date 22Mar02               *
      *                 CAP070             Date 11Mar02               *
      *                 CSE031             Date 13Dec01               *
      *                 CAP166             Date  5Mar01               *
      *                 CAS001             Date 23Nov01               *
      *                 CAP067             Date 24Sep01               *
      *                 196570             Date 26Jul01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11May01               *
      *                 CAP038             Date 11May01               *
      *                 CAP057             Date 11May01               *
      *                 CAP058             Date 11May01               *
      *                 CAP059             Date 11May01               *
      *                 CAP060             Date 11May01               *
      *                 CAP140             Date 17Oct00               *
      *                 CAP042             Date 08Jan01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP039             Date 14Jul00               *
      *                 CAP137             Date 07Feb00               *
      *                 CAP136             Date 15Nov99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE017             Date 20Oct99               *
      *                 CAP033             Date 26Apr99               *
      *                 CAP035             Date 15APR99               *
      *                 CAP034             Date 15APR99               *
      *                 CAP031             Date 15APR99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004             Date 25Aug98               *
      *                 CAP002  *Create    Date 16Feb98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL133 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Enquiry Only                       *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  CFT039 - SWIFT Mapping of Field Ordering Bank (Recompile)    *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,APH00011                                 *
      *             WNCPYSRC,APH00012                                 *
      *             WNCPYSRC,APH00013                                 *
      *             WNCPYSRC,APH00014                                 *
      *             WNCPYSRC,APH00015                                 *
      *             WNCPYSRC,APH00022                                 *
      *             WNCPYSRC,APH00023                                 *
      *             WNCPYSRC,APH00024                                 *
      *             WNCPYSRC,APH00025                                 *
      *             WNCPYSRC,APH00026                                 *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  CER034A - German Features - New Fields and Enquiries         *
      *  CER048 - German Features - Taxes                             *
      *  249071 - CSE097 problems in BYSL(Recompile)                  *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CAP183 - Conversion of Market Prices Input into modular      *
      *           structure to use APIs                               *
      *  233205 - Missing processing in AP0005                        *
      *  232543 - Fix to CGL031 (Recompile)                           *
      *  CGL032 - Automatic Exchange of Information.                  *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines                                        *
      *  BUG2254 - Recompile over changed PF/SDISECDPD                *
      *  CAP084 - ThinClient API - LERI (recompiled)                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP079 - Lending API enhancements - Repayments schedule      *
      *  CAP078 - Lending API enhancements - Fee input                *
      *  CAP077 - Lending API enhancements - Manual payments          *
      *  CAP076 - Lending API enhancements - Rollover Instructions    *
      *  CAP075 - Lending API enhancements - Loan amendments          *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *  CAP073 - Conversion of MN inputs into modular structure to   *
      *           use as APIs. Facility input Transaction Details     *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *  CSE040 - Securities Statement Processing                     *
      *  CAP182 - Auto Settlement of Trades                           *
      *         - Conversion of SE Trade Settlement Input maintence   *
      *           function to modular structure to use as APIs.       *
      *  CSE039 - Automatic Settlement of Trades                      *
      *  CAP055 - APIs for FRA/IRS Caps/Collars/Floors                *
      *  CSC011 - 24x7 Midas Availability for LE inputs               *
      *  CAP069 - Conversion of LE inputs into modular structure to   *
      *           use as APIs. Risk Participants.                   *
      *  CAP072 - Conversion of LE inputs into modular structure to   *
      *           use as APIs. Fee Settlement and Adjustment input    *
      *  CAP071 - Conversion of LE inputs into modular structure to   *
      *           use as APIs. Facility Amendments.                   *
      *  CAP068 - Conversion of LE inputs into modular structure to   *
      *           use as APIs. Funding Participants.                  *
      *  CAP070 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *  CAP166 - API for Non-Currency OTC                            *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  CAP067 - Repurchase Agreements API.                          *
      *  196570 - Patch for Market Data Feed (recompile)              *
      *  CSD006 - Market Data Feeds                                   *
      *  CAP038 - Midas APIs - Base Rates                             *
      *  CAP057 - Midas APIs - Spot Rates                             *
      *  CAP058 - Midas APIs - Intr Rates                             *
      *  CAP059 - Midas APIs - Fwrd Rates                             *
      *  CAP060 - Midas APIs - Secr Prices                            *
      *  CAP042 - Conversion of Internal Funding Deal inputs into     *
      *           modular structure to use as APIs.                   *
      *  CAP140 - Conversion of SE Security Diary Event inputs into   *
      *           modular structure to use as APIs.                   *
      *  CAP039 - Add processing for SD Security Customer Details     *
      *  CAP137 - Conversion of SE Securities inputs into modular     *
      *           structure to use as APIs.                           *
      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
      *           modular structure to use as APIs.                   *
      *  CSE017 - Cum/Ex Indicator on Depot Movements.                *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs.                                        *
      *  CAP035 - Add processing for GL ACCOUNTS MAINTENANCE          *
      *  CAP034 - Add processing for SD CUSTOMERS DETAILS             *
      *  CAP031 - Add processing for FT Outgoing Payments             *
      *  CAP004 - Addition of FRA/IRS and SE transactions             *
      *  CAP002 - Conversion of transaction inputs into modular       *
      *           structure to use as APIs.                           *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
     F*MMIDEAMP*IF***E           K DISK    INFSR(*PSSR)                                       CAP033
     FMMIDEAMPD IF   E           K DISK    INFSR(*PSSR)                                       CAP033
     F                                     RENAME(MMIDEAMD0:MMIDEAM0)
      ** Deal amemdments invalid logging file **
     F*MMILDNIP*IF***E           K DISK    INFSR(*PSSR)                                       CAP033
     FMMILDNIPD IF   E           K DISK    INFSR(*PSSR)                                       CAP033
     F                                     RENAME(MMILDNID0:MMILDNI0)
      ** Loan/deposits invalid logging file **
     F*MMINASPP*IF***E           K DISK    INFSR(*PSSR)                                       CAP033
     FMMINASPPD IF   E           K DISK    INFSR(*PSSR)                                       CAP033
     F                                     RENAME(MMINASPD0:MMINASP0)
      ** Negotiable assets purchased invalid logging file **
     F*MMINASSP*IF***E           K DISK    INFSR(*PSSR)                                       CAP033
     FMMINASSPD IF   E           K DISK    INFSR(*PSSR)                                       CAP033
     F                                     RENAME(MMINASSD0:MMINASS0)
      ** Negotiable assets sold invalid logging file **
     F*FXIFXDLP*IF***E           K DISK    INFSR(*PSSR)                                       CAP033
     FFXIFXDLPD IF   E           K DISK    INFSR(*PSSR)                                       CAP033
     F                                     RENAME(FXIFXDLD0:FXIFXDL0)
      ** Negotiable assets sold invalid logging file **
     F*IRIFRAPD*IF***E           K DISK    INFSR(*PSSR)                                CAP004 CAP033
     FIRIFRAPD  IF   E           K DISK    INFSR(*PSSR)                                       CAP033
      ** Forward Rate Agreements invalid logging file **                  CAP004
     F*IRISIRSP*IF***E           K DISK    INFSR(*PSSR)                                CAP004 CAP033
     FIRISIRSPD IF   E           K DISK    INFSR(*PSSR)                                       CAP033
     F                                     RENAME(IRISIRSD0:IRISIRS0)           CAP004
      ** Single Ccy IRS invalid logging file **                           CAP004
     F*IRICIRSP*IF***E           K DISK    INFSR(*PSSR)                                CAP004 CAP033
     FIRICIRSPD IF   E           K DISK    INFSR(*PSSR)                                       CAP033
     F                                     RENAME(IRICIRSD0:IRICIRS0)           CAP004
      ** Cross Ccy IRS invalid logging file **                            CAP004
     F*SEIDPMVP*IF***E           K DISK    INFSR(*PSSR)                                CAP004 CAP033
     FSEIDPMVPD IF   E           K DISK    INFSR(*PSSR)                                       CAP033
     F                                     RENAME(SEIDPMVD0:SEIDPMV0)           CAP004
      ** SE Depot Movts invalid logging file **                           CAP004
     F*SEITRADP*IF***E           K DISK    INFSR(*PSSR)                                CAP004 CAP033
     FSEITRADPD IF   E           K DISK    INFSR(*PSSR)                                       CAP033
     F                                     RENAME(SEITRADD0:SEITRAD0)           CAP004
      ** SE Trades invalid logging file **                                CAP004
      *                                                                   CAP004
     F*ABIINTCP*IF***E           K DISK    INFSR(*PSSR)                                CAP004 CAP033
     FABIINTCPD IF   E           K DISK    INFSR(*PSSR)                                       CAP033
     F                                     RENAME(ABIINTCD0:ABIINTC0)           CAP004
      ** SE Trades invalid logging file **                                CAP004
      *                                                                   CAP004
     F*FFIEXTRP*IF***E           K DISK    INFSR(*PSSR)                                CAP004 CAP033
     FFFIEXTRPD IF   E           K DISK    INFSR(*PSSR)                                       CAP033
     F                                     RENAME(FFIEXTRD0:FFIEXTR0)           CAP004
      ** FF Exchange Traded Futures & Options invalid logging file **     CAP004
      *                                                                   CAP004
     F*FFIOTCCP*IF***E           K DISK    INFSR(*PSSR)                                CAP004 CAP033
     FFFIOTCCPD IF   E           K DISK    INFSR(*PSSR)                                       CAP033
     F                                     RENAME(FFIOTCCD0:FFIOTCC0)           CAP004
      ** FF Over the Counter Options invalid logging file **              CAP004
      *
      ** FF Non-currency OTC options invalid logging file                                     CAP166
     FFFIOTCOPD IF   E           K DISK    INFSR(*PSSR)                                       CAP166
     F                                     RENAME(FFIOTCOD0:FFIOTCO0)                         CAP166
                                                                                              CAP166
     F*FTIOPAYP*IF***E           K DISK    INFSR(*PSSR)                                CAP031 CAP033
     FFTIOPAYPD IF   E           K DISK    INFSR(*PSSR)                                       CAP033
     F                                     RENAME(FTIOPAYD0:FTIOPAY0)                 CAP031
      ** FT Outgoing Payments invalid logging file **                           CAP031
      *                                                                         CAP034
     F*SDICUSDP*IF***E           K DISK    INFSR(*PSSR)                                CAP034 CAP033
     FSDICUSDPD IF   E           K DISK    INFSR(*PSSR)                                       CAP033
     F                                     RENAME(SDICUSDD0:SDICUSD0)                 CAP034
      ** SD Customer Details invalid logging file **                            CAP034
      *                                                                         CAP035
     F*GLIAMADP*IF***E           K DISK    INFSR(*PSSR)                                CAP035 CAP033
     FGLIAMADPD IF   E           K DISK    INFSR(*PSSR)                                       CAP033
     F                                     RENAME(GLIAMADD0:GLIAMAD0)                 CAP035
      ** GL Account Maintenance invalid logging file **                         CAP035
      *                                                                         CAP035
     FPMIPFDMPD IF   E           K DISK    INFSR(*PSSR)                                       CAP033
      ** Portfolio Definition Details invalid logging file                CAP033
     F                                     RENAME(PMIPFDMD0:PMIPFDM0)           CAP033
      *                                                                   CAP033
     FFTIIPAYPD IF   E           K DISK    INFSR(*PSSR)                         CAP136
     F                                     RENAME(FTIIPAYD0:FTIIPAY0)           CAP136
      ** FT Incoming Payments invalid logging file                              CAP136
      *                                                                         CAP136
     FSEISECSPD IF   E           K DISK    INFSR(*PSSR)                         CAP137
     F                                     RENAME(SEISECSD0:SEISECS0)           CAP137
      ** SE Securities invalid logging file                                     CAP137
      *                                                                         CAP137
     FSEISEDEPD IF   E           K DISK    INFSR(*PSSR)                                       CAP140
     F                                     RENAME(SEISEDED0:SEISEDE0)                         CAP140
      ** SE Security Diary Events invalid logging file                                        CAP140
      *                                                                                       CAP140
     FSDISECDPD IF   E           K DISK    INFSR(*PSSR)                                       CAP039
      ** SD Security Customer Details invalid logging file                CAP039
     F                                     RENAME(SDISECDD0:SDISECD0)           CAP039
      *                                                                   CAP039
     FFDIFWRTPD IF   E           K DISK    INFSR(*PSSR)                         CAP059
      ** FD Forward Rate Details invalid logging file                           CAP059
     F                                     RENAME(FDIFWRTD0:FDIFWRD0)           CAP059
      *                                                                         CAP059
     FFDIINTRPD IF   E           K DISK    INFSR(*PSSR)                         CAP058
      ** FD Interest Rate Details invalid logging file                          CAP058
     F                                     RENAME(FDIINTRD0:FDIINTD0)           CAP058
      *                                                                         CAP058
     FSDIBSRTPD IF   E           K DISK    INFSR(*PSSR)                         CAP038
      ** FD Base Rate Details invalid logging file                              CAP038
     F                                      RENAME(SDIBSRTD0:FDIBSRD0)          CAP038
      *                                                                         CAP038
     FSDISPTRPD IF   E           K DISK    INFSR(*PSSR)                         CAP057
      ** FD Spot Rate Details invalid logging file                              CAP057
     F                                     RENAME(SDISPTRD0:SDISPTD0)           CAP057
      *                                                                         CAP057
     FSEIPRCSPD IF   E           K DISK    INFSR(*PSSR)                         CAP060
      ** SE Security Price Details invalid logging file                         CAP060
     F                                     RENAME(SEIPRCSD0:SEIPRCD0)           CAP060
      *                                                                         CAP060
      ** AB Internal Funding Deals invalid logging file                                       CAP042
     FABIFUNDPD IF   E           K DISK    INFSR(*PSSR)                                       CAP042
     F                                     PREFIX(DD:2)                                       CAP042
     F                                     RENAME(ABIFUNDD0:ABIFUND0)                         CAP042
                                                                                              CAP042
     FMMIRPLDPD IF   E           K DISK    INFSR(*PSSR)                                       CAP067
      ** MM Invalid REPO Loan & Deposit                                                       CAP067
     F                                     RENAME(MMIRPLDD0:MMIRPLD0)                         CAP067
      *                                                                                       CAP067
     FSEIBYSLPD IF   E           K DISK    INFSR(*PSSR)                                       CAP067
      ** SE Invalid Buy-Sell Transaction File                                                 CAP067
     F                                     RENAME(SEIBYSLD0:SEIBYSD0)                         CAP067
                                                                                              CAS001
     FSDIYRATPD IF   E           K DISK    INFSR(*PSSR)                                       CAS001
      ** SD Yield Rates Invalid File                                                          CAS001
                                                                                              CAS001
     FLEIASGNPD IF   E           K DISK    INFSR(*PSSR)                                       CAP070
      ** LE Assignments Details invalid logging file                                          CAP070
     F                                     RENAME(LEIASGND0:LEIASGD0)                         CAP070
      *                                                                                       CAP070
     FLEIRPRTPD IF   E           K DISK    INFSR(*PSSR)                                       CAP069
      ** LE Risk Participants Details invalid logging file                                    CAP069
     F                                     RENAME(LEIRPRTD0:LEIRPRD0)                         CAP069
      *                                                                                       CAP069
     FLEIFPRTPD IF   E           K DISK    INFSR(*PSSR)                                       CAP068
      ** LE Funding Participants Details invalid logging file                                 CAP068
     F                                     RENAME(LEIFPRTD0:LEIFPRD0)                         CAP068
      *                                                                                       CAP068
     FLEIFAMDPD IF   E           K DISK    INFSR(*PSSR)                                       CAP071
      ** LE Funding Participants Details invalid logging file                                 CAP071
     F                                     RENAME(LEIFAMDD0:LEIFAMD0)                         CAP071
      *                                                                                       CAP071
     FLEIFEADPD IF   E           K DISK    INFSR(*PSSR)                                       CAP072
      ** LE Fee Adjustment Details invalid logging file                                       CAP072
     F                                     RENAME(LEIFEADD0:LEIFEAD0)                         CAP072
      *                                                                                       CAP072
     FLEIFESTPD IF   E           K DISK    INFSR(*PSSR)                                       CAP072
      ** LE Fee Settlement Details invalid logging file                                       CAP072
     F                                     RENAME(LEIFESTD0:LEIFEST0)                         CAP072
      *                                                                                       CAP072
     FLEIFACPD  IF   E           K DISK    INFSR(*PSSR)                                       CSC011
      ** LE Facility Input invalid logging file                                               CSC011
     F                                     RENAME(LEIFACP0:LEIFAC0)                           CSC011
      *                                                                                       CSC011
     FLEILONPD  IF   E           K DISK    INFSR(*PSSR)                                       CSC011
      ** LE Loans/Parts Purchased/Parts Sold Input Invalid logging file                       CSC011
     F                                     RENAME(LEILONP0:LEILON0)                           CSC011
      *                                                                                       CSC011
     FLEILAMPD  IF   E           K DISK    INFSR(*PSSR)                                       CSC011
      ** LE Loan Amendments Invalid logging file                                              CSC011
     F                                     RENAME(LEILAMP0:LEILAM0)                           CSC011
      *                                                                                       CSC011
     FLEIROLPD  IF   E           K DISK    INFSR(*PSSR)                                       CSC011
      ** LE Rollover Invalid logging file                                                     CSC011
     F                                     RENAME(LEIROLP0:LEIROL0)                           CSC011
      *                                                                                       CSC011
     FLEIMRPPD  IF   E           K DISK    INFSR(*PSSR)                                       CSC011
      ** LE Manual Repayment Invalid logging file                                             CSC011
     F                                     RENAME(LEIMRPD0:LEIMRP0)                           CSC011
      *                                                                                       CSC011
     FLEIFEEPD  IF   E           K DISK    INFSR(*PSSR)                                       CSC011
      ** LE Fee Input Invalid logging file                                                    CSC011
     F                                     RENAME(LEIFEEP0:LEIFEE0)                           CSC011
      *                                                                                       CSC011
      ** IR Caps/Collars/Floors invalid logging file                                          CAP055
     FIRICACFPD IF   E           K DISK    INFSR(*PSSR)                                       CAP055
     F                                     PREFIX(IR:2)                                       CAP055
                                                                                              CAP055
     FSEIMVTSPD IF   E           K DISK    INFSR(*PSSR)                                       CSE039
      ** SE Movements Status invalid logging file                                             CSE039
                                                                                              CSE039
     FSEITRSMPD IF   E           K DISK    INFSR(*PSSR)                                       CAP182
     F                                     RENAME(SEITRSMD0:SEITRSM0)                         CAP182
      ** SE Trade Settlement invalid logging file                                             CAP182
                                                                                              CAP182
     FSEISTPRPD IF   E           K DISK    INFSR(*PSSR)                                       CSE040
      ** SE Statement Production Requests invalid logging file                                CSE040
                                                                                              CSE040
     FLEIFCIPPD IF   E           K DISK    INFSR(*PSSR)                                       CAP073
      ** LE Facility Details invalid logging file                                             CAP073
     F                                     RENAME(LEIFCIPD0:LEIFCID0)                         CAP073
      *                                                                                       CAP073
     FLEICLIPPD IF   E           K DISK    INFSR(*PSSR)                                       CAP074
      ** LE Loans Details invalid logging file                                                CAP074
     F                                     RENAME(LEICLIPD0:LEICLID0)                         CAP074
      *                                                                                       CAP074
     FLEILOAMPD IF   E           K DISK    INFSR(*PSSR)                                       CAP075
      ** LE Loan amendment Details invalid logging file                                       CAP075
     F                                     RENAME(LEILOAMD0:LEILOAD0)                         CAP075
      *                                                                                       CAP075
     FLEILERIPD IF   E           K DISK    INFSR(*PSSR)                                       CAP076
      ** LE Rollover Instructions Details invalid logging file                                CAP076
     F                                     RENAME(LEILERID0:LEILERD0)                         CAP076
      *                                                                                       CAP076
     FLEIMAPYPD IF   E           K DISK    INFSR(*PSSR)                                       CAP077
      ** LE Manual payments Details invalid logging file                                      CAP077
     F                                     RENAME(LEIMAPYD0:LEIMAPY0)                         CAP077
      *                                                                                       CAP077
     FLEIFEEMPD IF   E           K DISK    INFSR(*PSSR)                                       CAP078
      ** LE Fee input invalid logging file                                                    CAP078
     F                                     RENAME(LEIFEEMD0:LEIFEEM0)                         CAP078
     F                                     PREFIX(LE)                                         CAP078
      *                                                                                       CAP078
     FLEIRPSCPD IF   E           K DISK    INFSR(*PSSR)                                       CAP079
      ** LE Repayments schedule Details invalid logging file                                  CAP079
     F                                     RENAME(LEIRPSCD0:LEIRPSD0)                         CAP079
      *                                                                                       CAP079
     FDLIDLFEPD IF   E           K DISK    INFSR(*PSSR)                                       CAS009
      ** DL Dealing Fees Invalid File                                                         CAS009
                                                                                              CAS009
     FAPINVLPD  O    E           K DISK    INFSR(*PSSR)
      ** Merged API invalid logging file **
      *
     FSDINAHLPD IF   E           K Disk    Infsr(*PSSR)                                       CGL032
      ** SD Non-A/C Holders Details Invalid logging file                                      CGL032
     F                                     Rename(SDINAHLD0:SDINAHL0)                         CGL032
                                                                                              CGL032
     FSDIJACMPD IF   E           K DISK    INFSR(*PSSR) PREFIX(Q:1)                           CGL032
      ** Midas SD Invalid Joint Account Members                                               CGL032
                                                                                              CGL032
     FSDIACUDPD IF   E           K Disk    INFSR(*PSSR)                                       CGL032
      ** SD Additional Customer Details Invalid logging file                                  CGL032
     F                                     RENAME(SDIACUDD0:SDIACUD0)                         CGL032
      *                                                                                       CGL032
     FSDINATXPD IF   E           K Disk    Infsr(*PSSR)                                       CGL032
      ** SD Non-A/C Holders by Country of Tax Details Invalid logging file                    CGL032
     F                                     Rename(SDINATXD0:SDINATL0)                         CGL032
      *                                                                                       CGL032
     FSDICCTXPD IF   E           K Disk    Infsr(*PSSR)                                       233205
      ** SD Non-A/C Holders by Country of Tax Details Invalid logging file                    233205
     F                                     Rename(SDICCTXD0:SDICCTL0)                         233205
      *                                                                                       233205
     FFFIMPRIPD IF   E           K DISK    INFSR(*PSSR)                                       CAP183
      ** Midas FF Invalid Market Prices                                                       CAP183
      *                                                                                      CER034A
      ** SD Customer/Authority Holder Invalid Details                                        CER034A
      *                                                                                      CER034A
     FSDICUAHPD IF   E             DISK    INFSR(*PSSR)                                      CER034A
      *                                                                                       CAP183
     F/COPY WNCPYSRC,APH00011
     F/COPY WNCPYSRC,APH00022
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *  ----------------------                                       *
      *                                                               *
      *     10 - read indicator for invalid DEAMs                     *
      *     11 - read indicator for invalid LDNIs                     *
      *     12 - read indicator for invalid NASPs                     *
      *     13 - read indicator for invalid NASSs                     *
      *     14 - read indicator for invalid FXDLs                     *
      *     15 - read indicator for invalid FRAs                      *   CAP004
      *     16 - read indicator for invalid SIRSs                     *   CAP004
      *     17 - read indicator for invalid CIRSs                     *   CAP004
      *     18 - read indicator for invalid DPMVs                     *   CAP004
      *     19 - read indicator for invalid TRADs                     *   CAP004
      *     20 - read indicator for invalid INTCs                     *   CAP004
      *     21 - read indicator for invalid EXTRs                     *   CAP004
      *     22 - read indicator for invalid OTCCs                     *   CAP004
      *     23 - read indicator for invalid OPAYs                     *   CAP031
      *     24 - read indicator for invalid CUSDs                     *   CAP034
      *     25 - read indicator for invalid AMADs                     *   CAP035
      *     26 - read indicator for invalid PFDMs                     *   CAP033
      *     27 - read indicator for invalid IPAYs                     *         CAP136
      *     28 - read indicator for invalid SECSs                     *   CAP137
      *     29 - read indicator for invalid SECDs                     *   CAP039
      *     30 - read indicator for invalid SEDEs                     *                       CAP140
      *     31 - read indicator for invalid INTRs                     *         CAP058
      *     32 - read indicator for invalid BSRTs                     *         CAP038
      *     33 - read indicator for invalid SPTRs                     *         CAP057
      *     34 - read indicator for invalid PRCSs                     *         CAP060
      *     35 - read indicator for invalid FUNDs                     *                       CAP042
      *     36 - read indicator for invalid FWRTs                     *         CAP059
      *     37 - read indicator for invalid REPOs                     *                       CAP067
      *     38 - read indicator for invalid BYSLs                     *                       CAP067
      *     39 - read indicator for invalid YRATs                     *                       CAS001
      *     40 - read indicator for invalid OTCOs                     *                       CAP166
      *     41 - read indicator for invalid FEADs                     *                       CAP072
      *     42 - read indicator for invalid FESTs                     *                       CAP072
      ******43*-*read*indicator*for*invalid*ASGNs                     *                CAP070 CAP073
      *     43 - read indicator for invalid ASGNs, FCIPs              *                       CAP073
      ******44*-*read*indicator*for*invalid*RPRTs                     *                CAP069 CAP074
      *     44 - read indicator for invalid RPRTs, CLIPs              *                       CAP074
      ******45*-*read*indicator*for*invalid*FPRTs                     *                CAP068 CAP076
      *     45 - read indicator for invalid FPRTs, LERIs              *                       CAP076
      ******46*-*read*indicator*for*invalid*FAMDs                     *                CAP071 CAP075
      *     46 - read indicator for invalid FAMDs, LOAMs              *                       CAP075
      ******47*-*read*indicator*for*invalid*FCTYs                     *                CSC011 CAP079
      *     47 - read indicator for invalid FCTYs, RPSCs              *                       CAP079
      ******48*-*read*indicator*for*invalid*LOANs,*PTPUs*PTSOs        *                CSC011 CAP077
      *     48 - read indicator for invalid LOANs, PTPUs, PTSOs,      *                       CAP077
      *          MAPYs                                                *                       CAP077
      ******49*-*read*indicator*for*invalid*LAPTs,*LAPFs,*LAPFs,*LAPIs*                CSC011 CAP078
      ***********LABCs,*LASCs,*LASAs,*LALALS.                         *                CSC011 CAP078
      *     49 - read indicator for invalid LAPTs, LAPFs, LAPFs,      *                       CAP078
      *          LAPIs, LABCs, LASCs, LASAs, LALAs, FEEMs             *                       CAP078
      *     50 - read indicator for invalid ROLLs,                    *                       CSC011
      *     51 - read indicator for invalid LAMRs,                    *                       CSC011
      *     52 - read indicator for invalid FEESs,                    *                       CSC011
      *     53 - read indicator for invalid CACFs                     *                       CAP055
      *     54 - read indicator for invalid NAHLs                     *                       CGL032
      *     55 - read indicator for invalid NATXs                     *                       CGL032
      *     56 - read indicator for invalid ACUDs                     *                       CGL032
      *     58 - read indicator for invalid MPRIs                     *                       CAP183
      *                                                               *
      *  U7+U8 - Database error occurs                                *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *                                                                   CAP035
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      *
      ** External DS for SAR Details                                                          CAS001
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS001
                                                                                              CAS001
      ** First DS for Access Programs, Short Data Structure                                   CAS001
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CAS001
                                                                                              CAS001
     D PSDS           SDS
      ** Program Status Data Structure
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D                 DS
     D  AYRS                   1      4
     D  AMON                   6      7
     D  ADAY                   9     10
     D  AHRS                  12     13
     D  AMIN                  15     16
     D  ASEC                  18     19
     D  AMSC                  21     26
     D  ATMST                  1     26
      *
     D                 DS
     D  BYRS                   1      4
     D  BMON                   5      6
     D  BDAY                   7      8
     D  BHRS                   9     10
     D  BMIN                  11     12
     D  BSEC                  13     14
     D  BMSC                  15     20
     D  BTMST                  1     20  0
      *
     D                 DS                                                                     CAP035
     D  PDBRCA                 1      3                                                       CAP035
     D  PDCNUM                 4      9                                                       CAP035
     D  PDCCY                 10     12                                                       CAP035
     D***PDACOD                13     16                                               CAP035 CGL029
     D***PDACSQ                17     18                                               CAP035 CGL029
     D***PDACCN                 1     18                                               CAP035 CGL029
     D  PDACOD                13     22                                                       CGL029
     D  PDACSQ                23     24                                                       CGL029
     D  PDACCN                 1     24                                                       CGL029
      *                                                                                       CAP140
     D WAPTRAN         DS            18                                                       CAP140
     D  WSDSN                  1     10                                                       CAP140
     D  WSDED                 11     16                                                       CAP140
     D  WSDET                 17     18                                                       CAP140
      *                                                                                       CAP182
     D WWAPTRAN        DS            14                                                       CAP182
     D  WTRDR                  1      6                                                       CAP182
     D  WMVDT                  7     12                                                       CAP182
     D  WFSET                 13     13                                                       CAP182
     D  WREVE                 14     14                                                       CAP182
                                                                                              CAS001
      ** Work variable used by CAS001                                                         CAS001
     D PRtCd           S              7A                                                      CAS001
     D POptn           S              7A                                                      CAS001
     D PSarD           S              6A                                                      CAS001
     D CAS001          S              1A                                                      CAS001
                                                                                              CAS009
     D CAS009          S              1A                                                      CAS009
                                                                                              CGL032
      ** Switchable Features                                                                  CGL032
     D CGL032          S              1A   INZ('N')                                           CGL032
                                                                                              CGL032
      ** Switchable Features                                                                  CAP183
     D CAP183          S              1A   INZ('N')                                           CAP183
     D CGL132          S              1A                                                      CGL132
     D CGL133          S              1A                                                      CGL133
      *
     D RMRLOC          S              1A                                                     CER034A
      *
     D/COPY WNCPYSRC,APH00012
     D/COPY WNCPYSRC,APH00023
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     IMMIDEAM0
     I              DDFOTRANID                  ADFOTR
     I              DDFOASOCID                  ADFOAS
     I              DDRPRLOCN                   ADRPRL
     I              DDTMESTMP                   ADTMES
     I              DDAMNP                      DDAM15
     IMMILDNI0
     I              DDFOTRANID                  BDFOTR
     I              DDFOASOCID                  BDFOAS
     I              DDRPRLOCN                   BDRPRL
     I              DDTMESTMP                   BDTMES
     I              DDLQPR                      @@LQPR                                        CAS005
     I              DDISDT                      @DDISDT                                       CER048
     IMMINASP0
     I              FRONTOFFID                  CFRONT
     I              ASSOCFOID                   CASSOC
     I              REPAIRLOC                   CREPAI
     I              DDTMESTMP                   CDTMES
     I              DDAMNP                      CDAM15
     I              DDLQPR                      P@LQPR                                        CAS005
     IMMINASS0
     I              FRONTOFFID                  DFRONT
     I              ASSOCFOID                   DASSOC
     I              REPAIRLOC                   DREPAI
     I              DDTMESTMP                   DDTMES
     I              DDBRKG                      DDBR22                          CSD006
     I              DDAMNP                      DDAM15
     IFXIFXDL0
     I              DDFOTRANID                  EDFOTR
     I              DDFOASOCID                  EDFOAS
     I              DDRPRLOCN                   EDRPRL
     I              DDTMESTMP                   EDTMES
     IIRIFRAD0                                                                  CAP004
     I              SFOTRANID                   FSFOTR                          CAP004
     I              SFOASOCID                   FSFOAS                          CAP004
     I              SRPRLOCN                    FSRPRL                          CAP004
     I              STMESTMP                    FSTMES                          CAP004
     IIRISIRS0                                                                  CAP004
     I              SFOTRANID                   GSFOTR                          CAP004
     I              SFOASOCID                   GSFOAS                          CAP004
     I              SRPRLOCN                    GSRPRL                          CAP004
     I              STMESTMP                    GSTMES                          CAP004
     I              SFACT                       GSFACT                                        CLE025
     I              SFCNO                       GSFCNO                                        CLE025
     IIRICIRS0                                                                  CAP004
     I              SFOTRANID                   HSFOTR                          CAP004
     I              SFOASOCID                   HSFOAS                          CAP004
     I              SRPRLOCN                    HSRPRL                          CAP004
     I              STMESTMP                    HSTMES                          CAP004
     I              SFACT                       HSFACT                                        CLE025
     I              SFCNO                       HSFCNO                                        CLE025
     ISEIDPMV0                                                                  CAP004
     I              FOFFID                      IFOFFI                          CAP004
     I              RPRLOC                      IRPRLO                          CAP004
     I              DDTSTMP                     IDDTST                          CAP004
     I              DDDEPOT                     IDEPOT                          CAP004
     I              DDDPNR2                     IDPNR2                          CSE017
     I              DDDPNR3                     IDPNR3                          CSE017
     I              DDDPNR4                     IDPNR4                          CSE017
     I              DDDPNR5                     IDPNR5                          CSE017
     I              DDOPIN                      IDOPIN                                        CGL032
     ISEITRAD0                                                                  CAP004
     I              DDACTN                      JDACTN                          CAP004
     I              DDFOTRANID                  JDFOTR                          CAP004
     I              DDFOASOCID                  JDFOAS                          CAP004
     I              DDRPRLOCN                   JDRPRL                          CAP004
     I              DDTMESTMP                   JDTMES                          CAP004
     I              DDCLTY2                     JCLTY2                          CAP004
     I              ADDGMES                     JAGMES                          CAP004
     I              ADDTRTT                     JATRTT                          CAP004
     I              ADDINST                     JAINST                          CAP004
     I              ADDINSS                     JAINSS                          CAP004
     I              ADDEUCL                     JAEUCL                          CAP004
     I              ADDSAFA                     JASAFA                          CAP004
     I              ADDRPTY                     JARPTY                          CAP004
     I              ADDGDEL                     JAGDEL                          CAP004
     I              ADDSROL                     JASROL                          CAP004
     I              ADDFCOD                     JAFCOD                          CAP004
     I              ADDFTID                     JAFTID                          CAP004
     I              ADDGMEC                     JAGMEC                          CAP004
     I              ADDCCID                     JACCID                          CAP004
     I              ADDFID1                     JAFID1                          CAP004
     I              BDDGMES                     JBGMES                          CAP004
     I              BDDTRTT                     JBTRTT                          CAP004
     I              BDDINST                     JBINST                          CAP004
     I              BDDINSS                     JBINSS                          CAP004
     I              BDDEUCL                     JBEUCL                          CAP004
     I              BDDSAFA                     JBSAFA                          CAP004
     I              BDDRPTY                     JBRPTY                          CAP004
     I              BDDGDEL                     JBGDEL                          CAP004
     I              BDDSROL                     JBSROL                          CAP004
     I              BDDFCOD                     JBFCOD                          CAP004
     I              BDDFTID                     JBFTID                          CAP004
     I              BDDGMEC                     JBGMEC                          CAP004
     I              BDDCCID                     JBCCID                          CAP004
     I              BDDFID1                     JBFID1                          CAP004
     I              DDLQPR                      T@LQPR                                        CAS006
     IABIINTC0                                                                  CAP004
     I              DDACTN                      KDACTN                          CAP004
     I              DDFOTRANID                  KDFOTR                          CAP004
     I              DDFOASOCID                  KDFOAS                          CAP004
     I              DDRPRLOCN                   KDRPRL                          CAP004
     I              DDTMESTMP                   KDTMES                          CAP004
     IFFIEXTR0                                                                  CAP004
     I              SACTN                       LDACTN                          CAP004
     I              SEFOTRANID                  LDFOTR                          CAP004
     I              SEASOCFOID                  LDFOAS                          CAP004
     I              SERPRLOC                    LDRPRL                          CAP004
     I              SETMESTMP                   LDTMES                          CAP004
     IFFIOTCC0                                                                  CAP004
     I              SACTN                       MDACTN                          CAP004
     I              SOFOTRANID                  MDFOTR                          CAP004
     I              SOASOCFOID                  MDFOAS                          CAP004
     I              SORPRLOC                    MDRPRL                          CAP004
     I              SOTMESTMP                   MDTMES                          CAP004
      *
     IFTIOPAY0                                                                  CAP031
     I              SACTION                     NDACTN                          CAP031
     I              SFOTRANID                   NDFOTR                          CAP031
     I              SRPRLOCN                    NDRPRL                          CAP031
     I              STMESTMP                    NDTMES                          CAP031
      *
     ISDICUSD0                                                                  CAP034
     I              DDACTN                      ODACTN                          CAP034
     I              DDCUSN                      ODCUSN                          CAP034
     I              DDFOTRANID                  ODFOTR                          CAP034
     I              DDFOASOCID                  ODFOAS                          CAP034
     I              DDRPRLOCN                   ODRPRL                          CAP034
     I              DDTMESTMP                   ODTMES                          CAP034
      *
     IGLIAMAD0                                                                  CAP035
     I              DDACTN                      PDACTN                          CAP035
     I              DDBRCA                      PDBRCA                          CAP035
     I              DDCUSN                      PDCNUM                          CAP035
     I              DDCCY                       PDCCY                           CAP035
     I              DDACOD                      PDACOD                          CAP035
     I              DDACSQ                      PDACSQ                          CAP035
     I              DDAODRX                     PDAODR                          CAP035
     I              DDBRTCA                     PDABRC                          CAP035
     I              DDFOTRANID                  PDFOTR                          CAP035
     I              DDFOASOCID                  PDFOAS                          CAP035
     I              DDRPRLOCN                   PDRPRL                          CAP035
     I              DDTMESTMP                   PDTMES                          CAP035
     IPMIPFDM0                                                                  CAP033
     I              DDFRNT                      PMFOTR                          CAP033
     I              DDAFRT                      PMFOAS                          CAP033
     I              DDREPA                      PMRPRL                          CAP033
     I              DDTMESTMP                   PMTMES                          CAP033
      *                                                                         CAP136
     IFTIIPAY0                                                                  CAP136
     I              DDPREF                      FTPREF                          CAP136
     I              DDRATE                      FTRATE                          CAP136
     I              DDNWRK                      FTNWRK                          CER059
      *
     ISDISECD0                                                                  CAP039
     I              DDACTN                      QDACTN                          CAP039
     I              DDCUSN                      QDCUSN                          CAP039
     I              DDFOTRANID                  QDFOTR                          CAP039
     I              DDFOASOCID                  QDFOAS                          CAP039
     I              DDRPRLOCN                   QDRPRL                          CAP039
     I              DDTMESTMP                   QDTMES                          CAP039
     I              DDADCD                      QDADCD                          CAP039
     I              DDTXCD                      QDTXCD                          CAP039
     I              DDCLAS                      QDCLAS                          CDL038
      *
     IABIFUND0                                                                                CAP042
     I              #1TMST                      RDTMST                                        CAP042
     I              #1FRNT                      RDFRNT                                        CAP042
     I              #1AFRT                      RDAFRT                                        CAP042
     I              #1REPA                      RDREPA                                        CAP042
     I              #1DLNO                      RDDLNO                                        CAP042
     I              #1ACTN                      RDACTN                                        CAP042
     I              #1AMNP                      RDAMNP                                        CAP042
     I              #1TOTI                      RDTOTI                                        CAP042
     IFDIFWRD0                                                                  CAP059
     I              DDACTN                      RDACTN                          CAP059
     I              DDCCY                       RDCCY                           CAP059
     I              DDFOTRANID                  RDFOTR                          CAP059
     I              DDFOASOCID                  RDFOAS                          CAP059
     I              DDRPRLOCN                   RDRPRL                          CAP059
     I              DDTMESTMP                   RDTMES                          CAP059
      *                                                                         CAP059
     IFDIINTD0                                                                  CAP058
     I              DDACTN                      SDACTN                          CAP058
     I              DDCCY                       SDCCY                           CAP058
     I              DDFOTRANID                  SDFOTR                          CAP058
     I              DDFOASOCID                  SDFOAS                          CAP058
     I              DDRPRLOCN                   SDRPRL                          CAP058
     I              DDTMESTMP                   SDTMES                          CAP058
      *                                                                         CAP058
     I*SDIBSRD0*****                                                                   CAP038 CPK016
     IFDIBSRD0                                                                                CPK016
     I              DDACTN                      TDACTN                          CAP038
     I              DDCYCD                      TDCYCD                          CAP038
     I              DDFOTRANID                  TDFOTR                          CAP038
     I**************DDFOASOCID                  TDFOAS                                 CAP038 CPK016
     I              DDRPRLOCN                   TDRPRL                          CAP038
     I              DDTMESTMP                   TDTMES                          CAP038
      *                                                                         CAP038
     ISDISPTD0                                                                  CAP057
     I              DDACTN                      UDACTN                          CAP057
     I              DDCYCD                      UDCYCD                          CAP057
     I              DDSPRT                      UDSPRT                          CAP057
     I              DDFOTRANID                  UDFOTR                          CAP057
     I              DDRPRLOCN                   UDRPRL                          CAP057
     I              DDTMESTMP                   UDTMES                          CAP057
      *                                                                         CAP057
     ISEIPRCD0                                                                  CAP060
     I              DDACTN                      VDACTN                          CAP060
     I              DDPSSN                      VDPSSN                          CAP060
     I              DDFOTRANID                  VDFOTR                          CAP060
     I              DDFOASOCID                  VDFOAS                          CAP060
     I              DDRPRLOCN                   VDRPRL                          CAP060
     I              DDTMESTMP                   VDTMES                          CAP060
      *                                                                         CAP060
     IMMIRPLD0                                                                                CAP067
     I              DDACTN                      WDACTN                                        CAP067
     I              DDDLNO                      WDDLNO                                        CAP067
     I              DDFOTRANID                  WDFOTR                                        CAP067
     I              DDFOASOCID                  WDFOAS                                        CAP067
     I              DDRPRLOCN                   WDRPRL                                        CAP067
     I              DDTMESTMP                   WDTMES                                        CAP067
      *                                                                                       CAP067
     ISEIBYSD0                                                                                CAP067
     I              DDACTN                      WWDACTN                                       CAP067
     I              DDTRTP                      WWDTRTP                                       CAP067
     I              DDFOTRANID                  WWDFOTR                                       CAP067
     I              DDFOASOCID                  WWDFOAS                                       CAP067
     I              DDRPRLOCN                   WWDRPRL                                       CAP067
     I              DDTMESTMP                   WWDTMES                                       CAP067
      *                                                                                       CAP067
     IFFIOTCO0                                                                                CAP166
     I              NACTN                       XDACTN                                        CAP166
     I              NTNBR                       XSTNBR                                        CAP166
     I              SOFOTRANID                  XDFOTR                                        CAP166
     I              SOASOCFOID                  XDFOAS                                        CAP166
     I              SORPRLOC                    XDRPRL                                        CAP166
     I              SOTMESTMP                   XDTMES                                        CAP166
      *                                                                                       CAP166
     ISEISECS0                                                                                CSE031
     I              DDBR01                      ZDDBR01                                       CSE031
     I              DDBR02                      ZDDBR02                                       CSE031
     I              DDBR03                      ZDDBR03                                       CSE031
     I              DDBR04                      ZDDBR04                                       CSE031
     I              DDBR05                      ZDDBR05                                       CSE031
     I              DDBR06                      ZDDBR06                                       CSE031
     I              DDBR07                      ZDDBR07                                       CSE031
     I              DDBR08                      ZDDBR08                                       CSE031
     I              DDBR09                      ZDDBR09                                       CSE031
     I              DDBR10                      ZDDBR10                                       CSE031
      *                                                                                       CSE031
     ILEIASGD0                                                                                CAP070
     I              S#ACTN                      WDACTN                                        CAP070
     I              DDFRNT                      WDFOTR                                        CAP070
     I              DDAFRT                      WDFOAS                                        CAP070
     I              DDREPA                      WDRPRL                                        CAP070
     I              XTMST                       WDTMES                                        CAP070
      *                                                                                       CAP070
     ILEIRPRD0                                                                                CAP069
     I              S#ACTN                      WRACTN                                        CAP069
     I              DDFRNT                      WRFOTR                                        CAP069
     I              DDAFRT                      WRFOAS                                        CAP069
     I              DDREPA                      WRRPRL                                        CAP069
     I              XTMST                       WRTMES                                        CAP069
      *                                                                                       CAP069
     ILEIFPRD0                                                                                CAP068
     I              S#ACTN                      WPACTN                                        CAP068
     I              DDFRNT                      WPFOTR                                        CAP068
     I              DDAFRT                      WPFOAS                                        CAP068
     I              DDREPA                      WPRPRL                                        CAP068
     I              XTMST                       WPTMES                                        CAP068
      *                                                                                       CAP068
     ILEIFAMD0                                                                                CAP071
     I              S#ACTN                      WFACTN                                        CAP071
     I              S#FRNT                      WFFOTR                                        CAP071
     I              S#AFRT                      WFFOAS                                        CAP071
     I              S#REPA                      WFRPRL                                        CAP071
     I              XTMST                       WFTMES                                        CAP071
      *                                                                                       CAP071
     ILEIFEAD0                                                                                CAP072
     I              S#ACTN                      WAACTN                                        CAP072
     I              DDFRNT                      WAFOTR                                        CAP072
     I              DDAFRT                      WAFOAS                                        CAP072
     I              DDREPA                      WARPRL                                        CAP072
     I              XTMST                       WATMES                                        CAP072
      *                                                                                       CAP072
     ILEIFEST0                                                                                CAP072
     I              S#ACTN                      WSACTN                                        CAP072
     I              DDFRNT                      WSFOTR                                        CAP072
     I              DDAFRT                      WSFOAS                                        CAP072
     I              DDREPA                      WSRPRL                                        CAP072
     I              XTMST                       WSTMES                                        CAP072
      *                                                                                       CAP072
      *                                                                                       CSC011
     ILEIFAC0                                                                                 CSC011
     I              SACTN                       TYACTN                                        CSC011
     I              XREPN                       TYREPN                                        CSC011
     I              XMSID                       TYMSID                                        CSC011
     I              STNRF                       TYTNRF                                        CSC011
     I              STMST                       TYTMES                                        CSC011
      *                                                                                       CSC011
     ILEILON0                                                                                 CSC011
     I              SACTN                       LOACTN                                        CSC011
     I              XREPN                       LOREPN                                        CSC011
     I              XMSID                       LOMSID                                        CSC011
     I              STNRF                       LOTNRF                                        CSC011
     I              STMST                       LOTMES                                        CSC011
      *                                                                                       CSC011
     ILEILAM0                                                                                 CSC011
     I              SACTN                       LAACTN                                        CSC011
     I              XREPN                       LAREPN                                        CSC011
     I              XMSID                       LAMSID                                        CSC011
     I              STNRF                       LATNRF                                        CSC011
     I              STMST                       LATMES                                        CSC011
      *                                                                                       CSC011
     ILEIROL0                                                                                 CSC011
     I              SACTN                       ROACTN                                        CSC011
     I              XREPN                       ROREPN                                        CSC011
     I              XMSID                       ROMSID                                        CSC011
     I              STNRF                       ROTNRF                                        CSC011
     I              STMST                       ROTMES                                        CSC011
     I              SCNUM                       ROCNUM                                        CSC011
      *                                                                                       CSC011
     ILEIMRP0                                                                                 CSC011
     I              SLSEL                       MRACTN                                        CSC011
     I              XREPN                       MRREPN                                        CSC011
     I              XMSID                       MRMSID                                        CSC011
     I              STNRF                       MRTNRF                                        CSC011
     I              STMST                       MRTMES                                        CSC011
      *                                                                                       CSC011
     ILEIFEE0                                                                                 CSC011
     I              SFLCHT                      FEACTN                                        CSC011
     I              XREPN                       FEREPN                                        CSC011
     I              XMSID                       FEMSID                                        CSC011
     I              STNRF                       FETNRF                                        CSC011
     I              STMST                       FETMES                                        CSC011
      *                                                                                       CSE039
     ISEIMVTSD0                                                                               CSE039
     I              DDNARR                      MVTS_NARR                                     CSE039
      *                                                                                       CAP182
     ISEITRSM0                                                                                CAP182
     I              DDTDFA                      TRSM_TDFA                                     CAP182
     I              DDSREF                      TRSM_SREF                                     CAP182
      *                                                                                       CSE040
     ISEISTPRD0                                                                               CSE040
     I              DDCUST                      STPR_CUST                                     CSE040
      *
     ILEIFCID0                                                                                CAP073
     I              DDACTN                      WQACTN                                        CAP073
     I              DDFOTRANID                  WQFOTR                                        CAP073
     I              DDFOASOCID                  WQFOAS                                        CAP073
     I              DDRPRLOCN                   WQRPRL                                        CAP073
     I              DDTMESTMP                   WQTMES                                        CAP073
     I              DDCRSK                      WQCRSK                                        CAP073
      *                                                                                       CAP074
     ILEICLID0                                                                                CAP074
     I              DDACTN                      WQACTN                                        CAP074
     I              DDFOTRANID                  WQFOTR                                        CAP074
     I              DDFOASOCID                  WQFOAS                                        CAP074
     I              DDRPRLOCN                   WQRPRL                                        CAP074
     I              DDTMESTMP                   WQTMES                                        CAP074
     I              DDPTFN                      WQPTFN                                        CAP074
     I              DDPTFT                      WQPTFT                                        CAP074
     I              DDBCXR                      WQBCXR                                        CAP074
     I              DDRAMT                      WQRAMT                                        CAP074
     I              DDCRSK                      WQCRSK                                        CAP074
     I              DDISDT                      @DDISDT                                       CER048
      *                                                                                       CAP074
     ILEILOAD0                                                                                CAP075
     I              DDACTN                      WRACTN                                        CAP075
     I              DDFRNT                      WRFRNT                                        CAP075
     I              DDAFRT                      WRAFRT                                        CAP075
     I              DDREPR                      WRREPR                                        CAP075
     I              DDSTMP                      WRSTMP                                        CAP075
     I              DDCNUM                      WRCNUM                                        CAP075
     I              DDBRAT                      WRBRAT                                        CAP075
      *                                                                                       CAP075
     ILEILERD0                                                                                CAP076
     I              DDACTN                      WLACTN                                        CAP076
     I              DDFOTRANID                  WLFOTR                                        CAP076
     I              DDFOASOCID                  WLFOAS                                        CAP076
     I              DDRPRLOCN                   WLRPRL                                        CAP076
     I              DDTMESTMP                   WLTMES                                        CAP076
      *                                                                                       CAP076
     ILEIRPSD0                                                                                CAP079
     I              DDACTN                      WLACTN                                        CAP079
     I              DDFOTRANID                  WLFOTR                                        CAP079
     I              DDFOASOCID                  WLFOAS                                        CAP079
     I              DDRPRLOCN                   WLRPRL                                        CAP079
     I              DDTMESTMP                   WLTMES                                        CAP079
      *                                                                                       CAP079
     IDLIDLFED0                                                                               CAS009
     I              DDCUST                      DFCUST                                        CAS009
     I              DDFAMT                      DFFAMT                                        CAS011
     ISDIACUD0                                                                                CGL032
     I              DDACTN                      QDACTN                                        CGL032
     I              DDCUST                      QDCUST                                        CGL032
     I              DDFRNT                      QDFRNT                                        CGL032
     I              DDREPA                      QDREPA                                        CGL032
     I              DDTMST                      QDTMST                                        CGL032
     I              DDCNA1                      QDCNA1                                        CGL032
     I              DDCNA2                      QDCNA2                                        CGL032
     I              DDISDT                      QDISDT                                       CER034A
      *                                                                                       CGL032
     ISDINAHL0                                                                                CGL032
     I              DDACTN                      QDACTN                                        CGL032
     I              DDNAHO                      QDNAHO                                        CGL032
     I              DDFRNT                      QDFRNT                                        CGL032
     I              DDREPA                      QDREPA                                        CGL032
     I              DDTMST                      QDTMST                                        CGL032
     I              DDISDT                      QDISDT                                       CER034A
     I              DDMDNM                      @DDMDNM                                       CER048
     I              DDSREF                      @DDSREF                                       CER048
      *                                                                                       CGL032
     ISDINATL0                                                                                CGL032
     I              DDACTN                      QDACTN                                        CGL032
     I              DDNAHO                      QDNAHO                                        CGL032
     I              DDFRNT                      QDFRNT                                        CGL032
     I              DDREPA                      QDREPA                                        CGL032
     I              DDTMST                      QDTMST                                        CGL032
      *                                                                                       CGL032
     ISDICCTL0                                                                                233205
     I              DDACTN                      QDACTN                                        233205
     I              DDCUST                      QDCUST                                        233205
     I              DDFRNT                      QDFRNT                                        233205
     I              DDREPA                      QDREPA                                        233205
     I              DDTMST                      QDTMST                                        233205
     ISDICUAHD0                                                                              CER034A
     I              DDACTN                      RMACTN                                       CER034A
     I              DDCUST                      RMCUST                                       CER034A
     I              DDFRNT                      RMFRNT                                       CER034A
     I              DDREPA                      RMRLOC                                       CER034A
     I              DDTMST                      RMTMST                                       CER034A
                                                                                              233205
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Initial processing
     C                   EXSR      INIT
      *
      ** Main processing
     C                   EXSR      MAIN
      *
      ** End processing
     C                   EXSR      END
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - Main Processing                                        *
      *                                                               *
      * Called by: C.MOD                                              *
      * Calls:     ZDATE2, *PSSR                                      *
      *****************************************************************
     C     MAIN          BEGSR
      *
      * Extract invalid transactions from the
      *
     C                   EXSR      IDEAM
     C                   EXSR      ILDNI
     C                   EXSR      INASP
     C                   EXSR      INASS
     C                   EXSR      IFXDL
     C                   EXSR      IFRA                                                        CAP00
     C                   EXSR      ISIRS                                                       CAP00
     C                   EXSR      ICIRS                                                       CAP00
     C                   EXSR      IDPMV                                                       CAP00
     C                   EXSR      ITRAD                                                       CAP00
     C                   EXSR      IINTC                                                       CAP00
     C                   EXSR      IEXTR                                                       CAP00
     C                   EXSR      IOTCC                                                       CAP00
     C                   EXSR      IOPAY                                                       CAP03
     C                   EXSR      ICUSD                                                       CAP03
     C                   EXSR      IAMAD                                                       CAP03
     C                   EXSR      IPFDM                                                       CAP00
     C                   EXSR      IIPAY                                        CAP136
     C                   EXSR      ISECS                                        CAP137
     C                   EXSR      ISECD                                                      CAP039
     C                   EXSR      ISEDE                                                      CAP140
     C                   EXSR      IFWRT                                        CAP059
     C                   EXSR      IINTR                                        CAP058
     C                   EXSR      IBSRT                                        CAP038
     C                   EXSR      ISPTR                                        CAP057
     C                   EXSR      IPRCS                                        CAP060
     C                   EXSR      IFUND                                                      CAP042
     C                   EXSR      IREPO                                                      CAP067
     C                   EXSR      IBYSL                                                      CAP067
     C                   EXSR      IOTCO                                                      CAP166
                                                                                              CAS001
     C                   IF        CAS001 = 'Y'                                               CAS001
     C                   EXSR      SRYRAT                                                     CAS001
     C                   ENDIF                                                                CAS001
      *                                                                                       CAS001
     C                   EXSR      IASGN                                                      CAP070
     C                   EXSR      IRPRT                                                      CAP069
     C                   EXSR      IFPRT                                                      CAP068
     C                   EXSR      IFAMD                                                      CAP071
     C                   EXSR      IFEAD                                                      CAP072
     C                   EXSR      IFEST                                                      CAP072
     C                   EXSR      IFCTY                                                      CSC011
     C                   EXSR      ILOAN                                                      CSC011
     C                   EXSR      ILOAM                                                      CSC011
     C                   EXSR      IROLL                                                      CSC011
     C                   EXSR      ILAMR                                                      CSC011
     C                   EXSR      IFEES                                                      CSC011
     C                   EXSR      SRCACF                                                     CAP055
     C                   EXSR      IMVTS                                                      CSE039
     C                   EXSR      ITRSM                                                      CAP182
     C                   EXSR      ISTPR                                                      CSE040
     C                   EXSR      IFUND                                                      CAP042
     C                   EXSR      IFCIP                                                      CAP073
     C                   EXSR      ICLIP                                                      CAP074
     C                   EXSR      ILAMN                                                      CAP075
     C                   EXSR      ILERI                                                      CAP076
     C                   EXSR      IMAPY                                                      CAP077
     C                   EXSR      IFEEM                                                      CAP078
     C                   EXSR      IRPSC                                                      CAP079
     C                   EXSR      SRICuAh                                                   CER034A
                                                                                              CAS009
     C                   IF        CAS009 = 'Y'                                               CAS009
     C                   EXSR      SRDLFE                                                     CAS009
     C                   ENDIF                                                                CAS009
     C                   IF        CGL032 = 'Y'                                               CGL032
     C                             or CGL132 = 'Y'                                            CGL132
     C                             or CGL133 = 'Y'                                            CGL133
     C                   EXSR      IACUD                                                      CGL032
     C                   Exsr      INAHL                                                      CGL032
     C                   EXSR      INATX                                                      CGL032
     C                   EXSR      SRIJAcM                                                    CGL032
     C                   EXSR      SRICCTX                                                    233205
     C                   ENDIF                                                                CGL032
     C                   IF        CAP183 = 'Y'                                               CAP183
     C                   EXSR      IMPRI                                                      CAP183
     C                   ENDIF                                                                CAP183
 
     C/COPY WNCPYSRC,APH00013
     C/COPY WNCPYSRC,APH00024
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IDEAM - Deal amendments                                       *
      *                                                               *
      * Called by: MAIN                                               *
      * Calls: None                                                   *
      *****************************************************************
     C     IDEAM         BEGSR
      *
      ** Do first read before main loop
     C**********         READ      MMIDEAMP                               10                  CAP033
     C                   READ      MMIDEAMPD                              10                  CAP033
      *
      ** Loop while records read
     C     *IN10         DOWEQ     '0'
      *
      * Set output fields
      *
     C                   MOVE      ADTMES        ATMST
     C                   MOVE      AYRS          BYRS
     C                   MOVE      AMON          BMON
     C                   MOVE      ADAY          BDAY
     C                   MOVE      AHRS          BHRS
     C                   MOVE      AMIN          BMIN
     C                   MOVE      ASEC          BSEC
     C                   MOVE      AMSC          BMSC
     C                   MOVE      BTMST         APTMSS
      *
     C                   MOVE      ADTMES        APTMES
     C                   MOVEL     ADFOTR        APFOTR
     C                   MOVEL     ADFOAS        APFOAS
     C                   MOVEL     ADRPRL        APRPRL
     C                   MOVEL     'DL'          APMIDA
     C*************      MOVE      DDDLNO        APDLNO                   CAP033
     C                   MOVEL     DDDLNO        APTRAN                         CAP033
     C                   MOVE      DDACTN        APACTN
      *
      ** Write details
     C                   WRITE     APINVLD0
      *
      ** Read next record and loop back
     C**********         READ      MMIDEAMP                               10                  CAP033
     C                   READ      MMIDEAMPD                              10                  CAP033
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ILDNI - Loan/deposit processing                               *
      *                                                               *
      * Called by: MAIN                                               *
      * Calls: None                                                   *
      *****************************************************************
     C     ILDNI         BEGSR
      *
      ** Do first read before main loop
     C**********         READ      MMILDNIP                               11                  CAP033
     C                   READ      MMILDNIPD                              11                  CAP033
      *
      ** Loop while records read
     C     *IN11         DOWEQ     '0'
      *
      * Set output fields
      *
     C                   MOVE      BDTMES        ATMST
     C                   MOVE      AYRS          BYRS
     C                   MOVE      AMON          BMON
     C                   MOVE      ADAY          BDAY
     C                   MOVE      AHRS          BHRS
     C                   MOVE      AMIN          BMIN
     C                   MOVE      ASEC          BSEC
     C                   MOVE      AMSC          BMSC
     C                   MOVE      BTMST         APTMSS
      *
     C                   MOVE      BDTMES        APTMES
     C                   MOVEL     BDFOTR        APFOTR
     C                   MOVEL     BDFOAS        APFOAS
     C                   MOVEL     BDRPRL        APRPRL
     C                   MOVEL     'DL'          APMIDA
     C***********          MOVE DDDLNO    APDLNO                          CAP033
     C                   MOVEL     DDDLNO        APTRAN                                       CAP033
     C                   MOVE      DDACTN        APACTN
      *
      ** Write details
     C                   WRITE     APINVLD0
      *
      ** Read next record and loop back
     C**********         READ      MMILDNIP                               11                  CAP033
     C                   READ      MMILDNIPD                              11                  CAP033
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INASP - Negotiable assets purchased                           *
      *                                                               *
      * Called by: MAIN                                               *
      * Calls: None                                                   *
      *****************************************************************
     C     INASP         BEGSR
      *
      ** Do first read before main loop
     C**********         READ      MMINASPP                               12                  CAP033
     C                   READ      MMINASPPD                              12                  CAP033
      *
      ** Loop while records read
     C     *IN12         DOWEQ     '0'
      *
      * Set output fields
      *
     C                   MOVE      CDTMES        ATMST
     C                   MOVE      AYRS          BYRS
     C                   MOVE      AMON          BMON
     C                   MOVE      ADAY          BDAY
     C                   MOVE      AHRS          BHRS
     C                   MOVE      AMIN          BMIN
     C                   MOVE      ASEC          BSEC
     C                   MOVE      AMSC          BMSC
     C                   MOVE      BTMST         APTMSS
      *
     C                   MOVE      CDTMES        APTMES
     C                   MOVEL     CFRONT        APFOTR
     C                   MOVEL     CASSOC        APFOAS
     C                   MOVEL     CREPAI        APRPRL
     C                   MOVEL     'DL'          APMIDA
     C***********          MOVE DDDLNO    APDLNO                          CAP033
     C                   MOVEL     DDDLNO        APTRAN                                       CAP033
     C                   MOVE      DDACTN        APACTN
      *
      ** Write details
     C                   WRITE     APINVLD0
      *
      ** Read next record and loop back
     C**********         READ      MMINASPP                               12                  CAP033
     C                   READ      MMINASPPD                              12                  CAP033
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INASS - Negotiable assets sold                                *
      *                                                               *
      * Called by: MAIN                                               *
      * Calls: None                                                   *
      *****************************************************************
     C     INASS         BEGSR
      *
      ** Do first read before main loop
     C**********         READ      MMINASSP                               13                  CAP033
     C                   READ      MMINASSPD                              13                  CAP033
      *
      ** Loop while records read
     C     *IN13         DOWEQ     '0'
      *
      * Set output fields
      *
     C                   MOVE      DDTMES        ATMST
     C                   MOVE      AYRS          BYRS
     C                   MOVE      AMON          BMON
     C                   MOVE      ADAY          BDAY
     C                   MOVE      AHRS          BHRS
     C                   MOVE      AMIN          BMIN
     C                   MOVE      ASEC          BSEC
     C                   MOVE      AMSC          BMSC
     C                   MOVE      BTMST         APTMSS
      *
     C                   MOVE      DDTMES        APTMES
     C                   MOVEL     DFRONT        APFOTR
     C                   MOVEL     DASSOC        APFOAS
     C                   MOVEL     DREPAI        APRPRL
     C                   MOVEL     'DL'          APMIDA
     C***********          MOVE DDDLNO    APDLNO                          CAP033
     C                   MOVEL     DDDLNO        APTRAN                                       CAP033
     C                   MOVE      DDACTN        APACTN
      *
      ** Write details
     C                   WRITE     APINVLD0
      *
      ** Read next record and loop back
     C**********         READ      MMINASSP                               13                  CAP033
     C                   READ      MMINASSPD                              13                  CAP033
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IFXDL - FX deals                                              *
      *                                                               *
      * Called by: MAIN                                               *
      * Calls: None                                                   *
      *****************************************************************
     C     IFXDL         BEGSR
      *
      ** Do first read before main loop
     C**********         READ      FXIFXDLP                               14                  CAP033
     C                   READ      FXIFXDLPD                              14                  CAP033
      *
      ** Loop while records read
     C     *IN14         DOWEQ     '0'
      *
      * Set output fields
      *
     C                   MOVE      EDTMES        ATMST
     C                   MOVE      AYRS          BYRS
     C                   MOVE      AMON          BMON
     C                   MOVE      ADAY          BDAY
     C                   MOVE      AHRS          BHRS
     C                   MOVE      AMIN          BMIN
     C                   MOVE      ASEC          BSEC
     C                   MOVE      AMSC          BMSC
     C                   MOVE      BTMST         APTMSS
      *
     C                   MOVE      EDTMES        APTMES
     C                   MOVEL     EDFOTR        APFOTR
     C                   MOVEL     EDFOAS        APFOAS
     C                   MOVEL     EDRPRL        APRPRL
     C                   MOVEL     'DL'          APMIDA
     C***********          MOVE DDDLNO    APDLNO                          CAP033
     C                   MOVEL     DDDLNO        APTRAN                                       CAP033
     C                   MOVE      DDACTN        APACTN
      *
      ** Write details
     C                   WRITE     APINVLD0
      *
      ** Read next record and loop back
     C**********         READ      FXIFXDLP                               14                  CAP033
     C                   READ      FXIFXDLPD                              14                  CAP033
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                              CAP004
      *****************************************************************   CAP004
      * IFRA  - FRA deals                                             *   CAP004
      *                                                               *   CAP004
      * Called by: MAIN                                               *   CAP004
      * Calls: None                                                   *   CAP004
      *****************************************************************   CAP004
     C     IFRA          BEGSR                                                                 CAP00
      *                                                                   CAP004
      ** Do first read before main loop                                   CAP004
     C                   READ      IRIFRAPD                               15                   CAP00
      *                                                                   CAP004
      ** Loop while records read                                          CAP004
     C     *IN15         DOWEQ     '0'                                                         CAP00
      *                                                                   CAP004
      * Set output fields                                                 CAP004
      *                                                                   CAP004
     C                   MOVE      FSTMES        ATMST                                         CAP00
     C                   MOVE      AYRS          BYRS                                          CAP00
     C                   MOVE      AMON          BMON                                          CAP00
     C                   MOVE      ADAY          BDAY                                          CAP00
     C                   MOVE      AHRS          BHRS                                          CAP00
     C                   MOVE      AMIN          BMIN                                          CAP00
     C                   MOVE      ASEC          BSEC                                          CAP00
     C                   MOVE      AMSC          BMSC                                          CAP00
     C                   MOVE      BTMST         APTMSS                                        CAP00
      *                                                                   CAP004
     C                   MOVE      FSTMES        APTMES                                        CAP00
     C                   MOVEL     FSFOTR        APFOTR                                        CAP00
     C                   MOVEL     FSFOAS        APFOAS                                        CAP00
     C                   MOVEL     FSRPRL        APRPRL                                        CAP00
     C                   MOVEL     'IR'          APMIDA                                       CAP033
     C***********          MOVE SDLNO     APDLNO                   CAP004 CAP033
     C                   MOVEL     SDLNO         APTRAN                                       CAP033
     C                   MOVE      SACCD         APACTN                                       CAP033
      *                                                                   CAP004
      ** Write details                                                    CAP004
     C                   WRITE     APINVLD0                                                   CAP033
      *                                                                   CAP004
      ** Read next record and loop back                                   CAP004
     C                   READ      IRIFRAPD                               15                  CAP033
      *                                                                   CAP004
     C                   ENDDO                                                                CAP033
      *                                                                   CAP004
     C                   ENDSR                                                                CAP033
      *****************************************************************   CAP004
      /EJECT                                                              CAP004
      *****************************************************************   CAP004
      * ISIRS - IRS deals (single ccy)                                *   CAP004
      *                                                               *   CAP004
      * Called by: MAIN                                               *   CAP004
      * Calls: None                                                   *   CAP004
      *****************************************************************   CAP004
     C     ISIRS         BEGSR                                                                 CAP00
      *                                                                   CAP004
      ** Do first read before main loop                                   CAP004
     C**********         READ      IRISIRSP                               16                  CAP033
     C                   READ      IRISIRSPD                              16                  CAP033
      *                                                                   CAP004
      ** Loop while records read                                          CAP004
     C     *IN16         DOWEQ     '0'                                                         CAP00
      *                                                                   CAP004
      * Set output fields                                                 CAP004
      *                                                                   CAP004
     C                   MOVE      GSTMES        ATMST                                         CAP00
     C                   MOVE      AYRS          BYRS                                          CAP00
     C                   MOVE      AMON          BMON                                          CAP00
     C                   MOVE      ADAY          BDAY                                          CAP00
     C                   MOVE      AHRS          BHRS                                          CAP00
     C                   MOVE      AMIN          BMIN                                          CAP00
     C                   MOVE      ASEC          BSEC                                          CAP00
     C                   MOVE      AMSC          BMSC                                          CAP00
     C                   MOVE      BTMST         APTMSS                                        CAP00
      *                                                                   CAP004
     C                   MOVE      GSTMES        APTMES                                        CAP00
     C                   MOVEL     GSFOTR        APFOTR                                        CAP00
     C                   MOVEL     GSFOAS        APFOAS                                        CAP00
     C                   MOVEL     GSRPRL        APRPRL                                        CAP00
     C                   MOVEL     'IR'          APMIDA                                        CAP00
     C***********          MOVE SDLNO     APDLNO                   CAP004 CAP033
     C                   MOVEL     SDLNO         APTRAN                                        CAP00
     C                   MOVE      SACCD         APACTN                                        CAP00
      *                                                                   CAP004
      ** Write details                                                    CAP004
     C                   WRITE     APINVLD0                                                    CAP00
      *                                                                   CAP004
      ** Read next record and loop back                                   CAP004
     C**********         READ      IRISIRSP                               16                  CAP033
     C                   READ      IRISIRSPD                              16                  CAP033
      *                                                                   CAP004
     C                   ENDDO                                                                 CAP00
      *                                                                   CAP004
     C                   ENDSR                                                                 CAP00
      *****************************************************************   CAP004
      /EJECT                                                              CAP004
      *****************************************************************   CAP004
      * ICIRS - IRS deals (cross ccy)                                 *   CAP004
      *                                                               *   CAP004
      * Called by: MAIN                                               *   CAP004
      * Calls: None                                                   *   CAP004
      *****************************************************************   CAP004
     C     ICIRS         BEGSR                                                                 CAP00
      *                                                                   CAP004
      ** Do first read before main loop                                   CAP004
     C**********         READ      IRICIRSP                               17                  CAP033
     C                   READ      IRICIRSPD                              17                  CAP033
      *                                                                   CAP004
      ** Loop while records read                                          CAP004
     C     *IN17         DOWEQ     '0'                                                         CAP00
      *                                                                   CAP004
      * Set output fields                                                 CAP004
      *                                                                   CAP004
     C                   MOVE      HSTMES        ATMST                                         CAP00
     C                   MOVE      AYRS          BYRS                                          CAP00
     C                   MOVE      AMON          BMON                                          CAP00
     C                   MOVE      ADAY          BDAY                                          CAP00
     C                   MOVE      AHRS          BHRS                                          CAP00
     C                   MOVE      AMIN          BMIN                                          CAP00
     C                   MOVE      ASEC          BSEC                                          CAP00
     C                   MOVE      AMSC          BMSC                                          CAP00
     C                   MOVE      BTMST         APTMSS                                        CAP00
      *                                                                   CAP004
     C                   MOVE      HSTMES        APTMES                                        CAP00
     C                   MOVEL     HSFOTR        APFOTR                                        CAP00
     C                   MOVEL     HSFOAS        APFOAS                                        CAP00
     C                   MOVEL     HSRPRL        APRPRL                                        CAP00
     C                   MOVEL     'IR'          APMIDA                                        CAP00
     C***********          MOVE SDLNO     APDLNO                   CAP004 CAP033
     C                   MOVEL     SDLNO         APTRAN                                        CAP00
     C                   MOVE      SACCD         APACTN                                        CAP00
      *                                                                   CAP004
      ** Write details                                                    CAP004
     C                   WRITE     APINVLD0                                                    CAP00
      *                                                                   CAP004
      ** Read next record and loop back                                   CAP004
     C**********         READ      IRICIRSP                               17                  CAP033
     C                   READ      IRICIRSPD                              17                  CAP033
      *                                                                   CAP004
     C                   ENDDO                                                                 CAP00
      *                                                                   CAP004
     C                   ENDSR                                                                 CAP00
      *****************************************************************   CAP004
      /EJECT                                                              CAP004
      *****************************************************************   CAP004
      * IDPMV - SE depot movements (WI/WO)                            *   CAP004
      *                                                               *   CAP004
      * Called by: MAIN                                               *   CAP004
      * Calls: None                                                   *   CAP004
      *****************************************************************   CAP004
     C     IDPMV         BEGSR                                                                 CAP00
      *                                                                   CAP004
      ** Do first read before main loop                                   CAP004
     C**********         READ      SEIDPMVP                               18                  CAP033
     C                   READ      SEIDPMVPD                              18                  CAP033
      *                                                                   CAP004
      ** Loop while records read                                          CAP004
     C     *IN18         DOWEQ     '0'                                                         CAP00
      *                                                                   CAP004
      * Set output fields                                                 CAP004
      *                                                                   CAP004
     C                   MOVE      IDDTST        ATMST                                         CAP00
     C                   MOVE      AYRS          BYRS                                          CAP00
     C                   MOVE      AMON          BMON                                          CAP00
     C                   MOVE      ADAY          BDAY                                          CAP00
     C                   MOVE      AHRS          BHRS                                          CAP00
     C                   MOVE      AMIN          BMIN                                          CAP00
     C                   MOVE      ASEC          BSEC                                          CAP00
     C                   MOVE      AMSC          BMSC                                          CAP00
     C                   MOVE      BTMST         APTMSS                                        CAP00
      *                                                                   CAP004
     C                   MOVE      IDDTST        APTMES                                        CAP00
     C                   MOVEL     IFOFFI        APFOTR                                        CAP00
     C                   MOVE      *BLANK        APFOAS                                        CAP00
     C                   MOVEL     IRPRLO        APRPRL                                        CAP00
     C                   MOVEL     'SE'          APMIDA                                        CAP00
     C***********          MOVE DDDPRN    APDLNO                   CAP004 CAP033
     C                   MOVEL     DDDPRN        APTRAN                                        CAP00
     C                   MOVE      DDACTN        APACTN                                        CAP00
      *                                                                   CAP004
      ** Write details                                                    CAP004
     C                   WRITE     APINVLD0                                                    CAP00
      *                                                                   CAP004
      ** Read next record and loop back                                   CAP004
     C**********         READ      SEIDPMVP                               18                  CAP033
     C                   READ      SEIDPMVPD                              18                  CAP033
      *                                                                   CAP004
     C                   ENDDO                                                                 CAP00
      *                                                                   CAP004
     C                   ENDSR                                                                 CAP00
      *****************************************************************   CAP004
      /EJECT                                                              CAP004
      *****************************************************************   CAP004
      * ITRAD - SE trades                                             *   CAP004
      *                                                               *   CAP004
      * Called by: MAIN                                               *   CAP004
      * Calls: None                                                   *   CAP004
      *****************************************************************   CAP004
     C     ITRAD         BEGSR                                                                 CAP00
      *                                                                   CAP004
      ** Do first read before main loop                                   CAP004
     C**********         READ      SEITRADP                               19                  CAP033
     C                   READ      SEITRADPD                              19                  CAP033
      *                                                                   CAP004
      ** Loop while records read                                          CAP004
     C     *IN19         DOWEQ     '0'                                                         CAP00
      *                                                                   CAP004
      * Set output fields                                                 CAP004
      *                                                                   CAP004
     C                   MOVE      JDTMES        ATMST                                         CAP00
     C                   MOVE      AYRS          BYRS                                          CAP00
     C                   MOVE      AMON          BMON                                          CAP00
     C                   MOVE      ADAY          BDAY                                          CAP00
     C                   MOVE      AHRS          BHRS                                          CAP00
     C                   MOVE      AMIN          BMIN                                          CAP00
     C                   MOVE      ASEC          BSEC                                          CAP00
     C                   MOVE      AMSC          BMSC                                          CAP00
     C                   MOVE      BTMST         APTMSS                                        CAP00
      *                                                                   CAP004
     C                   MOVE      JDTMES        APTMES                                        CAP00
     C                   MOVEL     JDFOTR        APFOTR                                        CAP00
     C                   MOVEL     JDFOAS        APFOAS                                        CAP00
     C                   MOVEL     JDRPRL        APRPRL                                        CAP00
     C                   MOVEL     'SE'          APMIDA                                        CAP00
     C***********          MOVE DDDLNO    APDLNO                   CAP004 CAP033
     C                   MOVEL     DDDLNO        APTRAN                                        CAP00
     C                   MOVE      JDACTN        APACTN                                        CAP00
      *                                                                   CAP004
      ** Write details                                                    CAP004
     C                   WRITE     APINVLD0                                                    CAP00
      *                                                                   CAP004
      ** Read next record and loop back                                   CAP004
     C**********         READ      SEITRADP                               19                  CAP033
     C                   READ      SEITRADPD                              19                  CAP033
      *                                                                   CAP004
     C                   ENDDO                                                                 CAP00
      *                                                                   CAP004
     C                   ENDSR                                                                 CAP00
      *****************************************************************   CAP004
      /EJECT                                                              CAP004
      *****************************************************************   CAP004
      * IINTC - AB Internal Contract Deals                            *   CAP004
      *                                                               *   CAP004
      * Called by: MAIN                                               *   CAP004
      * Calls: None                                                   *   CAP004
      *****************************************************************   CAP004
     C     IINTC         BEGSR                                                                 CAP00
      *                                                                   CAP004
      ** Do first read before main loop                                   CAP004
     C**********         READ      ABIINTCP                               20                  CAP033
     C                   READ      ABIINTCPD                              20                  CAP033
      *                                                                   CAP004
      ** Loop while records read                                          CAP004
     C     *IN20         DOWEQ     '0'                                                         CAP00
      *                                                                   CAP004
      * Set output fields                                                 CAP004
      *                                                                   CAP004
     C                   MOVE      KDTMES        ATMST                                         CAP00
     C                   MOVE      AYRS          BYRS                                          CAP00
     C                   MOVE      AMON          BMON                                          CAP00
     C                   MOVE      ADAY          BDAY                                          CAP00
     C                   MOVE      AHRS          BHRS                                          CAP00
     C                   MOVE      AMIN          BMIN                                          CAP00
     C                   MOVE      ASEC          BSEC                                          CAP00
     C                   MOVE      AMSC          BMSC                                          CAP00
     C                   MOVE      BTMST         APTMSS                                        CAP00
      *                                                                   CAP004
     C                   MOVE      KDTMES        APTMES                                        CAP00
     C                   MOVEL     KDFOTR        APFOTR                                        CAP00
     C                   MOVEL     KDFOAS        APFOAS                                        CAP00
     C                   MOVEL     KDRPRL        APRPRL                                        CAP00
     C                   MOVEL     'AB'          APMIDA                                        CAP00
     C***********          MOVE DDTDRF    APDLNO                   CAP004 CAP033
     C                   MOVEL     DDTDRF        APTRAN                                        CAP00
     C                   MOVE      KDACTN        APACTN                                        CAP00
      *                                                                   CAP004
      ** Write details                                                    CAP004
     C                   WRITE     APINVLD0                                                    CAP00
      *                                                                   CAP004
      ** Read next record and loop back                                   CAP004
     C**********         READ      ABIINTCP                               20                  CAP033
     C                   READ      ABIINTCPD                              20                  CAP033
      *                                                                   CAP004
     C                   ENDDO                                                                 CAP00
      *                                                                   CAP004
     C                   ENDSR                                                                 CAP00
      *****************************************************************   CAP004
      /EJECT                                                              CAP004
      *****************************************************************   CAP004
      * IEXTR - FF Exchange Traded Futures & Options                  *   CAP004
      *                                                               *   CAP004
      * Called by: MAIN                                               *   CAP004
      * Calls: None                                                   *   CAP004
      *****************************************************************   CAP004
     C     IEXTR         BEGSR                                                                 CAP00
      *                                                                   CAP004
      ** Do first read before main loop                                   CAP004
     C**********         READ      FFIEXTRP                               21                  CAP033
     C                   READ      FFIEXTRPD                              21                  CAP033
      *                                                                   CAP004
      ** Loop while records read                                          CAP004
     C     *IN21         DOWEQ     '0'                                                         CAP00
      *                                                                   CAP004
      * Set output fields                                                 CAP004
      *                                                                   CAP004
     C                   MOVE      LDTMES        ATMST                                         CAP00
     C                   MOVE      AYRS          BYRS                                          CAP00
     C                   MOVE      AMON          BMON                                          CAP00
     C                   MOVE      ADAY          BDAY                                          CAP00
     C                   MOVE      AHRS          BHRS                                          CAP00
     C                   MOVE      AMIN          BMIN                                          CAP00
     C                   MOVE      ASEC          BSEC                                          CAP00
     C                   MOVE      AMSC          BMSC                                          CAP00
     C                   MOVE      BTMST         APTMSS                                        CAP00
      *                                                                   CAP004
     C                   MOVE      LDTMES        APTMES                                        CAP00
     C                   MOVEL     LDFOTR        APFOTR                                        CAP00
     C                   MOVEL     LDFOAS        APFOAS                                        CAP00
     C                   MOVEL     LDRPRL        APRPRL                                        CAP00
     C                   MOVEL     'FF'          APMIDA                                        CAP00
     C***********          MOVE STNBR     APDLNO                   CAP004 CAP033
     C                   MOVEL     STNBR         APTRAN                                        CAP00
     C                   MOVE      LDACTN        APACTN                                        CAP00
      *                                                                   CAP004
      ** Write details                                                    CAP004
     C                   WRITE     APINVLD0                                                    CAP00
      *                                                                   CAP004
      ** Read next record and loop back                                   CAP004
     C**********         READ      FFIEXTRP                               21                  CAP033
     C                   READ      FFIEXTRPD                              21                  CAP033
      *                                                                   CAP004
     C                   ENDDO                                                                 CAP00
      *                                                                   CAP004
     C                   ENDSR                                                                 CAP00
      *****************************************************************   CAP004
      /EJECT                                                              CAP004
      *****************************************************************   CAP004
      * IOTCC - FF OTC Options                                        *   CAP004
      *                                                               *   CAP004
      * Called by: MAIN                                               *   CAP004
      * Calls: None                                                   *   CAP004
      *****************************************************************   CAP004
     C     IOTCC         BEGSR                                                                 CAP00
      *                                                                   CAP004
      ** Do first read before main loop                                   CAP004
     C**********         READ      FFIOTCCP                               22                  CAP033
     C                   READ      FFIOTCCPD                              22                  CAP033
      *                                                                   CAP004
      ** Loop while records read                                          CAP004
     C     *IN22         DOWEQ     '0'                                                         CAP00
      *                                                                   CAP004
      * Set output fields                                                 CAP004
      *                                                                   CAP004
     C                   MOVE      MDTMES        ATMST                                         CAP00
     C                   MOVE      AYRS          BYRS                                          CAP00
     C                   MOVE      AMON          BMON                                          CAP00
     C                   MOVE      ADAY          BDAY                                          CAP00
     C                   MOVE      AHRS          BHRS                                          CAP00
     C                   MOVE      AMIN          BMIN                                          CAP00
     C                   MOVE      ASEC          BSEC                                          CAP00
     C                   MOVE      AMSC          BMSC                                          CAP00
     C                   MOVE      BTMST         APTMSS                                        CAP00
      *                                                                   CAP004
     C                   MOVE      MDTMES        APTMES                                        CAP00
     C                   MOVEL     MDFOTR        APFOTR                                        CAP00
     C                   MOVEL     MDFOAS        APFOAS                                        CAP00
     C                   MOVEL     MDRPRL        APRPRL                                        CAP00
     C                   MOVEL     'FF'          APMIDA                                        CAP00
     C***********          MOVE STNBR     APDLNO                   CAP004 CAP033
     C                   MOVEL     STNBR         APTRAN                                        CAP00
     C                   MOVE      MDACTN        APACTN                                        CAP00
      *                                                                   CAP004
      ** Write details                                                    CAP004
     C                   WRITE     APINVLD0                                                    CAP00
      *                                                                   CAP004
      ** Read next record and loop back                                   CAP004
     C**********         READ      FFIOTCCP                               22                  CAP033
     C                   READ      FFIOTCCPD                              22                  CAP033
      *                                                                   CAP004
     C                   ENDDO                                                                 CAP00
      *                                                                   CAP004
     C                   ENDSR                                                                 CAP00
      *****************************************************************   CAP004
     C/EJECT
      *****************************************************************   CAP031
      * IOPAY - FT Outgoing payments                                  *   CAP031
      *                                                               *   CAP031
      * Called by: MAIN                                               *   CAP031
      * Calls: None                                                   *   CAP031
      *****************************************************************   CAP031
     C     IOPAY         BEGSR                                                                CAP031
      *                                                                                       CAP031
      ** Do first read before main loop                                                       CAP031
     C**********         READ      FTIOPAYP                               23           CAP031 CAP033
     C                   READ      FTIOPAYPD                              23                  CAP033
      *                                                                                       CAP031
      ** Loop while records read                                                              CAP031
     C     *IN23         DOWEQ     '0'                                                        CAP031
      *                                                                                       CAP031
      * Set output fields                                                                     CAP031
      *                                                                                       CAP031
     C                   MOVE      NDTMES        ATMST                                        CAP031
     C                   MOVE      AYRS          BYRS                                         CAP031
     C                   MOVE      AMON          BMON                                         CAP031
     C                   MOVE      ADAY          BDAY                                         CAP031
     C                   MOVE      AHRS          BHRS                                         CAP031
     C                   MOVE      AMIN          BMIN                                         CAP031
     C                   MOVE      ASEC          BSEC                                         CAP031
     C                   MOVE      AMSC          BMSC                                         CAP031
     C                   MOVE      BTMST         APTMSS                                       CAP031
      *                                                                   CAP031
     C                   MOVE      NDTMES        APTMES                                       CAP031
     C                   MOVEL     NDFOTR        APFOTR                                       CAP031
     C                   MOVEL     *BLANKS       APFOAS                                       CAP031
     C                   MOVEL     NDRPRL        APRPRL                                       CAP031
     C                   MOVEL     'FT'          APMIDA                                       CAP031
     C***************    MOVEL     SPREF         APDLNO                                       CAP031
     C                   MOVEL     SPREF         APTRAN                                       CAP031
     C                   MOVE      NDACTN        APACTN                                       CAP031
      *                                                                   CAP031
      ** Write details                                                    CAP031
     C                   WRITE     APINVLD0                                                   CAP031
      *                                                                   CAP031
      ** Read next record and loop back                                   CAP031
     C**********         READ      FTIOPAYP                               23           CAP031 CAP033
     C                   READ      FTIOPAYPD                              23                  CAP033
      *                                                                   CAP031
     C                   ENDDO                                                                CAP031
      *                                                                   CAP031
     C                   ENDSR                                                                CAP031
      *****************************************************************   CAP031
     C/EJECT
      *****************************************************************   CAP034
      * ICUSD - SD Customers Details                                  *   CAP034
      *                                                               *   CAP034
      * Called by: MAIN                                               *   CAP034
      * Calls: None                                                   *   CAP034
      *****************************************************************   CAP034
     C     ICUSD         BEGSR                                                                 CAP03
      *                                                                   CAP034
      ** Do first read before main loop                                   CAP034
     C**********         READ      SDICUSDP                               24          CAP034  CAP033
     C                   READ      SDICUSDPD                              24                  CAP033
      *                                                                   CAP034
      ** Loop while records read                                          CAP034
     C     *IN24         DOWEQ     '0'                                                        CAP034
      *                                                                   CAP034
      * Set output fields                                                 CAP034
      *                                                                   CAP034
     C                   MOVE      ODTMES        ATMST                                         CAP03
     C                   MOVE      AYRS          BYRS                                          CAP03
     C                   MOVE      AMON          BMON                                          CAP03
     C                   MOVE      ADAY          BDAY                                          CAP03
     C                   MOVE      AHRS          BHRS                                          CAP03
     C                   MOVE      AMIN          BMIN                                          CAP03
     C                   MOVE      ASEC          BSEC                                          CAP03
     C                   MOVE      AMSC          BMSC                                          CAP03
     C                   MOVE      BTMST         APTMSS                                        CAP03
      *                                                                   CAP034
     C                   MOVE      ODTMES        APTMES                                        CAP03
     C                   MOVEL     ODFOTR        APFOTR                                        CAP03
     C                   MOVEL     *BLANKS       APFOAS                                        CAP03
     C                   MOVEL     ODRPRL        APRPRL                                        CAP03
     C                   MOVEL     'SD'          APMIDA                                        CAP03
     C*************      MOVEL     ODCUSN        APDLNO                                       CAP034
     C                   MOVEL     ODCUSN        APTRAN                                       CAP034
     C                   MOVE      ODACTN        APACTN                                       CAP034
      *                                                                   CAP034
      ** Write details                                                    CAP034
     C                   WRITE     APINVLD0                                                   CAP034
      *                                                                   CAP034
      ** Read next record and loop back                                   CAP034
     C**********         READ      SDICUSDP                               24           CAP034 CAP033
     C                   READ      SDICUSDPD                              24                  CAP033
      *                                                                   CAP034
     C                   ENDDO                                                                CAP034
      *                                                                   CAP034
     C                   ENDSR                                                                CAP034
      *****************************************************************   CAP034
     C/EJECT
      *****************************************************************   CAP035
      * IAMAD - GL Accounts Maintenance                               *   CAP035
      *                                                               *   CAP035
      * Called by: MAIN                                               *   CAP035
      * Calls: None                                                   *   CAP035
      *****************************************************************   CAP035
     C     IAMAD         BEGSR                                                                 CAP03
      *                                                                   CAP035
      ** Do first read before main loop                                   CAP035
     C**********         READ      GLIAMADP                               25           CAP035 CAP033
     C                   READ      GLIAMADPD                              25                  CAP033
      *                                                                   CAP035
      ** Loop while records read                                          CAP035
     C     *IN25         DOWEQ     '0'                                                         CAP03
      *                                                                   CAP035
      * Set output fields                                                 CAP035
      *                                                                   CAP035
     C                   MOVE      PDTMES        ATMST                                         CAP03
     C                   MOVE      AYRS          BYRS                                          CAP03
     C                   MOVE      AMON          BMON                                          CAP03
     C                   MOVE      ADAY          BDAY                                          CAP03
     C                   MOVE      AHRS          BHRS                                          CAP03
     C                   MOVE      AMIN          BMIN                                          CAP03
     C                   MOVE      ASEC          BSEC                                          CAP03
     C                   MOVE      AMSC          BMSC                                          CAP03
     C                   MOVE      BTMST         APTMSS                                        CAP03
      *                                                                   CAP035
     C                   MOVE      PDTMES        APTMES                                        CAP03
     C                   MOVEL     PDFOTR        APFOTR                                        CAP03
     C**********         MOVEL     *BLANKS       APFOAS                                CAP034 CGL029
     C                   MOVEL     PDFOAS        APFOAS                                       CGL029
     C                   MOVEL     PDRPRL        APRPRL                                        CAP03
     C                   MOVEL     'GL'          APMIDA                                       CAP034
     C**************     MOVEL     PDCNUM        APDLNO                                       CAP034
     C                   MOVEL     PDACCN        APTRAN                                       CAP034
     C                   MOVE      PDACTN        APACTN                                       CAP034
      *                                                                   CAP035
      ** Write details                                                    CAP035
     C                   WRITE     APINVLD0                                                   CAP034
      *                                                                   CAP035
      ** Read next record and loop back                                   CAP035
     C**********         READ      GLIAMADP                               25           CAP034 CAP033
     C                   READ      GLIAMADPD                              25                  CAP033
      *                                                                   CAP035
     C                   ENDDO                                                                CAP034
      *                                                                   CAP035
     C                   ENDSR                                                                CAP034
      *****************************************************************   CAP035
      /EJECT                                                              CAP033
      *****************************************************************   CAP033
      * IPFDM - Subroutine to process Portfolio Definitions           *   CAP033
      *                                                               *   CAP033
      * Called by: MAIN                                               *   CAP033
      * Calls: None                                                   *   CAP033
      *****************************************************************   CAP033
     C     IPFDM         BEGSR                                                                 CAP00
      *                                                                   CAP033
      ** Do first read before main loop.                                  CAP033
     C                   READ      PMIPFDMPD                              26                 CAP033
      *                                                                   CAP033
      ** Loop while records read.                                         CAP033
     C     *IN26         DOWEQ     '0'                                                         CAP00
      *                                                                   CAP033
      ** Set output fields.                                               CAP033
      *                                                                   CAP033
     C                   MOVE      PMTMES        ATMST                                         CAP00
     C                   MOVE      AYRS          BYRS                                          CAP00
     C                   MOVE      AMON          BMON                                          CAP00
     C                   MOVE      ADAY          BDAY                                          CAP00
     C                   MOVE      AHRS          BHRS                                          CAP00
     C                   MOVE      AMIN          BMIN                                          CAP00
     C                   MOVE      ASEC          BSEC                                          CAP00
     C                   MOVE      AMSC          BMSC                                          CAP00
     C                   MOVE      BTMST         APTMSS                                        CAP00
      *                                                                   CAP033
     C                   MOVE      PMTMES        APTMES                                        CAP00
     C                   MOVEL     PMFOTR        APFOTR                                        CAP00
     C                   MOVEL     PMFOAS        APFOAS                                        CAP00
     C                   MOVEL     PMRPRL        APRPRL                                        CAP00
     C                   MOVEL     'PM'          APMIDA                                        CAP00
     C                   MOVEL     DDCSNM        WTRAN            10                           CAP00
     C                   MOVE      DDPREF        WTRAN                                         CAP00
     C                   MOVEL     WTRAN         APTRAN                                        CAP00
     C                   MOVE      DDACTN        APACTN                                        CAP00
      *                                                                   CAP033
      ** Write details.                                                   CAP033
     C                   WRITE     APINVLD0                                                    CAP00
      *                                                                   CAP033
      ** Read next record and loop back.                                  CAP033
     C                   READ      PMIPFDMPD                              26                  CAP033
      *                                                                   CAP033
     C                   ENDDO                                                                 CAP00
      *                                                                   CAP033
     C                   ENDSR                                                                 CAP00
      *****************************************************************   CAP033
      /EJECT                                                              CAP035
      *****************************************************************         CAP136
      * IIPAY - Subroutine to process FT Incoming Payments            *         CAP136
      *                                                               *         CAP136
      * Called by: MAIN                                               *         CAP136
      * Calls: None                                                   *         CAP136
      *****************************************************************         CAP136
     C     IIPAY         BEGSR                                                  CAP136
      *                                                                         CAP136
      ** Do first read before main loop.                                        CAP136
      *                                                                         CAP136
     C                   READ      FTIIPAYPD                              27    CAP136
      *                                                                         CAP136
      ** Loop while records read.                                               CAP136
      *                                                                         CAP136
     C     *IN27         DOWEQ     '0'                                          CAP136
      *                                                                         CAP136
      ** Set output fields.                                                     CAP136
      *                                                                         CAP136
     C                   MOVE      DDTMST        ATMST                          CAP136
     C                   MOVE      AYRS          BYRS                           CAP136
     C                   MOVE      AMON          BMON                           CAP136
     C                   MOVE      ADAY          BDAY                           CAP136
     C                   MOVE      AHRS          BHRS                           CAP136
     C                   MOVE      AMIN          BMIN                           CAP136
     C                   MOVE      ASEC          BSEC                           CAP136
     C                   MOVE      AMSC          BMSC                           CAP136
     C                   MOVE      BTMST         APTMSS                         CAP136
      *                                                                         CAP136
     C                   MOVE      DDTMST        APTMES                         CAP136
     C                   MOVEL     DDFRNT        APFOTR                         CAP136
     C                   MOVEL     *Blanks       APFOAS                         CAP136
     C                   MOVEL     DDREPA        APRPRL                         CAP136
     C                   MOVEL     'FT'          APMIDA                         CAP136
     C                   MOVEL     FTPREF        APTRAN                         CAP136
     C                   MOVE      DDACTN        APACTN                         CAP136
      *                                                                         CAP136
      ** Write details.                                                         CAP136
      *                                                                         CAP136
     C                   WRITE     APINVLD0                                     CAP136
      *                                                                         CAP136
      ** Read next record and loop back.                                        CAP136
      *                                                                         CAP136
     C                   READ      FTIIPAYPD                              27    CAP136
      *                                                                         CAP136
     C                   ENDDO                                                  CAP136
      *                                                                         CAP136
     C                   ENDSR                                                  CAP136
      *****************************************************************         CAP136
      /EJECT                                                                    CAP136
      *****************************************************************         CAP137
      * ISECS - Subroutine to process SE Securities                   *         CAP137
      *                                                               *         CAP137
      * Called by: MAIN                                               *         CAP137
      * Calls: None                                                   *         CAP137
      *****************************************************************         CAP137
     C     ISECS         BEGSR                                                  CAP137
      *                                                                         CAP137
      ** Do first read before main loop.                                        CAP137
      *                                                                         CAP137
     C                   READ      SEISECSPD                              28    CAP137
      *                                                                         CAP137
      ** Loop while records read.                                               CAP137
      *                                                                         CAP137
     C     *IN28         DOWEQ     '0'                                          CAP137
      *                                                                         CAP137
      ** Set output fields.                                                     CAP137
      *                                                                         CAP137
     C                   MOVE      DDTMST        ATMST                          CAP137
     C                   MOVE      AYRS          BYRS                           CAP137
     C                   MOVE      AMON          BMON                           CAP137
     C                   MOVE      ADAY          BDAY                           CAP137
     C                   MOVE      AHRS          BHRS                           CAP137
     C                   MOVE      AMIN          BMIN                           CAP137
     C                   MOVE      ASEC          BSEC                           CAP137
     C                   MOVE      AMSC          BMSC                           CAP137
     C                   MOVE      BTMST         APTMSS                         CAP137
      *                                                                         CAP137
     C                   MOVE      DDTMST        APTMES                         CAP137
     C                   MOVEL     DDFRNT        APFOTR                         CAP137
     C                   MOVEL     *Blanks       APFOAS                         CAP137
     C                   MOVEL     DDREPA        APRPRL                         CAP137
     C                   MOVEL     'SE'          APMIDA                         CAP137
     C                   MOVEL     DDSESN        APTRAN                         CAP137
     C                   MOVE      DDACTN        APACTN                         CAP137
      *                                                                         CAP137
      ** Write details.                                                         CAP137
      *                                                                         CAP137
     C                   WRITE     APINVLD0                                     CAP137
      *                                                                         CAP137
      ** Read next record and loop back.                                        CAP137
      *                                                                         CAP137
     C                   READ      SEISECSPD                              28    CAP137
      *                                                                         CAP137
     C                   ENDDO                                                  CAP137
      *                                                                         CAP137
     C                   ENDSR                                                  CAP137
      *****************************************************************         CAP137
      /EJECT                                                                    CAP137
      *****************************************************************   CAP039
      * ISECD - SD Security Customers Details                         *   CAP039
      *                                                               *   CAP039
      * Called by: MAIN                                               *   CAP039
      * Calls: None                                                   *   CAP039
      *****************************************************************   CAP039
     C     ISECD         BEGSR                                                                CAP039
      *                                                                                       CAP039
      ** Do first read before main loop                                                       CAP039
     C                   READ      SDISECDPD                              29                  CAP039
      *                                                                                       CAP039
      ** Loop while records read                                                              CAP039
     C     *IN29         DOWEQ     '0'                                                        CAP039
      *                                                                                       CAP039
      * Set output fields                                                                     CAP039
      *                                                                                       CAP039
     C                   MOVE      QDTMES        ATMST                                        CAP039
     C                   MOVE      AYRS          BYRS                                         CAP039
     C                   MOVE      AMON          BMON                                         CAP039
     C                   MOVE      ADAY          BDAY                                         CAP039
     C                   MOVE      AHRS          BHRS                                         CAP039
     C                   MOVE      AMIN          BMIN                                         CAP039
     C                   MOVE      ASEC          BSEC                                         CAP039
     C                   MOVE      AMSC          BMSC                                         CAP039
     C                   MOVE      BTMST         APTMSS                                       CAP039
      *                                                                                       CAP039
     C                   MOVE      QDTMES        APTMES                                       CAP039
     C                   MOVEL     QDFOTR        APFOTR                                       CAP039
     C                   MOVEL     *BLANKS       APFOAS                                       CAP039
     C                   MOVEL     QDRPRL        APRPRL                                       CAP039
     C                   MOVEL     'SD'          APMIDA                                       CAP039
     C                   MOVEL     QDCUSN        APTRAN                                       CAP039
     C                   MOVE      QDACTN        APACTN                                       CAP039
      *                                                                                       CAP039
      ** Write details                                                                        CAP039
     C                   WRITE     APINVLD0                                                   CAP039
      *                                                                                       CAP039
      ** Read next record and loop back                                                       CAP039
     C                   READ      SDISECDPD                              29                  CAP039
      *                                                                                       CAP039
     C                   ENDDO                                                                CAP039
      *                                                                                       CAP039
     C                   ENDSR                                                                CAP039
      *****************************************************************                       CAP039
      /EJECT                                                                                  CAP039
      /EJECT                                                                    CAP059
      *****************************************************************         CAP059
      * IFWRT - FD Forward Rate Details                               *         CAP059
      *                                                               *         CAP059
      * Called by: MAIN                                               *         CAP059
      * Calls: None                                                   *         CAP059
      *****************************************************************         CAP059
     C     IFWRT         BEGSR                                                  CAP059
      *                                                                         CAP059
      ** Do first read before main loop                                         CAP059
     C                   READ      FDIFWRTPD                              36    CAP059
      *                                                                         CAP059
      ** Loop while records read                                                CAP059
     C     *IN36         DOWEQ     '0'                                          CAP059
      *                                                                         CAP059
      * Set output fields                                                       CAP059
      *                                                                         CAP059
     C                   MOVE      RDTMES        ATMST                          CAP059
     C                   MOVE      AYRS          BYRS                           CAP059
     C                   MOVE      AMON          BMON                           CAP059
     C                   MOVE      ADAY          BDAY                           CAP059
     C                   MOVE      AHRS          BHRS                           CAP059
     C                   MOVE      AMIN          BMIN                           CAP059
     C                   MOVE      ASEC          BSEC                           CAP059
     C                   MOVE      AMSC          BMSC                           CAP059
     C                   MOVE      BTMST         APTMSS                         CAP059
      *                                                                         CAP059
     C                   MOVE      RDTMES        APTMES                         CAP059
     C                   MOVEL     RDFOTR        APFOTR                         CAP059
     C                   MOVEL     *BLANKS       APFOAS                         CAP059
     C                   MOVEL     RDRPRL        APRPRL                         CAP059
     C                   MOVEL     'FD'          APMIDA                         CAP059
     C                   MOVEL     RDCCY         APTRAN                         CAP059
     C                   MOVE      RDACTN        APACTN                         CAP059
      *                                                                         CAP059
      ** Write details                                                          CAP059
     C                   WRITE     APINVLD0                                     CAP059
      *                                                                         CAP059
      ** Read next record and loop back                                         CAP059
     C                   READ      FDIFWRTPD                              36    CAP059
      *                                                                         CAP059
     C                   ENDDO                                                  CAP059
      *                                                                         CAP059
     C                   ENDSR                                                  CAP059
      *****************************************************************         CAP059
      /EJECT                                                                    CAP059
      *****************************************************************         CAP058
      * IINTR - FD Interest Rate Details                              *         CAP058
      *                                                               *         CAP058
      * Called by: MAIN                                               *         CAP058
      * Calls: None                                                   *         CAP058
      *****************************************************************         CAP058
     C     IINTR         BEGSR                                                  CAP058
      *                                                                         CAP058
      ** Do first read before main loop                                         CAP058
     C                   READ      FDIINTRPD                              31    CAP058
      *                                                                         CAP058
      ** Loop while records read                                                CAP058
     C     *IN36         DOWEQ     '0'                                          CAP058
      *                                                                         CAP058
      * Set output fields                                                       CAP058
      *                                                                         CAP058
     C                   MOVE      SDTMES        ATMST                          CAP058
     C                   MOVE      AYRS          BYRS                           CAP058
     C                   MOVE      AMON          BMON                           CAP058
     C                   MOVE      ADAY          BDAY                           CAP058
     C                   MOVE      AHRS          BHRS                           CAP058
     C                   MOVE      AMIN          BMIN                           CAP058
     C                   MOVE      ASEC          BSEC                           CAP058
     C                   MOVE      AMSC          BMSC                           CAP058
     C                   MOVE      BTMST         APTMSS                         CAP058
      *                                                                         CAP058
     C                   MOVE      SDTMES        APTMES                         CAP058
     C                   MOVEL     SDFOTR        APFOTR                         CAP058
     C                   MOVEL     *BLANKS       APFOAS                         CAP058
     C                   MOVEL     SDRPRL        APRPRL                         CAP058
     C                   MOVEL     'FD'          APMIDA                         CAP058
     C                   MOVEL     SDCCY         APTRAN                         CAP058
     C                   MOVE      SDACTN        APACTN                         CAP058
      *                                                                         CAP058
      ** Write details                                                          CAP058
     C                   WRITE     APINVLD0                                     CAP058
      *                                                                         CAP058
      ** Read next record and loop back                                         CAP058
     C                   READ      FDIINTRPD                              31    CAP058
      *                                                                         CAP058
     C                   ENDDO                                                  CAP058
      *                                                                         CAP058
     C                   ENDSR                                                  CAP058
      *****************************************************************         CAP058
      /EJECT                                                                    CAP058
      *****************************************************************         CAP058
      * IBSRT - SD Base Rate Details                                  *         CAP038
      *                                                               *         CAP038
      * Called by: MAIN                                               *         CAP038
      * Calls: None                                                   *         CAP038
      *****************************************************************         CAP038
     C     IBSRT         BEGSR                                                  CAP038
      *                                                                         CAP038
      ** Do first read before main loop                                         CAP038
     C                   READ      SDIBSRTPD                              32    CAP038
      *                                                                         CAP038
      ** Loop while records read                                                CAP038
     C     *IN32         DOWEQ     '0'                                          CAP038
      *                                                                         CAP038
      * Set output fields                                                       CAP038
      *                                                                         CAP038
     C                   MOVE      TDTMES        ATMST                          CAP038
     C                   MOVE      AYRS          BYRS                           CAP038
     C                   MOVE      AMON          BMON                           CAP038
     C                   MOVE      ADAY          BDAY                           CAP038
     C                   MOVE      AHRS          BHRS                           CAP038
     C                   MOVE      AMIN          BMIN                           CAP038
     C                   MOVE      ASEC          BSEC                           CAP038
     C                   MOVE      AMSC          BMSC                           CAP038
     C                   MOVE      BTMST         APTMSS                         CAP038
      *                                                                         CAP038
     C                   MOVE      TDTMES        APTMES                         CAP038
     C                   MOVEL     TDFOTR        APFOTR                         CAP038
     C                   MOVEL     *BLANKS       APFOAS                         CAP038
     C                   MOVEL     TDRPRL        APRPRL                         CAP038
     C                   MOVEL     'SD'          APMIDA                         CAP038
     C                   MOVEL     TDCYCD        APTRAN                         CAP038
     C                   MOVE      TDACTN        APACTN                         CAP038
      *                                                                         CAP038
      ** Write details                                                          CAP038
     C                   WRITE     APINVLD0                                     CAP038
      *                                                                         CAP038
      ** Read next record and loop back                                         CAP038
     C                   READ      SDIBSRTPD                              32    CAP038
      *                                                                         CAP038
     C                   ENDDO                                                  CAP038
      *                                                                         CAP038
     C                   ENDSR                                                  CAP038
      *****************************************************************         CAP038
      */EJECT                                                                   CAP038
      *****************************************************************         CAP038
      * ISPTR - SD Spot Rate Details                                  *         CAP057
      *                                                               *         CAP057
      * Called by: MAIN                                               *         CAP057
      * Calls: None                                                   *         CAP057
      *****************************************************************         CAP057
     C     ISPTR         BEGSR                                                  CAP057
      *                                                                         CAP057
      ** Do first read before main loop                                         CAP057
     C                   READ      SDISPTRPD                              33    CAP057
      *                                                                         CAP057
      ** Loop while records read                                                CAP057
     C     *IN33         DOWEQ     '0'                                          CAP057
      *                                                                         CAP057
      * Set output fields                                                       CAP057
      *                                                                         CAP057
     C                   MOVE      UDTMES        ATMST                          CAP057
     C                   MOVE      AYRS          BYRS                           CAP057
     C                   MOVE      AMON          BMON                           CAP057
     C                   MOVE      ADAY          BDAY                           CAP057
     C                   MOVE      AHRS          BHRS                           CAP057
     C                   MOVE      AMIN          BMIN                           CAP057
     C                   MOVE      ASEC          BSEC                           CAP057
     C                   MOVE      AMSC          BMSC                           CAP057
     C                   MOVE      BTMST         APTMSS                         CAP057
      *                                                                         CAP057
     C                   MOVE      UDTMES        APTMES                         CAP057
     C                   MOVEL     UDFOTR        APFOTR                         CAP057
     C                   MOVEL     *BLANKS       APFOAS                         CAP057
     C                   MOVEL     UDRPRL        APRPRL                         CAP057
     C                   MOVEL     'SD'          APMIDA                         CAP057
     C                   MOVEL     UDCYCD        APTRAN                         CAP057
     C                   MOVE      UDACTN        APACTN                         CAP057
      *                                                                         CAP057
      ** Write details                                                          CAP057
     C                   WRITE     APINVLD0                                     CAP057
      *                                                                         CAP057
      ** Read next record and loop back                                         CAP057
     C                   READ      SDISPTRPD                              33    CAP057
      *                                                                         CAP057
     C                   ENDDO                                                  CAP057
      *                                                                         CAP057
     C                   ENDSR                                                  CAP057
      *****************************************************************         CAP057
      /EJECT                                                                    CAP057
      *****************************************************************         CAP060
      * IPRCS - SE Security Price Details                             *         CAP060
      *                                                               *         CAP060
      * Called by: MAIN                                               *         CAP060
      * Calls: None                                                   *         CAP060
      *****************************************************************         CAP060
     C     IPRCS         BEGSR                                                  CAP060
      *                                                                         CAP060
      ** Do first read before main loop                                         CAP060
     C                   READ      SEIPRCSPD                              34    CAP060
      *                                                                         CAP060
      ** Loop while records read                                                CAP060
     C     *IN34         DOWEQ     '0'                                          CAP060
      *                                                                         CAP060
      * Set output fields                                                       CAP060
      *                                                                         CAP060
     C                   MOVE      VDTMES        ATMST                          CAP060
     C                   MOVE      AYRS          BYRS                           CAP060
     C                   MOVE      AMON          BMON                           CAP060
     C                   MOVE      ADAY          BDAY                           CAP060
     C                   MOVE      AHRS          BHRS                           CAP060
     C                   MOVE      AMIN          BMIN                           CAP060
     C                   MOVE      ASEC          BSEC                           CAP060
     C                   MOVE      AMSC          BMSC                           CAP060
     C                   MOVE      BTMST         APTMSS                         CAP060
      *                                                                         CAP060
     C                   MOVE      VDTMES        APTMES                         CAP060
     C                   MOVEL     VDFOTR        APFOTR                         CAP060
     C                   MOVEL     *BLANKS       APFOAS                         CAP060
     C                   MOVEL     VDRPRL        APRPRL                         CAP060
     C                   MOVEL     'SE'          APMIDA                         CAP060
     C                   MOVEL     VDPSSN        APTRAN                         CAP060
     C                   MOVE      VDACTN        APACTN                         CAP060
      *                                                                         CAP060
      ** Write details                                                          CAP060
     C                   WRITE     APINVLD0                                     CAP060
      *                                                                         CAP060
      ** Read next record and loop back                                         CAP060
     C                   READ      SEIPRCSPD                              34    CAP060
      *                                                                         CAP060
     C                   ENDDO                                                  CAP060
      *                                                                         CAP060
     C                   ENDSR                                                  CAP060
      *****************************************************************         CAP060
      */EJECT                                                                   CAP060
      *****************************************************************                       CAP042
      * IFUND - Subroutine to process AB Internal Funding Deals       *                       CAP042
      *                                                               *                       CAP042
      * Called by: MAIN                                               *                       CAP042
      * Calls: None                                                   *                       CAP042
      *****************************************************************                       CAP042
     C     IFUND         BEGSR                                                                CAP042
      *                                                                                       CAP042
      ** Do first read before main loop.                                                      CAP042
      *                                                                                       CAP042
     C                   READ      ABIFUNDPD                              35                  CAP042
      *                                                                                       CAP042
      ** Loop while records read.                                                             CAP042
      *                                                                                       CAP042
     C     *IN35         DOWEQ     '0'                                                        CAP042
      *                                                                                       CAP042
      ** Set output fields.                                                                   CAP042
      *                                                                                       CAP042
     C                   MOVE      RDTMST        ATMST                                        CAP042
     C                   MOVE      AYRS          BYRS                                         CAP042
     C                   MOVE      AMON          BMON                                         CAP042
     C                   MOVE      ADAY          BDAY                                         CAP042
     C                   MOVE      AHRS          BHRS                                         CAP042
     C                   MOVE      AMIN          BMIN                                         CAP042
     C                   MOVE      ASEC          BSEC                                         CAP042
     C                   MOVE      AMSC          BMSC                                         CAP042
     C                   MOVE      BTMST         APTMSS                                       CAP042
      *                                                                                       CAP042
     C                   MOVE      RDTMST        APTMES                                       CAP042
     C                   MOVEL     RDFRNT        APFOTR                                       CAP042
     C                   MOVEL     RDAFRT        APFOAS                                       CAP042
     C                   MOVEL     RDREPA        APRPRL                                       CAP042
     C                   MOVEL     'AB'          APMIDA                                       CAP042
     C                   MOVEL     RDDLNO        APTRAN                                       CAP042
     C                   MOVE      RDACTN        APACTN                                       CAP042
      *                                                                                       CAP042
      ** Write details.                                                                       CAP042
      *                                                                                       CAP042
     C                   WRITE     APINVLD0                                                   CAP042
      *                                                                                       CAP042
      ** Read next record and loop back.                                                      CAP042
      *                                                                                       CAP042
     C                   READ      ABIFUNDPD                              35                  CAP042
      *                                                                                       CAP042
     C                   ENDDO                                                                CAP042
      *                                                                                       CAP042
     C                   ENDSR                                                                CAP042
      *****************************************************************                       CAP042
      /EJECT                                                                                  CAP042
      *****************************************************************                       CAP140
      * ISEDE - Subroutine to process SE Security Diary Events        *                       CAP140
      *                                                               *                       CAP140
      * Called by: MAIN                                               *                       CAP140
      * Calls: None                                                   *                       CAP140
      *****************************************************************                       CAP140
     C     ISEDE         BEGSR                                                                CAP140
      *                                                                                       CAP140
      ** Do first read before main loop.                                                      CAP140
      *                                                                                       CAP140
     C                   READ      SEISEDEPD                              30                  CAP140
      *                                                                                       CAP140
      ** Loop while records read.                                                             CAP140
      *                                                                                       CAP140
     C     *IN30         DOWEQ     '0'                                                        CAP140
      *                                                                                       CAP140
      ** Set output fields.                                                                   CAP140
      *                                                                                       CAP140
     C                   MOVE      DDTMST        ATMST                                        CAP140
     C                   MOVE      AYRS          BYRS                                         CAP140
     C                   MOVE      AMON          BMON                                         CAP140
     C                   MOVE      ADAY          BDAY                                         CAP140
     C                   MOVE      AHRS          BHRS                                         CAP140
     C                   MOVE      AMIN          BMIN                                         CAP140
     C                   MOVE      ASEC          BSEC                                         CAP140
     C                   MOVE      AMSC          BMSC                                         CAP140
     C                   MOVE      BTMST         APTMSS                                       CAP140
      *                                                                                       CAP140
     C                   MOVE      DDTMST        APTMES                                       CAP140
     C                   MOVEL     DDFRNT        APFOTR                                       CAP140
     C                   MOVEL     *Blanks       APFOAS                                       CAP140
     C                   MOVEL     DDREPA        APRPRL                                       CAP140
     C                   MOVEL     'SE'          APMIDA                                       CAP140
     C                   MOVEL     DDSDSN        WSDSN                                        CAP140
     C                   MOVEL     DDSDED        WSDED                                        CAP140
     C                   MOVEL     DDSDET        WSDET                                        CAP140
     C                   MOVEL     WAPTRAN       APTRAN                                       CAP140
     C                   MOVE      DDACTN        APACTN                                       CAP140
      *                                                                                       CAP140
      ** Write details.                                                                       CAP140
      *                                                                                       CAP140
     C                   WRITE     APINVLD0                                                   CAP140
      *                                                                                       CAP140
      ** Read next record and loop back.                                                      CAP140
      *                                                                                       CAP140
     C                   READ      SEISEDEPD                              30                  CAP140
      *                                                                                       CAP140
     C                   ENDDO                                                                CAP140
      *                                                                                       CAP140
     C                   ENDSR                                                                CAP140
      *****************************************************************                       CAP140
      /EJECT                                                                                  CAP140
      *****************************************************************                       CAP067
      * IREPO - Subroutine to process MM REPO Loan and Deposit        *                       CAP067
      *                                                               *                       CAP067
      * Called by: MAIN                                               *                       CAP067
      * Calls: None                                                   *                       CAP067
      *****************************************************************                       CAP067
     C     IREPO         BEGSR                                                                CAP067
      *                                                                                       CAP067
      ** Do first read before main loop.                                                      CAP067
      *                                                                                       CAP067
     C                   READ      MMIRPLDPD                              37                  CAP067
      *                                                                                       CAP067
      ** Loop while records read.                                                             CAP067
      *                                                                                       CAP067
     C     *IN37         DOWEQ     '0'                                                        CAP067
      *                                                                                       CAP067
      ** Set output fields.                                                                   CAP067
      *                                                                                       CAP067
     C                   MOVE      WDTMES        ATMST                                        CAP067
     C                   MOVE      AYRS          BYRS                                         CAP067
     C                   MOVE      AMON          BMON                                         CAP067
     C                   MOVE      ADAY          BDAY                                         CAP067
     C                   MOVE      AHRS          BHRS                                         CAP067
     C                   MOVE      AMIN          BMIN                                         CAP067
     C                   MOVE      ASEC          BSEC                                         CAP067
     C                   MOVE      AMSC          BMSC                                         CAP067
     C                   MOVE      BTMST         APTMSS                                       CAP067
      *                                                                                       CAP067
     C                   MOVE      WDTMES        APTMES                                       CAP067
     C                   MOVEL     WDFOTR        APFOTR                                       CAP067
     C                   MOVEL     WDFOAS        APFOAS                                       CAP067
     C                   MOVEL     WDRPRL        APRPRL                                       CAP067
     C                   MOVEL     'MM'          APMIDA                                       CAP067
     C                   MOVEL     WDDLNO        APTRAN                                       CAP067
     C                   MOVE      WDACTN        APACTN                                       CAP067
      *                                                                                       CAP067
      ** Write details.                                                                       CAP067
      *                                                                                       CAP067
     C                   WRITE     APINVLD0                                                   CAP067
      *                                                                                       CAP067
      ** Read next record and loop back.                                                      CAP067
      *                                                                                       CAP067
     C                   READ      MMIRPLDPD                              37                  CAP067
      *                                                                                       CAP067
     C                   ENDDO                                                                CAP067
      *                                                                                       CAP067
     C                   ENDSR                                                                CAP067
      *****************************************************************                       CAP067
      /EJECT                                                                                  CAP067
      *****************************************************************                       CAP067
      * IBYSL - Subroutine to process Buy-Sell Transaction            *                       CAP067
      *                                                               *                       CAP067
      * Called by: MAIN                                               *                       CAP067
      * Calls: None                                                   *                       CAP067
      *****************************************************************                       CAP067
     C     IBYSL         BEGSR                                                                CAP067
      *                                                                                       CAP067
      ** Do first read before main loop.                                                      CAP067
      *                                                                                       CAP067
     C                   READ      SEIBYSLPD                              38                  CAP067
      *                                                                                       CAP067
      ** Loop while records read.                                                             CAP067
      *                                                                                       CAP067
     C     *IN38         DOWEQ     '0'                                                        CAP067
      *                                                                                       CAP067
      ** Set output fields.                                                                   CAP067
      *                                                                                       CAP067
     C                   MOVE      WWDTMES       ATMST                                        CAP067
     C                   MOVE      AYRS          BYRS                                         CAP067
     C                   MOVE      AMON          BMON                                         CAP067
     C                   MOVE      ADAY          BDAY                                         CAP067
     C                   MOVE      AHRS          BHRS                                         CAP067
     C                   MOVE      AMIN          BMIN                                         CAP067
     C                   MOVE      ASEC          BSEC                                         CAP067
     C                   MOVE      AMSC          BMSC                                         CAP067
     C                   MOVE      BTMST         APTMSS                                       CAP067
      *                                                                                       CAP067
     C                   MOVE      WWDTMES       APTMES                                       CAP067
     C                   MOVEL     WWDFOTR       APFOTR                                       CAP067
     C                   MOVEL     WWDFOAS       APFOAS                                       CAP067
     C                   MOVEL     WWDRPRL       APRPRL                                       CAP067
     C                   MOVEL     'SE'          APMIDA                                       CAP067
     C                   MOVEL     WWDTRTP       APTRAN                                       CAP067
     C                   MOVE      WWDACTN       APACTN                                       CAP067
      *                                                                                       CAP067
      ** Write details.                                                                       CAP067
      *                                                                                       CAP067
     C                   WRITE     APINVLD0                                                   CAP067
      *                                                                                       CAP067
      ** Read next record and loop back.                                                      CAP067
      *                                                                                       CAP067
     C                   READ      SEIBYSLPD                              38                  CAP067
      *                                                                                       CAP067
     C                   ENDDO                                                                CAP067
      *                                                                                       CAP067
     C                   ENDSR                                                                CAP067
      *****************************************************************                       CAP067
      /EJECT                                                                                  CAP166
      *****************************************************************                       CAP166
      * IOTCO - FF Non-Currency OTC Options                           *                       CAP166
      *                                                               *                       CAP166
      * Called by: MAIN                                               *                       CAP166
      * Calls: None                                                   *                       CAP166
      *****************************************************************                       CAP166
                                                                                              CAP166
     C     IOTCO         BEGSR                                                                CAP166
                                                                                              CAP166
      ** Do first read before main loop                                                       CAP166
                                                                                              CAP166
     C                   READ      FFIOTCOPD                              40                  CAP166
                                                                                              CAP166
      ** Loop while records read                                                              CAP166
                                                                                              CAP166
     C                   DOW       *IN40 = '0'                                                CAP166
                                                                                              CAP166
      ** Set output fields                                                                    CAP166
                                                                                              CAP166
     C                   MOVE      XDTMES        ATMST                                        CAP166
     C                   MOVE      AYRS          BYRS                                         CAP166
     C                   MOVE      AMON          BMON                                         CAP166
     C                   MOVE      ADAY          BDAY                                         CAP166
     C                   MOVE      AHRS          BHRS                                         CAP166
     C                   MOVE      AMIN          BMIN                                         CAP166
     C                   MOVE      ASEC          BSEC                                         CAP166
     C                   MOVE      AMSC          BMSC                                         CAP166
     C                   MOVE      BTMST         APTMSS                                       CAP166
                                                                                              CAP166
     C                   MOVE      XDTMES        APTMES                                       CAP166
     C                   MOVEL     XDFOTR        APFOTR                                       CAP166
     C                   MOVEL     XDFOAS        APFOAS                                       CAP166
     C                   MOVEL     XDRPRL        APRPRL                                       CAP166
     C                   MOVEL     'FF'          APMIDA                                       CAP166
     C                   MOVEL     XSTNBR        APTRAN                                       CAP166
     C                   MOVE      XDACTN        APACTN                                       CAP166
                                                                                              CAP166
      ** Write details                                                                        CAP166
                                                                                              CAP166
     C                   WRITE     APINVLD0                                                   CAP166
                                                                                              CAP166
      ** Read next record and loop back                                                       CAP166
                                                                                              CAP166
     C                   READ      FFIOTCOPD                              40                  CAP166
                                                                                              CAP166
     C                   ENDDO                                                                CAP166
                                                                                              CAP166
     C                   ENDSR                                                                CAP166
      *****************************************************************                       CAP166
      /EJECT                                                                                  CAP067
      *****************************************************************                       CAS001
      *                                                               *                       CAS001
      * SRYRAT - SD Yield Rates Details                               *                       CAS001
      *                                                               *                       CAS001
      * Called by: MAIN                                               *                       CAS001
      *                                                               *                       CAS001
      * Calls: None                                                   *                       CAS001
      *                                                               *                       CAS001
      *****************************************************************                       CAS001
                                                                                              CAS001
     C     SRYRAT        BEGSR                                                                CAS001
                                                                                              CAS001
      ** Do first read before main loop                                                       CAS001
                                                                                              CAS001
     C                   READ      SDIYRATPD                              39                  CAS001
                                                                                              CAS001
      ** Loop while records read                                                              CAS001
                                                                                              CAS001
     C     *IN39         DOWEQ     *OFF                                                       CAS001
                                                                                              CAS001
      ** Set output fields                                                                    CAS001
                                                                                              CAS001
     C                   MOVE      #0TMES        ATMST                                        CAS001
     C                   MOVE      AYRS          BYRS                                         CAS001
     C                   MOVE      AMON          BMON                                         CAS001
     C                   MOVE      ADAY          BDAY                                         CAS001
     C                   MOVE      AHRS          BHRS                                         CAS001
     C                   MOVE      AMIN          BMIN                                         CAS001
     C                   MOVE      ASEC          BSEC                                         CAS001
     C                   MOVE      AMSC          BMSC                                         CAS001
     C                   MOVE      BTMST         APTMSS                                       CAS001
      *                                                                                       CAS001
     C                   MOVE      #0TMES        APTMES                                       CAS001
     C                   MOVEL     #0FOTR        APFOTR                                       CAS001
     C                   MOVEL     *BLANKS       APFOAS                                       CAS001
     C                   MOVEL     #0RPRL        APRPRL                                       CAS001
     C                   MOVEL     'SD'          APMIDA                                       CAS001
     C                   EVAL      APTRAN = #0YLDC + #0YCCY + #0YICM                          CAS001
     C                   MOVE      #0ACTN        APACTN                                       CAS001
                                                                                              CAS001
      ** Write details                                                                        CAS001
                                                                                              CAS001
     C                   WRITE     APINVLD0                                                   CAS001
                                                                                              CAS001
      ** Read next record and loop back                                                       CAS001
                                                                                              CAS001
     C                   READ      SDIYRATPD                              39                  CAS001
                                                                                              CAS001
     C                   ENDDO                                                                CAS001
                                                                                              CAS001
     C                   ENDSR                                                                CAS001
                                                                                              CAS001
      *****************************************************************                       CAS001
      /EJECT                                                                                  CAP070
      *****************************************************************                       CAP070
      * IASGN - Subroutine to process LE Assignments                  *                       CAP070
      *                                                               *                       CAP070
      * Called by: MAIN                                               *                       CAP070
      * Calls: None                                                   *                       CAP070
      *****************************************************************                       CAP070
     C     IASGN         BEGSR                                                                CAP070
      *                                                                                       CAP070
      ** Do first read before main loop.                                                      CAP070
      *                                                                                       CAP070
     C                   READ      LEIASGNPD                              43                  CAP070
      *                                                                                       CAP070
      ** Loop while records read.                                                             CAP070
      *                                                                                       CAP070
     C     *IN43         DOWEQ     '0'                                                        CAP070
      *                                                                                       CAP070
      ** Set output fields.                                                                   CAP070
      *                                                                                       CAP070
     C                   MOVE      WDTMES        ATMST                                        CAP070
     C                   MOVE      AYRS          BYRS                                         CAP070
     C                   MOVE      AMON          BMON                                         CAP070
     C                   MOVE      ADAY          BDAY                                         CAP070
     C                   MOVE      AHRS          BHRS                                         CAP070
     C                   MOVE      AMIN          BMIN                                         CAP070
     C                   MOVE      ASEC          BSEC                                         CAP070
     C                   MOVE      AMSC          BMSC                                         CAP070
     C                   MOVE      BTMST         APTMSS                                       CAP070
      *                                                                                       CAP070
     C                   MOVE      WDTMES        APTMES                                       CAP070
     C                   MOVEL     WDFOTR        APFOTR                                       CAP070
     C                   MOVEL     WDFOAS        APFOAS                                       CAP070
     C                   MOVEL     WDRPRL        APRPRL                                       CAP070
     C                   MOVEL     'LE'          APMIDA                                       CAP070
     C                   EVAL      APTRAN = S#PMFC + S#PMFT + S#PMFN + S#ASTS                 CAP070
     C                   MOVE      WDACTN        APACTN                                       CAP070
      *                                                                                       CAP070
      ** Write details.                                                                       CAP070
      *                                                                                       CAP070
     C                   WRITE     APINVLD0                                                   CAP070
      *                                                                                       CAP070
      ** Read next record and loop back.                                                      CAP070
      *                                                                                       CAP070
     C                   READ      LEIASGNPD                              43                  CAP070
      *                                                                                       CAP070
     C                   ENDDO                                                                CAP070
      *                                                                                       CAP070
     C                   ENDSR                                                                CAP070
      *****************************************************************                       CAP070
      /EJECT                                                                                  CAP069
      *****************************************************************                       CAP069
      * IRPRT - Subroutine to process LE Risk Participants            *                       CAP069
      *                                                               *                       CAP069
      * Called by: MAIN                                               *                       CAP069
      * Calls: None                                                   *                       CAP069
      *****************************************************************                       CAP069
     C     IRPRT         BEGSR                                                                CAP069
      *                                                                                       CAP069
      ** Do first read before main loop.                                                      CAP069
      *                                                                                       CAP069
     C                   READ      LEIRPRTPD                              44                  CAP069
      *                                                                                       CAP069
      ** Loop while records read.                                                             CAP069
      *                                                                                       CAP069
     C     *IN44         DOWEQ     '0'                                                        CAP069
      *                                                                                       CAP069
      ** Set output fields.                                                                   CAP069
      *                                                                                       CAP069
     C                   MOVE      WRTMES        ATMST                                        CAP069
     C                   MOVE      AYRS          BYRS                                         CAP069
     C                   MOVE      AMON          BMON                                         CAP069
     C                   MOVE      ADAY          BDAY                                         CAP069
     C                   MOVE      AHRS          BHRS                                         CAP069
     C                   MOVE      AMIN          BMIN                                         CAP069
     C                   MOVE      ASEC          BSEC                                         CAP069
     C                   MOVE      AMSC          BMSC                                         CAP069
     C                   MOVE      BTMST         APTMSS                                       CAP069
      *                                                                                       CAP069
     C                   MOVE      WRTMES        APTMES                                       CAP069
     C                   MOVEL     WRFOTR        APFOTR                                       CAP069
     C                   MOVEL     WRFOAS        APFOAS                                       CAP069
     C                   MOVEL     WRRPRL        APRPRL                                       CAP069
     C                   MOVEL     'LE'          APMIDA                                       CAP069
     C                   EVAL      APTRAN = S#PMFC + S#PMFT + S#PMFN + S#ASTS                 CAP069
     C                   MOVE      WRACTN        APACTN                                       CAP069
      *                                                                                       CAP069
      ** Write details.                                                                       CAP069
      *                                                                                       CAP069
     C                   WRITE     APINVLD0                                                   CAP069
      *                                                                                       CAP069
      ** Read next record and loop back.                                                      CAP069
      *                                                                                       CAP069
     C                   READ      LEIRPRTPD                              44                  CAP069
      *                                                                                       CAP069
     C                   ENDDO                                                                CAP069
      *                                                                                       CAP069
     C                   ENDSR                                                                CAP069
      *****************************************************************                       CAP069
      /EJECT                                                                                  CAP068
      *****************************************************************                       CAP068
      * IFPRT - Subroutine to process LE Funding Participants         *                       CAP068
      *                                                               *                       CAP068
      * Called by: MAIN                                               *                       CAP068
      * Calls: None                                                   *                       CAP068
      *****************************************************************                       CAP068
     C     IFPRT         BEGSR                                                                CAP068
      *                                                                                       CAP068
      ** Do first read before main loop.                                                      CAP068
      *                                                                                       CAP068
     C                   READ      LEIFPRTPD                              45                  CAP068
      *                                                                                       CAP068
      ** Loop while records read.                                                             CAP068
      *                                                                                       CAP068
     C     *IN45         DOWEQ     '0'                                                        CAP068
      *                                                                                       CAP068
      ** Set output fields.                                                                   CAP068
      *                                                                                       CAP068
     C                   MOVE      WPTMES        ATMST                                        CAP068
     C                   MOVE      AYRS          BYRS                                         CAP068
     C                   MOVE      AMON          BMON                                         CAP068
     C                   MOVE      ADAY          BDAY                                         CAP068
     C                   MOVE      AHRS          BHRS                                         CAP068
     C                   MOVE      AMIN          BMIN                                         CAP068
     C                   MOVE      ASEC          BSEC                                         CAP068
     C                   MOVE      AMSC          BMSC                                         CAP068
     C                   MOVE      BTMST         APTMSS                                       CAP068
      *                                                                                       CAP068
     C                   MOVE      WPTMES        APTMES                                       CAP068
     C                   MOVEL     WPFOTR        APFOTR                                       CAP068
     C                   MOVEL     WPFOAS        APFOAS                                       CAP068
     C                   MOVEL     WPRPRL        APRPRL                                       CAP068
     C                   MOVEL     'LE'          APMIDA                                       CAP068
     C                   EVAL      APTRAN = S#PMFC + S#PMFT + S#PMFN                          CAP068
     C                   MOVE      WPACTN        APACTN                                       CAP068
      *                                                                                       CAP068
      ** Write details.                                                                       CAP068
      *                                                                                       CAP068
     C                   WRITE     APINVLD0                                                   CAP068
      *                                                                                       CAP068
      ** Read next record and loop back.                                                      CAP068
      *                                                                                       CAP068
     C                   READ      LEIFPRTPD                              45                  CAP068
      *                                                                                       CAP068
     C                   ENDDO                                                                CAP068
      *                                                                                       CAP068
     C                   ENDSR                                                                CAP068
      *****************************************************************                       CAP068
      /EJECT                                                                                  CAP071
      *****************************************************************                       CAP071
      * IFAMD - Subroutine to process LE Facility Amendments          *                       CAP071
      *                                                               *                       CAP071
      * Called by: MAIN                                               *                       CAP071
      * Calls: None                                                   *                       CAP071
      *****************************************************************                       CAP071
     C     IFAMD         BEGSR                                                                CAP071
      *                                                                                       CAP071
      ** Do first read before main loop.                                                      CAP071
      *                                                                                       CAP071
     C                   READ      LEIFAMDPD                              46                  CAP071
      *                                                                                       CAP071
      ** Loop while records read.                                                             CAP071
      *                                                                                       CAP071
     C     *IN46         DOWEQ     '0'                                                        CAP071
      *                                                                                       CAP071
      ** Set output fields.                                                                   CAP071
      *                                                                                       CAP071
     C                   MOVE      WFTMES        ATMST                                        CAP071
     C                   MOVE      AYRS          BYRS                                         CAP071
     C                   MOVE      AMON          BMON                                         CAP071
     C                   MOVE      ADAY          BDAY                                         CAP071
     C                   MOVE      AHRS          BHRS                                         CAP071
     C                   MOVE      AMIN          BMIN                                         CAP071
     C                   MOVE      ASEC          BSEC                                         CAP071
     C                   MOVE      AMSC          BMSC                                         CAP071
     C                   MOVE      BTMST         APTMSS                                       CAP071
      *                                                                                       CAP071
     C                   MOVE      WFTMES        APTMES                                       CAP071
     C                   MOVEL     WFFOTR        APFOTR                                       CAP071
     C                   MOVEL     WFFOAS        APFOAS                                       CAP071
     C                   MOVEL     WFRPRL        APRPRL                                       CAP071
     C                   MOVEL     'LE'          APMIDA                                       CAP071
     C                   EVAL      APTRAN = S#CSSN + S#FACT + S#FCNO + S#FATP                 CAP071
     C                                      + S#VLDT + S#SQNO                                 CAP071
     C                   MOVE      WFACTN        APACTN                                       CAP071
      *                                                                                       CAP071
      ** Write details.                                                                       CAP071
      *                                                                                       CAP071
     C                   WRITE     APINVLD0                                                   CAP071
      *                                                                                       CAP071
      ** Read next record and loop back.                                                      CAP071
      *                                                                                       CAP071
     C                   READ      LEIFAMDPD                              46                  CAP071
      *                                                                                       CAP071
     C                   ENDDO                                                                CAP071
      *                                                                                       CAP071
     C                   ENDSR                                                                CAP071
      *****************************************************************                       CAP071
      /EJECT                                                                                  CAP072
      *****************************************************************                       CAP072
      * IFEAD - Subroutine to process LE Fees Adjustments             *                       CAP072
      *                                                               *                       CAP072
      * Called by: MAIN                                               *                       CAP072
      * Calls: None                                                   *                       CAP072
      *****************************************************************                       CAP072
     C     IFEAD         BEGSR                                                                CAP072
      *                                                                                       CAP072
      ** Do first read before main loop.                                                      CAP072
      *                                                                                       CAP072
     C                   READ      LEIFEADPD                              41                  CAP072
      *                                                                                       CAP072
      ** Loop while records read.                                                             CAP072
      *                                                                                       CAP072
     C     *IN41         DOWEQ     '0'                                                        CAP072
      *                                                                                       CAP072
      ** Set output fields.                                                                   CAP072
      *                                                                                       CAP072
     C                   MOVE      WATMES        ATMST                                        CAP072
     C                   MOVE      AYRS          BYRS                                         CAP072
     C                   MOVE      AMON          BMON                                         CAP072
     C                   MOVE      ADAY          BDAY                                         CAP072
     C                   MOVE      AHRS          BHRS                                         CAP072
     C                   MOVE      AMIN          BMIN                                         CAP072
     C                   MOVE      ASEC          BSEC                                         CAP072
     C                   MOVE      AMSC          BMSC                                         CAP072
     C                   MOVE      BTMST         APTMSS                                       CAP072
      *                                                                                       CAP072
     C                   MOVE      WATMES        APTMES                                       CAP072
     C                   MOVEL     WAFOTR        APFOTR                                       CAP072
     C                   MOVEL     WAFOAS        APFOAS                                       CAP072
     C                   MOVEL     WARPRL        APRPRL                                       CAP072
     C                   MOVEL     'LE'          APMIDA                                       CAP072
     C                   EVAL      APTRAN = S#CSSN + 'F' + S#FACT +
     C                              S#FCNO + S#FSEQ                                           CAP072
     C                   MOVE      WAACTN        APACTN                                       CAP072
      *                                                                                       CAP072
      ** Write details.                                                                       CAP072
      *                                                                                       CAP072
     C                   WRITE     APINVLD0                                                   CAP072
      *                                                                                       CAP072
      ** Read next record and loop back.                                                      CAP072
      *                                                                                       CAP072
     C                   READ      LEIFEADPD                              41                  CAP072
      *                                                                                       CAP072
     C                   ENDDO                                                                CAP072
      *                                                                                       CAP072
     C                   ENDSR                                                                CAP072
      *****************************************************************                       CAP072
      /EJECT                                                                                  CAP072
      *****************************************************************                       CAP072
      * IFEST - Subroutine to process LE Fees Settlements             *                       CAP072
      *                                                               *                       CAP072
      * Called by: MAIN                                               *                       CAP072
      * Calls: None                                                   *                       CAP072
      *****************************************************************                       CAP072
     C     IFEST         BEGSR                                                                CAP072
      *                                                                                       CAP072
      ** Do first read before main loop.                                                      CAP072
      *                                                                                       CAP072
     C                   READ      LEIFESTPD                              42                  CAP072
      *                                                                                       CAP072
      ** Loop while records read.                                                             CAP072
      *                                                                                       CAP072
     C     *IN42         DOWEQ     '0'                                                        CAP072
      *                                                                                       CAP072
      ** Set output fields.                                                                   CAP072
      *                                                                                       CAP072
     C                   MOVE      WSTMES        ATMST                                        CAP072
     C                   MOVE      AYRS          BYRS                                         CAP072
     C                   MOVE      AMON          BMON                                         CAP072
     C                   MOVE      ADAY          BDAY                                         CAP072
     C                   MOVE      AHRS          BHRS                                         CAP072
     C                   MOVE      AMIN          BMIN                                         CAP072
     C                   MOVE      ASEC          BSEC                                         CAP072
     C                   MOVE      AMSC          BMSC                                         CAP072
     C                   MOVE      BTMST         APTMSS                                       CAP072
      *                                                                                       CAP072
     C                   MOVE      WSTMES        APTMES                                       CAP072
     C                   MOVEL     WSFOTR        APFOTR                                       CAP072
     C                   MOVEL     WSFOAS        APFOAS                                       CAP072
     C                   MOVEL     WSRPRL        APRPRL                                       CAP072
     C                   MOVEL     'LE'          APMIDA                                       CAP072
     C                   EVAL      APTRAN = S#CSSN + 'F' + S#FACT +
     C                              S#FCNO + S#FSEQ + S#VDAT                                  CAP072
     C                   MOVE      WSACTN        APACTN                                       CAP072
      *                                                                                       CAP072
      ** Write details.                                                                       CAP072
      *                                                                                       CAP072
     C                   WRITE     APINVLD0                                                   CAP072
      *                                                                                       CAP072
      ** Read next record and loop back.                                                      CAP072
      *                                                                                       CAP072
     C                   READ      LEIFESTPD                              42                  CAP072
      *                                                                                       CAP072
     C                   ENDDO                                                                CAP072
      *                                                                                       CAP072
     C                   ENDSR                                                                CAP072
      *****************************************************************                       CAP072
      /EJECT                                                                                  CAS001
      *****************************************************************                       CSC011
      * IFCTY - Subroutine to process LE Facility Input               *                       CSC011
      *                                                               *                       CSC011
      * Called by: MAIN                                               *                       CSC011
      * Calls: None                                                   *                       CSC011
      *****************************************************************                       CSC011
     C     IFCTY         BEGSR                                                                CSC011
      *                                                                                       CSC011
      ** Do first read before main loop.                                                      CSC011
      *                                                                                       CSC011
     C                   READ      LEIFACPD                               47                  CSC011
      *                                                                                       CSC011
      ** Loop while records read.                                                             CSC011
      *                                                                                       CSC011
     C     *IN47         DOWEQ     '0'                                                        CSC011
      *                                                                                       CSC011
      ** Set output fields.                                                                   CSC011
      *                                                                                       CSC011
     C                   MOVE      TYTMES        ATMST                                        CSC011
     C                   MOVE      AYRS          BYRS                                         CSC011
     C                   MOVE      AMON          BMON                                         CSC011
     C                   MOVE      ADAY          BDAY                                         CSC011
     C                   MOVE      AHRS          BHRS                                         CSC011
     C                   MOVE      AMIN          BMIN                                         CSC011
     C                   MOVE      ASEC          BSEC                                         CSC011
     C                   MOVE      AMSC          BMSC                                         CSC011
     C                   MOVE      BTMST         APTMSS                                       CSC011
      *                                                                                       CSC011
     C                   MOVE      TYTMES        APTMES                                       CSC011
     C                   MOVEL     TYTNRF        APFOTR                                       CSC011
     C                   MOVEL     'LE'          APMIDA                                       CSC011
     C************       MOVE      WSFCTY        WSFCTY           20 0                 CSC011 CSD027
     C                   MOVE      WSFCTY        WSFCTY           20                          CSD027
     C                   MOVE      *BLANKS       @WXP1             3                          CSD027
     C                   MOVE      *BLANKS       @WXP2             2                          CSD027
     C**************     EVAL      WSFCTY = SFCNM + SFACT + SFCNO                      CSC011 CSD027
     C                   EVAL      WSFCTY = SFCNM + @WXP1 + @WXP2                             CSD027
     C                   MOVEL     WSFCTY        APTRAN                                       CSC011
     C                   MOVE      TYACTN        APACTN                                       CSC011
      *                                                                                       CSC011
      ** Write details.                                                                       CSC011
      *                                                                                       CSC011
     C                   WRITE     APINVLD0                                                   CSC011
      *                                                                                       CSC011
      ** Read next record and loop back.                                                      CSC011
      *                                                                                       CSC011
     C                   READ      LEIFACPD                               47                  CSC011
      *                                                                                       CSC011
     C                   ENDDO                                                                CSC011
      *                                                                                       CSC011
     C                   ENDSR                                                                CSC011
      *****************************************************************                       CSC011
      /EJECT                                                                                  CSC011
      *****************************************************************                       CSC011
      * ILOAN - Subroutine to process LE Loans/Parts Purchased/Parts  *                       CSC011
      *                                                        sold   *                       CSC011
      * Called by: MAIN                                               *                       CSC011
      * Calls: None                                                   *                       CSC011
      *****************************************************************                       CSC011
     C     ILOAN         BEGSR                                                                CSC011
      *                                                                                       CSC011
      ** Do first read before main loop.                                                      CSC011
      *                                                                                       CSC011
     C                   READ      LEILONPD                               48                  CSC011
      *                                                                                       CSC011
      ** Loop while records read.                                                             CSC011
      *                                                                                       CSC011
     C     *IN48         DOWEQ     '0'                                                        CSC011
      *                                                                                       CSC011
      ** Set output fields.                                                                   CSC011
      *                                                                                       CSC011
     C                   MOVE      LOTMES        ATMST                                        CSC011
     C                   MOVE      AYRS          BYRS                                         CSC011
     C                   MOVE      AMON          BMON                                         CSC011
     C                   MOVE      ADAY          BDAY                                         CSC011
     C                   MOVE      AHRS          BHRS                                         CSC011
     C                   MOVE      AMIN          BMIN                                         CSC011
     C                   MOVE      ASEC          BSEC                                         CSC011
     C                   MOVE      AMSC          BMSC                                         CSC011
     C                   MOVE      BTMST         APTMSS                                       CSC011
      *                                                                                       CSC011
     C                   MOVE      LOTMES        APTMES                                       CSC011
     C                   MOVEL     LOTNRF        APFOTR                                       CSC011
     C                   MOVEL     'LE'          APMIDA                                       CSC011
     C                   EVAL      APTRAN = SLNRF                                             CSC011
     C                   MOVE      LOACTN        APACTN                                       CSC011
      *                                                                                       CSC011
      ** Write details.                                                                       CSC011
      *                                                                                       CSC011
     C                   WRITE     APINVLD0                                                   CSC011
      *                                                                                       CSC011
      ** Read next record and loop back.                                                      CSC011
      *                                                                                       CSC011
     C                   READ      LEILONPD                               48                  CSC011
      *                                                                                       CSC011
     C                   ENDDO                                                                CSC011
      *                                                                                       CSC011
     C                   ENDSR                                                                CSC011
      *****************************************************************                       CSC011
      /EJECT                                                                                  CSC011
      *****************************************************************                       CSC011
      * ILOAM - Subroutine to process LE Loan Amendments              *                       CSC011
      *                     - Prinicpal Transfers To                  *                       CSC011
      *                     - Principal Transfers From                *                       CSC011
      *                     - Principal Increase                      *                       CSC011
      *                     - Base Rate Change                        *                       CSC011
      *                     - Spread Change                           *                       CSC011
      *                     - Stop/Start Accrual                      *                       CSC011
      *                     - Loan Subtype Change                     *                       CSC011
      *                                                               *                       CSC011
      * Called by: MAIN                                               *                       CSC011
      * Calls: None                                                   *                       CSC011
      *****************************************************************                       CSC011
     C     ILOAM         BEGSR                                                                CSC011
      *                                                                                       CSC011
      ** Do first read before main loop.                                                      CSC011
      *                                                                                       CSC011
     C                   READ      LEILAMPD                               49                  CSC011
      *                                                                                       CSC011
      ** Loop while records read.                                                             CSC011
      *                                                                                       CSC011
     C     *IN49         DOWEQ     '0'                                                        CSC011
      *                                                                                       CSC011
      ** Set output fields.                                                                   CSC011
      *                                                                                       CSC011
     C                   MOVE      LATMES        ATMST                                        CSC011
     C                   MOVE      AYRS          BYRS                                         CSC011
     C                   MOVE      AMON          BMON                                         CSC011
     C                   MOVE      ADAY          BDAY                                         CSC011
     C                   MOVE      AHRS          BHRS                                         CSC011
     C                   MOVE      AMIN          BMIN                                         CSC011
     C                   MOVE      ASEC          BSEC                                         CSC011
     C                   MOVE      AMSC          BMSC                                         CSC011
     C                   MOVE      BTMST         APTMSS                                       CSC011
      *                                                                                       CSC011
     C                   MOVE      LATMES        APTMES                                       CSC011
     C                   MOVEL     LATNRF        APFOTR                                       CSC011
     C                   MOVEL     'LE'          APMIDA                                       CSC011
     C                   EVAL      APTRAN = SLNRF + SVLDT + SSQNO +SATYP                      CSC011
     C                   MOVE      LAACTN        APACTN                                       CSC011
      *                                                                                       CSC011
      ** Write details.                                                                       CSC011
      *                                                                                       CSC011
     C                   WRITE     APINVLD0                                                   CSC011
      *                                                                                       CSC011
      ** Read next record and loop back.                                                      CSC011
      *                                                                                       CSC011
     C                   READ      LEILAMPD                               49                  CSC011
      *                                                                                       CSC011
     C                   ENDDO                                                                CSC011
      *                                                                                       CSC011
     C                   ENDSR                                                                CSC011
      *****************************************************************                       CSC011
      /EJECT                                                                                  CSC011
      *****************************************************************                       CSC011
      * IROLL - Subroutine to process LE Rollover Inputs              *                       CSC011
      *                                                               *                       CSC011
      *                                                               *                       CSC011
      *                                                               *                       CSC011
      * Called by: MAIN                                               *                       CSC011
      * Calls: None                                                   *                       CSC011
      *****************************************************************                       CSC011
     C     IROLL         BEGSR                                                                CSC011
      *                                                                                       CSC011
      ** Do first read before main loop.                                                      CSC011
      *                                                                                       CSC011
     C                   READ      LEIROLPD                               50                  CSC011
      *                                                                                       CSC011
      ** Loop while records read.                                                             CSC011
      *                                                                                       CSC011
     C     *IN50         DOWEQ     '0'                                                        CSC011
      *                                                                                       CSC011
      ** Set output fields.                                                                   CSC011
      *                                                                                       CSC011
     C                   MOVE      ROTMES        ATMST                                        CSC011
     C                   MOVE      AYRS          BYRS                                         CSC011
     C                   MOVE      AMON          BMON                                         CSC011
     C                   MOVE      ADAY          BDAY                                         CSC011
     C                   MOVE      AHRS          BHRS                                         CSC011
     C                   MOVE      AMIN          BMIN                                         CSC011
     C                   MOVE      ASEC          BSEC                                         CSC011
     C                   MOVE      AMSC          BMSC                                         CSC011
     C                   MOVE      BTMST         APTMSS                                       CSC011
      *                                                                                       CSC011
     C                   MOVE      ROTMES        APTMES                                       CSC011
     C                   MOVEL     ROTNRF        APFOTR                                       CSC011
     C                   MOVEL     'LE'          APMIDA                                       CSC011
     C                   EVAL      APTRAN = SLNRF                                             CSC011
     C                   MOVE      ROACTN        APACTN                                       CSC011
      *                                                                                       CSC011
      ** Write details.                                                                       CSC011
      *                                                                                       CSC011
     C                   WRITE     APINVLD0                                                   CSC011
      *                                                                                       CSC011
      ** Read next record and loop back.                                                      CSC011
      *                                                                                       CSC011
     C                   READ      LEIROLPD                               50                  CSC011
      *                                                                                       CSC011
     C                   ENDDO                                                                CSC011
      *                                                                                       CSC011
     C                   ENDSR                                                                CSC011
      *****************************************************************                       CSC011
      /EJECT                                                                                  CSC011
      *****************************************************************                       CSC011
      * ILAMR - Subroutine to process LE Rollover Inputs              *                       CSC011
      *                                                               *                       CSC011
      *                                                               *                       CSC011
      *                                                               *                       CSC011
      * Called by: MAIN                                               *                       CSC011
      * Calls: None                                                   *                       CSC011
      *****************************************************************                       CSC011
     C     ILAMR         BEGSR                                                                CSC011
      *                                                                                       CSC011
      ** Do first read before main loop.                                                      CSC011
      *                                                                                       CSC011
     C                   READ      LEIMRPPD                               51                  CSC011
      *                                                                                       CSC011
      ** Loop while records read.                                                             CSC011
      *                                                                                       CSC011
     C     *IN51         DOWEQ     '0'                                                        CSC011
      *                                                                                       CSC011
      ** Set output fields.                                                                   CSC011
      *                                                                                       CSC011
     C                   MOVE      MRTMES        ATMST                                        CSC011
     C                   MOVE      AYRS          BYRS                                         CSC011
     C                   MOVE      AMON          BMON                                         CSC011
     C                   MOVE      ADAY          BDAY                                         CSC011
     C                   MOVE      AHRS          BHRS                                         CSC011
     C                   MOVE      AMIN          BMIN                                         CSC011
     C                   MOVE      ASEC          BSEC                                         CSC011
     C                   MOVE      AMSC          BMSC                                         CSC011
     C                   MOVE      BTMST         APTMSS                                       CSC011
      *                                                                                       CSC011
     C                   MOVE      MRTMES        APTMES                                       CSC011
     C                   MOVEL     MRTNRF        APFOTR                                       CSC011
     C                   MOVEL     'LE'          APMIDA                                       CSC011
     C                   EVAL      APTRAN = SLNRF + SVLDT + SSQNO + FAMTP                     CSC011
     C                   MOVE      MRACTN        APACTN                                       CSC011
      *                                                                                       CSC011
      ** Write details.                                                                       CSC011
      *                                                                                       CSC011
     C                   WRITE     APINVLD0                                                   CSC011
      *                                                                                       CSC011
      ** Read next record and loop back.                                                      CSC011
      *                                                                                       CSC011
     C                   READ      LEIMRPPD                               51                  CSC011
      *                                                                                       CSC011
     C                   ENDDO                                                                CSC011
      *                                                                                       CSC011
     C                   ENDSR                                                                CSC011
      *****************************************************************                       CSC011
      /EJECT                                                                                  CSC011
      *****************************************************************                       CSC011
      * IFEES - Subroutine to process LE Fees Inputs                  *                       CSC011
      *                                                               *                       CSC011
      *                                                               *                       CSC011
      *                                                               *                       CSC011
      * Called by: MAIN                                               *                       CSC011
      * Calls: None                                                   *                       CSC011
      *****************************************************************                       CSC011
     C     IFEES         BEGSR                                                                CSC011
      *                                                                                       CSC011
      ** Do first read before main loop.                                                      CSC011
      *                                                                                       CSC011
     C                   READ      LEIFEEPD                               52                  CSC011
      *                                                                                       CSC011
      ** Loop while records read.                                                             CSC011
      *                                                                                       CSC011
     C     *IN52         DOWEQ     '0'                                                        CSC011
      *                                                                                       CSC011
      ** Set output fields.                                                                   CSC011
      *                                                                                       CSC011
     C                   MOVE      FETMES        ATMST                                        CSC011
     C                   MOVE      AYRS          BYRS                                         CSC011
     C                   MOVE      AMON          BMON                                         CSC011
     C                   MOVE      ADAY          BDAY                                         CSC011
     C                   MOVE      AHRS          BHRS                                         CSC011
     C                   MOVE      AMIN          BMIN                                         CSC011
     C                   MOVE      ASEC          BSEC                                         CSC011
     C                   MOVE      AMSC          BMSC                                         CSC011
     C                   MOVE      BTMST         APTMSS                                       CSC011
      *                                                                                       CSC011
     C                   MOVE      FETMES        APTMES                                       CSC011
     C                   MOVEL     FETNRF        APFOTR                                       CSC011
     C                   EVAL      APTRAN = SFCNUM + SFFACT + SFFCNO                          CSC011
     C                                    + SFLNRF + SFFSEQ                                   CSC011
     C                   MOVEL     'LE'          APMIDA                                       CSC011
     C                   MOVE      FEACTN        APACTN                                       CSC011
      *                                                                                       CSC011
      ** Write details.                                                                       CSC011
      *                                                                                       CSC011
     C                   WRITE     APINVLD0                                                   CSC011
      *                                                                                       CSC011
      ** Read next record and loop back.                                                      CSC011
      *                                                                                       CSC011
     C                   READ      LEIFEEPD                               52                  CSC011
      *                                                                                       CSC011
     C                   ENDDO                                                                CSC011
      *                                                                                       CSC011
     C                   ENDSR                                                                CSC011
      *****************************************************************                       CSC011
      /EJECT                                                                                  CSC011
      *****************************************************************                       CAP055
      *                                                               *                       CAP055
      * SRCACF - IR Caps/Collars/Floors Details                       *                       CAP055
      *                                                               *                       CAP055
      * Called by: MAIN                                               *                       CAP055
      *                                                               *                       CAP055
      * Calls: None                                                   *                       CAP055
      *                                                               *                       CAP055
      *****************************************************************                       CAP055
     C     SRCACF        BEGSR                                                                CAP055
                                                                                              CAP055
      ** Do first read before main loop                                                       CAP055
                                                                                              CAP055
     C                   READ      IRICACFPD                              53                  CAP055
                                                                                              CAP055
      ** Loop while records read                                                              CAP055
                                                                                              CAP055
     C     *IN53         DOWEQ     *OFF                                                       CAP055
                                                                                              CAP055
      ** Set output fields                                                                    CAP055
                                                                                              CAP055
     C                   MOVE      IRTMES        ATMST                                        CAP055
     C                   MOVE      AYRS          BYRS                                         CAP055
     C                   MOVE      AMON          BMON                                         CAP055
     C                   MOVE      ADAY          BDAY                                         CAP055
     C                   MOVE      AHRS          BHRS                                         CAP055
     C                   MOVE      AMIN          BMIN                                         CAP055
     C                   MOVE      ASEC          BSEC                                         CAP055
     C                   MOVE      AMSC          BMSC                                         CAP055
     C                   MOVE      BTMST         APTMSS                                       CAP055
      *                                                                                       CAP055
     C                   MOVE      IRTMES        APTMES                                       CAP055
     C                   MOVEL     IRFOID        APFOTR                                       CAP055
     C                   MOVEL     *BLANKS       APFOAS                                       CAP055
     C                   MOVEL     IRLOCN        APRPRL                                       CAP055
     C                   MOVEL     'IR'          APMIDA                                       CAP055
     C                   MOVEL     IRDLNO        APTRAN                                       CAP055
     C                   MOVE      IRACCD        APACTN                                       CAP055
                                                                                              CAP055
      ** Write details                                                                        CAP055
                                                                                              CAP055
     C                   WRITE     APINVLD0                                                   CAP055
                                                                                              CAP055
      ** Read next record and loop back                                                       CAP055
                                                                                              CAP055
     C                   READ      IRICACFPD                              53                  CAP055
                                                                                              CAP055
     C                   ENDDO                                                                CAP055
                                                                                              CAP055
     C                   ENDSR                                                                CAP055
      *****************************************************************                       CAS009
      /EJECT                                                                                  CAS009
      *****************************************************************                       CAS009
      *                                                               *                       CAS009
      * SRDLFE - DL Dealing Fees Details                              *                       CAS009
      *                                                               *                       CAS009
      * Called by: MAIN                                               *                       CAS009
      *                                                               *                       CAS009
      * Calls: None                                                   *                       CAS009
      *                                                               *                       CAS009
      *****************************************************************                       CAS009
     C     SRDLFE        BEGSR                                                                CAS009
                                                                                              CAS009
      ** Do first read before main loop                                                       CAS009
                                                                                              CAS009
     C                   READ      DLIDLFEPD                                                  CAS009
                                                                                              CAS009
      ** Loop until end of DLIDLFEPD file                                                     CAS009
                                                                                              CAS009
     C                   DOU       %EOF(DLIDLFEPD)                                            CAS009
                                                                                              CAS009
      ** Set output fields                                                                    CAS009
                                                                                              CAS009
     C                   MOVE      DDTMST        ATMST                                        CAS009
     C                   MOVE      AYRS          BYRS                                         CAS009
     C                   MOVE      AMON          BMON                                         CAS009
     C                   MOVE      ADAY          BDAY                                         CAS009
     C                   MOVE      AHRS          BHRS                                         CAS009
     C                   MOVE      AMIN          BMIN                                         CAS009
     C                   MOVE      ASEC          BSEC                                         CAS009
     C                   MOVE      AMSC          BMSC                                         CAS009
     C                   MOVE      BTMST         APTMSS                                       CAS009
      *                                                                                       CAS009
     C                   MOVE      DDTMST        APTMES                                       CAS009
     C                   MOVEL     DDFRNT        APFOTR                                       CAS009
     C                   MOVEL     *BLANKS       APFOAS                                       CAS009
     C                   MOVEL     DDREPA        APRPRL                                       CAS009
     C                   MOVEL     'DL'          APMIDA                                       CAS009
     C                   EVAL      APTRAN = DDDLNO + DDFSEQ                                   CAS009
     C                   MOVE      DDACTN        APACTN                                       CAS009
                                                                                              CAS009
      ** Write details                                                                        CAS009
                                                                                              CAS009
     C                   WRITE     APINVLD0                                                   CAS009
                                                                                              CAS009
      ** Read next record and loop back                                                       CAS009
                                                                                              CAS009
     C                   READ      DLIDLFEPD                                                  CAS009
                                                                                              CAS009
     C                   ENDDO                                                                CAS009
                                                                                              CAS009
     C                   ENDSR                                                                CAS009
      *****************************************************************                       CAP055
      /EJECT                                                                                  CAP055
      *****************************************************************                       CSE039
      * IMVTS - Subroutine to process SE Invalid Movements Status     *                       CSE039
      *                                                               *                       CSE039
      * Called by: MAIN                                               *                       CSE039
      * Calls: None                                                   *                       CSE039
      *****************************************************************                       CSE039
     C     IMVTS         BEGSR                                                                CSE039
      *                                                                                       CSE039
      ** Do first read before main loop.                                                      CSE039
      *                                                                                       CSE039
     C                   READ      SEIMVTSD0                                                  CSE039
      *                                                                                       CSE039
      ** Loop while records read.                                                             CSE039
      *                                                                                       CSE039
     C                   DOW       NOT %EOF(SEIMVTSPD)                                        CSE039
      *                                                                                       CSE039
      ** Set output fields.                                                                   CSE039
      *                                                                                       CSE039
     C                   MOVE      DDTMESTMP     ATMST                                        CSE039
     C                   MOVE      AYRS          BYRS                                         CSE039
     C                   MOVE      AMON          BMON                                         CSE039
     C                   MOVE      ADAY          BDAY                                         CSE039
     C                   MOVE      AHRS          BHRS                                         CSE039
     C                   MOVE      AMIN          BMIN                                         CSE039
     C                   MOVE      ASEC          BSEC                                         CSE039
     C                   MOVE      AMSC          BMSC                                         CSE039
     C                   MOVE      BTMST         APTMSS                                       CSE039
      *                                                                                       CSE039
     C                   MOVE      DDTMESTMP     APTMES                                       CSE039
     C                   MOVEL     DDFOTRANID    APFOTR                                       CSE039
     C                   MOVEL     DDFOASOCID    APFOAS                                       CSE039
     C                   MOVEL     DDRPRLOCN     APRPRL                                       CSE039
     C                   MOVEL     'SE'          APMIDA                                       CSE039
     C                   MOVE      DDSQNR        DDSQNR_A          3                          CSE039
     C                   EVAL      APTRAN = DDTRRF + DDTRTY + DDNTDT + DDSQNR_A               CSE039
     C                   MOVE      DDACTN        APACTN                                       CSE039
      *                                                                                       CSE039
      ** Write details.                                                                       CSE039
      *                                                                                       CSE039
     C                   WRITE     APINVLD0                                                   CSE039
      *                                                                                       CSE039
      ** Read next record and loop back.                                                      CSE039
      *                                                                                       CSE039
     C                   READ      SEIMVTSD0                                                  CSE039
      *                                                                                       CSE039
     C                   ENDDO                                                                CSE039
      *                                                                                       CSE039
     C                   ENDSR                                                                CSE039
      *                                                                                       CSE039
      *****************************************************************                       CAP182
      * ITRSM - Subroutine to process SE Trade Settlements            *                       CAP182
      *                                                               *                       CAP182
      * Called by: MAIN                                               *                       CAP182
      * Calls: None                                                   *                       CAP182
      *****************************************************************                       CAP182
     C     ITRSM         BEGSR                                                                CAP182
      *                                                                                       CAP182
      ** Do first read before main loop.                                                      CAP182
      *                                                                                       CAP182
     C                   READ      SEITRSMPD                              30                  CAP182
      *                                                                                       CAP182
      ** Loop while records read.                                                             CAP182
      *                                                                                       CAP182
     C     *IN30         DOWEQ     '0'                                                        CAP182
      *                                                                                       CAP182
      ** Set output fields.                                                                   CAP182
      *                                                                                       CAP182
     C                   MOVE      DDTMST        ATMST                                        CAP182
     C                   MOVE      AYRS          BYRS                                         CAP182
     C                   MOVE      AMON          BMON                                         CAP182
     C                   MOVE      ADAY          BDAY                                         CAP182
     C                   MOVE      AHRS          BHRS                                         CAP182
     C                   MOVE      AMIN          BMIN                                         CAP182
     C                   MOVE      ASEC          BSEC                                         CAP182
     C                   MOVE      AMSC          BMSC                                         CAP182
     C                   MOVE      BTMST         APTMSS                                       CAP182
      *                                                                                       CAP182
     C                   MOVE      DDTMST        APTMES                                       CAP182
     C                   MOVEL     DDFRNT        APFOTR                                       CAP182
     C                   MOVEL     *Blanks       APFOAS                                       CAP182
     C                   MOVEL     DDREPA        APRPRL                                       CAP182
     C                   MOVEL     'SE'          APMIDA                                       CAP182
     C                   MOVEL     DDTRDR        WTRDR                                        CAP182
     C                   MOVEL     DDMVDT        WMVDT                                        CAP182
     C                   MOVEL     DDFSET        WFSET                                        CAP182
     C                   MOVEL     DDREVE        WREVE                                        CAP182
     C                   MOVEL     WWAPTRAN      APTRAN                                       CAP182
     C                   MOVE      'I'           APACTN                                       CAP182
      *                                                                                       CAP182
      ** Write details.                                                                       CAP182
      *                                                                                       CAP182
     C                   WRITE     APINVLD0                                                   CAP182
      *                                                                                       CAP182
      ** Read next record and loop back.                                                      CAP182
      *                                                                                       CAP182
     C                   READ      SEITRSMPD                              30                  CAP182
      *                                                                                       CAP182
     C                   ENDDO                                                                CAP182
      *                                                                                       CAP182
     C                   ENDSR                                                                CAP182
      *****************************************************************                       CAP182
      /EJECT                                                                                  CAP182
      *****************************************************************                       CSE040
      * ISTPR - Subroutine to process SE Invalid Statement Production *                       CSE040
      *         Requests                                              *                       CSE040
      * Called by: MAIN                                               *                       CSE040
      * Calls: None                                                   *                       CSE040
      *****************************************************************                       CSE040
     C     ISTPR         BEGSR                                                                CSE040
      *                                                                                       CSE040
      ** Do first read before main loop.                                                      CSE040
      *                                                                                       CSE040
     C                   READ      SEISTPRD0                                                  CSE040
      *                                                                                       CSE040
      ** Loop while records read.                                                             CSE040
      *                                                                                       CSE040
     C                   DOW       NOT %EOF(SEISTPRPD)                                        CSE040
      *                                                                                       CSE040
      ** Set output fields.                                                                   CSE040
      *                                                                                       CSE040
     C                   MOVE      DDTMESTMP     ATMST                                        CSE040
     C                   MOVE      AYRS          BYRS                                         CSE040
     C                   MOVE      AMON          BMON                                         CSE040
     C                   MOVE      ADAY          BDAY                                         CSE040
     C                   MOVE      AHRS          BHRS                                         CSE040
     C                   MOVE      AMIN          BMIN                                         CSE040
     C                   MOVE      ASEC          BSEC                                         CSE040
     C                   MOVE      AMSC          BMSC                                         CSE040
     C                   MOVE      BTMST         APTMSS                                       CSE040
      *                                                                                       CSE040
     C                   MOVE      DDTMESTMP     APTMES                                       CSE040
     C                   MOVEL     DDFOTRANID    APFOTR                                       CSE040
     C                   MOVEL     DDFOASOCID    APFOAS                                       CSE040
     C                   MOVEL     DDRPRLOCN     APRPRL                                       CSE040
     C                   MOVEL     'SE'          APMIDA                                       CSE040
     C                   EVAL      APTRAN = STPR_CUST + DDTYPE + DDSNDR +                     CSE040
     C                                      DDRECP                                            CSE040
     C                   MOVE      DDACTN        APACTN                                       CSE040
      *                                                                                       CSE040
      ** Write details.                                                                       CSE040
      *                                                                                       CSE040
     C                   WRITE     APINVLD0                                                   CSE040
      *                                                                                       CSE040
      ** Read next record and loop back.                                                      CSE040
      *                                                                                       CSE040
     C                   READ      SEISTPRD0                                                  CSE040
      *                                                                                       CSE040
     C                   ENDDO                                                                CSE040
      *                                                                                       CSE040
     C                   ENDSR                                                                CSE040
      *****************************************************************                       CSE040
      /EJECT                                                                                  CSE040
      *****************************************************************                       CAP073
      * IFCIP - Subroutine to process LE Facility                     *                       CAP073
      *                                                               *                       CAP073
      * Called by: MAIN                                               *                       CAP073
      * Calls: None                                                   *                       CAP073
      *****************************************************************                       CAP073
     C     IFCIP         BEGSR                                                                CAP073
      *                                                                                       CAP073
      ** Do first read before main loop.                                                      CAP073
      *                                                                                       CAP073
     C                   READ      LEIFCIPPD                              43                  CAP073
      *                                                                                       CAP073
      ** Loop while records read.                                                             CAP073
      *                                                                                       CAP073
     C     *IN43         DOWEQ     '0'                                                        CAP073
      *                                                                                       CAP073
      ** Set output fields.                                                                   CAP073
      *                                                                                       CAP073
     C                   MOVE      WQTMES        ATMST                                        CAP073
     C                   MOVE      AYRS          BYRS                                         CAP073
     C                   MOVE      AMON          BMON                                         CAP073
     C                   MOVE      ADAY          BDAY                                         CAP073
     C                   MOVE      AHRS          BHRS                                         CAP073
     C                   MOVE      AMIN          BMIN                                         CAP073
     C                   MOVE      ASEC          BSEC                                         CAP073
     C                   MOVE      AMSC          BMSC                                         CAP073
     C                   MOVE      BTMST         APTMSS                                       CAP073
      *                                                                                       CAP073
     C                   MOVE      WQTMES        APTMES                                       CAP073
     C                   MOVEL     WQFOTR        APFOTR                                       CAP073
     C                   MOVEL     WQFOAS        APFOAS                                       CAP073
     C                   MOVEL     WQRPRL        APRPRL                                       CAP073
     C                   MOVEL     'LE'          APMIDA                                       CAP073
     C                   EVAL      APTRAN = DDCSSN + DDFACT + DDFCNO                          CAP073
     C                   MOVE      WQACTN        APACTN                                       CAP073
      *                                                                                       CAP073
      ** Write details.                                                                       CAP073
      *                                                                                       CAP073
     C                   WRITE     APINVLD0                                                   CAP073
      *                                                                                       CAP073
      ** Read next record and loop back.                                                      CAP073
      *                                                                                       CAP073
     C                   READ      LEIFCIPPD                              43                  CAP073
      *                                                                                       CAP073
     C                   ENDDO                                                                CAP073
      *                                                                                       CAP073
     C                   ENDSR                                                                CAP073
      *****************************************************************                       CAP074
      /EJECT                                                                                  CAP074
      *****************************************************************                       CAP074
      * ICLIP - Subroutine to process LE Loans                        *                       CAP074
      *                                                               *                       CAP074
      * Called by: MAIN                                               *                       CAP074
      * Calls: None                                                   *                       CAP074
      *****************************************************************                       CAP074
     C     ICLIP         BEGSR                                                                CAP074
      *                                                                                       CAP074
      ** Do first read before main loop.                                                      CAP074
      *                                                                                       CAP074
     C                   READ      LEICLIPPD                              44                  CAP074
      *                                                                                       CAP074
      ** Loop while records read.                                                             CAP074
      *                                                                                       CAP074
     C     *IN44         DOWEQ     '0'                                                        CAP074
      *                                                                                       CAP074
      ** Set output fields.                                                                   CAP074
      *                                                                                       CAP074
     C                   MOVE      WQTMES        ATMST                                        CAP074
     C                   MOVE      AYRS          BYRS                                         CAP074
     C                   MOVE      AMON          BMON                                         CAP074
     C                   MOVE      ADAY          BDAY                                         CAP074
     C                   MOVE      AHRS          BHRS                                         CAP074
     C                   MOVE      AMIN          BMIN                                         CAP074
     C                   MOVE      ASEC          BSEC                                         CAP074
     C                   MOVE      AMSC          BMSC                                         CAP074
     C                   MOVE      BTMST         APTMSS                                       CAP074
      *                                                                                       CAP074
     C                   MOVE      WQTMES        APTMES                                       CAP074
     C                   MOVEL     WQFOTR        APFOTR                                       CAP074
     C                   MOVEL     WQFOAS        APFOAS                                       CAP074
     C                   MOVEL     WQRPRL        APRPRL                                       CAP074
     C                   MOVEL     'LE'          APMIDA                                       CAP074
     C                   EVAL      APTRAN = DDLNRF                                            CAP074
     C                   MOVE      WQACTN        APACTN                                       CAP074
      *                                                                                       CAP074
      ** Write details.                                                                       CAP074
      *                                                                                       CAP074
     C                   WRITE     APINVLD0                                                   CAP074
      *                                                                                       CAP074
      ** Read next record and loop back.                                                      CAP074
      *                                                                                       CAP074
     C                   READ      LEICLIPPD                              44                  CAP074
      *                                                                                       CAP074
     C                   ENDDO                                                                CAP074
      *                                                                                       CAP074
     C                   ENDSR                                                                CAP074
      *****************************************************************                       CAP074
      /EJECT                                                                                  CAP075
      *****************************************************************                       CAP075
      * ILAMN - Subroutine to process LE Loan amendments              *                       CAP075
      *                                                               *                       CAP075
      * Called by: MAIN                                               *                       CAP075
      * Calls: None                                                   *                       CAP075
      *****************************************************************                       CAP075
     C     ILAMN         BEGSR                                                                CAP075
      *                                                                                       CAP075
      ** Do first read before main loop.                                                      CAP075
      *                                                                                       CAP075
     C                   READ      LEILOAMPD                              46                  CAP075
      *                                                                                       CAP075
      ** Loop while records read.                                                             CAP075
      *                                                                                       CAP075
     C     *IN44         DOWEQ     '0'                                                        CAP075
      *                                                                                       CAP075
      ** Set output fields.                                                                   CAP075
      *                                                                                       CAP075
     C                   MOVE      WRSTMP        ATMST                                        CAP075
     C                   MOVE      AYRS          BYRS                                         CAP075
     C                   MOVE      AMON          BMON                                         CAP075
     C                   MOVE      ADAY          BDAY                                         CAP075
     C                   MOVE      AHRS          BHRS                                         CAP075
     C                   MOVE      AMIN          BMIN                                         CAP075
     C                   MOVE      ASEC          BSEC                                         CAP075
     C                   MOVE      AMSC          BMSC                                         CAP075
     C                   MOVE      BTMST         APTMSS                                       CAP075
      *                                                                                       CAP075
     C                   MOVE      WRSTMP        APTMES                                       CAP075
     C                   MOVEL     WRFRNT        APFOTR                                       CAP075
     C                   MOVEL     WRAFRT        APFOAS                                       CAP075
     C                   MOVEL     WRREPR        APRPRL                                       CAP075
     C                   MOVEL     'LE'          APMIDA                                       CAP075
     C                   EVAL      APTRAN = DDLOAN                                            CAP075
     C                   MOVE      WRACTN        APACTN                                       CAP075
      *                                                                                       CAP075
      ** Write details.                                                                       CAP075
      *                                                                                       CAP075
     C                   WRITE     APINVLD0                                                   CAP075
      *                                                                                       CAP075
      ** Read next record and loop back.                                                      CAP075
      *                                                                                       CAP075
     C                   READ      LEILOAMPD                              44                  CAP075
      *                                                                                       CAP075
     C                   ENDDO                                                                CAP075
      *                                                                                       CAP075
     C                   ENDSR                                                                CAP075
      *****************************************************************                       CAP075
      /EJECT                                                                                  CAP076
      *****************************************************************                       CAP076
      * ILERI - Subroutine to process LE Rollover Instructions        *                       CAP076
      *                                                               *                       CAP076
      * Called by: MAIN                                               *                       CAP076
      * Calls: None                                                   *                       CAP076
      *****************************************************************                       CAP076
     C     ILERI         BEGSR                                                                CAP076
      *                                                                                       CAP076
      ** Do first read before main loop.                                                      CAP076
      *                                                                                       CAP076
     C                   READ      LEILERIPD                              44                  CAP076
      *                                                                                       CAP076
      ** Loop while records read.                                                             CAP076
      *                                                                                       CAP076
     C     *IN44         DOWEQ     '0'                                                        CAP076
      *                                                                                       CAP076
      ** Set output fields.                                                                   CAP076
      *                                                                                       CAP076
     C                   MOVE      WLTMES        ATMST                                        CAP076
     C                   MOVE      AYRS          BYRS                                         CAP076
     C                   MOVE      AMON          BMON                                         CAP076
     C                   MOVE      ADAY          BDAY                                         CAP076
     C                   MOVE      AHRS          BHRS                                         CAP076
     C                   MOVE      AMIN          BMIN                                         CAP076
     C                   MOVE      ASEC          BSEC                                         CAP076
     C                   MOVE      AMSC          BMSC                                         CAP076
     C                   MOVE      BTMST         APTMSS                                       CAP076
      *                                                                                       CAP076
     C                   MOVE      WLTMES        APTMES                                       CAP076
     C                   MOVEL     WLFOTR        APFOTR                                       CAP076
     C                   MOVEL     WLFOAS        APFOAS                                       CAP076
     C                   MOVEL     WLRPRL        APRPRL                                       CAP076
     C                   MOVEL     'LE'          APMIDA                                       CAP076
     C                   EVAL      APTRAN = DDLNRF                                            CAP076
     C                   MOVE      WLACTN        APACTN                                       CAP076
      *                                                                                       CAP076
      ** Write details.                                                                       CAP076
      *                                                                                       CAP076
     C                   WRITE     APINVLD0                                                   CAP076
      *                                                                                       CAP076
      ** Read next record and loop back.                                                      CAP076
      *                                                                                       CAP076
     C                   READ      LEILERIPD                              45                  CAP076
      *                                                                                       CAP076
     C                   ENDDO                                                                CAP076
      *                                                                                       CAP076
     C                   ENDSR                                                                CAP076
      *****************************************************************                       CAP076
      *****************************************************************                       CAP077
      * IMAPY - Subroutine to process LE Manual payments              *                       CAP077
      *                                                               *                       CAP077
      * Called by: MAIN                                               *                       CAP077
      * Calls: None                                                   *                       CAP077
      *****************************************************************                       CAP077
     C     IMAPY         BEGSR                                                                CAP077
      *                                                                                       CAP077
      ***  Do first read before main loop.                                                    CAP077
      *                                                                                       CAP077
     C                   READ      LEIMAPYPD                              48                  CAP077
      *                                                                                       CAP077
      ***  Loop while records read.                                                           CAP077
      *                                                                                       CAP077
     C     *IN48         DOWEQ     '0'                                                        CAP077
      *                                                                                       CAP077
      ***  Set output fields.                                                                 CAP077
      *                                                                                       CAP077
     C                   MOVE      WLTMES        ATMST                                        CAP077
     C                   MOVE      AYRS          BYRS                                         CAP077
     C                   MOVE      AMON          BMON                                         CAP077
     C                   MOVE      ADAY          BDAY                                         CAP077
     C                   MOVE      AHRS          BHRS                                         CAP077
     C                   MOVE      AMIN          BMIN                                         CAP077
     C                   MOVE      ASEC          BSEC                                         CAP077
     C                   MOVE      AMSC          BMSC                                         CAP077
     C                   MOVE      BTMST         APTMSS                                       CAP077
      *                                                                                       CAP077
     C                   MOVE      WLTMES        APTMES                                       CAP077
     C                   MOVEL     WLFOTR        APFOTR                                       CAP077
     C                   MOVEL     WLFOAS        APFOAS                                       CAP077
     C                   MOVEL     WLRPRL        APRPRL                                       CAP077
     C                   MOVEL     'LE'          APMIDA                                       CAP077
     C                   EVAL      APTRAN = DDLNRF + DDVDAT + DDSEQN                          CAP077
     C                   MOVE      WLACTN        APACTN                                       CAP077
      *                                                                                       CAP077
      ***  Write details.                                                                     CAP077
      *                                                                                       CAP077
     C                   WRITE     APINVLD0                                                   CAP077
      *                                                                                       CAP077
      ***  Read next record and loop back.                                                    CAP077
      *                                                                                       CAP077
     C                   READ      LEIMAPYPD                              47                  CAP077
      *                                                                                       CAP077
     C                   ENDDO                                                                CAP077
      *                                                                                       CAP077
     C                   ENDSR                                                                CAP077
      *****************************************************************                       CAP077
      /EJECT                                                                                  CAP078
      *****************************************************************                       CAP078
      * IFEEM - Subroutine to process LE Fee input                    *                       CAP078
      *                                                               *                       CAP078
      * Called by: MAIN                                               *                       CAP078
      * Calls: None                                                   *                       CAP078
      *****************************************************************                       CAP078
     C     IFEEM         BEGSR                                                                CAP078
      *                                                                                       CAP078
      ***  Do first read before main loop.                                                    CAP078
      *                                                                                       CAP078
     C                   READ      LEIFEEMPD                              49                  CAP078
      *                                                                                       CAP078
      ***  Loop while records read.                                                           CAP078
      *                                                                                       CAP078
     C     *IN48         DOWEQ     '0'                                                        CAP078
      *                                                                                       CAP078
      ***  Set output fields.                                                                 CAP078
      *                                                                                       CAP078
     C                   MOVE      WLTMES        ATMST                                        CAP078
     C                   MOVE      AYRS          BYRS                                         CAP078
     C                   MOVE      AMON          BMON                                         CAP078
     C                   MOVE      ADAY          BDAY                                         CAP078
     C                   MOVE      AHRS          BHRS                                         CAP078
     C                   MOVE      AMIN          BMIN                                         CAP078
     C                   MOVE      ASEC          BSEC                                         CAP078
     C                   MOVE      AMSC          BMSC                                         CAP078
     C                   MOVE      BTMST         APTMSS                                       CAP078
      *                                                                                       CAP078
     C                   MOVE      WLTMES        APTMES                                       CAP078
     C                   MOVEL     WLFOTR        APFOTR                                       CAP078
     C                   MOVEL     WLFOAS        APFOAS                                       CAP078
     C                   MOVEL     WLRPRL        APRPRL                                       CAP078
     C                   MOVEL     'LE'          APMIDA                                       CAP078
     C                   EVAL      APTRAN = LEDDCSSN + LEDDFACT + LEDDFCNO +                  CAP078
     C                                      LEDDLNRF + LEDDFSEQ                               CAP078
     C                   MOVE      WLACTN        APACTN                                       CAP078
      *                                                                                       CAP078
      ***  Write details.                                                                     CAP078
      *                                                                                       CAP078
     C                   WRITE     APINVLD0                                                   CAP078
      *                                                                                       CAP078
      ***  Read next record and loop back.                                                    CAP078
      *                                                                                       CAP078
     C                   READ      LEIFEEMPD                              49                  CAP078
      *                                                                                       CAP078
     C                   ENDDO                                                                CAP078
      *                                                                                       CAP078
     C                   ENDSR                                                                CAP078
      *****************************************************************                       CAP078
      /EJECT                                                                                  CAP078
      /EJECT                                                                                  CAP079
      *****************************************************************                       CAP079
      * IRPSC - Subroutine to process LE Repayments schedule          *                       CAP079
      *                                                               *                       CAP079
      * Called by: MAIN                                               *                       CAP079
      * Calls: None                                                   *                       CAP079
      *****************************************************************                       CAP079
     C     IRPSC         BEGSR                                                                CAP079
      *                                                                                       CAP079
      ***  Do first read before main loop.                                                    CAP079
      *                                                                                       CAP079
     C                   READ      LEIRPSCPD                              47                  CAP079
      *                                                                                       CAP079
      ***  Loop while records read.                                                           CAP079
      *                                                                                       CAP079
     C     *IN47         DOWEQ     '0'                                                        CAP079
      *                                                                                       CAP079
      ***  Set output fields.                                                                 CAP079
      *                                                                                       CAP079
     C                   MOVE      WLTMES        ATMST                                        CAP079
     C                   MOVE      AYRS          BYRS                                         CAP079
     C                   MOVE      AMON          BMON                                         CAP079
     C                   MOVE      ADAY          BDAY                                         CAP079
     C                   MOVE      AHRS          BHRS                                         CAP079
     C                   MOVE      AMIN          BMIN                                         CAP079
     C                   MOVE      ASEC          BSEC                                         CAP079
     C                   MOVE      AMSC          BMSC                                         CAP079
     C                   MOVE      BTMST         APTMSS                                       CAP079
      *                                                                                       CAP079
     C                   MOVE      WLTMES        APTMES                                       CAP079
     C                   MOVEL     WLFOTR        APFOTR                                       CAP079
     C                   MOVEL     WLFOAS        APFOAS                                       CAP079
     C                   MOVEL     WLRPRL        APRPRL                                       CAP079
     C                   MOVEL     'LE'          APMIDA                                       CAP079
     C                   EVAL      APTRAN = DDLNRF + DDVDAT + DDSEQN                          CAP079
     C                   MOVE      WLACTN        APACTN                                       CAP079
      *                                                                                       CAP079
      ***  Write details.                                                                     CAP079
      *                                                                                       CAP079
     C                   WRITE     APINVLD0                                                   CAP079
      *                                                                                       CAP079
      ***  Read next record and loop back.                                                    CAP079
      *                                                                                       CAP079
     C                   READ      LEIRPSCPD                              47                  CAP079
      *                                                                                       CAP079
     C                   ENDDO                                                                CAP079
      *                                                                                       CAP079
     C                   ENDSR                                                                CAP079
      *****************************************************************                       CAP079
      /EJECT                                                                                  CAP077
      *****************************************************************                       CGL032
      * IACUD - SD Additional Customer Details                        *                       CGL032
      *                                                               *                       CGL032
      * Called by: MAIN                                               *                       CGL032
      * Calls: None                                                   *                       CGL032
      *****************************************************************                       CGL032
     C     IACUD         BEGSR                                                                CGL032
                                                                                              CGL032
      ** Do first read before main loop                                                       CGL032
                                                                                              CGL032
     C                   READ      SDIACUDPD                              56                  CGL032
                                                                                              CGL032
      ** Loop while records read                                                              CGL032
                                                                                              CGL032
     C     *IN56         DOWEQ     '0'                                                        CGL032
                                                                                              CGL032
      ** Set output fields                                                                    CGL032
                                                                                              CGL032
     C                   MOVE      QDTMST        ATMST                                        CGL032
     C                   MOVE      AYRS          BYRS                                         CGL032
     C                   MOVE      AMON          BMON                                         CGL032
     C                   MOVE      ADAY          BDAY                                         CGL032
     C                   MOVE      AHRS          BHRS                                         CGL032
     C                   MOVE      AMIN          BMIN                                         CGL032
     C                   MOVE      ASEC          BSEC                                         CGL032
     C                   MOVE      AMSC          BMSC                                         CGL032
     C                   MOVE      BTMST         APTMSS                                       CGL032
                                                                                              CGL032
     C                   MOVE      QDTMST        APTMES                                       CGL032
     C                   MOVEL     QDFRNT        APFOTR                                       CGL032
     C                   MOVEL     *BLANKS       APFOAS                                       CGL032
     C                   MOVEL     QDREPA        APRPRL                                       CGL032
     C                   MOVEL     'SD'          APMIDA                                       CGL032
     C                   MOVEL     QDCUST        APTRAN                                       CGL032
     C                   MOVE      QDACTN        APACTN                                       CGL032
                                                                                              CGL032
      ** Write details                                                                        CGL032
                                                                                              CGL032
     C                   WRITE     APINVLD0                                                   CGL032
                                                                                              CGL032
      ** Read next record and loop back                                                       CGL032
                                                                                              CGL032
     C                   READ      SDIACUDPD                              56                  CGL032
                                                                                              CGL032
     C                   ENDDO                                                                CGL032
                                                                                              CGL032
     C                   ENDSR                                                                CGL032
      *****************************************************************                       CGL032
      /EJECT                                                                                  CGL032
      *****************************************************************                       CGL032
      * INAHL - SD Non-A/C Holders Details                            *                       CGL032
      *                                                               *                       CGL032
      * Called by: MAIN                                               *                       CGL032
      * Calls: None                                                   *                       CGL032
      *****************************************************************                       CGL032
     C     INAHL         Begsr                                                                CGL032
                                                                                              CGL032
      ** Do first read before main loop                                                       CGL032
                                                                                              CGL032
     C                   Read      SDINAHLPD                              37                  CGL032
                                                                                              CGL032
      ** Loop while records read                                                              CGL032
                                                                                              CGL032
     C     *IN37         Doweq     '0'                                                        CGL032
                                                                                              CGL032
      ** Set output fields                                                                    CGL032
                                                                                              CGL032
     C                   Move      QDTMST        ATMST                                        CGL032
     C                   Move      AYRS          BYRS                                         CGL032
     C                   Move      AMON          BMON                                         CGL032
     C                   Move      ADAY          BDAY                                         CGL032
     C                   Move      AHRS          BHRS                                         CGL032
     C                   Move      AMIN          BMIN                                         CGL032
     C                   Move      ASEC          BSEC                                         CGL032
     C                   Move      AMSC          BMSC                                         CGL032
     C                   Move      BTMST         APTMSS                                       CGL032
                                                                                              CGL032
     C                   Move      QDTMST        APTMES                                       CGL032
     C                   MoveL     QDFRNT        APFOTR                                       CGL032
     C                   MoveL     *BLANKS       APFOAS                                       CGL032
     C                   MoveL     QDREPA        APRPRL                                       CGL032
     C                   MoveL     'SD'          APMIDA                                       CGL032
     C                   MoveL     QDNAHO        APTRAN                                       CGL032
     C                   Move      QDACTN        APACTN                                       CGL032
                                                                                              CGL032
      ** Write details                                                                        CGL032
                                                                                              CGL032
     C                   Write     APINVLD0                                                   CGL032
                                                                                              CGL032
      ** Read next record and loop back                                                       CGL032
                                                                                              CGL032
     C                   Read      SDINAHLPD                              37                  CGL032
                                                                                              CGL032
     C                   Enddo                                                                CGL032
                                                                                              CGL032
     C                   Endsr                                                                CGL032
      *****************************************************************                       CGL032
      /EJECT                                                                                  CGL032
      *****************************************************************                       CGL032
      *                                                               *                       CGL032
      *  SRIJAcM - Invalid Joint A/c Member Details.                  *                       CGL032
      *                                                               *                       CGL032
      *****************************************************************                       CGL032
     C     SRIJAcM       BEGSR                                                                CGL032
                                                                                              CGL032
     C                   READ      SDIJACMPD                                                  CGL032
                                                                                              CGL032
     C                   DOW       NOT %EOF                                                   CGL032
                                                                                              CGL032
     C                   MOVE      QDTMST        ATMST                                        CGL032
     C                   MOVE      AYRS          BYRS                                         CGL032
     C                   MOVE      AMON          BMON                                         CGL032
     C                   MOVE      ADAY          BDAY                                         CGL032
     C                   MOVE      AHRS          BHRS                                         CGL032
     C                   MOVE      AMIN          BMIN                                         CGL032
     C                   MOVE      ASEC          BSEC                                         CGL032
     C                   MOVE      AMSC          BMSC                                         CGL032
     C                   MOVE      BTMST         APTMSS                                       CGL032
                                                                                              CGL032
     C                   MOVE      QDTMST        APTMES                                       CGL032
     C                   MOVEL     QDFRNT        APFOTR                                       CGL032
     C                   MOVEL     *BLANKS       APFOAS                                       CGL032
     C                   MOVEL     QDREPA        APRPRL                                       CGL032
     C                   MOVEL     'SD'          APMIDA                                       CGL032
     C                   EVAL      APDLNO = *BLANKS                                           CGL032
     C                   MOVE      QDACTN        APACTN                                       CGL032
                                                                                              CGL032
     C                   IF        QDCUST <> *BLANKS                                          CGL032
     C                   EVAL      APTRAN = QDJANO + QDCUST                                   CGL032
     C                   ELSE                                                                 CGL032
     C                   EVAL      APTRAN = QDJANO + QDNAHO                                   CGL032
     C                   ENDIF                                                                CGL032
                                                                                              CGL032
     C                   WRITE     APINVLD0                                                   CGL032
                                                                                              CGL032
     C                   READ      SDIJACMPD                                                  CGL032
     C                   ENDDO                                                                CGL032
                                                                                              CGL032
     C                   ENDSR                                                                CGL032
      *****************************************************************                       CGL032
      /EJECT                                                                                  CGL032
      *****************************************************************                       CGL032
      * INATX - SD Non-A/C Holders Details by Country of Tax          *                       CGL032
      *                                                               *                       CGL032
      * Called by: MAIN                                               *                       CGL032
      * Calls: None                                                   *                       CGL032
      *****************************************************************                       CGL032
     C     INATX         Begsr                                                                CGL032
                                                                                              CGL032
      ** Do first read before main loop                                                       CGL032
                                                                                              CGL032
     C                   Read      SDINATXPD                              55                  CGL032
                                                                                              CGL032
      ** Loop while records read                                                              CGL032
                                                                                              CGL032
     C     *IN55         Doweq     '0'                                                        CGL032
                                                                                              CGL032
      ** Set output fields                                                                    CGL032
                                                                                              CGL032
     C                   Move      QDTMST        ATMST                                        CGL032
     C                   Move      AYRS          BYRS                                         CGL032
     C                   Move      AMON          BMON                                         CGL032
     C                   Move      ADAY          BDAY                                         CGL032
     C                   Move      AHRS          BHRS                                         CGL032
     C                   Move      AMIN          BMIN                                         CGL032
     C                   Move      ASEC          BSEC                                         CGL032
     C                   Move      AMSC          BMSC                                         CGL032
     C                   Move      BTMST         APTMSS                                       CGL032
                                                                                              CGL032
     C                   Move      QDTMST        APTMES                                       CGL032
     C                   MoveL     QDFRNT        APFOTR                                       CGL032
     C                   MoveL     *BLANKS       APFOAS                                       CGL032
     C                   MoveL     QDREPA        APRPRL                                       CGL032
     C                   MoveL     'SD'          APMIDA                                       CGL032
     C                   MoveL     QDNAHO        APTRAN                                       CGL032
     C                   Move      QDACTN        APACTN                                       CGL032
                                                                                              CGL032
      ** Write details                                                                        CGL032
                                                                                              CGL032
     C                   Write     APINVLD0                                                   CGL032
                                                                                              CGL032
      ** Read next record and loop back                                                       CGL032
                                                                                              CGL032
     C                   Read      SDINATXPD                              55                  CGL032
                                                                                              CGL032
     C                   Enddo                                                                CGL032
                                                                                              CGL032
     C                   Endsr                                                                CGL032
      *****************************************************************                       CGL032
      /EJECT                                                                                  CGL032
      *****************************************************************                       233205
      * SRICCTX - SD Custoner Detqils by Country of Tax               *                       233205
      *                                                               *                       233205
      * Called by: MAIN                                               *                       233205
      * Calls: None                                                   *                       233205
      *****************************************************************                       233205
     C     SRICCTX       BEGSR                                                                233205
                                                                                              233205
      ** Do first read before main loop                                                       233205
     C                   READ      SDICCTXPD                              57                  233205
                                                                                              233205
      ** Loop while records read                                                              233205
     C     *IN57         DOWEQ     *OFF                                                       233205
                                                                                              233205
      ** Set output fields                                                                    233205
                                                                                              233205
     C                   MOVE      QDTMST        ATMST                                        233205
     C                   MOVE      AYRS          BYRS                                         233205
     C                   MOVE      AMON          BMON                                         233205
     C                   MOVE      ADAY          BDAY                                         233205
     C                   MOVE      AHRS          BHRS                                         233205
     C                   MOVE      AMIN          BMIN                                         233205
     C                   MOVE      ASEC          BSEC                                         233205
     C                   MOVE      AMSC          BMSC                                         233205
     C                   MOVE      BTMST         APTMSS                                       233205
                                                                                              233205
     C                   MOVE      QDTMST        APTMES                                       233205
     C                   MOVEL     QDFRNT        APFOTR                                       233205
     C                   MOVEL     *BLANKS       APFOAS                                       233205
     C                   MOVEL     QDREPA        APRPRL                                       233205
     C                   MOVEL     'SD'          APMIDA                                       233205
     C                   MOVEL     QDCUST        APTRAN                                       233205
     C                   MOVE      QDACTN        APACTN                                       233205
                                                                                              233205
      ** Write details                                                                        233205
     C                   WRITE     APINVLD0                                                   233205
                                                                                              233205
      ** Read next record and loop back                                                       233205
     C                   READ      SDICCTXPD                              57                  233205
                                                                                              233205
     C                   ENDDO                                                                233205
                                                                                              233205
     C                   ENDSR                                                                233205
      *****************************************************************                       233205
      /EJECT                                                                                  CAP183
      *****************************************************************                       CAP183
      * IMPRI - Subroutine to process FF Market Price                 *                       CAP183
      *                                                               *                       CAP183
      * Called by: MAIN                                               *                       CAP183
      * Calls: None                                                   *                       CAP183
      *****************************************************************                       CAP183
     C     IMPRI         BEGSR                                                                CAP183
      *                                                                                       CAP183
      ***  Do first read before main loop.                                                    CAP183
      *                                                                                       CAP183
     C                   READ      FFIMPRIPD                              58                  CAP183
      *                                                                                       CAP183
      ***  Loop while records read.                                                           CAP183
      *                                                                                       CAP183
     C     *IN58         DOWEQ     '0'                                                        CAP183
      *                                                                                       CAP183
      ***  Set output fields.                                                                 CAP183
      *                                                                                       CAP183
     C                   MOVE      DITMST        ATMST                                        CAP183
     C                   MOVE      AYRS          BYRS                                         CAP183
     C                   MOVE      AMON          BMON                                         CAP183
     C                   MOVE      ADAY          BDAY                                         CAP183
     C                   MOVE      AHRS          BHRS                                         CAP183
     C                   MOVE      AMIN          BMIN                                         CAP183
     C                   MOVE      ASEC          BSEC                                         CAP183
     C                   MOVE      AMSC          BMSC                                         CAP183
     C                   MOVE      BTMST         APTMSS                                       CAP183
      *                                                                                       CAP183
     C                   MOVE      DITMST        APTMES                                       CAP183
     C                   MOVEL     DIFRNT        APFOTR                                       CAP183
     C                   MOVEL     DIAFRT        APFOAS                                       CAP183
     C                   MOVEL     DIREPA        APRPRL                                       CAP183
     C                   MOVEL     'FF'          APMIDA                                       CAP183
     C                   EVAL      APTRAN = DIMRKT + DIISTC + DIMTHN +                        CAP183
     C                                      DIYRNO + DIPCAL                                   CAP183
     C                   MOVE      DIACTN        APACTN                                       CAP183
      *                                                                                       CAP183
      ***  Write details.                                                                     CAP183
      *                                                                                       CAP183
     C                   WRITE     APINVLD0                                                   CAP183
      *                                                                                       CAP183
      ***  Read next record and loop back.                                                    CAP183
      *                                                                                       CAP183
     C                   READ      FFIMPRIPD                              58                  CAP183
      *                                                                                       CAP183
     C                   ENDDO                                                                CAP183
      *                                                                                       CAP183
     C                   ENDSR                                                                CAP183
      *****************************************************************                       CAP183
      /EJECT                                                                                  233205
      *****************************************************************
      *                                                               *
      * INIT - Initialisation routine                                 *
      *                                                               *
      * Called by: MAIN                                               *
      * Calls:     *PSSR                                              *
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Set up copyright parameter
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Define LDA
     C     *DTAARA       DEFINE                  LDA
                                                                                              CAS001
      ** Check if CAS001 is installed                                                         CAS001
                                                                                              CAS001
     C                   CALL      'AOSARDR0'                                                 CAS001
     C                   PARM      *BLANKS       PRtCd                                        CAS001
     C                   PARM      '*VERIFY'     POptn                                        CAS001
     C                   PARM      'CAS001'      PSarD                                        CAS001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS001
                                                                                              CAS001
     C     PRtCd         IFEQ      *BLANK                                                     CAS001
     C                   MOVEL     'Y'           CAS001                                       CAS001
     C                   ELSE                                                                 CAS001
     C                   MOVEL     'N'           CAS001                                       CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS009
      ** Check if CAS009 is installed                                                         CAS009
                                                                                              CAS009
     C                   CALL      'AOSARDR0'                                                 CAS009
     C                   PARM      *BLANKS       PRtCd                                        CAS009
     C                   PARM      '*VERIFY'     POptn                                        CAS009
     C                   PARM      'CAS009'      PSarD                                        CAS009
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS009
                                                                                              CAS009
     C     PRtCd         IFEQ      *BLANK                                                     CAS009
     C                   MOVEL     'Y'           CAS009                                       CAS009
     C                   ELSE                                                                 CAS009
     C                   MOVEL     'N'           CAS009                                       CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CGL032
      ** Check if CGL032 is enabled.                                                          CGL032
                                                                                              CGL032
     C                   CALL      'AOSARDR0'                                                 CGL032
     C                   PARM      *BLANKS       PRtCd                                        CGL032
     C                   PARM      '*VERIFY'     POptn                                        CGL032
     C                   PARM      'CGL032'      PSARD                                        CGL032
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL032
                                                                                              CGL032
     C                   IF        PRtCd = *BLANKS                                            CGL032
     C                   EVAL      CGL032 = 'Y'                                               CGL032
     C                   ELSE                                                                 CGL032
                                                                                              CGL032
     C                   IF        PRtCd <> '*NRF   '                                         CGL032
     C     *LOCK         IN        LDA                                                        CGL032
     C                   EVAL      DBFile = 'SCSARDPD'                                        CGL032
     C                   EVAL      DBKey = PSARD                                              CGL032
     C                   EVAL      DBase = 101                                                CGL032
     C                   OUT       LDA                                                        CGL032
     C                   EXSR      *PSSR                                                      CGL032
     C                   ENDIF                                                                CGL032
                                                                                              CGL032
     C                   ENDIF                                                                CGL032
      *
      ** Check if CAP183 is enabled.                                                          CAP183
                                                                                              CAP183
     C                   CALL      'AOSARDR0'                                                 CAP183
     C                   PARM      *BLANKS       PRtCd                                        CAP183
     C                   PARM      '*VERIFY'     POptn                                        CAP183
     C                   PARM      'CAP183'      PSARD                                        CAP183
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP183
                                                                                              CAP183
     C                   IF        PRtCd = *BLANKS                                            CAP183
     C                   EVAL      CAP183 = 'Y'                                               CAP183
     C                   ELSE                                                                 CAP183
                                                                                              CAP183
     C                   IF        PRtCd <> '*NRF   '                                         CAP183
     C     *LOCK         IN        LDA                                                        CAP183
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP183
     C                   EVAL      DBKey = PSARD                                              CAP183
     C                   EVAL      DBase = 102                                                CAP183
     C                   OUT       LDA                                                        CAP183
     C                   EXSR      *PSSR                                                      CAP183
     C                   ENDIF                                                                CAP183
                                                                                              CAP183
     C                   ENDIF                                                                CAP183
     C/COPY WNCPYSRC,APH00014
     C/COPY WNCPYSRC,APH00025
                                                                                              CAP183
      ** Check if CGL132 is installed                                                         CGL132
                                                                                              CGL132
     C                   CALL      'AOSARDR0'                                                 CGL132
     C                   PARM      *BLANKS       PRTCD                                        CGL132
     C                   PARM      '*VERIFY'     POPTN                                        CGL132
     C                   PARM      'CGL132'      PSARD                                        CGL132
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL132
                                                                                              CGL132
     C     PRTCD         IFEQ      *BLANK                                                     CGL132
     C                   MOVEL     'Y'           CGL132                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVEL     'N'           CGL132                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Check if CGL133 is installed                                                         CGL133
                                                                                              CGL133
     C                   CALL      'AOSARDR0'                                                 CGL133
     C                   PARM      *BLANKS       PRTCD                                        CGL133
     C                   PARM      '*VERIFY'     POPTN                                        CGL133
     C                   PARM      'CGL133'      PSARD                                        CGL133
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL133
                                                                                              CGL133
     C     PRTCD         IFEQ      *BLANK                                                     CGL133
     C                   MOVEL     'Y'           CGL133                                       CGL133
     C                   ELSE                                                                 CGL133
     C                   MOVEL     'N'           CGL133                                       CGL133
     C                   ENDIF                                                                CGL133
                                                                                              CGL133
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * END - End Routine                                             *
      *                                                               *
      * Called by: C.MOD                                              *
      * Calls: None                                                   *
      *****************************************************************
     C     END           BEGSR
      *
     C                   SETON                                            LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                 CER034A
      *****************************************************************                      CER034A
      * SRICuAh - Subroutine to SD CUAH Records                       *                      CER034A
      *                                                               *                      CER034A
      * Called by: MAIN                                               *                      CER034A
      *                                                               *                      CER034A
      * Calls: None                                                   *                      CER034A
      *****************************************************************                      CER034A
     C     SRICuAh       BEGSR                                                               CER034A
      *                                                                                      CER034A
      ** Do first read before main loop.                                                     CER034A
      *                                                                                      CER034A
     C                   READ      SDICUAHPD                                                 CER034A
      *                                                                                      CER034A
      ** Loop while records read.                                                            CER034A
      *                                                                                      CER034A
     C                   DOW       NOT%EOF(SDICUAHPD)                                        CER034A
      *                                                                                      CER034A
      ** Set output fields.                                                                  CER034A
      *                                                                                      CER034A
     C                   MOVE      RMTMST        ATMST                                       CER034A
     C                   EVAL       BYRS   = AYRS                                            CER034A
     C                   EVAL       BMON   = AMON                                            CER034A
     C                   EVAL       BDAY   = ADAY                                            CER034A
     C                   EVAL       BHRS   = AHRS                                            CER034A
     C                   EVAL       BMIN   = AMIN                                            CER034A
     C                   EVAL       BSEC   = ASEC                                            CER034A
     C                   EVAL       BMSC   = AMSC                                            CER034A
     C                   EVAL       BTMST  = APTMSS                                          CER034A
      *                                                                                      CER034A
     C                   EVAL       APTMES = RMTMST                                          CER034A
     C                   EVAL       APFOTR = RMFRNT                                          CER034A
     C                   EVAL       APRPRL = RMRLOC                                          CER034A
     C                   EVAL       APMIDA = 'SD'                                            CER034A
     C                   EVAL       APTRAN = RMCUST                                          CER034A
     C                   EVAL       APACTN = RMACTN                                          CER034A
      *                                                                                      CER034A
      ** Write details.                                                                      CER034A
      *                                                                                      CER034A
     C                   WRITE     APINVLD0                                                  CER034A
      *                                                                                      CER034A
      ** Read next record and loop back.                                                     CER034A
      *                                                                                      CER034A
     C                   READ      SDICUAHPD                                                 CER034A
      *                                                                                      CER034A
     C                   ENDDO                                                               CER034A
      *                                                                                      CER034A
     C                   ENDSR                                                               CER034A
      *****************************************************************                      CER034A
      /EJECT
     C/COPY WNCPYSRC,APH00015
     C/COPY WNCPYSRC,APH00026
      *****************************************************************
      * *PSSR - Program exception error routine                       *
      *                                                               *
      * Called by: INIT, MAIN                                         *
      * Calls:     None                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      'N'
     C                   MOVE      'Y'           @RUN              1
     C                   MOVEL(P)  'AP0005'      DBPGM
     C                   OUT       LDA
     C                   DUMP
     C                   ENDIF
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
** CPY@ - Object copyright
(c) Misys International Banking Systems Ltd. 2001
