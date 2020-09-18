     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities input validation controller 2')    *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECS2VL - Securities Input Validation Controller 2         *
      *                                                               *
      *  Function: This module validates Securities fields for        *
      *            Screen 2 input into the Midas database.            *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                SESECSCTL                                      *
      *                SESECSRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD035962           Date 25May16               *
      *                 MD000091           Date 16May13               *
      *                 AR1077984          Date 17Jan13               *
      *                 AR750169           Date 17Sep12               *
      *                 AR947093           Date 26Apr12               *
      *                 AR847249           Date 28Jan12               *
      *                 AR881060           Date 20Dec11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11215           Date 18May06               *
      *                 BUG11193           Date 02May06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10847R          Date 24Mar06               *
      *                 BUG10847           Date 17Mar06               *
      *                 BUG10083           Date 17Feb06               *
      *                 CGL032             Date 05Jul04               *
      *                 CSE075             Date 17Nov05               *
      *                 BUG8915            Date 07Oct05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 26May05               *
      *                 CGL014             Date 20Oct03               *
      *                 CSE037             Date 29Apr02               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 210378             Date 15Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 16Nov01               *
      *                 CSE032             Date 13Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 12Jan01               *
      *                 183604             Date 16Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  MD035962 - NCD incorrectly defaulted to maturity date. Make  *
      *             sure next coupon date is defaulted first before   *
      *             validation in SRVNxtCD. Additional fix done for   *
      *             defaulting of first coupon date when left blank.  *
      *  MD000091 - Event Codes Substitution                          *
      *  AR1077984 - Serious Midas Error on Security Details          *
      *  AR750169 - SE: Unexpectedly big amount of coupon interest    *
      *             accrual for EBRDB02 on 20.01.2011. Checks if the  *
      *             coupon array amended falls on the last coupon     *
      *             date. (Child: AR750194)                           *
      *  AR947093 - Base Rate amendment resulted to 0 interest rate   *
      *  AR847249 - Negative interest is shown in the main list and   *
      *             Loan Details enquiry screen                       *
      *  AR881060 - No validation on Blank base rate                  *
      *  CRE073 - Interest Rate Rounding                              *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  BUG11215 - SEFRN Wrong First Coupon Date/LCPN defaulted by   *
      *             FRN Business Day Convention (Recompile)           *
      *  BUG11193 - Purchased Interest not calculated on BackValued   *
      *             Trade. (Recompile)                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10847R- Incorrect Last and Next Coupon Dates              *
      *  BUG10847 - Last and Next Coupon Date fields not defaulted    *
      *  BUG10083 Incorrect validation in SESECS2VL. S/R's            *
      *           SRVLstCD and SRVNxtCD were not being  called        *
      *           in insert mode.                                     *
      *  CGL032 - Automatic Exchange of Information (Recompile)       *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  BUG8915- Incorrect validation in SESECS2VL by CSE071         *
      *  CSE074 - Const. Yield Amort. on Mortgage backed assets       *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CSE037 - Countervalue rounding                               *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  210378 - Show warning message instead of blocking message    *
      *           if security reference already exists for an other   *
      *           security (like ISIN code)                           *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *  CSE032 - Recompiled over changed SEVSYLDBS.                  *
      *  CSD006 - Market Data Feed (recompile)                        *
      *  183604 - Industry Code and Market Center must be mandatory   *
      *           when new PB Module is switched ON. Rating Code      *
      *           must be validated against new table PBRATIPD when   *
      *           new PB Module is switched ON.                       *
      *  CAP137 - Conversion of SE Securities Input into modular      *
      *           structure to use as APIs.                           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,SESEC2V001
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
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
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *                                                                                    BUG10847R
      ** Data Structure to hold Coupon/Rate Days array                                     BUG10847R
     D WSCD            S              4A   DIM(12)                                         BUG10847R
      *                                                                                    BUG10847R
      ** Data Structure to hold Coupon/Rate Indicators array                               BUG10847R
     D WSCR            S              1A   DIM(12)                                         BUG10847R
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     D NwSE2ScnFmt   E DS                  EXTNAME(SESEC2PD)
      *
      ** Security screen 2 details retrieved from file - screen format
     D CrSE2ScnFmt   E DS                  EXTNAME(SESEC2PD)
     D                                     PREFIX(O:1)
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     D NwSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
      *
      ** Securities screen 1 details retrieved from file
      ** - screen format
     D CrSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
     D                                     PREFIX(O)
      *                                                                                       CSE071
      ** Securities screen 6 details from incoming transaction                                CSE071
      ** - screen format                                                                      CSE071
     D NwSE6ScnFmt   E DS                  EXTNAME(SESEC6PD)                                  CSE071
      *                                                                                       CSE071
      ** Securities Screen 6 Details Retrieved From File                                      CSE071
      ** - Screen Format                                                                      CSE071
     D CrSE6ScnFmt   E DS                  EXTNAME(SESEC6PD)                                  CSE071
     D                                     PREFIX(O)                                          CSE071
      *
      ** Securities for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
      ** Coupon/Rate days
     D  CDArr                183    230
      ** Coupon/Rate inds
     D  CRArr                231    242
      *
      ** Securities retrieved from file - file format
     D CrSEFilFmt    E DS                  EXTNAME(SECTYD)
      *
      ** Securities screen 2 error indicators
     D SEESEC2       E DS                  EXTNAME(SEESEC2PD)
      *
      ** Externally described DS for SAR details                                              CRE073
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CRE073
     D  SLCD         E                     EXTFLD(LCD)                                        CRE073
      *                                                                                       CRE073
      ** Externally described DS for Base Rate Details                                        CRE073
     D   SDBSRT      E DS                  EXTNAME(SDBSRTPD)                                  CRE073
      *                                                                                       CRE073
      ** DS for Access Objects - second data structure                                        CRE073
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CRE073
      *                                                                                       CRE073
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D Idx             S              3P 0
      *
      ** Index for arrays of warning error message ids, etc.
     D WIdx            S              3P 0
      *
      ** Index for arrays of warning error message ids, etc.
     D Ix              S              3P 0
      *
      ** Response Mode, received as a parameter from the common header
     D PRespMode       S              1A
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     D PMode           S              6A
      *
      ** Redisplay screen
     D PReDsp          S              1A
      *
      ** Work parameters
     D*PSDC1****       S              6S 0                                                    CSD027
     D*PSDC2****       S              6S 0                                                    CSD027
     D*PSDC3****       S              6S 0                                                    CSD027
     D PSDC1           S              6A                                                      CSD027
     D PSDC2           S              6A                                                      CSD027
     D PSDC3           S              6A                                                      CSD027
     D PBsRtSpd        S             16A
     D PCpnRt          S             15P 0
     D PPROT           S              1A
     D PPrCpn          S              1A
     D PNmDp           S              1P 0
     D PVlDp           S              1P 0
     D WShare          S              1A
     D WIntst          S              1A
     D PMKTN           S             20A
     D PLCD            S              5P 0                                                  BUG10847
     D PNCD            S              5P 0                                                  BUG10847
     D ZDAYNO          S              5  0                                                  BUG10847
     D ZDATE           S              6  0                                                  BUG10847
     D ZADATE          S              7                                                     BUG10847
     D ZADATE2         S              6                                                    BUG10847R
     D WWSCD           S             48A                                                   BUG10847R
     D WWSCR           S             12A                                                   BUG10847R
     D WFCPN           S              5  0                                                 BUG10847R
     D WITLDFlag       S              1A                                                   BUG10847R
     D WCPDRTFlag      S              1A                                                   BUG10847R
     D ErrorFlag       S              1A                                                   BUG10847R
     D PRtCd           S              7A                                                      CRE073
     D POptn           S              7A                                                      CRE073
     D PSard           S              6A                                                      CRE073
     D PFinalRate      S             11P 7                                                  AR847249
     D WBsRt           S             11P 7                                                    CRE073
     D WDDBRTT         S             12A                                                      CRE073
      *
      ** Standing data
     D BJDNWD          S              5P 0
     D BJRDNB          S              5P 0
     D BJDFIN          S              1A
     D BVCIAK          S              1A
     D BGRKMG          S              1A
     D BGN4ST          S              1A                                        183604
      *
      ** Switchable features
     D CSE005          S              1A
     D CSE007          S              1A
     D CSE011          S              1A
     D CEU017          S              1A
     D CSE031          S              1A                                                      CSE031
     D CSE037          S              1A                                                      CSE037
     D CSE071          S              1A                                                      CSE071
     D CRE073          S              1A                                                      CRE073
      *                                                                                       CRE073
      ** OK Flags                                                                             CRE073
     D DDDCSGOK        S              1A                                                      CRE073
     D DDDCSPOK        S              1A                                                      CRE073
     D DDRDFDOK        S              1A                                                      CRE073
     D DDRDMTOK        S              1A                                                      CRE073
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,SESEC2V002
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** M A I N  P R O C E S S I N G
      ** ============================
      *
 
      /COPY WNCPYSRC,SESEC2V003
      *
      ** Validate value date positions.
      *
      /COPY WNCPYSRC,SESEC2V004
 
     C                   EXSR      SRVVldPos
      *
      ** Share entries
      ** =============
      *
      /COPY WNCPYSRC,SESEC2V005
 
     C                   EVAL      WShare = *BLANK
 
     C                   IF        PPROT = '4' OR PPROT = '7'
 
      /COPY WNCPYSRC,SESEC2V006
      *
      ** Validate initial dividend date
      *
      /COPY WNCPYSRC,SESEC2V007
 
     C                   EXSR      SRVIDivDt
 
      /COPY WNCPYSRC,SESEC2V008
      *
      ** Validate dividend payment dates/Coupon rate/days & ind.
      *
      /COPY WNCPYSRC,SESEC2V009
 
     C                   EXSR      SRVDivP_CpnR
 
      /COPY WNCPYSRC,SESEC2V010
      *
      ** Validate next expected dividend
      *
      /COPY WNCPYSRC,SESEC2V011
 
     C                   EXSR      SRVNExpD
 
     C                   ELSE
 
     C                   EVAL      WShare = 'N'
 
     C                   EVAL      DDIDIV = *BLANKS
     C                   EVAL      S1IDIV = *ZEROS
 
     C                   EVAL      DDNEXD = *BLANKS
     C                   EVAL      S1NEXD = *ZEROS
 
     C                   ENDIF
 
      /COPY WNCPYSRC,SESEC2V012
      *
      ** Validate roll forward dividend date
      *
      /COPY WNCPYSRC,SESEC2V013
 
     C                   IF        BGRKMG = 'Y' AND
     C                             (PPROT  = '4' OR PPROT = '7')
     C                   EXSR      SRVRFDivI
     C                   ELSE
     C                   EVAL      S1RFDI = 'N'
 
     C                   IF        BGRKMG = 'Y'
     C                   EVAL      DDRFDI = 'N'
     C                   ELSE
     C                   EVAL      DDRFDI = *BLANK
     C                   ENDIF
 
     C                   ENDIF
 
      /COPY WNCPYSRC,SESEC2V014
      *
      ** Discount entries
      ** =============
      *
     C                   IF        S1STBS = 'D' OR S1STBS = 'Y' AND
     C                             PPROT = '9'
      /COPY WNCPYSRC,SESEC2V015
      *
      ** Validate maturity date
      *
      /COPY WNCPYSRC,SESEC2V016
 
     C                   EXSR      SRVMatDat1
 
      /COPY WNCPYSRC,SESEC2V017
      *
      ** Validate maturity date indicator
      *
      /COPY WNCPYSRC,SESEC2V018
 
     C                   EXSR      SRVMatDtI1
 
      /COPY WNCPYSRC,SESEC2V019
      *
      ** Validate day basis
      *
      /COPY WNCPYSRC,SESEC2V020
 
     C                   EXSR      SRVDayBs1
 
      /COPY WNCPYSRC,SESEC2V021
      *
      ** Validate divisor basis
      *
      /COPY WNCPYSRC,SESEC2V022
 
     C                   EXSR      SRVDivBs1
 
      /COPY WNCPYSRC,SESEC2V023
      *
      ** Validate contingency liability indicator 1
      *
      /COPY WNCPYSRC,SESEC2V024
 
     C                   EXSR      SRVCLInd
 
     C                   ELSE
     C                   EVAL      DDMATY1 = *BLANKS
     C                   EVAL      S1MATY = *ZERO
 
     C                   EVAL      DDMDTI1 = *BLANKS
     C                   EVAL      S1MDTI = *BLANKS
 
     C                   EVAL      DDDYBS1 = *BLANKS
     C                   EVAL      S1DYBS = *BLANKS
 
     C                   EVAL      DDDVBS1 = *BLANKS
     C                   EVAL      S1DVBS = *BLANKS
 
     C                   EVAL      DDCNLI1 = *BLANKS
     C                   EVAL      S1CNLI = *BLANKS
 
     C                   ENDIF
 
      /COPY WNCPYSRC,SESEC2V025
      *
      ** Interest security entries 1
      ** ===========================
      *
     C                   EVAL      WIntst = *BLANK
 
     C                   IF        (S1STBS = 'P' AND PPROT <> '2' AND
     C                             PPROT <> '4' AND PPROT <> '7') OR
     C                             (S1STBS = 'Y' AND PPROT <> '2' AND
     C                             PPROT <> '4' AND PPROT <> '7' AND
     C                             PPROT <> '9')
      /COPY WNCPYSRC,SESEC2V026
      *
      ** Validate coupon rate
      *
      /COPY WNCPYSRC,SESEC2V027
 
     C                   EXSR      SRVCpnRt
 
      /COPY WNCPYSRC,SESEC2V028
      *
      ** Validate base rate code
      *
      /COPY WNCPYSRC,SESEC2V029
 
     C                   EXSR      SRVBsRtCd
 
      /COPY WNCPYSRC,SESEC2V030
      *                                                                                       CRE073
      ** Retrieve Base Rate                                                                   CRE073
      *                                                                                       CRE073
     C                   EXSR      SRRtvBsRt                                                  CRE073
      *                                                                                       CRE073
     C                   IF        CRE073 = 'Y' AND                                           CRE073
     C                             (PPROT = '3' OR PPROT = '8')                               CRE073
     C                   EVAL      PModule = 'SECU  '                                         CRE073
      *                                                                                       CRE073
      ** Validate Contractual Spread and Sign                                                 CRE073
      *                                                                                       CRE073
     C                   EXSR      SRVCSpdSn                                                  CRE073
      *                                                                                       CRE073
      ** Validate Rounding Method                                                             CRE073
      *                                                                                       CRE073
     C                   EXSR      SRVRndMtd                                                  CRE073
      *                                                                                       CRE073
      ** Validate Rounding Fraction/Decimal                                                   CRE073
      *                                                                                       CRE073
     C                   EXSR      SRVRndFrDc                                                 CRE073
      *                                                                                       CRE073
      ** If all fields are valid, compute for the new spread rate                             CRE073
      ** based on the interest rate rounding rules                                            CRE073
      *                                                                                       CRE073
     C                   IF        DDDCSPOK = 'Y' AND DDDCSGOK = 'Y'                          CRE073
     C                             AND DDRDMTOK = 'Y' AND DDRDFDOK = 'Y'                      CRE073
      *                                                                                       CRE073
     C                   EXSR      SRNwSprRt                                                  CRE073
      *                                                                                       CRE073
     C                   EVAL      S1BASS = PNewSpread                                        CRE073
     C                   EVAL      S1SPRI = DDSPRI                                            CRE073
     C                   EVAL      S1CNSP = TMCNSP                                            CRE073
     C                   EVAL      S1CNSG = DDCNSG                                            CRE073
     C                   EVAL      S1RDMT = DDRDMT                                            CRE073
     C                   EVAL      S1RDFD = DDRDFD                                            CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
     C                   ELSE                                                                 CRE073
      *
      ** Validate base rate spread
      *
      /COPY WNCPYSRC,SESEC2V031
 
     C                   EXSR      SRVBsRtSpd
 
      /COPY WNCPYSRC,SESEC2V032
      *
      ** Validate spread indicator
      *
      /COPY WNCPYSRC,SESEC2V033
 
     C                   EXSR      SRVSpdInd
 
      /COPY WNCPYSRC,SESEC2V034
      *                                                                                       CRE073
     C                   ENDIF                                                                CRE073
      *
      ** Validate minimum coupon
      *
      /COPY WNCPYSRC,SESEC2V035
 
     C                   EXSR      SRVMinCpn
 
      /COPY WNCPYSRC,SESEC2V036
      *
      ** Validate maturity date
      *
      /COPY WNCPYSRC,SESEC2V037
 
     C                   EXSR      SRVMatDat2
 
      /COPY WNCPYSRC,SESEC2V038
      *
      ** Validate maturity date indicator
      *
      /COPY WNCPYSRC,SESEC2V039
 
     C                   EXSR      SRVMatDtI2
 
      /COPY WNCPYSRC,SESEC2V040
      *
      ** Validate long term maturity indicator
      *
      /COPY WNCPYSRC,SESEC2V041
 
     C                   EXSR      SRVLTMatI
 
      /COPY WNCPYSRC,SESEC2V042
      *
      ** Validate day basis
      *
      /COPY WNCPYSRC,SESEC2V043
 
     C                   EXSR      SRVDayBs2
 
      /COPY WNCPYSRC,SESEC2V044
      *
      ** Validate divisor basis
      *
      /COPY WNCPYSRC,SESEC2V045
 
     C                   EXSR      SRVDivBs2
 
      /COPY WNCPYSRC,SESEC2V046
      *
      ** Validate interest adjustment
      *
      /COPY WNCPYSRC,SESEC2V047
 
     C                   EXSR      SRVIntAdj
 
      /COPY WNCPYSRC,SESEC2V048
      *
      ** Validate initial date
      *
      /COPY WNCPYSRC,SESEC2V049
 
     C                   EXSR      SRVIntlDat
 
      /COPY WNCPYSRC,SESEC2V050
      *
      ** Validate contingency liability indicator 2
      *
      /COPY WNCPYSRC,SESEC2V051
 
     C                   EXSR      SRVCLInd
 
     C                   ELSE
 
     C                   EVAL      WIntst = 'N'
 
     C                   EVAL      DDCPNR = *BLANKS
     C                   EVAL      S1CPNR = *ZEROS
 
     C                   EVAL      DDBASC = *BLANKS
     C**********         EVAL      S1BASC = *ZEROS                                            CSD103
     C                   EVAL      S1BASC = *BLANKS                                           CSD103
 
     C                   EVAL      DDBASS = *BLANKS
     C                   EVAL      S1BASS = *ZEROS
     C
     C                   EVAL      DDSPRI = *BLANKS
     C                   EVAL      S1SPRI = *BLANKS
     C
     C                   EVAL      DDMCPN = *BLANKS
     C                   EVAL      S1MCPN = *ZEROS
     C
     C                   EVAL      DDMATY2 = *BLANKS
     C                   EVAL      DDMDTI2 = *BLANKS
     C
     C                   EVAL      DDLTMI = *BLANKS
     C                   EVAL      S1LTMI = 'N'
     C
     C                   EVAL      DDDYBS2 = *BLANKS
     C                   EVAL      DDDVBS2 = *BLANKS
 
     C                   EVAL      DDIADJ = *BLANKS
     C                   EVAL      S1IADJ = *ZEROS
 
     C                   EVAL      DDITLD = *BLANKS
     C                   EVAL      S1ITLD = *ZEROS
 
     C                   EVAL      DDCNLI2 = *BLANKS
 
     C                   ENDIF
 
      /COPY WNCPYSRC,SESEC2V052
      *
      ** Validate risk customer
      *
      /COPY WNCPYSRC,SESEC2V053
 
     C                   EXSR      SRVRCust
 
      /COPY WNCPYSRC,SESEC2V054
      *
      ** Validate business day convention
      *
      /COPY WNCPYSRC,SESEC2V055
 
     C                   IF        CSE005 = 'Y'
     C                   EXSR      SRVBDCnv
     C                   ELSE
     C                   EVAL      DDBCNV = *BLANKS
     C                   ENDIF
 
     C                   IF        CSE031 = 'Y'                                               CSE031
     C                             OR CSE071 = 'Y'                                            CSE071
     C                   IF        PPROT = '3' OR PPROT = '8'                                 CSE031
     C**************************** OR CSE071 = 'Y' AND (PPROT = '1' OR                CSE071 BUG8915
     C**************************** PPROT = '5' OR PPROT = '6' OR PPROT = '9')         CSE071 BUG8915
     C                             OR CSE071 = 'Y' AND                                       BUG8915
     C                             ((S1STBS = 'P' AND PPROT <> '2' AND                       BUG8915
     C                             PPROT <> '4' AND PPROT <> '7') OR                         BUG8915
     C                             (S1STBS = 'Y' AND PPROT <> '2' AND                        BUG8915
     C                             PPROT <> '4' AND PPROT <> '7' AND                         BUG8915
     C                             PPROT <> '9'))                                            BUG8915
      *                                                                                       CSE031
     C**********         IF        DDACTN <> 'I'                                     CSE031 BUG10083
                                                                                            BUG10847
      ** Get default value of Last Coupon Date                                              BUG10847
                                                                                            BUG10847
     C                   IF        DDACTN =  'I'  AND DDLCPN = *BLANKS                      BUG10847
     C                   EXSR      SRGetLCD                                                 BUG10847
     C                   ENDIF                                                              BUG10847
                                                                                            BUG10847
      ** Validate the Last Coupon Date.                                                       CSE031
     C                   EXSR      SRVLstCD                                                   CSE031
      *                                                                                       CSE031
      ***Validate*the*Next Coupon Date.*******************************               CSE031 MD035962
     C**********         EXSR      SRVNxtCD                                          CSE031 MD035962
                                                                                            BUG10847
     C                   IF        DDACTN =  'I'  AND DDNCD  = *BLANKS                      BUG10847
     C                   EXSR      SRGetNCD                                                 BUG10847
     C                   ENDIF                                                              BUG10847
                                                                                            BUG10847
      ** Validate the Next Coupon Date.                                                     MD035962
      *                                                                                     MD035962
     C                   EXSR      SRVNxtCD                                                 MD035962
      *                                                                                       CSE031
     C**********         ENDIF                                                       CSE031 BUG10083
      *                                                                                       CSE071
     C                   ENDIF                                                                CSE071
     C                   ENDIF                                                                CSE071
                                                                                              CSE071
     C                   IF        CSE031 = 'Y'                                               CSE071
     C                   IF        PPROT = '3' OR PPROT = '8'                                 CSE071
      *                                                                                       CSE031
      ** Validate the Fixing Days.                                                            CSE031
     C                   EXSR      SRVFixDy                                                   CSE031
      *                                                                                       CSE031
      ** Validate the Auto Fix.                                                               CSE031
     C                   EXSR      SRVAuFx                                                    CSE031
      *                                                                                       CSE031
     C                   ENDIF                                                                CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
      /COPY WNCPYSRC,SESEC2V056
      *
      ** If not interest security, set first coupon to blanks
      ** to default value to next coupon date after initial
      ** date in validation module.
      *
     C                   IF        WIntst = 'N'
     C                   EVAL      DDFCPN = *BLANKS
     C                   ENDIF
      *
      ** Validate first coupon date
      *
      /COPY WNCPYSRC,SESEC2V057
 
     C                   EXSR      SRVFstCpn
 
     C                   IF        DDFCPN = *BLANKS                                         MD035962
     C                             AND S1FCPN <> 0                                          MD035962
      *                                                                                     MD035962
     C                   Z-ADD     S1FCPN        ZDAYNO                                     MD035962
      *                                                                                     MD035962
     C                   CALLB     'ZDATE2'                                                 MD035962
     C                   PARM                    ZDAYNO                                     MD035962
     C                   PARM                    BJDFIN                                     MD035962
     C                   PARM      *ZEROS        ZDATE                                      MD035962
     C                   PARM      *BLANKS       ZADATE                                     MD035962
      *                                                                                     MD035962
     C                   MOVEL     ZDATE         DDFCPN                                     MD035962
      *                                                                                     MD035962
     C                   IF        S1FCPN > PNCD                                            MD035962
     C                   Z-ADD     S1FCPN        PNCD                                       MD035962
     C                   MOVEL     DDFCPN        DDNCD                                      MD035962
     C                   ENDIF                                                              MD035962
      *                                                                                     MD035962
     C                   ENDIF                                                              MD035962
      *                                                                                     MD035962
      /COPY WNCPYSRC,SESEC2V058
      *
      ** Interest security entries 2
      ** ===========================
      *
     C                   IF        WIntst <> 'N'
      *
      ** Validate dividend payment dates/Coupon rate/days & ind.
      *
      /COPY WNCPYSRC,SESEC2V059
 
     C                   EXSR      SRVDivP_CpnR
 
      /COPY WNCPYSRC,SESEC2V060
      *
      ** Validate rate change frequency
      *
      /COPY WNCPYSRC,SESEC2V061
 
     C                   EXSR      SRVRChgFrq
 
      /COPY WNCPYSRC,SESEC2V062
      *
      ** Validate next change date
      *
      /COPY WNCPYSRC,SESEC2V063
 
     C                   EXSR      SRVNChgDat
 
     C                   ELSE
 
     C                   EVAL      DDFCPN = *BLANKS
     C                   EVAL      S1FCPN = *ZEROS
 
     C                   EVAL      DDCR01 = *BLANKS
     C                   EVAL      DDCR02 = *BLANKS
     C                   EVAL      DDCR03 = *BLANKS
     C                   EVAL      DDCR04 = *BLANKS
     C                   EVAL      DDCR05 = *BLANKS
     C                   EVAL      DDCR06 = *BLANKS
     C                   EVAL      DDCR07 = *BLANKS
     C                   EVAL      DDCR08 = *BLANKS
     C                   EVAL      DDCR09 = *BLANKS
     C                   EVAL      DDCR10 = *BLANKS
     C                   EVAL      DDCR11 = *BLANKS
     C                   EVAL      DDCR12 = *BLANKS
     C                   EVAL      CRArr = *BLANKS
 
     C                   IF        WShare = 'N'
     C                   EVAL      DDCD01 = *BLANKS
     C                   EVAL      DDCD02 = *BLANKS
     C                   EVAL      DDCD03 = *BLANKS
     C                   EVAL      DDCD04 = *BLANKS
     C                   EVAL      DDCD05 = *BLANKS
     C                   EVAL      DDCD06 = *BLANKS
     C                   EVAL      DDCD07 = *BLANKS
     C                   EVAL      DDCD08 = *BLANKS
     C                   EVAL      DDCD09 = *BLANKS
     C                   EVAL      DDCD10 = *BLANKS
     C                   EVAL      DDCD11 = *BLANKS
     C                   EVAL      DDCD12 = *BLANKS
     C                   EVAL      CDArr = *ZEROS
     C                   ENDIF
 
     C                   EVAL      DDRCFQ = *BLANK
     C                   EVAL      S1RCFQ = *BLANK
 
     C                   EVAL      DDNCHD = *BLANKS
     C                   EVAL      S1NCHD = *ZEROS
 
     C                   ENDIF
 
      /COPY WNCPYSRC,SESEC2V064
 
      *
      ** Screen defaults
      ** ===============
      *
      /COPY WNCPYSRC,SESEC2V065
      *
      ** Validate depot security references
      *
      /COPY WNCPYSRC,SESEC2V066
 
     C                   EXSR      SRVDptSRef
 
      /COPY WNCPYSRC,SESEC2V067
      *
      ** Validate market center
      *
      /COPY WNCPYSRC,SESEC2V068
 
     C                   EXSR      SRVMktCtr
 
      /COPY WNCPYSRC,SESEC2V069
      *
      ** Validate convertible indicator
      *
      /COPY WNCPYSRC,SESEC2V070
 
     C                   EXSR      SRVCnvInd
 
      /COPY WNCPYSRC,SESEC2V071
      *
      ** Validate price basis
      *
      /COPY WNCPYSRC,SESEC2V072
 
     C                   EXSR      SRVPrcBs
 
      /COPY WNCPYSRC,SESEC2V073
      *
      ** Validate yield basis
      *
      /COPY WNCPYSRC,SESEC2V074
 
     C                   EXSR      SRVYldBs
 
      /COPY WNCPYSRC,SESEC2V075
 
     C                   IF        DDSYBS = 'AU'
      *
      ** Validate compounding frequency
      *
      /COPY WNCPYSRC,SESEC2V076
 
     C                   EXSR      SRVCpdFrq
 
      /COPY WNCPYSRC,SESEC2V077
      *
      ** Validate discount basis
      *
      /COPY WNCPYSRC,SESEC2V078
 
     C                   EXSR      SRVDscBs
 
      /COPY WNCPYSRC,SESEC2V079
      *
      ** Validate discount last coupon
      *
      /COPY WNCPYSRC,SESEC2V080
 
     C                   EXSR      SRVDscLCpn
 
     C                   ELSE
     C                   EVAL      DDCMFQ = *BLANKS
     C                   EVAL      S1CMFQ = *ZEROS
 
     C                   EVAL      DDDSCB = *BLANKS
     C                   EVAL      S1DSCB = *BLANKS
 
     C                   EVAL      DDDSLC = *BLANKS
     C                   EVAL      S1DSLC = *BLANKS
 
     C                   ENDIF
 
      *
      ** Partly paid entries
      ** ===================
      *
     C                   IF        DDPPDI = 'Y'
      *
      /COPY WNCPYSRC,SESEC2V081
      *
      ** Validate initial price
      *
      /COPY WNCPYSRC,SESEC2V082
 
     C                   EXSR      SRVIntlPrc
 
      /COPY WNCPYSRC,SESEC2V083
      *
      ** Validate fully paid price
      *
      /COPY WNCPYSRC,SESEC2V084
 
     C                   EXSR      SRVFulPrc
 
     C                   ELSE
     C                   EVAL      DDSINP = *BLANKS
     C                   EVAL      DDSFPP = *BLANKS
     C                   EVAL      S1SINP = SINP
     C                   EVAL      S1SFPP = SFPP
     C                   EVAL      S1CPDP = CPDP
     C                   EVAL      S1TPHD = TPHD
     C                   ENDIF
 
      /COPY WNCPYSRC,SESEC2V085
      *
      ** Issue amount
      ** ============
      *
      /COPY WNCPYSRC,SESEC2V086
     C                   IF        DDERPY = 'Y' AND
     C                             BGRKMG = 'Y'
     C                   EXSR      SRVIssAmt
     C                   ELSE
     C                   EVAL      DDISA1 = *BLANKS
     C                   EVAL      S1ISSA = ISSA
     C                   ENDIF
 
      /COPY WNCPYSRC,SESEC2V087
 
      *                                                                                       CSE037
      ** Countervalue rounding (no switch check here, must always default)                    CSE037
      *                                                                                       CSE037
     C                   EXSR      SRVndec                                                    CSE037
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      *
      /COPY WNCPYSRC,SESEC2V088
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVVldPos - Validate value data positions.                   *
      *                                                               *
      *****************************************************************
 
     C     SRVVldPos     BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSVDPOS'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Securities screen 2 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE2ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDxAr
     C                   PARM                    WMsgDtXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVIDivDt - Validate Initial Dividend Date                   *
      *                                                               *
      *****************************************************************
 
     C     SRVIDivDt     BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSIDVDT'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdxAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVRFDivI - Validate Roll Forward Dividend Indicator         *
      *                                                               *
      *****************************************************************
 
     C     SRVRFDivI     BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSRFDI'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdxAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVNExpD - Validate Next Expected Dividend                   *
      *                                                               *
      *****************************************************************
 
     C     SRVNExpD      BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSNEDIV'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Value currency's no. of decimal places
     C                   PARM                    PVlDp
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDxAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVDivP_CpnR - Validate Dividend Payment Dates & Coupon      *
      *                Rate/Days & Indicators.                        *
      *                                                               *
      *****************************************************************
 
     C     SRVDivP_CpnR  BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSCPDRT'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *                                                                                     AR750169
      ** Securities retrieved from file - file format                                       AR750169
      *                                                                                     AR750169
     C                   PARM                    CrSEFilFmt                                 AR750169
      *
      ** Processing type, from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Coupon rate
     C                   PARM                    PCpnRt
      *
      ** Protect coupon rate/days
     C                   PARM                    PPrCpn
      *
      ** STANDING DATA
      ** =============
      *                                                                                     AR750169
      ** SDBANK - Runday number                                                             AR750169
      *                                                                                     AR750169
     C                   PARM                    BJRDNB                                     AR750169
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** SWITCHABLE FEATURE
      ** ==================
      *
      ** Effect of holidays on FRN coupon date
     C                   PARM                    CSE005
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes.                                               CSE031
     C                   PARM                    CSE031                                       CSE031
      *                                                                                       CSE071
      ** Multiple Holidays                                                                    CSE071
     C                   PARM                    CSE071                                       CSE071
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDxAr
     C                   PARM                    WMsgDtXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVMatDat1 - Validate Maturity Date                          *
      *                                                               *
      *****************************************************************
 
     C     SRVMatDat1    BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSMDAT1'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Runday number
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDxAr
     C                   PARM                    WMsgDtXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVMatDtI1 - Validate Maturity Date Indicator                *
      *                                                               *
      *****************************************************************
 
     C     SRVMatDtI1    BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSMDTI1'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Processing type, from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVDayBs1 - Validate Day Basis                               *
      *                                                               *
      *****************************************************************
 
     C     SRVDayBs1     BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSDYBS1'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVDivBs1 - Validate Divisor Basis                           *
      *                                                               *
      *****************************************************************
 
     C     SRVDivBs1     BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSDVBS1'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Corporate Actions
     C                   PARM                    CSE007
      ** Securities Redenomination
     C                   PARM                    CEU017
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDxAr
     C                   PARM                    WMsgDtXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCLInd - Validate Contingency Liability Indicator          *
      *                                                               *
      *****************************************************************
 
     C     SRVCLInd      BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSCNLBI'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Processing type, from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVRCust - Validate Risk Customer                            *
      *                                                               *
      *****************************************************************
 
     C     SRVRCust      BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSRCUST'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (SCREEN INPUT function)
     C                   PARM                    PMode
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Processing type, from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Redisplay screen
     C                   PARM                    PReDsp
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCpnRt - Validate Coupon Rate                              *
      *                                                               *
      *****************************************************************
 
     C     SRVCpnRt      BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSCPNRT'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDxAr
     C                   PARM                    WMsgDtXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Coupon rate
     C                   PARM                    PCpnRt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************                       CRE073
      *                                                               *                       CRE073
      *  SRRtvBsRt - Retrieve Base Rate                               *                       CRE073
      *                                                               *                       CRE073
      *****************************************************************                       CRE073
      *                                                                                       CRE073
     C     SRRtvBsRt     BEGSR                                                                CRE073
      *                                                                                       CRE073
     C                   CALL      'AOBSRTR0'                                                 CRE073
     C                   PARM      *BLANKS       PRtCd                                        CRE073
     C                   PARM      '*KEY   '     POptn                                        CRE073
     C                   PARM                    S1NMCY                                       CRE073
     C                   PARM                    DDBASC                                       CRE073
     C     SDBSRT        PARM      SDBSRT        DSSDY                                        CRE073
      *                                                                                       CRE073
     C                   EVAL      WBsRt = 0                                                  CRE073
     C                   EVAL      WDDBRTT = *BLANKS                                        AR881060
     C                   IF        PRtCd = *BLANKS                                            CRE073
     C                   EVAL      WBsRt = BACBSR                                             CRE073
     C**********         EVAL      WDDBRTT = *BLANKS                                 CRE073 AR881060
     C                   IF        WBsRT <> 0                                                 CRE073
     C                   EVAL      WDDBRTT = %CHAR(WBsRt)                                     CRE073
     C                   EVAL      WDDBRTT = %TRIMR(WDDBRTT)                                  CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************
      *                                                               *
      *  SRVBsRtCd - Validate Base Rate Code                          *
      *                                                               *
      *****************************************************************
 
     C     SRVBsRtCd     BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSBSRTC'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (SCREEN INPUT function)
     C                   PARM                    PMode
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Redisplay screen
     C                   PARM                    PReDsp
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVBsRtSpd - Validate Base Rate Spread                       *
      *                                                               *
      *****************************************************************
      *
     C     SRVBsRtSpd    BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSBSRTSP'
      *                             ==========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Work variable for Base Rate Spread
     C                   PARM                    PBsRtSpd
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVSpdInd - Validate Spread Indicator                        *
      *                                                               *
      *****************************************************************
 
     C     SRVSpdInd     BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSSPIND'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Work variable for Base Rate Spread
     C                   PARM                    PBsRtSpd
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************                       CRE073
      *                                                               *                       CRE073
      *  SRVCSpdSn - Validate Contractual Spread and Sign             *                       CRE073
      *                                                               *                       CRE073
      *****************************************************************                       CRE073
      *                                                                                       CRE073
     C     SRVCSpdSn     BEGSR                                                                CRE073
      *                                                                                       CRE073
      ** Reset variables updated by each module                                               CRE073
      *                                                                                       CRE073
     C                   EXSR      SRResetErrs                                                CRE073
      *                                                                                       CRE073
     C                   CALL      'ZAVCSPSG'                                                 CRE073
      *                                                                                       CRE073
      ** Input                                                                                CRE073
      *                                                                                       CRE073
     C                   PARM      *BLANKS       RetCodeOut                                   CRE073
     C                   PARM                    WDDBRTT                                      CRE073
     C                   PARM                    DDBASC                                       CRE073
     C                   PARM      *ZEROS        PFixRate         12                          CRE073
     C                   PARM                    DDCNSP                                       CRE073
     C                   PARM                    DDCNSG                                       CRE073
      *                                                                                       CRE073
      ** Output                                                                               CRE073
      *                                                                                       CRE073
     C                   PARM      *ZEROS        TMCNSP           11 7                        CRE073
     C                   PARM                    PModule           6                          CRE073
     C                   PARM      *ZEROS        PCurset           2 0                        CRE073
     C                   PARM                    FldNamXAr                                    CRE073
     C                   PARM                    MsgIDXAr                                     CRE073
     C                   PARM                    MsgDtaXAr                                    CRE073
     C                   PARM      *ZEROS        Indx              3 0                        CRE073
     C                   PARM                    DDDCSPOK                                     CRE073
     C                   PARM                    DDDCSGOK                                     CRE073
      *                                                                                       CRE073
      ** Update error info with that returned from the validation module                      CRE073
      *                                                                                       CRE073
     C                   IF        RetCodeOut <> *BLANKS                                      CRE073
     C                   EXSR      SRUpdatErrs                                                CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
     C                   ENDSR                                                                CRE073
      *                                                                                       CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *                                                               *                       CRE073
      *  SRVRndMtd - Validate Rounding Method                         *                       CRE073
      *                                                               *                       CRE073
      *****************************************************************                       CRE073
      *                                                                                       CRE073
     C     SRVRndMtd     BEGSR                                                                CRE073
      *                                                                                       CRE073
      ** Reset variables updated by each module                                               CRE073
      *                                                                                       CRE073
     C                   EXSR      SRResetErrs                                                CRE073
      *                                                                                       CRE073
     C                   CALL      'ZAVRNDMT'                                                 CRE073
      *                                                                                       CRE073
      ** Input                                                                                CRE073
      *                                                                                       CRE073
     C                   PARM      *BLANKS       RetCodeOut                                   CRE073
     C                   PARM                    DDRDMT                                       CRE073
     C                   PARM                    DDCNSP                                       CRE073
     C                   PARM                    DDRDFD                                       CRE073
     C                   PARM                    PModule                                      CRE073
     C                   PARM      *ZEROS        PCurset                                      CRE073
      *                                                                                       CRE073
      ** Output                                                                               CRE073
      *                                                                                       CRE073
     C                   PARM                    FldNamXAr                                    CRE073
     C                   PARM                    MsgIDXAr                                     CRE073
     C                   PARM                    MsgDtaXAr                                    CRE073
     C                   PARM      *ZEROS        Indx                                         CRE073
     C                   PARM                    DDRDMTOK                                     CRE073
      *                                                                                       CRE073
      ** Update error info with that returned from the validation module                      CRE073
      *                                                                                       CRE073
     C                   IF        RetCodeOut <> *BLANKS                                      CRE073
     C                   EXSR      SRUpdatErrs                                                CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
     C                   ENDSR                                                                CRE073
      *                                                                                       CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *                                                               *                       CRE073
      *  SRVRndFrDc - Validate Rounding Fraction/Decimal              *                       CRE073
      *                                                               *                       CRE073
      *****************************************************************                       CRE073
      *                                                                                       CRE073
     C     SRVRndFrDc    BEGSR                                                                CRE073
      *                                                                                       CRE073
      ** Reset variables updated by each module                                               CRE073
      *                                                                                       CRE073
     C                   EXSR      SRResetErrs                                                CRE073
      *                                                                                       CRE073
     C                   CALL      'ZAVRNDFD'                                                 CRE073
      *                                                                                       CRE073
      ** Input                                                                                CRE073
      *                                                                                       CRE073
     C                   PARM      *BLANKS       RetCodeOut                                   CRE073
     C                   PARM                    DDRDFD                                       CRE073
     C                   PARM                    DDCNSP                                       CRE073
     C                   PARM                    DDRDMT                                       CRE073
     C                   PARM                    PModule                                      CRE073
     C                   PARM      *ZEROS        PCurset                                      CRE073
      *                                                                                       CRE073
      ** Output                                                                               CRE073
      *                                                                                       CRE073
     C                   PARM                    FldNamXAr                                    CRE073
     C                   PARM                    MsgIDXAr                                     CRE073
     C                   PARM                    MsgDtaXAr                                    CRE073
     C                   PARM      *ZEROS        Indx                                         CRE073
     C                   PARM      *BLANKS       DDRDFDOK                                     CRE073
      *                                                                                       CRE073
      ** Update error info with that returned from the validation module                      CRE073
      *                                                                                       CRE073
     C                   IF        RetCodeOut <> *BLANKS                                      CRE073
     C                   EXSR      SRUpdatErrs                                                CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
     C                   ENDSR                                                                CRE073
      *                                                                                       CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *                                                               *                       CRE073
      *  SRNwSprRt - Compute for the New Spread Rate                  *                       CRE073
      *                                                               *                       CRE073
      *****************************************************************                       CRE073
      *                                                                                       CRE073
     C     SRNwSprRt     BEGSR                                                                CRE073
      *                                                                                       CRE073
     C                   CALL      'ZACALCSPRT'                                               CRE073
     C                   PARM      *BLANKS       RetCodeOut                                   CRE073
     C                   PARM                    WBsRt                                        CRE073
     C                   PARM                    TMCNSP                                       CRE073
     C                   PARM                    DDCNSG                                       CRE073
     C                   PARM                    DDRDMT                                       CRE073
     C                   PARM                    DDRDFD                                       CRE073
     C                   PARM      *ZERO         PNewSpread       11 7                        CRE073
     C                   PARM      *ZERO         PFinalRate                                 AR847249
      *                                                                                       CRE073
     C                   IF        RetCodeOut <> *BLANKS                                      CRE073
     C                   EXSR      *PSSR                                                      CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
     C**********         IF        PFinalRate <= 0 AND                             AR847249 AR947093
     C**********                   DDRDMT <> *BLANKS                               AR847249 AR947093
     C**********         EVAL      DDRDMTOK = 'N'                                  AR847249 AR947093
     C**********         EVAL      FldNamXAr(1) = 'DDRDMT'                         AR847249 AR947093
     C**********         EVAL      MsgIDXAr(1)  = 'USS0015'                        AR847249 AR947093
      **********                                                                   AR847249 AR947093
     C**********         EVAL      MsgDtaXAr(1) = %EDITC(PFinalRate:'J')           AR847249 AR947093
     C**********         EXSR      SRUpdatErrs                                     AR847249 AR947093
      **********                                                                   AR847249 AR947093
     C**********         ELSE                                                      AR847249 AR947093
     C                   IF        PNewSpread = 0                                             CRE073
     C                   EVAL      DDBASS = *BLANKS                                           CRE073
     C                   EVAL      DDSPRI = *BLANKS                                           CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      DDBASS = %CHAR(PNewSpread)                                 CRE073
     C                   EVAL      DDSPRI = DDCNSG                                            CRE073
     C                   IF        PNewSpread < 0                                             CRE073
                                                                                            AR847249
     C                   EVAL      OKSPRI = 'W'                                             AR847249
     C                   EVAL      WFldNmXAr(1) = 'DDSPRI'                                  AR847249
     C                   EVAL      WMsgIDXAr(1) = 'USS0016'                                 AR847249
     C**********         EVAL      WMsgDtXAr(1) = %EDITC(PNewSpread:'J')           AR847249 MD000091
     C                   EVAL      MsgDtaTmp = %EDITC(PNewSpread:'J')                       MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      WMsgDtXAr(1) = LenStr + %TRIM(MsgDtaTmp)                 MD000091
     C                   EXSR      SRUpdatErrs                                              AR847249
                                                                                            AR847249
     C                   EVAL      DDBASS = %CHAR(%ABS(PNewSpread))                           CRE073
     C                   SELECT                                                               CRE073
     C                   WHEN      DDCNSG = 'A'                                               CRE073
     C                   EVAL      DDSPRI = 'S'                                               CRE073
     C                   WHEN      DDCNSG = 'S'                                               CRE073
     C                   EVAL      DDSPRI = 'A'                                               CRE073
     C                   WHEN      DDCNSG = 'P'                                               CRE073
     C                   EVAL      DDSPRI = DDCNSG                                            CRE073
     C                   EVAL      DDBASS = %CHAR(PNewSpread)                                 CRE073
     C                   ENDSL                                                                CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CRE073
     C**********         ENDIF                                                     AR847249 AR947093
      *                                                                                       CRE073
     C                   ENDSR                                                                CRE073
      *                                                                                       CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************
      *                                                               *
      *  SRVMinCpn - Validate Minimum Coupon                          *
      *                                                               *
      *****************************************************************
 
     C     SRVMinCpn     BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSMINCP'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Coupon Rate
     C                   PARM                    PCpnRt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVMatDat2 - Validate Maturity Date 2                        *
      *                                                               *
      *****************************************************************
 
     C     SRVMatDat2    BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSMDAT2'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Corporate action
     C                   PARM                    CSE007
      *
      ** Securities redenomination
     C                   PARM                    CEU017
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Run date
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Date of next working day
     C                   PARM                    BJDNWD
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDxAr
     C                   PARM                    WMsgDtXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVMatDtI2 - Validate Maturity Date Indicator 2              *
      *                                                               *
      *****************************************************************
 
     C     SRVMatDtI2    BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSMDTI2'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Processing type, from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVLtMatI - Validate Long Term Maturity Indicator            *
      *                                                               *
      *****************************************************************
      *
     C     SRVLtMatI     BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSLTMIN'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVDayBs2 - Validate Day Basis 2                             *
      *                                                               *
      *****************************************************************
 
     C     SRVDayBs2     BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSDYBS2'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVDivBs2 - Validate Divisor Basis 2                         *
      *                                                               *
      *****************************************************************
      *
     C     SRVDivBs2     BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSDVBS2'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Coupon Rate
     C                   PARM                    PCpnRt
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Corporate actions
     C                   PARM                    CSE007
      *
      ** Securities redenomination
     C                   PARM                    CEU017
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDxAr
     C                   PARM                    WMsgDtXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVIntAdj - Validate Interest Adjustment                     *
      *                                                               *
      *****************************************************************
 
     C     SRVIntAdj     BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSINTAD'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVIntlDat - Validate Initial Date                           *
      *                                                               *
      *****************************************************************
 
     C     SRVIntlDat    BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSINDAT'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Coupon Rate
     C                   PARM                    PCpnRt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVFstCpn - Validate First Coupon Date                       *
      *                                                               *
      *****************************************************************
 
     C     SRVFstCpn     BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSFSTCP'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *                                                                                       CSE071
      ** Securities screen 6 details from incoming transaction                                CSE071
      ** - screen format                                                                      CSE071
     C                   PARM                    NwSE6ScnFmt                                  CSE071
      *
      ** Processing type, from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Work variable for coupon rate
     C                   PARM                    PCpnRt
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Effect of holidays on FRN coupon date
     C                   PARM                    CSE005
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes.                                               CSE031
     C                   PARM                    CSE031                                       CSE031
      *                                                                                       CSE071
      ** Multiple Holidays                                                                    CSE071
     C                   PARM                    CSE071                                       CSE071
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDxAr
     C                   PARM                    WMsgDtXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVRChgFrq - Validate Rate Change Frequency                  *
      *                                                               *
      *****************************************************************
 
     C     SRVRChgFrq    BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSRCFRQ'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVNChgDat - Validate Next Change Date                       *
      *                                                               *
      *****************************************************************
 
     C     SRVNChgDat    BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSNCHDT'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** SDBANK - Run day number
     C                   PARM                    BJRDNB
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVBdCnv - Validate Business Day Convetion                   *
      *                                                               *
      *****************************************************************
 
     C     SRVBdCnv      BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSBDCNV'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Processing type, from PF/INVTPD
     C                   PARM                    PPROT
      *                                                                                       CSE031
      ** SWITCHABLE FEATURES                                                                  CSE031
      ** ===================                                                                  CSE031
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes.                                               CSE031
     C                   PARM                    CSE031                                       CSE031
      *                                                                                       CSE071
      ** Multiple Holidays                                                                    CSE071
     C                   PARM                    CSE071                                       CSE071
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT                                                                                  CSE031
      *****************************************************************                       CSE031
      *                                                               *                       CSE031
      *  SRVLstCD - Validate Last Coupon Date.                        *                       CSE031
      *                                                               *                       CSE031
      *****************************************************************                       CSE031
                                                                                              CSE031
     C     SRVLstCD      BEGSR                                                                CSE031
      *                                                                                       CSE031
      ** Reset variables updated by each module                                               CSE031
      *                                                                                       CSE031
     C                   EXSR      SRResetErrs                                                CSE031
                                                                                              CSE031
     C                   CALLB     'SEVSLSTCD'                                                CSE031
      *                             =========                                                 CSE031
      ** INPUT                                                                                CSE031
      ** ======                                                                               CSE031
      *                                                                                       CSE031
      ** Return code                                                                          CSE031
     C                   PARM                    RetCodeOut                                   CSE031
      *                                                                                       CSE031
      ** Securities screen 2 details from incoming transaction                                CSE031
      ** - screen format                                                                      CSE031
     C                   PARM                    NwSE2ScnFmt                                  CSE031
      *                                                                                       CSE031
      ** STANDING DATA                                                                        CSE031
      ** =============                                                                        CSE031
      *                                                                                       CSE031
      ** SDBANK - Runday number                                                               CSE031
     C                   PARM                    BJRDNB                                       CSE031
      *                                                                                       CSE031
      ** SDBANK - Date format indicator                                                       CSE031
     C                   PARM                    BJDFIN                                       CSE031
      *                                                                                       CSE031
      ** OUTPUT                                                                               CSE031
      ** ======                                                                               CSE031
      *                                                                                       CSE031
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSE031
     C                   PARM                    FldNamXAr                                    CSE031
     C                   PARM                    MsgIDXAr                                     CSE031
     C                   PARM                    MsgDtaXAr                                    CSE031
      *                                                                                       CSE031
      ** Securities screen 2 error indicators                                                 CSE031
     C                   PARM                    SEESEC2                                      CSE031
      *                                                                                       CSE031
      ** Securities for file update - file format                                             CSE031
     C                   PARM                    NwSEFilFmt                                   CSE031
      *                                                                                       CSE031
      ** Update error info with that returned from the validation module                      CSE031
      *                                                                                       CSE031
     C                   IF        RetCodeOut <> *BLANKS                                      CSE031
     C                   EXSR      SRUpdatErrs                                                CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
     C                   ENDSR                                                                CSE031
      *                                                                                       CSE031
      *****************************************************************                       CSE031
      /EJECT                                                                                  CSE031
      *****************************************************************                       CSE031
      *                                                               *                       CSE031
      *  SRVNxtCD - Validate Next Coupon Date.                        *                       CSE031
      *                                                               *                       CSE031
      *****************************************************************                       CSE031
                                                                                              CSE031
     C     SRVNxtCD      BEGSR                                                                CSE031
      *                                                                                       CSE031
      ** Reset variables updated by each module                                               CSE031
      *                                                                                       CSE031
     C                   EXSR      SRResetErrs                                                CSE031
                                                                                              CSE031
     C                   CALLB     'SEVSNXTCD'                                                CSE031
      *                             =========                                                 CSE031
      ** INPUT                                                                                CSE031
      ** ======                                                                               CSE031
      *                                                                                       CSE031
      ** Return code                                                                          CSE031
     C                   PARM                    RetCodeOut                                   CSE031
      *                                                                                       CSE031
      ** Securities screen 2 details from incoming transaction                                CSE031
      ** - screen format                                                                      CSE031
     C                   PARM                    NwSE2ScnFmt                                  CSE031
      *                                                                                       CSE071
      ** Securities screen 6 details from incoming transaction                                CSE071
      ** - screen format                                                                      CSE071
     C                   PARM                    NwSE6ScnFmt                                  CSE071
      *                                                                                       CSE031
      ** Securities retrieved from file - file format                                         CSE031
     C                   PARM                    CrSEFilFmt                                   CSE031
      *                                                                                       CSE031
      *                                                                                       CSE031
      ** STANDING DATA                                                                        CSE031
      ** =============                                                                        CSE031
      *                                                                                       CSE031
      ** SDBANK - Runday number                                                               CSE031
     C                   PARM                    BJRDNB                                       CSE031
      *                                                                                       CSE031
      ** SDBANK - Date format indicator                                                       CSE031
     C                   PARM                    BJDFIN                                       CSE031
      *                                                                                       CSE031
      ** OUTPUT                                                                               CSE031
      ** ======                                                                               CSE031
      *                                                                                       CSE031
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSE031
     C                   PARM                    FldNamXAr                                    CSE031
     C                   PARM                    MsgIDXAr                                     CSE031
     C                   PARM                    MsgDtaXAr                                    CSE031
      *                                                                                       CSE031
      ** Securities screen 2 error indicators                                                 CSE031
     C                   PARM                    SEESEC2                                      CSE031
      *                                                                                       CSE031
      ** Securities for file update - file format                                             CSE031
     C                   PARM                    NwSEFilFmt                                   CSE031
      *                                                                                       CSE031
      ** Update error info with that returned from the validation module                      CSE031
      *                                                                                       CSE031
     C                   IF        RetCodeOut <> *BLANKS                                      CSE031
     C                   EXSR      SRUpdatErrs                                                CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
     C                   ENDSR                                                                CSE031
      *                                                                                       CSE031
      *****************************************************************                       CSE031
      /EJECT                                                                                  CSE031
      *****************************************************************                       CSE031
      *                                                               *                       CSE031
      *  SRVFixDy - Validate Fixing Days.                             *                       CSE031
      *                                                               *                       CSE031
      *****************************************************************                       CSE031
                                                                                              CSE031
     C     SRVFixDy      BEGSR                                                                CSE031
      *                                                                                       CSE031
      ** Reset variables updated by each module                                               CSE031
      *                                                                                       CSE031
     C                   EXSR      SRResetErrs                                                CSE031
                                                                                              CSE031
     C                   CALLB     'SEVSFIXDY'                                                CSE031
      *                             =========                                                 CSE031
      ** INPUT                                                                                CSE031
      ** ======                                                                               CSE031
      *                                                                                       CSE031
      ** Return code                                                                          CSE031
     C                   PARM                    RetCodeOut                                   CSE031
      *                                                                                       CSE031
      ** Securities screen 2 details from incoming transaction                                CSE031
      ** - screen format                                                                      CSE031
     C                   PARM                    NwSE2ScnFmt                                  CSE031
      *                                                                                       CSE031
      ** OUTPUT                                                                               CSE031
      ** ======                                                                               CSE031
      *                                                                                       CSE031
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSE031
     C                   PARM                    FldNamXAr                                    CSE031
     C                   PARM                    MsgIDXAr                                     CSE031
     C                   PARM                    MsgDtaXAr                                    CSE031
      *                                                                                       CSE031
      ** Securities screen 2 error indicators                                                 CSE031
     C                   PARM                    SEESEC2                                      CSE031
      *                                                                                       CSE031
      ** Securities for file update - file format                                             CSE031
     C                   PARM                    NwSEFilFmt                                   CSE031
      *                                                                                       CSE031
      ** Update error info with that returned from the validation module                      CSE031
      *                                                                                       CSE031
     C                   IF        RetCodeOut <> *BLANKS                                      CSE031
     C                   EXSR      SRUpdatErrs                                                CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
     C                   ENDSR                                                                CSE031
      *                                                                                       CSE031
      *****************************************************************                       CSE031
      /EJECT                                                                                  CSE031
      *****************************************************************                       CSE031
      *                                                               *                       CSE031
      *  SRVAuFx - Validate Auto Fix.                                 *                       CSE031
      *                                                               *                       CSE031
      *****************************************************************                       CSE031
                                                                                              CSE031
     C     SRVAuFx       BEGSR                                                                CSE031
      *                                                                                       CSE031
      ** Reset variables updated by each module                                               CSE031
      *                                                                                       CSE031
     C                   EXSR      SRResetErrs                                                CSE031
                                                                                              CSE031
     C                   CALLB     'SEVSAUFX'                                                 CSE031
      *                             =========                                                 CSE031
      ** INPUT                                                                                CSE031
      ** ======                                                                               CSE031
      *                                                                                       CSE031
      ** Return code                                                                          CSE031
     C                   PARM                    RetCodeOut                                   CSE031
      *                                                                                       CSE031
      ** Securities screen 2 details from incoming transaction                                CSE031
      ** - screen format                                                                      CSE031
     C                   PARM                    NwSE2ScnFmt                                  CSE031
      *                                                                                       CSE031
      ** OUTPUT                                                                               CSE031
      ** ======                                                                               CSE031
      *                                                                                       CSE031
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSE031
     C                   PARM                    FldNamXAr                                    CSE031
     C                   PARM                    MsgIDXAr                                     CSE031
     C                   PARM                    MsgDtaXAr                                    CSE031
      *                                                                                       CSE031
      ** Securities screen 2 error indicators                                                 CSE031
     C                   PARM                    SEESEC2                                      CSE031
      *                                                                                       CSE031
      ** Securities for file update - file format                                             CSE031
     C                   PARM                    NwSEFilFmt                                   CSE031
      *                                                                                       CSE031
      ** Update error info with that returned from the validation module                      CSE031
      *                                                                                       CSE031
     C                   IF        RetCodeOut <> *BLANKS                                      CSE031
     C                   EXSR      SRUpdatErrs                                                CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
     C                   ENDSR                                                                CSE031
      *                                                                                       CSE031
      *****************************************************************                       CSE031
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVDptSRef - Validate Depot Security References              *
      *                                                               *
      *****************************************************************
 
     C     SRVDptSRef    BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSSECRF'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Settlement depot customer 1, from PF/INVTPD
     C                   PARM                    PSDC1
      *
      ** Settlement depot customer 2, from PF/INVTPD
     C                   PARM                    PSDC2
      *
      ** Settlement depot customer 3, from PF/INVTPD
     C                   PARM                    PSDC3
      *
      ** SWITCHABLE FEATURE
      ** ==================
      *
      ** Duplicate security code check
     C                   PARM                    CSE011
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *                                                                                   210378
      ** Warning fields/message IDs/message data (arrays) from/to caller                  210378
     C                   PARM                    WFldNmXAr                                210378
     C                   PARM                    WMsgIDxAr                                210378
     C                   PARM                    WMsgDtXAr                                210378
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVMktCtr - Validate Market Center                           *
      *                                                               *
      *****************************************************************
 
     C     SRVMktCtr     BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSMKTCT'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Market Name
     C                   PARM                    PMKTN
      *                                                                        183604
      ** SDMMOD - Private banking                                              183604
     C                   PARM                    BGN4ST                        183604
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCnvInd - Validate Convertible Indicator                   *
      *                                                               *
      *****************************************************************
 
     C     SRVCnvInd     BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSCNVIN'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Processing type, from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** SWTICHABLE FEATURE
      ** ==================
      *
      ** Corporate action
     C                   PARM                    CSE007
      *
      ** Security redenomination
     C                   PARM                    CEU017
      *
      ** STANDING DATA
      ** =============
      *
      ** SDSTRD - Convertible indicator
     C                   PARM                    BVCIAK
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDxAr
     C                   PARM                    WMsgDtXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVPrcBs - Validate Price Basis                              *
      *                                                               *
      *****************************************************************
 
     C     SRVPrcBs      BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSPRCBS'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVYldBs - Validate Yield Basis                              *
      *                                                               *
      *****************************************************************
 
     C     SRVYldBs      BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSYLDBS'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCpdFrq - Validate Compounding Frequency                   *
      *                                                               *
      *****************************************************************
 
     C     SRVCpdFrq     BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSCMFRQ'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVDscBs - Validate Discount Basis                           *
      *                                                               *
      *****************************************************************
 
     C     SRVDscBs      BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSDSCBS'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVDscLCpn - Validate Discount Last Coupon                   *
      *                                                               *
      *****************************************************************
 
     C     SRVDscLCpn    BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSDSCLC'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVIntlPrc - Validate Initial Price                          *
      *                                                               *
      *****************************************************************
 
     C     SRVIntlPrc    BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSIPYMT'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities screen 1 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE1ScnFmt
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Processing type, from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Nominal ccy no. of decimal places
     C                   PARM                    PNmDp
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVFulPrc - Validate Full Price                              *
      *                                                               *
      *****************************************************************
 
     C     SRVFulPrc     BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSFPDPR'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Processing type, from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Nominal decimal places.
     C                   PARM                    PNmDp
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVIssAmt - Validate Issue Amount                            *
      *                                                               *
      *****************************************************************
 
     C     SRVIssAmt     BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSISAM1'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************                       CSE037
      *                                                               *                       CSE037
      *  SRVndec - Countervalue rounding validation                   *                       CSE037
      *                                                               *                       CSE037
      *****************************************************************                       CSE037
                                                                                              CSE037
     C     SRVndec       BEGSR                                                                CSE037
      *                                                                                       CSE037
      ** Reset variables updated by each module                                               CSE037
      *                                                                                       CSE037
     C                   EXSR      SRResetErrs                                                CSE037
      *                                                                                       CSE037
      ** Call validation module                                                               CSE037
      *                                                                                       CSE037
     C                   CALLB     'SEVSNDEC'                                                 CSE037
      *                             ========                                                  CSE037
      ** INPUTS                                                                               CSE037
      ** ======                                                                               CSE037
      *                                                                                       CSE037
      ** Return code                                                                          CSE037
     C                   PARM                    RetCodeOut                                   CSE037
      *                                                                                       CSE037
      ** Securities screen 1 details from incoming transaction                                CSE037
      ** - screen format                                                                      CSE037
     C                   PARM                    NwSE2ScnFmt                                  CSE037
      *                                                                                       CSE037
      ** SWITCHABLE FEATURE                                                                   CSE037
      ** ==================                                                                   CSE037
      *                                                                                       CSE037
      ** Decimals on nominals                                                                 CSE037
     C                   PARM                    CSE037                                       CSE037
      *                                                                                       CSE037
      ** OUTPUT                                                                               CSE037
      ** ======                                                                               CSE037
      *                                                                                       CSE037
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSE037
     C                   PARM                    FldNamXAr                                    CSE037
     C                   PARM                    MsgIDXAr                                     CSE037
     C                   PARM                    MsgDtaXAr                                    CSE037
      *                                                                                       CSE037
      ** Securities screen 1 error indicators                                                 CSE037
     C                   PARM                    SEESEC2                                      CSE037
      *                                                                                       CSE037
      ** Securities for file update - file format                                             CSE037
     C                   PARM                    NwSEFilFmt                                   CSE037
      *                                                                                       CSE037
      ** Update error info with that returned from the validation module                      CSE037
      *                                                                                       CSE037
     C                   IF        RetCodeOut <> *BLANKS                                      CSE037
     C                   EXSR      SRUpdatErrs                                                CSE037
     C                   ENDIF                                                                CSE037
                                                                                              CSE037
     C                   ENDSR                                                                CSE037
                                                                                              CSE037
      *****************************************************************                       CSE037
      /EJECT                                                                                  CSE037
      *****************************************************************
      *                                                               *
      *  SRResetErrs - Routine to reset Error Information that is     *
      *                received from each validation module           *
      *                                                               *
      *****************************************************************
 
     C     SRResetErrs   BEGSR
 
     C                   EVAL      RetCodeOut = *BLANKS
      *
      ** Reset error and warning fields/message IDs/message
      ** data (arrays).
      *
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr  = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
 
     C                   EVAL      WFldNmXAr = *BLANKS
     C                   EVAL      WMsgIDXAr = *BLANKS
     C                   EVAL      WMsgDtXAr = *BLANKS
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdatErrs - Routine to update Error Information with that  *
      *                received back from each validation module      *
      *                                                               *
      *****************************************************************
 
     C     SRUpdatErrs   BEGSR
      *
      ** Update error fields/message IDs/message data (arrays).
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    FldNameArr(Ix)                         99
     C                   IF        *IN99 = *On
     C                   MOVEA     FldNamXar     FldNameArr(Ix)
     C                   MOVEA     MsgIDXAr      MsgIdArr(Ix)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(Ix)
     C                   ENDIF
      *
      ** Set Error Index.
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    FLDNAMEARR(Ix)                         99
     C     *IN99         IFEQ      '1'
     C     Ix            SUB       1             Idx
     C                   ELSE
     C                   EVAL      Ix = ArrayMax
     C                   MOVE      *BLANKS       FLDNAMEARR(Ix)
     C                   MOVE      *BLANKS       MSGIDARR(Ix)
     C                   MOVE      *BLANKS       MSGDTAARR(Ix)
     C                   Eval      Idx = ArrayMax - 1
     C                   ENDIF
      *
      ** Update warning fields/message IDs/message data (arrays).
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    WFldNamArr(Ix)                         99
     C                   IF        *IN99 = *On
     C                   MOVEA     WFldNmXAr     WFldNamArr(Ix)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(Ix)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(Ix)
     C                   ENDIF
      *
      ** Set Warning Index.
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    WFLDNAMARR(Ix)                         99
     C     *IN99         IFEQ      '1'
     C     Ix            SUB       1             WIdx
     C                   ELSE
     C                   EVAL      Ix = ArrayMax
     C                   MOVE      *BLANKS       WFLDNAMARR(Ix)
     C                   MOVE      *BLANKS       WMSGIDARR(Ix)
     C                   MOVE      *BLANKS       WMSGDTAARR(Ix)
     C                   EVAL      WIdx = ArrayMax - 1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************                     BUG10847
      *                                                               *                     BUG10847
      *  SRGetLCD - Routine to get default value of Last Coupon Date  *                     BUG10847
      *                                                               *                     BUG10847
      *****************************************************************                     BUG10847
     C     SRGetLCD      BEGSR                                                              BUG10847
                                                                                            BUG10847
     C                   EXSR      SRGetArr                                                BUG10847R
                                                                                           BUG10847R
     C                   EXSR      SRGetFCPN                                               BUG10847R
                                                                                           BUG10847R
     C                   EXSR      SRValITLD                                               BUG10847R
                                                                                           BUG10847R
     C                   EXSR      SRValCPDRT                                              BUG10847R
                                                                                           BUG10847R
     C                   IF        WITLDFlag <> 'Y'   AND  WCPDRTFlag <> 'Y'               BUG10847R
     C                   Z-ADD     *ZEROS        PLCD                                       BUG10847
                                                                                            BUG10847
     C                   CALLB     'ZLCD'                                                   BUG10847
     C                   PARM                    S1ISSD                                     BUG10847
     C                   PARM                    S1ITLD                                     BUG10847
     C**********         PARM                    S1FCPN                           BUG10847 BUG10847R
     C                   PARM                    WFCPN                                     BUG10847R
     C                   PARM                    S1MATY                                     BUG10847
     C**********         PARM                    CDArr                            BUG10847 BUG10847R
     C**********         PARM                    CRArr                            BUG10847 BUG10847R
     C                   PARM                    WWSCD                                     BUG10847R
     C                   PARM                    WWSCR                                     BUG10847R
     C                   PARM                    LCPN                                      BUG10847R
     C                   PARM                    BJRDNB                                     BUG10847
     C                   PARM                    BJDFIN                                     BUG10847
     C                   PARM                    S1NMCY                                     BUG10847
     C                   PARM                    S1SITP                                     BUG10847
     C                   PARM                    S1BCNV                                     BUG10847
     C                   PARM                    S1HCY1                                     BUG10847
     C                   PARM                    S1HCY2                                     BUG10847
     C                   PARM                    S1HCY3                                     BUG10847
     C                   PARM                    S1HCY4                                     BUG10847
     C                   PARM                    S1HCY5                                     BUG10847
     C                   PARM                    S1HCY6                                     BUG10847
     C                   PARM                    S1HCY7                                     BUG10847
     C                   PARM                    S1HCY8                                     BUG10847
     C                   PARM                    S1HCY9                                     BUG10847
     C                   PARM                    PLCD                                       BUG10847
                                                                                            BUG10847
     C                   Z-ADD     PLCD          ZDAYNO                                     BUG10847
     C                   CALLB     'ZDATE2'                                                 BUG10847
     C                   PARM                    ZDAYNO                                     BUG10847
     C                   PARM                    BJDFIN                                     BUG10847
     C                   PARM      *ZEROS        ZDATE                                      BUG10847
     C                   PARM      *BLANKS       ZADATE                                     BUG10847
                                                                                            BUG10847
     C                   MOVEL     ZDATE         DDLCPN                                     BUG10847
     C                   ENDIF                                                             BUG10847R
                                                                                            BUG10847
     C                   ENDSR                                                              BUG10847
      *****************************************************************                     BUG10847
      *                                                               *                     BUG10847
      *  SRGetNCD - Routine to get default value of Next Coupon Date  *                     BUG10847
      *                                                               *                     BUG10847
      *****************************************************************                     BUG10847
     C     SRGetNCD      BEGSR                                                              BUG10847
                                                                                            BUG10847
     C                   EXSR      SRGetArr                                                BUG10847R
                                                                                           BUG10847R
     C                   EXSR      SRGetFCPN                                               BUG10847R
     C                   EXSR      SRValITLD                                               BUG10847R
     C                   EXSR      SRValCPDRT                                              BUG10847R
                                                                                           BUG10847R
     C                   IF        WITLDFlag <> 'Y'   AND  WCPDRTFlag <> 'Y'               BUG10847R
                                                                                           BUG10847R
     C                   Z-ADD     *ZEROS        PNCD                                       BUG10847
                                                                                            BUG10847
     C                   CALLB     'ZNCD'                                                   BUG10847
     C                   PARM                    S1ITLD                                     BUG10847
     C**********         PARM                    S1FCPN                           BUG10847 BUG10847R
     C                   PARM                    WFCPN                                     BUG10847R
     C                   PARM                    S1MATY                                     BUG10847
     C**********         PARM                    CDArr                            BUG10847 BUG10847R
     C**********         PARM                    CRArr                            BUG10847 BUG10847R
     C                   PARM                    WWSCD                                     BUG10847R
     C                   PARM                    WWSCR                                     BUG10847R
     C                   PARM                    BJRDNB                                     BUG10847
     C                   PARM                    BJDFIN                                     BUG10847
     C                   PARM                    S1NMCY                                     BUG10847
     C                   PARM                    S1SITP                                     BUG10847
     C                   PARM                    S1BCNV                                     BUG10847
     C                   PARM                    S1LCPN                                     BUG10847
     C                   PARM                    S1HCY1                                     BUG10847
     C                   PARM                    S1HCY2                                     BUG10847
     C                   PARM                    S1HCY3                                     BUG10847
     C                   PARM                    S1HCY4                                     BUG10847
     C                   PARM                    S1HCY5                                     BUG10847
     C                   PARM                    S1HCY6                                     BUG10847
     C                   PARM                    S1HCY7                                     BUG10847
     C                   PARM                    S1HCY8                                     BUG10847
     C                   PARM                    S1HCY9                                     BUG10847
     C                   PARM                    PNCD                                       BUG10847
                                                                                            BUG10847
     C                   Z-ADD     PNCD          ZDAYNO                                     BUG10847
                                                                                            BUG10847
     C                   CALLB     'ZDATE2'                                                 BUG10847
     C                   PARM                    ZDAYNO                                     BUG10847
     C                   PARM                    BJDFIN                                     BUG10847
     C                   PARM      *ZERO         ZDATE                                      BUG10847
     C                   PARM      *BLANKS       ZADATE                                     BUG10847
                                                                                            BUG10847
     C                   MOVEL     ZDATE         DDNCD                                      BUG10847
     C                   ENDIF                                                             BUG10847R
                                                                                            BUG10847
     C                   ENDSR                                                              BUG10847
      *
      *****************************************************************                    BUG10847R
      *                                                               *                    BUG10847R
      *  SRGetArr - Get coupon rate/day indicators                    *                    BUG10847R
      *                                                               *                    BUG10847R
      *****************************************************************                    BUG10847R
                                                                                           BUG10847R
     C     SRGetArr      BEGSR                                                             BUG10847R
      *                                                                                    BUG10847R
     C                   MOVE      DDCD01        WSCD(1)                                   BUG10847R
     C                   MOVE      DDCD02        WSCD(2)                                   BUG10847R
     C                   MOVE      DDCD03        WSCD(3)                                   BUG10847R
     C                   MOVE      DDCD04        WSCD(4)                                   BUG10847R
     C                   MOVE      DDCD05        WSCD(5)                                   BUG10847R
     C                   MOVE      DDCD06        WSCD(6)                                   BUG10847R
     C                   MOVE      DDCD07        WSCD(7)                                   BUG10847R
     C                   MOVE      DDCD08        WSCD(8)                                   BUG10847R
     C                   MOVE      DDCD09        WSCD(9)                                   BUG10847R
     C                   MOVE      DDCD10        WSCD(10)                                  BUG10847R
     C                   MOVE      DDCD11        WSCD(11)                                  BUG10847R
     C                   MOVE      DDCD12        WSCD(12)                                  BUG10847R
                                                                                           BUG10847R
     C                   MOVE      DDCR01        WSCR(1)                                   BUG10847R
     C                   MOVE      DDCR02        WSCR(2)                                   BUG10847R
     C                   MOVE      DDCR03        WSCR(3)                                   BUG10847R
     C                   MOVE      DDCR04        WSCR(4)                                   BUG10847R
     C                   MOVE      DDCR05        WSCR(5)                                   BUG10847R
     C                   MOVE      DDCR06        WSCR(6)                                   BUG10847R
     C                   MOVE      DDCR07        WSCR(7)                                   BUG10847R
     C                   MOVE      DDCR08        WSCR(8)                                   BUG10847R
     C                   MOVE      DDCR09        WSCR(9)                                   BUG10847R
     C                   MOVE      DDCR10        WSCR(10)                                  BUG10847R
     C                   MOVE      DDCR11        WSCR(11)                                  BUG10847R
     C                   MOVE      DDCR12        WSCR(12)                                  BUG10847R
      *                                                                                    BUG10847R
                                                                                           BUG10847R
     C                   MOVEA     WSCD          WWSCD                                     BUG10847R
     C                   MOVEA     WSCR          WWSCR                                     BUG10847R
                                                                                           BUG10847R
     C                   ENDSR                                                             BUG10847R
                                                                                           BUG10847R
      *****************************************************************                    BUG10847R
      *                                                               *                    BUG10847R
      *  SRGetFCPN - Get First Coupon Date                            *                    BUG10847R
      *                                                               *                    BUG10847R
      *****************************************************************                    BUG10847R
                                                                                           BUG10847R
     C     SRGetFCPN     BEGSR                                                             BUG10847R
                                                                                           BUG10847R
     C                   Z-ADD     0             WFCPN                                     BUG10847R
                                                                                           BUG10847R
     C                   IF        DDFCPN <> *BLANKS                                       BUG10847R
                                                                                           BUG10847R
     C                   MOVE      DDFCPN        ZADATE2                                   BUG10847R
     C                   CALLB     'ZDATE1'                                                BUG10847R
                                                                                           BUG10847R
     C                   PARM                    ZADATE2                                   BUG10847R
     C                   PARM      *ZEROS        ZDAYNO                                    BUG10847R
     C                   PARM                    BJDFIN                                    BUG10847R
     C                   PARM                    ErrorFlag                                 BUG10847R
                                                                                           BUG10847R
     C                   If        ErrorFlag  <>  'Y'                                      BUG10847R
     C                   Z-ADD     ZDAYNO        WFCPN                                     BUG10847R
     C                   Endif                                                             BUG10847R
                                                                                           BUG10847R
     C                   Endif                                                             BUG10847R
                                                                                           BUG10847R
     C                   ENDSR                                                             BUG10847R
                                                                                           BUG10847R
      *****************************************************************                    BUG10847R
      *                                                               *                    BUG10847R
      *  SRValITLD - Validate Initial Date for Last Coupon and        *                    BUG10847R
      *                Next Coupon Dates Defaulting                   *                    BUG10847R
      *                                                               *                    BUG10847R
      *****************************************************************                    BUG10847R
                                                                                           BUG10847R
     C     SRValITLD     BEGSR                                                             BUG10847R
                                                                                           BUG10847R
     C                   EVAL      WITLDFlag = *BLANK                                      BUG10847R
                                                                                           BUG10847R
     C                   EXSR      SRResetErrs                                             BUG10847R
     C                   CALLB     'SEVSINDAT'                                             BUG10847R
     C                   PARM                    RetCodeOut                                BUG10847R
     C                   PARM                    NwSE1ScnFmt                               BUG10847R
     C                   PARM                    NwSE2ScnFmt                               BUG10847R
     C                   PARM                    CrSEFilFmt                                BUG10847R
     C                   PARM                    PCpnRt                                    BUG10847R
     C                   PARM                    BJDFIN                                    BUG10847R
     C                   PARM                    FldNamXAr                                 BUG10847R
     C                   PARM                    MsgIDXAr                                  BUG10847R
     C                   PARM                    MsgDtaXAr                                 BUG10847R
     C                   PARM                    SEESEC2                                   BUG10847R
     C                   PARM                    NwSEFilFmt                                BUG10847R
                                                                                           BUG10847R
     C                   IF        RetCodeOut <> *BLANKS                                   BUG10847R
     C                   EVAL      WITLDFlag = 'Y'                                         BUG10847R
     C                   ENDIF                                                             BUG10847R
                                                                                           BUG10847R
     C                   ENDSR                                                             BUG10847R
      *                                                                                    BUG10847R
      *****************************************************************                    BUG10847R
      *                                                               *                    BUG10847R
      *  SRValCPDRT - Validate Dividend Payment Dates & Coupon Rates  *                    BUG10847R
      *                for Last Coupon & Next Coupon Dates            *                    BUG10847R
      *                Defaulting                                     *                    BUG10847R
      *                                                               *                    BUG10847R
      *****************************************************************                    BUG10847R
                                                                                           BUG10847R
     C     SRValCPDRT    BEGSR                                                             BUG10847R
                                                                                           BUG10847R
     C                   EVAL      WCPDRTFlag = *BLANK                                     BUG10847R
                                                                                           BUG10847R
     C                   EXSR      SRResetErrs                                             BUG10847R
                                                                                           BUG10847R
     C                   CALLB     'SEVSCPDRT'                                             BUG10847R
                                                                                           BUG10847R
     C                   PARM                    RetCodeOut                                BUG10847R
     C                   PARM                    NwSE2ScnFmt                               BUG10847R
     C                   PARM                    CrSEFilFmt                                AR1077984
     C                   PARM                    PPROT                                     BUG10847R
     C                   PARM                    PCpnRt                                    BUG10847R
     C                   PARM                    PPrCpn                                    BUG10847R
     C                   PARM                    BJRDNB                                    AR1077984
     C                   PARM                    BJDFIN                                    BUG10847R
     C                   PARM                    CSE005                                    BUG10847R
     C                   PARM                    CSE031                                    BUG10847R
     C                   PARM                    CSE071                                    BUG10847R
     C                   PARM                    FldNamXAr                                 BUG10847R
     C                   PARM                    MsgIDXAr                                  BUG10847R
     C                   PARM                    MsgDtaXAr                                 BUG10847R
     C                   PARM                    WFldNmXAr                                 BUG10847R
     C                   PARM                    WMsgIDxAr                                 BUG10847R
     C                   PARM                    WMsgDtXAr                                 BUG10847R
     C                   PARM                    SEESEC2                                   BUG10847R
     C                   PARM                    NwSEFilFmt                                BUG10847R
                                                                                           BUG10847R
     C                   IF        RetCodeOut <> *BLANKS                                   BUG10847R
     C                   EVAL      WCPDRTFlag = 'Y'                                        BUG10847R
     C                   ENDIF                                                             BUG10847R
                                                                                           BUG10847R
     C                   ENDSR                                                             BUG10847R
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
     C                   PARM                    PMode
      *
      ** Response mode
     C                   PARM                    PRespMode
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities screen 1 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE1ScnFmt
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Security screen 2 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE2ScnFmt
      *                                                                                       CSE071
      ** Securities screen 6 details from incoming transaction                                CSE071
      ** - screen format                                                                      CSE071
     C                   PARM                    NwSE6ScnFmt                                  CSE071
      *                                                                                       CSE071
      ** Securities screen 6 details retrieved from file                                      CSE071
      ** - screen format                                                                      CSE071
     C                   PARM                    CrSE6ScnFmt                                  CSE071
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Processing type, from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Settlement depot customer 1
     C                   PARM                    PSDC1
      *
      ** Settlement depot customer 2
     C                   PARM                    PSDC2
      *
      ** Settlement depot customer 3
     C                   PARM                    PSDC3
      *
      ** Protect Coupon Rate/Inds Indicator
     C                   PARM                    PPrCpn
      *
      ** Nominal currency's decimal places
     C                   PARM                    PNmDp
      *
      ** Value currency's decimal places
     C                   PARM                    PVlDp
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** SDBANK - Midas run date number
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Date of next working day
     C                   PARM                    BJDNWD
      *
      ** SDMMOD - Interest risk management
     C                   PARM                    BGRKMG
      *
      ** SDSTRD - Convertible indicator A/K
     C                   PARM                    BVCIAK
      *                                                                        183604
      ** SDMMOD - Private banking                                              183604
     C                   PARM                    BGN4ST                        183604
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Effect of holidays on FRN coupon dates
     C                   PARM                    CSE005
      *
      ** Corporate action
     C                   PARM                    CSE007
      *
      ** EMU securities redenomination
     C                   PARM                    CEU017
      *
      ** Duplicate security code check
     C                   PARM                    CSE011
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes.                                               CSE031
     C                   PARM                    CSE031                                       CSE031
      *                                                                                       CSE037
      ** Coupon Fixing for Floating Rate Notes.                                               CSE037
     C                   PARM                    CSE037                                       CSE037
      *                                                                                       CSE071
      ** Multiple Holidays                                                                    CSE071
     C                   PARM                    CSE071                                       CSE071
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Redisplay screen
     C                   PARM                    PReDsp
      *
      ** Market Name
     C                   PARM                    PMKTN
      *
      ** Check if CRE073 is installed                                                         CRE073
      *                                                                                       CRE073
     C                   EVAL      CRE073 = 'N'                                               CRE073
     C                   CALLB     'AOSARDR0'                                                 CRE073
     C                   PARM      *BLANKS       PRtCd                                        CRE073
     C                   PARM      '*VERIFY'     POptn                                        CRE073
     C                   PARM      'CRE073'      PSard                                        CRE073
     C     SCSARD        PARM      SCSARD        DSSDY                                        CRE073
      *                                                                                       CRE073
     C                   IF        PRtCd = *BLANKS                                            CRE073
     C                   EVAL      CRE073 = 'Y'                                               CRE073
     C                   ELSE                                                                 CRE073
     C                   IF        PRtCd <> '*NRF   '                                         CRE073
     C                   EVAL      DBKey  = 'CRE073'                                          CRE073
     C                   EVAL      DBFile = 'SCSARDPD'                                        CRE073
     C                   EVAL      DBase  = 1                                                 CRE073
     C                   EXSR      *PSSR                                                      CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      /COPY WNCPYSRC,SESEC2V089
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
