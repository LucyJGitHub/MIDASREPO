     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Incoming payments validation controller 1')   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPAY1VL - Incoming Payments Validation Controller 1        *
      *                                                               *
      *  Function: This module validates Incoming Payments Level 1    *
      *            fields for input into the Midas database.          *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYCTL                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR900506           Date 04Nov14               *
      *  Prev Amend No. CFT157             Date 29Aug14               *
      *                 AR798055           Date 19Aug14               *
      *                 MD025111           Date 24Feb14               *
      *                 MD023051           Date 25Oct13               *
      *                 CSW213             Date 03Jun13               *
      *                 AR1079259          Date 21Jan13               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 250600             Date 30Sep07               *
      *                 247142             Date 01Jun07               *
      *                 CRE026             Date 24May06               *
      *                 BUG12952           Date 21Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12583           Date 10Nov06               *
      *                 CFT032             Date 11Sep06               *
      *                 BUG12278           Date 24Oct06               *
      *                 CSD031             Date 10Apr06               *
      *                 241002             Date 18Jul06               *
      *                 240689             Date 13Jul06               *
      *                 CDL049             Date 06Jul06               *
      *                 220180             Date 06Jun06               *
      *                 BUG6864            Date 14Dec05               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG7101            Date 06Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3644            Date 12Jul04               *
      *                 CFT115             Date 01Jul04               *
      *                 BUG3281            Date 17Jun04               *
      *                 CGL014             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 TDA006             Date 16Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001             Date 09Dec03               *
      *                 CAP084             Date 25Aug03               *
      *                 CRE008             Date 19Feb02               *
      *                 213026             Date 09Dec02               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4.01.02 ----------------------------------------*
      *                 207211             Date 16Jul02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 202322             Date 30Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR900506 - Add/Deduct defaulting not occurring through API   *
      *             (Child: AR900507)                                 *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *           (Recompile)                                         *
      *  AR798055 - Funds Checking needed during Insert.              *
      *             (Child: AR798056)                                 *
      *  MD025111 - Incoming payment without charges is not allowed   *
      *             if the account is blocked for DR                  *
      *  MD023051 - System does not default Transfer Comission for    *
      *             IPAY if Senders Charges are not blank             *
      *  CSW213 - SWIFT Changes 2013 (Recompile)                      *
      *  AR1079259 - Projected fee amount is wrong                    *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  250600 - Fix to CFT032                                       *
      *  247142 - Funds Transfer allows payments over Blocked &       *
      *           Reffered Accounts without warning.                  *
      *           Apply fixes 232151 and 210654.  These fixes were    *
      *           applied and annotated by 240689.                    *
      *  232151 - Display warning messages.                           *
      *  210654 - Check status of account.                            *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  BUG12952 - Parameter mismatch corrupting the payment sub-    *
      *             type to become blank                              *
      *  BUG12583 - Error encountered when amending a record          *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  BUG12278 - A serious Midas error occurs when inserting new   *
      *             incoming payment transaction                      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  241002 - Cannot amend booking branch. Applied 227458.        *
      *           Fix already catered by fix 220180.                  *
      *  227458 - Allow booking branch to be amendable. Applied part  *
      *           of 219713.                                          *
      *  240689 - Applied fix 210654 plus additional changes of       *
      *           232151.                                             *
      *  CDL049 - Addition of a Reference Rate field                  *
      *  220180 - Validate booking branch.                            *
      *  BUG6864 - If user enters charges do not overwrite with dfts  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG7101 - DB error in AOSPOSU0 due to blank INTRIT. Remove   *
      *            fix 202322 and put changes in FTIPAYSIN instead.   *
      *            Applied core fix 216842.                           *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  CFT115 - Core changes for GBO015.                            *
      *         - Incoming Payments Beneficiary Validation            *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:FTIPY1V002,FTIPY1V038,FTIPY1V039,*
      *                              FTIPY1V001,                      *
      *           Core hooks added:FTIPA1VC24,FTIPA1VX01              *
      *  BUG3281 - Discrepancies on sources                           *
      *  CGL014 - Collaterals Processing                              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  TDA006 - Correct 10-digit full account processing.           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGP001 - Recompiled due to change in FTV2OPYPD               *
      *  CAP084 - Receiver's Charges Remitted not saved during IP.    *
      *           Only condition clearing of NwIp2Filfmt if CFT009    *
      *           CFT003 and CFT014 are off.                          *
      *  CRE008 - Cash Management                                     *
      *  213026 - Populate NDCY field properly                        *
      *  207211 - warning messages are not detected                   *
      *  202322 - FT - FTIPAYSIN decimal data error in FTVITCHG       *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** SWIFT ISO Country Codes File                                           CFT014
     FMEISOCL1  IF   E           K DISK    INFSR(*PSSR)                         CFT014
      *                                                                         CFT014
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,FTIPY1V001
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
      *                                                                                     AR798055
      ** String for System Values Array                                                     AR798055
      *                                                                                     AR798055
     D SysValOne       C                   CONST('FundsCheckOnInsert')                      AR798055
     D SysValTwo       C                   CONST('FundsCheckWarngOnly')                     AR798055
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     D NwIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)
      *
      ** Incoming Payments Lvl 1 Scrn details retrieved from file
      ** - screen format
     D CrIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)
     D                                     PREFIX(O)
      *
      ** Incoming Payments extra data
     D PExtData      E DS                  EXTNAME(FTIPEXPD)
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     D FTEIPY1       E DS                  EXTNAME(FTEIPY1PD)
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *                                                                         CFT014
      ** Incoming Payments (additional details) for file update                 CFT014
     D NwIP2FilFmt   E DS                  EXTNAME(FTVIPY2PD)                   CFT014
      *                                                                         CFT014
      ** Incoming Payments Lvl 1 Scrn 1/2 details from Incoming trans.          CFT014
     D NwIP1aScnFmt  E DS                  EXTNAME(FTIPY1APD)                   CFT014
      *                                                                         CFT009
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming trans.            CFT009
      ** - screen format                                                        CFT009
     D NWIP5SCNFMT   E DS                  EXTNAME(FTIPY5PD)                    CFT009
     D NWIP5SCNFMTA  E DS                  EXTNAME(FTIPY5PD)                                 BUG6864
     D                                     PREFIX(W#)                                        BUG6864
      *                                                                                       220180
      ** Incoming Payments retrieved from file - file format                                  220180
     D CrIPFilFmt    E DS                  EXTNAME(INPAYDD)                                   220180
                                                                                CFT009
      ** Valid Incoming Payments Extension File (default)                       CFT009
     D DEFVALIDX     E DS                  EXTNAME(FTVIPY2PD)                   CFT009
     D                                     PREFIX(D#)                           CFT009
                                                                                CFT009
      * Valid Payments layout (default)                                         CFT009
     D DEFVALID      E DS                  EXTNAME(FTVIPAYPD)                   CFT009
     D                                     PREFIX(D#)                           CFT009
                                                                                              CGL014
      ** GL006000 parameter account details                                                   CGL014
     D WACCT           DS            24                                                       CGL014
     D   PACNUM                1      6                                                       CGL014
     D   PACCY                 7      9                                                       CGL014
     D   PAACOD               10     19                                                       CGL014
     D   PAACSQ               20     21                                                       CGL014
     D   PABRCA               22     24                                                       CGL014
     D   W11TO18              11     18                                                       CGL014
      *
      ** DS for IBANs full account
     D PIBANAcc        DS
     D**IBCNUM**               1      6  0                                                    CSD027
     D  IBCNUM                 1      6                                                       CSD027
     D  IBCCY                  7      9
     D***IBACOD**              10     13  0                                                   CGL029
     D***IBACSQ**              14     15  0                                                   CGL029
     D***IBBRCA**              16     18                                                      CGL029
     D  IBACOD                10     19  0                                                    CGL029
     D  IBACSQ                20     21  0                                                    CGL029
     D  IBBRCA                22     24                                                       CGL029
      *                                                                         CFT014
      ** Externally described DS for Customer details                           CFT014
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    CFT014
      *                                                                         CFT014
      ** Externally described DS for Branch details                             CFT014
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                    CFT014
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     CGL029
      *                                                                         CFT014
      ** Externally described DS for Location codes details                     CFT014
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                    CFT014
      *                                                                         CFT014
      ** Externally described DS for Country codes details                      CFT014
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)                    CFT014
      *                                                                         CFT014
     D/COPY WNCPYSRC,FTIPA1VD01
      ** DS for Access Objects - short data structure                           CFT014
     D DSFDY         E DS                  EXTNAME(DSFDY)                       CFT014
      *                                                                         CFT014
      ** DS for Access Objects - long data structure                            CFT014
     D DSSDY         E DS                  EXTNAME(DSSDY)                       CFT014
                                                                                              CAP084
     D/COPY WNCPYSRC,FTH00272
      ** Externally described DS for SAR details                                              CAP084
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAP084
     D SLCD          E                     EXTFLD(LCD)                                        CAP084
      *                                                                                     AR798055
      ** For IBAN Customer Number calculations                                              AR798055
      *                                                                                     AR798055
     D P@ACCN        E DS                  EXTNAME(ACCNTAB) PREFIX(IC)                      AR798055
     D/COPY WNCPYSRC,FTH00236
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Index for arrays of warning error message ids, etc.
     D WIDx            S              3P 0
      *
      ** Index for update of error arrays
     D Ix              S              3  0
      *
      ** Response Mode
     D PResponse       S              1A
      *                                                                         CFT009
      ** Input Charge Currency                                                  CFT009
     D PICCY           S              3                                         CFT009
      *                                                                         CFT009
      ** Output Charge Currency                                                 CFT009
     D POCCY           S              3                                         CFT009
      *                                                                         CFT009
      ** Input Charge Currency No. of Decimal Places                            CFT009
     D PINBDP          S              1  0                                      CFT009
      *                                                                         CFT009
      ** Output Charge Currency No. of Decimal Places                           CFT009
     D PONBDP          S              1  0                                      CFT009
                                                                                              CGL029
      ** Fields redefined by CGL029                                                           CGL029
     D PPYFLDS         S             24A                                                      CGL029
     D PRCCDS          S             24A                                                      CGL029
                                                                                              CGL014
     D CGL014          S              1                                                       CGL014
     D PTAMNT          S             15  0                                                    CGL014
     D PTCCY           S              3                                                       CGL014
     D PAACNO          S             10  0                                                    CGL014
     D PRTCD           S              7                                                       CGL014
     D Wx              S              2  0                                                    CGL014
     D Wwx             S              2  0                                                    CGL014
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,FTIPY1V002
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
      /COPY WNCPYSRC,FTIPY1V003
      *                                                                                       220180
      ** Perform Booking Branch validation if multibranching.                                 220180
      *                                                                                       220180
     C                   IF        BGMBIN = 'Y'                                               220180
      *                                                                                       220180
     C                   EXSR      SRBkBr                                                     220180
      *                                                                                       220180
      ** Otherwise, set Booking Branch to Single Branch Code.                                 220180
      *                                                                                       220180
     C                   ELSE                                                                 220180
      *                                                                                       220180
     C                   EVAL      DDBRCA = *BLANKS                                           220180
     C                   EVAL      IPBRCA = BJSBRC                                            220180
      *                                                                                       220180
     C                   ENDIF                                                                220180
      * If the user is connected via a browser, the job user name is QUSER -                 BUG6864
      * their user name is stored in ZMUSER                                                  BUG6864
                                                                                             BUG6864
     C     PUSRID        IFNE      *BLANKS                                                   BUG6864
     C     PUSRID        ANDNE     PSUser                                                    BUG6864
     C                   MOVE      'Y'           JAVAUSER          1                         BUG6864
     C                   ELSE                                                                BUG6864
     C                   MOVE      'N'           JAVAUSER                                    BUG6864
     C                   ENDIF                                                               BUG6864
      *
      ** Originating Branch Validation.
      *
      /COPY WNCPYSRC,FTIPY1V004
      *
      ** Validate Originating Branch if multibranching and
      ** Originating Branch being used.
      *
     C                   IF        BGMBIN = 'Y' and
     C                             BKOBRU = 'Y'
      *
     C                   EXSR      SROrBr
      *
     C                   ELSE
      *
     C                   EVAL      DDORBR = *BLANKS
      *
      ** If not multibranching, default Originating Branch to
      ** Single Branch Code.
      *
     C                   IF        BGMBIN <> 'Y'
      *
     C                   EVAL      IPORBR = BJSBRC
      *
     C                   ELSE
      *
      ** If multibranching and Originating Branch not being
      ** used, default Originating Branch to Booking Branch.
      *
     C                   IF        BKOBRU <> 'Y' and
     C                             OKBRCA = 'Y'
      *
     C                   EVAL      IPORBR = IPBRCA
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      /COPY WNCPYSRC,FTIPY1V005
      *
      ** Payment Subtype Validation.
      *
      /COPY WNCPYSRC,FTIPY1V006
      *
     C                   EXSR      SRPyStp
      *
      /COPY WNCPYSRC,FTIPY1V007
      *
      ** Settlement Currency and Amount Validation.
      *
      /COPY WNCPYSRC,FTIPY1V008
      *
     C                   EXSR      SRScyAm
      *
      /COPY WNCPYSRC,FTIPY1V009
      *
      ** Payment Currency and Amount Validation.
      *
      /COPY WNCPYSRC,FTIPY1V010
      *
     C                   EXSR      SRPcyAm
      *
      /COPY WNCPYSRC,FTIPY1V011
      *
      ** Notified Currency and Amount Validation.
      *
      /COPY WNCPYSRC,FTIPY1V012
      *
      ** Validate Notified Currency and Amount if EMU FT
      ** Settlement Currency Conversion feature is installed.
      ** OR MT103 is installed                                                  CFT014
      *
     C                   IF        CEU006 = 'Y'
     C                             OR (CFT014 = 'Y')                            CFT014
     C                   EXSR      SRNcyAm
     C                   ELSE
     C                   EVAL      DDNDCY = *BLANKS
     C                   EVAL      DDNDAM = *BLANKS
     C                   ENDIF
      *
      /COPY WNCPYSRC,FTIPY1V013
      *
      ** Override Flag Validation.
      *
      /COPY WNCPYSRC,FTIPY1V014
      *
     C                   EXSR      SROvrdF
      *
      /COPY WNCPYSRC,FTIPY1V015
      *
      ** Sender Validation.
      *
      /COPY WNCPYSRC,FTIPY1V016
      *
     C                   EXSR      SRSendr
      *
      /COPY WNCPYSRC,FTIPY1V017
      *
      ** Receiver's Correspondent Validation.
      *
      /COPY WNCPYSRC,FTIPY1V018
      *
     C                   EXSR      SRRCorr
      *
      /COPY WNCPYSRC,FTIPY1V019
      *                                                                         CFT014
      ** Third Reimbursement Institution                                        CFT014
      *                                                                         CFT014
     C                   IF        CFT014 = 'Y'                                 CFT014
     C                   EXSR      SRTRIB                                       CFT014
     C                   ELSE                                                   CFT014
     C                   EVAL      DDTRIB = *BLANKS                             CFT014
     C                   ENDIF                                                  CFT014
                                                                                              CGL014
     C                   IF        CGL014 = 'Y'   AND  OKSMCY <> 'N'  AND                     CGL014
     C                             OKSMAM <> 'N'                                              CGL014
     C                   IF        DDACTN = 'I'  OR                                          BUG3281
     C                             (DDACTN = 'A'  AND  IPOEDT = BJRDNB)                      BUG3281
                                                                                              CGL014
     C/COPY WNCPYSRC,FTIPY1V041                                                               CGL014
                                                                                              CGL014
     C                   EXSR      VSETBL                                                     CGL014
                                                                                              CGL014
     C/COPY WNCPYSRC,FTIPY1V042                                                               CGL014
                                                                                              CGL014
     C                   ENDIF                                                                CGL014
     C                   ENDIF                                                               BUG3281
      *
      ** Beneficiary Customer Validation.
      *
      /COPY WNCPYSRC,FTIPY1V020
      *
     C                   EXSR      SRBenfC
      *
      /COPY WNCPYSRC,FTIPY1V021
      *
      ** Account With Bank Validation.
      *
      /COPY WNCPYSRC,FTIPY1V022
      *
     C                   EXSR      SRAcBnk
      *
      /COPY WNCPYSRC,FTIPY1V023
      *
      ** Settlement Value Date Validation.
      *
      /COPY WNCPYSRC,FTIPY1V024
      *
     C                   EXSR      SRSetVD
      *
      /COPY WNCPYSRC,FTIPY1V025
      *
      ** Payment Value Date Validation.
      *
      /COPY WNCPYSRC,FTIPY1V026
      *
     C                   EXSR      SRPayVD
      *
      /COPY WNCPYSRC,FTIPY1V027
      *
      ** Rate Validation.
      *
      /COPY WNCPYSRC,FTIPY1V028
      *
     C                   EXSR      SRRate
      *                                                                         CFT014
      ** Perform additional defaulting process for Instructed Currency/         CFT014
      ** Amount if switchable feature CFT014 is installed.                      CFT014
      *                                                                         CFT014
     C                   If        CFT014 = 'Y' and                             CFT014
     C                             OKNDCY = 'Y' and DDNDCY = *BLANKS and        CFT014
     C                             OKNDAM = 'Y' and IPNDAM = *ZERO and          CFT014
     C                             OKSND1 = 'Y' and OKBRCA = 'Y' and            CFT014
     C                             OKSMCY = 'Y' and DDSMCY <> *BLANKS and       CFT014
     C                             IPSMAM <> *ZERO                              CFT014
     C                   EXSR      SRIDFT                                       CFT014
     C                   ENDIF                                                  CFT014
     C/COPY WNCPYSRC,FTH00273
      *                                                                         CFT014
      ** Display warning error if level joiner is off, action is amend,         CFT014
      ** any of the Sender's Charges or Receiver's Charges Remitted is not      CFT014
      ** zero and Instructed Amount is zero.                                    CFT014
      *                                                                         CFT014
     C                   IF        CFT014 = 'Y' and DDNDAM <> PPrvNDAM          CFT014
      *                                                                         CFT014
     C                   IF        BTLVJN <> 'Y' and DDACTN = 'A' and           CFT014
     C                             OKNDAM = 'Y' and IPNDAM = *ZERO              CFT014
      *                                                                         CFT014
     C                   IF        I2INSCH1 <> *ZERO or i2INSCH2 <> *ZERO or    CFT014
     C                             I2INSCH3 <> *ZERO or I2INSCH4 <> *ZERO or    CFT014
     C                             I2INSCH5 <> *ZERO or I2INSCC1 <> *BLANKS or  CFT014
     C                             I2INSCC2 <> *BLANKS or                       CFT014
     C                             I2INSCC3 <> *BLANKS or                       CFT014
     C                             I2INSCC4 <> *BLANKS or                       CFT014
     C                             I2INSCC5 <> *BLANKS or I2INRCRM <> *ZERO     CFT014
     C                   MOVE      'N'           OKNDAM                         CFT014
     C                   Add       1             Ix                             CFT014
     C                   MOVEL     'DDNDAM'      FldNameArr(Ix)                 CFT014
     C                   MOVEL     'FTM3160'     MsgIdArr(Ix)                   CFT014
     C                   ENDIF                                                  CFT014
     C                   ENDIF                                                  CFT014
     C                   ENDIF                                                  CFT014
      *
      /COPY WNCPYSRC,FTIPY1V029
      *                                                                         CFT014
      ** Original Exchange Rate                                                 CFT014
      *                                                                         CFT014
     C                   IF        CFT014 = 'Y'                                 CFT014
     C                   EXSR      SROEXR                                       CFT014
     C                   ELSE                                                   CFT014
     C                   EVAL      DDOEXR = *BLANKS                             CFT014
     C                   ENDIF                                                  CFT014
      *
      ** Add/Deduct Charges Indicator Validation.
      *
      /COPY WNCPYSRC,FTIPY1V030
      *
     C                   EXSR      SRAdDct
      *
      /COPY WNCPYSRC,FTIPY1V031
      *
      ** SWIFT Priority Code Validation.
      *
      /COPY WNCPYSRC,FTIPY1V032
      *
     C                   EXSR      SRSwPCd
      *
      /COPY WNCPYSRC,FTIPY1V033
      *
      ** Book Code Validation.
      *
      /COPY WNCPYSRC,FTIPY1V034
      *
     C                   EXSR      SRBokCd
      *
      /COPY WNCPYSRC,FTIPY1V035
      *
      ** Profit Centre Validation.
      *
      /COPY WNCPYSRC,FTIPY1V036
      *
      ** Validate Profit Centre if Profit Centre is supported
      ** by the system.
      *
     C     BKPRCU        IFEQ      'Y'
     C                   EXSR      SRPrCtr
     C                   ELSE
     C                   EVAL      DDPRFC = *BLANKS
     C                   ENDIF
      *
      /COPY WNCPYSRC,FTIPY1V037
      *
      ** If Electronic Banking Interface IATs and TPPs feature is
      ** switched on.
     C                   IF        CGL009 = 'Y'
     C                   EVAL      IPFDLR = DDFDLR
     C                   ENDIF
      *
      /COPY WNCPYSRC,FTIPY1V038
      *                                                                                     AR798055
     C                   IF        FUNDCHECK = 'Y'                                          AR798055
      *                                                                                     AR798055
      ** If no errors check available balance                                               AR798055
      *                                                                                     AR798055
     C                   IF        Idx = 0                                                  AR798055
      *                                                                                     AR798055
      ** Account types for Receiver's Corr and Sender                                       AR798055
      **   R - Retail                                                                       AR798055
      **   G - Full Account                                                                 AR798055
      **   I - IBAN                                                                         AR798055
      *                                                                                     AR798055
     C                   MOVEL     *Blanks       @ACNT                                      AR798055
      *                                                                                     AR798055
     C                   SELECT                                                             AR798055
      *                                                                                     AR798055
     C     IPRCRT        WHENEQ    'R'                                                      AR798055
     C                   MOVEL     IPINRCO1      ##010A           10                        AR798055
     C                   MOVEL     ##010A        @ACNT                                      AR798055
      *                                                                                     AR798055
     C     IPRCRT        WHENEQ    'G'                                                      AR798055
     C                   MOVEL     IPINRCO1      WACCT                                      AR798055
      *                                                                                     AR798055
     C                   CALLB     'AOACCTR0'                                               AR798055
     C                   PARM      *BLANKS       @RTCD                                      AR798055
     C                   PARM      '*KEY   '     @OPTN                                      AR798055
     C                   PARM      *BLANKS       PPRETL           10                        AR798055
     C                   PARM                    PACNUM                                     AR798055
     C                   PARM                    PACCY                                      AR798055
     C                   PARM                    PAACOD                                     AR798055
     C                   PARM                    PAACSQ                                     AR798055
     C                   PARM                    PABRCA                                     AR798055
     C     P@ACCN        PARM      P@ACCN        DSSDY                                      AR798055
      *                                                                                     AR798055
      ** Database Error                                                                     AR798055
      *                                                                                     AR798055
     C     @RTCD         IFNE      *BLANKS                                                  AR798055
     C                   MOVEL     'AOACCTR0'    DBFILE                                     AR798055
     C                   MOVEL     '010'         DBASE                                      AR798055
     C                   MOVEL     @OPTN         DBKEY                                      AR798055
     C                   EXSR      *PSSR                                                    AR798055
     C                   ENDIF                                                              AR798055
      *                                                                                     AR798055
     C                   MOVEL     ICACNO        @ACNT                                      AR798055
      *                                                                                     AR798055
     C     IPRCRT        WHENEQ    'I'                                                      AR798055
      *                                                                                     AR798055
      ** Determine corresponding Midas Account of IBAN Account                              AR798055
      *                                                                                     AR798055
     C                   MOVEL     IPINRCO1      P@IBAN                                     AR798055
     C                   MOVE      *BLANKS       DSSDY                                      AR798055
      *                                                                                     AR798055
     C                   CALL      'AOIBANR4'                                               AR798055
     C                   PARM      *BLANKS       @RTCD             7                        AR798055
     C                   PARM      '*KEY   '     @OPTN             7                        AR798055
     C                   PARM                    P@IBAN           34                        AR798055
     C     P@ACCN        PARM                    DSSDY                                      AR798055
      *                                                                                     AR798055
      ** Database Error                                                                     AR798055
      *                                                                                     AR798055
     C     @RTCD         IFNE      *BLANKS                                                  AR798055
     C                   MOVEL     'AOIBANR4'    DBFILE                                     AR798055
     C                   MOVEL     '011'         DBASE                                      AR798055
     C                   MOVEL     @OPTN         DBKEY                                      AR798055
     C                   EXSR      *PSSR                                                    AR798055
     C                   ENDIF                                                              AR798055
      *                                                                                     AR798055
     C                   MOVEL     ICACNO        @ACNT                                      AR798055
      *                                                                                     AR798055
      ** If Sender is entered                                                               AR798055
      *                                                                                     AR798055
     C     IPSNTP        WHENEQ    'G'                                                      AR798055
     C                   MOVEL     IPSND1        WACCT                                      AR798055
      *                                                                                     AR798055
     C                   CALLB     'AOACCTR0'                                               AR798055
     C                   PARM      *BLANKS       @RTCD                                      AR798055
     C                   PARM      '*KEY   '     @OPTN                                      AR798055
     C                   PARM      *BLANKS       PPRETL                                     AR798055
     C                   PARM                    PACNUM                                     AR798055
     C                   PARM                    PACCY                                      AR798055
     C                   PARM                    PAACOD                                     AR798055
     C                   PARM                    PAACSQ                                     AR798055
     C                   PARM                    PABRCA                                     AR798055
     C     P@ACCN        PARM      P@ACCN        DSSDY                                      AR798055
      *                                                                                     AR798055
      ** Database Error                                                                     AR798055
      *                                                                                     AR798055
     C     @RTCD         IFNE      *BLANKS                                                  AR798055
     C                   MOVEL     'AOACCTR0'    DBFILE                                     AR798055
     C                   MOVEL     '012'         DBASE                                      AR798055
     C                   MOVEL     @OPTN         DBKEY                                      AR798055
     C                   EXSR      *PSSR                                                    AR798055
     C                   ENDIF                                                              AR798055
      *                                                                                     AR798055
     C                   MOVEL     ICACNO        @ACNT                                      AR798055
      *                                                                                     AR798055
     C     IPSNTP        WHENEQ    'R'                                                      AR798055
     C                   MOVEL     IPSND1        @ACNT                                      AR798055
      *                                                                                     AR798055
     C                   OTHER                                                              AR798055
      *                                                                                     AR798055
     C                   GOTO      ENDTAG                                                   AR798055
      *                                                                                     AR798055
     C                   ENDSL                                                              AR798055
      *                                                                                     AR798055
      ** Call Funds Check program                                                           AR798055
      *                                                                                     AR798055
     C                   EXSR      SRResetErrs                                              AR798055
      *                                                                                     AR798055
     C                   CALL      'FT0805'                                                 AR798055
     C                   PARM                    @ACNT            21                        AR798055
     C                   PARM      IPSMCY        @CCY              3                        AR798055
     C                   PARM      IPBRCA        @BRCA             3                        AR798055
     C                   PARM      IPSMAM        @SMAM            13 0                      AR798055
     C                   PARM      IPSLDT        @SLDT             5 0                      AR798055
     C                   PARM      *BLANKS       @RCD              1                        AR798055
     C                   PARM      *Blanks       @ORETB            5                        AR798055
      *                                                                                     AR798055
      ** Check results and send messages                                                    AR798055
      *                                                                                     AR798055
     C     @RCD          IFEQ      'Y'                                                      AR798055
     C                   IF        FWARNING = 'N'                                           AR798055
     C                   MOVE      'N'           OKSmam                                     AR798055
     C                   ADD       1             Idx                                        AR798055
     C                   MOVEL     'DDSMAM'      FldNamXAr(Idx)                             AR798055
     C                   MOVEL     'BAW0001'     MsgIdXAr(Idx)                              AR798055
      *                                                                                     AR798055
     C                   ELSE                                                               AR798055
      *                                                                                     AR798055
     C                   EVAL      OKSMAM = 'W'                                             AR798055
     C                   ADD       1             Wwx                                        AR798055
     C                   EVAL      WFldNmXAr(Wwx) = 'DDSMAM'                                AR798055
     C                   EVAL      WMsgIDXAr(Wwx) = 'BAW0001'                               AR798055
     C                   ENDIF                                                              AR798055
      *                                                                                     AR798055
     C                   ENDIF                                                              AR798055
     C     ENDTAG        TAG                                                                AR798055
     C                   EXSR      SRUpdatErrs                                              AR798055
      *                                                                                     AR798055
     C                   ENDIF                                                              AR798055
     C                   ENDIF                                                              AR798055
 
      * Validate FX spread set and payment date offset code                     CFT009
     C                   IF        CFT009 = 'Y'                                 CFT009
     C                   EXSR      VFXSP                                        CFT009
     C                   EXSR      VOFCD                                        CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CDL049
      * Validate Reference Rate field                                           CDL049
     C                   IF        CDL049 = 'Y'                                 CDL049
     C                   EXSR      VRRAT                                        CDL049
     C                   ENDIF                                                  CDL049
                                                                                CFT009
      * Default charges                                                         CFT009
     C                   IF        IDX = 0 AND CFT009 = 'Y'                     CFT009
      * For Midasplus users                                                                  BUG6864
      * Save charges values, if they have been entered then keep them instead                BUG6864
      * of overwriting with the defaults. Charges are always defaulted first but             BUG6864
      * the user may change them after this.                                                 BUG6864
     C                   Eval      NWIP5SCNFMTA = NWIP5SCNFMT                                BUG6864
     C                   EVAL      IPCDRO = DDCDRO                                         AR1079259
     C                   EXSR      DFTCHG                                       CFT009
     C                   EVAL      IPCDRO = *BLANKS                                        AR1079259
      * Check if charges fields were entered or previously defaulted                         BUG6864
      * If so then do not default                                                            BUG6864
     C                   If        JAVAUSER = 'Y'                                            BUG6864
     C                   If        W#DDTRCD <> *BLANKS OR W#DDCHCD <> *BLANKS OR             BUG6864
     C                             W#DDTXCD <> *BLANKS OR W#DDCQCD <> *BLANKS OR             BUG6864
     C                             W#DDADCD <> *BLANKS OR W#DDTLCD <> *BLANKS OR             BUG6864
     C**********                   W#DDMSCD <> *BLANKS OR W#DDRCRM <> *BLANKS OR    BUG6864 MD023051
     C                             W#DDMSCD <> *BLANKS OR                                   MD023051
     C                             W#M1CD <> *BLANKS OR W#M2CD <> *BLANKS OR                 BUG6864
     C                             W#M3CD <> *BLANKS OR W#M4CD <> *BLANKS OR                 BUG6864
     C**********                   W#M5CD <> *BLANKS OR W#DDSCH1 <> *BLANKS OR      BUG6864 MD023051
     C**********                   W#DDSCH2 <> *BLANKS OR W#DDSCH3 <> *BLANKS OR    BUG6864 MD023051
     C**********                   W#DDSCH4 <> *BLANKS OR W#DDSCH5 <> *BLANKS       BUG6864 MD023051
     C                             W#M5CD <> *BLANKS                                        MD023051
     C                   Eval      NWIP5SCNFMT = NWIP5SCNFMTA                                BUG6864
     C                   EndIf                                                               BUG6864
     C                   EndIf                                                               BUG6864
                                                                                CFT009
      * Re-validate defaulted rate from FX spread set, to check rate is         CFT009
      * still within tolerence.                                                 CFT009
                                                                                CFT009
     C                   IF        CFT009 = 'Y'                                 CFT009
     C                   EXSR      SRRate                                       CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * Save defaults                                                           CFT009
     C                   IF        DDACTN = 'I' OR DDACTN = 'A'                 CFT009
     C                   CLEAR                   DEFVALID                       CFT009
     C                   CLEAR                   DEFVALIDX                      CFT009
                                                                                CFT009
     C                   EVAL      DEFVALID = NWIPFILFMT                        CFT009
     C                   EVAL      DEFVALIDX = NWIP2FILFMT                      CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      ***If*CFT009*is*not,*on*clear*the*default*format*to*avoid*decimal*data          202322 BUG7101
      ***error*later                                                                  202322 BUG7101
     C**********         ELSE                                                         202322 BUG7101
      **********                                                                      CAP084 BUG7101
      ***Only*clear*if*CFT003*and*CFT014*are*both*off.                                CAP084 BUG7101
     C**********         IF        CFT003 <> 'Y' AND                                  CAP084 BUG7101
     C**********                   CFT014 <> 'Y'                                      CAP084 BUG7101
     C**********         CLEAR                   NWIP2FILFMT                          202322 BUG7101
     C**********         ENDIF                                                        CAP084 BUG7101
      **********                                                                      CAP084 BUG7101
     C**********         CLEAR                   DEFVALID                             CAP084 BUG7101
     C**********         CLEAR                   DEFVALIDX                            202322 BUG7101
     C                   ENDIF                                                  CFT009
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      *
      /COPY WNCPYSRC,FTIPY1V039
      *
      *****************************************************************
      /EJECT                                                                                  220180
      *****************************************************************                       220180
      *                                                               *                       220180
      *  SRBKBR - Booking Branch Validation                           *                       220180
      *                                                               *                       220180
      *****************************************************************                       220180
      *                                                                                       220180
     C     SRBkBr        BEGSR                                                                220180
      *                                                                                       220180
      ** Reset fields.                                                                        220180
      *                                                                                       220180
     C                   EXSR      SRResetErrs                                                220180
      *                                                                                       220180
      ** Call validation module.                                                              220180
      *                                                                                       220180
     C/COPY WNCPYSRC,FTH00370
     C                   CALLB     'FTVIBRCA'                                                 220180
      *                             ========                                                  220180
      ** INPUT                                                                                220180
      ** =====                                                                                220180
      *                                                                                       220180
      ** Return Code                                                                          220180
     C                   PARM                    RetCodeOut                                   220180
      *                                                                                       220180
      ** Action Code                                                                          220180
     C                   PARM                    DDACTN                                       220180
      *                                                                                       220180
      ** Booking Branch                                                                       220180
     C                   PARM                    DDBRCA                                       220180
      *                                                                                       220180
      ** SWIFT Reference                                                                      220180
     C                   PARM                    DDSWTN           28                          220180
      *                                                                                       220180
      ** Mode = '*FRONT' (Front Office Transaction Interface)                                 220180
      ** Mode = '      ' (Not Front Office Transaction Interface)                             220180
      ** Mode = '*RPR  ' (Repair function)                                                    220180
      ** Mode = '*SIN  ' (Screen Input function)                                              220180
     C                   PARM                    PMode                                        220180
      *                                                                                       220180
      ** Response Mode                                                                        220180
     C                   PARM                    PResponse         1                          220180
      *                                                                                       220180
      ** Linked Program                                                                       220180
     C                   PARM                    WLinkPgm         10                          220180
      *                                                                                       220180
      ** Incoming Payments retrieved from file - file format                                  220180
     C                   PARM                    CrIPFilFmt                                   220180
      *                                                                                       220180
      ** STANDING DATA                                                                        220180
      ** =============                                                                        220180
      *                                                                                       220180
      ** ZMUSER - Default Branch                                                              220180
     C                   PARM                    PDBRN             3                          220180
      *                                                                                       220180
      ** OUTPUT                                                                               220180
      ** ======                                                                               220180
      *                                                                                       220180
      ** Error fields/message IDs/message data (arrays) from/to caller                        220180
     C                   PARM                    FldNamXAr                                    220180
     C                   PARM                    MsgIDXAr                                     220180
     C                   PARM                    MsgDtaXAr                                    220180
      *                                                                                       220180
      ** OK Action Code                                                                       220180
     C                   PARM                    OKACTN                                       220180
      *                                                                                       220180
      ** OK Payment Reference                                                                 220180
     C                   PARM                    OKPREF                                       220180
      *                                                                                       220180
      ** OK Booking Branch                                                                    220180
     C                   PARM                    OKBRCA                                       220180
      *                                                                                       220180
      ** Incoming Payments for file update - file format                                      220180
     C                   PARM                    NwIPFilFmt                                   220180
     C/COPY WNCPYSRC,FTH00371
      *                                                                                       220180
      ** Update error information.                                                            220180
      *                                                                                       220180
     C                   IF        RetCodeOut <> *Blanks                                      220180
     C                   EXSR      SRUpdatErrs                                                220180
     C                   ENDIF                                                                220180
      *                                                                                       220180
     C                   ENDSR                                                                220180
      *                                                                                       220180
      *****************************************************************                       220180
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRORBR - Originating Branch Validation                       *
      *                                                               *
      *****************************************************************
      *
     C     SROrBr        BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C/COPY WNCPYSRC,FTH00368
     C                   CALLB     'FTVIORBR'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *                                                                                     BUG12583
      ** Incoming Payments Lvl 1 Scrn file 2 details from                                   BUG12583
      ** Incoming transactions - screen format                                              BUG12583
     C                   PARM                    NwIP1AScnFmt                               BUG12583
      *                                                                                     BUG12583
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Response Mode
     C                   PARM                    PResponse
      *
      ** STANDING DATA
      ** =============
      *
      ** SDGELR - Originating Branch/User Vald Req.
     C                   PARM                    BKOBUV
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
                                                                                            BUG12583
     C                   Parm                    WFldNmXAr                                  BUG12583
     C                   Parm                    WMsgIDXAr                                  BUG12583
     C                   Parm                    WMsgDtXAr                                  BUG12583
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
     C/COPY WNCPYSRC,FTH00369
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPYSTP - Payment Subtype Validation                         *
      *                                                               *
      *****************************************************************
      *
     C     SRPyStp       BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVIPYST'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *
      ** Payment Type
     C                   PARM                    PPYTP
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
                                                                                            BUG12952
     C                   PARM                    WFldNmXAr                                  BUG12952
     C                   PARM                    WMsgIDXAr                                  BUG12952
     C                   PARM                    WMsgDtXAr                                  BUG12952
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
     C
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSCYAM - Settlement Currency and Amount Validation          *
      *                                                               *
      *****************************************************************
      *
     C     SRScyAm       BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVISMCA'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Base Currency No. of Decimal Places
     C                   PARM                    PBCDP
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
                                                                                            BUG12278
     C                   Parm                    WFldNmXAr                                  BUG12278
     C                   Parm                    WMsgIDXAr                                  BUG12278
     C                   Parm                    WMsgDtXAr                                  BUG12278
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Settlement In Currency Indicator
     C                   PARM                    PSetInCy          1
      *
      ** Settlement EMU Transaction Period Start Date
     C                   PARM                    PSetTPSD          5 0
      *
      ** Settlement Number of Decimal Places
     C                   PARM                    PSetNumDP         1 0
      *
      ** Settlement Spot Rate
     C                   PARM                    PSetSpotRat      13 8
      *
      ** Settlement Multiply/Divide indicator
     C                   PARM                    PSetMDIn          1 0
      *
      ** Settlement Spot by Buy Spread
     C                   PARM                    PSetBRat         13 8
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
     C/COPY WNCPYSRC,FTIPA1VC12
      *****************************************************************
      *                                                               *
      *  SRPCYAM - Payment Currency and Amount Validation             *
      *                                                               *
      *****************************************************************
      *
     C     SRPcyAm       BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
     C/COPY WNCPYSRC,FTIPA1VC15
      *
     C                   CALLB     'FTVIPYCA'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Base Currency No. of Decimal Places
     C                   PARM                    PBCDP
      *
      ** Settlement Number of Decimal Places
     C                   PARM                    PSetNumDP
      *
      ** Settlement Spot Rate
     C                   PARM                    PSetSpotRat
      *
      ** Settlement Multiply/Divide indicator
     C                   PARM                    PSetMDIn
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
                                                                                            BUG12278
     C                   Parm                    WFldNmXAr                                  BUG12278
     C                   Parm                    WMsgIDXAr                                  BUG12278
     C                   Parm                    WMsgDtXAr                                  BUG12278
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Payment In Currency Indicator
     C                   PARM                    PPayInCy          1
      *
      ** Payment EMU Transaction Period Start Date
     C                   PARM                    PPayTPSD          5 0
      *
      ** Payment Number of Decimal Places
     C                   PARM                    PPayNumDP         1 0
      *
      ** Payment Spot Rate
     C                   PARM                    PPaySpotRat      13 8
      *
      ** Payment Multiply/Divide Indicator
     C                   PARM                    PPayMDIn          1 0
      *
      ** Payment Spot Rate by Sell Spread
     C                   PARM                    PPaySRat         13 8
     C/COPY WNCPYSRC,FTIPA1VC16
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNCYAM - Notified Currency and Amount Validation            *
      *                                                               *
      *****************************************************************
      *
     C     SRNcyAm       BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVINDCA'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Settlement In Currency Indicator
     C                   PARM                    PSetInCy
      *
      ** STANDING DATA
      ** =============
      *
      ** SDGELR - Currency Code for Euro
     C                   PARM                    BKEURO
      *
      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU FT Settlement Currency Conversion
     C                   PARM                    CEU006
      *                                                                         CFT014
      ** MT103 Messages Generation for FT                                       CFT014
     C                   PARM                    CFT014                         CFT014
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Notified Delivery In Currency Indicator
     C                   PARM                    PNotInCy          1
      *
      ** Notified EMU Transition Period Start Date
     C                   PARM                    PNotTPSD          5 0
      *
      ** Notified Delivery Number of Decimal Places
     C                   PARM                    PNotNumDP         1 0
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROVRDF - Override Flag Validation                           *
      *                                                               *
      *****************************************************************
      *
     C     SROvrdF       BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVIOVRD'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSENDR - Sender Validation                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRSendr       BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
     C/COPY WNCPYSRC,FTIPA1VC02
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVISNDR'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *                                                                                       240689
      ** Incoming Payments Lvl 1 Scrn file 2 details from                                     240689
      ** Incoming transactions - screen format                                                240689
      *                                                                                       240689
     C                   PARM                    NwIP1AScnFmt                                 240689
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Multibranch Indicator
     C                   PARM                    BGMBIN
      *
      ** SDMMOD - Retail Banking
     C                   PARM                    BGRTBN
      *
      ** SDMMOD - Dealing Foreign Exchange
     C                   PARM                    BGDLFX
      *
      ** SDMMOD - Dealing Money Market
     C                   PARM                    BGDLMM
      *
      ** SDRETL - Retail A/c Number Required?
     C                   PARM                    BMRANR
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
                                                                                              CRE008
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CRE008
     C                   PARM                    WFldNmXAr                                    CRE008
     C                   PARM                    WMsgIDXAr                                    CRE008
     C                   PARM                    WMsgDtXAr                                    CRE008
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Sender Currency
     C                   PARM                    PSendrCcy         3
      *
      ** Sender's Account Type
     C                   PARM                    PAtyp1            1
      *
      ** Sender's Account Status
     C                   PARM                    PAcSt1            1
      *
      ** Sender's Date Account Opened
     C                   PARM                    PDAcO1            5 0
      *
      ** Sender's full account
     C**********         PARM                    PSNDDS           18                          TDA006
     C                   PARM                    PSNDDS           24                          TDA006
      *                                                                         CFT014
      ** Sender's SWIFT ID                                                      CFT014
     C                   PARM                    PSNDCSID         12            CFT014
      *                                                                         CFT014
      ** Sender's Country of location                                           CFT014
     C                   PARM                    PSNDCOLC          2            CFT014
     C/COPY WNCPYSRC,FTIPA1VC03
      *
      ** Update error information.
      *
     C**********         IF        RetCodeOut <> *BLANKS                                      240689
     C                   EXSR      SRUpdatErrs
     C**********         ENDIF                                                                240689
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCORR - Receiver's Correspondent Validation                *
      *                                                               *
      *****************************************************************
      *
     C     SRRCorr       BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
     C/COPY WNCPYSRC,FTIPA1VC04
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVIRCCO'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *                                                                         CFT014
      ** Incoming Payments Lvl 1 Scrn file 2 details from                       CFT014
      ** Incoming transactions - screen format                                  CFT014
     C                   PARM                    NwIP1AScnFmt                   CFT014
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Sender Currency
     C                   PARM                    PSendrCcy
      *                                                                         CFT014
      ** FT Batch Auth. and Credit Advices                                      CFT014
     C                   PARM                    CFT004                         CFT014
      *                                                                         CFT014
      ** MT103 Messages Generation for FT                                       CFT014
     C                   PARM                    CFT014                         CFT014
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Retail Banking
     C                   PARM                    BGRTBN
      *
      ** SDRETL - Retail A/c Number Required?
     C                   PARM                    BMRANR
      *                                                                         CFT014
      ** Default branch for single-branch                                       CFT014
     C                   PARM                    BJSBRC                         CFT014
      *                                                                         CFT014
      ** Multi-branching indicator                                              CFT014
     C                   PARM                    BGMBIN                         CFT014
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
                                                                                              240689
     C                   Parm                    WFldNmXAr                                    240689
     C                   Parm                    WMsgIDXAr                                    240689
     C                   Parm                    WMsgDtXAr                                    240689
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** RCorr's Account Type
     C                   PARM                    PATyp2            1
      *
      ** RCorr's Account Status
     C                   PARM                    PAcSt2            1
      *
      ** RCorr's Date Account Opened
     C                   PARM                    PDAcO2            5 0
      *
      ** Receiver Correspondence's full account
     C**********         PARM                    PRCCDS           18                          CGL029
     C                   PARM                    PRCCDS                                       CGL029
      *
      ** Work flag for error '041'
     C                   PARM                    POkRcCo           1
     C/COPY WNCPYSRC,FTIPA1VC05
      *
      ** Update error information.
      *
     C**********         IF        RetCodeOut <> *BLANKS                                      240689
     C                   EXSR      SRUpdatErrs
     C**********         ENDIF                                                                240689
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBENFC - Beneficiary Validation                             *
      *                                                               *
      *****************************************************************
      *
     C     SRBenfC       BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
     C/COPY WNCPYSRC,FTIPA1VC06
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVIBENC'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Multibranch Indicator
     C                   PARM                    BGMBIN
      *
      ** SDMMOD - Retail Banking
     C                   PARM                    BGRTBN
      *
      ** SDRETL - Retail A/c Number Required?
     C                   PARM                    BMRANR
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** IBAN numbers
     C                   PARM                    CFT004            1
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
                                                                                              240689
     C                   Parm                    WFldNmXAr                                    240689
     C                   Parm                    WMsgIDXAr                                    240689
     C                   Parm                    WMsgDtXAr                                    240689
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Beneficiary Customer's Account Type
     C                   PARM                    PAtyp3            1
      *
      ** Beneficiary Customer's Account Status
     C                   PARM                    PAcSt3            1
      *
      ** Beneficiary Customer's Date Account Opened
     C                   PARM                    PDAcO3            5 0
      *
      ** Beneficiary's full account
     C**********         PARM                    PBNCDS           18                          TDA006
     C                   PARM                    PBNCDS           24                          TDA006
      *
      ** IBANs full account
     C                   PARM                    PIBANAcc
      *
      ** Account needed to set payment value date
     C**********         PARM                    PPYFLDS          18                          CGL029
     C                   PARM                    PPYFLDS                                      CGL029
     C                   PARM                    BENEDrBlck                                 MD025111
     C/COPY WNCPYSRC,FTIPA1VC07
      *
      ** Update error information.
      *
     C**********         IF        RetCodeOut <> *BLANKS                                      240689
     C                   EXSR      SRUpdatErrs
     C**********         ENDIF                                                                240689
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRACBNK - Account with Bank Validation                       *
      *                                                               *
      *****************************************************************
      *
     C     SRAcBnk       BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
     C/COPY WNCPYSRC,FTIPA1VC08
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVIACBK'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Work flag for error '041'
     C                   PARM                    POkRcCo
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDMMOD - Multibranch Indicator
     C                   PARM                    BGMBIN
      *
      ** SDMMOD - Retail Banking
     C                   PARM                    BGRTBN
      *
      ** SDRETL - Retail A/c Number Required?
     C                   PARM                    BMRANR
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
                                                                                              240689
     C                   Parm                    WFldNmXAr                                    240689
     C                   Parm                    WMsgIDXAr                                    240689
     C                   Parm                    WMsgDtXAr                                    240689
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** A/c with Bank's Account Type
     C                   PARM                    PAtyp4            1
      *
      ** A/c with Bank's Account Status
     C                   PARM                    PAcSt4            1
      *
      ** A/c with Bank's Date Account Opened
     C                   PARM                    PDAcO4            5 0
      *
      ** Account with Bank's full account
     C**********         PARM                    PACBDS           18                          TDA006
     C                   PARM                    PACBDS           24                          TDA006
      *
      ** Account needed to set Payment Value Date
     C                   PARM                    PPYFLDS
     C/COPY WNCPYSRC,FTIPA1VC09
      *
      ** Update error information.
      *
     C**********         IF        RetCodeOut <> *BLANKS                                      240689
     C                   EXSR      SRUpdatErrs
     C**********         ENDIF                                                                240689
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSETVD - Settlement Value Date Validation                   *
      *                                                               *
      *****************************************************************
      *
     C     SRSetVD       BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
     C/COPY WNCPYSRC,FTH00237
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVISLDT'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *                                                                         CFT014
      ** Incoming Payments Lvl 1 Scrn file 2 details from Incoming              CFT014
      ** transaction - screen format                                            CFT014
     C                   PARM                    NwIP1AScnFmt                   CFT014
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Sender's Account Type
     C                   PARM                    PAtyp1
      *
      ** Sender's Account Status
     C                   PARM                    PAcSt1
      *
      ** Sender's Date Account Opened
     C                   PARM                    PDAcO1
      *
      ** RCorr's Account Type
     C                   PARM                    PATyp2
      *
      ** RCorr's Account Status
     C                   PARM                    PAcSt2
      *
      ** RCorr's Date Account Opened
     C                   PARM                    PDAcO2
      *                                                                         CFT014
      ** Third Reimbursement Inst. Account Type                                 CFT014
     C                   PARM                    PAtyp5                         CFT014
      *                                                                         CFT014
      ** Third Reimbursement Inst. Account Status                               CFT014
     C                   PARM                    PAcSt5                         CFT014
      *                                                                         CFT014
      ** Third Reimbursement Inst. Date Account Opened                          CFT014
     C                   PARM                    PDAcO5                         CFT014
      *
      ** Settlement In Currency Indicator
     C                   PARM                    PSetInCy
      *
      ** Settlement EMU Transaction Period Start Date
     C                   PARM                    PSetTPSD
      *
      ** Notified Delivery In Currency Indicator
     C                   PARM                    PNotInCy
      *
      ** Notified EMU Transition Period Start Date
     C                   PARM                    PNotTPSD
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Midas Run Date
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Back Value Period in Days
     C                   PARM                    BJBVPD
      *
      ** SDBANK - Midas Local Currency
     C                   PARM                    BJLCCY
      *
      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN
      *
      ** SDGELR - Currency Code for Euro
     C                   PARM                    BKEURO
      *
      ** SWITCHABLE FEATURES
      *
      ** EMU FT Settlement Currency Conversion
     C                   PARM                    CEU006
      *                                                                         CFT014
      ** MT103 Messages Generation for FT                                       CFT014
     C                   PARM                    CFT014                         CFT014
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
     C/COPY WNCPYSRC,FTH00562
      *
      ** Update error information.
      *
     C**********         IF        RetCodeOut <> *BLANKS                                      207211
     C                   EXSR      SRUpdatErrs
     C**********         ENDIF                                                                207211
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPAYVD - Payment Value Date Validation                      *
      *                                                               *
      *****************************************************************
      *
     C     SRPayVD       BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
     C/COPY WNCPYSRC,FTIPA1VC10
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVIPYDT'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Beneficiary Customer's Account Type
     C                   PARM                    PAtyp3
      *
      ** Beneficiary Customer's Account Status
     C                   PARM                    PAcSt3
      *
      ** Beneficiary Customer's Date Account Opened
     C                   PARM                    PDAcO3
      *
      ** A/c with Bank's Account Type
     C                   PARM                    PAtyp4
      *
      ** A/c with Bank's Account Status
     C                   PARM                    PAcSt4
      *
      ** A/c with Bank's Date Account Opened
     C                   PARM                    PDAcO4
      *
      ** Account needed to set payment value date
     C                   PARM                    PPYFLDS
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Midas Run Date
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Back Value Period in Days
     C                   PARM                    BJBVPD
      *
      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY
      *
      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD
      *
      ** SDBANK - Location Code
     C                   PARM                    BJSLCD
      *
      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN
      *                                                                         CFT009
      ** SWITCHABLE FEATURES                                                    CFT009
      ** ===================                                                    CFT009
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
     C/COPY WNCPYSRC,FTIPA1VC11
      *
      ** Update error information.
      *
     C**********         IF        RetCodeOut <> *BLANKS                                      207211
     C                   EXSR      SRUpdatErrs
     C**********         ENDIF                                                                207211
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRATE - Rate Validation                                     *
      *                                                               *
      *****************************************************************
      *
     C     SRRate        BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
     C/COPY WNCPYSRC,FTIPA1VC17
      *
     C                   CALLB     'FTVIRATE'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *
      ** Incoming Payments Lvl 1 Scrn details retrieved from file
      ** - screen format
     C                   PARM                    CrIP1ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Base Currency No. of Decimal Places
     C                   PARM                    PBCDP
      *
      ** Notified Delivery Number of Decimal Places
     C                   PARM                    PNotNumDP
      *                                                                         CFT014
      ** Instructed In currency indicator                                       CFT014
     C                   PARM                    PNotInCy                       CFT014
      *
      ** Settlement Spot by Buy Spread
     C                   PARM                    PSetBRat
      *
      ** Settlement Number of Decimal Places
     C                   PARM                    PSetNumDP
      *
      ** Settlement Multiply/Divide indicator
     C                   PARM                    PSetMDIn
      *
      ** Settlement Spot Rate
     C                   PARM                    PSetSpotRat
      *                                                                         CFT014
      ** Settlement In currency indicator                                       CFT014
     C                   PARM                    PSetInCy                       CFT014
      *
      ** Payment Spot Rate by Sell Spread
     C                   PARM                    PPaySRat
      *
      ** Payment of Decimal Places
     C                   PARM                    PPayNumDP
      *
      ** Payment Multiply/Divide Indicator
     C                   PARM                    PPayMDIn
      *
      ** Payment Spot Rate
     C                   PARM                    PPaySpotRat
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Multibranch Indicator
     C                   PARM                    BGMBIN
      *
      ** SDGELR - Currency Code for Euro
     C                   PARM                    BKEURO
      *
      ** SDGELR - Originating Branch Used
     C                   PARM                    BKOBRU
      *
      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD
      *
      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU FT Settlement Currency Conversion
     C                   PARM                    CEU006
      *                                                                         CFT014
      ** STP Phase 2 MT103                                                      CFT014
     C                   PARM                    CFT014                         CFT014
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Charges Branch
     C                   PARM                    PPYBR             3
     C/COPY WNCPYSRC,FTIPA1VC18
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRADDCT - Add/Deduct Charges Validation                      *
      *                                                               *
      *****************************************************************
      *
     C     SRAdDct       BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *                                                                                     AR900506
      ** Default Add/Deduct indicator if Details of Charges present                         AR900506
      ** This should only occur with a transaction passed through the                       AR900506
      ** API                                                                                AR900506
      *                                                                                     AR900506
     C                   IF        DDADDC = *blank                                          AR900506
     C                   IF        DDDTCH = 'OUR'                                           AR900506
     C                   EVAL      DDADDC = 'A'                                 ADD         AR900506
     C                   ENDIF                                                              AR900506
     C                   IF        DDDTCH = 'SHA' or DDDTCH = 'BEN'                         AR900506
     C                   EVAL      DDADDC = 'D'                                 DEDUCT      AR900506
     C                   ENDIF                                                              AR900506
     C                   ENDIF                                                              AR900506
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVIADDC'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSWPCD - SWIFT Priority Code Validation                     *
      *                                                               *
      *****************************************************************
      *
     C     SRSwPCd       BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVISWPC'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBOKCD - Book Code Validation                               *
      *                                                               *
      *****************************************************************
      *
     C     SRBokCd       BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVIBOKC'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPRCTR - Profit Centre Validation                           *
      *                                                               *
      *****************************************************************
      *
     C     SRPrCtr       BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVIPRFC'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** STANDING DATA
      ** =============
      *
      ** SDGELR - Profit Centre Default Used
     C                   PARM                    BKPCDU
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST
      *
      ** ZMUSER - Department Code
     C                   PARM                    PDPPT
      *
      ** ZMUSER - User Id
     C                   PARM                    PUSRID
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT                                                                    CFT014
      *****************************************************************                       CGL014
      *                                                               *                       CGL014
      *  VSETBL  - Additional validation on settlement amount         *                       CGL014
      *                                                               *                       CGL014
      *****************************************************************                       CGL014
                                                                                              CGL014
     C     VSETBL        BEGSR                                                                CGL014
                                                                                              CGL014
      ** If third reimbursement, receiver's correspondent, or sender is a                     CGL014
      ** retail a/c, check if its available balance (after settlement) is                     CGL014
      ** sufficient to cover its blocked amount                                               CGL014
                                                                                              CGL014
     C                   IF        (OKTRIB <> 'N'  AND  PATYP5 = 'R')  OR                     CGL014
     C                             (OKRCO1 <> 'N'  AND  OKRCO2 <> 'N'  AND                    CGL014
     C                             OKRCO3 <> 'N'  AND  OKRCO4 <> 'N'  AND                     CGL014
     C                             OKRCO5 <> 'N'  AND  PATYP2 = 'R')  OR                      CGL014
     C                             (OKSND1 <> 'N'  AND  OKSND2 <> 'N'  AND                    CGL014
     C                             OKSND3 <> 'N'  AND  OKSND4 <> 'N'  AND                     CGL014
     C                             PATYP1 = 'R')                                              CGL014
                                                                                              CGL014
      ** Reset variables updated by each module                                               CGL014
                                                                                              CGL014
     C                   EXSR      SRResetErrs                                                CGL014
     C                   EVAL      Wx = 0                                                     CGL014
     C                   EVAL      Wwx = 0                                                    CGL014
                                                                                              CGL014
      ** Third reimbursement                                                                  CGL014
                                                                                              CGL014
     C                   SELECT                                                               CGL014
     C                   WHEN      PATYP5 = 'R'                                               CGL014
     C                   EVAL      WACCT = DDTRIB                                             CGL014
     C                   IF        W11TO18 = *BLANKS                                          CGL014
     C                   MOVEL     DDTRIB        PAACNO                                       CGL014
     C                   EVAL      WACCT = *BLANKS                                            CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      PAACNO = 0                                                 CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      ** Receiver's correspondent                                                             CGL014
                                                                                              CGL014
     C                   WHEN      PATYP2 = 'R'                                               CGL014
     C                   EVAL      WACCT = PRCCDS                                             CGL014
     C                   EVAL      PAACNO = 0                                                 CGL014
                                                                                              CGL014
      ** Sender                                                                               CGL014
                                                                                              CGL014
     C                   WHEN      PATYP1 = 'R'                                               CGL014
     C                   EVAL      WACCT = PSNDDS                                             CGL014
     C                   EVAL      PAACNO = 0                                                 CGL014
     C                   ENDSL                                                                CGL014
                                                                                              CGL014
     C                   Z-ADD     IPSMAM        PTAMNT                                       CGL014
                                                                                              CGL014
      ** Call validation module                                                               CGL014
                                                                                              CGL014
     C                   CALLB     'GL006000'                                                 CGL014
     C                   PARM                    PTAMNT                                       CGL014
     C                   PARM      DDSMCY        PTCCY                                        CGL014
     C                   PARM                    PABRCA                                       CGL014
     C                   PARM                    PACNUM                                       CGL014
     C                   PARM                    PACCY                                        CGL014
     C                   PARM                    PAACOD                                       CGL014
     C                   PARM                    PAACSQ                                       CGL014
     C                   PARM                    PAACNO                                       CGL014
     C                   PARM      *BLANKS       PRTCD                                        CGL014
                                                                                              CGL014
      ** Error:  Available balance is not sufficient                                          CGL014
      ** to cover blocked amount                                                              CGL014
                                                                                              CGL014
     C                   IF        PRTCD = '*BLKERR'                                          CGL014
     C                   EVAL      OKSMAM = 'N'                                               CGL014
     C                   ADD       1             Wx                                           CGL014
     C                   EVAL      FldNamXAr(Wx) = 'DDSMAM'                                   CGL014
     C                   EVAL      MsgIdXAr(Wx) = 'FTA0140'                                   CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      ** Warning:  Balance is greater than blocked amount but less                            CGL014
      ** than minimum balance; minimum balance will be exceeded                               CGL014
                                                                                              CGL014
     C                   IF        PRTCD = '*WARN  '                                          CGL014
     C                   EVAL      OKSMAM = 'W'                                               CGL014
     C                   ADD       1             Wwx                                          CGL014
     C                   EVAL      WFldNmXAr(Wwx) = 'DDSMAM'                                  CGL014
     C                   EVAL      WMsgIDXAr(Wwx) = 'FTA0141'                                 CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      ** Update error info with that returned from the validation module                      CGL014
                                                                                              CGL014
     C                   EXSR      SRUpdatErrs                                                CGL014
                                                                                              CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   ENDSR                                                                CGL014
                                                                                              CGL014
      *****************************************************************                       CGL014
     C/EJECT                                                                                  CGL014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SRTRIB  - Third Reimbursement validation                     *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
     C     SRTRIB        BEGSR                                                  CFT014
      *                                                                         CFT014
      ** Reset fields.                                                          CFT014
     C                   EXSR      SRResetErrs                                  CFT014
      *                                                                         CFT014
      ** Extract Receiver's Correspondents's account currency                   CFT014
     C     3             SUBST     PRCCDS:7      PRcvCorCcy        3            CFT014
      *                                                                         CFT014
      ** Call validation module                                                 CFT014
     C                   CALLB     'FTVITRIB'                                   CFT014
      ** O: Return Code                                                         CFT014
     C                   PARM      *BLANKS       RetCodeOut                     CFT014
      ***********                                                               CFT014
      ** INPUT **                                                               CFT014
      ***********                                                               CFT014
      ** Incoming Payments Lvl 1 Scrn details                                   CFT014
     C                   PARM                    NwIP1ScnFmt                    CFT014
      ** Incoming Payments Lvl 1 Scrn File 2 details                            CFT014
     C                   PARM                    NwIP1AScnFmt                   CFT014
      ** Sender's Correspondent Type from master file                           CFT014
     C                   PARM                    IPSNCT                         CFT014
      ** Receiver's Correspondent Type                                          CFT014
     C                   PARM                    IPINRCRT                       CFT014
      ** Receiver's Correspondent's account currency                            CFT014
     C                   PARM                    PRcvCorCcy                     CFT014
      ** Level Join indicator (SDFTFRPD)                                        CFT014
     C                   PARM                    BTLVJN                         CFT014
      ** Default branch code (SDBANKPD)                                         CFT014
     C                   PARM                    BJSBRC                         CFT014
      ** Multi-branching indicator                                              CFT014
     C                   PARM                    BGMBIN                         CFT014
      ** Retail module (SDMMODPD)                                               CFT014
     C                   PARM                    BGRTBN                         CFT014
      ** Interest on Accrual (SDMMODPD)                                         CFT014
     C                   PARM                    BGIOAC                         CFT014
      ** Retail Acc numbers (SDRETLPD)                                          CFT014
     C                   PARM                    BMRANR                         CFT014
      ** FT Batch Authorization and Credit Advices                              CFT014
     C                   PARM                    CFT004                         CFT014
      ************                                                              CFT014
      ** OUTPUT **                                                              CFT014
      ************                                                              CFT014
      ** Incoming Payments Valid extension file                                 CFT014
     C                   PARM                    NwIP2FilFmt                    CFT014
      ** O: Incoming Payments Lvl 1 Scrn Error indicators                       CFT014
     C                   PARM                    FTEIPY1                        CFT014
      ** Third Reimbursement Inst. Account Type                                 CFT014
     C                   PARM      *BLANK        PATYP5            1            CFT014
      ** Third Reimbursement Inst. Account Status                               CFT014
     C                   PARM      *BLANKS       PACST5            1            CFT014
      ** Third Reimbursement Inst. Date Account Opened                          CFT014
     C                   PARM      *ZERO         PDACO5            5 0          CFT014
      ** Third Reimbursement Inst. Full Account                                               250600
     C                   PARM                    PTRBDS           24                          250600
      ** I/O: Third Reimbursement Institution (previous)                        CFT014
     C                   PARM                    PPrvTRI                        CFT014
      ** Error fields/message IDs/message data (arrays) from/to caller          CFT014
     C                   PARM                    FldNamXAr                      CFT014
     C                   PARM                    MsgIDXAr                       CFT014
     C                   PARM                    MsgDtaXAr                      CFT014
     C                   PARM                    WFldNmXAr                      CFT014
     C                   PARM                    WMsgIDXAr                      CFT014
     C                   PARM                    WMsgDtXAr                      CFT014
      *                                                                         CFT014
     C                   IF        RetCodeOut <> *BLANKS                        CFT014
     C                   EXSR      SRUpdatErrs                                  CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDSR                                                  CFT014
      *****************************************************************         CFT014
      /EJECT                                                                    CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SROEXR  - Original Exchange Rate                             *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
     C     SROEXR        BEGSR                                                  CFT014
      *                                                                         CFT014
      ** Reset fields.                                                          CFT014
     C                   EXSR      SRResetErrs                                  CFT014
      *                                                                         CFT014
      ** Call validation module                                                 CFT014
     C                   CALLB     'FTVIOEXR'                                   CFT014
      *                                                                         CFT014
      ** O: Return Code                                                         CFT014
     C                   PARM                    RetCodeOut                     CFT014
      *                                                                         CFT014
      ***********                                                               CFT014
      ** INPUT **                                                               CFT014
      ***********                                                               CFT014
      *                                                                         CFT014
      ** Incoming Payments Lvl1 details                                         CFT014
     C                   PARM                    NwIP1ScnFmt                    CFT014
      ** Incoming Payments Lvl1 file 2 details                                  CFT014
     C                   PARM                    NwIP1AScnFmt                   CFT014
      ** Pay Amount                                                             CFT014
     C                   PARM                    IPPYAM                         CFT014
      ** Pay Amount's number of decimal places                                  CFT014
     C                   PARM                    PPayNumDP                      CFT014
      ** Instructed Amount                                                      CFT014
     C                   PARM                    IPNDAM                         CFT014
      ** Instructed Amount's number of decimal places                           CFT014
     C                   PARM                    PNotNumDP                      CFT014
      ** Percent Rate Discrepancy (SDFTFRPD)                                    CFT014
     C                   PARM                    BTPCRD                         CFT014
      *                                                                         CFT014
      ************                                                              CFT014
      ** Output **                                                              CFT014
      ************                                                              CFT014
      *                                                                         CFT014
      ** Incoming Payments Valid extension file                                 CFT014
     C                   PARM                    NwIP2FilFmt                    CFT014
      ** Incoming Payments Lvl 1 Scrn error indicators                          CFT014
     C                   PARM                    FTEIPY1                        CFT014
      ** Error fields/message IDs/message data (arrays) from/to caller          CFT014
     C                   PARM                    FldNamXAr                      CFT014
     C                   PARM                    MsgIDXAr                       CFT014
     C                   PARM                    MsgDtaXAr                      CFT014
      *                                                                         CFT014
     C                   IF        RetCodeOut <> *BLANKS                        CFT014
     C                   EXSR      SRUpdatErrs                                  CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDSR                                                  CFT014
      *****************************************************************         CFT014
      /EJECT                                                                    CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SRIDFT  - Set-up default for Instructed Amount/Currency      *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
     C     SRIDFT        BEGSR                                                  CFT014
      *                                                                         CFT014
     C                   IF        IPSNTP <> 'F' and IPSNTP <> 'R' and          CFT014
     C                             IPSNTP <> 'G' and IPSNTP <> 'C' and          CFT014
     C                             IPSNTP <> 'S'                                CFT014
     C                   GOTO      EXIDFT                                       CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Check for Support Charge Transparency flag for                         CFT014
      ** Sender Country Code.                                                   CFT014
      *                                                                         CFT014
     C                   IF        IPSNTP = 'F' or IPSNTP = 'R' or              CFT014
     C                             IPSNTP = 'G'                                 CFT014
     C     6             SUBST     PSNDDS:1      WSCNUM            6            CFT014
      *                                                                         CFT014
      ** Retrieve Customer details of Sender.                                   CFT014
      *                                                                         CFT014
     C                   CALL      'AOCUSTR0'                                   CFT014
     C                   PARM      *BLANKS       PRTCD             7            CFT014
     C                   PARM      '*KEY   '     POPTN             7            CFT014
     C                   PARM      WSCNUM        PKEY1            10            CFT014
     C                   PARM      *BLANK        PKYST             7            CFT014
     C     SDCUST        PARM      SDCUST        DSSDY                          CFT014
      *                                                                         CFT014
     C     PRTCD         IFNE      *BLANKS                                      CFT014
     C     PKYST         ORNE      '*CNUM'                                      CFT014
     C                   Z-ADD     1             DBASE                          CFT014
     C                   MOVEL     WSCNUM        DBKEY                          CFT014
     C                   MOVEL     'SDCUSTPD'    DBFILE                         CFT014
     C                   EXSR      *PSSR                                        CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ELSE                                                   CFT014
      ** SWIFT ID or Customer                                                   CFT014
     C                   MOVEL     PSNDCSID      BBCSID                         CFT014
     C                   MOVEL     PSNDCOLC      BBCOLC                         CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** If BBCSID field is not blank, use the 5-6 positions                    CFT014
      ** of the field to chain to MEISOCL1.                                     CFT014
      *                                                                         CFT014
     C     BBCSID        IFNE      *BLANKS                                      CFT014
     C     2             SUBST     BBCSID:5      W0506W            2            CFT014
     C     W0506W        CHAIN     MEISOCL1                           88        CFT014
      *                                                                         CFT014
     C     *IN88         IFEQ      *ON                                          CFT014
     C     M3SCHT        ORNE      'Y'                                          CFT014
     C                   GOTO      EXIDFT                                       CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ELSE                                                   CFT014
      *                                                                         CFT014
     C     BBCOLC        IFNE      *BLANKS                                      CFT014
      *                                                                         CFT014
      ** Retrieve Country Code details of Sender.                               CFT014
      *                                                                         CFT014
     C                   CALL      'AOCTRYR0'                                   CFT014
     C                   PARM      *BLANKS       PRTCD                          CFT014
     C                   PARM      '*KEY   '     POPTN                          CFT014
     C                   PARM      BBCOLC        PCNCD             2            CFT014
     C     SDCTRY        PARM      SDCTRY        DSSDY                          CFT014
      *                                                                         CFT014
     C     PRTCD         IFNE      *BLANKS                                      CFT014
     C                   Z-ADD     2             DBASE                          CFT014
     C                   MOVEL     BBCOLC        DBKEY                          CFT014
     C                   MOVEL     'SDCTRYPD'    DBFILE                         CFT014
     C                   EXSR      *PSSR                                        CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Use A4ISOC from Country Code details to chain                          CFT014
      ** to MEISOCL1.                                                           CFT014
      *                                                                         CFT014
     C     A4ISOC        CHAIN     MEISOCL1                           88        CFT014
      *                                                                         CFT014
     C     *IN88         IFEQ      *ON                                          CFT014
     C     M3SCHT        ORNE      'Y'                                          CFT014
     C                   GOTO      EXIDFT                                       CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ELSE                                                   CFT014
      *                                                                         CFT014
     C                   GOTO      EXIDFT                                       CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Check for Support Charge Transparency flag for                         CFT014
      ** Receiver Country Code.                                                 CFT014
      *                                                                         CFT014
     C                   IF        BGMBIN = 'Y'                                 CFT014
     C                   MOVE      DDBRCA        WRBRCH            3            CFT014
     C                   ELSE                                                   CFT014
     C                   MOVE      BJSBRC        WRBRCH                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Retrieve Branch details of Booking Branch or                           CFT014
      ** Single-Branch code.                                                    CFT014
      *                                                                         CFT014
     C**********         CALL      'AOBRCHR0'                                          CFT014 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD                          CFT014
     C                   PARM      '*KEY   '     POPTN                          CFT014
     C                   PARM      WRBRCH        PBRCD             3            CFT014
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                 CFT014 CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *                                                                         CFT014
     C     @RTCD         IFNE      *BLANKS                                      CFT014
     C                   Z-ADD     3             DBASE                          CFT014
     C                   MOVEL     WRBRCH        DBKEY                          CFT014
     C                   MOVEL     'SDBRCHPD'    DBFILE                         CFT014
     C                   EXSR      *PSSR                                        CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** If A8BTID field is not blank, use the 5-6 positions                    CFT014
      ** of the field from Branch details to chain to MEISOCL1.                 CFT014
      *                                                                         CFT014
     C     A8BTID        IFNE      *BLANKS                                      CFT014
     C     2             SUBST     A8BTID:5      W0506W                         CFT014
     C     W0506W        CHAIN     MEISOCL1                           88        CFT014
      *                                                                         CFT014
     C     *IN88         IFEQ      *ON                                          CFT014
     C     M3SCHT        ORNE      'Y'                                          CFT014
     C                   GOTO      EXIDFT                                       CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ELSE                                                   CFT014
      *                                                                         CFT014
     C     A8LCCD        IFNE      *BLANKS                                      CFT014
      *                                                                         CFT014
      ** Retrieve Location Code details of Branch.                              CFT014
      *                                                                         CFT014
     C                   CALL      'AOLOCNR0'                                   CFT014
     C                   PARM      *BLANKS       PRTCD                          CFT014
     C                   PARM      '*KEY   '     POPTN                          CFT014
     C                   PARM      A8LCCD        PLCCD             3            CFT014
     C     SDLOCN        PARM      SDLOCN        DSSDY                          CFT014
      *                                                                         CFT014
     C     PRTCD         IFNE      *BLANKS                                      CFT014
     C                   Z-ADD     4             DBASE                          CFT014
     C                   MOVEL     A8LCCD        DBKEY                          CFT014
     C                   MOVEL     'SDLOCNPD'    DBFILE                         CFT014
     C                   EXSR      *PSSR                                        CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Retrieve Country Code details.                                         CFT014
      *                                                                         CFT014
     C                   CALL      'AOCTRYR0'                                   CFT014
     C                   PARM      *BLANKS       PRTCD                          CFT014
     C                   PARM      '*KEY   '     POPTN                          CFT014
     C                   PARM      DVCNCD        PCNCD             2            CFT014
     C     SDCTRY        PARM      SDCTRY        DSSDY                          CFT014
      *                                                                         CFT014
     C     PRTCD         IFNE      *BLANKS                                      CFT014
     C                   Z-ADD     5             DBASE                          CFT014
     C                   MOVEL     DVCNCD        DBKEY                          CFT014
     C                   MOVEL     'SDCTRYPD'    DBFILE                         CFT014
     C                   EXSR      *PSSR                                        CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Use A4ISOC from Country Code details to chain                          CFT014
      ** to MEISOCL1.                                                           CFT014
      *                                                                         CFT014
     C     A4ISOC        CHAIN     MEISOCL1                           88        CFT014
      *                                                                         CFT014
     C     *IN88         IFEQ      *ON                                          CFT014
     C     M3SCHT        ORNE      'Y'                                          CFT014
     C                   GOTO      EXIDFT                                       CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ELSE                                                   CFT014
      *                                                                         CFT014
      ** Retrieve Customer details of Branch Internal Customer.                 CFT014
      *                                                                         CFT014
     C                   CALL      'AOCUSTR0'                                   CFT014
     C                   PARM      *BLANKS       PRTCD                          CFT014
     C                   PARM      '*KEY   '     POPTN                          CFT014
     C                   PARM      A8BICN        PKEY1                          CFT014
     C                   PARM      *BLANK        PKYST                          CFT014
     C     SDCUST        PARM      SDCUST        DSSDY                          CFT014
      *                                                                         CFT014
     C     PRTCD         IFNE      *BLANKS                                      CFT014
     C     PKYST         ORNE      '*CNUM'                                      CFT014
     C                   Z-ADD     5             DBASE                          CFT014
     C                   MOVEL     A8BICN        DBKEY                          CFT014
     C                   MOVEL     'SDCUSTPD'    DBFILE                         CFT014
     C                   EXSR      *PSSR                                        CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** If SWIFT Id is not blank, chain to MEISOCL1 using                      CFT014
      ** positions 5 to 6 of the field.                                         CFT014
      *                                                                         CFT014
     C     BBCSID        IFNE      *BLANKS                                      CFT014
     C     2             SUBST     BBCSID:5      W0506W                         CFT014
     C     W0506W        CHAIN     MEISOCL1                           88        CFT014
      *                                                                         CFT014
     C     *IN88         IFEQ      *ON                                          CFT014
     C     M3SCHT        ORNE      'Y'                                          CFT014
     C                   GOTO      EXIDFT                                       CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ELSE                                                   CFT014
      *                                                                         CFT014
      ** Retrieve Country Code details of Branch Internal                       CFT014
      ** Customer.                                                              CFT014
      *                                                                         CFT014
     C                   CALL      'AOCTRYR0'                                   CFT014
     C                   PARM      *BLANKS       PRTCD                          CFT014
     C                   PARM      '*KEY   '     POPTN                          CFT014
     C                   PARM      BBCOLC        PCNCD                          CFT014
     C     SDCTRY        PARM      SDCTRY        DSSDY                          CFT014
      *                                                                         CFT014
     C     @RTCD         IFNE      *BLANKS                                      CFT014
     C                   Z-ADD     6             DBASE                          CFT014
     C                   MOVEL     BBCOLC        DBKEY                          CFT014
     C                   MOVEL     'SDCTRYPD'    DBFILE                         CFT014
     C                   EXSR      *PSSR                                        CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Use A4ISOC from Country Code details to chain                          CFT014
      ** to MEISOCL1.                                                           CFT014
      *                                                                         CFT014
     C     A4ISOC        CHAIN     MEISOCL1                           88        CFT014
      *                                                                         CFT014
     C     *IN88         IFEQ      *ON                                          CFT014
     C     M3SCHT        ORNE      'Y'                                          CFT014
     C                   GOTO      EXIDFT                                       CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
     C                   ENDIF                                                  CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** At this point, Support Charge Transparency flag is 'Y'                 CFT014
      ** for both Sender and Receiver.  Default Instructed Currency             CFT014
      ** and Amount to Settlement Currency and Amount.                          CFT014
      *                                                                         CFT014
     C                   MOVE      DDSMCY        DDNDCY                         CFT014
     C                   MOVE      DDNDCY        IPNDCY                                       213026
      *                                                                         CFT014
      ** Save Settle Currency details to Instructed Currency                    CFT014
      ** details.                                                               CFT014
      *                                                                         CFT014
     C                   MOVE      PSetInCy      PNotInCy                       CFT014
     C                   MOVE      PSetTPSD      PNotTPSD                       CFT014
     C                   MOVE      PSetNumDP     PNotNumDP                      CFT014
      *                                                                         CFT014
     C                   Z-ADD     IPSMAM        IPNDAM                         CFT014
      *                                                                         CFT014
      ** Format Instructed Amount for display.                                  CFT014
      *                                                                         CFT014
     C                   MOVE      *BLANK        ZFIELD                         CFT014
     C                   MOVE      IPNDAM        ZFIELD                         CFT014
     C                   Z-ADD     PNotNumDP     ZADEC2                         CFT014
      *                                                                         CFT014
     C                   CALLB     'ZAEDITM'                                    CFT014
     C                   PARM                    ZFIELD           16            CFT014
     C                   PARM                    ZADEC2            2 0          CFT014
      *                                                                         CFT014
     C                   MOVE      ZFIELD        DDNDAM                         CFT014
      *                                                                         CFT014
     C     EXIDFT        ENDSR                                                  CFT014
      *****************************************************************         CFT014
     C/EJECT                                                                    CFT009
      *****************************************************************         CFT009
      *                                                               *         CFT009
      *  VFXSP     - Validate FX Spread Set                           *         CFT009
      *                                                               *         CFT009
      *****************************************************************         CFT009
                                                                                CFT009
     C     VFXSP         BEGSR                                                  CFT009
                                                                                CFT009
      ** Reset variables updated by other modules                               CFT009
                                                                                CFT009
     C                   EXSR      SRRESETERRS                                  CFT009
                                                                                CFT009
      ** Validate FX Spread Set                                                 CFT009
                                                                                CFT009
     C                   CALLB     'FTVIFXSP'                                   CFT009
     C                   PARM                    RETCODEOUT                     CFT009
     C                   PARM                    NWIP1SCNFMT                    CFT009
     C                   PARM                    NWIP1ASCNFMT                   CFT009
     C                   PARM                    NWIP2FILFMT                    CFT009
     C                   PARM                    FTEIPY1                        CFT009
     C                   PARM                    FLDNAMXAR                      CFT009
     C                   PARM                    MSGIDXAR                       CFT009
     C                   PARM                    MSGDTAXAR                      CFT009
                                                                                CFT009
      ** Update error info with that returned from the validation module        CFT009
                                                                                CFT009
     C                   EXSR      SRUPDATERRS                                  CFT009
                                                                                CFT009
     C                   ENDSR                                                  CFT009
     C/EJECT                                                                    CFT009
      *****************************************************************         CFT009
      *                                                               *         CFT009
      *  VOFCD     - Validate Payment Date Offset Code                *         CFT009
      *                                                               *         CFT009
      *****************************************************************         CFT009
                                                                                CFT009
     C     VOFCD         BEGSR                                                  CFT009
                                                                                CFT009
      ** Reset variables updated by other modules                               CFT009
                                                                                CFT009
     C                   EXSR      SRRESETERRS                                  CFT009
                                                                                CFT009
      ** Validate Payment Date Offset Code                                      CFT009
                                                                                CFT009
     C                   CALLB     'FTVIPYCD'                                   CFT009
     C                   PARM                    RETCODEOUT                     CFT009
     C                   PARM                    NWIP1SCNFMT                    CFT009
     C                   PARM                    NWIP1ASCNFMT                   CFT009
     C                   PARM                    NWIP2FILFMT                    CFT009
     C                   PARM                    FTEIPY1                        CFT009
     C                   PARM                    FLDNAMXAR                      CFT009
     C                   PARM                    MSGIDXAR                       CFT009
     C                   PARM                    MSGDTAXAR                      CFT009
                                                                                CFT009
      ** Update error info with that returned from the validation module        CFT009
                                                                                CFT009
     C                   EXSR      SRUPDATERRS                                  CFT009
                                                                                CFT009
     C                   ENDSR                                                  CFT009
     C/EJECT                                                                    CDL049
      *****************************************************************         CDL049
      *                                                               *         CDL049
      *  VRRAT     - Validate Reference Rate field                    *         CDL049
      *                                                               *         CDL049
      *****************************************************************         CDL049
                                                                                CDL049
     C     VRRAT         BEGSR                                                  CDL049
                                                                                CDL049
      ** Reset variables updated by other modules                               CDL049
                                                                                CDL049
     C                   EXSR      SRRESETERRS                                  CDL049
                                                                                CDL049
      ** Validate Reference Rate field                                          CDL049
                                                                                CDL049
     C                   CALLB     'FTVIRRAT'                                   CDL049
     C                   PARM                    RETCODEOUT                     CDL049
     C                   PARM                    NwIP1ScnFmt                    CDL049
     C                   PARM                    FLDNAMXAR                      CDL049
     C                   PARM                    MSGIDXAR                       CDL049
     C                   PARM                    MSGDTAXAR                      CDL049
     C                   PARM                    WFLDNMXAR                      CDL049
     C                   PARM                    WMSGIDXAR                      CDL049
     C                   PARM                    WMSGDTXAR                      CDL049
     C                   PARM                    IPRATE                         CDL049
     C                   PARM                    IPRRAT                         CDL049
                                                                                CDL049
      ** Update error info with that returned from the validation module        CDL049
                                                                                CDL049
     C                   EXSR      SRUPDATERRS                                  CDL049
                                                                                CDL049
     C                   ENDSR                                                  CDL049
      *****************************************************************         CFT009
      /EJECT                                                                    CFT009
      *****************************************************************         CFT009
      * DFTCHG - Default charges                                                CFT009
      *****************************************************************         CFT009
     C     DFTCHG        BEGSR                                                  CFT009
                                                                                CFT009
      * Reset variables updated by each module                                  CFT009
     C                   EXSR      SRRESETERRS                                  CFT009
      *                                                                         CFT009
     C                   CALLB     'FTIPAY1DT'                                  CFT009
      *                                                                         CFT009
      ** Return Code                                                            CFT009
     C                   PARM                    RETCODEIN                      CFT009
      *  Screen fields                                                          CFT009
     C                   PARM                    NWIP1SCNFMT                    CFT009
     C                   PARM                    NWIP1ASCNFMT                   CFT009
      *                                                                         CFT009
      ** Base Currency No. of Decimal Places                                    CFT009
     C                   PARM                    PBCDP                          CFT009
      *                                                                         CFT009
      ** Sender's Account Type                                                  CFT009
     C                   PARM                    PATYP1                         CFT009
      *                                                                         CFT009
      ** Sender's Account Status                                                CFT009
     C                   PARM                    PACST1                         CFT009
      *                                                                         CFT009
      ** Sender's Date Account Opened                                           CFT009
     C                   PARM                    PDACO1                         CFT009
      *                                                                         CFT009
      ** RCorr's Account Type                                                   CFT009
     C                   PARM                    PATYP2                         CFT009
      *                                                                         CFT009
      ** RCorr's Account Status                                                 CFT009
     C                   PARM                    PACST2                         CFT009
      *                                                                         CFT009
      ** RCorr's Date Account Opened                                            CFT009
     C                   PARM                    PDACO2                         CFT009
      *                                                                         CFT009
      ** Beneficiary Customer's Account Type                                    CFT009
     C                   PARM                    PATYP3                         CFT009
      *                                                                         CFT009
      ** Beneficiary Customer's Account Status                                  CFT009
     C                   PARM                    PACST3                         CFT009
      *                                                                         CFT009
      ** Beneficiary Customer's Date Account Opened                             CFT009
     C                   PARM                    PDACO3                         CFT009
      *                                                                         CFT009
      ** A/c with Bank's Account Type                                           CFT009
     C                   PARM                    PATYP4                         CFT009
      *                                                                         CFT009
      ** A/c with Bank's Account Status                                         CFT009
     C                   PARM                    PACST4                         CFT009
      *                                                                         CFT009
      ** A/c with Bank's Date Account Opened                                    CFT009
     C                   PARM                    PDACO4                         CFT009
      *                                                                         CFT009
      ** Third Reimbursement Inst. Account Type                                 CFT009
     C                   PARM                    PATYP5                         CFT009
      *                                                                         CFT009
      ** Third Reimbursement Inst. Account Status                               CFT009
     C                   PARM                    PACST5                         CFT009
      *                                                                         CFT009
      ** Third Reimbursement Inst. Date Account Opened                          CFT009
     C                   PARM                    PDACO5                         CFT009
      *                                                                         CFT009
      ** Account needed to set payment value date                               CFT009
     C                   PARM                    PPYFLDS                        CFT009
      *                                                                         CFT009
      ** STANDING DATA                                                          CFT009
      ** =============                                                          CFT009
      *                                                                         CFT009
      ** SDBANK - Base Currency Code                                            CFT009
     C                   PARM                    BJCYCD            3            CFT009
      *                                                                         CFT009
      ** SDBANK - Local Currency Code                                           CFT009
     C                   PARM                    BJLCCY            3            CFT009
      *                                                                         CFT009
      ** SDFTFR - Charges Currency                                              CFT009
     C                   PARM                    BTCHCY            1            CFT009
      *                                                                         CFT009
      ** SDFTFR - Fixed Charge Currency                                         CFT009
     C                   PARM                    FCHCCY            3            CFT009
      *                                                                         CFT009
      ** SDFTFR - Charges calculated in transaction ccy                         CFT009
     C                   PARM                    CHTRCY            1            CFT009
      *                                                                         CFT009
      ** VAT Rate                                                               CFT009
     C                   PARM                    PVATR             5 4          CFT009
      *                                                                         CFT009
      ** SDBANK - Date Format Indicator                                         CFT009
     C                   PARM                    BJDFIN                         CFT009
      *                                                                         CFT009
      ** SDBANK - Midas Run Date                                                CFT009
     C                   PARM                    BJRDNB                         CFT009
      *                                                                         CFT009
      ** SDBANK - Back Value Period in Days                                     CFT009
     C                   PARM                    BJBVPD                         CFT009
      *                                                                         CFT009
      ** SDBANK - System Location Code                                          CFT009
     C                   PARM                    BJSLCD                         CFT009
      *                                                                         CFT009
      ** SWITCHABLE FEATURES                                                    CFT009
      ** ===================                                                    CFT009
      *                                                                         CFT009
      ** Fees & Charges (VAT)                                                   CFT009
     C                   PARM                    CFT010            1            CFT009
      *                                                                         CFT009
      ** BLI FT Enhancements Feature                                            CFT009
     C                   PARM                    S01494            1            CFT009
      *                                                                         CFT009
      ** MT103 Messages Generation for FT                                       CFT009
     C                   PARM                    CFT014                         CFT009
     C/COPY WNCPYSRC,FTH00549
      *                                                                         CFT009
      ** OUTPUT                                                                 CFT009
      ** ======                                                                 CFT009
      *                                                                         CFT009
     C                   PARM                    NWIP5SCNFMT                    CFT009
      *  Error fields/message IDs/message data (arrays) from/to caller          CFT009
     C                   PARM                    FLDNAMXAR                      CFT009
     C                   PARM                    MSGIDXAR                       CFT009
     C                   PARM                    MSGDTAXAR                      CFT009
                                                                                CFT009
     C                   PARM                    WFLDNMXAR                      CFT009
     C                   PARM                    WMSGIDXAR                      CFT009
     C                   PARM                    WMSGDTXAR                      CFT009
      *  OK Flags                                                               CFT009
     C                   PARM                    FTEIPY1                        CFT009
      * Valid payment layout (DS) from/to caller                                CFT009
     C                   PARM                    NWIPFILFMT                     CFT009
     C                   PARM                    NWIP2FILFMT                    CFT009
      *                                                                         CFT009
      ** Charges Amount                                                         CFT009
     C                   PARM                    PCHARGES        196            CFT009
      *                                                                         CFT009
      ** Input Charge Currency                                                  CFT009
     C                   PARM                    PICCY                          CFT009
      *                                                                         CFT009
      ** Output Charge Currency                                                 CFT009
     C                   PARM                    POCCY                          CFT009
      *                                                                         CFT009
      ** Input Charge Currency No. of Decimal Places                            CFT009
     C                   PARM                    PINBDP                         CFT009
      *                                                                         CFT009
      ** Output Charge Currency No. of Decimal Places                           CFT009
     C                   PARM                    PONBDP                         CFT009
                                                                                CFT009
      ** Update error info with that returned from the validation module        CFT009
                                                                                CFT009
     C                   EXSR      SRUPDATERRS                                  CFT009
                                                                                CFT009
     C                   ENDSR                                                  CFT009
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRESETERRS - Routine to reset Error Information that is     *
      *                received from each validation module           *
      *                                                               *
      *****************************************************************
      *
     C     SRResetErrs   BEGSR
      *
     C                   EVAL      RetCodeOut = *BLANKS
      *
      ** Reset error and warning fields/message IDs/message
      ** data (arrays).
      *
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr  = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
      *
     C                   EVAL      WFldNmXAr = *BLANKS
     C                   EVAL      WMsgIDXAr = *BLANKS
     C                   EVAL      WMsgDtXAr = *BLANKS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPDATERRS - Routine to update Error Information with that  *
      *                received back from each validation module      *
      *                                                               *
      *****************************************************************
      *
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
     C     Ix            SUB       1             IDX
     C                   ELSE
     C                   EVAL      Ix = ArrayMax
     C                   MOVE      *BLANKS       FLDNAMEARR(Ix)
     C                   MOVE      *BLANKS       MSGIDARR(Ix)
     C                   MOVE      *BLANKS       MSGDTAARR(Ix)
     C                   Eval      IDX = ArrayMax - 1
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
     C     Ix            SUB       1             WIDX
     C                   ELSE
     C                   EVAL      Ix = ArrayMax
     C                   MOVE      *BLANKS       WFLDNAMARR(Ix)
     C                   MOVE      *BLANKS       WMSGIDARR(Ix)
     C                   MOVE      *BLANKS       WMSGDTAARR(Ix)
     C                   Eval      WIDX = ArrayMax - 1
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode             6
      *
      ** Response Mode
     C                   PARM                    PResponse
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *                                                                         CFT014
      ** Incoming Payments Lvl 1 Scrn 1/2 details from Incoming trans.          CFT014
     C                   PARM                    NwIP1aScnFmt                   CFT014
      *                                                                         CFT009
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction       CFT009
      ** - screen format                                                        CFT009
     C                   PARM                    NWIP5SCNFMT                    CFT009
      *                                                                         CFT014
      ** Third Reimbursement Institution (previous)                             CFT014
     C                   PARM                    PPrvTRI          34            CFT014
      *                                                                         CFT014
      ** Previous Instructed Amount                                             CFT014
     C                   PARM                    PPrvNDAM         14            CFT014
      *
      ** Base Currency No. of Decimal Places
     C                   PARM                    PBCDP             1 0
      *
      ** Payment Type
     C                   PARM                    PPYTP             2
      *
      ** Incoming Payments Lvl 1 Scrn details retrieved from file
      ** - screen format
     C                   PARM                    CrIP1ScnFmt
      *
      ** Incoming Payments extra data
     C                   PARM                    PExtData
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD            3
      *
      ** SDBANK - Midas Run Date
     C                   PARM                    BJRDNB            5 0
      *
      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY            3
      *
      ** SDBANK - Location Code
     C                   PARM                    BJSLCD            3
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC            3
      *
      ** SDBANK - Back Value Period in Days
     C                   PARM                    BJBVPD            3 0
      *
      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN            1
      *
      ** SDGELR - Currency Code for Euro
     C                   PARM                    BKEURO            3
      *
      ** SDGELR - Profit Centre Default Used
     C                   PARM                    BKPCDU            1
      *
      ** SDGELR - Profit Centre Used
     C                   PARM                    BKPRCU            1
      *
      ** SDGELR - Originating Branch Used
     C                   PARM                    BKOBRU            1
      *
      ** SDGELR - Originating Branch/User Vald Req.
     C                   PARM                    BKOBUV            1
      *
      ** SDMMOD - Retail Banking
     C                   PARM                    BGRTBN            1
      *
      ** SDMMOD - Multibranch Indicator
     C                   PARM                    BGMBIN            1
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST            1
      *
      ** SDMMOD - Dealing Foreign Exchange
     C                   PARM                    BGDLFX            1
      *
      ** SDMMOD - Dealing Money Market
     C                   PARM                    BGDLMM            1
      *
      ** SDRETL - Retail A/c Number Required?
     C                   PARM                    BMRANR            1
      *                                                                         CFT014
      ** SDFTFR - Level Join indicator                                          CFT014
     C                   PARM                    BTLVJN            1            CFT014
      ** SDFTFR - Percent Rate Discrepancy                                      CFT014
     C                   PARM                    BTPCRD            5 2          CFT014
      *                                                                         CFT014
      ** SDMMOD - Interest on Accrual                                           CFT014
     C                   PARM                    BGIOAC            1            CFT014
      *
      ** ZMUSER - Department Code
     C                   PARM                    PDPPT             3
      *
      ** ZMUSER - User Id
     C                   PARM                    PUSRID           10
      *                                                                         CFT009
      ** SDFTFR - Charges Currency                                              CFT009
     C                   PARM                    BTCHCY            1            CFT009
      *                                                                         CFT009
      ** SDFTFR - Fixed Charge Currency                                         CFT009
     C                   PARM                    FCHCCY            3            CFT009
      *                                                                         CFT009
      ** SDFTFR - Charges calculated in transaction ccy                         CFT009
     C                   PARM                    CHTRCY            1            CFT009
      *                                                                         CFT009
      ** VAT Rate                                                               CFT009
     C                   PARM                    PVATR             5 4          CFT009
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU FT Settlement Currency Conversion
     C                   PARM                    CEU006            1
      *
      ** Electronic Banking Interface IATs and TPPs
     C                   PARM                    CGL009            1
      *
      ** IBAN numbers
     C                   PARM                    CFT004            1
      *                                                                         CFT014
      ** STP Phase 2 MT103                                                      CFT014
     C                   PARM                    CFT014            1            CFT014
     C/COPY WNCPYSRC,FTIPA1VC13
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009            1            CFT009
     C                   PARM                    CFT010            1            CFT009
      *                                                                         CFT009
      ** BLI FT Enhancements Feature                                            CFT009
     C                   PARM                    S01494            1            CFT009
                                                                                              CGL014
      ** Collaterals Processing                                                               CGL014
                                                                                              CGL014
     C                   PARM                    CGL014                                       CGL014
     C/COPY WNCPYSRC,FTIPA1VC01
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
     C                   PARM                    IDx
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIDx
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *                                                                         CFT014
      ** Incoming Payments (additional details) for file update                 CFT014
     C                   PARM                    NwIP2FilFmt                    CFT014
      *
      ** Charges Branch
     C                   PARM                    PPYBR
      *
      ** Account with Bank's full account
     C                   PARM                    PACBDS
      *
      ** Sender's full account
     C                   PARM                    PSNDDS
      *
      ** Receiver Correspondence's full account
     C                   PARM                    PRCCDS
      *                                                                                       250600
      ** Third Reimbursemnt Party  full account                                               250600
     C                   PARM                    PTRBDS                                       250600
      *
      ** Beneficiary's full account
     C                   PARM                    PBNCDS
      *
      ** IBANs full account
     C                   PARM                    PIBANAcc
      *
      ** Settlement In Currency Indicator
     C                   PARM                    PSetInCy
      *
      ** Settlement EMU Transaction Period Start Date
     C                   PARM                    PSetTPSD
      *
      ** Payment In Currency Indicator
     C                   PARM                    PPayInCy
      *
      ** Payment EMU Transaction Period Start Date
     C                   PARM                    PPayTPSD
     C/COPY WNCPYSRC,FTIPA1VC14
      *                                                                         CFT009
      ** Charges Amount                                                         CFT009
     C                   PARM                    PCHARGES                       CFT009
      *                                                                         CFT009
      ** Input Charge Currency                                                  CFT009
     C                   PARM                    PICCY                          CFT009
      *                                                                         CFT009
      ** Output Charge Currency                                                 CFT009
     C                   PARM                    POCCY                          CFT009
      *                                                                         CFT009
      ** Input Charge Currency No. of Decimal Places                            CFT009
     C                   PARM                    PINBDP                         CFT009
      *                                                                         CFT009
      ** Output Charge Currency No. of Decimal Places                           CFT009
     C                   PARM                    PONBDP                         CFT009
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
     C                   PARM                    BENEDrBlck        1                        MD025111
     C/COPY WNCPYSRC,FTIPA1VC24
                                                                                              CAP084
      ** Access SAR file to determine if CFT003 (Batch Authorisation)                         CAP084
      ** is installed.                                                                        CAP084
                                                                                              CAP084
     C                   CALLB     'AOSARDR0'                                                 CAP084
     C                   PARM      *BLANKS       PRTCD                                        CAP084
     C                   PARM      '*VERIFY'     POPTN                                        CAP084
     C                   PARM      'CFT003'      PSARD             6                          CAP084
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP084
                                                                                              CAP084
     C     PRTCD         IFEQ      *BLANK                                                     CAP084
     C                   MOVEL     'Y'           CFT003            1                          CAP084
     C                   ELSE                                                                 CAP084
     C                   MOVEL     'N'           CFT003                                       CAP084
     C                   ENDIF                                                                CAP084
     C/COPY WNCPYSRC,FTH00174
                                                                                              CDL049
      ** Access SAR file to determine if CDL049 (Additional Reference Rate)                   CDL049
      ** is installed.                                                                        CDL049
                                                                                              CDL049
     C                   CALLB     'AOSARDR0'                                                 CDL049
     C                   PARM      *BLANKS       PRTCD                                        CDL049
     C                   PARM      '*VERIFY'     POPTN                                        CDL049
     C                   PARM      'CDL049'      PSARD             6                          CDL049
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL049
                                                                                              CDL049
     C     PRTCD         IFEQ      *BLANK                                                     CDL049
     C                   MOVEL     'Y'           CDL049            1                          CDL049
     C                   ELSE                                                                 CDL049
     C                   MOVEL     'N'           CDL049                                       CDL049
     C                   ENDIF                                                                CDL049
      *                                                                                     AR798055
      ** Access System Values                                                               AR798055
      *                                                                                     AR798055
     C                   EVAL      P@OP01 = *Blanks                                         AR798055
      *                                                                                     AR798055
     C                   CALL      'AOSVALR0'                                               AR798055
     C                   PARM      *BLANKS       PRetCode          7                        AR798055
     C                   PARM      SysValOne     P@OP01           20                        AR798055
     C                   PARM      *BLANKS       P@VL01          200                        AR798055
     C                   PARM      *BLANKS       P@OP02           20                        AR798055
     C                   PARM      *BLANKS       P@VL02          200                        AR798055
     C                   PARM      *BLANKS       P@OP03           20                        AR798055
     C                   PARM      *BLANKS       P@VL03          200                        AR798055
     C                   PARM      *BLANKS       P@OP04           20                        AR798055
     C                   PARM      *BLANKS       P@VL04          200                        AR798055
     C                   PARM      *BLANKS       P@OP05           20                        AR798055
     C                   PARM      *BLANKS       P@VL05          200                        AR798055
     C                   PARM      *BLANKS       P@OP06           20                        AR798055
     C                   PARM      *BLANKS       P@VL06          200                        AR798055
     C                   PARM      *BLANKS       P@OP07           20                        AR798055
     C                   PARM      *BLANKS       P@VL07          200                        AR798055
     C                   PARM      *BLANKS       P@OP08           20                        AR798055
     C                   PARM      *BLANKS       P@VL08          200                        AR798055
     C                   PARM      *BLANKS       P@OP09           20                        AR798055
     C                   PARM      *BLANKS       P@VL09          200                        AR798055
     C                   PARM      *BLANKS       P@OP10           20                        AR798055
     C                   PARM      *BLANKS       P@VL10          200                        AR798055
      *                                                                                     AR798055
     C                   IF        PRetCode  <> *BLANKS                                     AR798055
     C                   EVAL      DBPGM = 'FTIPAY1VL'                                      AR798055
     C                   EVAL      DBFILE = 'SDSVALPD'                                      AR798055
     C                   EVAL      DBKEy = '*KEY   '                                        AR798055
     C                   EVAL      DBase = 880                                              AR798055
     C                   EXSR      *PSSR                                                    AR798055
     C                   ELSE                                                               AR798055
      *                                                                                     AR798055
     C                   IF        P@VL01 = 'Y'                                             AR798055
     C                   MOVEL     'Y'           FUNDCHECK         1                        AR798055
      *                                                                                     AR798055
      ** Access System Values                                                               AR798055
      *                                                                                     AR798055
     C                   EVAL      P@OP01 = *Blanks                                         AR798055
      *                                                                                     AR798055
     C                   CALL      'AOSVALR0'                                               AR798055
     C                   PARM      *BLANKS       PRetCode          7                        AR798055
     C                   PARM      SysValTwo     P@OP01           20                        AR798055
     C                   PARM      *BLANKS       P@VL01          200                        AR798055
     C                   PARM      *BLANKS       P@OP02           20                        AR798055
     C                   PARM      *BLANKS       P@VL02          200                        AR798055
     C                   PARM      *BLANKS       P@OP03           20                        AR798055
     C                   PARM      *BLANKS       P@VL03          200                        AR798055
     C                   PARM      *BLANKS       P@OP04           20                        AR798055
     C                   PARM      *BLANKS       P@VL04          200                        AR798055
     C                   PARM      *BLANKS       P@OP05           20                        AR798055
     C                   PARM      *BLANKS       P@VL05          200                        AR798055
     C                   PARM      *BLANKS       P@OP06           20                        AR798055
     C                   PARM      *BLANKS       P@VL06          200                        AR798055
     C                   PARM      *BLANKS       P@OP07           20                        AR798055
     C                   PARM      *BLANKS       P@VL07          200                        AR798055
     C                   PARM      *BLANKS       P@OP08           20                        AR798055
     C                   PARM      *BLANKS       P@VL08          200                        AR798055
     C                   PARM      *BLANKS       P@OP09           20                        AR798055
     C                   PARM      *BLANKS       P@VL09          200                        AR798055
     C                   PARM      *BLANKS       P@OP10           20                        AR798055
     C                   PARM      *BLANKS       P@VL10          200                        AR798055
      *                                                                                     AR798055
     C                   IF        PRetCode  <> *BLANKS                                     AR798055
     C                   EVAL      DBPGM = 'FTIPAY1VL'                                      AR798055
     C                   EVAL      DBFILE = 'SDSVALPD'                                      AR798055
     C                   EVAL      DBKEy = '*KEY   '                                        AR798055
     C                   EVAL      DBase = 890                                              AR798055
     C                   EXSR      *PSSR                                                    AR798055
     C                   ELSE                                                               AR798055
      *                                                                                     AR798055
     C                   IF        P@VL01 = 'Y'                                             AR798055
     C                   MOVEL     'Y'           FWARNING          1                        AR798055
     C                   ELSE                                                               AR798055
     C                   EVAL      FWARNING = 'N'                                           AR798055
     C                   ENDIF                                                              AR798055
     C                   ENDIF                                                              AR798055
      *                                                                                     AR798055
     C                   ELSE                                                               AR798055
     C                   EVAL      FUNDCHECK = 'N'                                          AR798055
     C                   ENDIF                                                              AR798055
     C                   ENDIF                                                              AR798055
     C/COPY WNCPYSRC,FTH00274
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      *
      /COPY WNCPYSRC,FTIPY1V040
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
(c) Misys International Banking Systems Ltd. 2001
     X/COPY WNCPYSRC,FTIPA1VX01
