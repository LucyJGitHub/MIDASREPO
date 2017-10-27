     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AP API errors enquiry')                          *
      *****************************************************************
      *                                                               *
      *  Midas - API Interface Module                                 *
      *                                                               *
      *  APERRENQ - API ERRORS ENQUIRY                                *
      *                                                               *
      *  Function:  This function displays API errors                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CGL133             Date 01May13               *
      *                 CGL132             Date 01May13               *
      *                 CSD092             Date 01May13               *
      *                 CSD093             Date 01Apr13               *
      *                 AR787620           Date 10Jun11               *
      *                 CER059             Date 19Jul10               *
      *                 CAP190             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 249071             Date 31Jul07
      *                 BUG13553           Date 22Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 233235             Date 03Oct06               *
      *                 CAP183             Date 05Jan06               *
      *                 CGL032             Date 05Jul04               *
      *                 CAS009             Date 04May04               *
      *                 CAP079             Date 19Aug02               *
      *                 CAP078             Date 31Oct02               *
      *                 CAP077             Date 27Aug02               *
      *                 CAP076             Date 24May02               *
      *                 CAP075             Date 12Aug02               *
      *                 CAP074             Date 26Mar02               *
      *                 CAP073             Date 14May02               *
      *                 CSE040             Date 01Apr03               *
      *                 CAP182             Date 14Mar03               *
      *                 CSE039             Date 10Mar03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CPK015             Date 27Jun02               *
      *                 CAP055             Date 13Mar02               *
      *                 CAP072             Date 28Mar02               *
      *                 CAP071             Date 22Mar02               *
      *                 CAP068             Date 22Mar02               *
      *                 CAP069             Date 22Mar02               *
      *                 CAP070             Date 11Mar02               *
      *                 CAP166             Date  5Mar02               *
      *                 CAS001             Date 23Nov01               *
      *                 CAP067             Date 24Sep01               *
      *                 196570             Date 23Jul01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP038             Date 31Oct00               *
      *                 CAP057             Date 31Oct00               *
      *                 CAP059             Date 31Oct00               *
      *                 CAP060             Date 31Oct00               *
      *                 CAP042             Date 08Jan01               *
      *                 CAP140             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP039             Date 14Jul00               *
      *                 CAP137             Date 07Feb00               *
      *                 CAP136             Date 15Nov99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP035             Date 06Jul99               *
      *                 CAP034             Date 06Jul99               *
      *                 CAP031             Date 06Jul99               *
      *                 CAP051             Date 08Nov99               *
      *                 CDL007             Date 05Oct99               *
      *                 CAP032             Date 06Oct99               *
      *                 CAP033             Date 17Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 154477             Date 29Jan99               *
      *                 CAP004  *CREATE    Date 03Oct98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL133 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Enquiry Only                       *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  CSD092 - Account Review                                      *
      *  CSD093 - Document Management                                 *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,APH00005                                 *
      *             WNCPYSRC,APH00006                                 *
      *             WNCPYSRC,APH00007                                 *
      *             WNCPYSRC,APH00008                                 *
      *             WNCPYSRC,APH00018                                 *
      *             WNCPYSRC,APH00019                                 *
      *             WNCPYSRC,APH00020                                 *
      *             WNCPYSRC,APH00021                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CAP190 - Customer Exchange MQ enabling.                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249071 - CSE097 problems in BYSL(Recompile)                  *
      *  BUG13553-Check Repair Queue, introduced by MQ Series Int.    *
      *  233235 - Checking of switchable feature CGL032 was not done. *
      *  CAP183 - Conversion of Market Prices Input into modular      *
      *           structure to use APIs                               *
      *  CGL032 - Automatic Exchange of Information                   *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *  CAP079 - Lending API enhancements - Repayments schedule      *
      *  CAP078 - Lending API enhancements - Fee input                *
      *  CAP077 - Lending API enhancements - Manual payments          *
      *  CAP076 - Lending API enhancements - Rollover Instructions    *
      *  CAP075 - Lending API enhancements - Loan amendments          *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *  CAP073 - Conversion of MN inputs into modular structure to   *
      *           use as APIs. Facility input Transaction Details     *
      *  CSE040 - Securities Statement Processing                     *
      *  CAP182 - Auto Settlement of Trades                           *
      *         - Conversion of SE Trade Settlement Input maintence   *
      *           function to modular structure to use as APIs.       *
      *  CSE039 - Automatic Settlement of Trades                      *
      *  CPK015 - Lending API enhancements.                           *
      *  CAP055 - APIs for FRA/IRS Caps/Collars/Floors                *
      *  CAP072 - Conversion of LE inputs into modular structure to   *
      *           use as APIs. Fee Settlement and Adjustment input    *
      *  CAP071 - Conversion of LE inputs into modular structure to   *
      *           use as APIs. Facility Amendment.                    *
      *  CAP068 - Conversion of LE inputs into modular structure to   *
      *           use as APIs. Funding Participants.                  *
      *  CAP069 - Conversion of LE inputs into modular structure to   *
      *           use as APIs. Risk Participants.                     *
      *  CAP070 - Conversion of LE inputs into modular structure to   *
      *           use as APIs. Assignments.                           *
      *  CAP166 - API for Non-Currency OTC                            *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  CAP067 - Repurchase Agreements API.                          *
      *  196570 - Patch for Market Data Feed                          *
      *  CAP038 - Midas Base Rates API                                *
      *  CAP057 - Midas Spot Rates API                                *
      *  CAP059 - Midas Fwd Rates  API                                *
      *  CAP060 - Midas Sec Prices API                                *
      *  CAP042 - Conversion of Internal Funding Deal inputs into     *
      *           modular structure to use as APIs.                   *
      *  CAP140 - Conversion of SE Security Diary Event inputs into   *
      *           modular structure to use as APIs.                   *
      *  CAP039 - Conversion of SD Security Customer Details into     *
      *           modular structure to use as APIS                    *
      *  CAP137 - Conversion of SE Securities inputs into modular     *
      *           structure to use as APIs.                           *
      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
      *           modular structure to use as APIs.                   *
      *  CAP035 - Conversion of GL Account Maintenance into           *
      *           modular structure to use as APIS                    *
      *  CAP034 - Conversion of SD Customer Details into              *
      *           modular structure to use as APIS                    *
      *  CAP031 - Conversion of FT Outgoing Payments into             *
      *           modular structure to use as APIS                    *
      *  CAP051 - Automatic Authorisation (MM Part)                   *
      *           Recompiled due to change into MMVELDNIPD            *
      *  CDL007 - Deposit Breakdown Penalty                           *
      *           Recompiled due to change into MMVELDNIPD            *
      *  CAP032 - Conversion of Journal Batch Entry inputs into       *
      *           modular structure to use as APIs.                   *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs.                                        *
      *  154477 - Recompile for change to MMVELDNIPD.                 *
      *  CAP004 - APIs phase 3                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FAPERRENQDFCF   E             WORKSTN
     F                                     SFILE(APERRENQS1:@@RRN)

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

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

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULE DETAILS

     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CAP038
      ** EXTERNAL DS FOR SAR DETAILS                                            CAP038
                                                                                CAP038
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

      ** Array of output lines
     D LIN             S             18A   DIM(100) ASCEND

      ** Data structure for output line
     D LINEDS          DS            18
     D  MSGDNB                 1      7
     D  NO_RECS                8     17S 0
     D  HIGHLITE              18     18

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Fields used by ZARTVMBRD
     D/COPY ZACPYSRC,ZARMD_D
                                                                                              CAS001
      ** Parameters for Used for Access Object                                                CAS001
     D PRtCd           S              7A                                                      CAS001
     D POptn           S              7A                                                      CAS001
     D PSarD           S              6A                                                      CAS001
     D CAS001          S              1A                                                      CAS001
     D CAP055          S              1A                                                      CAP055
     D CAS009          S              1A                                                      CAS009
     D CGL032          S              1A   INZ('N')                                           CGL032
     D CSD093          S              1A   INZ('N')                                           CSD093
     D CSD092          S              1A   INZ('N')                                           CSD092
     D CGL132          S              1A                                                      CGL132
     D CGL133          S              1A                                                      CGL133

      ** Non-currency OTC Flag                                                                CAP166
     D CAP166          S              1A                                                      CAP166
     D/COPY WNCPYSRC,APH00005
                                                                                              CAP166
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
      *
      **  Loop until CK/3 taken
      *
     C     *INKC         DOWEQ     '0'
     C                   EXSR      DETCOUNTS
     C                   EXSR      SUBFILOUT
     C                   END
      *****************************************************************
      /EJECT
      *****************************************************************
      * DETERMINE COUNTS
      *****************************************************************
     C     DETCOUNTS     BEGSR
      *
      * Clear number of lines and line array
      *
     C                   Z-ADD     0             NO_LINES          5 0
     C                   MOVEL     *BLANK        LIN
      *
      ** MQ messages read
      *
     C                   MOVEL     'APOUTPUTPD'  FileName
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD
      *
     C                   MOVEL     'APA1001'     MSGDNB
     C                   Z-ADD     RtvCurrRcd    NO_RECS
     C                   MOVEL     'N'           HIGHLITE
     C                   ADD       1             NO_LINES
     C                   MOVEL     LINEDS        LIN(NO_LINES)
      *
      * Blank line
      *
     C                   MOVEL     *BLANK        LINEDS
     C                   MOVEL     'N'           HIGHLITE
     C                   ADD       1             NO_LINES
     C                   MOVEL     LINEDS        LIN(NO_LINES)
      *
      ** Exceptions
      *
     C                   MOVEL     'APEXCPERPD  'FileName
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD
      *                                                                         **2
     C     RtvCurrRcd    IFGT      0
     C                   MOVEL     'APA1002'     MSGDNB
     C                   Z-ADD     RtvCurrRcd    NO_RECS
     C                   MOVEL     'Y'           HIGHLITE
     C                   ADD       1             NO_LINES
     C                   MOVEL     LINEDS        LIN(NO_LINES)
     C                   ENDIF
      *
      ** Non-authorized
     C                   MOVEL     'APUNAUTHPD  'FileName
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD
      *                                                                         **2
     C     RtvCurrRcd    IFGT      0
     C                   MOVEL     'APA1003'     MSGDNB
     C                   Z-ADD     RtvCurrRcd    NO_RECS
     C                   MOVEL     'Y'           HIGHLITE
     C                   ADD       1             NO_LINES
     C                   MOVEL     LINEDS        LIN(NO_LINES)
     C                   ENDIF
      *
      * DEALING FILES - FX
      *
     C     BGDLFX        IFEQ      'Y'
     C                   EXSR      DEALFX
     C                   ENDIF
      *
      * DEALING FILES - MM
      *
     C     BGDLMM        IFEQ      'Y'
     C                   EXSR      DEALMM
     C                   ENDIF
      *
      * DEALING FILES - INTERNAL CONTRACTS
      *
     C     BGINCN        IFEQ      'Y'
     C                   EXSR      DEALIC
     C                   ENDIF
      *
      * FRA/IRS FILES
      *
     C     BGFIIN        IFEQ      'Y'
     C                   EXSR      FRAIRS
     C                   ENDIF
      *
      * SECURITIES TRADING FILES
      *
     C     BGSECS        IFEQ      'Y'
     C                   EXSR      SECUR
     C                   ENDIF
      *
      * FUTURES & OPTIONS FILES
      *
     C     BGFUOP        IFEQ      'Y'
     C     CAP166        OREQ      'Y'                                                        CAP166
     C     CAP183        OREQ      'Y'                                                        CAP183
     C                   EXSR      FUTOPT
     C                   ENDIF
      *                                                                                       CAP033
      ** Portfolio Management / Private Banking files                                         CAP033
      *                                                                                       CAP033
     C     BGPFMG        IFEQ      'Y'                                                        CAP033
     C     BGN4ST        OREQ      'Y'                                                        CAP033
     C                   EXSR      PORTMGMT                                                   CAP033
     C                   ENDIF                                                                CAP033
      *                                                                                       CAP032
      ** General Ledger - Journal Entry files                                                 CAP032
      *                                                                                       CAP032
     C     BGSDGL        IFEQ      'Y'                                                        CAP032
     C                   EXSR      SRBITH                                                     CAP032
     C                   EXSR      SRBITP                                                     CAP032
     C                   ENDIF                                                                CAP032
      *
      * FUNDS TRANSFER FILES                                                    CAP031
      *                                                                         CAP031
     C     BGFDTR        IFEQ      'Y'                                          CAP031
     C                   EXSR      FUNTFR                                       CAP031
     C                   ENDIF                                                  CAP031
      *
      * SD CUSTOMER MAINTENANCE FILES                                           CAP034
      *                                                                         CAP034
     C     BGSDGL        IFEQ      'Y'                                          CAP034
     C                   EXSR      SDCUSD                                       CAP034
     C                   ENDIF                                                  CAP034
      *
      * GL ACCOUNT MAINTENANCE FILES                                            CAP035
      *                                                                         CAP035
     C     BGSDGL        IFEQ      'Y'                                          CAP035
     C                   EXSR      GLAMAD                                       CAP035
     C                   ENDIF                                                  CAP035
      *                                                                         CAP035
      ** SE Securities File                                                     CAP137
      *                                                                         CAP137
     C     BGSECS        IFEQ      'Y'                                          CAP137
     C                   EXSR      SRSECS                                       CAP137
     C                   ENDIF                                                  CAP137
      *                                                                         CAP137
      * SD SECURITY CUSTOMER DETAILS FILES                                      CAP039
      *                                                                         CAP039
     C     BGSDGL        IFEQ      'Y'                                          CAP039
     C     BGSECS        ANDEQ     'Y'                                          CAP039
     C                   EXSR      SDSECD                                       CAP039
     C                   ENDIF                                                  CAP039
      *                                                                                       CAP140
      ** SE Security Diary Events File                                                        CAP140
      *                                                                                       CAP140
     C     BGSECS        IFEQ      'Y'                                                        CAP140
     C                   EXSR      SRSEDE                                                     CAP140
     C                   ENDIF                                                                CAP140
      *                                                                                       CAP059
      * SD Forward Rate Files                                                                 CAP059
      *                                                                                       CAP059
     C     CAP059F       IFEQ      'Y'                                                        CAP059
     C     BGDLMM        ANDEQ     'Y'                                                        CAP059
     C                   EXSR      FDFWRT                                                     CAP059
     C                   ENDIF                                                                CAP059
      *                                                                                       CAP059
      * SD Interest Rate Files                                                                CAP058
      *                                                                                       CAP058
     C     CAP058F       IFEQ      'Y'                                                        CAP058
     C     BGDLMM        ANDEQ     'Y'                                                        CAP058
     C                   EXSR      FDINTR                                                     CAP058
     C                   ENDIF                                                                CAP058
      *                                                                                       CAP058
      * SD Base Rate Files                                                                    CAP038
      *                                                                                       CAP038
     C     CAP038F       IFEQ      'Y'                                                        CAP038
     C                   EXSR      SDBSRT                                                     CAP038
     C                   ENDIF                                                                CAP038
      *                                                                                       CAP038
      * SD Spot Rate Files                                                                    CAP038
      *                                                                                       CAP057
     C     CAP057F       IFEQ      'Y'                                                        CAP057
     C                   EXSR      SDSPTR                                                     CAP057
     C                   ENDIF                                                                CAP057
      *                                                                                       CAP057
      * SD Security Prices                                                                    CAP057
      *                                                                                       CAP060
     C     CAP060F       IFEQ      'Y'                                                        CAP060
     C     BGSECS        ANDEQ     'Y'                                                        CAP060
     C                   EXSR      SEPRCS                                                     CAP060
     C                   ENDIF                                                                CAP060
      *                                                                                       CAP042
      ** AB Internal Funding Deals                                                            CAP042
      *                                                                                       CAP042
     C     BGINCN        IFEQ      'Y'                                                        CAP042
     C                   EXSR      SRFUND                                                     CAP042
     C                   ENDIF                                                                CAP042
      *                                                                                       CAP067
      ** SE Buy-Sell Backs                                                                    CAP067
      *                                                                                       CAP067
     C     BGSECS        IFEQ      'Y'                                                        CAP067
     C                   EXSR      SRBYSL                                                     CAP067
     C                   ENDIF                                                                CAP067
      *                                                                                       CAP067
      ** MM Money Market                                                                      CAP067
      *                                                                                       CAP067
     C     BGDRMM        IFEQ      'Y'                                                        CAP067
     C                   EXSR      SRREPO                                                     CAP067
     C                   ENDIF                                                                CAP067
                                                                                              CAS001
      ** SD Yield Rates File                                                                  CAS001
                                                                                              CAS001
     C     CAS001        IFEQ      'Y'                                                        CAS001
     C                   EXSR      SRYRAT                                                     CAS001
     C                   ENDIF                                                                CAS001
      *                                                                                       CAP070
      * LE Assignments                                                                        CAP070
     C     BGCSLN        IFEQ      'Y'                                                        CAP070
     C                   EXSR      LEASGN                                                     CAP070
     C                   ENDIF                                                                CAP070
      *                                                                                       CAP069
      * LE Risk Participants                                                                  CAP069
     C     BGCSLN        IFEQ      'Y'                                                        CAP069
     C                   EXSR      LERPRT                                                     CAP069
     C                   ENDIF                                                                CAP069
      *                                                                                       CAP068
      * LE Funding Participants                                                               CAP068
     C     BGCSLN        IFEQ      'Y'                                                        CAP068
     C                   EXSR      LEFPRT                                                     CAP068
     C                   ENDIF                                                                CAP068
      *                                                                                       CAP071
      * LE Facility Amendment                                                                 CAP071
     C     BGCSLN        IFEQ      'Y'                                                        CAP071
     C                   EXSR      LEFAMD                                                     CAP071
     C                   ENDIF                                                                CAP071
      *                                                                                       CAP072
      * LE Fee Adjustment input                                                               CAP072
     C     BGCSLN        IFEQ      'Y'                                                        CAP072
     C                   EXSR      LEFEAD                                                     CAP072
     C                   ENDIF                                                                CAP072
      *                                                                                       CAP072
      * LE Fee Settlement input                                                               CAP072
     C     BGCSLN        IFEQ      'Y'                                                        CAP072
     C                   EXSR      LEFEST                                                     CAP072
     C                   ENDIF                                                                CAP072
                                                                                              CAP055
      ** Caps/Collars/Floors                                                                  CAP055
                                                                                              CAP055
     C     CAP055        IFEQ      'Y'                                                        CAP055
     C                   EXSR      SRCACF                                                     CAP055
     C                   ENDIF                                                                CAP055
                                                                                              CPK015
      ** DL Dealing Fees                                                                      CAS009
                                                                                              CAS009
     C     CAS009        IFEQ      'Y'                                                        CAS009
     C                   EXSR      SRDLFE                                                     CAS009
     C                   ENDIF                                                                CAS009
     C/COPY WNCPYSRC,APH00006
      *                                                                                       CPK015
      ** LE Partial API's                                                                     CPK015
     C     BGCSLN        IFEQ      'Y'                                                        CPK015
      *                                                                                       CPK015
      ** LE Facilities                                                                        CPK015
     C                   EXSR      SRFCTY                                                     CPK015
      *                                                                                       CPK015
      ** LE Loans / Parts purhased / Parts sold                                               CPK015
     C                   EXSR      SRPPPS                                                     CPK015
      *                                                                                       CPK015
      ** LE Loan amendments                                                                   CPK015
     C                   EXSR      SRLOAM                                                     CPK015
      *                                                                                       CPK015
      ** LE Rollovers                                                                         CPK015
     C                   EXSR      SRROLL                                                     CPK015
      *                                                                                       CPK015
      ** LE Manual Repayments                                                                 CPK015
     C                   EXSR      SRMANR                                                     CPK015
      *                                                                                       CPK015
      ** LE Fees                                                                              CPK015
     C                   EXSR      SRFEES                                                     CPK015
     C                   ENDIF                                                                CPK015
      *                                                                                       CSE039
      * SE Movements Status                                                                   CSE039
      *                                                                                       CSE039
     C     CSE039F       IFEQ      'Y'                                                        CSE039
     C                   EXSR      SEMVTS                                                     CSE039
     C                   ENDIF                                                                CSE039
      *
      * SE Trade Settlements                                                                  CAP182
      *                                                                                       CAP182
     C     CAP182        IFEQ      'Y'                                                        CAP182
     C                   EXSR      SETRSM                                                     CAP182
     C                   ENDIF                                                                CAP182
      *                                                                                       CSE040
      * SE Statement Production Request                                                       CSE040
      *                                                                                       CSE040
     C     CSE040F       IFEQ      'Y'                                                        CSE040
     C                   EXSR      SESTPR                                                     CSE040
     C                   ENDIF                                                                CSE040
      *                                                                                       CAP073
      * LE Facility                                                                           CAP073
      *                                                                                       CAP073
     C     CAP073F       IFEQ      'Y'                                                        CAP073
     C                   EXSR      LEFCIP                                                     CAP073
     C                   ENDIF                                                                CAP073
      *                                                                                       CAP074
      * LE Loans PP and PS                                                                    CAP074
      *                                                                                       CAP074
     C     CAP074F       IFEQ      'Y'                                                        CAP074
     C                   EXSR      LECLIP                                                     CAP074
     C                   ENDIF                                                                CAP074
      *                                                                                       CAP076
      * LE Rollover Instructions                                                              CAP076
      *                                                                                       CAP076
     C     CAP076F       IFEQ      'Y'                                                        CAP076
     C                   EXSR      LELERI                                                     CAP076
     C                   ENDIF                                                                CAP076
      *                                                                                       CAP075
      * LE Loan amendments                                                                    CAP075
      *                                                                                       CAP075
     C     CAP075F       IFEQ      'Y'                                                        CAP075
     C                   EXSR      LELOAM                                                     CAP075
     C                   ENDIF                                                                CAP075
      *                                                                                       CAP079
      * LE Repayments schedule                                                                CAP079
      *                                                                                       CAP079
     C     CAP079F       IFEQ      'Y'                                                        CAP079
     C                   EXSR      LERPSC                                                     CAP079
     C                   ENDIF                                                                CAP079
      *                                                                                       CAP077
      * LE Manual payments                                                                    CAP077
      *                                                                                       CAP077
     C     CAP077F       IFEQ      'Y'                                                        CAP077
     C                   EXSR      LEMAPY                                                     CAP077
     C                   ENDIF                                                                CAP077
      *                                                                                       CAP078
      * LE Fee input                                                                          CAP078
      *                                                                                       CAP078
     C     CAP078F       IFEQ      'Y'                                                        CAP078
     C                   EXSR      LEFEEM                                                     CAP078
     C                   ENDIF                                                                CAP078
      *                                                                                       CGL032
      ** SD Customer Details by Country of Tax                                                CGL032
      *                                                                                       CGL032
     C     CGL032        IFEQ      'Y'                                                        CGL032
     C                   EXSR      SRCTTX                                                     CGL032
     C                   ENDIF                                                                CGL032
      *                                                                                       CGL032
      ** SD Additional Customer Details                                                       CGL032
      *                                                                                       CGL032
     C     CGL032        IFEQ      'Y'                                                        CGL032
     C     CGL132        OREQ      'Y'                                                        CGL132
     C     CGL133        OREQ      'Y'                                                        CGL133
     C                   EXSR      SRACUD                                                     CGL032
     C                   ENDIF                                                                CGL032
      *                                                                                       CGL032
      ** SD Non-A/C Holder Details                                                            CGL032
      *                                                                                       CGL032
     C     CGL032        IFEQ      'Y'                                                        CGL032
     C     CGL132        OREQ      'Y'                                                        CGL132
     C     CGL133        OREQ      'Y'                                                        CGL133
     C                   EXSR      SRNAHL                                                     CGL032
     C                   ENDIF                                                                CGL032
      *                                                                                       CGL032
      ** SD Non-A/C Holder by Country of Tax                                                  CGL032
      *                                                                                       CGL032
     C     CGL032        IFEQ      'Y'                                                        CGL032
     C                   EXSR      SRNATX                                                     CGL032
     C                   ENDIF                                                                CGL032
                                                                                              CGL032
      ** SD Joint A/c Member Details                                                          CGL032
                                                                                              CGL032
     C                   IF        CGL032 = 'Y'                                               CGL032
     C                             OR CGL132 ='Y'                                             CGL132
     C                             OR CGL133 ='Y'                                             CGL133
     C                   EXSR      SRJACM                                                     CGL032
     C                   ENDIF                                                                CGL032
      *                                                                                     BUG13553
      * Repair Queue                                                                        BUG13553
      *                                                                                     BUG13553
     C     CAP185        IFEQ      'Y'                                                      BUG13553
     C     CAP190        OREQ      'Y'                                                        CAP190
     C                   EXSR      APRPRQ                                                   BUG13553
     C                   ENDIF                                                              BUG13553
      *                                                                                       CSD093
      ** Document Management                                                                  CSD093
      *                                                                                       CSD093
     C     CSD093        IFEQ      'Y'                                                        CSD093
     C                   EXSR      SRDCMT                                                     CSD093
     C                   ENDIF                                                                CSD093
                                                                                              CSD092
      ** SD Account Review                                                                    CSD092
                                                                                              CSD092
     C     CSD092        IFEQ      'Y'                                                        CSD092
     C                   EXSR      SRACRV                                                     CSD092
     C                   ENDIF                                                                CSD092
      *
      * If only one line present output message 'NO INVALID TRANSACTIONS'
      *
     C                   Z-ADD     3             NO_LINES
     C     *BLANK        LOOKUP    LIN(NO_LINES)                      99
      *
      * If not found
      *
     C     *IN99         IFEQ      '0'
     C                   MOVEL     *BLANK        LINEDS
     C                   MOVEL     'N'           HIGHLITE
     C                   MOVEL     LINEDS        LIN(3)
     C                   MOVEL     LINEDS        LIN(4)
     C                   MOVEL     LINEDS        LIN(5)
     C                   MOVEL     'APA0999'     MSGDNB
     C                   Z-ADD     0             NO_RECS
     C                   MOVEL     LINEDS        LIN(6)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DEALING FILES - FX
      *****************************************************************
     C     DEALFX        BEGSR
      *                                                                        **2
      ** Invalid FX deals
     C                   MOVEL     'FXIFXDLPD   'FileName
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD
      *                                                                         **2
     C     RtvCurrRcd    IFGT      0
     C                   MOVEL     'APA1004'     MSGDNB
     C                   Z-ADD     RtvCurrRcd    NO_RECS
     C                   MOVEL     'N'           HIGHLITE
     C                   ADD       1             NO_LINES
     C                   MOVEL     LINEDS        LIN(NO_LINES)
     C                   ENDIF
      *                                                                        **2
      ** Valid Errors FX deals
     C                   MOVEL     'FXVEFXDLPD  'FileName
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD
      *                                                                         **2
     C     RtvCurrRcd    IFGT      0
     C                   MOVEL     'APA1005'     MSGDNB
     C                   Z-ADD     RtvCurrRcd    NO_RECS
     C                   MOVEL     'Y'           HIGHLITE
     C                   ADD       1             NO_LINES
     C                   MOVEL     LINEDS        LIN(NO_LINES)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DEALING FILES - MM
      *****************************************************************
     C     DEALMM        BEGSR
      *
      ** Invalid LDNI deals
     C                   MOVEL     'MMILDNIPD   'FileName
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD
      *                                                                         **2
     C     RtvCurrRcd    IFGT      0
     C                   MOVEL     'APA1006'     MSGDNB
     C                   Z-ADD     RtvCurrRcd    NO_RECS
     C                   MOVEL     'N'           HIGHLITE
     C                   ADD       1             NO_LINES
     C                   MOVEL     LINEDS        LIN(NO_LINES)
     C                   ENDIF
      *
      ** Valid Errors LDNI deals
     C                   MOVEL     'MMVELDNIPD  'FileName
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD
      *                                                                         **2
     C     RtvCurrRcd    IFGT      0
     C                   MOVEL     'APA1007'     MSGDNB
     C                   Z-ADD     RtvCurrRcd    NO_RECS
     C                   MOVEL     'Y'           HIGHLITE
     C                   ADD       1             NO_LINES
     C                   MOVEL     LINEDS        LIN(NO_LINES)
     C                   ENDIF
      *
      ** Invalid NASP deals
     C                   MOVEL     'MMINASPPD   'FileName
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD
      *                                                                         **2
     C     RtvCurrRcd    IFGT      0
     C                   MOVEL     'APA1008'     MSGDNB
     C                   Z-ADD     RtvCurrRcd    NO_RECS
     C                   MOVEL     'N'           HIGHLITE
     C                   ADD       1             NO_LINES
     C                   MOVEL     LINEDS        LIN(NO_LINES)
     C                   ENDIF
      *
      ** Valid Errors NASP deals
     C                   MOVEL     'MMVENASPPD  'FileName
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD
      *                                                                         **2
     C     RtvCurrRcd    IFGT      0
     C                   MOVEL     'APA1009'     MSGDNB
     C                   Z-ADD     RtvCurrRcd    NO_RECS
     C                   MOVEL     'Y'           HIGHLITE
     C                   ADD       1             NO_LINES
     C                   MOVEL     LINEDS        LIN(NO_LINES)
     C                   ENDIF
      *
      ** Invalid NASS deals
     C                   MOVEL     'MMINASSPD   'FileName
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD
      *                                                                         **2
     C     RtvCurrRcd    IFGT      0
     C                   MOVEL     'APA1010'     MSGDNB
     C                   Z-ADD     RtvCurrRcd    NO_RECS
     C                   MOVEL     'N'           HIGHLITE
     C                   ADD       1             NO_LINES
     C                   MOVEL     LINEDS        LIN(NO_LINES)
     C                   ENDIF
      *
      ** Valid errors NASS deals
     C                   MOVEL     'MMVENASSPD  'FileName
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD
      *                                                                         **2
     C     RtvCurrRcd    IFGT      0
     C                   MOVEL     'APA1011'     MSGDNB
     C                   Z-ADD     RtvCurrRcd    NO_RECS
     C                   MOVEL     'Y'           HIGHLITE
     C                   ADD       1             NO_LINES
     C                   MOVEL     LINEDS        LIN(NO_LINES)
     C                   ENDIF
      *
      ** Invalid DEAMs
     C                   MOVEL     'MMIDEAMPD   'FileName
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD
      *                                                                         **2
     C     RtvCurrRcd    IFGT      0
     C                   MOVEL     'APA1012'     MSGDNB
     C                   Z-ADD     RtvCurrRcd    NO_RECS
     C                   MOVEL     'N'           HIGHLITE
     C                   ADD       1             NO_LINES
     C                   MOVEL     LINEDS        LIN(NO_LINES)
     C                   ENDIF
      *
      ** Valid Errors DEAMs
     C                   MOVEL     'MMVEDEAMPD  'FileName
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD
      *                                                                         **2
     C     RtvCurrRcd    IFGT      0
     C                   MOVEL     'APA1013'     MSGDNB
     C                   Z-ADD     RtvCurrRcd    NO_RECS
     C                   MOVEL     'Y'           HIGHLITE
     C                   ADD       1             NO_LINES
     C                   MOVEL     LINEDS        LIN(NO_LINES)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DEALING FILES - INTERNAL CONTRACTS
      *****************************************************************
     C     DEALIC        BEGSR
      *
      ** Invalid Internal Contracts
     C                   MOVEL     'ABIINTCPD   'FileName
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD
      *                                                                         **2
     C     RtvCurrRcd    IFGT      0
     C                   MOVEL     'APA1014'     MSGDNB
     C                   Z-ADD     RtvCurrRcd    NO_RECS
     C                   MOVEL     'N'           HIGHLITE
     C                   ADD       1             NO_LINES
     C                   MOVEL     LINEDS        LIN(NO_LINES)
     C                   ENDIF
      *
      ** Valid Errors Internal Contracts
     C                   MOVEL     'ABVEINTCPD  'FileName
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD
      *                                                                         **2
     C     RtvCurrRcd    IFGT      0
     C                   MOVEL     'APA1015'     MSGDNB
     C                   Z-ADD     RtvCurrRcd    NO_RECS
     C                   MOVEL     'Y'           HIGHLITE
     C                   ADD       1             NO_LINES
     C                   MOVEL     LINEDS        LIN(NO_LINES)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FRA/IRS FILES
      *****************************************************************
     C     FRAIRS        BEGSR
      *
      ** Invalid FRAs
     C                   MOVEL     'IRIFRAPD    'FileName
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD
      *                                                                         **2
     C     RtvCurrRcd    IFGT      0
     C                   MOVEL     'APA1016'     MSGDNB
     C                   Z-ADD     RtvCurrRcd    NO_RECS
     C                   MOVEL     'N'           HIGHLITE
     C                   ADD       1             NO_LINES
     C                   MOVEL     LINEDS        LIN(NO_LINES)
     C                   ENDIF
      *
      ** Valid Errors FRAs
     C                   MOVEL     'IRVEFRAPD   'FileName
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD
      *                                                                         **2
     C     RtvCurrRcd    IFGT      0
     C                   MOVEL     'APA1017'     MSGDNB
     C                   Z-ADD     RtvCurrRcd    NO_RECS
     C                   MOVEL     'Y'           HIGHLITE
     C                   ADD       1             NO_LINES
     C                   MOVEL     LINEDS        LIN(NO_LINES)
     C                   ENDIF
      *
      ** Invalid Single Currency IRSs
     C                   MOVEL     'IRISIRSPD   'FileName
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD
      *                                                                         **2
     C     RtvCurrRcd    IFGT      0
     C                   MOVEL     'APA1018'     MSGDNB
     C                   Z-ADD     RtvCurrRcd    NO_RECS
     C                   MOVEL     'N'           HIGHLITE
     C                   ADD       1             NO_LINES
     C                   MOVEL     LINEDS        LIN(NO_LINES)
     C                   ENDIF
      *
      ** Valid Errors Single Currency IRSs
     C                   MOVEL     'IRVESIRSPD  'FileName
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD
      *                                                                         **2
     C     RtvCurrRcd    IFGT      0
     C                   MOVEL     'APA1019'     MSGDNB
     C                   Z-ADD     RtvCurrRcd    NO_RECS
     C                   MOVEL     'Y'           HIGHLITE
     C                   ADD       1             NO_LINES
     C                   MOVEL     LINEDS        LIN(NO_LINES)
     C                   ENDIF
      *
      ** Invalid Cross Currency IRSs
     C                   MOVEL     'IRICIRSPD   'FileName
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD
      *                                                                         **2
     C     RtvCurrRcd    IFGT      0
     C                   MOVEL     'APA1020'     MSGDNB
     C                   Z-ADD     RtvCurrRcd    NO_RECS
     C                   MOVEL     'N'           HIGHLITE
     C                   ADD       1             NO_LINES
     C                   MOVEL     LINEDS        LIN(NO_LINES)
     C                   ENDIF
      *
      ** Valid Error Cross Currency IRSs
     C                   MOVEL     'IRVECIRSPD  'FileName
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD
      *                                                                         **2
     C     RtvCurrRcd    IFGT      0
     C                   MOVEL     'APA1021'     MSGDNB
     C                   Z-ADD     RtvCurrRcd    NO_RECS
     C                   MOVEL     'Y'           HIGHLITE
     C                   ADD       1             NO_LINES
     C                   MOVEL     LINEDS        LIN(NO_LINES)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SECURITIES TRADING FILES
      *****************************************************************
     C     SECUR         BEGSR
      *
      ** Invalid Trades
     C                   MOVEL     'SEITRADPD   'FileName
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD
      *                                                                         **2
     C     RtvCurrRcd    IFGT      0
     C                   MOVEL     'APA1022'     MSGDNB
     C                   Z-ADD     RtvCurrRcd    NO_RECS
     C                   MOVEL     'N'           HIGHLITE
     C                   ADD       1             NO_LINES
     C                   MOVEL     LINEDS        LIN(NO_LINES)
     C                   ENDIF
      *
      ** Valid Error Trades
     C                   MOVEL     'SEVETRADPD  'FileName
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD
      *                                                                         **2
     C     RtvCurrRcd    IFGT      0
     C                   MOVEL     'APA1023'     MSGDNB
     C                   Z-ADD     RtvCurrRcd    NO_RECS
     C                   MOVEL     'Y'           HIGHLITE
     C                   ADD       1             NO_LINES
     C                   MOVEL     LINEDS        LIN(NO_LINES)
     C                   ENDIF
      *
      ** Invalid Depot Movements
     C                   MOVEL     'SEIDPMVPD   'FileName
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD
      *                                                                         **2
     C     RtvCurrRcd    IFGT      0
     C                   MOVEL     'APA1024'     MSGDNB
     C                   Z-ADD     RtvCurrRcd    NO_RECS
     C                   MOVEL     'N'           HIGHLITE
     C                   ADD       1             NO_LINES
     C                   MOVEL     LINEDS        LIN(NO_LINES)
     C                   ENDIF
      *
      ** Valid Error Depot Movements
     C                   MOVEL     'SEVEDPMVPD  'FileName
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD
      *                                                                         **2
     C     RtvCurrRcd    IFGT      0
     C                   MOVEL     'APA1025'     MSGDNB
     C                   Z-ADD     RtvCurrRcd    NO_RECS
     C                   MOVEL     'Y'           HIGHLITE
     C                   ADD       1             NO_LINES
     C                   MOVEL     LINEDS        LIN(NO_LINES)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FUTURES & OPTIONS FILES
      *****************************************************************
     C     FUTOPT        BEGSR
      *
      ** Invalid exchange traded trades
     C                   MOVEL     'FFIEXTRPD   'FileName
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD
      *                                                                         **2
     C     RtvCurrRcd    IFGT      0
     C                   MOVEL     'APA1026'     MSGDNB
     C                   Z-ADD     RtvCurrRcd    NO_RECS
     C                   MOVEL     'N'           HIGHLITE
     C                   ADD       1             NO_LINES
     C                   MOVEL     LINEDS        LIN(NO_LINES)
     C                   ENDIF
      *
      ** Invalid OTCs
     C                   MOVEL     'FFIOTCCPD   'FileName
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD
      *                                                                         **2
     C     RtvCurrRcd    IFGT      0
     C                   MOVEL     'APA1027'     MSGDNB
     C                   Z-ADD     RtvCurrRcd    NO_RECS
     C                   MOVEL     'N'           HIGHLITE
     C                   ADD       1             NO_LINES
     C                   MOVEL     LINEDS        LIN(NO_LINES)
     C                   ENDIF
                                                                                              CAP166
      ** Invalid non-currency OTCs                                                            CAP166
                                                                                              CAP166
     C                   IF        CAP166 = 'Y'                                               CAP166
     C                   MOVEL     'FFIOTCOPD   'FileName                                     CAP166
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP166
                                                                                              CAP166
     C                   IF        RtvCurrRcd > 0                                             CAP166
     C                   MOVEL     'APA1102'     MSGDNB                                       CAP166
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP166
     C                   MOVEL     'N'           HIGHLITE                                     CAP166
     C                   ADD       1             NO_LINES                                     CAP166
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP166
     C                   ENDIF                                                                CAP166
     C                   ENDIF                                                                CAP166
                                                                                              CAP183
      ** Invalid Market Prices                                                                CAP183
                                                                                              CAP183
     C                   IF        CAP183 = 'Y'                                               CAP183
     C                   MOVEL     'FFIMPRIPD   'FileName                                     CAP183
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP183
                                                                                              CAP183
     C                   IF        RtvCurrRcd > 0                                             CAP183
