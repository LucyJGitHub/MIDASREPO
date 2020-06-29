     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities convert file to screen format')    *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECSCVT - Security details conversion from file to         *
      *              screen format                                    *
      *                                                               *
      *  Function: This module converts the fields of a Security      *
      *            from their format as on file to screen format.     *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                SESECSCTL                                      *
      *                SESECSRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. DUG502             Date 23Aug17               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG11566           Date 23Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 06Mar06               *
      *                 BUG9839            Date 16Jan06               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL032             Date 05Jul04               *
      *                 CSE065             Date 08Nov04               *
      *                 CSE071             Date 26May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 BUG5564            Date 27Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CGL014             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 CAP084             Date 07Aug03               *
      *                 CAS006             Date 21Jan03               *
      *                 CSE037             Date 29Apr02               *
      *                 216368             Date 12Jun03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      *                 CSE031             Date 27Nov01               *
      *                 CSE032             Date 03Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP060             Date 22May01               *
      *                 CSD006             Date 12Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DUG502 - Security Diary Enhancements.                        *
      *         - Add Hooks DUG502_002, DUG502_003, DUG502_004        *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding                              *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus                                          *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG11566 - Serious Midas Error whenever Lead Manager,        *
      *             LGMR = '000000'. Also include ISSR.               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - CSE075 Change Control. Display Coupon Delay period  *
      *           for all interest-bearing securities.                *
      *  BUG9839 - (SECS Enquiry) Trade Basis Override is blank.      *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus.          *
      *  CGL032 - Automatic Exchange of Information                   *
      *  CSE065 - Const. Yield Amort. on Mortgage backed assets       *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  BUG5564- Caused validation error and lost of data when fields*
      *           are not passed to display fields.                   *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CGL014 - Collaterals Processing                              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP084 - Change to allow the conversion of all fields.       *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CSE037 - Countervalue rounding                               *
      *  216368 - DBErr occurs when enquiring a matured security with *
      *           already deleted issuer.  Fix is to bypass dberr when*
      *           enquiring a matured security and issuer details in  *
      *           SDCUSTPD is already deleted.  Issuer field would    *
      *           then, contain only the customer number.             *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *  CSE032 - Retrieve Yield from file unconditionally.           *
      *  CAP060 - Midas APIs Sec Prices                               *
      *  CSD006 - Market Data Feed                                    *
      *  CSE023 - Treaty Withholding Tax                              *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs.                           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
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
      *
      ** Securities retrieved from file - file format
     D CrSEFilFmt    E DS                  EXTNAME(SECTYD)
      ** Coupon/Rate days
     D  CDArr                183    230
      ** Coupon/Rate inds
     D  CRArr                231    242
      *
      ** Securities Screen 1 details retrieved from file
      ** - screen format
     D CrSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
      *
      ** Securities Screen 2 details retrieved from file
      ** - screen format
     D CrSE2ScnFmt   E DS                  EXTNAME(SESEC2PD)
      *
      ** Securities Screen 3 details retrieved from file
      ** - screen format
     D CrSE3ScnFmt   E DS                  EXTNAME(SESEC3PD)
      *                                                                                       CSE031
      ** Securities Screen 4 details retrieved from file                                      CSE031
      ** - screen format                                                                      CSE031
     D CrSE4ScnFmt   E DS                  EXTNAME(SESEC4PD)                                  CSE031
                                                                                              CAS006
      ** Securities Screen 5 Details Retrieved From File                                      CAS006
      ** - Screen Format                                                                      CAS006
     D CrSE5ScnFmt   E DS                  EXTNAME(SESEC5PD)                                  CAS006
                                                                                              CSE071
      ** Securities Screen 6 Details Retrieved From File                                      CSE071
      ** - Screen Format                                                                      CSE071
     D CrSE6ScnFmt   E DS                  EXTNAME(SESEC6PD)                                  CSE071
      *
      ** Externally described DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Externally described DS for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** DS for Access Objects - second data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for Access Objects - Very long data structure
     D DSLDY         E DS                  EXTNAME(DSLDY)
                                                                                              CSC011
      ** Externally described DS for SAR details                                              CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
     D  SLCD         E                     EXTFLD(LCD)                                        CSC011
      *
      ** Passed other information
     D POthInf         DS
     D  WSRPN                        20A
     D  WSFN1                        30A
     D  WSFN2                        30A
     D  WT2RF                        12A
     D  WISNO                        12A
     D  WCSPN                         9A
     D  WSREF                         7A
     D  WSRE1                        12A
     D  WSRE2                        12A
     D  WSRE3                        12A
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Parameter list for ZA0921
     D PAmountIn       S             15P 0
     D PNDCP           S              1P 0
     D PDCSP           S              1A
     D PAmountOutP     S             16A
     D PAmountOutD     S             17A
      *
      ** Parameter list for AOCURRR0
     D PRtCd           S              7A
     D POptn           S              7A
     D PCurr           S              3A
      *
      ** Parameter list for AOCUSTR1
     D PKeyC           S             10A
     D PKySt           S              7A
      *
      ** Parameter list for ZSEDITF
     D ZFld15          S             15P 0
     D ZDecs           S              1P 0
     D ZECode          S              1A
     D ZEChar          S              1A
     D ZOut21          S             21A
      *
      ** Parameter list for ZDATE2
     D PDateIn         S              5P 0
     D PDateOut        S              6P 0
     D PADateOut       S              7A
      *                                                                                       CSE065
      ** Parameter list for ZA0140M                                                           CSE065
     D PRtn            S              1A                                                      CSE065
     D PDayN           S              5  0                                                    CSE065
     D PDFmt           S              1A                                                      CSE065
     D PDate           S              6  0                                                    CSE065
     D PDatA           S              7A                                                      CSE065
     D PDat8           S              8  0                                                    CSE065
     D PDat8F          S              8  0                                                    CSE065
      *
      ** Standing Data
     D BJDFIN          S              1A
     D BGRKMG          S              1A
     D BGN2ST          S              1A
     D BGN4ST          S              1A
     D BJRDNB          S              5P 0
      *
      ** Switchable features
     D CEU018          S              1A
     D CSE005          S              1A
     D S01401          S              1A
     D CSE023          S              1A                                        CSE023
     D CSD006          S              1A                                        CSD006
     D CAP060          S              1A                                        CAP060
     D CSE031          S              1A                                                      CSE031
     D CSC011          S              1A                                                      CSC011
     D CAS006          S              1A                                                      CAS006
     D CSE037          S              1A                                                      CSE037
     D CSE071          S              1A                                                      CSE071
     D CSE065          S              1A                                                      CSE065
     D CGL032          S              1A                                                      CGL032
     D CSE075          S              1A                                                      CSE075
     D CRE073          S              1A                                                      CRE073
      *
      ** Entry parameter fields
     D PDDACTN         S              1A
     D PPOldSecDtl     S              1A
     D PPROT           S              1A
     D PLCPN           S              6A
     D PNCD            S              6A
     D*NCD******       S              5P 0                                                    CSE031
     D PParmLink       S              1A                                                      CSC011
     D PSard           S              6A                                                      CSC011
                                                                                              CGL014
     D CGL014          S              1                                                       CGL014
     D WRKFLD4         S              4A                                                      CSE075
     D WRKFLD9         S              9A                                                      CSE075
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
      ** +--------------------------------------+
      ** ¦ I-specs                              ¦
      ** ¦ =======                              ¦
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
      ** Initialisation.
      *
     C                   EXSR      SRInit
      *
      ** If process old security details indicator is set to 'Y' then
      ** get other info from link program.
      *
     C                   IF        PPOldSecDtl = 'Y' AND
     C                             PDDACTN = 'I'
     C                   EXSR      SRPlink
     C                   ENDIF
      *
      ** Convert fields from file to screen format.
      *
     C                   EXSR      SRConvFlds
      *
      ** If process old security details indicator is set to 'Y' then
      ** clear out old security details.
      *
     C                   IF        PPOldSecDtl = 'Y' AND
     C                             PDDACTN = 'I'
     C                   EXSR      SRClrSec
     C                   ENDIF
      *
      ** Return.
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Routine to initialise fields                        *
      *                                                               *
      *****************************************************************
 
     C     SRInit        BEGSR
      *
      ** Initialise output parameters.
      *
     C                   CLEAR                   CrSE1ScnFmt
     C                   CLEAR                   CrSE2SCnFmt
     C                   CLEAR                   CrSE3SCnFmt
     C                   CLEAR                   CrSE4SCnFmt                                  CSE031
     C                   CLEAR                   CrSE5ScnFmt                                  CAS006
     C                   CLEAR                   CrSE6ScnFmt                                  CSE071
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPLink - Routine to process other info from link pgm        *
      *                                                               *
      *****************************************************************
 
     C     SRPLink       BEGSR
 
     C                   IF        POthInf <> *BLANKS
 
     C                   IF        WSRPN <> *BLANKS
     C                   EVAL      SRPN = WSRPN
     C                   ENDIF
 
     C                   IF        WSFN1 <> *BLANKS
     C                   EVAL      SFN1 = WSFN1
     C                   ENDIF
 
     C                   IF        WSFN2 <> *BLANKS
     C                   EVAL      SFN2 = WSFN2
     C                   ENDIF
 
     C                   IF        WT2RF <> *BLANKS
     C                   EVAL      T2RF = WT2RF
     C                   ENDIF
 
     C                   IF        WISNO <> *BLANKS
     C                   EVAL      ISIN = WISNO
     C                   ENDIF
 
     C                   IF        WCSPN <> *BLANKS
     C                   EVAL      CSPN = WCSPN
     C                   ENDIF
 
     C                   IF        WSREF <> *BLANKS
     C                   EVAL      SREF = WSREF
     C                   ENDIF
 
     C                   IF        WSRE1 <> *BLANKS
     C                   EVAL      DASR = WSRE1
     C                   ENDIF
 
     C                   IF        WSRE2 <> *BLANKS
     C                   EVAL      DCSR = WSRE2
     C                   ENDIF
 
     C                   IF        WSRE3 <> *BLANKS
     C                   EVAL      DDSR = WSRE3
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRConvFlds - Routine to move the contents of the fields      *
      *               from file to screen fields                      *
      *                                                               *
      *****************************************************************
 
     C     SRConvFlds    BEGSR
      *
      ** First Screen
      ** ============
      *
      ** Action code.
      *
     C                   EVAL      DDACTN  = PDDACTN
      *
      ** Security shortname.
      *
     C                   EVAL      DDSESN  = SESN
      *
      ** Security reportname.
      *
     C                   EVAL      DDSRPN = SRPN
      *
      ** Security full name.
      *
     C                   EVAL      DDSFN1 = SFN1
     C                   EVAL      DDSFN2 = SFN2
      *
      ** Issuer.
      *
     C**********         IF        ISSR <> *ZEROS                                             CSD027
     C                   IF        ISSR <> *BLANKS                                            CSD027
     C                             AND ISSR <> *ZEROS                                       BUG11566
     C                   EVAL      PKeyC = *BLANKS
     C                   MOVEL     ISSR          PKeyC
     C                   EXSR      SRAOCust
                                                                                              216368
     C                   IF        RECI = 'M'                                                 216368
     C                             AND PRtcd <> *BLANKS                                       216368
                                                                                              216368
     C**********         IF        ISSR <> *ZEROS                                      216368 CSD027
     C                   IF        ISSR <> *BLANKS                                            CSD027
     C                             AND ISSR <> *ZEROS                                       BUG11566
     C                   MOVEL     ISSR          DDISSR                                       216368
     C                   END                                                                  216368
     C                   MOVE      '*NOISSR   '  RetCodeIn                                    216368
                                                                                              216368
     C                   ELSE                                                                 216368
                                                                                              216368
     C                   EVAL      DDISSR = BBCSSN
                                                                                              216368
     C                   ENDIF                                                                216368
     C                   ENDIF
      *
      ** New Issue.
      *
     C************       IF        (DDACTN = 'A' OR DDACTN = 'E') AND                         CAP084
     C                   IF        DDACTN <> 'I'  AND                                         CAP084
     C                             (ISSD <> ITLD OR ISSP <> 0 OR
     C**********                   LMGR <> 0 OR ISSA <> 0 OR                                  CSD027
     C                             LMGR <> *BLANKS OR ISSA <> 0 OR                            CSD027
     C                             TOTU <> 0 OR ALRQ <> 0 OR
     C                             ALRC <> 0 OR MGFD <> 0 OR
     C                             MGRC <> 0 OR UNFD <> 0 OR
     C                             UNFR <> 0 OR FECY <> NMCY)
     C                   EVAL      DDNISS = 'Y'
     C                   ENDIF
      *
      ** Incomplete indicator.
      *
     C                   EVAL      DDINCS = INCS
      *
      ** Partly paid indicator.
      *
     C                   EVAL      DDPPDI = PPDI
      *
      ** Investment type.
      *
     C                   EVAL      DDSITP = SITP
      *                                                                                      BUG9839
      ** Trade Basis Override                                                                BUG9839
      *                                                                                      BUG9839
     C                   EVAL      DDTBOR = STBS                                             BUG9839
      *
      ** Rating.
      *
     C                   EVAL      DDQLTY = QLTY
      *
      ** Market indicator.
      *
     C                   EVAL      DDMKTI = MKTI
      *
      ** Trade denomination.
      *
     C                   IF        SDNM <> *ZEROS
     C                   EVAL      PAmountIn = SDNM
     C                   EVAL      PNDCP = 0
     C                   EXSR      SRFmtAmt
     C                   MOVE      PAmountOutP   DDSDNM
     C                   ENDIF
      *
      ** Early repayment.
      *
     C                   EVAL      DDERPY = ERPY
      *
      ** Value date default.
      *
     C                   EVAL      DDVDFT = VDFT
      *
      ** Ex date default.
      *
     C                   EVAL      DDEDFT = EDFT
      *
      ** Nominal currency.
      *
     C                   EVAL      PCurr = NMCY
     C                   EXSR      SRAOCurr
     C                   EVAL      DDNMCY = NMCY
      *
      ** Value currency.
      *
     C                   EVAL      DDVLCY = VLCY
      *
      ** Sector code.
      *
     C                   EVAL      DDSSEC = SSEC
      *
      ** Multi-currency.
      *
     C                   EVAL      DDMLTI = MLTI
      *
      ** Industry code.
      *
     C**********         MOVEL     SIDY          DDSIDY                                       CER020
     C                   MOVEL     LOIC          DDSIDY                                       CER020
      *
      ** Country of risk.
      *
     C                   EVAL      DDSCOR = SCOR
      *
      ** Statutory returns code.
      *
     C                   EVAL      DDSRET = SRET
      *
      ** Sedol (EXTEL) reference.
      *
     C                   EVAL      DDSREF = SREF
      *
      ** Telekurs reference.
      *
     C                   EVAL      DDT2RF = T2RF
      *
      ** Cusip number.
      *
     C                   EVAL      DDCSPN = CSPN
      *
      ***Set*up*ISIN*and*SWTP*if*MT5xx*Message*Generation*or***                              BUG5564
      ***Private*Banking*module*is*installed.******************                              BUG5564
      *********************************************************                              BUG5564
     C*******************IF        S01401 = 'Y' OR BGN4ST = 'Y'                              BUG5564
      *
      ** ISIN/Common code.
     C                   EVAL      DDISIN = ISIN
      *
      ** SWIFT security type code.
     C                   EVAL      DDSWTP = SWTP
 
     C*******************ENDIF                                                               BUG5564
      *
      ** Set up Nominal decimal places if EMU Securities decimals
      ** on nominals is on.
      *
     C                   IF        CEU018 = 'Y'
     C                   MOVE      NMDP          DDNMDP
     C                   ELSE
     C                   IF        PPROT <> '7' OR  PPROT <> '8'
     C                   MOVE      '0'           DDNMDP
     C                   ENDIF
     C                   ENDIF
      *
      ** If Midas-Plato Interface is installed, set up the
      ** following values.
      *
     C                   IF        BGN2ST = 'Y'
      *
      ** Plato: Instrumental class code.
     C                   EVAL      DDICCD = PLICCD
      *
      ** Debt instrument name.
     C                   EVAL      DDDINM = PLDINM
      *
      ** Reporting group.
     C                   EVAL      DDRGCD = PLRGCD
      *
      ** Pricing group.
     C                   EVAL      DDPGCD = PLPGCD
 
     C                   ENDIF
 
      ** Market Data Feed
     C                   IF        CAP060 = 'Y'                                               CAP060
     C                   EVAL      DDSPID = SPID                                              CAP060
     C                   EVAL      DDSPDS = SPDS                                              CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CGL032
      ** Taxation of Savings Income                                                           CGL032
                                                                                              CGL032
     C                   IF        CGL032 = 'Y'                                               CGL032
     C                   EVAL      DDSETX = SETX                                              CGL032
     C                   ENDIF                                                                CGL032
      *
      ** Second Screen
      ** =============
      *
      ** Set up second screen values only if action is not Insert.
      *
     C                   IF        PDDACTN <> 'I'
     C                             and CSC011 = 'N' or                                        CSC011
     C                             PParmLink <> 'Y' and CSC011 = 'Y'                          CSC011
      *
      ** Initial dividend.
      *
     C                   IF        IDIV <> *ZEROS
     C                   Z-ADD     IDIV          PDateIn
     C                   EXSR      SRFmtDat
     C                   MOVEL     PDateOut      DDIDIV
     C                   ENDIF
      *
      ** Next expected dividend.
      *
     C                   IF        NEXD <> *ZEROS
 
     C                   IF        VLCY <> *BLANKS
     C                   EVAL      PCurr = VLCY
     C                   ELSE
     C                   EVAL      PCurr = NMCY
     C                   ENDIF
      *
      ** Get decimal places.
     C                   EXSR      SRAOCurr
     C                   EVAL      PAmountIn = NEXD
     C                   EVAL      PNDCP = A6NBDP
     C                   EXSR      SRFmtAmt
     C                   MOVE      PAmountOutP   DDNEXD
 
     C                   ENDIF
      *
      ** Set up Roll forward dividend if Interest Risk Management
      ** is on.
      *
     C                   IF        BGRKMG = 'Y'
     C                   IF        RFDI <> *BLANKS
     C                   EVAL      DDRFDI = RFDI
     C                   ELSE
     C                   EVAL      DDRFDI = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** Interest bearing security
      ** =========================
      *
     C                   IF        (STBS = 'P' AND PPROT <> '2' AND
     C                             PPROT <> '4' AND PPROT <> '7') OR
     C                             (STBS = 'Y' AND PPROT <> '2' AND
     C                             PPROT <> '4' AND PPROT <> '7' AND
     C                             PPROT <> '9')
      *
      ** Coupon rate.
     C                   MOVE      *BLANKS       ZFld15
     C                   MOVE      CPNR          ZFld15
     C                   EVAL      ZDecs = 7
     C                   EXSR      SRFmtAm1
     C                   MOVE      ZOut21        DDCPNR
      *
      ** Base rate code.
     C                   IF        BASC <> *ZEROS
     C                   MOVEL     BASC          DDBASC
     C                   ENDIF
      *
      ** Base rate/spread.
     C                   IF        BASS <> *ZEROS
     C                   Z-ADD     *ZERO         PAmountIn
     C                   MOVE      BASS          PAmountIn
     C                   EVAL      PNDCP = 7
     C                   EXSR      SRFmtAmt
     C                   MOVE      PAmountOutP   DDBASS
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   MOVE      PAmountOutD   DDBASS                                       CRE073
     C                   ENDIF
     C                   ENDIF                                                                CRE073
      *
      ** Spread indicator.
     C                   EVAL      DDSPRI = SPRI
      *
      ** Minimum coupon.
     C                   IF        MCPN <> *ZEROS
     C                   Z-ADD     *ZERO         PAmountIn
     C                   MOVE      MCPN          PAmountIn
     C                   EVAL      PNDCP = 7
     C                   EXSR      SRFmtAmt
     C                   MOVE      PAmountOutP   DDMCPN
     C                   ENDIF
      *
      ** Maturity date 2.
     C                   IF        MATY <> *ZEROS
     C                   IF        MATY <> 99999
     C                   Z-ADD     MATY          PDateIn
     C                   EXSR      SRFmtDat
     C                   MOVEL     PDateOut      DDMATY2
     C                   ELSE
     C                   EVAL      DDMATY2 = '999999'
     C                   ENDIF
     C                   ENDIF
      *
      ** Maturity date indicator 2.
     C                   IF        PPROT = '9'
     C                   EVAL      DDMDTI2 = MDTI
     C                   ENDIF
      *
      ** Long-term maturity indicator.
     C                   EVAL      DDLTMI = LTMI
      *
      ** Day basis 2.
     C                   EVAL      DDDYBS2 = DYBS
      *
      ** Divisor basis 2.
     C                   EVAL      DDDVBS2 = DVBS
      *
      ** Interest adjustment.
     C                   IF        IADJ <> *ZEROS
     C                   MOVE      *BLANKS       ZFld15
     C                   MOVE      IADJ          ZFld15
     C                   EVAL      ZDecs = 0
     C                   EXSR      SRFmtAm1
     C                   MOVE      ZOut21        DDIADJ
     C                   ENDIF
      *
      ** Initial date.
     C                   IF        ITLD <> *ZEROS
     C                   Z-ADD     ITLD          PDateIn
     C                   EXSR      SRFmtDat
     C                   MOVEL     PDateOut      DDITLD
     C                   ENDIF
      *
      ** Contingent liability indicator 2.
     C                   EVAL      DDCNLI2 = CNLI
      *
      ** First coupon.
     C                   IF        FCPN <> *ZEROS
     C                   Z-ADD     FCPN          PDateIn
     C                   EXSR      SRFmtDat
     C                   MOVEL     PDateOut      DDFCPN
     C                   ENDIF
      *
      ** Rate change frequency.
     C                   EVAL      DDRCFQ = RCFQ
      *
      ** Next change date.
     C                   IF        NCHD <> *ZEROS
     C                   Z-ADD     NCHD          PDateIn
     C                   EXSR      SRFmtDat
     C                   MOVEL     PDateOut      DDNCHD
     C                   ENDIF
      *
      ** Coupon/Rate indicators array.
     C                   EVAL      DDCR01 = CR01
     C                   EVAL      DDCR02 = CR02
     C                   EVAL      DDCR03 = CR03
     C                   EVAL      DDCR04 = CR04
     C                   EVAL      DDCR05 = CR05
     C                   EVAL      DDCR06 = CR06
     C                   EVAL      DDCR07 = CR07
     C                   EVAL      DDCR08 = CR08
     C                   EVAL      DDCR09 = CR09
     C                   EVAL      DDCR10 = CR10
     C                   EVAL      DDCR11 = CR11
     C                   EVAL      DDCR12 = CR12
                                                                                              CAS006
      ** Set the Coupon Rate Credit Risk Spread and the Coupon Rate                           CAS006
      ** Liquidity Premium display fields if CAS006 is enabled.                               CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
                                                                                              CAS006
     C                   EVAL      ZDecs = 7                                                  CAS006
                                                                                              CAS006
     C                   IF        CCRK <> *ZERO                                              CAS006
     C                   EVAL      ZFld15 = *ZERO                                             CAS006
     C                   MOVE      CCRK          ZFld15                                       CAS006
     C                   EXSR      SRFmtAm1                                                   CAS006
     C                   MOVE      ZOut21        DDCCRK                                       CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        CLQP <> *ZERO                                              CAS006
     C                   EVAL      ZFld15 = *ZERO                                             CAS006
     C                   MOVE      CLQP          ZFld15                                       CAS006
     C                   EXSR      SRFmtAm1                                                   CAS006
     C                   MOVE      ZOut21        DDCLQP                                       CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CSE071
      ** Set Holiday Currencies if CSE071 is on.                                              CSE071
                                                                                              CSE071
     C                   IF        CSE071 = 'Y'                                               CSE071
      *                                                                                       CSE071
     C                   EVAL      DDHCY1 = HCY1                                              CSE071
     C                   EVAL      DDHCY2 = HCY2                                              CSE071
     C                   EVAL      DDHCY3 = HCY3                                              CSE071
     C                   EVAL      DDHCY4 = HCY4                                              CSE071
     C                   EVAL      DDHCY5 = HCY5                                              CSE071
     C                   EVAL      DDHCY6 = HCY6                                              CSE071
     C                   EVAL      DDHCY7 = HCY7                                              CSE071
     C                   EVAL      DDHCY8 = HCY8                                              CSE071
     C                   EVAL      DDHCY9 = HCY9                                              CSE071
      *                                                                                       CSE071
     C                   ENDIF                                                                CSE071
 
     C                   ENDIF
      *
      ** Discount security.
      ** =================
      *
     C                   IF        STBS = 'D' OR
     C                             (STBS = 'Y' AND PPROT = '9')
      *
      ** Maturity date and indicator 1.
     C                   IF        MATY <> *ZEROS
     C                   Z-ADD     MATY          PDateIn
     C                   EXSR      SRFmtDat
     C                   MOVEL     PDateOut      DDMATY1
     C                   ENDIF
      *
      ** Maturity date indicator 1.
     C                   IF        PPROT = '9'
     C                   EVAL      DDMDTI1 = MDTI
     C                   ENDIF
      *
      ** Day basis 1.
     C                   EVAL      DDDYBS1 = DYBS
      *
      ** Divisor basis 1.
     C                   EVAL      DDDVBS1 = DVBS
      *
      ** Contingent liability indicator 1.
     C                   EVAL      DDCNLI1 = CNLI
 
     C                   ENDIF
      *
      ** Risk customer and drawer.
      *
     C                   IF        PPROT = '9'
 
     C**********         IF        RSKC <> *ZERO                                              CSD027
     C                   IF        RSKC <> *BLANKS                                            CSD027
     C                   MOVEL     RSKC          DDRSKC
     C                   ENDIF
 
     C                   EVAL      DDDRWR = DRWR
     C                   ENDIF
      *
      ** Business day convention.
      *
     C                   IF        CSE005 = 'Y'
     C                   EVAL      DDBCNV = BCNV
     C                   ENDIF
      *                                                                                       CSE031
     C                   IF        CSE031 = 'Y'                                               CSE031
     C                   IF        PPROT = '3' OR PPROT = '8'                                 CSE031
      ** Fixing Day                                                                           CSE031
     C                   MOVE      FIXD          DDFIXD                                       CSE031
      ** Auto Fix                                                                             CSE031
     C                   EVAL      DDAUFX = AUFX                                              CSE031
      *                                                                                       CSE031
     C                   ENDIF                                                                CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CRE073
     C                   EVAL      DDCNSP = *BLANKS                                           CRE073
     C                   EVAL      DDCNSG = *BLANKS                                           CRE073
     C                   EVAL      DDRDMT = *BLANKS                                           CRE073
     C                   EVAL      DDRDFD = *BLANKS                                           CRE073
      *                                                                                       CRE073
     C                   IF        CRE073 = 'Y' AND                                           CRE073
     C                             (PPROT = '3' OR PPROT = '8')                               CRE073
      *                                                                                       CRE073
      ** Contractual Spread                                                                   CRE073
      *                                                                                       CRE073
     C                   IF        CNSP <> *ZEROS                                             CRE073
     C                   Z-ADD     *ZERO         PAmountIn                                    CRE073
     C                   MOVE      CNSP          PAmountIn                                    CRE073
     C                   EVAL      PNDCP = 7                                                  CRE073
     C                   EXSR      SRFmtAmt                                                   CRE073
     C                   MOVE      PAmountOutP   DDCNSP                                       CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
      ** Contractual Spread Indicator                                                         CRE073
      *                                                                                       CRE073
     C                   EVAL      DDCNSG = CNSG                                              CRE073
      *                                                                                       CRE073
      ** Rounding Method                                                                      CRE073
      *                                                                                       CRE073
     C                   EVAL      DDRDMT = RDMT                                              CRE073
      *                                                                                       CRE073
      ** Rounding Fraction/ Decimal                                                           CRE073
      *                                                                                       CRE073
     C                   EVAL      DDRDFD = RDFD                                              CRE073
      *                                                                                       CRE073
     C                   ENDIF                                                                CRE073
      *
      ** Initial and Fuly paid prices are based on 3 decimal places if
      ** Processing type '4', else Nominal currency decimal places.
      *
     C                   IF        SINP <> *ZEROS OR
     C                             SFPP <> *ZEROS
 
     C                   IF        PPROT <> '4'
     C                   EVAL      PNDCP = 3
     C                   ELSE
     C/COPY WNCPYSRC,DUG502_003                                                               DUG502
     C                   EVAL      PCurr = NMCY
     C                   EXSR      SRAOCurr
     C                   EVAL      PNDCP = A6NBDP
     C/COPY WNCPYSRC,DUG502_004                                                               DUG502
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Initial payment.
      *
     C                   IF        SINP <> *ZEROS
     C                   EVAL      PAmountIn = SINP
     C                   EXSR      SRFmtAmt
     C                   MOVE      PAmountOutP   DDSINP
     C                   ENDIF
      *
      ** Fully paid price.
      *
     C                   IF        SFPP <> *ZEROS
     C                   EVAL      PAmountIn = SFPP
     C                   EXSR      SRFmtAmt
     C                   MOVE      PAmountOutP   DDSFPP
     C                   ENDIF
      *
      ** If Interest or Share Security, set up Coupon/Rate days array.
      *
     C                   IF        (STBS = 'P' AND PPROT <> '2' AND
     C                             PPROT <> '4' AND PPROT <> '7') OR
     C                             (STBS = 'Y' AND PPROT <> '2' AND
     C                             PPROT <> '4' AND PPROT <> '7' AND
     C                             PPROT <> '9')  OR  PPROT = '4' OR
     C                             PPROT = '7'
 
     C                   IF        CD01 <> *ZEROS
     C                   MOVEL     CD01          DDCD01
     C                   ENDIF
     C                   IF        CD02 <> *ZEROS
     C                   MOVEL     CD02          DDCD02
     C                   ENDIF
     C                   IF        CD03 <> *ZEROS
     C                   MOVEL     CD03          DDCD03
     C                   ENDIF
     C                   IF        CD04 <> *ZEROS
     C                   MOVEL     CD04          DDCD04
     C                   ENDIF
     C                   IF        CD05 <> *ZEROS
     C                   MOVEL     CD05          DDCD05
     C                   ENDIF
     C                   IF        CD06 <> *ZEROS
     C                   MOVEL     CD06          DDCD06
     C                   ENDIF
     C                   IF        CD07 <> *ZEROS
     C                   MOVEL     CD07          DDCD07
     C                   ENDIF
     C                   IF        CD08 <> *ZEROS
     C                   MOVEL     CD08          DDCD08
     C                   ENDIF
     C                   IF        CD09 <> *ZEROS
     C                   MOVEL     CD09          DDCD09
     C                   ENDIF
     C                   IF        CD10 <> *ZEROS
     C                   MOVEL     CD10          DDCD10
     C                   ENDIF
     C                   IF        CD11 <> *ZEROS
     C                   MOVEL     CD11          DDCD11
     C                   ENDIF
     C                   IF        CD12 <> *ZEROS
     C                   MOVEL     CD12          DDCD12
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Issue amount - 1.
      *
     C                   IF        DDERPY = 'Y' AND BGRKMG = 'Y' AND
     C                             ISSA <> *ZEROS
     C                   EVAL      PAmountIn = ISSA
     C                   EVAL      PNDCP = 0
     C                   EXSR      SRFmtAmt
     C                   MOVE      PAmountOutP   DDISA1
     C                   ENDIF
      *
      ** Depot security references.
      *
     C                   EVAL      DDDASR = DASR
     C                   EVAL      DDDCSR = DCSR
     C                   EVAL      DDDDSR = DDSR
      *
      ** Market centre.
      *
     C                   EVAL      DDSMCC = SMCC
      *
      ** Convertible indicator.
      *
     C                   EVAL      DDSCVI = SCVI
      *
      ** Price basis.
      *
     C                   EVAL      DDSPBS = SPBS
      *
      ** Yield basis.
      *
     C**********         IF        STBS = 'Y'                                   CSE032
     C                   EVAL      DDSYBS = SYBS
     C**********         ENDIF                                                  CSE032
      *
      ** Australian yield defaults.
      *
     C     SYBS          IFEQ      'AU'
      *
      ** Compounding frequency.
     C                   IF        CMFQ <> *ZEROS
     C                   MOVEL     CMFQ          DDCMFQ
     C                   ENDIF
      *
      ** Discount basis.
     C                   EVAL      DDDSCB = DSCB
      *
      ** Discount last coupon.
     C                   EVAL      DDDSLC = DSLC
      *
      ** Maturity date 2.
     C                   IF        MATY <> *ZEROS
     C                   IF        MATY <> 99999
     C                   Z-ADD     MATY          PDateIn
     C                   EXSR      SRFmtDat
     C                   MOVEL     PDateOut      DDMATY2
     C                   ELSE
     C                   EVAL      DDMATY2 = '999999'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
      *
      ** If user is not inserting, format last/next coupon date.
      *
     C                   IF        DDACTN <> 'I'
     C                             and CSC011 = 'N' or                                        CSC011
     C                             PParmLink <> 'Y' and CSC011 = 'Y'                          CSC011
      *
      ** Last coupon date.
     C                   IF        LCPN <> *ZEROS
     C                   Z-ADD     LCPN          PDateIn
     C                   EXSR      SRFmtDat
     C                   MOVEL     PDateOut      PLCPN
     C                   ELSE
     C                   EVAL      PLCPN = *BLANKS
     C                   ENDIF
      *                                                                                       CSE031
     C                   MOVEL     PLCPN         DDLCPN                                       CSE031
      *
      ** Next coupon date.
     C                   CALLB     'ZNCD'
     C                   PARM                    ITLD
     C                   PARM                    FCPN
     C                   PARM                    MATY
     C                   PARM                    CDArr
     C                   PARM                    CRArr
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN
     C                   PARM                    NMCY
     C                   PARM                    SITP
     C                   PARM                    BCNV
     C                   PARM                    LCPN                                         CSE031
      ** Effect of Holidays on Dates                                                          CSE071
     C                   PARM                    HCY1                                         CSE071
     C                   PARM                    HCY2                                         CSE071
     C                   PARM                    HCY3                                         CSE071
     C                   PARM                    HCY4                                         CSE071
     C                   PARM                    HCY5                                         CSE071
     C                   PARM                    HCY6                                         CSE071
     C                   PARM                    HCY7                                         CSE071
     C                   PARM                    HCY8                                         CSE071
     C                   PARM                    HCY9                                         CSE071
     C                   PARM                    NCD
 
     C                   IF        NCD <> *ZEROS
     C                   Z-ADD     NCD           PDateIn
     C                   EXSR      SRFmtDat
     C                   MOVEL     PDateOut      PNCD
     C                   ELSE
     C                   MOVE      *BLANKS       PNCD
     C                   ENDIF
 
     C                   IF        CSE031 = 'Y' AND PPROT = '3' OR                            CSE031
     C                             CSE031 = 'Y' AND PPROT = '8'                               CSE031
     C                             OR CSE071 = 'Y' AND (PPROT = '1' OR                        CSE071
     C                             PPROT = '3' OR PPROT = '5' OR PPROT = '6' OR               CSE071
     C                             PPROT = '8' OR PPROT = '9')                                CSE071
      *                                                                                       CSE031
      ** Next Coupon date is made amendable.                                                  CSE031
      *                                                                                       CSE031
     C                   MOVEL     PNCD          DDNCD                                        CSE031
      *                                                                                       CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
     C                   ENDIF
 
     C                   ENDIF
      *                                                                                       CSE037
      ** Set up No of decimal places to round if Countervalue rounding is on.                 CSE037
      *                                                                                       CSE037
     C                   IF        CSE037 = 'Y'                                               CSE037
     C                   MOVE      NDEC          DDNDEC                                       CSE037
     C                   ELSE                                                                 CSE037
     C                   CLEAR                   DDNDEC                                       CSE037
     C                   ENDIF                                                                CSE037
 
      *
      ** Third Screen
      ** ============
      *
      ** Set up third screen values only if action is not Insert.
      *
     C                   IF        PDDACTN <> 'I'
     C                             and CSC011 = 'N' or                                        CSC011
     C                             PParmLink <> 'Y' and CSC011 = 'Y'                          CSC011
      *
      ** Issue date.
      *
     C*******************IF        DDNISS = 'Y' OR BGN4ST = 'Y'                              BUG5564
     C                   IF        ISSD <> *ZEROS
     C                   Z-ADD     ISSD          PDateIn
     C                   EXSR      SRFmtDat
     C                   MOVEL     PDateOut      DDISSD
     C                   ENDIF
     C*******************ENDIF                                                               BUG5564
      *
      ** Set up new issue details if new issue.
      *
     C*******************IF        DDNISS = 'Y'                                              BUG5564
      *
      ** Issue price.
      *
     C                   IF        ISSP <> *ZEROS
     C                   Z-ADD     *ZERO         PAmountIn
     C                   MOVE      ISSP          PAmountIn
     C                   EVAL      PNDCP = 8
     C                   EXSR      SRFmtAmt
     C                   MOVE      PAmountOutP   DDISSP
     C                   ENDIF
      *
      ** Issue amount - 2.
      *
     C                   IF        ISSA <> *ZEROS
     C                   EVAL      PAmountIn = ISSA
     C                   EVAL      PNDCP = 0
     C                   EXSR      SRFmtAmt
     C                   MOVE      PAmountOutP   DDISA2
     C                   ENDIF
      *
      ** Lead manager.
      *
     C**********         IF        LMGR <> *ZEROS                                             CSD027
     C                   IF        LMGR <> *BLANKS                                            CSD027
     C                             AND LMGR <> *ZEROS                                       BUG11566
     C                   EVAL      PKeyC = *BLANKS
     C                   MOVEL     LMGR          PKeyC
     C                   EXSR      SRAOCust
                                                                                              216368
     C                   IF        RECI = 'M'                                                 216368
     C                             AND PRtcd <> *BLANKS                                       216368
                                                                                              216368
     C**********         IF        LMGR <> *ZEROS                                      216368 CSD027
     C                   IF        LMGR <> *BLANKS                                            CSD027
     C                             AND LMGR <> *ZEROS                                       BUG11566
     C                   MOVEL     LMGR          DDLMGR                                       216368
     C                   ENDIF                                                                216368
     C                   MOVE      '*NOLMGR   '  RetCodeIn                                    216368
                                                                                              216368
     C                   ELSE                                                                 216368
                                                                                              216368
     C                   EVAL      DDLMGR = BBCSSN
                                                                                              216368
     C                   ENDIF                                                                216368
     C                   ENDIF
      *
      ** Total underwritten.
      *
     C                   IF        TOTU <> *ZEROS
     C                   EVAL      PAmountIn = TOTU
     C                   EVAL      PNDCP = 0
     C                   EXSR      SRFmtAmt
     C                   MOVE      PAmountOutP   DDTOTU
     C                   ENDIF
      *
      ** Allocation requested.
      *
     C                   IF        ALRQ <> *ZEROS
     C                   EVAL      PAmountIn = ALRQ
     C                   EVAL      PNDCP = 0
     C                   EXSR      SRFmtAmt
     C                   MOVE      PAmountOutP   DDALRQ
     C                   ENDIF
      *
      ** Allocation received.
      *
     C                   IF        ALRC <> *ZEROS
     C                   EVAL      PAmountIn = ALRC
     C                   EVAL      PNDCP = 0
     C                   EXSR      SRFmtAmt
     C                   MOVE      PAmountOutP   DDALRC
     C                   ENDIF
      *
      ** Check number of decimal places for fee currency.
      *
     C                   EVAL      PCurr = FECY
     C                   EXSR      SRAOCurr
      *
      ** Management fees due.
      *
     C                   IF        MGFD <> *ZEROS
     C                   EVAL      PAmountIn = MGFD
     C                   EVAL      PNDCP = A6NBDP
     C                   EXSR      SRFmtAmt
     C                   MOVE      PAmountOutP   DDMGFD
     C                   ENDIF
      *
      ** Management fees received.
      *
     C                   IF        MGRC <> *ZEROS
     C                   EVAL      PAmountIn = MGRC
     C                   EVAL      PNDCP = A6NBDP
     C                   EXSR      SRFmtAmt
     C                   MOVE      PAmountOutP   DDMGRC
     C                   ENDIF
      *
      ** Underwriting fees due.
      *
     C                   IF        UNFD <> *ZEROS
     C                   EVAL      PAmountIn = UNFD
     C                   EVAL      PNDCP = A6NBDP
     C                   EXSR      SRFmtAmt
     C                   MOVE      PAmountOutP   DDUNFD
     C                   ENDIF
      *
      ** Underwriting fees received.
      *
     C                   IF        UNFR <> *ZEROS
     C                   EVAL      PAmountIn = UNFR
     C                   EVAL      PNDCP = A6NBDP
     C                   EXSR      SRFmtAmt
     C                   MOVE      PAmountOutP   DDUNFR
     C                   ENDIF
 
     C*******************ENDIF                                                               BUG5564
      *
      ** Fee currency.
      *
     C*******************IF        DDNISS = 'Y' OR BGN4ST = 'Y'                              BUG5564
     C                   EVAL      DDFECY = FECY
     C*******************ENDIF                                                               BUG5564
      *                                                                                       CGL014
     C                   IF        CGL014 = 'Y'                                               CGL014
     C                   IF        WEIC <> *ZERO                                              CGL014
     C                   MOVEL     WEIC          DDWEIC                                       CGL014
     C                   ENDIF                                                                CGL014
     C                   EVAL      DDPBIT = PBIT                                              CGL014
     C                   ENDIF                                                                CGL014
      *
      *
      ** Display file values if Private Banking is on.
      *
     C*******************IF        BGN4ST = 'Y'                                              BUG5564
      *
      ** Principal paying agent.
     C**********         IF        PPAG <> *ZEROS                                             CSD027
     C                   IF        PPAG <> *BLANKS                                            CSD027
     C                   MOVEL     PPAG          DDPPAG
     C                   ENDIF
      *
      ** Guarantor.
     C**********         IF        GUAR <> *ZEROS                                             CSD027
     C                   IF        GUAR <> *BLANKS                                            CSD027
     C                   MOVEL     GUAR          DDGUAR
     C                   ENDIF
      *
      ** Weighting code.
     C                   IF        WEIC <> *ZEROS
     C                   MOVEL     WEIC          DDWEIC
     C                   ENDIF
      *
      ** Nature of account.
     C                   EVAL      DDNATU = NATU
      *
      ** PB Instrument Type.
     C                   EVAL      DDPBIT = PBIT
 
     C                   ENDIF
      *                                                                                       CSE065
      ** Average Life Date                                                                    CSE065
     C                   IF        CSE065 = 'Y' AND                                           CSE065
     C                             PPROT <> '2' AND                                           CSE065
     C                             PPROT <> '4' AND                                           CSE065
     C                             PPROT <> '7'                                               CSE065
     C                   EVAL      PDayN = ALDT                                               CSE065
     C                   EXSR      SrFmtDat2                                                  CSE065
     C                   MOVE      PDat8F        DDALDT                                       CSE065
     C                   ENDIF                                                                CSE065
      *                                                                                       CSE075
      ** Format US Enhanced Treasury fields.                                                  CSE075
      *                                                                                       CSE075
     C                   IF        CSE075 = 'Y' AND                                           CSE075
     C                             PPROT = '8'                                                CSE075
                                                                                              CSE075
     C**********         MOVE      *BLANKS       ZFld15                                CSE075 CSE075
     C**********         MOVE      CPDY          ZFld15                                CSE075 CSE075
     C**********         EVAL      ZDecs = 0                                           CSE075 CSE075
     C**********         EXSR      SRFmtAm1                                            CSE075 CSE075
     C**********         MOVE      ZOut21        WRKFLD4                               CSE075 CSE075
     C**********         MOVEL     WRKFLD4       DDCPDY                                CSE075 CSE075
                                                                                              CSE075
     C                   MOVE      *BLANKS       ZFld15                                       CSE075
     C                   MOVE      RPRT          ZFld15                                       CSE075
     C                   EVAL      ZDecs = 4                                                  CSE075
     C                   EXSR      SRFmtAm1                                                   CSE075
     C                   MOVE      ZOut21        WRKFLD9                                      CSE075
     C                   MOVEL     WRKFLD9       DDRPRT                                       CSE075
                                                                                              CSE075
     C                   MOVE      *BLANKS       ZFld15                                       CSE075
     C                   MOVE      WACP          ZFld15                                       CSE075
     C                   EVAL      ZDecs = 4                                                  CSE075
     C                   EXSR      SRFmtAm1                                                   CSE075
     C                   MOVE      ZOut21        WRKFLD9                                      CSE075
     C                   MOVEL     WRKFLD9       DDWACP                                       CSE075
                                                                                              CSE075
     C                   MOVE      *BLANKS       ZFld15                                       CSE075
     C                   MOVE      WAMY          ZFld15                                       CSE075
     C                   EVAL      ZDecs = 4                                                  CSE075
     C                   EXSR      SRFmtAm1                                                   CSE075
     C                   MOVE      ZOut21        WRKFLD9                                      CSE075
     C                   MOVEL     WRKFLD9       DDWAMY                                       CSE075
                                                                                              CSE075
     C                   ENDIF                                                                CSE075
                                                                                              CSE075
      ** Format Coupon Daily Rate separately                                                  CSE075
                                                                                              CSE075
     C                   IF        CSE075 = 'Y'                                               CSE075
     C                   IF        (STBS = 'P' AND PPROT <> '2' AND                           CSE075
     C                             PPROT <> '4' AND PPROT <> '7') OR                          CSE075
     C                             (STBS = 'Y' AND PPROT <> '2' AND                           CSE075
     C                             PPROT <> '4' AND PPROT <> '7' AND                          CSE075
     C                             PPROT <> '9')                                              CSE075
     C                   MOVE      *BLANKS       ZFld15                                       CSE075
     C                   MOVE      CPDY          ZFld15                                       CSE075
     C                   EVAL      ZDecs = 0                                                  CSE075
     C                   EXSR      SRFmtAm1                                                   CSE075
     C                   MOVE      ZOut21        WRKFLD4                                      CSE075
     C                   MOVEL     WRKFLD4       DDCPDY                                       CSE075
     C                   ENDIF                                                                CSE075
     C                   ENDIF                                                                CSE075
 
     C*******************ENDIF                                                               BUG5564
      *                                                                         CSE023
      ** Third Screen Window                                                    CSE023
      ** ===================                                                    CSE023
      *                                                                         CSE023
      ** Set up third screen window values only if action is not Insert         CSE023
      ** and enhancement CSE023 is installed.                                   CSE023
      *                                                                         CSE023
     C                   IF        PDDACTN <> 'I' AND CSE023 = 'Y'              CSE023
     C                             and CSC011 = 'N' or                                        CSC011
     C                             PParmLink <> 'Y' and CSC011 = 'Y' and                      CSC011
     C                             CSE023 = 'Y'                                               CSC011
                                                                                CSE023
     C                   EVAL      DDCRTT = CRTT                                CSE023
     C                   EVAL      DDINCT = INCT                                CSE023
     C                   EVAL      DDEXCD = EXCD                                CSE023
     C                   EVAL      DDOIDI = OIDI                                CSE023
     C                   EVAL      DDAPIE = APIE                                CSE023
                                                                                CSE023
     C                   ENDIF                                                  CSE023
 
      *                                                                                       CSE031
      * Fourth Screen                                                                         CSE031
      * =============                                                                         CSE031
     C                   IF        CSE031 = 'Y'                                               CSE031
      *                                                                                       CSE031
      ** Applicable Date 1                                                                    CSE031
     C                   IF        AD01 <> *ZEROS                                             CSE031
     C                   MOVEL     AD01          DDAD01                                       CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Base Rate Code 1                                                                     CSE031
     C                   IF        BR01 <> *ZEROS                                             CSE031
     C                   MOVE      BR01          DDBR01                                       CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Spread Rate 1                                                                        CSE031
     C                   IF        BS01 <> *ZEROS                                             CSE031
     C                   Z-ADD     *ZERO         PAmountIn                                    CSE031
     C                   MOVE      BS01          PAmountIn                                    CSE031
     C                   EVAL      PNDCP = 7                                                  CSE031
     C                   EXSR      SRFmtAmt                                                   CSE031
     C                   MOVE      PAmountOutP   DDBS01                                       CSE031
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   MOVE      PAmountOutD   DDBS01                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Spread Indicator 1                                                                   CSE031
     C                   EVAL      DDSI01 = SI01                                              CSE031
      *                                                                                       CSE031
      *                                                                                       CSE031
      ** Applicable Date 2                                                                    CSE031
     C                   IF        AD02 <> *ZEROS                                             CSE031
     C                   MOVE      AD02          DDAD02                                       CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Base Rate Code 2                                                                     CSE031
     C                   IF        BR02 <> *ZEROS                                             CSE031
     C                   MOVE      BR02          DDBR02                                       CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Spread Rate 2                                                                        CSE031
     C                   IF        BS02 <> *ZEROS                                             CSE031
     C                   Z-ADD     *ZERO         PAmountIn                                    CSE031
     C                   MOVE      BS02          PAmountIn                                    CSE031
     C                   EVAL      PNDCP = 7                                                  CSE031
     C                   EXSR      SRFmtAmt                                                   CSE031
     C                   MOVE      PAmountOutP   DDBS02                                       CSE031
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   MOVE      PAmountOutD   DDBS02                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Spread Indicator 2                                                                   CSE031
     C                   EVAL      DDSI02 = SI02                                              CSE031
      *                                                                                       CSE031
      *                                                                                       CSE031
      ** Applicable Date 3                                                                    CSE031
     C                   IF        AD03 <> *ZEROS                                             CSE031
     C                   MOVE      AD03          DDAD03                                       CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Base Rate Code 3                                                                     CSE031
     C                   IF        BR03 <> *ZEROS                                             CSE031
     C                   MOVE      BR03          DDBR03                                       CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Spread Rate 3                                                                        CSE031
     C                   IF        BS03 <> *ZEROS                                             CSE031
     C                   Z-ADD     *ZERO         PAmountIn                                    CSE031
     C                   MOVE      BS03          PAmountIn                                    CSE031
     C                   EVAL      PNDCP = 7                                                  CSE031
     C                   EXSR      SRFmtAmt                                                   CSE031
     C                   MOVE      PAmountOutP   DDBS03                                       CSE031
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   MOVE      PAmountOutD   DDBS03                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Spread Indicator 3                                                                   CSE031
     C                   EVAL      DDSI03 = SI03                                              CSE031
      *                                                                                       CSE031
      *                                                                                       CSE031
      ** Applicable Date 4                                                                    CSE031
     C                   IF        AD04 <> *ZEROS                                             CSE031
     C                   MOVE      AD04          DDAD04                                       CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Base Rate Code 4                                                                     CSE031
     C                   IF        BR04 <> *ZEROS                                             CSE031
     C                   MOVE      BR04          DDBR04                                       CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Spread Rate 4                                                                        CSE031
     C                   IF        BS04 <> *ZEROS                                             CSE031
     C                   Z-ADD     *ZERO         PAmountIn                                    CSE031
     C                   MOVE      BS04          PAmountIn                                    CSE031
     C                   EVAL      PNDCP = 7                                                  CSE031
     C                   EXSR      SRFmtAmt                                                   CSE031
     C                   MOVE      PAmountOutP   DDBS04                                       CSE031
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   MOVE      PAmountOutD   DDBS04                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Spread Indicator 4                                                                   CSE031
     C                   EVAL      DDSI04 = SI04                                              CSE031
      *                                                                                       CSE031
      *                                                                                       CSE031
      ** Applicable Date 5                                                                    CSE031
     C                   IF        AD05 <> *ZEROS                                             CSE031
     C                   MOVE      AD05          DDAD05                                       CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Base Rate Code 5                                                                     CSE031
     C                   IF        BR05 <> *ZEROS                                             CSE031
     C                   MOVE      BR05          DDBR05                                       CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Spread Rate 5                                                                        CSE031
     C                   IF        BS05 <> *ZEROS                                             CSE031
     C                   Z-ADD     *ZERO         PAmountIn                                    CSE031
     C                   MOVE      BS05          PAmountIn                                    CSE031
     C                   EVAL      PNDCP = 7                                                  CSE031
     C                   EXSR      SRFmtAmt                                                   CSE031
     C                   MOVE      PAmountOutP   DDBS05                                       CSE031
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   MOVE      PAmountOutD   DDBS05                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Spread Indicator 5                                                                   CSE031
     C                   EVAL      DDSI05 = SI05                                              CSE031
      *                                                                                       CSE031
      *                                                                                       CSE031
      ** Applicable Date 6                                                                    CSE031
     C                   IF        AD06 <> *ZEROS                                             CSE031
     C                   MOVE      AD06          DDAD06                                       CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Base Rate Code 6                                                                     CSE031
     C                   IF        BR06 <> *ZEROS                                             CSE031
     C                   MOVE      BR06          DDBR06                                       CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Spread Rate 6                                                                        CSE031
     C                   IF        BS06 <> *ZEROS                                             CSE031
     C                   Z-ADD     *ZERO         PAmountIn                                    CSE031
     C                   MOVE      BS06          PAmountIn                                    CSE031
     C                   EVAL      PNDCP = 7                                                  CSE031
     C                   EXSR      SRFmtAmt                                                   CSE031
     C                   MOVE      PAmountOutP   DDBS06                                       CSE031
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   MOVE      PAmountOutD   DDBS06                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Spread Indicator 6                                                                   CSE031
     C                   EVAL      DDSI06 = SI06                                              CSE031
      *                                                                                       CSE031
      *                                                                                       CSE031
      ** Applicable Date 7                                                                    CSE031
     C                   IF        AD07 <> *ZEROS                                             CSE031
     C                   MOVE      AD07          DDAD07                                       CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Base Rate Code 7                                                                     CSE031
     C                   IF        BR07 <> *ZEROS                                             CSE031
     C                   MOVE      BR07          DDBR07                                       CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Spread Rate 7                                                                        CSE031
     C                   IF        BS07 <> *ZEROS                                             CSE031
     C                   Z-ADD     *ZERO         PAmountIn                                    CSE031
     C                   MOVE      BS07          PAmountIn                                    CSE031
     C                   EVAL      PNDCP = 7                                                  CSE031
     C                   EXSR      SRFmtAmt                                                   CSE031
     C                   MOVE      PAmountOutP   DDBS07                                       CSE031
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   MOVE      PAmountOutD   DDBS07                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Spread Indicator 7                                                                   CSE031
     C                   EVAL      DDSI07 = SI07                                              CSE031
      *                                                                                       CSE031
      *                                                                                       CSE031
      ** Applicable Date 8                                                                    CSE031
     C                   IF        AD08 <> *ZEROS                                             CSE031
     C                   MOVE      AD08          DDAD08                                       CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Base Rate Code 8                                                                     CSE031
     C                   IF        BR08 <> *ZEROS                                             CSE031
     C                   MOVE      BR08          DDBR08                                       CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Spread Rate 8                                                                        CSE031
     C                   IF        BS08 <> *ZEROS                                             CSE031
     C                   Z-ADD     *ZERO         PAmountIn                                    CSE031
     C                   MOVE      BS08          PAmountIn                                    CSE031
     C                   EVAL      PNDCP = 7                                                  CSE031
     C                   EXSR      SRFmtAmt                                                   CSE031
     C                   MOVE      PAmountOutP   DDBS08                                       CSE031
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   MOVE      PAmountOutD   DDBS08                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Spread Indicator 8                                                                   CSE031
     C                   EVAL      DDSI08 = SI08                                              CSE031
      *                                                                                       CSE031
      *                                                                                       CSE031
      ** Applicable Date 9                                                                    CSE031
     C                   IF        AD09 <> *ZEROS                                             CSE031
     C                   MOVE      AD09          DDAD09                                       CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Base Rate Code 9                                                                     CSE031
     C                   IF        BR09 <> *ZEROS                                             CSE031
     C                   MOVE      BR09          DDBR09                                       CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Spread Rate 9                                                                        CSE031
     C                   IF        BS09 <> *ZEROS                                             CSE031
     C                   Z-ADD     *ZERO         PAmountIn                                    CSE031
     C                   MOVE      BS09          PAmountIn                                    CSE031
     C                   EVAL      PNDCP = 7                                                  CSE031
     C                   EXSR      SRFmtAmt                                                   CSE031
     C                   MOVE      PAmountOutP   DDBS09                                       CSE031
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   MOVE      PAmountOutD   DDBS09                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Spread Indicator 9                                                                   CSE031
     C                   EVAL      DDSI09 = SI09                                              CSE031
      *                                                                                       CSE031
      *                                                                                       CSE031
      ** Applicable Date 10                                                                   CSE031
     C                   IF        AD10 <> *ZEROS                                             CSE031
     C                   MOVE      AD10          DDAD10                                       CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Base Rate Code 10                                                                    CSE031
     C                   IF        BR10 <> *ZEROS                                             CSE031
     C                   MOVE      BR10          DDBR10                                       CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Spread Rate 10                                                                       CSE031
     C                   IF        BS10 <> *ZEROS                                             CSE031
     C                   Z-ADD     *ZERO         PAmountIn                                    CSE031
     C                   MOVE      BS10          PAmountIn                                    CSE031
     C                   EVAL      PNDCP = 7                                                  CSE031
     C                   EXSR      SRFmtAmt                                                   CSE031
     C                   MOVE      PAmountOutP   DDBS10                                       CSE031
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   MOVE      PAmountOutD   DDBS10                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Spread Indicator 10                                                                  CSE031
     C                   EVAL      DDSI10 = SI10                                              CSE031
      *                                                                                       CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
      *                                                                                       CRE073
      ** CRE073 Related Fields                                                                CRE073
      *                                                                                       CRE073
     C                   IF        CRE073 = 'Y' AND                                           CRE073
     C                             (PPROT = '3' OR PPROT = '8')                               CRE073
      *                                                                                       CRE073
      ** Rounding Method 1                                                                    CRE073
      *                                                                                       CRE073
     C                   EVAL      DDRDM01 = RDM01                                            CRE073
      *                                                                                       CRE073
      ** Rounding Fraction/ Decimal 1                                                         CRE073
      *                                                                                       CRE073
     C                   EVAL      DDRDF01 = RDF01                                            CRE073
      *                                                                                       CRE073
      ** Contractual Spread 1                                                                 CRE073
      *                                                                                       CRE073
     C                   IF        CNP01 <> *ZEROS                                            CRE073
     C                   Z-ADD     *ZERO         PAmountIn                                    CRE073
     C                   MOVE      CNP01         PAmountIn                                    CRE073
     C                   EVAL      PNDCP = 7                                                  CRE073
     C                   EXSR      SRFmtAmt                                                   CRE073
     C                   MOVE      PAmountOutP   DDCNP01                                      CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
      ** Contractual Spread Indicator 1                                                       CRE073
      *                                                                                       CRE073
     C                   EVAL      DDCNG01 = CNG01                                            CRE073
      *                                                                                       CRE073
      ** Rounding Method 2                                                                    CRE073
      *                                                                                       CRE073
     C                   EVAL      DDRDM02 = RDM02                                            CRE073
      *                                                                                       CRE073
      ** Rounding Fraction/ Decimal 2                                                         CRE073
      *                                                                                       CRE073
     C                   EVAL      DDRDF02 = RDF02                                            CRE073
      *                                                                                       CRE073
      ** Contractual Spread 2                                                                 CRE073
      *                                                                                       CRE073
     C                   IF        CNP02 <> *ZEROS                                            CRE073
     C                   Z-ADD     *ZERO         PAmountIn                                    CRE073
     C                   MOVE      CNP02         PAmountIn                                    CRE073
     C                   EVAL      PNDCP = 7                                                  CRE073
     C                   EXSR      SRFmtAmt                                                   CRE073
     C                   MOVE      PAmountOutP   DDCNP02                                      CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
      ** Contractual Spread Indicator 2                                                       CRE073
      *                                                                                       CRE073
     C                   EVAL      DDCNG02 = CNG02                                            CRE073
      *                                                                                       CRE073
      ** Rounding Method 3                                                                    CRE073
      *                                                                                       CRE073
     C                   EVAL      DDRDM03 = RDM03                                            CRE073
      *                                                                                       CRE073
      ** Rounding Fraction/ Decimal 3                                                         CRE073
      *                                                                                       CRE073
     C                   EVAL      DDRDF03 = RDF03                                            CRE073
      *                                                                                       CRE073
      ** Contractual Spread 3                                                                 CRE073
      *                                                                                       CRE073
     C                   IF        CNP03 <> *ZEROS                                            CRE073
     C                   Z-ADD     *ZERO         PAmountIn                                    CRE073
     C                   MOVE      CNP03         PAmountIn                                    CRE073
     C                   EVAL      PNDCP = 7                                                  CRE073
     C                   EXSR      SRFmtAmt                                                   CRE073
     C                   MOVE      PAmountOutP   DDCNP03                                      CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
      ** Contractual Spread Indicator 3                                                       CRE073
      *                                                                                       CRE073
     C                   EVAL      DDCNG03 = CNG03                                            CRE073
      *                                                                                       CRE073
      ** Rounding Method 4                                                                    CRE073
      *                                                                                       CRE073
     C                   EVAL      DDRDM04 = RDM04                                            CRE073
      *                                                                                       CRE073
      ** Rounding Fraction/ Decimal 4                                                         CRE073
      *                                                                                       CRE073
     C                   EVAL      DDRDF04 = RDF04                                            CRE073
      *                                                                                       CRE073
      ** Contractual Spread 4                                                                 CRE073
      *                                                                                       CRE073
     C                   IF        CNP04 <> *ZEROS                                            CRE073
     C                   Z-ADD     *ZERO         PAmountIn                                    CRE073
     C                   MOVE      CNP04         PAmountIn                                    CRE073
     C                   EVAL      PNDCP = 7                                                  CRE073
     C                   EXSR      SRFmtAmt                                                   CRE073
     C                   MOVE      PAmountOutP   DDCNP04                                      CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
      ** Contractual Spread Indicator 4                                                       CRE073
      *                                                                                       CRE073
     C                   EVAL      DDCNG04 = CNG04                                            CRE073
      *                                                                                       CRE073
      ** Rounding Method 5                                                                    CRE073
      *                                                                                       CRE073
     C                   EVAL      DDRDM05 = RDM05                                            CRE073
      *                                                                                       CRE073
      ** Rounding Fraction/ Decimal 5                                                         CRE073
      *                                                                                       CRE073
     C                   EVAL      DDRDF05 = RDF05                                            CRE073
      *                                                                                       CRE073
      ** Contractual Spread 5                                                                 CRE073
      *                                                                                       CRE073
     C                   IF        CNP05 <> *ZEROS                                            CRE073
     C                   Z-ADD     *ZERO         PAmountIn                                    CRE073
     C                   MOVE      CNP05         PAmountIn                                    CRE073
     C                   EVAL      PNDCP = 7                                                  CRE073
     C                   EXSR      SRFmtAmt                                                   CRE073
     C                   MOVE      PAmountOutP   DDCNP05                                      CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
      ** Contractual Spread Indicator 5                                                       CRE073
      *                                                                                       CRE073
     C                   EVAL      DDCNG05 = CNG05                                            CRE073
      *                                                                                       CRE073
      ** Rounding Method 6                                                                    CRE073
      *                                                                                       CRE073
     C                   EVAL      DDRDM06 = RDM06                                            CRE073
      *                                                                                       CRE073
      ** Rounding Fraction/ Decimal 6                                                         CRE073
      *                                                                                       CRE073
     C                   EVAL      DDRDF06 = RDF06                                            CRE073
      *                                                                                       CRE073
      ** Contractual Spread 6                                                                 CRE073
      *                                                                                       CRE073
     C                   IF        CNP06 <> *ZEROS                                            CRE073
     C                   Z-ADD     *ZERO         PAmountIn                                    CRE073
     C                   MOVE      CNP06         PAmountIn                                    CRE073
     C                   EVAL      PNDCP = 7                                                  CRE073
     C                   EXSR      SRFmtAmt                                                   CRE073
     C                   MOVE      PAmountOutP   DDCNP06                                      CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
      ** Contractual Spread Indicator 6                                                       CRE073
      *                                                                                       CRE073
     C                   EVAL      DDCNG06 = CNG06                                            CRE073
      *                                                                                       CRE073
      ** Rounding Method 7                                                                    CRE073
      *                                                                                       CRE073
     C                   EVAL      DDRDM07 = RDM07                                            CRE073
      *                                                                                       CRE073
      ** Rounding Fraction/ Decimal 7                                                         CRE073
      *                                                                                       CRE073
     C                   EVAL      DDRDF07 = RDF07                                            CRE073
      *                                                                                       CRE073
      ** Contractual Spread 7                                                                 CRE073
      *                                                                                       CRE073
     C                   IF        CNP07 <> *ZEROS                                            CRE073
     C                   Z-ADD     *ZERO         PAmountIn                                    CRE073
     C                   MOVE      CNP07         PAmountIn                                    CRE073
     C                   EVAL      PNDCP = 7                                                  CRE073
     C                   EXSR      SRFmtAmt                                                   CRE073
     C                   MOVE      PAmountOutP   DDCNP07                                      CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
      ** Contractual Spread Indicator 7                                                       CRE073
      *                                                                                       CRE073
     C                   EVAL      DDCNG07 = CNG07                                            CRE073
      *                                                                                       CRE073
      ** Rounding Method 8                                                                    CRE073
      *                                                                                       CRE073
     C                   EVAL      DDRDM08 = RDM08                                            CRE073
      *                                                                                       CRE073
      ** Rounding Fraction/ Decimal 8                                                         CRE073
      *                                                                                       CRE073
     C                   EVAL      DDRDF08 = RDF08                                            CRE073
      *                                                                                       CRE073
      ** Contractual Spread 8                                                                 CRE073
      *                                                                                       CRE073
     C                   IF        CNP08 <> *ZEROS                                            CRE073
     C                   Z-ADD     *ZERO         PAmountIn                                    CRE073
     C                   MOVE      CNP08         PAmountIn                                    CRE073
     C                   EVAL      PNDCP = 7                                                  CRE073
     C                   EXSR      SRFmtAmt                                                   CRE073
     C                   MOVE      PAmountOutP   DDCNP08                                      CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
      ** Contractual Spread Indicator 8                                                       CRE073
      *                                                                                       CRE073
     C                   EVAL      DDCNG08 = CNG08                                            CRE073
      *                                                                                       CRE073
      ** Rounding Method 9                                                                    CRE073
      *                                                                                       CRE073
     C                   EVAL      DDRDM09 = RDM09                                            CRE073
      *                                                                                       CRE073
      ** Rounding Fraction/ Decimal 9                                                         CRE073
      *                                                                                       CRE073
     C                   EVAL      DDRDF09 = RDF09                                            CRE073
      *                                                                                       CRE073
      ** Contractual Spread 9                                                                 CRE073
      *                                                                                       CRE073
     C                   IF        CNP09 <> *ZEROS                                            CRE073
     C                   Z-ADD     *ZERO         PAmountIn                                    CRE073
     C                   MOVE      CNP09         PAmountIn                                    CRE073
     C                   EVAL      PNDCP = 7                                                  CRE073
     C                   EXSR      SRFmtAmt                                                   CRE073
     C                   MOVE      PAmountOutP   DDCNP09                                      CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
      ** Contractual Spread Indicator 9                                                       CRE073
      *                                                                                       CRE073
     C                   EVAL      DDCNG09 = CNG09                                            CRE073
      *                                                                                       CRE073
      ** Rounding Method 10                                                                   CRE073
      *                                                                                       CRE073
     C                   EVAL      DDRDM10 = RDM10                                            CRE073
      *                                                                                       CRE073
      ** Rounding Fraction/ Decimal 10                                                        CRE073
      *                                                                                       CRE073
     C                   EVAL      DDRDF10 = RDF10                                            CRE073
      *                                                                                       CRE073
      ** Contractual Spread 10                                                                CRE073
      *                                                                                       CRE073
     C                   IF        CNP10 <> *ZEROS                                            CRE073
     C                   Z-ADD     *ZERO         PAmountIn                                    CRE073
     C                   MOVE      CNP10         PAmountIn                                    CRE073
     C                   EVAL      PNDCP = 7                                                  CRE073
     C                   EXSR      SRFmtAmt                                                   CRE073
     C                   MOVE      PAmountOutP   DDCNP10                                      CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
      ** Contractual Spread Indicator 10                                                      CRE073
      *                                                                                       CRE073
     C                   EVAL      DDCNG10 = CNG10                                            CRE073
      *                                                                                       CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtAm1 - Format amount for display using ZSEDITF           *
      *                                                               *
      *****************************************************************
 
     C     SRFmtAm1      BEGSR
 
     C                   CALLB     'ZSEDITF'
     C                   PARM                    ZFld15
     C                   PARM                    ZDecs
     C                   PARM      'L'           ZECode
     C                   PARM      *BLANKS       ZEChar
     C                   PARM      *BLANKS       ZOut21
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtAmt - Format amount for display                         *
      *                                                               *
      *****************************************************************
 
     C     SRFmtAmt      BEGSR
 
     C                   CALLB     'ZA0921'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    PAmountIn
     C                   PARM                    PNDCP
     C                   PARM      '.'           PDCSP
     C                   PARM      *BLANK        PAmountOutP
     C                   PARM      *BLANK        PAmountOutD
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtDat - Format date for display                           *
      *                                                               *
      *****************************************************************
 
     C     SRFmtDat      BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDateIn
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PDateOut
     C                   PARM      *BLANKS       PADateOut
 
     C                   ENDSR
 
      *****************************************************************                       CSE065
      /EJECT                                                                                  CSE065
      *****************************************************************                       CSE065
      *                                                               *                       CSE065
      *  SRFmtDat2 - Format date for display                          *                       CSE065
      *                                                               *                       CSE065
      *****************************************************************                       CSE065
                                                                                              CSE065
     C     SRFmtDat2     BEGSR                                                                CSE065
                                                                                              CSE065
     C                   CALLB     'ZA0140M'                                                  CSE065
     C                   PARM      *BLANK        PRtn                                         CSE065
     C                   PARM                    PDayN                                        CSE065
     C                   PARM      BJDFIN        PDFmt                                        CSE065
     C                   PARM      *ZERO         PDate                                        CSE065
     C                   PARM      *BLANK        PDatA                                        CSE065
     C                   PARM      *ZERO         PDat8                                        CSE065
     C                   PARM      *ZERO         PDat8F                                       CSE065
                                                                                              CSE065
     C                   ENDSR                                                                CSE065
                                                                                              CSE065
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAOCurr - Check currency details                            *
      *                                                               *
      *****************************************************************
 
     C     SRAOCurr      BEGSR
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCurr
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBKey = PCurr
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   Z-ADD     1             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAOCust - Access customer details                           *
      *                                                               *
      *****************************************************************
 
     C     SRAOCust      BEGSR
 
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PKeyC
     C                   PARM      *BLANKS       PKySt
     C     SDCUST        PARM      SDCUST        DSLDY
 
     C                   IF        PRtcd <> *BLANKS
     C                             and RECI <> 'M'                                            216368
     C                   EVAL      DBKey = PKeyC
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   Z-ADD     2             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrSec - Clear security details                            *
      *                                                               *
      *****************************************************************
 
     C     SRClrSec      BEGSR
 
     C                   CLEAR                   CRSEFilFmt
     C                   EVAL      CDArr = *ZEROS
     C                   Z-ADD     0             NMDP
     C                   Z-ADD     0             SIDY
     C                   Z-ADD     0             SLCA
     C**********         Z-ADD     0             ISSR                                         CSD027
     C                   EVAL      ISSR = *BLANKS                                             CSD027
     C                   Z-ADD     0             SDNM
     C                   Z-ADD     0             IDIV
     C                   Z-ADD     0             NEXD
     C                   Z-ADD     0             LCPN
     C                   Z-ADD     0             CPNR
     C                   Z-ADD     0             BASC
     C                   Z-ADD     0             BASS
     C                   Z-ADD     0             MCPN
     C                   Z-ADD     0             MATY
     C**********         Z-ADD     0             RSKC                                         CSD027
     C                   EVAL      RSKC = *BLANKS                                             CSD027
     C                   Z-ADD     0             IADJ
     C                   Z-ADD     0             ITLD
     C                   Z-ADD     0             FCPN
     C                   Z-ADD     0             NCHD
     C                   Z-ADD     0             SINP
     C                   Z-ADD     0             SFPP
     C                   Z-ADD     0             ISSD
     C                   Z-ADD     0             ISSP
     C**********         Z-ADD     0             LMGR                                         CSD027
     C                   EVAL      LMGR = *BLANKS                                             CSD027
     C                   Z-ADD     0             ISSA
     C                   Z-ADD     0             TOTU
     C                   Z-ADD     0             ALRQ
     C                   Z-ADD     0             ALRC
     C                   Z-ADD     0             MGFD
     C                   Z-ADD     0             MGRC
     C                   Z-ADD     0             UNFD
     C                   Z-ADD     0             UNFR
     C                   Z-ADD     0             DCOM
     C                   Z-ADD     0             MKPR
     C                   Z-ADD     0             ORED
     C                   Z-ADD     0             NDVD
     C                   Z-ADD     0             SEXR
     C                   Z-ADD     0             LPRU
     C                   Z-ADD     0             CPDP
     C                   Z-ADD     0             TPHD
     C                   Z-ADD     0             SCPP
     C                   Z-ADD     0             SCPD
     C                   Z-ADD     0             LCD
     C                   Z-ADD     0             TNLU
     C                   Z-ADD     0             CMFQ
     C                   Z-ADD     0             CFCT
     C                   Z-ADD     0             SRBK
     C**********         Z-ADD     0             PPAG                                         CSD027
     C**********         Z-ADD     0             GUAR                                         CSD027
     C                   EVAL      PPAG = *BLANKS                                             CSD027
     C                   EVAL      GUAR = *BLANKS                                             CSD027
     C                   Z-ADD     0             WEIC
     C                   Z-ADD     0             NDEC                                         CSE037
     C                   EVAL      MKPN = *ZERO                                               CAS006
     C                   EVAL      MCRK = *ZERO                                               CAS006
     C                   EVAL      MLQP = *ZERO                                               CAS006
 
     C                   EVAL      LOIC = *BLANKS                                             CER020
      *                                                                                       CRE073
      ** CRE073 related fields                                                                CRE073
      *                                                                                       CRE073
     C                   EVAL      CNSP  = *ZERO                                              CRE073
     C                   EVAL      CNSG  = *BLANKS                                            CRE073
     C                   EVAL      RDMT  = *BLANKS                                            CRE073
     C                   EVAL      RDFD  = *BLANKS                                            CRE073
     C                   EVAL      CNP01 = *ZERO                                              CRE073
     C                   EVAL      CNG01 = *BLANKS                                            CRE073
     C                   EVAL      RDM01 = *BLANKS                                            CRE073
     C                   EVAL      RDF01 = *BLANKS                                            CRE073
     C                   EVAL      CNP02 = *ZERO                                              CRE073
     C                   EVAL      CNG02 = *BLANKS                                            CRE073
     C                   EVAL      RDM02 = *BLANKS                                            CRE073
     C                   EVAL      RDF02 = *BLANKS                                            CRE073
     C                   EVAL      CNP03 = *ZERO                                              CRE073
     C                   EVAL      CNG03 = *BLANKS                                            CRE073
     C                   EVAL      RDM03 = *BLANKS                                            CRE073
     C                   EVAL      RDF03 = *BLANKS                                            CRE073
     C                   EVAL      CNP04 = *ZERO                                              CRE073
     C                   EVAL      CNG04 = *BLANKS                                            CRE073
     C                   EVAL      RDM04 = *BLANKS                                            CRE073
     C                   EVAL      RDF04 = *BLANKS                                            CRE073
     C                   EVAL      CNP05 = *ZERO                                              CRE073
     C                   EVAL      CNG05 = *BLANKS                                            CRE073
     C                   EVAL      RDM05 = *BLANKS                                            CRE073
     C                   EVAL      RDF05 = *BLANKS                                            CRE073
     C                   EVAL      CNP06 = *ZERO                                              CRE073
     C                   EVAL      CNG06 = *BLANKS                                            CRE073
     C                   EVAL      RDM06 = *BLANKS                                            CRE073
     C                   EVAL      RDF06 = *BLANKS                                            CRE073
     C                   EVAL      CNP07 = *ZERO                                              CRE073
     C                   EVAL      CNG07 = *BLANKS                                            CRE073
     C                   EVAL      RDM07 = *BLANKS                                            CRE073
     C                   EVAL      RDF07 = *BLANKS                                            CRE073
     C                   EVAL      CNP08 = *ZERO                                              CRE073
     C                   EVAL      CNG08 = *BLANKS                                            CRE073
     C                   EVAL      RDM08 = *BLANKS                                            CRE073
     C                   EVAL      RDF08 = *BLANKS                                            CRE073
     C                   EVAL      CNP09 = *ZERO                                              CRE073
     C                   EVAL      CNG09 = *BLANKS                                            CRE073
     C                   EVAL      RDM09 = *BLANKS                                            CRE073
     C                   EVAL      RDF09 = *BLANKS                                            CRE073
     C                   EVAL      CNP10 = *ZERO                                              CRE073
     C                   EVAL      CNG10 = *BLANKS                                            CRE073
     C                   EVAL      RDM10 = *BLANKS                                            CRE073
     C                   EVAL      RDF10 = *BLANKS                                            CRE073
                                                                                              CRE073
     C                   ENDSR
 
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
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Investment processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Action Code
     C                   PARM                    PDDACTN
      *
      ** Passed other information from link proccessing
     C                   PARM                    POthInf
      *
      ** Process old security details indicator
     C                   PARM                    PPOldSecDtl
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** SDBANK - midas run day number
     C                   PARM                    BJRDNB
      *
      ** SDMMOD - Interest risk management
     C                   PARM                    BGRKMG
      *
      ** SDMMOD - Midas-Plato interface
     C                   PARM                    BGN2ST
      *
      ** SDMMOD - Private banking
     C                   PARM                    BGN4ST
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU Securities decimals on nominals
     C                   PARM                    CEU018
      *
      ** Effect of holidays on FRN coupon dates
     C                   PARM                    CSE005
      *
      ** MT5xx message generation
     C                   PARM                    S01401
      *                                                                         CSE023
      ** US Withholding tax treaty                                              CSE023
     C                   PARM                    CSE023                         CSE023
      *                                                                         CSD006
      ** Market Data Feed                                                       CSD006
     C                   PARM                    CSD006                         CSD006
      *                                                                         CAP060
      ** Midas APIs Sec Prices                                                  CAP060
     C                   PARM                    CAP060                         CAP060
      *                                                                         CSE031
      ** Coupon Fixing for Floating Rate Notes.                                 CSE031
     C                   PARM                    CSE031                         CSE031
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
      *                                                                         CSE037
      ** Countervalue rounding                                                  CSE037
     C                   PARM                    CSE037                         CSE037
                                                                                              CGL014
      ** Collaterals Processing                                                               CGL014
                                                                                              CGL014
     C                   PARM                    CGL014                                       CGL014
                                                                                              CSE071
      ** Multiple Holidays                                                                    CSE071
     C                   PARM                    CSE071                                       CSE071
                                                                                              CGL032
      ** Taxation on Savings Income                                                           CGL032
                                                                                              CGL032
     C                   PARM                    CGL032                                       CGL032
      *
      ** OUTPUT
      ** ======
      *
      ** Securities screen 1 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE1ScnFmt
      *
      ** Securities screen 2 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE2ScnFmt
      *
      ** Securities screen 3 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE3ScnFmt
      *                                                                                       CSE031
      ** Securities screen 4 details retrieved from file                                      CSE031
      ** - screen format                                                                      CSE031
     C                   PARM                    CrSE4ScnFmt                                  CSE031
                                                                                              CAS006
      ** Securities Screen 5 Details Retrieved From File                                      CAS006
      ** - Screen Format                                                                      CAS006
     C                   PARM                    CrSE5ScnFmt                                  CAS006
                                                                                              CSE071
      ** Securities Screen 6 Details Retrieved From File                                      CSE071
      ** - Screen Format                                                                      CSE071
     C                   PARM                    CrSE6ScnFmt                                  CSE071
      *
      ** Last Coupon Date
     C                   PARM                    PLCPN
      *
      ** Next Coupon Date
     C                   PARM                    PNCD
                                                                                              CSC011
      ** Linked Maintenance Flag                                                              CSC011
                                                                                              CSC011
     C                   PARM                    PParmLink                                    CSC011
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *Blanks       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSSDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   ELSE                                                                 CSC011
     C                   IF        PRTCD <> '*NRF   '                                         CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBKEY  = 'CSC011'                                          CSC011
     C                   EVAL      DBASE  = 3                                                 CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
      ** Check if CSE065 is installed                                                         CSE065
     C                   EVAL      CSE065 = 'N'                                               CSE065
     C                   CALLB     'AOSARDR0'                                                 CSE065
     C                   PARM      *Blanks       PRTCD                                        CSE065
     C                   PARM      '*VERIFY'     POPTN                                        CSE065
     C                   PARM      'CSE065'      PSARD                                        CSE065
     C     SCSARD        PARM      SCSARD        DSSDY                                        CSE065
                                                                                              CSE065
     C                   IF        PRTCD = *Blanks                                            CSE065
     C                   EVAL      CSE065 = 'Y'                                               CSE065
     C                   ELSE                                                                 CSE065
     C                   IF        PRTCD <> '*NRF   '                                         CSE065
     C     *LOCK         IN        LDA                                                        CSE065
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSE065
     C                   EVAL      DBKEY  = 'CSE065'                                          CSE065
     C                   EVAL      DBASE  = 4                                                 CSE065
     C                   OUT       LDA                                                        CSE065
     C                   EXSR      *PSSR                                                      CSE065
     C                   ENDIF                                                                CSE065
     C                   ENDIF                                                                CSE065
      *                                                                                       CSE075
      ** Check if CSE075 is installed.                                                        CSE075
      *                                                                                       CSE075
     C                   EVAL      CSE075 = 'N'                                               CSE075
     C                   CALLB     'AOSARDR0'                                                 CSE075
     C                   PARM      *Blanks       PRTCD                                        CSE075
     C                   PARM      '*VERIFY'     POPTN                                        CSE075
     C                   PARM      'CSE075'      PSARD                                        CSE075
     C     SCSARD        PARM      SCSARD        DSSDY                                        CSE075
                                                                                              CSE075
     C                   IF        PRTCD = *Blanks                                            CSE075
     C                   EVAL      CSE075 = 'Y'                                               CSE075
     C                   ELSE                                                                 CSE075
     C                   IF        PRTCD <> '*NRF   '                                         CSE075
     C     *LOCK         IN        LDA                                                        CSE075
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSE075
     C                   EVAL      DBKEY  = 'CSE075'                                          CSE075
     C                   EVAL      DBASE  = 5                                                 CSE075
     C                   OUT       LDA                                                        CSE075
     C                   EXSR      *PSSR                                                      CSE075
     C                   ENDIF                                                                CSE075
     C                   ENDIF                                                                CSE075
      *                                                                                       CRE073
      ** Check if CRE073 is installed.                                                        CRE073
      *                                                                                       CRE073
     C                   EVAL      CRE073 = 'N'                                               CRE073
     C                   CALLB     'AOSARDR0'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM      '*VERIFY'     POPTN                                        CRE073
     C                   PARM      'CRE073'      PSARD                                        CRE073
     C     SCSARD        PARM      SCSARD        DSSDY                                        CRE073
                                                                                              CRE073
     C                   IF        PRTCD = *BLANKS                                            CRE073
     C                   EVAL      CRE073 = 'Y'                                               CRE073
     C                   ELSE                                                                 CRE073
     C                   IF        PRTCD <> '*NRF   '                                         CRE073
     C     *LOCK         IN        LDA                                                        CRE073
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE073
     C                   EVAL      DBKEY  = 'CRE073'                                          CRE073
     C                   EVAL      DBASE  = 6                                                 CRE073
     C                   OUT       LDA                                                        CRE073
     C                   EXSR      *PSSR                                                      CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CRE073
      *
     C/COPY WNCPYSRC,DUG502_002                                                               DUG502
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