HERE C                   MOVEL     'APA1137'     MSGDNB                                       CAP183
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP183
     C                   MOVEL     'N'           HIGHLITE                                     CAP183
     C                   ADD       1             NO_LINES                                     CAP183
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP183
     C                   ENDIF                                                                CAP183
     C                   ENDIF                                                                CAP183
      *
      ** Valid Error Trades
     C                   MOVEL     'FFVETRANPD  'FileName
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD
      *                                                                         **2
     C     RtvCurrRcd    IFGT      0
     C                   MOVEL     'APA1028'     MSGDNB
     C                   Z-ADD     RtvCurrRcd    NO_RECS
     C                   MOVEL     'Y'           HIGHLITE
     C                   ADD       1             NO_LINES
     C                   MOVEL     LINEDS        LIN(NO_LINES)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CAP033
      * Portfolio Management / Private Banking Files                                          CAP033
      *****************************************************************                       CAP033
     C     PORTMGMT      BEGSR                                                                CAP033
      *                                                                                       CAP033
      ** Invalid Portfolio Definitions file                                                   CAP033
      *                                                                                       CAP033
     C                   MOVEL     'PMIPFDMPD   'FileName                                     CAP033
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP033
      *                                                                                       CAP033
     C     RtvCurrRcd    IFGT      0                                                          CAP033
     C                   MOVEL     'APA1053'     MSGDNB                                       CAP033
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP033
     C                   MOVEL     'N'           HIGHLITE                                     CAP033
     C                   ADD       1             NO_LINES                                     CAP033
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP033
     C                   ENDIF                                                                CAP033
      *                                                                                       CAP033
      ** Valid Errors Portfolio Definitions file                                              CAP033
      *                                                                                       CAP033
     C                   MOVEL     'PMVEPFDMPD  'FileName                                     CAP033
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP033
      *                                                                                       CAP033
     C     RtvCurrRcd    IFGT      0                                                          CAP033
     C                   MOVEL     'APA1054'     MSGDNB                                       CAP033
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP033
     C                   MOVEL     'Y'           HIGHLITE                                     CAP033
     C                   ADD       1             NO_LINES                                     CAP033
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP033
     C                   ENDIF                                                                CAP033
      *                                                                                       CAP033
     C                   ENDSR                                                                CAP033
      *****************************************************************                       CAP033
      /EJECT                                                                                  CAP033
      *****************************************************************                       CAP032
      * SRBITH - Journal Entry Headers File                                                   CAP032
      *****************************************************************                       CAP032
     C     SRBITH        BEGSR                                                                CAP032
      *                                                                                       CAP032
      ** Valid Errors Journal Entry Headers file                                              CAP032
      *                                                                                       CAP032
     C                   MOVEL     'GLVEBITHPD  'FileName                                     CAP032
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP032
      *                                                                                       CAP032
     C     RtvCurrRcd    IFGT      0                                                          CAP032
     C                   MOVEL     'APA1055'     MSGDNB                                       CAP032
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP032
     C                   MOVEL     'Y'           HIGHLITE                                     CAP032
     C                   ADD       1             NO_LINES                                     CAP032
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP032
     C                   ENDIF                                                                CAP032
      *                                                                                       CAP032
     C                   ENDSR                                                                CAP032
      *****************************************************************                       CAP032
      /EJECT                                                                                  CAP032
      *****************************************************************                       CAP032
      * SRBITP - Journal Entry Items File                                                     CAP032
      *****************************************************************                       CAP032
     C     SRBITP        BEGSR                                                                CAP032
      *                                                                                       CAP032
      ** Valid Errors Journal Entry Items file                                                CAP032
      *                                                                                       CAP032
     C                   MOVEL     'GLVEBITPPD  'FileName                                     CAP032
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP032
      *                                                                                       CAP032
     C     RtvCurrRcd    IFGT      0                                                          CAP032
     C                   MOVEL     'APA1056'     MSGDNB                                       CAP032
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP032
     C                   MOVEL     'Y'           HIGHLITE                                     CAP032
     C                   ADD       1             NO_LINES                                     CAP032
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP032
     C                   ENDIF                                                                CAP032
      *                                                                                       CAP032
     C                   ENDSR                                                                CAP032
      *****************************************************************                       CAP032
      /EJECT                                                                                  CAP032
      *****************************************************************         CAP031
      * FUNDS TRANSFER FILES                                                    CAP031
      *****************************************************************         CAP031
     C     FUNTFR        BEGSR                                                  CAP031
      *                                                                         CAP031
      ** Invalid Outgoing Payments                                              CAP031
     C                   MOVEL     'FTIOPAYPD   'FileName                       CAP031
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                      CAP031
      *                                                                         CAP031
     C     RtvCurrRcd    IFGT      0                                            CAP031
     C                   MOVEL     'APA1029'     MSGDNB                         CAP031
     C                   Z-ADD     RtvCurrRcd    NO_RECS                        CAP031
     C                   MOVEL     'N'           HIGHLITE                       CAP031
     C                   ADD       1             NO_LINES                       CAP031
     C                   MOVEL     LINEDS        LIN(NO_LINES)                  CAP031
     C                   ENDIF                                                  CAP031
      *                                                                         CAP031
      ** Valid Error Outgoing Payments                                          CAP031
     C                   MOVEL     'FTVEOPAYPD  'FileName                       CAP031
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                      CAP031
      *                                                                         CAP031
     C     RtvCurrRcd    IFGT      0                                            CAP031
     C                   MOVEL     'APA1030'     MSGDNB                         CAP031
     C                   Z-ADD     RtvCurrRcd    NO_RECS                        CAP031
     C                   MOVEL     'Y'           HIGHLITE                       CAP031
     C                   ADD       1             NO_LINES                       CAP031
     C                   MOVEL     LINEDS        LIN(NO_LINES)                  CAP031
     C                   ENDIF                                                  CAP031
      *                                                                         CAP031
      ** Invalid Incoming Payments file                                         CAP136
      *                                                                         CAP136
     C                   MOVEL     'FTIIPAYPD   'FileName                       CAP136
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                      CAP136
      *                                                                         CAP136
     C     RtvCurrRcd    IFGT      0                                            CAP136
     C                   MOVEL     'APA1060'     MSGDNB                         CAP136
     C                   Z-ADD     RtvCurrRcd    NO_RECS                        CAP136
     C                   MOVEL     'N'           HIGHLITE                       CAP136
     C                   ADD       1             NO_LINES                       CAP136
     C                   MOVEL     LINEDS        LIN(NO_LINES)                  CAP136
     C                   ENDIF                                                  CAP136
      *                                                                         CAP136
      ** Valid Errors Incoming Payments file                                    CAP136
      *                                                                         CAP136
     C                   MOVEL     'FTVEIPAYPD  'FileName                       CAP136
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                      CAP136
      *                                                                         CAP136
     C     RtvCurrRcd    IFGT      0                                            CAP136
     C                   MOVEL     'APA1061'     MSGDNB                         CAP136
     C                   Z-ADD     RtvCurrRcd    NO_RECS                        CAP136
     C                   MOVEL     'Y'           HIGHLITE                       CAP136
     C                   ADD       1             NO_LINES                       CAP136
     C                   MOVEL     LINEDS        LIN(NO_LINES)                  CAP136
     C                   ENDIF                                                  CAP136
      *                                                                         CAP136
     C                   ENDSR                                                  CAP031
      *****************************************************************         CAP031
      /EJECT                                                                    CAP031
      *****************************************************************         CAP031
      * CUSTOMER MAINTENANCE FILES                                              CAP034
      *****************************************************************         CAP034
     C     SDCUSD        BEGSR                                                  CAP034
      *                                                                         CAP034
      ** Invalid Customer Details                                               CAP034
     C                   MOVEL     'SDICUSDPD   'FileName                       CAP034
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                      CAP034
      *                                                                         CAP034
     C     RtvCurrRcd    IFGT      0                                            CAP034
     C                   MOVEL     'APA1031'     MSGDNB                         CAP034
     C                   Z-ADD     RtvCurrRcd    NO_RECS                        CAP034
     C                   MOVEL     'N'           HIGHLITE                       CAP034
     C                   ADD       1             NO_LINES                       CAP034
     C                   MOVEL     LINEDS        LIN(NO_LINES)                  CAP034
     C                   ENDIF                                                  CAP034
      *                                                                         CAP034
      ** Valid Error Customer Details                                           CAP034
     C                   MOVEL     'SDVECUSDPD  'FileName                       CAP034
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                      CAP034
      *                                                                         CAP034
     C     RtvCurrRcd    IFGT      0                                            CAP034
     C                   MOVEL     'APA1032'     MSGDNB                         CAP034
     C                   Z-ADD     RtvCurrRcd    NO_RECS                        CAP034
     C                   MOVEL     'Y'           HIGHLITE                       CAP034
     C                   ADD       1             NO_LINES                       CAP034
     C                   MOVEL     LINEDS        LIN(NO_LINES)                  CAP034
     C                   ENDIF                                                  CAP034
      *                                                                         CAP034
      ** Invalid Customer Base Rate details                                     CAP034
     C                   MOVEL     'SDICUBRPD   'FileName                       CAP034
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                      CAP034
      *                                                                         CAP034
     C     RtvCurrRcd    IFGT      0                                            CAP034
     C                   MOVEL     'APA1033'     MSGDNB                         CAP034
     C                   Z-ADD     RtvCurrRcd    NO_RECS                        CAP034
     C                   MOVEL     'N'           HIGHLITE                       CAP034
     C                   ADD       1             NO_LINES                       CAP034
     C                   MOVEL     LINEDS        LIN(NO_LINES)                  CAP034
     C                   ENDIF                                                  CAP034
      *                                                                         CAP034
      ** Valid Error Customer Base Rate Details                                 CAP034
     C                   MOVEL     'SDVECUBRPD  'FileName                       CAP034
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                      CAP034
      *                                                                         CAP034
     C     RtvCurrRcd    IFGT      0                                            CAP034
     C                   MOVEL     'APA1034'     MSGDNB                         CAP034
     C                   Z-ADD     RtvCurrRcd    NO_RECS                        CAP034
     C                   MOVEL     'Y'           HIGHLITE                       CAP034
     C                   ADD       1             NO_LINES                       CAP034
     C                   MOVEL     LINEDS        LIN(NO_LINES)                  CAP034
     C                   ENDIF                                                  CAP034
      *                                                                         CAP034
      ** Invalid Private Banking details                                        CAP034
     C                   MOVEL     'SDICUPBPD   'FileName                       CAP034
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                      CAP034
      *                                                                         CAP034
     C     RtvCurrRcd    IFGT      0                                            CAP034
     C                   MOVEL     'APA1035'     MSGDNB                         CAP034
     C                   Z-ADD     RtvCurrRcd    NO_RECS                        CAP034
     C                   MOVEL     'N'           HIGHLITE                       CAP034
     C                   ADD       1             NO_LINES                       CAP034
     C                   MOVEL     LINEDS        LIN(NO_LINES)                  CAP034
     C                   ENDIF                                                  CAP034
      *                                                                         CAP034
      ** Valid Error Customer Private Banking Details                           CAP034
     C                   MOVEL     'SDVECUPBPD  'FileName                       CAP034
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                      CAP034
      *                                                                         CAP034
     C     RtvCurrRcd    IFGT      0                                            CAP034
     C                   MOVEL     'APA1036'     MSGDNB                         CAP034
     C                   Z-ADD     RtvCurrRcd    NO_RECS                        CAP034
     C                   MOVEL     'Y'           HIGHLITE                       CAP034
     C                   ADD       1             NO_LINES                       CAP034
     C                   MOVEL     LINEDS        LIN(NO_LINES)                  CAP034
     C                   ENDIF                                                  CAP034
      *                                                                         CAP034
     C                   ENDSR                                                  CAP034
      *****************************************************************         CAP034
      /EJECT                                                                    CAP035
      *****************************************************************         CAP035
      * ACCOUNT MAINTENANCE FILES                                               CAP035
      *****************************************************************         CAP035
     C     GLAMAD        BEGSR                                                  CAP035
      *                                                                         CAP035
      ** Invalid G/L Accounts                                                   CAP035
     C                   MOVEL     'GLIAMADPD   'FileName                       CAP035
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                      CAP035
      *                                                                         CAP035
     C     RtvCurrRcd    IFGT      0                                            CAP035
     C                   MOVEL     'APA1037'     MSGDNB                         CAP035
     C                   Z-ADD     RtvCurrRcd    NO_RECS                        CAP035
     C                   MOVEL     'N'           HIGHLITE                       CAP035
     C                   ADD       1             NO_LINES                       CAP035
     C                   MOVEL     LINEDS        LIN(NO_LINES)                  CAP035
     C                   ENDIF                                                  CAP035
      *                                                                         CAP035
      ** Valid Error G/L Accounts                                               CAP035
     C                   MOVEL     'GLVEAMADPD  'FileName                       CAP035
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                      CAP035
      *                                                                         CAP035
     C     RtvCurrRcd    IFGT      0                                            CAP035
     C                   MOVEL     'APA1038'     MSGDNB                         CAP035
     C                   Z-ADD     RtvCurrRcd    NO_RECS                        CAP035
     C                   MOVEL     'Y'           HIGHLITE                       CAP035
     C                   ADD       1             NO_LINES                       CAP035
     C                   MOVEL     LINEDS        LIN(NO_LINES)                  CAP035
     C                   ENDIF                                                  CAP035
      *                                                                         CAP035
      ** Valid Error G/L Accounts                                               CAP035
     C                   MOVEL     'GLVEAMBXPD  'FileName                       CAP035
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                      CAP035
      *                                                                         CAP035
     C     RtvCurrRcd    IFGT      0                                            CAP035
     C                   MOVEL     'APA1039'     MSGDNB                         CAP035
     C                   Z-ADD     RtvCurrRcd    NO_RECS                        CAP035
     C                   MOVEL     'Y'           HIGHLITE                       CAP035
     C                   ADD       1             NO_LINES                       CAP035
     C                   MOVEL     LINEDS        LIN(NO_LINES)                  CAP035
     C                   ENDIF                                                  CAP035
      *                                                                         CAP035
      *                                                                         CAP035
      ** Valid Error G/L Accounts                                               CAP035
     C                   MOVEL     'GLVEAMCOPD  'FileName                       CAP035
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                      CAP035
      *                                                                         CAP035
     C     RtvCurrRcd    IFGT      0                                            CAP035
     C                   MOVEL     'APA1040'     MSGDNB                         CAP035
     C                   Z-ADD     RtvCurrRcd    NO_RECS                        CAP035
     C                   MOVEL     'Y'           HIGHLITE                       CAP035
     C                   ADD       1             NO_LINES                       CAP035
     C                   MOVEL     LINEDS        LIN(NO_LINES)                  CAP035
     C                   ENDIF                                                  CAP035
      *                                                                         CAP035
      *                                                                         CAP035
      ** Valid Error G/L Accounts                                               CAP035
     C                   MOVEL     'GLVEAMPWPD  'FileName                       CAP035
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                      CAP035
      *                                                                         CAP035
     C     RtvCurrRcd    IFGT      0                                            CAP035
     C                   MOVEL     'APA1041'     MSGDNB                         CAP035
     C                   Z-ADD     RtvCurrRcd    NO_RECS                        CAP035
     C                   MOVEL     'Y'           HIGHLITE                       CAP035
     C                   ADD       1             NO_LINES                       CAP035
     C                   MOVEL     LINEDS        LIN(NO_LINES)                  CAP035
     C                   ENDIF                                                  CAP035
      *                                                                         CAP035
      *                                                                         CAP035
      ** Valid Error G/L Accounts                                               CAP035
     C                   MOVEL     'GLVEAMRIPD  'FileName                       CAP035
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                      CAP035
      *                                                                         CAP035
     C     RtvCurrRcd    IFGT      0                                            CAP035
     C                   MOVEL     'APA1042'     MSGDNB                         CAP035
     C                   Z-ADD     RtvCurrRcd    NO_RECS                        CAP035
     C                   MOVEL     'Y'           HIGHLITE                       CAP035
     C                   ADD       1             NO_LINES                       CAP035
     C                   MOVEL     LINEDS        LIN(NO_LINES)                  CAP035
     C                   ENDIF                                                  CAP035
      *                                                                         CAP035
     C                   ENDSR                                                  CAP035
      *****************************************************************         CAP035
      /EJECT                                                                    CAP035
      *****************************************************************         CAP137
      * Securities Files                                                        CAP137
      *****************************************************************         CAP137
     C     SRSECS        BEGSR                                                  CAP137
      *                                                                         CAP137
      ** Invalid Securities file                                                CAP137
      *                                                                         CAP137
     C                   MOVEL     'SEISECSPD   'FileName                       CAP137
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                      CAP137
      *                                                                         CAP137
     C     RtvCurrRcd    IFGT      0                                            CAP137
     C                   MOVEL     'APA1071'     MSGDNB                         CAP137
     C                   Z-ADD     RtvCurrRcd    NO_RECS                        CAP137
     C                   MOVEL     'N'           HIGHLITE                       CAP137
     C                   ADD       1             NO_LINES                       CAP137
     C                   MOVEL     LINEDS        LIN(NO_LINES)                  CAP137
     C                   ENDIF                                                  CAP137
      *                                                                         CAP137
      ** Valid Errors Securities file                                           CAP137
      *                                                                         CAP137
     C                   MOVEL     'SEVESECSPD  'FileName                       CAP137
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                      CAP137
      *                                                                         CAP137
     C     RtvCurrRcd    IFGT      0                                            CAP137
     C                   MOVEL     'APA1072'     MSGDNB                         CAP137
     C                   Z-ADD     RtvCurrRcd    NO_RECS                        CAP137
     C                   MOVEL     'Y'           HIGHLITE                       CAP137
     C                   ADD       1             NO_LINES                       CAP137
     C                   MOVEL     LINEDS        LIN(NO_LINES)                  CAP137
     C                   ENDIF                                                  CAP137
      *                                                                         CAP137
     C                   ENDSR                                                  CAP137
      ********************************************************************      CAP137
      /EJECT                                                                    CAP137
      *****************************************************************         CAP039
      * SECURITY CUSTOMER DETAILS FILES                                         CAP039
      *****************************************************************         CAP039
     C     SDSECD        BEGSR                                                  CAP039
      *                                                                         CAP039
      ** Invalid Security Customer Details                                      CAP039
     C                   MOVEL     'SDISECDPD   'FileName                       CAP039
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                      CAP039
      *                                                                         CAP039
     C     RtvCurrRcd    IFGT      0                                            CAP039
     C                   MOVEL     'APA1043'     MSGDNB                         CAP039
     C                   Z-ADD     RtvCurrRcd    NO_RECS                        CAP039
     C                   MOVEL     'N'           HIGHLITE                       CAP039
     C                   ADD       1             NO_LINES                       CAP039
     C                   MOVEL     LINEDS        LIN(NO_LINES)                  CAP039
     C                   ENDIF                                                  CAP039
      *                                                                         CAP039
      ** Valid Error Customer Details                                           CAP039
     C                   MOVEL     'SDVESECDPD  'FileName                       CAP039
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                      CAP039
      *                                                                         CAP039
     C     RtvCurrRcd    IFGT      0                                            CAP039
     C                   MOVEL     'APA1044'     MSGDNB                         CAP039
     C                   Z-ADD     RtvCurrRcd    NO_RECS                        CAP039
     C                   MOVEL     'Y'           HIGHLITE                       CAP039
     C                   ADD       1             NO_LINES                       CAP039
     C                   MOVEL     LINEDS        LIN(NO_LINES)                  CAP039
     C                   ENDIF                                                  CAP039
      *                                                                         CAP039
     C                   ENDSR                                                  CAP039
      *****************************************************************         CAP039
      /EJECT                                                                    CAP039
      *****************************************************************                       CAP140
      * Security Diary Events File                                                            CAP140
      *****************************************************************                       CAP140
     C     SRSEDE        BEGSR                                                                CAP140
      *                                                                                       CAP140
      ** Invalid Security Diary Events File                                                   CAP140
      *                                                                                       CAP140
     C                   MOVEL     'SEISEDEPD   'FileName                                     CAP140
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP140
      *                                                                                       CAP140
     C     RtvCurrRcd    IFGT      0                                                          CAP140
     C                   MOVEL     'APA1079'     MSGDNB                                       CAP140
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP140
     C                   MOVEL     'N'           HIGHLITE                                     CAP140
     C                   ADD       1             NO_LINES                                     CAP140
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP140
     C                   ENDIF                                                                CAP140
      *                                                                                       CAP140
      ** Valid Errors Security Diary Events File                                              CAP140
      *                                                                                       CAP140
     C                   MOVEL     'SEVESEDEPD  'FileName                                     CAP140
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP140
      *                                                                                       CAP140
     C     RtvCurrRcd    IFGT      0                                                          CAP140
     C                   MOVEL     'APA1080'     MSGDNB                                       CAP140
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP140
     C                   MOVEL     'Y'           HIGHLITE                                     CAP140
     C                   ADD       1             NO_LINES                                     CAP140
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP140
     C                   ENDIF                                                                CAP140
      *                                                                                       CAP140
     C                   ENDSR                                                                CAP140
      ********************************************************************                    CAP140
      /EJECT                                                                                  CAP140
      *****************************************************************                       CAP059
      * FORWARD RATES DETAILS FILES                                                           CAP059
      *****************************************************************                       CAP059
     C     FDFWRT        BEGSR                                                                CAP059
      *                                                                                       CAP059
      ***Invalid*Security*Customer*Details                                             CAP059 196570
      ** Invalid forward rates                                                                196570
     C                   MOVEL     'FDIFWRTPD   'FileName                                     CAP059
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP059
      *                                                                                       CAP059
     C     RtvCurrRcd    IFGT      0                                                          CAP059
     C*******************MOVEL     'APA1080'     MSGDNB                                CAP059 196570
     C                   MOVEL     'APA1098'     MSGDNB                                       196570
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP059
     C                   MOVEL     'N'           HIGHLITE                                     CAP059
     C                   ADD       1             NO_LINES                                     CAP059
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP059
     C                   ENDIF                                                                CAP059
      *                                                                                       CAP059
      ***Valid*Error*Customer*Details                                                  CAP059 196570
      *  Valid Error forward rates                                                            196570
     C                   MOVEL     'FDVEFWRTPD  'FileName                                     CAP059
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP059
      *                                                                                       CAP059
     C     RtvCurrRcd    IFGT      0                                                          CAP059
     C*******************MOVEL     'APA1081'     MSGDNB                                CAP059 196570
     C                   MOVEL     'APA1099'     MSGDNB                                       196570
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP059
     C                   MOVEL     'Y'           HIGHLITE                                     CAP059
     C                   ADD       1             NO_LINES                                     CAP059
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP059
     C                   ENDIF                                                                CAP059
      *                                                                                       CAP059
     C                   ENDSR                                                                CAP059
      *****************************************************************                       CAP059
      /EJECT                                                                                  CAP058
      *****************************************************************                       CAP058
      * INTEREST RATES DETAILS FILES                                                          CAP058
      *****************************************************************                       CAP058
     C     FDINTR        BEGSR                                                                CAP058
      *                                                                                       CAP058
      ***Invalid*Security*Customer*Details*****                                        CAP058 196570
      *  Invalid MM Interest rates                                                            196570
     C                   MOVEL     'FDIINTRPD   'FileName                                     CAP058
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP058
      *                                                                                       CAP058
     C     RtvCurrRcd    IFGT      0                                                          CAP058
     C*******************MOVEL     'APA1082'     MSGDNB                                CAP058 196570
     C                   MOVEL     'APA1100'     MSGDNB                                       196570
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP058
     C                   MOVEL     'N'           HIGHLITE                                     CAP058
     C                   ADD       1             NO_LINES                                     CAP058
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP058
     C                   ENDIF                                                                CAP058
      *                                                                                       CAP058
      ***Valid*Error*Customer*Details**********                                        CAP058 196570
      *  Valid Error Interest rates                                                           196570
     C                   MOVEL     'FDVEINTRPD  'FileName                                     CAP058
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP058
      *                                                                                       CAP058
     C     RtvCurrRcd    IFGT      0                                                          CAP058
     C*******************MOVEL     'APA1083'     MSGDNB                                CAP058 196570
     C                   MOVEL     'APA1101'     MSGDNB                                       196570
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP058
     C                   MOVEL     'Y'           HIGHLITE                                     CAP058
     C                   ADD       1             NO_LINES                                     CAP058
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP058
     C                   ENDIF                                                                CAP058
      *                                                                                       CAP058
     C                   ENDSR                                                                CAP058
      *****************************************************************                       CAP058
      /EJECT                                                                                  CAP058
      *****************************************************************                       CAP038
      * BASE RATE DETAILS FILES                                                               CAP038
      *****************************************************************                       CAP038
     C     SDBSRT        BEGSR                                                                CAP038
      *                                                                                       CAP038
      ******************* Customer Details                                             CAP038 196570
      ** Invalid Base Rates                                                                   196570
     C                   MOVEL     'SDIBSRTPD   'FileName                                     CAP038
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP038
      *                                                                                       CAP038
     C     RtvCurrRcd    IFGT      0                                                          CAP038
     C*******************MOVEL     'APA1084'     MSGDNB                                CAP038 196570
     C                   MOVEL     'APA1092'     MSGDNB                                       196570
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP038
     C                   MOVEL     'N'           HIGHLITE                                     CAP038
     C                   ADD       1             NO_LINES                                     CAP038
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP038
     C                   ENDIF                                                                CAP038
      *                                                                                       CAP038
      ***Valid*Error*Customer*Details                                                  CAP038 196570
      ** Valid Error base rates                                                               196570
     C                   MOVEL     'SDVEBSRTPD  'FileName                                     CAP038
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP038
      *                                                                                       CAP038
     C     RtvCurrRcd    IFGT      0                                                          CAP038
     C*******************MOVEL     'APA1085'     MSGDNB                                CAP038 196570
     C                   MOVEL     'APA1104'     MSGDNB                                       196570
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP038
     C                   MOVEL     'Y'           HIGHLITE                                     CAP038
     C                   ADD       1             NO_LINES                                     CAP038
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP038
     C                   ENDIF                                                                CAP038
      *                                                                                       CAP038
     C                   ENDSR                                                                CAP038
      *****************************************************************                       CAP038
      /EJECT                                                                                  CAP038
      *****************************************************************                       CAP038
      * SPOT RATE DETAILS FILES                                                               CAP038
      *****************************************************************                       CAP057
     C     SDSPTR        BEGSR                                                                CAP057
      *                                                                                       CAP057
      ***Invalid*Security*Customer*Details*************                                CAP057 196570
      ** Invalid Spot rates                                                                   196570
     C                   MOVEL     'SDISPTRPD   'FileName                                     CAP057
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP057
      *                                                                                       CAP057
     C     RtvCurrRcd    IFGT      0                                                          CAP057
     C*******************MOVEL     'APA1086'     MSGDNB                                CAP057 196570
     C                   MOVEL     'APA1105'     MSGDNB                                       196570
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP057
     C                   MOVEL     'N'           HIGHLITE                                     CAP057
     C                   ADD       1             NO_LINES                                     CAP057
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP057
     C                   ENDIF                                                                CAP057
      *                                                                                       CAP057
      ***Valid*Error*Customer*Details**********                                        CAP057 196570
      ** Valid Error spot rates                                                               196570
     C                   MOVEL     'SDVESPTRPD  'FileName                                     CAP057
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP057
      *                                                                                       CAP057
     C     RtvCurrRcd    IFGT      0                                                          CAP057
     C*******************MOVEL     'APA1087'     MSGDNB                                CAP057 196570
     C                   MOVEL     'APA1106'     MSGDNB                                       196570
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP057
     C                   MOVEL     'Y'           HIGHLITE                                     CAP057
     C                   ADD       1             NO_LINES                                     CAP057
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP057
     C                   ENDIF                                                                CAP057
      *                                                                                       CAP057
     C                   ENDSR                                                                CAP057
      *****************************************************************                       CAP057
      /EJECT                                                                                  CAP057
      *****************************************************************                       CAP057
      * SECURITY PRICES DETAILS FILES                                                         CAP060
      *****************************************************************                       CAP060
     C     SEPRCS        BEGSR                                                                CAP060
      *                                                                                       CAP060
      ***Invalid*Security*Customer*Details                                             CAP060 196570
      *  Invalid security prices                                                              196570
     C                   MOVEL     'SEIPRCSPD   'FileName                                     CAP060
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP060
      *                                                                                       CAP060
     C     RtvCurrRcd    IFGT      0                                                          CAP060
     C*******************MOVEL     'APA1088'     MSGDNB                                CAP060 196570
     C                   MOVEL     'APA1107'     MSGDNB                                       196570
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP060
     C                   MOVEL     'N'           HIGHLITE                                     CAP060
     C                   ADD       1             NO_LINES                                     CAP060
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP060
     C                   ENDIF                                                                CAP060
      *                                                                                       CAP060
      ***Valid*Error*Customer*Details                                                  CAP060 196570
      *  Valid Error Security Prices                                                          196570
     C                   MOVEL     'SEVEPRCSPD  'FileName                                     CAP060
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP060
      *                                                                                       CAP060
     C     RtvCurrRcd    IFGT      0                                                          CAP060
     C*******************MOVEL     'APA1089'     MSGDNB                                CAP060 196570
     C                   MOVEL     'APA1097'     MSGDNB                                       196570
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP060
     C                   MOVEL     'Y'           HIGHLITE                                     CAP060
     C                   ADD       1             NO_LINES                                     CAP060
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP060
     C                   ENDIF                                                                CAP060
      *                                                                                       CAP060
     C                   ENDSR                                                                CAP060
      *****************************************************************                       CAP060
      /EJECT                                                                                  CAP060
      *****************************************************************                       CAP042
      * Internal Funding Deals                                        *                       CAP042
      *****************************************************************                       CAP042
     C     SRFUND        BEGSR                                                                CAP042
      *                                                                                       CAP042
      ** Invalid Internal Funding Deals File                                                  CAP042
      *                                                                                       CAP042
     C                   MOVEL     'ABIFUNDPD   'FileName                                     CAP042
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP042
      *                                                                                       CAP042
     C     RtvCurrRcd    IFGT      0                                                          CAP042
     C                   MOVEL     'APA1083'     MSGDNB                                       CAP042
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP042
     C                   MOVEL     'N'           HIGHLITE                                     CAP042
     C                   ADD       1             NO_LINES                                     CAP042
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP042
     C                   ENDIF                                                                CAP042
      *                                                                                       CAP042
     C                   ENDSR                                                                CAP042
      ********************************************************************                    CAP042
      /EJECT                                                                                  CAP042
      *****************************************************************                       CAP067
      * Buy-Sell Backs                                                *                       CAP067
      *****************************************************************                       CAP067
     C     SRBYSL        BEGSR                                                                CAP067
      *                                                                                       CAP067
      ** Invalid Buy-Sell Backs File                                                          CAP067
      *                                                                                       CAP067
     C                   MOVEL     'SEIBYSLPD   'FileName                                     CAP067
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP067
      *                                                                                       CAP067
     C     RtvCurrRcd    IFGT      0                                                          CAP067
     C                   MOVEL     'APA1093'     MSGDNB                                       CAP067
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP067
     C                   MOVEL     'N'           HIGHLITE                                     CAP067
     C                   ADD       1             NO_LINES                                     CAP067
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP067
     C                   ENDIF                                                                CAP067
      *                                                                                       CAP067
      ** Valid Errors Buy-Sell Backs File                                                     CAP067
      *                                                                                       CAP067
     C                   MOVEL     'SEVEBYSLPD  'FileName                                     CAP067
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP067
      *                                                                                       CAP067
     C     RtvCurrRcd    IFGT      0                                                          CAP067
     C                   MOVEL     'APA1094'     MSGDNB                                       CAP067
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP067
     C                   MOVEL     'Y'           HIGHLITE                                     CAP067
     C                   ADD       1             NO_LINES                                     CAP067
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP067
     C                   ENDIF                                                                CAP067
      *                                                                                       CAP067
     C                   ENDSR                                                                CAP067
      ******************************************************************                      CAP067
      /EJECT                                                                                  CAP067
      *****************************************************************                       CAP067
      * Money Market Repos                                            *                       CAP067
      *****************************************************************                       CAP067
     C     SRREPO        BEGSR                                                                CAP067
      *                                                                                       CAP067
      ** Invalid Repos file                                                                   CAP067
      *                                                                                       CAP067
     C                   MOVEL     'MMIRPLDPD   'FileName                                     CAP067
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP067
      *                                                                                       CAP067
     C     RtvCurrRcd    IFGT      0                                                          CAP067
     C                   MOVEL     'APA1095'     MSGDNB                                       CAP067
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP067
     C                   MOVEL     'N'           HIGHLITE                                     CAP067
     C                   ADD       1             NO_LINES                                     CAP067
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP067
     C                   ENDIF                                                                CAP067
      *                                                                                       CAP067
      ** Valid Error Repos File                                                               CAP067
      *                                                                                       CAP067
     C                   MOVEL     'MMVERPLNPD  'FileName                                     CAP067
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP067
      *                                                                                       CAP067
     C     RtvCurrRcd    IFGT      0                                                          CAP067
     C                   MOVEL     'APA1096'     MSGDNB                                       CAP067
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP067
     C                   MOVEL     'Y'           HIGHLITE                                     CAP067
     C                   ADD       1             NO_LINES                                     CAP067
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP067
     C                   ENDIF                                                                CAP067
      *                                                                                       CAP067
     C                   ENDSR                                                                CAP067
      ******************************************************************                      CAP067
      /EJECT                                                                                  CAP067
      *****************************************************************                       CAS001
      *                                                               *                       CAS001
      * SRYRAT - Yield Rate Details Files                             *                       CAS001
      *                                                               *                       CAS001
      * Called by: DETCOUNTS - Determine Counts                       *                       CAS001
      *                                                               *                       CAS001
      * Calls: ZARTVMBRD                                              *                       CAS001
      *                                                               *                       CAS001
      *****************************************************************                       CAS001
                                                                                              CAS001
     C     SRYRAT        BEGSR                                                                CAS001
                                                                                              CAS001
      ** Invalid Yield Rates Details                                                          CAS001
                                                                                              CAS001
     C                   MOVEL     'SDIYRATPD   'FileName                                     CAS001
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAS001
                                                                                              CAS001
     C     RtvCurrRcd    IFGT      0                                                          CAS001
     C                   MOVEL     'APA1108'     MSGDNB                                       CAS001
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAS001
     C                   MOVEL     'N'           HIGHLITE                                     CAS001
     C                   ADD       1             NO_LINES                                     CAS001
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS001
      ** Valid Error Yield Rates Details                                                      CAS001
                                                                                              CAS001
     C                   MOVEL     'SDVEYRATPD  'FileName                                     CAS001
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAS001
                                                                                              CAS001
     C     RtvCurrRcd    IFGT      0                                                          CAS001
     C                   MOVEL     'APA1109'     MSGDNB                                       CAS001
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAS001
     C                   MOVEL     'Y'           HIGHLITE                                     CAS001
     C                   ADD       1             NO_LINES                                     CAS001
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS001
     C                   ENDSR                                                                CAS001
                                                                                              CAS001
      *****************************************************************                       CAS001
      /EJECT                                                                                  CAS001
      *****************************************************************                       CAP070
      * LE Assignments DETAILS FILES                                                          CAP070
      *****************************************************************                       CAP070
     C     LEASGN        BEGSR                                                                CAP070
      *                                                                                       CAP070
      ** Invalid Assignments Details                                                          CAP070
     C                   MOVEL     'LEIASGNPD   'FileName                                     CAP070
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP070
      *                                                                                       CAP070
     C     RtvCurrRcd    IFGT      0                                                          CAP070
     C                   MOVEL     'APA1123'     MSGDNB                                       CAP070
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP070
     C                   MOVEL     'N'           HIGHLITE                                     CAP070
     C                   ADD       1             NO_LINES                                     CAP070
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP070
     C                   ENDIF                                                                CAP070
      *                                                                                       CAP070
      ** Valid Error Assignments Details                                                      CAP070
     C                   MOVEL     'LEVEASGNPD  'FileName                                     CAP070
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP070
      *                                                                                       CAP070
     C     RtvCurrRcd    IFGT      0                                                          CAP070
     C                   MOVEL     'APA1124'     MSGDNB                                       CAP070
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP070
     C                   MOVEL     'Y'           HIGHLITE                                     CAP070
     C                   ADD       1             NO_LINES                                     CAP070
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP070
     C                   ENDIF                                                                CAP070
      *                                                                                       CAP070
     C                   ENDSR                                                                CAP070
      *****************************************************************                       CAP070
      /EJECT                                                                                  CAP069
      *****************************************************************                       CAP069
      * LE Risk Participants DETAILS FILES                                                    CAP069
      *****************************************************************                       CAP069
     C     LERPRT        BEGSR                                                                CAP069
      *                                                                                       CAP069
      ** Invalid Risk Participant details                                                     CAP069
     C                   MOVEL     'LEIRPRTPD   'FileName                                     CAP069
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP069
      *                                                                                       CAP069
     C     RtvCurrRcd    IFGT      0                                                          CAP069
     C                   MOVEL     'APA1125'     MSGDNB                                       CAP069
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP069
     C                   MOVEL     'N'           HIGHLITE                                     CAP069
     C                   ADD       1             NO_LINES                                     CAP069
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP069
     C                   ENDIF                                                                CAP069
      *                                                                                       CAP069
      ** Valid Error Risk Participant Details                                                 CAP069
     C                   MOVEL     'LEVERPRTPD  'FileName                                     CAP069
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP069
      *                                                                                       CAP069
     C     RtvCurrRcd    IFGT      0                                                          CAP069
     C                   MOVEL     'APA1126'     MSGDNB                                       CAP069
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP069
     C                   MOVEL     'Y'           HIGHLITE                                     CAP069
     C                   ADD       1             NO_LINES                                     CAP069
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP069
     C                   ENDIF                                                                CAP069
      *                                                                                       CAP069
     C                   ENDSR                                                                CAP069
      *****************************************************************                       CAP069
      /EJECT                                                                                  CAP068
      *****************************************************************                       CAP068
      * LE Funding Participant Details Files                                                  CAP068
      *****************************************************************                       CAP068
     C     LEFPRT        BEGSR                                                                CAP068
      *                                                                                       CAP068
      ** Invalid Funding Participant Details                                                  CAP068
     C                   MOVEL     'LEIFPRTPD   'FileName                                     CAP068
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP068
      *                                                                                       CAP068
     C     RtvCurrRcd    IFGT      0                                                          CAP068
     C                   MOVEL     'APA1127'     MSGDNB                                       CAP068
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP068
     C                   MOVEL     'N'           HIGHLITE                                     CAP068
     C                   ADD       1             NO_LINES                                     CAP068
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP068
     C                   ENDIF                                                                CAP068
      *                                                                                       CAP068
      ** Valid Error Funding Participant Details                                              CAP068
     C                   MOVEL     'LEVEFCLMPD  'FileName                                     CAP068
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP068
      *                                                                                       CAP068
     C     RtvCurrRcd    IFGT      0                                                          CAP068
     C                   MOVEL     'APA1128'     MSGDNB                                       CAP068
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP068
     C                   MOVEL     'Y'           HIGHLITE                                     CAP068
     C                   ADD       1             NO_LINES                                     CAP068
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP068
     C                   ENDIF                                                                CAP068
      *                                                                                       CAP068
     C                   ENDSR                                                                CAP068
      *****************************************************************                       CAP068
      /EJECT                                                                                  CAP068
      *****************************************************************                       CAP068
      * LE Facility Amendment Details Files                                                   CAP071
      *****************************************************************                       CAP071
     C     LEFAMD        BEGSR                                                                CAP071
      *                                                                                       CAP071
      ** Invalid Funding Participant Details                                                  CAP071
     C                   MOVEL     'LEIFAMDPD   'FileName                                     CAP071
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP071
      *                                                                                       CAP071
     C     RtvCurrRcd    IFGT      0                                                          CAP071
     C                   MOVEL     'APA1129'     MSGDNB                                       CAP071
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP071
     C                   MOVEL     'N'           HIGHLITE                                     CAP071
     C                   ADD       1             NO_LINES                                     CAP071
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP071
     C                   ENDIF                                                                CAP071
      *                                                                                       CAP071
      ** Valid Error Facility Amendment Details                                               CAP071
     C                   MOVEL     'LEVEFAMDPD  'FileName                                     CAP071
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP071
      *                                                                                       CAP071
     C     RtvCurrRcd    IFGT      0                                                          CAP071
     C                   MOVEL     'APA1130'     MSGDNB                                       CAP071
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP071
     C                   MOVEL     'Y'           HIGHLITE                                     CAP071
     C                   ADD       1             NO_LINES                                     CAP071
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP071
     C                   ENDIF                                                                CAP071
      *                                                                                       CAP071
     C                   ENDSR                                                                CAP071
      *****************************************************************                       CAP071
      /EJECT                                                                                  CAP071
      *****************************************************************                       CAP072
      * LE Fee Adjustment details file                                                        CAP072
      *****************************************************************                       CAP072
     C     LEFEAD        BEGSR                                                                CAP072
      *                                                                                       CAP072
      ** Invalid Fee Adjustment Details                                                       CAP072
     C                   MOVEL     'LEIFEADPD   'FileName                                     CAP072
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP072
      *                                                                                       CAP072
     C     RtvCurrRcd    IFGT      0                                                          CAP072
     C                   MOVEL     'APA1131'     MSGDNB                                       CAP072
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP072
     C                   MOVEL     'N'           HIGHLITE                                     CAP072
     C                   ADD       1             NO_LINES                                     CAP072
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP072
     C                   ENDIF                                                                CAP072
      *                                                                                       CAP072
      ** Valid Error Fee Adjustment Details                                                   CAP072
     C                   MOVEL     'LEVEFEADPD  'FileName                                     CAP072
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP072
      *                                                                                       CAP072
     C     RtvCurrRcd    IFGT      0                                                          CAP072
     C                   MOVEL     'APA1132'     MSGDNB                                       CAP072
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP072
     C                   MOVEL     'Y'           HIGHLITE                                     CAP072
     C                   ADD       1             NO_LINES                                     CAP072
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP072
     C                   ENDIF                                                                CAP072
      *                                                                                       CAP072
     C                   ENDSR                                                                CAP072
      *****************************************************************                       CAP071
      /EJECT                                                                                  CAP071
      *****************************************************************                       CAP072
      * LE Fee Settlement details file                                                        CAP072
      *****************************************************************                       CAP072
     C     LEFEST        BEGSR                                                                CAP072
      *                                                                                       CAP072
      ** Invalid Fee Settlement Details                                                       CAP072
     C                   MOVEL     'LEIFESTPD   'FileName                                     CAP072
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP072
      *                                                                                       CAP072
     C     RtvCurrRcd    IFGT      0                                                          CAP072
     C                   MOVEL     'APA1133'     MSGDNB                                       CAP072
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP072
     C                   MOVEL     'N'           HIGHLITE                                     CAP072
     C                   ADD       1             NO_LINES                                     CAP072
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP072
     C                   ENDIF                                                                CAP072
      *                                                                                       CAP072
      ** Valid Error Fee Settlement Details                                                   CAP072
     C                   MOVEL     'LEVEFESTPD  'FileName                                     CAP072
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP072
      *                                                                                       CAP072
     C     RtvCurrRcd    IFGT      0                                                          CAP072
     C                   MOVEL     'APA1134'     MSGDNB                                       CAP072
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP072
     C                   MOVEL     'Y'           HIGHLITE                                     CAP072
     C                   ADD       1             NO_LINES                                     CAP072
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP072
     C                   ENDIF                                                                CAP072
      *                                                                                       CAP072
     C                   ENDSR                                                                CAP072
      *****************************************************************                       CAP072
      /EJECT                                                                                  CAP072
      *****************************************************************                       CAP055
      * Caps/Collars/Floors                                           *                       CAP055
      *****************************************************************                       CAP055
     C     SRCACF        BEGSR                                                                CAP055
                                                                                              CAP055
      ** Invalid Caps/Collars/Floors                                                          CAP055
                                                                                              CAP055
     C                   MOVEL     'IRICACFPD   'FileName                                     CAP055
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP055
                                                                                              CAP055
     C     RtvCurrRcd    IFGT      0                                                          CAP055
     C                   MOVEL     'APA1115'     MSGDNB                                       CAP055
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP055
     C                   MOVEL     'N'           HIGHLITE                                     CAP055
     C                   ADD       1             NO_LINES                                     CAP055
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP055
     C                   ENDIF                                                                CAP055
                                                                                              CAP055
      ** Deals in Error from DBU function for Caps/Collars/Floors                             CAP055
                                                                                              CAP055
     C                   MOVEL     'IRVECACFPD  'FileName                                     CAP055
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP055
                                                                                              CAP055
     C     RtvCurrRcd    IFGT      0                                                          CAP055
     C                   MOVEL     'APA1116'     MSGDNB                                       CAP055
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP055
     C                   MOVEL     'Y'           HIGHLITE                                     CAP055
     C                   ADD       1             NO_LINES                                     CAP055
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP055
     C                   ENDIF                                                                CAP055
                                                                                              CAP055
     C                   ENDSR                                                                CAP055
      *****************************************************************                       CAS009
      /EJECT                                                                                  CAS009
      *****************************************************************                       CAS009
      * Dealing Fees                                                  *                       CAS009
      *****************************************************************                       CAS009
     C     SRDLFE        BEGSR                                                                CAS009
                                                                                              CAS009
      ** Invalid Dealing Fees                                                                 CAS009
                                                                                              CAS009
     C                   MOVEL     'DLIDLFEPD   'FileName                                     CAS009
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAS009
                                                                                              CAS009
     C     RtvCurrRcd    IFGT      0                                                          CAS009
     C                   MOVEL     'APA1135'     MSGDNB                                       CAS009
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAS009
     C                   MOVEL     'N'           HIGHLITE                                     CAS009
     C                   ADD       1             NO_LINES                                     CAS009
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
      ** Valid Error Dealing Fees                                                             CAS009
                                                                                              CAS009
     C                   MOVEL     'DLVEDLFEPD  'FileName                                     CAS009
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAS009
                                                                                              CAS009
     C     RtvCurrRcd    IFGT      0                                                          CAS009
     C                   MOVEL     'APA1136'     MSGDNB                                       CAS009
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAS009
     C                   MOVEL     'Y'           HIGHLITE                                     CAS009
     C                   ADD       1             NO_LINES                                     CAS009
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CAS009
     C                   ENDSR                                                                CAS009
      *****************************************************************                       CPK015
      /EJECT                                                                                  CPK015
      *****************************************************************                       CPK015
      * Facilities                                                    *                       CPK015
      *****************************************************************                       CPK015
                                                                                              CPK015
     C     SRFCTY        BEGSR                                                                CPK015
                                                                                              CPK015
      *                                                                                       CPK015
      ** Invalid Facilities                                                                   CPK015
      *                                                                                       CPK015
     C                   MOVEL     'LEIFACPD    'FileName                                     CPK015
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CPK015
      *                                                                                       CPK015
     C     RtvCurrRcd    IFGT      0                                                          CPK015
     C                   MOVEL     'APA1117'     MSGDNB                                       CPK015
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CPK015
     C                   MOVEL     'N'           HIGHLITE                                     CPK015
     C                   ADD       1             NO_LINES                                     CPK015
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CPK015
     C                   ENDIF                                                                CPK015
      *                                                                                       CPK015
      ** Valid Error Facilities Details                                                       CPK015
      ** Not applicable.                                                                      CPK015
      *                                                                                       CPK015
     C                   ENDSR                                                                CPK015
      *                                                                                       CPK015
      *****************************************************************                       CPK015
      /EJECT                                                                                  CPK015
      *****************************************************************                       CPK015
      * Loans / Parts purchased / parts sold                          *                       CPK015
      *****************************************************************                       CPK015
                                                                                              CPK015
     C     SRPPPS        BEGSR                                                                CPK015
                                                                                              CPK015
      *                                                                                       CPK015
      ** Invalid Loans / Parts purchased / parts sold                                         CPK015
      *                                                                                       CPK015
     C                   MOVEL     'LEILONPD    'FileName                                     CPK015
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CPK015
      *                                                                                       CPK015
     C     RtvCurrRcd    IFGT      0                                                          CPK015
     C                   MOVEL     'APA1118'     MSGDNB                                       CPK015
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CPK015
     C                   MOVEL     'N'           HIGHLITE                                     CPK015
     C                   ADD       1             NO_LINES                                     CPK015
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CPK015
     C                   ENDIF                                                                CPK015
      *                                                                                       CPK015
      ** Valid Error Invalid Loans / Parts purchased / parts sold                             CPK015
      ** details                                                                              CPK015
      ** Not applicable.                                                                      CPK015
      *                                                                                       CPK015
     C                   ENDSR                                                                CPK015
      *                                                                                       CPK015
      *****************************************************************                       CPK015
      /EJECT                                                                                  CPK015
      *****************************************************************                       CPK015
      * Loan Amendments                                               *                       CPK015
      *****************************************************************                       CPK015
                                                                                              CPK015
     C     SRLOAM        BEGSR                                                                CPK015
                                                                                              CPK015
      *                                                                                       CPK015
      ** Invalid Loan Amendments                                                              CPK015
      *                                                                                       CPK015
     C                   MOVEL     'LEILAMPD    'FileName                                     CPK015
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CPK015
      *                                                                                       CPK015
     C     RtvCurrRcd    IFGT      0                                                          CPK015
     C                   MOVEL     'APA1119'     MSGDNB                                       CPK015
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CPK015
     C                   MOVEL     'N'           HIGHLITE                                     CPK015
     C                   ADD       1             NO_LINES                                     CPK015
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CPK015
     C                   ENDIF                                                                CPK015
      *                                                                                       CPK015
      ** Valid Error Loan Amendments Details                                                  CPK015
      ** Not applicable.                                                                      CPK015
      *                                                                                       CPK015
     C                   ENDSR                                                                CPK015
      *                                                                                       CPK015
      *****************************************************************                       CPK015
      /EJECT                                                                                  CPK015
      *****************************************************************                       CPK015
      * Rollovers                                                     *                       CPK015
      *****************************************************************                       CPK015
                                                                                              CPK015
     C     SRROLL        BEGSR                                                                CPK015
                                                                                              CPK015
      *                                                                                       CPK015
      ** Invalid Rollovers                                                                    CPK015
      *                                                                                       CPK015
     C                   MOVEL     'LEIROLPD    'FileName                                     CPK015
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CPK015
      *                                                                                       CPK015
     C     RtvCurrRcd    IFGT      0                                                          CPK015
     C                   MOVEL     'APA1120'     MSGDNB                                       CPK015
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CPK015
     C                   MOVEL     'N'           HIGHLITE                                     CPK015
     C                   ADD       1             NO_LINES                                     CPK015
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CPK015
     C                   ENDIF                                                                CPK015
      *                                                                                       CPK015
      ** Valid Error Rollover Details                                                         CPK015
      ** Not applicable.                                                                      CPK015
      *                                                                                       CPK015
     C                   ENDSR                                                                CPK015
      *                                                                                       CPK015
      *****************************************************************                       CPK015
      /EJECT                                                                                  CPK015
      *****************************************************************                       CPK015
      * Manual Repayments                                             *                       CPK015
      *****************************************************************                       CPK015
                                                                                              CPK015
     C     SRMANR        BEGSR                                                                CPK015
                                                                                              CPK015
      *                                                                                       CPK015
      ** Invalid Manual Repayments                                                            CPK015
      *                                                                                       CPK015
     C                   MOVEL     'LEIMRPPD    'FileName                                     CPK015
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CPK015
      *                                                                                       CPK015
     C     RtvCurrRcd    IFGT      0                                                          CPK015
     C                   MOVEL     'APA1121'     MSGDNB                                       CPK015
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CPK015
     C                   MOVEL     'N'           HIGHLITE                                     CPK015
     C                   ADD       1             NO_LINES                                     CPK015
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CPK015
     C                   ENDIF                                                                CPK015
      *                                                                                       CPK015
      ** Valid Error Manual Repayment details                                                 CPK015
      ** Not applicable.                                                                      CPK015
      *                                                                                       CPK015
     C                   ENDSR                                                                CPK015
      *                                                                                       CPK015
      *****************************************************************                       CPK015
      /EJECT                                                                                  CPK015
      *****************************************************************                       CPK015
      * Fees                                                          *                       CPK015
      *****************************************************************                       CPK015
                                                                                              CPK015
     C     SRFEES        BEGSR                                                                CPK015
                                                                                              CPK015
      *                                                                                       CPK015
      ** Invalid Fees                                                                         CPK015
      *                                                                                       CPK015
     C                   MOVEL     'LEIFEEPD    'FileName                                     CPK015
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CPK015
      *                                                                                       CPK015
     C     RtvCurrRcd    IFGT      0                                                          CPK015
     C                   MOVEL     'APA1122'     MSGDNB                                       CPK015
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CPK015
     C                   MOVEL     'N'           HIGHLITE                                     CPK015
     C                   ADD       1             NO_LINES                                     CPK015
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CPK015
     C                   ENDIF                                                                CPK015
      *                                                                                       CPK015
      ** Valid Error Fees Details                                                             CPK015
      ** Not applicable.                                                                      CPK015
      *                                                                                       CPK015
     C                   ENDSR                                                                CPK015
      *                                                                                       CPK015
      *****************************************************************                       CAP055
      /EJECT                                                                                  CAP055
      *****************************************************************                       CGL032
      *                                                               *                       CGL032
      * SRCTTX - Customer Details by Country of Tax                   *                       CGL032
      *                                                               *                       CGL032
      *****************************************************************                       CGL032
     C     SRCTTX        BEGSR                                                                CGL032
                                                                                              CGL032
      ** Invalid Customer Details by Country of Tax                                           CGL032
                                                                                              CGL032
     C                   MOVEL     'SDICCTXPD   'FileName                                     CGL032
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CGL032
                                                                                              CGL032
     C     RtvCurrRcd    IFGT      0                                                          CGL032
     C                   MOVEL     'APA1092'     MSGDNB                                       CGL032
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CGL032
     C                   MOVEL     'N'           HIGHLITE                                     CGL032
     C                   ADD       1             NO_LINES                                     CGL032
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CGL032
     C                   ENDIF                                                                CGL032
                                                                                              CGL032
      ** Valid Customer Details by Country of Tax                                             CGL032
                                                                                              CGL032
     C                   MOVEL     'SDVECCTXPD  'FileName                                     CGL032
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CGL032
                                                                                              CGL032
     C     RtvCurrRcd    IFGT      0                                                          CGL032
     C                   MOVEL     'APA1093'     MSGDNB                                       CGL032
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CGL032
     C                   MOVEL     'Y'           HIGHLITE                                     CGL032
     C                   ADD       1             NO_LINES                                     CGL032
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CGL032
     C                   ENDIF                                                                CGL032
                                                                                              CGL032
     C                   ENDSR                                                                CGL032
      *****************************************************************                       CGL032
      /EJECT                                                                                  CGL032
      *****************************************************************                       CGL032
      *                                                               *                       CGL032
      *  SRACUD - Additional Customer Details                         *                       CGL032
      *                                                               *                       CGL032
      *****************************************************************                       CGL032
     C     SRACUD        BEGSR                                                                CGL032
                                                                                              CGL032
      ** Invalid Additional Customer Details                                                  CGL032
                                                                                              CGL032
     C                   MOVEL     'SDIACUDPD   'FileName                                     CGL032
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CGL032
                                                                                              CGL032
     C     RtvCurrRcd    IFGT      0                                                          CGL032
     C                   MOVEL     'APA1043'     MSGDNB                                       CGL032
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CGL032
     C                   MOVEL     'N'           HIGHLITE                                     CGL032
     C                   ADD       1             NO_LINES                                     CGL032
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CGL032
     C                   ENDIF                                                                CGL032
                                                                                              CGL032
      ** Valid Error Additional Customer Details                                              CGL032
                                                                                              CGL032
     C                   MOVEL     'SDVACUDPD   'FileName                                     CGL032
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CGL032
                                                                                              CGL032
     C     RtvCurrRcd    IFGT      0                                                          CGL032
     C                   MOVEL     'APA1044'     MSGDNB                                       CGL032
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CGL032
     C                   MOVEL     'Y'           HIGHLITE                                     CGL032
     C                   ADD       1             NO_LINES                                     CGL032
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CGL032
     C                   ENDIF                                                                CGL032
                                                                                              CGL032
     C                   ENDSR                                                                CGL032
      *****************************************************************                       CGL032
      /EJECT                                                                                  CGL032
      *****************************************************************                       CGL032
      *                                                               *                       CGL032
      *  SRNAHL - Non-A/C Holder Details                              *                       CGL032
      *                                                               *                       CGL032
      *****************************************************************                       CGL032
     C     SRNAHL        BEGSR                                                                CGL032
                                                                                              CGL032
      ** Invalid Non-A/C Holder Details                                                       CGL032
                                                                                              CGL032
     C                   MOVEL     'SDINAHLPD   'FileName                                     CGL032
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CGL032
                                                                                              CGL032
     C     RtvCurrRcd    IFGT      0                                                          CGL032
     C                   MOVEL     'APA1043'     MSGDNB                                       CGL032
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CGL032
     C                   MOVEL     'N'           HIGHLITE                                     CGL032
     C                   ADD       1             NO_LINES                                     CGL032
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CGL032
     C                   ENDIF                                                                CGL032
                                                                                              CGL032
      ** Valid Error Non-A/C Holder Details                                                   CGL032
                                                                                              CGL032
     C                   MOVEL     'SDVNAHLPD   'FileName                                     CGL032
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CGL032
                                                                                              CGL032
     C     RtvCurrRcd    IFGT      0                                                          CGL032
     C                   MOVEL     'APA1044'     MSGDNB                                       CGL032
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CGL032
     C                   MOVEL     'Y'           HIGHLITE                                     CGL032
     C                   ADD       1             NO_LINES                                     CGL032
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CGL032
     C                   ENDIF                                                                CGL032
                                                                                              CGL032
     C                   ENDSR                                                                CGL032
      *****************************************************************                       CGL032
      /EJECT                                                                                  CGL032
      *****************************************************************                       CGL032
      *                                                               *                       CGL032
      *  SRNATX - Non-A/C Holder by Country of Tax                    *                       CGL032
      *                                                               *                       CGL032
      *****************************************************************                       CGL032
     C     SRNATX        BEGSR                                                                CGL032
                                                                                              CGL032
      ** Invalid Non-A/C Holder by Country of Tax                                             CGL032
                                                                                              CGL032
     C                   MOVEL     'SDINATXPD   'FileName                                     CGL032
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CGL032
                                                                                              CGL032
     C     RtvCurrRcd    IFGT      0                                                          CGL032
     C                   MOVEL     'APA1043'     MSGDNB                                       CGL032
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CGL032
     C                   MOVEL     'N'           HIGHLITE                                     CGL032
     C                   ADD       1             NO_LINES                                     CGL032
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CGL032
     C                   ENDIF                                                                CGL032
                                                                                              CGL032
      ** Valid Error Non-A/C Holder Details                                                   CGL032
                                                                                              CGL032
     C                   MOVEL     'SDVNATXPD   'FileName                                     CGL032
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CGL032
      *                                                                                       CGL032
     C     RtvCurrRcd    IFGT      0                                                          CGL032
     C                   MOVEL     'APA1044'     MSGDNB                                       CGL032
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CGL032
     C                   MOVEL     'Y'           HIGHLITE                                     CGL032
     C                   ADD       1             NO_LINES                                     CGL032
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CGL032
     C                   ENDIF                                                                CGL032
                                                                                              CGL032
     C                   ENDSR                                                                CGL032
      *****************************************************************                       CGL032
      /EJECT                                                                                  CGL032
      *****************************************************************                       CGL032
      *                                                               *                       CGL032
      *  SRJACM - Joint A/c Member Details.                           *                       CGL032
      *                                                               *                       CGL032
      *****************************************************************                       CGL032
     C     SRJACM        BEGSR                                                                CGL032
                                                                                              CGL032
      ** Invalid Joint A/c Member Details.                                                    CGL032
                                                                                              CGL032
     C                   EVAL      FileName = 'SDIJACMPD'                                     CGL032
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CGL032
                                                                                              CGL032
     C                   IF        RtvCurrRcd > *ZERO                                         CGL032
     C                   EVAL      MSGDNB = 'APA0400'                                         CGL032
     C                   EVAL      NO_RECS = RtvCurrRcd                                       CGL032
     C                   EVAL      HIGHLITE = 'N'                                             CGL032
     C                   EVAL      NO_LINES = NO_LINES + 1                                    CGL032
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CGL032
     C                   ENDIF                                                                CGL032
                                                                                              CGL032
      ** Valid Joint A/c Member Details.                                                      CGL032
                                                                                              CGL032
     C                   EVAL      FileName = 'SDVJACMPD'                                     CGL032
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CGL032
                                                                                              CGL032
     C                   IF        RtvCurrRcd > *ZERO                                         CGL032
     C                   EVAL      MSGDNB = 'APA0401'                                         CGL032
     C                   EVAL      NO_RECS = RtvCurrRcd                                       CGL032
     C                   EVAL      HIGHLITE = 'N'                                             CGL032
     C                   EVAL      NO_LINES = NO_LINES + 1                                    CGL032
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CGL032
     C                   ENDIF                                                                CGL032
                                                                                              CGL032
     C                   ENDSR                                                                CGL032
      *****************************************************************                       CGL032
      /EJECT                                                                                  CGL032
      *****************************************************************                       CSD093
      *                                                               *                       CSD093
      *  SRDCMT - Document Management Details                         *                       CSD093
      *                                                               *                       CSD093
      *****************************************************************                       CSD093
     C     SRDCMT        BEGSR                                                                CSD093
                                                                                              CSD093
      ** Invalid Document Management Details                                                  CSD093
                                                                                              CSD093
     C                   EVAL      FileName = 'SDIDCMTPD'                                     CSD093
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CSD093
                                                                                              CSD093
     C                   IF        RtvCurrRcd > *ZERO                                         CSD093
     C                   EVAL      MSGDNB = 'APA1153'                                         CSD093
     C                   EVAL      NO_RECS = RtvCurrRcd                                       CSD093
     C                   EVAL      HIGHLITE = 'N'                                             CSD093
     C                   EVAL      NO_LINES = NO_LINES + 1                                    CSD093
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CSD093
     C                   ENDIF                                                                CSD093
                                                                                              CSD093
      ** Valid Document Management Details                                                    CSD093
                                                                                              CSD093
     C                   EVAL      FileName = 'SDVDCMTPD'                                     CSD093
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CSD093
                                                                                              CSD093
     C                   IF        RtvCurrRcd > *ZERO                                         CSD093
     C                   EVAL      MSGDNB = 'APA1154'                                         CSD093
     C                   EVAL      NO_RECS = RtvCurrRcd                                       CSD093
     C                   EVAL      HIGHLITE = 'N'                                             CSD093
     C                   EVAL      NO_LINES = NO_LINES + 1                                    CSD093
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CSD093
     C                   ENDIF                                                                CSD093
                                                                                              CSD093
     C                   ENDSR                                                                CSD093
      *****************************************************************                       CSD092
      *                                                               *                       CSD092
      *  SRACRV - Account Review Details                              *                       CSD092
      *                                                               *                       CSD092
      *  Called by: SDACRV1VL                                         *                       CSD092
      *                                                               *                       CSD092
      *  Calls: None                                                  *                       CSD092
      *                                                               *                       CSD092
      *****************************************************************                       CSD092
     C     SRACRV        BEGSR                                                                CSD092
                                                                                              CSD092
      ** Invalid Account Review Details                                                       CSD092
                                                                                              CSD092
     C                   MOVEL     'SDIACRVPD   'FileName                                     CSD092
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CSD092
                                                                                              CSD092
     C     RtvCurrRcd    IFGT      0                                                          CSD092
     C                   MOVEL     'APA1151'     MSGDNB                                       CSD092
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CSD092
     C                   MOVEL     'N'           HIGHLITE                                     CSD092
     C                   ADD       1             NO_LINES                                     CSD092
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CSD092
     C                   ENDIF                                                                CSD092
                                                                                              CSD092
      ** Valid Error Account Review Details                                                   CSD092
                                                                                              CSD092
     C                   MOVEL     'SDVACRVPD   'FileName                                     CSD092
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CSD092
                                                                                              CSD092
     C     RtvCurrRcd    IFGT      0                                                          CSD092
     C                   MOVEL     'APA1152'     MSGDNB                                       CSD092
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CSD092
     C                   MOVEL     'Y'           HIGHLITE                                     CSD092
     C                   ADD       1             NO_LINES                                     CSD092
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CSD092
     C                   ENDIF                                                                CSD092
                                                                                              CSD092
     C                   ENDSR                                                                CSD092
      *****************************************************************                       CSD092
      /EJECT                                                                                  CSD092
      *****************************************************************                       CSE039
      * Movements Status Details Files                                                        CSE039
      *****************************************************************                       CSE039
     C     SEMVTS        BEGSR                                                                CSE039
      *                                                                                       CSE039
      ** Invalid Movements Status Details                                                     CSE039
      *                                                                                       CSE039
     C                   MOVEL     'SEIMVTSPD   'FileName                                     CSE039
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CSE039
      *                                                                                       CSE039
     C     RtvCurrRcd    IFGT      0                                                          CSE039
     C                   MOVEL     'APA1135'     MSGDNB                                       CSE039
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CSE039
     C                   MOVEL     'N'           HIGHLITE                                     CSE039
     C                   ADD       1             NO_LINES                                     CSE039
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CSE039
     C                   ENDIF                                                                CSE039
      *                                                                                       CSE039
      ** Valid Error Movements Status Details                                                 CSE039
      *                                                                                       CSE039
     C                   MOVEL     'SEVEMVTSPD  'FileName                                     CSE039
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CSE039
      *                                                                                       CSE039
     C     RtvCurrRcd    IFGT      0                                                          CSE039
     C                   MOVEL     'APA1136'     MSGDNB                                       CSE039
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CSE039
     C                   MOVEL     'Y'           HIGHLITE                                     CSE039
     C                   ADD       1             NO_LINES                                     CSE039
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CSE039
     C                   ENDIF                                                                CSE039
      *                                                                                       CSE039
     C                   ENDSR                                                                CSE039
      ********************************************************************                    CSE039
      /EJECT                                                                                  CSE039
      *****************************************************************                       CAP182
      * Trade Settlements Details Files                                                       CAP182
      *****************************************************************                       CAP182
     C     SETRSM        BEGSR                                                                CAP182
      *                                                                                       CAP182
      ** Invalid Trade Settlement Details                                                     CAP182
      *                                                                                       CAP182
     C                   MOVEL     'SEITRSMPD   'FileName                                     CAP182
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP182
      *                                                                                       CAP182
     C     RtvCurrRcd    IFGT      0                                                          CAP182
     C                   MOVEL     'APA1137'     MSGDNB                                       CAP182
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP182
     C                   MOVEL     'N'           HIGHLITE                                     CAP182
     C                   ADD       1             NO_LINES                                     CAP182
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP182
     C                   ENDIF                                                                CAP182
      *                                                                                       CAP182
      ** Valid Error Trade Settlement                                                         CAP182
      *                                                                                       CAP182
     C                   MOVEL     'SEVETRSMPD  'FileName                                     CAP182
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP182
      *                                                                                       CAP182
     C     RtvCurrRcd    IFGT      0                                                          CAP182
     C                   MOVEL     'APA1138'     MSGDNB                                       CAP182
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP182
     C                   MOVEL     'Y'           HIGHLITE                                     CAP182
     C                   ADD       1             NO_LINES                                     CAP182
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP182
     C                   ENDIF                                                                CAP182
      *                                                                                       CAP182
     C                   ENDSR                                                                CAP182
      *****************************************************************                       CAP182
      /EJECT                                                                                  CAP182
      *****************************************************************                       CSE040
      * Statement Production Requests Details File                                            CSE040
      *****************************************************************                       CSE040
     C     SESTPR        BEGSR                                                                CSE040
      *                                                                                       CSE040
      ** Invalid Statement Production Requests Details                                        CSE040
      *                                                                                       CSE040
     C                   MOVEL     'SEISTPRPD   'FileName                                     CSE040
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CSE040
      *                                                                                       CSE040
     C     RtvCurrRcd    IFGT      0                                                          CSE040
     C                   MOVEL     'APA1141'     MSGDNB                                       CSE040
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CSE040
     C                   MOVEL     'N'           HIGHLITE                                     CSE040
     C                   ADD       1             NO_LINES                                     CSE040
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CSE040
     C                   ENDIF                                                                CSE040
      *                                                                                       CSE040
      ** Valid Error Statement Production Requests Details                                    CSE040
      *                                                                                       CSE040
     C                   MOVEL     'SEVESTPRPD  'FileName                                     CSE040
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CSE040
      *                                                                                       CSE040
     C     RtvCurrRcd    IFGT      0                                                          CSE040
     C                   MOVEL     'APA1142'     MSGDNB                                       CSE040
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CSE040
     C                   MOVEL     'Y'           HIGHLITE                                     CSE040
     C                   ADD       1             NO_LINES                                     CSE040
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CSE040
     C                   ENDIF                                                                CSE040
      *                                                                                       CSE040
     C                   ENDSR                                                                CSE040
      *****************************************************************                       CSE040
      /EJECT                                                                                  CSE040
      *****************************************************************                       CAP073
      * LE Facility Details Files                                                             CAP073
      *****************************************************************                       CAP073
     C     LEFCIP        BEGSR                                                                CAP073
      *                                                                                       CAP073
      ** Invalid Facility Details                                                             CAP073
     C                   MOVEL     'LEIFCIPPD   'FileName                                     CAP073
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP073
      *                                                                                       CAP073
     C     RtvCurrRcd    IFGT      0                                                          CAP073
     C                   MOVEL     'APA1134'     MSGDNB                                       CAP073
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP073
     C                   MOVEL     'N'           HIGHLITE                                     CAP073
     C                   ADD       1             NO_LINES                                     CAP073
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP073
     C                   ENDIF                                                                CAP073
      *                                                                                       CAP073
      ** Valid Error Facility FM Details                                                      CAP073
      ** No need to check the 'B' record - the same error will be there too                   CAP073
     C                   MOVEL     'LEVEFCIMPD  'FileName                                     CAP073
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP073
      *                                                                                       CAP073
     C     RtvCurrRcd    IFGT      0                                                          CAP073
     C                   MOVEL     'APA1135'     MSGDNB                                       CAP073
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP073
     C                   MOVEL     'Y'           HIGHLITE                                     CAP073
     C                   ADD       1             NO_LINES                                     CAP073
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP073
     C                   ENDIF                                                                CAP073
      *                                                                                       CAP073
     C                   ENDSR                                                                CAP073
      ********************************************************************                    CAP073
      /EJECT                                                                                  CAP074
      *****************************************************************                       CAP074
      * LE Loans Details Files                                                                CAP074
      *****************************************************************                       CAP074
     C     LECLIP        BEGSR                                                                CAP074
      *                                                                                       CAP074
      ** Invalid Loans Details                                                                CAP074
     C                   MOVEL     'LEICLIPPD   'FileName                                     CAP074
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP074
      *                                                                                       CAP074
     C     RtvCurrRcd    IFGT      0                                                          CAP074
     C                   MOVEL     'APA1136'     MSGDNB                                       CAP074
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP074
     C                   MOVEL     'N'           HIGHLITE                                     CAP074
     C                   ADD       1             NO_LINES                                     CAP074
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP074
     C                   ENDIF                                                                CAP074
      *                                                                                       CAP074
      ** Valid Error Loan CL Details                                                          CAP074
      ** No need to check the 'B' record - the same error will be there too                   CAP074
     C                   MOVEL     'LEVECLILPD  'FileName                                     CAP074
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP074
      *                                                                                       CAP074
     C     RtvCurrRcd    IFGT      0                                                          CAP074
     C                   MOVEL     'APA1137'     MSGDNB                                       CAP074
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP074
     C                   MOVEL     'Y'           HIGHLITE                                     CAP074
     C                   ADD       1             NO_LINES                                     CAP074
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP074
     C                   ENDIF                                                                CAP074
      *                                                                                       CAP074
     C                   ENDSR                                                                CAP074
      *****************************************************************                       CAP074
      /EJECT                                                                                  CAP074
      *****************************************************************                       CAP074
      * LE Rollover Instructions Details files                                                CAP076
      *****************************************************************                       CAP076
     C     LELERI        BEGSR                                                                CAP076
      *                                                                                       CAP076
      ** Invalid Rollover Instructions Details                                                CAP076
     C                   MOVEL     'LEILERIPD   'FileName                                     CAP076
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP076
      *                                                                                       CAP076
     C     RtvCurrRcd    IFGT      0                                                          CAP076
     C                   MOVEL     'APA1138'     MSGDNB                                       CAP076
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP076
     C                   MOVEL     'N'           HIGHLITE                                     CAP076
     C                   ADD       1             NO_LINES                                     CAP076
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP076
     C                   ENDIF                                                                CAP076
      *                                                                                       CAP076
      ** Valid Error Loan CL Details                                                          CAP076
      ** No need to check the 'B' record - the same error will be there too                   CAP076
     C                   MOVEL     'LEVECLILPD  'FileName                                     CAP076
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP076
      *                                                                                       CAP076
     C     RtvCurrRcd    IFGT      0                                                          CAP076
     C                   MOVEL     'APA1139'     MSGDNB                                       CAP076
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP076
     C                   MOVEL     'Y'           HIGHLITE                                     CAP076
     C                   ADD       1             NO_LINES                                     CAP076
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP076
     C                   ENDIF                                                                CAP076
      *                                                                                       CAP076
     C                   ENDSR                                                                CAP076
      *****************************************************************                       CAP076
      /EJECT                                                                                  CAP076
      *****************************************************************                       CAP076
      * LE Loan amendment Details files                                                       CAP075
      *****************************************************************                       CAP075
     C     LELOAM        BEGSR                                                                CAP075
      *                                                                                       CAP075
      ** Invalid Loan amendment Details                                                       CAP075
     C                   MOVEL     'LEILOAMPD   'FileName                                     CAP075
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP075
      *                                                                                       CAP075
     C     RtvCurrRcd    IFGT      0                                                          CAP075
     C                   MOVEL     'APA1140'     MSGDNB                                       CAP075
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP075
     C                   MOVEL     'N'           HIGHLITE                                     CAP075
     C                   ADD       1             NO_LINES                                     CAP075
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP075
     C                   ENDIF                                                                CAP075
      *                                                                                       CAP075
      ** Valid Error Loan amendment Details                                                   CAP075
     C                   MOVEL     'LEVELOAMPD  'FileName                                     CAP075
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP075
      *                                                                                       CAP075
     C     RtvCurrRcd    IFGT      0                                                          CAP075
     C                   MOVEL     'APA1141'     MSGDNB                                       CAP075
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP075
     C                   MOVEL     'Y'           HIGHLITE                                     CAP075
     C                   ADD       1             NO_LINES                                     CAP075
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP075
     C                   ENDIF                                                                CAP075
      *                                                                                       CAP075
     C                   ENDSR                                                                CAP075
      *****************************************************************                       CAP075
      /EJECT                                                                                  CAP075
      *****************************************************************                       CAP075
      * LE Repayments schedule Details files                                                  CAP079
      *****************************************************************                       CAP079
     C     LERPSC        BEGSR                                                                CAP079
      *                                                                                       CAP079
      ** Invalid repayments schedule details                                                  CAP079
     C                   MOVEL     'LEIRPSCPD   'FileName                                     CAP079
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP079
      *                                                                                       CAP079
     C     RtvCurrRcd    IFGT      0                                                          CAP079
     C                   MOVEL     'APA1142'     MSGDNB                                       CAP079
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP079
     C                   MOVEL     'N'           HIGHLITE                                     CAP079
     C                   ADD       1             NO_LINES                                     CAP079
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP079
     C                   ENDIF                                                                CAP079
      *                                                                                       CAP079
      ** Valid Error repayments schedule details                                              CAP079
     C                   MOVEL     'LEVERPSCPD  'FileName                                     CAP079
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP079
      *                                                                                       CAP079
     C     RtvCurrRcd    IFGT      0                                                          CAP079
     C                   MOVEL     'APA1143'     MSGDNB                                       CAP079
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP079
     C                   MOVEL     'Y'           HIGHLITE                                     CAP079
     C                   ADD       1             NO_LINES                                     CAP079
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP079
     C                   ENDIF                                                                CAP079
      *                                                                                       CAP079
     C                   ENDSR                                                                CAP079
      *****************************************************************                       CAP079
      /EJECT                                                                                  CAP079
      *****************************************************************                       CAP079
      * LE Manual payments details files                                                      CAP077
      *****************************************************************                       CAP077
     C     LEMAPY        BEGSR                                                                CAP077
      *                                                                                       CAP077
      ** Invalid manual payments details                                                      CAP077
     C                   MOVEL     'LEIMAPYPD   'FileName                                     CAP077
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP077
      *                                                                                       CAP077
     C     RtvCurrRcd    IFGT      0                                                          CAP077
     C                   MOVEL     'APA1144'     MSGDNB                                       CAP077
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP077
     C                   MOVEL     'N'           HIGHLITE                                     CAP077
     C                   ADD       1             NO_LINES                                     CAP077
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP077
     C                   ENDIF                                                                CAP077
      *                                                                                       CAP077
      ** Valid Error Manual payments details                                                  CAP077
     C                   MOVEL     'LEVEMAPYPD  'FileName                                     CAP077
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP077
      *                                                                                       CAP077
     C     RtvCurrRcd    IFGT      0                                                          CAP077
     C                   MOVEL     'APA1145'     MSGDNB                                       CAP077
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP077
     C                   MOVEL     'Y'           HIGHLITE                                     CAP077
     C                   ADD       1             NO_LINES                                     CAP077
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP077
     C                   ENDIF                                                                CAP077
      *                                                                                       CAP077
     C                   ENDSR                                                                CAP077
      *****************************************************************                       CAP077
      /EJECT                                                                                  CAP077
      *****************************************************************                       CAP077
      * LE Fee input                                                                          CAP078
      *****************************************************************                       CAP078
     C     LEFEEM        BEGSR                                                                CAP078
      *                                                                                       CAP078
      ** Invalid Fee details                                                                  CAP078
     C                   MOVEL     'LEIFEEMPD   'FileName                                     CAP078
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP078
      *                                                                                       CAP078
     C     RtvCurrRcd    IFGT      0                                                          CAP078
     C                   MOVEL     'APA1144'     MSGDNB                                       CAP078
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP078
     C                   MOVEL     'N'           HIGHLITE                                     CAP078
     C                   ADD       1             NO_LINES                                     CAP078
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP078
     C                   ENDIF                                                                CAP078
      *                                                                                       CAP078
      ** Valid Error Fee details                                                              CAP078
     C                   MOVEL     'LEVEFEEMPD  'FileName                                     CAP078
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                    CAP078
      *                                                                                       CAP078
     C     RtvCurrRcd    IFGT      0                                                          CAP078
     C                   MOVEL     'APA1145'     MSGDNB                                       CAP078
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                      CAP078
     C                   MOVEL     'Y'           HIGHLITE                                     CAP078
     C                   ADD       1             NO_LINES                                     CAP078
     C                   MOVEL     LINEDS        LIN(NO_LINES)                                CAP078
     C                   ENDIF                                                                CAP078
      *                                                                                       CAP078
     C                   ENDSR                                                                CAP078
      *****************************************************************                       CAP078
      /EJECT                                                                                  CAP078
      *****************************************************************                     BUG13553
      * Repair Queue Table                                                                  BUG13553
      *****************************************************************                     BUG13553
     C     APRPRQ        BEGSR                                                              BUG13553
      *                                                                                     BUG13553
      ** Invalid Fee details                                                                BUG13553
     C                   MOVEL     'T_MSRPRQZ   'FileName                                   BUG13553
     C                   CALLB     'ZARTVMBRD'   ZARTVMBRD                                  BUG13553
      *                                                                                     BUG13553
     C     RtvCurrRcd    IFGT      0                                                        BUG13553
     C                   MOVEL     'APA1146'     MSGDNB                                     BUG13553
     C                   Z-ADD     RtvCurrRcd    NO_RECS                                    BUG13553
     C                   MOVEL     'N'           HIGHLITE                                   BUG13553
     C                   ADD       1             NO_LINES                                   BUG13553
     C                   MOVEL     LINEDS        LIN(NO_LINES)                              BUG13553
     C                   ENDIF                                                              BUG13553
      *                                                                                     BUG13553
     C                   ENDSR                                                              BUG13553
      *****************************************************************                     BUG13553
      /EJECT                                                                                BUG13553
      ********************************************************************
      * SUBFILOUT - SUBFILE OUTPUT
      ********************************************************************
     C     SUBFILOUT     BEGSR
      *
      **  Initialise subfile relative record number and 'end of output'
      *
     C                   Z-ADD     0             @@RRN             5 0
     C                   MOVEL     'N'           EndofOutpt        1
     C                   EVAL      *IN96 = *OFF
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     APERRENQS0
     C                   MOVE      '0'           *IN97
      *
      **  Write the select screen footer to the screen.
      *
     C                   WRITE     APERRENQF1
      *
      * Format a line for output to the subfile
      *
     C                   EXSR      FMTLIN
      *
      **  Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      '1'           *IN98
      *
      **  Fill the subfile until a page has been filled
      **  or until the end of output has been reached.
      **  Repeat the process until either end of output, ROLLUP
      **  has not been entered or F3 or F12 is input.
      *
     C     EndofOutpt    DOWNE     'Y'
     C     *IN98         ANDEQ     '1'
      *
      **  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT             3 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of output or the subfile page is full.
      *
     C     EndofOutpt    DOWNE     'Y'
     C     @@CNT         ANDLT     14
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      **  Write the line to the subfile.
      *
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     APERRENQS1
      *
      * Format a line for output to the subfile
      *
     C                   EXSR      FMTLIN
     C                   END
      *
      **  Retrieve time
      *
     C                   TIME                    DDTIME
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     APERRENQS0
      *
      **  Read the subfile control record to determine
      **  whether ROLLUP or CK/3 has been requested.
      *
     C                   READ      APERRENQS0                             99
      *
      **  If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * FMTLIN - FORMAT A LINE FOR OUTPUT
      ******************************************************************
     C     FMTLIN        BEGSR
      *
      * Recover next line
      *
     C                   Z-ADD     1             NO_LINES
     C     *BLANK        LOOKUP    LIN(NO_LINES)                      99
      *
      * If not found, end of output. Otherwise use details
      *
     C     *IN99         IFEQ      '0'
     C                   MOVEL     'Y'           EndofOutpt
     C                   EVAL      *IN96 = *ON
     C                   ELSE
     C                   MOVEL     LIN(NO_LINES) LINEDS
     C                   MOVEL     *BLANK        LIN(NO_LINES)
      *
      * Format line description and amount
      *
     C                   MOVEL     *BLANK        DDLDES
     C                   MOVEL     *BLANK        DDAMNT
     C     MSGDNB        IFNE      *BLANK
     C                   CALL      'SDRTVTXT'
     C                   PARM                    MSGDNB            7
     C/COPY WNCPYSRC,APH00018
     C                   PARM      'ZZGBMSGF  '  MSGNM            10
     C/COPY WNCPYSRC,APH00019
     C                   PARM      *BLANK        MSGTXT           80
     C                   MOVEL     MSGTXT        DDLDES
     C     MSGDNB        IFNE      'APA0999'
     C                   Z-ADD     NO_RECS       @@AMTW                         **2
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDAMNT
     C                   ENDIF
     C                   ENDIF
      *
      * Highlight? I.E. SERIOUS ERROR CONDITION
      *
     C     HIGHLITE      IFEQ      'Y'
     C                   MOVE      '1'           *IN95
     C                   CALL      'SDRTVTXT'
     C                   PARM      'APA1000'     MSGDNB            7
     C/COPY WNCPYSRC,APH00020
     C                   PARM      'ZZGBMSGF  '  MSGNM            10
     C/COPY WNCPYSRC,APH00021
     C                   PARM      *BLANK        MSGTXT           80
     C                   MOVEL     MSGTXT        DDETXT
     C                   ELSE
     C                   MOVE      '0'           *IN95
     C                   MOVE      *BLANKS       DDETXT
     C                   END
     C                   ENDIF
      *
     C                   ENDSR
     C******************************************************************
      /EJECT
      *****************************************************************
      * FMTAMT - FORMAT AMOUNT FOR DISPLAY                            *
      *****************************************************************
     C     FMTAMT        BEGSR
      *
     C                   CALLB     'ZA0920'
     C                   PARM      *BLANK        @@RETC           10
     C                   PARM                    @@AMTW           13 0
     C                   PARM      *ZERO         @@QECN            1 0
     C                   PARM      '.'           BNDCSP            1
     C                   PARM      *BLANK        @@AMTD           14
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize program name
      *
     C                   MOVEL     'APERRENQ '   DBPGM
      *
      ** Move user and workstation ID to screen fields
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
      *
      ** PLIST for ZARTVMBRD
      *
     C/COPY ZACPYSRC,ZARMD_C
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS MODULE DETAILS
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END

     C                   CALLB     'AOSARDR0'                                                 CAP060
     C                   PARM      *BLANKS       @RTCD                                        CAP038
     C                   PARM      '*VERIFY'     @OPTN                                        CAP038
     C                   PARM      'CAP038'      @SARD             6                          CAP038
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP038
     C     @RTCD         IFEQ      *BLANK                                                     CAP038
     C                   MOVEL     'Y'           CAP038F           1                          CAP038
     C                   ELSE                                                                 CAP038
     C                   MOVEL     'N'           CAP038F                                      CAP038
     C                   END                                                                  CAP038

     C                   CALLB     'AOSARDR0'                                                 CAP057
     C                   PARM      *BLANKS       @RTCD                                        CAP057
     C                   PARM      '*VERIFY'     @OPTN                                        CAP057
     C                   PARM      'CAP057'      @SARD             6                          CAP057
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP057
     C     @RTCD         IFEQ      *BLANK                                                     CAP057
     C                   MOVEL     'Y'           CAP057F           1                          CAP057
     C                   ELSE                                                                 CAP057
     C                   MOVEL     'N'           CAP057F                                      CAP057
     C                   END                                                                  CAP057

     C                   CALLB     'AOSARDR0'                                                 CAP058
     C                   PARM      *BLANKS       @RTCD                                        CAP058
     C                   PARM      '*VERIFY'     @OPTN                                        CAP058
     C                   PARM      'CAP058'      @SARD             6                          CAP058
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP058
     C     @RTCD         IFEQ      *BLANK                                                     CAP058
     C                   MOVEL     'Y'           CAP058F           1                          CAP058
     C                   ELSE                                                                 CAP058
     C                   MOVEL     'N'           CAP058F                                      CAP058
     C                   END                                                                  CAP058

     C                   CALLB     'AOSARDR0'                                                 CAP059
     C                   PARM      *BLANKS       @RTCD                                        CAP059
     C                   PARM      '*VERIFY'     @OPTN                                        CAP059
     C                   PARM      'CAP059'      @SARD             6                          CAP059
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP059
     C     @RTCD         IFEQ      *BLANK                                                     CAP059
     C                   MOVEL     'Y'           CAP059F           1                          CAP059
     C                   ELSE                                                                 CAP059
     C                   MOVEL     'N'           CAP059F                                      CAP059
     C                   END                                                                  CAP059

     C                   CALLB     'AOSARDR0'                                                 CAP060
     C                   PARM      *BLANKS       @RTCD                                        CAP060
     C                   PARM      '*VERIFY'     @OPTN                                        CAP060
     C                   PARM      'CAP060'      @SARD             6                          CAP060
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP060
     C     @RTCD         IFEQ      *BLANK                                                     CAP060
     C                   MOVEL     'Y'           CAP060F           1                          CAP060
     C                   ELSE                                                                 CAP060
     C                   MOVEL     'N'           CAP060F                                      CAP060
     C                   END                                                                  CAP060
                                                                                              CAP166
      ** Access SAR Details to determine whether non-ccy OTCs is present                      CAP166
                                                                                              CAP166
     C                   EVAL      CAP166 = 'N'                                               CAP166
     C                   CALLB     'AOSARDR0'                                                 CAP166
     C                   PARM      *BLANKS       @RtCd                                        CAP166
     C                   PARM      '*VERIFY'     @Optn                                        CAP166
     C                   PARM      'CAP166'      @SARD                                        CAP166
                                                                                              CAP166
     C                   IF        @RTCD = *BLANKS                                            CAP166
     C                   EVAL      CAP166 = 'Y'                                               CAP166
     C                   ENDIF                                                                CAP166
                                                                                              CAS001
      ** Check if CAS001 is installed                                                         CAS001
                                                                                              CAS001
     C                   CALLB     'AOSARDR0'                                                 CAS001
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
                                                                                              CAS001
      *
      ** Check if APIs for FRA/IRS Caps/Collars/Floors is installed                           CAP055
      *                                                                                       CAP055
     C                   CALLB     'AOSARDR0'                                                 CAP055
     C                   PARM      *BLANKS       PRTCD                                        CAP055
     C                   PARM      '*VERIFY'     POPTN                                        CAP055
     C                   PARM      'CAP055'      PSARD                                        CAP055
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP055
     C     PRTCD         IFEQ      *BLANKS                                                    CAP055
     C                   EVAL      CAP055 = 'Y'                                               CAP055
     C                   ELSE                                                                 CAP055
     C                   EVAL      CAP055 = 'N'                                               CAP055
     C                   ENDIF                                                                CAP055
                                                                                              CSE039
     C                   CALLB     'AOSARDR0'                                                 CSE039
     C                   PARM      *BLANKS       @RTCD                                        CSE039
     C                   PARM      '*VERIFY'     @OPTN                                        CSE039
     C                   PARM      'CSE039'      @SARD             6                          CSE039
                                                                                              CSE039
     C     @RTCD         IFEQ      *BLANK                                                     CSE039
     C                   MOVEL     'Y'           CSE039F           1                          CSE039
     C                   ELSE                                                                 CSE039
     C                   MOVEL     'N'           CSE039F                                      CSE039
     C                   END                                                                  CSE039
                                                                                              CSE039
     C                   CALLB     'AOSARDR0'                                                 CAP182
     C                   PARM      *BLANKS       @RTCD                                        CAP182
     C                   PARM      '*VERIFY'     @OPTN                                        CAP182
     C                   PARM      'CAP182'      @SARD             6                          CAP182
                                                                                              CAP182
     C     @RTCD         IFEQ      *BLANK                                                     CAP182
     C                   MOVEL     'Y'           CAP182            1                          CAP182
     C                   ELSE                                                                 CAP182
     C                   MOVEL     'N'           CAP182                                       CAP182
     C                   END                                                                  CAP182
                                                                                              CAP182
     C                   CALLB     'AOSARDR0'                                                 CSE040
     C                   PARM      *BLANKS       @RTCD                                        CSE040
     C                   PARM      '*VERIFY'     @OPTN                                        CSE040
     C                   PARM      'CSE040'      @SARD             6                          CSE040
                                                                                              CSE040
     C     @RTCD         IFEQ      *BLANK                                                     CSE040
     C                   MOVEL     'Y'           CSE040F           1                          CSE040
     C                   ELSE                                                                 CSE040
     C                   MOVEL     'N'           CSE040F                                      CSE040
     C                   END                                                                  CSE040
                                                                                              CSE040
     C                   CALLB     'AOSARDR0'                                                 CAP073
     C                   PARM      *BLANKS       @RTCD                                        CAP073
     C                   PARM      '*VERIFY'     @OPTN                                        CAP073
     C                   PARM      'CAP073'      @SARD             6                          CAP073
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP073
     C     @RTCD         IFEQ      *BLANK                                                     CAP073
     C                   MOVEL     'Y'           CAP073F           1                          CAP073
     C                   ELSE                                                                 CAP073
     C                   MOVEL     'N'           CAP073F                                      CAP073
     C                   END                                                                  CAP073
                                                                                              CAP074
     C                   CALLB     'AOSARDR0'                                                 CAP074
     C                   PARM      *BLANKS       @RTCD                                        CAP074
     C                   PARM      '*VERIFY'     @OPTN                                        CAP074
     C                   PARM      'CAP074'      @SARD             6                          CAP074
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP074
     C     @RTCD         IFEQ      *BLANK                                                     CAP074
     C                   MOVEL     'Y'           CAP074F           1                          CAP074
     C                   ELSE                                                                 CAP074
     C                   MOVEL     'N'           CAP074F                                      CAP074
     C                   END                                                                  CAP074
                                                                                              CAP076
     C                   CALLB     'AOSARDR0'                                                 CAP076
     C                   PARM      *BLANKS       @RTCD                                        CAP076
     C                   PARM      '*VERIFY'     @OPTN                                        CAP076
     C                   PARM      'CAP076'      @SARD             6                          CAP076
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP076
     C     @RTCD         IFEQ      *BLANK                                                     CAP076
     C                   MOVEL     'Y'           CAP076F           1                          CAP076
     C                   ELSE                                                                 CAP076
     C                   MOVEL     'N'           CAP076F                                      CAP076
     C                   END                                                                  CAP076
                                                                                              CAP075
     C                   CALLB     'AOSARDR0'                                                 CAP075
     C                   PARM      *BLANKS       @RTCD                                        CAP075
     C                   PARM      '*VERIFY'     @OPTN                                        CAP075
     C                   PARM      'CAP075'      @SARD             6                          CAP075
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP075
     C     @RTCD         IFEQ      *BLANK                                                     CAP075
     C                   MOVEL     'Y'           CAP075F           1                          CAP075
     C                   ELSE                                                                 CAP075
     C                   MOVEL     'N'           CAP075F                                      CAP075
     C                   END                                                                  CAP075
      *                                                                                       CAP079
     C                   CALLB     'AOSARDR0'                                                 CAP079
     C                   PARM      *BLANKS       @RTCD                                        CAP079
     C                   PARM      '*VERIFY'     @OPTN                                        CAP079
     C                   PARM      'CAP079'      @SARD                                        CAP079
      *                                                                                       CAP079
     C     @RTCD         IFEQ      *BLANK                                                     CAP079
     C                   MOVEL     'Y'           CAP079F           1                          CAP079
     C                   ELSE                                                                 CAP079
     C                   MOVEL     'N'           CAP079F                                      CAP079
     C                   END                                                                  CAP079
      *                                                                                       CAP079
     C                   CALLB     'AOSARDR0'                                                 CAP077
     C                   PARM      *BLANKS       @RTCD                                        CAP077
     C                   PARM      '*VERIFY'     @OPTN                                        CAP077
     C                   PARM      'CAP077'      @SARD                                        CAP077
      *                                                                                       CAP077
     C     @RTCD         IFEQ      *BLANK                                                     CAP077
     C                   MOVEL     'Y'           CAP077F           1                          CAP077
     C                   ELSE                                                                 CAP077
     C                   MOVEL     'N'           CAP077F                                      CAP077
     C                   END                                                                  CAP077
      *                                                                                       CAP078
     C                   CALLB     'AOSARDR0'                                                 CAP078
     C                   PARM      *BLANKS       @RTCD                                        CAP078
     C                   PARM      '*VERIFY'     @OPTN                                        CAP078
     C                   PARM      'CAP078'      @SARD                                        CAP078
      *                                                                                       CAP078
     C     @RTCD         IFEQ      *BLANK                                                     CAP078
     C                   MOVEL     'Y'           CAP078F           1                          CAP078
     C                   ELSE                                                                 CAP078
     C                   MOVEL     'N'           CAP078F                                      CAP078
     C                   END                                                                  CAP078
      *                                                                                       CAP078
                                                                                              CAS009
      ** Check if CAS009 is installed                                                         CAS009
                                                                                              CAS009
     C                   CALLB     'AOSARDR0'                                                 CAS009
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
                                                                                              CAS009
      ** Check if CGL032 is installed                                                         233235
                                                                                              233235
     C                   CALL      'AOSARDR0'                                                 233235
     C                   PARM      *BLANKS       PRTCD                                        233235
     C                   PARM      '*VERIFY'     POPTN                                        233235
     C                   PARM      'CGL032'      PSARD                                        233235
     C     SCSARD        PARM      SCSARD        DSFDY                                        233235
                                                                                              233235
     C                   IF        PRTCD = *BLANKS                                            233235
     C                   EVAL      CGL032 = 'Y'                                               233235
     C                   ELSE                                                                 233235
     C                   EVAL      CGL032 = 'N'                                               233235
     C                   ENDIF                                                                233235
                                                                                              233235
     C                   CALLB     'AOSARDR0'                                                 CAP183
     C                   PARM      *BLANKS       @RTCD                                        CAP183
     C                   PARM      '*VERIFY'     @OPTN                                        CAP183
     C                   PARM      'CAP183'      @SARD                                        CAP183
      *                                                                                       CAP183
     C     @RTCD         IFEQ      *BLANK                                                     CAP183
     C                   MOVEL     'Y'           CAP183            1                          CAP183
     C                   ELSE                                                                 CAP183
     C                   MOVEL     'N'           CAP183                                       CAP183
     C                   END                                                                  CAP183
      *                                                                                       CAP183
      ** Check if CAP185 is installed                                                       BUG13553
                                                                                            BUG13553
     C                   CALLB     'AOSARDR0'                                               BUG13553
     C                   PARM      *BLANKS       PRtCd                                      BUG13553
     C                   PARM      '*VERIFY'     POptn                                      BUG13553
     C                   PARM      'CAP185'      PSarD                                      BUG13553
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG13553
                                                                                            BUG13553
     C     PRtCd         IFEQ      *BLANK                                                   BUG13553
     C                   MOVEL     'Y'           CAP185            1                        BUG13553
     C                   ELSE                                                               BUG13553
     C                   MOVEL     'N'           CAP185                                     BUG13553
     C                   ENDIF                                                              BUG13553
     C/COPY WNCPYSRC,APH00007
                                                                                            BUG13553
      *                                                                                       CAP190
      ** Check if CAP190 is installed                                                         CAP190
      *                                                                                       CAP190
     C                   CALLB     'AOSARDR0'                                                 CAP190
     C                   PARM      *BLANKS       PRtCd                                        CAP190
     C                   PARM      '*VERIFY'     POptn                                        CAP190
     C                   PARM      'CAP190'      PSarD                                        CAP190
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP190
                                                                                              CAP190
     C     PRtCd         IFEQ      *BLANK                                                     CAP190
     C                   MOVEL     'Y'           CAP190            1                          CAP190
     C                   ELSE                                                                 CAP190
     C                   MOVEL     'N'           CAP190                                       CAP190
     C                   ENDIF                                                                CAP190

      ** Check if APIs for Document Management is installed                                   CSD093
      *                                                                                       CSD093
     C                   CALLB     'AOSARDR0'                                                 CSD093
     C                   PARM      *BLANKS       PRTCD                                        CSD093
     C                   PARM      '*VERIFY'     POPTN                                        CSD093
     C                   PARM      'CSD093'      PSARD                                        CSD093
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD093
     C     PRTCD         IFEQ      *BLANKS                                                    CSD093
     C                   EVAL      CSD093 = 'Y'                                               CSD093
     C                   ELSE                                                                 CSD093
     C                   EVAL      CSD093 = 'N'                                               CSD093
     C                   ENDIF                                                                CSD093
                                                                                              CSD093
     C                   CALLB     'AOSARDR0'                                                 CSD092
     C                   PARM      *BLANKS       PRTCD                                        CSD092
     C                   PARM      '*VERIFY'     POPTN                                        CSD092
     C                   PARM      'CSD092'      PSARD                                        CSD092
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD092
      *                                                                                       CSD092
     C     PRTCD         IFEQ      *BLANKS                                                    CSD092
     C                   EVAL      CSD092 = 'Y'                                               CSD092
     C                   ELSE                                                                 CSD092
     C                   EVAL      CSD092 = 'N'                                               CSD092
     C                   ENDIF                                                                CSD092
                                                                                              CSD092
      ** Check if CGL132 is installed                                                         CGL132
                                                                                              CGL132
     C                   CALLB     'AOSARDR0'                                                 CGL132
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
     C                   CALLB     'AOSARDR0'                                                 CGL133
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
     C/COPY WNCPYSRC,APH00008
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
