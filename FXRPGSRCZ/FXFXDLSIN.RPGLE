     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Input')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  FXFXDLSIN - FX DEALS SCREEN INPUT                            *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for FX deals.                                     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. 251029             Date 22May20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD047971           Date 16Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 MD036070           Date 19Oct15               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 258601             Date 17Feb09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 07Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CFX114             Date 15Jun04               *
      *                 CDL018             Date 03Feb04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CDL010             Date 02Aug02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 196952             Date 06May02               *
      *                 192916             Date 26Mar02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      *                 195763             Date 07Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 200400             Date 20Nov01               *
      *                 185612             Date 04Jul01               *
      *                 192530             Date 16May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002             Date 08Aug00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 179510             Date 06Nov00               *
      *                 CDL008             Date 02May00               *
      *                 183225             Date 02May00               *
      *                 182224             Date 24Aug00               *
      *                 181721             Date 10Aug00               *
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.02 Patch Z ---------------------------------------*
      *                 176883             Date 24Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP052             DATE 11Nov99               *
      *                 CAP051             DATE 11Nov99               *
      *                 CPB001             Date 01Jun99               *
      *                 165402             Date 04Aug99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006             DATE 24Feb99               *
      *                 CAP004             Date 07Sep98               *
      *                 136433             Date 10Jun98               *
      *                 CAP002  *CREATE    Date 22Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  251029 - Applied fix 231306.                                 *
      *  231306 - Handle file locking properly.                       *
      *  MD046248 - Finastra Rebranding                               *
      *  MD047971 - Do not allow amendment to settlement account if   *
      *             that side is already netted.                      *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  MD036070 - No way to go back to main deal details screen     *
      *             after reaching settlement screen.  Introduce new  *
      *             function key F11.                                 *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  258601 - Validate value date against the back value period   *
      *           defined in PF/SDBANKPD.                             *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CFX114 - Core changes for GBO014                             *
      *         - Perform Override when Exchange Rate Tolerance is    *
      *           exceeded.                                           *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:FXFXDLS008,FXFXDLSC35,FXFXDLSC37,*
      *                              FXFXDLSC48                       *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in FXDEALPP *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  196952 - Ensure Rate has 5 digits before decimal separator   *
      *           and 8 digits after.                                 *
      *           Recompiled due to changes in FXFXDLPD.              *
      *  192916 - Rollback of window updates wrongly managed in Core  *
      *           API's modules RPR and SIN.                          *
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  195763 - Recompiled due to recompiled FXFXDLVAL.             *
      *  200400 - Reverse fix 179510                                  *
      *  185612 - Warning for FOREX Limit exceeded.                   *
      *  192530 - Pass the correct date to ZASETINSIN.                *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *  179510 - For Settlement method 04 , fields  xxMORI &  xxMOPI *
      *           Midas our Receive/Pay instructions  respectively  not
      *           correctly  updated .  Introduced  new  Data Structure
      *           @MORPI  which is used  for that purpose .           *
      *  CDL008 - Continuous Linked Settlement                        *
      *  183225 - SSI not defaulting properly in FX deals input       *
      *  182224 - Deal Numbers are skipped by  Auto-allocation  process
      *           in   FX &  MM  input options .  When  F12  is pressed
      *           from  the last confirmation  screen ,  the  ROLBK   *
      *           is not performed  every time .                      *
      *  181721 - Allow amend to OP up to 'Option to Date'            *
      *  176883 - Errors found as a result of creating DBAR3.02       *
      *           Meridian repository file.                           *
      *           Mismatch on parameters for call to ZASETINDFT       *
      *  CAP052 - Deal Range Authorisation (By Front Office ID)       *
      *  CAP051 - Automatic Authorisation (FX Part)                   *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to changes in FXDEALPP               *
      *  165402 - Fields on deals are being corrupted on amendment    *
      *  CAP006 - Check for deal being updated by another workstation *
      *  CAP004 - API's Phase 3.                                      *
      *           Add extra parm for Extra Data                       *
      *  136433 - Deals enquiry should not default settle instructions*
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************

     F/COPY WNCPYSRC,FXFXDLSF01
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

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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

      * Array to hold Commitment Job Names                                                    CSC022
     D CmtJobNArr      S             10A   DIM(10)                                            CSC022
                                                                                              CSC022
      ** Commitment Control Data Area                                                         CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  wComitJob              4    103                                                       CSC022
                                                                                              CSC022
     D CrDlFilFmt    E DS                  EXTNAME(FXDEALPP)
      * Current Deal in File Format

     D CrDlScnFmt    E DS                  EXTNAME(FXFXDLPD)
      * (Current) Deal in Screen Format
     D                                     PREFIX(@)

     D NwDlFilFmt    E DS                  EXTNAME(FXVFXDLPD)
     D FXFXDLDORI    E                     EXTFLD(QQDORI)                                     CGL029
     D FXFXDLMORI    E                     EXTFLD(QQMORI)                                     CGL029
     D FXFXDLDOPI    E                     EXTFLD(QQDOPI)                                     CGL029
     D FXFXDLMOPI    E                     EXTFLD(QQMOPI)                                     CGL029
     D FXFXDLRONS    E                     EXTFLD(QQRONS)                                     CGL029
     D FXFXDLPONS    E                     EXTFLD(QQPONS)                                     CGL029
      * New Deal in File Format
     D  F3REC                400    468
     D  F3PAY                469   1027

     D NwDlScnFmt    E DS                  EXTNAME(FXFXDLPD)
      * New Deal in Screen Format

     D FXEFXD        E DS                  EXTNAME(FXEFXDLPD)
      * Error indicators


     D ##RECF        E DS                  EXTNAME(SDESFRPD)
      ** FILE RECEIVE INSTRUCTIONS
     D***FLREC                  1     69                                                      CGL029
     D  FLREC                  1     75                                                       CGL029

     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
      *** FILE PAYMENT INSTRUCTIONS
     D***FLPAY                  1    559                                                      CGL029
     D  FLPAY                  1    565                                                       CGL029

     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      ** FILE FRA/IRS INSTRUCTIONS

     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      ** SCREEN RECEIVE INSTRUCTIONS

     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      ** SCREEN PAYMENT INSTRUCTIONS

     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      ** SCREEN FRA/IRS INSTRUCTIONS

     D/COPY WNCPYSRC,FXFXDLSD01
     D @SETIN          DS
      ** Receive / Pay Settlement Currency, Method & Nostro
     D  @@RSCY                 1      3
     D  @@RSTM                 4      5  0
     D***@@RONS                 6     17                                                      CGL029
     D***@@PSCY                18     20                                                      CGL029
     D***@@PSTM                21     22  0                                                   CGL029
     D***@@PONS                23     34                                                      CGL029
     D  @@RONS                 6     23                                                       CGL029
     D  @@PSCY                24     26                                                       CGL029
     D  @@PSTM                27     28  0                                                    CGL029
     D  @@PONS                29     46                                                       CGL029

     D @CCI@M          DS
      ** CURRENT CONTROL INDICATORS FOR MAIN DETAIL SCREEN
     D  @EKYFD                 1      1
     D  @EDTFD                 2      2
     D  @EINKG                 3      3
     D  @EINKH                 4      4
     D  @EINKJ                 5      5
     D  @EINKN                 6      6
     D  @EINKP                 7      7

     D @PCI@M          DS             7
      ** PREVIOUS CONTROL INDICATORS FOR MAIN DETAIL SCREEN

     D                 DS
      **  Data structure for date in, to change format.
     D  DateIn                 1      8  0
     D  @@YY                   1      4  0
     D  @@MM                   5      6  0
     D  @@DD                   7      8  0

      ************                                                                     179510 200400
     D*@MORPI*****     DS                                                              179510 200400
      ***Midas*Our*Receive*/*Pay**Instructions*(for*Settl*Meth*=*04*)*******           179510 200400
     D**@@MORI****             1     12                                                179510 200400
     D**@@MOPI****            13     24                                                179510 200400

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** MIDAS MODULES DETAILS ACCESSED VIA ACCESS PROGRAM
                                                                                CDL008
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CDL008
      ** Externally described DS for switchable feature details                 CDL008

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
                                                                                CAP051
     D InfData       E DS                  EXTNAME(FXFXIFPD)                    CAP051
     D                                     PREFIX(IF_)                          CAP051
      * FX (FXDL) Extra Data - File (D/B) format                                CAP051
                                                                                CAP004
     D ExtData       E DS                  EXTNAME(FXFXEXPD)                    CAP004
      * FX Extra Data - File (D/B) format                                       CAP004
     D/COPY WNCPYSRC,FXH00122

     D/COPY QWINDSRC,FXDLSINDTA

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
                                                                                              185612
      ** Buy Amount                                                                           185612
     D BAMT            S             13  0                                                    185612
                                                                                              185612
      ** Sell Amount                                                                          185612
     D SAMT            S             13  0                                                    185612

      ** Work variables for CSC022                                                            CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D wCommitSkip     S              1A   INZ('N')                                           CSC022
     D DDRonxOK        S              1A   INZ('Y')                                         MD047971
     D DDPonxOK        S              1A   INZ('Y')                                         MD047971
     D/COPY WNCPYSRC,FXH00071
                                                                                              CSC022
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FXFXDLS008

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
      /COPY WNCPYSRC,FXFXDLS001

      * READ NEXT BROWSE SUBFILE RECORD
      *
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   END
      *
      /COPY WNCPYSRC,FXFXDLS002

      * DO WHILE SCREEN: MAIN DETAILS
      *
     C     @SCRN         DOWEQ     'M'
     C                   EXSR      SCRN@M
     C                   END
      *
      /COPY WNCPYSRC,FXFXDLS003

      * SCREEN: WINDOW
      *
     C     @SCRN         IFEQ      'W'
     C                   EXSR      WINDOW
     C                   END
      *
      /COPY WNCPYSRC,FXFXDLS004

      * DO WHILE SCREEN: SETTLEMENT DETAILS
      *
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      SCRN@S
     C                   END
      *
      /COPY WNCPYSRC,FXFXDLS005

      * SCREEN: CONFIRMATION OF INPUT
      *
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   END
      *
      /COPY WNCPYSRC,FXFXDLS006

      * DO FILE UPDATES
      *
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   END
      *
      /COPY WNCPYSRC,FXFXDLS007

      * TERMINATE PROGRAM
      *
     C     @SCRN         IFEQ      'T'
     C                   If        (CSC022 = 'N')                                             CSC022
     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
     C                   ROLBK                                                                192916
     C                   Else                                                                 CSC022
     C                   SetOn                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   MOVE      '1'           *INLR
     C                   END
      *****************************************************************

      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FXFXDLS009

      /EJECT
      *****************************************************************
      * SCRN@M - PROCESS SCREEN: MAIN DETAILS
      *****************************************************************
     C     SCRN@M        BEGSR
      *
      * Issue rollback to clear any possible updates in window function
      * Only required if deal number or action code has been changed
      * (this check will also cater for F12 taken from main screen)
      *
     C     BGWDPR        IFEQ      'Y'
     C*****DDDLNO        IFNE      DDDLNO                                       CAP004
     C     DDDLNO        IFNE      @PDLNO                                       CAP004
     C     DDACTN        ORNE      @PACTN                                       165402
     C     @CCI@M        ORNE      @PCI@M
                                                                                              182224
      * Check for the work field indicating Deal No. allocation has run                       182224
     C     @WFRUN        OREQ      'Y'                                                        182224
                                                                                              182224
     C                   If        (CSC022 = 'N')                                             CSC022
     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   SetOn                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
                                                                                              182224
     C                   EVAL      @WFRUN = *BLANKS                                           182224
     C                   END
     C                   END
      *
      * Update 'previous' deal number & screen control indicator
      *
     C                   MOVEL     DDDLNO        @PDLNO            6
     C                   MOVEL     DDACTN        @PACTN            1            165402
     C                   MOVEL     @CCI@M        @PCI@M
      *
      * WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'FXFXDLDSP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    NwDlScnFmt
      *
      * NET BUY/SELL REFERENCE
     C                   PARM                    DDNBRF
     C                   PARM                    DDNSRF
      *
      * DEAL STATUS
     C                   PARM                    DDSTS            24
     C/COPY WNCPYSRC,FXH00123
      *
      * FIELDS IN ERROR
     C                   PARM                    FXEFXD
     C/COPY WNCPYSRC,FXH00050
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
      *
      * ENABLED FUNCTION KEYS
     C                   PARM                    @EINKG
     C                   PARM                    @EINKH
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKN
     C                   PARM                    @EINKP
      *
      * SUCCESFUL INSERT DEAL
     C                   PARM                    @SIDN             6
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      'N'           WriteOnly         1
     C/COPY WNCPYSRC,FXFXDLSC02
      *                                                                                       185612
      ** Maximum Daily Delivery Risk fields:                                                  185612
      *                                                                                       185612
     C                   PARM                    DDMDDR           16                          185612
     C                   PARM                    DDEXP1           16                          185612
     C                   PARM                    DDEXP2           16                          185612
     C                   PARM                    DDLIM1            3                          185612
     C                   PARM                    DDLIM2            3                          185612
     C                   PARM                    DDLIM3            9                          185612
      *
      * RESET ERRORS
      *
     C/COPY WNCPYSRC,FXH00124
     C                   MOVE      *ALL'Y'       FXEFXD
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      * CK/7 - ROLL BACKWARDS
      *
     C     @INKG         CASEQ     '1'           ROLL
      *
      * CK/8 - ROLL FORWARDS
      *
     C     @INKH         CASEQ     '1'           ROLL
      *
      * CK/12 - CANCEL ON MAIN DETAILS SCREEN
      *
     C     @INKL         CASEQ     '1'           CANC@M
      *
      * CK/15 - BUILD BROWSE
      *
     C     @INKP         CASEQ     '1'           BLDBRW
      *
      * VALIDATE INPUT TO MAIN DETAILS SCREEN
      *
     C                   CAS                     VAL@M
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@M  - VALIDATE INPUT TO MAIN DETAILS SCREEN
      *****************************************************************
     C     VAL@M         BEGSR
      *
      * Retrieve deal details
      *
     C/COPY WNCPYSRC,FXH00056
     C                   EXSR      RTVDEL
      *
     C/COPY WNCPYSRC,FXFXDLSC32
      * If action code, deal number or booking branch are NOT OK
      * Re-output screen with error messages on it
      *
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C     OKBRSN        OREQ      'N'
     C                   GOTO      EVAL@M
     C                   END
      *
      * Set field and function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      * If action code is delete, enquire or authorize
      * or action code is amend and deal number has changed
      *   Put the deal on the main details screen
      *
     C     DDACTN        IFEQ      'D'
     C     DDACTN        OREQ      'E'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'A'
     C     DDDLNO        ANDNE     @PDLNO
     C     DDACTN        OREQ      'A'                                          165402
     C     DDACTN        ANDNE     @PACTN                                       165402
     C                   EXSR      PUTD@M
     C                   END
      *
      * If deal number or screen control indicators have changed
      *   Re-output screen
      *
     C     DDDLNO        IFNE      @PDLNO
     C     DDACTN        ANDNE     'I'
     C     DDACTN        ORNE      @PACTN                                       165402
     C     @CCI@M        ORNE      @PCI@M
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      * IF DELETE
      *
     C     DDACTN        IFEQ      'D'
      *
      * Update Deal in File Format
      *
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
      *
      * IF CK/10 TAKEN, GO ONTO UPDATES
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVEL     'U'           @SCRN
     C/COPY WNCPYSRC,FXFXDLSC34
     C                   END
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      * IF ENQUIRE
      *
     C     DDACTN        IFEQ      'E'
      *
      * Update Deal in File Format
      *
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
      *
      * IF CK/14 TAKEN, CONTINUE TO SETTLEMENTS SCREEN
      * If windows processing on, call window routine
      * IF BROWSE OUTSTANDING, READ NEXT BROWSE SUBFILE RECORD
      *
     C     @INKN         IFEQ      '1'
     C                   MOVEL     'S'           @SCRN
     C                   ELSE
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   END
     C                   END
     C                   END
      *
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      * IF AUTHORIZE
      *
     C     DDACTN        IFEQ      'X'
      *
      * Update Deal in File Format
      *
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
      *
      * If windows processing on, call window routine
      * otherwise, continue to settlements screen
      *
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
     C                   MOVEL     'S'           @SCRN
     C                   END
      *
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      * IF INSERT OR AMEND
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
      * Prior to validation, initialize error indicators as 'OK'
      * and clear Deal in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   MOVE      *ALL'Y'       FXEFXD
     C     ERRFSR        IFNE      'Y'                                                        258601
     C                   CLEAR                   NwDlFilFmt
     C                   Z-ADD     *ZERO         F3RSTM
     C**********         Z-ADD     *ZERO         F3ROBN                                       CSD027
     C**********         Z-ADD     *ZERO         F3ROCN                                       CSD027
     C                   EVAL      F3ROBN = *BLANKS                                           CSD027
     C                   EVAL      F3ROCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         F3PSTM
     C**********         Z-ADD     *ZERO         F3POBN                                       CSD027
     C**********         Z-ADD     *ZERO         F3POCN                                       CSD027
     C                   EVAL      F3POBN = *BLANKS                                           CSD027
     C                   EVAL      F3POCN = *BLANKS                                           CSD027
     C                   ENDIF                                                                258601
     C/COPY WNCPYSRC,FXH00212
      *
      * IF AMEND
      *
     C     DDACTN        IFEQ      'A'
      *
      * Update Deal in File Format
      *
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
     C/COPY WNCPYSRC,FXH00057
      *
      * Validate whether non-amenable fields have been changed
      *
     C                   CALLB     'FXFXDLAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
      *
      * Current Deal in Screen Format
     C                   PARM                    CrDlScnFmt
      *
      * Current Deal in file format
     C                   PARM                    CrDlFilFmt
      *                                                                                     MD047971
      ** Pay/rcv settlement account                                                         MD047971
      *                                                                                     MD047971
     C                   PARM                    DDRONX                                     MD047971
     C                   PARM                    DDPONX                                     MD047971
     C                   PARM                    DDRONXOK                                   MD047971
     C                   PARM                    DDPONXOK                                   MD047971
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    FXEFXD
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Amendments OK
     C                   PARM                    @@AMOK            1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           @@RSTE            1
     C                   END
      *
      * Validate deal details
      *
     C                   CALLB     'FXFXDLVAL'
     C                   PARM                    RespMode
     C                   PARM                    NwDlScnFmt
     C                   PARM                    InfData                        CAP051
     C                   PARM      F3RSCY        @@RSCY
     C                   PARM      F3RSTM        @@RSTM
     C                   PARM      F3RONS        @@RONS
     C                   PARM      F3PSCY        @@PSCY
     C                   PARM      F3PSTM        @@PSTM
     C                   PARM      F3PONS        @@PONS
     C                   PARM      F3FRNT        @@FRNT                         CPB002
     C                   PARM                    ExtData                        CAP004
     C/COPY WNCPYSRC,FXFXDLSC06
     C                   PARM                    DDNBRF
     C                   PARM                    DDNSRF
     C                   PARM                    FXEFXD
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwDlFilFmt
     C/COPY WNCPYSRC,FXFXDLSC35
      *
      * If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      EVAL@M
     C                   END
      *
      * If windows processing on, call window routine
      * otherwise, continue to settlements screen
      *
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
     C                   MOVEL     'S'           @SCRN
     C                   END
      *
     C                   END
      *----------------------------------------------------------------
     C     EVAL@M        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * WINDOW - CALL WINDOW MANAGER
      *****************************************************************
     C     WINDOW        BEGSR
      *
      * Reset erros
      *
     C/COPY WNCPYSRC,FXH00195
     C                   MOVE      *ALL'Y'       FXEFXD
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * Write out screen to remove error messages
      *
     C                   CALLB     'FXFXDLDSP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    NwDlScnFmt
      *
      * NET BUY/SELL REFERENCE
     C                   PARM                    DDNBRF
     C                   PARM                    DDNSRF
      *
      * DEAL STATUS
     C                   PARM                    DDSTS
     C/COPY WNCPYSRC,FXH00125
      *
      * FIELDS IN ERROR
     C                   PARM                    FXEFXD
     C/COPY WNCPYSRC,FXH00051
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
      *
      * ENABLED FUNCTION KEYS
     C                   PARM                    @EINKG
     C                   PARM                    @EINKH
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKN
     C                   PARM                    @EINKP
      *
      * SUCCESFUL INSERT DEAL
     C                   PARM                    @SIDN             6
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      'Y'           WriteOnly         1
     C/COPY WNCPYSRC,FXFXDLSC10
      *                                                                                       185612
      ** Maximum Daily Delivery Risk fields:                                                  185612
      *                                                                                       185612
     C                   PARM                    DDMDDR           16                          185612
     C                   PARM                    DDEXP1           16                          185612
     C                   PARM                    DDEXP2           16                          185612
     C                   PARM                    DDLIM1            3                          185612
     C                   PARM                    DDLIM2            3                          185612
     C                   PARM                    DDLIM3            9                          185612
      *
      * IF DEAL NUMBER NOT DEFINED (ON INSERT),
      * GET NEXT AVAILABLE DEAL NUMBER
      *
     C     DDDLNO        IFEQ      *BLANK
     C                   CALLB     'CAGETNXTDL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       @@MSG1            7
     C                   PARM                    I#DDDLNO          6
     C                   PARM      *ZERO         F3DN38
      *
      * DATABASE ERROR
      *
     C     @@MSG1        IFNE      *BLANK
     C                   MOVEL     'CAGTNXDL'    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   MOVEL     DDDLNO        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
                                                                                              182224
      * Set up the work field indicating the Deal No. allocation has run                      182224
     C                   MOVE      'Y'           @WFRUN            1                          182224
     C/COPY WNCPYSRC,FXFXDLSC39
                                                                                              182224
     C                   END
      *
     C/COPY WNCPYSRC,FXDLSINMV1
      *
     C                   CALL      'WN0010'
     C                   PARM      'FXFXDLSIN'   #PGM             10
     C                   PARM                    FKEY              2
     C                   PARM      DDACTN        ACTION            1
     C                   PARM                    DATA
     C                   PARM      *BLANKS       #RTRN             7
     C                   PARM                    SPAREW          256
      *
      * Process returned command keys
      *
     C     #RTRN         IFEQ      'Y2U9999'
     C                   EXSR      ENDP
     C                   ELSE
      *
      *  If Cmd12 pressed, or in enquiry, return to main details screen;
      *  otherwise, go to settlements screen
      *
     C     #RTRN         IFEQ      'USR0790'
     C     DDACTN        OREQ      'E'
     C     @RDNB         IFEQ      'Y'
     C/COPY WNCPYSRC,FXFXDLSC11
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
     C                   EVAL      @SCRN = 'M'
     C                   END
     C                   If        (CSC022 = 'N')                                             CSC022
     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
     C                   ROLBK                                                                192916
     C                   Else                                                                 CSC022
     C                   SetOn                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   ELSE
     C                   EVAL      @SCRN = 'S'
     C/COPY WNCPYSRC,FXFXDLSC36
     C                   ENDIF
     C                   ENDIF
      *
     C     WIND          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ROLL - ROLL BACKWARDS & FORWARDS THROUGH DEALS FILE
      *****************************************************************
     C     ROLL          BEGSR
      *
      * Default action code to enquiry if not valid
      *
     C     DDACTN        IFNE      'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'X'
     C                   MOVE      'E'           DDACTN
     C                   END
      *
      * READ NEXT OR PREVIOUS RECORD ON DEALS FILE
      * ACCORDING TO COMMAND KEY TAKEN (CK/7 OR CK/8)
      *
     C     @INKG         IFEQ      '1'
     C                   MOVEL     *BLANK        @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     *BLANK        @RDBCK
     C                   END
      *
     C                   CALLB     'FXFXDLRED'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *                                                                         CAP052
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                    CAP052
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP052
      *                                                                         CAP052
     C                   PARM      '      '      @@MODE            6            CAP052
      *
      * ACTION CODE
     C                   PARM                    DDACTN            1
      *
      * DEAL NUMBER POINTER
     C                   PARM                    DDDLNO            6
      *                                                                         CAP052
      * Front Office ID                                                         CAP052
     C                   PARM                    DDFRTN           20            CAP052
      *
      * READ FORWARDS
     C                   PARM                    @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM                    @RDBCK            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * DEAL NUMBER READ
     C                   PARM      *BLANK        @DLRED            6
      *                                                                         CAP052
      * Front Office ID READ                                                    CAP052
     C                   PARM      *BLANK        @FTRED           20            CAP052
      *
      * If error message returned from read, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@M
     C                   GOTO      EROLL
     C                   END
      *
      * If deal read
      *
     C     @DLRED        IFNE      *BLANK
      *
      * Retrieve deal details
      *
     C                   MOVEL     @DLRED        DDDLNO
     C                   EXSR      RTVDEL
      *
      * Set field and function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      * Put the deal on the main details screen
      *
     C                   EXSR      PUTD@M
     C                   END
      *
     C     EROLL         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * BLDBRW - BUILD BROWSE SUBFILE
      *****************************************************************
     C     BLDBRW        BEGSR
      *
      * RESET READ NEXT BROWSE SUBFILE RECORD
      *
     C                   MOVEL     *BLANK        @RDNB             1
     C/COPY WNCPYSRC,FXFXDLSC12
      *
      * BUILD BROWSE SUBFILE
      *
     C                   CALLB     'FXFXDLBRW'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * ACTION CODE
     C                   PARM                    DDACTN            1
      *
      * DEAL NUMBER POINTER
     C                   PARM                    DDDLNO            6
      *
      * BUILD SUB-FILE
     C                   PARM      'Y'           @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      *BLANK        @RDSFL            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM      *BLANK        @OPSEL            1
      *
      * DEAL NUMBER SELECTED
     C                   PARM      *BLANK        @DLSEL            6
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
     C/COPY WNCPYSRC,FXFXDLSC13
      *
      * If CK/3 taken in browse, end program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      EBLDBR
     C                   END
      *
      * If error message returned from browse, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@M
     C                   GOTO      EBLDBR
     C                   END
      *
      * If CK/12 not taken in browse
      * Read next browse subfile record
      *
     C     @INKL         IFNE      '1'
     C                   MOVE      'Y'           @RDNB
     C                   MOVEL     'R'           @SCRN
     C/COPY WNCPYSRC,FXFXDLSC14
     C                   GOTO      EBLDBR
     C                   END
      *
     C     EBLDBR        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
     C/COPY WNCPYSRC,FXFXDLSC15
      *
      * READ NEXT SUBFILE RECORD
      *
     C                   CALLB     'FXFXDLBRW'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * ACTION CODE
     C                   PARM                    DDACTN            1
      *
      * DEAL NUMBER POINTER
     C                   PARM                    DDDLNO            6
      *
      * BUILD SUB-FILE
     C                   PARM      *BLANK        @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      'Y'           @RDSFL            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM      *BLANK        @OPSEL            1
      *
      * DEAL NUMBER SELECTED
     C                   PARM      *BLANK        @DLSEL            6
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
     C/COPY WNCPYSRC,FXFXDLSC16
      *
      * IF DEAL READ FROM SUBFILE
      *
     C     @DLSEL        IFNE      *BLANK
      *
      * Retrieve deal details
      *
     C                   MOVEL     @OPSEL        DDACTN
     C/COPY WNCPYSRC,FXFXDLSC17
     C                   MOVEL     @DLSEL        DDDLNO
     C                   EXSR      RTVDEL
     C/COPY WNCPYSRC,FXFXDLSC18
      *
      * Set field and function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      * Put the deal on the main details screen
      *
     C                   EXSR      PUTD@M
     C/COPY WNCPYSRC,FXFXDLSC19
      *
      * ELSE, RESET READ NEXT BROWSE SUBFILE RECORD
      *
     C                   ELSE
     C/COPY WNCPYSRC,FXFXDLSC20
     C                   MOVEL     *BLANK        @RDNB
     C/COPY WNCPYSRC,FXFXDLSC21
     C                   END
      *
      * GO TO MAIN DETAILS SCREEN
      *
     C                   MOVE      'M'           @SCRN
     C/COPY WNCPYSRC,FXFXDLSC22
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVDEL - RETRIEVE DEAL
      *****************************************************************
     C     RTVDEL        BEGSR
      *
      * RETRIEVE DEAL
      *
     C                   CALLB     'FXFXDLRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '      '      @@MODE            6
      *
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      *
      * Action Code
     C                   PARM                    DDACTN
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * Front Office Associated Transaction Id
     C                   PARM                    FOASID           20
      *
      * (Midas) Deal Number
     C                   PARM                    DDDLNO
      *
      * (Midas) Swap/Option Deal Number
     C                   PARM                    DDSDNO
      *
      * Booking branch
     C                   PARM                    DDBRSN
      *
      * Originating branch
     C                   PARM                    DDORBR
      *
      * OUTPUTS
      *
      * (Current) deal in file format
     C                   PARM                    CrDlFilFmt
      *
      * OK - Action code
     C                   PARM      *BLANK        OKACTN
      *
      * OK - Deal Number
     C                   PARM      *BLANK        OKDLNO
      *
      * OK - Booking branch
     C                   PARM      *BLANK        OKBRSN
      *
      * OK - Originating branch
     C                   PARM                    OKORBR
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
                                                                                              CAS004
      ** Warning error fields/message IDs/message data (arrays) from/to caller                CAS004
                                                                                              CAS004
     C                   PARM      *BLANKS       WFldNamArr                                   CAS004
     C                   PARM      *BLANKS       WMsgIdArr                                    CAS004
     C                   PARM      *BLANKS       WMsgDtaArr                                   CAS004
                                                                                              CAS004
      ** Warning array index (3P0) from/to caller                                             CAS004
                                                                                              CAS004
     C                   PARM      *ZEROS        WIdx                                         CAS004
                                                                                              CAS004
     C/COPY WNCPYSRC,FXFXDLSC03
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PUTD@M - PUT A DEAL ON THE MAIN DETAILS SCREEN
      *****************************************************************
     C     PUTD@M        BEGSR
      *
      * Call program to fill screen fields with data from FXDEALPP
      *
     C                   CALLB     'FXFXDLCVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Deal in file format
     C                   PARM                    CrDlFilFmt
      *
      * OUTPUTS
      *
      * Deal in screen format
     C                   PARM                    NwDlScnFmt
      *
      * NET BUY/SELL REFERENCE
     C                   PARM                    DDNBRF           19
     C                   PARM                    DDNSRF           19
      *
      * Deal Status
     C                   PARM                    DDSTS            24
      *
      * Update 'Current' Deal with Deal in Screen Format
      *
     C                   MOVEL     NwDlScnFmt    CrDlScnFmt
     C/COPY WNCPYSRC,FXH00213
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFDS@M - SET FIELD STATUS ON MAIN DETAILS SCREEN
      *          ACCORDING TO ACTION CODE
      *****************************************************************
     C     SFDS@M        BEGSR
      *
      * Enable/disable key & detail fields on main details screen
      * (key fields = action code & deal number; detail fields = rest)
      * (Action code can only be 'I', 'A', 'E', 'D', or 'X')
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C                   MOVEL     'Y'           @EKYFD
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EKYFD
     C                   MOVEL     'N'           @EDTFD
     C                   END
     C/COPY WNCPYSRC,FXFXDLSC23
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFKS@M - SET FUNCTION KEY STATUS ON MAIN DETAILS SCREEN
      *          ACCORDING TO ACTION CODE
      *****************************************************************
     C     SFKS@M        BEGSR
      *
      * Enable/disable function keys on main details screen
      *
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      *
     C                   MOVEL     'Y'           @EINKG
     C                   MOVEL     'Y'           @EINKH
      *
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      *
     C     DDACTN        IFEQ      'D'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
      *
      * KN = COMMAND KEY 14 = SETTLEMENT DETAILS
      * (Action codes I, A, X display settlement details automatically)
      * (No futher screens are available from action code D)
      *
     C     DDACTN        IFEQ      'E'
     C                   MOVEL     'Y'           @EINKN
     C                   ELSE
     C                   MOVEL     'N'           @EINKN
     C                   END
      *
      * KP = COMMAND KEY 15 = BROWSE
      *
     C                   MOVEL     'Y'           @EINKP
     C/COPY WNCPYSRC,FXFXDLSC24
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IFDS@M - INITIALIZE FIELD STATUS ON MAIN DETAILS SCREEN
      *****************************************************************
     C     IFDS@M        BEGSR
      *
      * ENABLE KEY & DETAILS FIELDS ON MAIN DETAILS SCREEN
      *
     C                   MOVEL     'Y'           @EKYFD
     C                   MOVEL     'Y'           @EDTFD
     C/COPY WNCPYSRC,FXFXDLSC25
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IFKS@M - INITIALIZE FUNCTION KEY STATUS ON MAIN DETAILS SCREEN
      *****************************************************************
     C     IFKS@M        BEGSR
      *
      * ENABLE/DISABLE FUNCTION KEYS ON MAIN DETAILS SCREEN
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      * KN = COMMAND KEY 14 = SETTLEMENT DETAILS
      * KP = COMMAND KEY 15 = BROWSE
      *
     C                   MOVEL     'Y'           @EINKG
     C                   MOVEL     'Y'           @EINKH
     C                   MOVEL     'N'           @EINKJ
     C                   MOVEL     'N'           @EINKN
     C                   MOVEL     'Y'           @EINKP
     C/COPY WNCPYSRC,FXFXDLSC26
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@M - CANCEL ON MAIN DETAILS SCREEN
      *****************************************************************
     C     CANC@M        BEGSR
     C/COPY WNCPYSRC,FXFXDLSC27
      *
      * Reset Read Next Browse Subfile Record (if active)
      *
     C                   MOVEL     *BLANK        @RDNB
     C/COPY WNCPYSRC,FXFXDLSC28
      *
      * If input fields are enabled
      * Blank the main details screen
      * and settlement screen                                                   183225
      *
     C     @EKYFD        IFEQ      'Y'
     C     @EDTFD        OREQ      'Y'
     C                   MOVEL     *BLANK        NwDlScnFmt
     C                   MOVEL     *BLANK        DDSTS
     C                   MOVEL     *BLANK        DDNBRF
     C                   MOVEL     *BLANK        DDNSRF
     C                   CLEAR                   ##PAYF                         183225
     C                   CLEAR                   ##RECF                         183225
     C                   MOVEL     *BLANK        ##ACTN                         183225
     C                   MOVEL     *BLANK        ##DLNO                         183225
     C                   MOVEL     *BLANK        ##PCCY                         183225
     C                   MOVEL     *BLANK        ##RCCY                         183225
     C                   MOVEL     *BLANK        ##CSNM                         183225
     C                   MOVEL     *BLANK        ##CLSS                         CDL008
     C/COPY WNCPYSRC,FXFXDLSC05
     C                   END
      *
      * Initialize field and function key status on main details screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@M - SEND A MESSAGE TO MAIN DETAILS SCREEN
      *****************************************************************
     C     SNDM@M        BEGSR
      *
      * If single branching, user can't browse file
      *
     C     @ERRMS        IFEQ      'FXM0292'
     C                   MOVE      'N'           OKACTN
     C                   END
      *
      ** Deal number on screen must be blank or numeric for pointer
      *
     C     @ERRMS        IFEQ      'MMM0162'
     C                   MOVE      'N'           OKDLNO
     C                   END
      *
      ** Add error message to array passed to detail screen
      *
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99          *
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     @ERRMS        MsgIdArr(E)
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@S - PROCESS SCREEN: SETTLEMENT DETAILS
      *          EVOKED FOR INSERTS, AMENDS, ENQUIRIES & AUTHORIZATIONS
      *****************************************************************
     C     SCRN@S        BEGSR
      *                                                                                       192530
      * PAYMENT DATE = VALUE DATE                                                             192530
      *                                                                                       192530
      * For OP can amend Pay Side Settl Ins up to Option to Date                              192530
     C     DDACTN        IFEQ      'A'                                                        192530
     C     DDDLTP        ANDEQ     'OP'                                                       192530
     C                   Z-ADD     F3OTDN        ##DATP                                       192530
     C                   Z-ADD     F3OTDN        ##DATR                                       192530
     C                   ELSE                                                                 192530
     C                                                                                        192530
     C                   Z-ADD     F3VDDN        ##DATP                                       192530
      *                                                                                       192530
      * RECEIVE DATE = VALUE DATE                                                             192530
      *                                                                                       192530
     C                   Z-ADD     F3VDDN        ##DATR                                       192530
     C                   ENDIF                                                                192530
      *
      * IF FIRST TIME FOR ACTION CODE, DEAL NUMBER, CURRENCY OR CUSTOMER
      *
     C     DDACTN        IFNE      ##ACTN
     C     DDDLNO        ORNE      ##DLNO
     C     DDSCCY        ORNE      ##PCCY
     C     DDBCCY        ORNE      ##RCCY
     C     DDCUST        ORNE      ##CSNM
     C     CDL008        OREQ      'Y'                                          CDL008
     C     DDCLSS        ANDNE     ##CLSS                                       CDL008
      *                                                                         CDL008
      ** If feature CDL008 is installed                                         CDL008
      *                                                                         CDL008
     C                   IF        CDL008 = 'Y' AND DDCLSS = 'Y'                CDL008
     C                   EVAL      ##TTYP = 'CL'                                CDL008
     C                   ELSE                                                   CDL008
     C                   EVAL      ##TTYP = DDDLTP                              CDL008
     C                   ENDIF                                                  CDL008
      *                                                                         CDL008
     C                   MOVE      DDCLSS        ##CLSS            1            CDL008
      *
      * DETERMINE PARAMETERS FOR SETTLEMENT DETAILS INPUT
      *
     C                   EXSR      DETP@S
     C                   END
      *
      * SETTLEMENT INSTRUCTIONS INPUT
     C/COPY WNCPYSRC,FXFXDLSC41
      *
     C                   CALLB     'ZASETINSIN'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        ##RTCD           10
      *
      * Action code
     C                   PARM      DDACTN        ##ACTN            1
      *
      * Deal number
     C                   PARM      DDDLNO        ##DLNO            6
      *
      * Protect Payment
     C                   PARM                    ##PPAY            1
      *
      * Protect Receive
     C                   PARM                    ##PREC            1
      *
      * Calling program
     C                   PARM      'FXDL'        ##CALP            4
      *
      * Payment currency
     C                   PARM      DDSCCY        ##PCCY            3
      *
      * Receive currency
     C                   PARM      DDBCCY        ##RCCY            3
      *
      * Customer shortname
     C                   PARM      DDCUST        ##CSNM           10
      *
      * Transaction Type
     C***********        PARM      DDDLTP        ##TTYP            2            CDL008
     C                   PARM                    ##TTYP            2            CDL008
      *
      * Federal Funds Ind.
     C                   PARM      DDFEDF        ##FFND            1
      *
      * Booking branch
     C                   PARM      DDBRSN        ##BRCA            3
      *
      * Receipt Date
     C                   PARM                    ##DATR            5 0
      *
      * Payment Date
     C                   PARM                    ##DATP            5 0
      *
      * Payment instructions
     C                   PARM                    ##PAYS
      *
      * Receive instructions
     C                   PARM                    ##RECS
      *
      * FRA/IRS instructions
     C                   PARM                    ##FRIS
      *
      * OUTPUTS
      *
      * Payment instructions
     C                   PARM                    ##PAYF
      *
      * Receive instructions
     C                   PARM                    ##RECF
      *
      * FRA/IRS instructions
     C                   PARM                    ##FRIF
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKK             1                        MD036070
     C                   PARM      '0'           @INKL             1
      *
      ************                                                                     179510 200400
      **MIDAS*Our*Receive/ Pay Instructions (for Settlm Meth = 04 )                    179510 200400
     C************       PARM                    @MORPI                                179510 200400
      ************                                                                     179510 200400
      ************                                                                     179510 200400
     C/COPY WNCPYSRC,FXFXDLSC42
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      * CK/12 - CANCEL ON SETTLEMENT DETAILS
      *
     C     @INKK         CASEQ     '1'           CANC@S                                     MD036070
     C     @INKL         CASEQ     '1'           CANC@S
      *
      * EXIT FROM SETTLEMENT DETAILS
      *
     C                   CAS                     EXIT@S
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DETP@S - DETERMINE PARAMETERS FOR SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     DETP@S        BEGSR
      *
      * PAYMENT DATE = VALUE DATE
      *
      * For OP can amend Pay Side Settl Ins up to Option to Date                    181721
     C     DDACTN        IFEQ      'A'                                              181721
     C     DDDLTP        ANDEQ     'OP'                                             181721
     C                   Z-ADD     F3OTDN        ##DATP                             181721
     C                   Z-ADD     F3OTDN        ##DATR                             181721
     C                   ELSE                                                       181721
     C                                                                              181721
     C                   Z-ADD     F3VDDN        ##DATP
      *
      * RECEIVE DATE = VALUE DATE
      *
     C                   Z-ADD     F3VDDN        ##DATR
     C                   ENDIF                                                      181721
      *
      * Convert Transaction Date to a Midas Day Number
      *
     C                   Z-ADD     F3DTYY        @@YY
     C                   Z-ADD     F3DTMM        @@MM
     C                   Z-ADD     F3DTDD        @@DD
     C     DateIn        IFEQ      0
     C                   Z-ADD     BJRDNB        TransDate
     C                   ELSE
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM                    ZZMDNO            5 0
     C                   MOVE      ZZMDNO        TransDate         5 0
     C                   END
      *
      * PROTECT PAYMENT/RECEIVE INSTRUCTIONS IF DATES
      * ARE IN THE PAST AND THE DEAL WAS NOT DONE TODAY
      *
     C     ##DATP        IFLT      BJRDNB
     C     TransDate     ANDNE     BJRDNB
     C                   MOVEL     'Y'           ##PPAY
     C                   ELSE
     C                   MOVEL     'N'           ##PPAY
     C                   END
     C     ##DATR        IFLT      BJRDNB
     C     TransDate     ANDNE     BJRDNB
     C                   MOVEL     'Y'           ##PREC
     C                   ELSE
     C                   MOVEL     'N'           ##PREC
     C                   END
      *
      * SET UP PAYMENT INSTRUCTIONS FROM DEAL
      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C                   MOVEL     F3PAY         FLPAY
     C                   EVAL      %SUBST(FLPAY:1:2) = %SUBST(F3PAY:1:2)                      CGL029
     C                   EVAL      %SUBST(FLPAY:3:18) = F3PONS                                CGL029
     C                   EVAL      %SUBST(FLPAY:21:545) = %SUBST(F3PAY:15:545)                CGL029
     C                   MOVEL     F3POBR        FLPOBR
     C                   MOVEL     F3CVMR        FLCVMR
     C                   MOVEL     F3PSCY        FLPSCY
     C                   MOVEL     F3IC72        FLIC72
      *
      * SET UP RECEIVE INSTRUCTIONS FROM DEAL
      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C                   MOVEL     F3REC         FLREC
     C                   EVAL      %SUBST(FLREC:1:2) = %SUBST(F3REC:1:2)                      CGL029
     C                   EVAL      %SUBST(FLREC:3:18) = F3RONS                                CGL029
     C                   EVAL      %SUBST(FLREC:21:55) = %SUBST(F3REC:15:55)                  CGL029
     C                   MOVEL     F3ROBR        FLROBR
     C                   MOVEL     F3RSCY        FLRSCY
      *
      * IF SETTLEMENT INSTRUCTIONS ARE NOT DEFINED,
      * AND PAYMENT/RECEIPT DATES ARE NOT IN THE PAST, DEFAULT THEM
      * or if CLS Settlement field was amended, default them                    CDL008
      *
     C     FLPSTM        IFEQ      *ZERO
     C     ##PPAY        ANDNE     'Y'
     C     FLRSTM        ANDEQ     *ZERO
     C     ##PREC        ANDNE     'Y'
     C     DDACTN        ANDNE     'E'                                          136433
     C     CDL008        OREQ      'Y'                                          CDL008
     C     DDACTN        ANDEQ     'A'                                          CDL008
     C     ##PPAY        ANDNE     'Y'                                          CDL008
     C     ##PREC        ANDNE     'Y'                                          CDL008
     C     FHCLSS        ANDEQ     'Y'                                          CDL008
     C     DDCLSS        ANDEQ     'N'                                          CDL008
     C     CDL008        OREQ      'Y'                                          CDL008
     C     DDACTN        ANDEQ     'A'                                          CDL008
     C     ##PPAY        ANDNE     'Y'                                          CDL008
     C     ##PREC        ANDNE     'Y'                                          CDL008
     C     FHCLSS        ANDEQ     'N'                                          CDL008
     C     DDCLSS        ANDEQ     'Y'                                          CDL008
      *
     C/COPY WNCPYSRC,FXH00026
     C                   CALLB     'ZASETINDFT'
      *
      * INPUTS
      *
      * Calling program
     C                   PARM      'FXDL'        ##CALP            4
      *
      * Payment currency
     C                   PARM      DDSCCY        ##PCCY            3
      *
      * Receive currency
     C                   PARM      DDBCCY        ##RCCY            3
     C/COPY WNCPYSRC,FXFXDLSC43
      *
      * Customer shortname
     C                   PARM      DDCUST        ##CSNM           10
      *
      * Transaction Type
     C***********        PARM      DDDLTP        ##TTYP            2            CDL008
     C                   PARM                    ##TTYP            2            CDL008
      *
      * Federal Funds Ind.
     C                   PARM      DDFEDF        ##FFND            1
      *
      ** Version of ISDA Rules govern
     C                   PARM                    BQISDA            4
      *
      ** Type of ISDA agreement
     C                   PARM                    BQAGTY            6
      *
      ** Date of ISDA Agreement
     C                   PARM                    BQAGDT            6
      *
      ** Version of ISDA Agreement
     C                   PARM                    BQAGVV            2
      ** Version of ISDA Agreement century                                                    176883
     C                   PARM                    Blank2            2                          176883
      ** Deal Subtype                                                                         CSD095
     C                   PARM      DDDLST        ##DLST            2                          CSD095
      ** Branch                                                                               CSD095
     C                   PARM      DDBRSN        ##BRSN            3                          CSD095
      *
      ** OUTPUTS
      *
      * Payment instructions
     C                   PARM                    ##PAYF
      *
      * Receive instructions
     C                   PARM                    ##RECF
      *
      * FRA/IRS instructions
     C                   PARM                    ##FRIF
      *
     C/COPY WNCPYSRC,FXH00027
     C                   END
      *
      * CONVERT SETTLEMENT DETAILS FROM FILE TO SCREEN FORMAT
      *
     C                   CALLB     'ZASETINCVT'
      *
      ** INPUTS
      *
      ** File Payment Settlement Instruction
     C                   PARM                    ##PAYF
      *
      ** File Receipt Settlement Instruction
     C                   PARM                    ##RECF
      *
      ** File FRA/IRS Settlement Instruction
     C                   PARM      *BLANK        ##FRIF
      *
      ** OUTPUTS
      ** Screen Payment Settlement Instruction
     C                   PARM      *BLANK        ##PAYS
      *
      ** Screen Receipt Settlement Instruction
     C                   PARM      *BLANK        ##RECS
      *
      ** Screen FRA/IRS Settlement Instruction
     C                   PARM      *BLANK        ##FRIS
     C                   PARM      DDBCCY        #TRCCY            3                         CSF011A
     C                   PARM      DDSCCY        #TPCCY            3                         CSF011A
      *
     C/COPY WNCPYSRC,FXFXDLSIC1
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@S - CANCEL ON SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     CANC@S        BEGSR
      *
     C/COPY WNCPYSRC,FXFXDLSC08
      * Return to Main Details Screen
      *
     C                   MOVEL     'M'           @SCRN
     C/COPY WNCPYSRC,FXFXDLSC09
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@S - EXIT FROM SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     EXIT@S        BEGSR
      *
      * IF SETTLEMENT DETAILS INVALID
      *
     C     ##RTCD        IFEQ      '*ERRORS'
      *
      * RETURN TO MAIN DETAILS SCREEN
      *
     C                   MOVEL     'M'           @SCRN
     C                   ELSE
      *
      * ELSE, CONTINUE WITH CONFIRMATION SCREEN
      *
     C                   MOVEL     'C'           @SCRN
      *
      * UPDATE VALID DEAL: PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     FLPAY         F3PAY
     C                   EVAL      %SUBST(F3PAY:1:2) = %SUBST(FLPAY:1:2)                      CGL029
     C                   EVAL      F3PONS = %SUBST(FLPAY:3:18)                                CGL029
     C                   EVAL      %SUBST(F3PAY:15:545) = %SUBST(FLPAY:21:545)                CGL029
     C                   MOVEL     FLPOBR        F3POBR
     C                   MOVEL     FLCVMR        F3CVMR
      ************                                                                     179510 200400
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **DataStructure**into*the**correspondent**file**field**.*******                  179510 200400
      ************                                                                     179510 200400
     C*****DDPSTM*       IFEQ      '04'                                                179510 200400
     C************       MOVE      @@MOPI        F3MOPI                                179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
      *
      * UPDATE VALID DEAL: RECEIPT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     FLREC         F3REC
     C                   EVAL      %SUBST(F3REC:1:2) = %SUBST(FLREC:1:2)                      CGL029
     C                   EVAL      F3RONS = %SUBST(FLREC:3:18)                                CGL029
     C                   EVAL      %SUBST(F3REC:15:55) = %SUBST(FLREC:21:55)                  CGL029
     C                   MOVEL     FLROBR        F3ROBR
      *
      ************                                                                     179510 200400
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **DataStructure**into*the**correspondent**file**field**.*******                  179510 200400
      ************                                                                     179510 200400
     C*****DDRSTM*       IFEQ      '04'                                                179510 200400
     C************       MOVE      @@MORI        F3MORI                                179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
      * UPDATE VALID DEAL: SETTLEMENT CURRENCIES & 'IN' CCY IN FIELD 72
      *
     C                   MOVEL     FLRSCY        F3RSCY
     C                   MOVEL     FLPSCY        F3PSCY
     C                   MOVEL     FLIC72        F3IC72
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@C - PROCESS SCREEN: CONFIRMATION OF INPUT
      *          EVOKED FOR INSERTS, AMENDS & AUTHORIZATIONS
      *****************************************************************
     C     SCRN@C        BEGSR
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   MOVE      *ALL'Y'       FXEFXD
     C/COPY WNCPYSRC,FXH00196
      *
      * Validate deal details
      *
     C                   CALLB     'FXFXDLVAL'
     C                   PARM                    RespMode
     C                   PARM                    NwDlScnFmt
     C                   PARM                    InfData                        CAP051
     C                   PARM      F3RSCY        @@RSCY
     C                   PARM      F3RSTM        @@RSTM
     C                   PARM      F3RONS        @@RONS
     C                   PARM      F3PSCY        @@PSCY
     C                   PARM      F3PSTM        @@PSTM
     C                   PARM      F3PONS        @@PONS
     C                   PARM      F3FRNT        @@FRNT           20            CPB002
     C                   PARM                    ExtData                        CAP004
     C/COPY WNCPYSRC,FXFXDLSC07
     C                   PARM                    DDNBRF
     C                   PARM                    DDNSRF
     C                   PARM                    FXEFXD
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *ZERO         Idx               3 0
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      *ZERO         WIdx              3 0
     C                   PARM                    NwDlFilFmt
     C/COPY WNCPYSRC,FXFXDLSC37
      *
      * If transaction is valid output message 'Press enter to accept'
      *
     C     Idx           IFEQ      *ZERO
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1030'     MsgIdArr(1)
     C                   END
      *                                                                                       258601
     C     Idx           IFNE      *ZERO                                                      258601
     C                   EXSR      SFDS@M                                                     258601
     C                   EXSR      SFKS@M                                                     258601
     C                   MOVEL     'Y'           ERRFSR            1                          258601
     C                   ELSE                                                                 258601
     C                   MOVEL     'N'           @EKYFD                                       258601
     C                   MOVEL     'N'           @EDTFD                                       258601
     C                   MOVEL     'N'           @EINKG                                       258601
     C                   MOVEL     'N'           @EINKH                                       258601
     C                   MOVEL     'N'           @EINKJ                                       258601
     C                   MOVEL     'N'           @EINKN                                       258601
     C                   MOVEL     'N'           @EINKP                                       258601
     C                   MOVEL     'N'           ERRFSR                                       258601
     C                   END                                                                  258601
      *                                                                                       185612
      ** Call routine to output MDDR data                                                     185612
      *                                                                                       185612
     C     DDACTN        IFEQ      'I'                                                        185612
     C     DDACTN        OREQ      'X'                                                        185612
      *                                                                                       185612
      ** Set up buy and sell amounts                                                          185612
      *                                                                                       185612
     C     F3DAM1        IFLT      0                                                          185612
     C                   Z-SUB     F3DAM1        BAMT                                         185612
     C                   ELSE                                                                 185612
     C                   Z-ADD     F3DAM1        BAMT                                         185612
     C                   ENDIF                                                                185612
     C     F3DAM2        IFLT      0                                                          185612
     C                   Z-SUB     F3DAM2        SAMT                                         185612
     C                   ELSE                                                                 185612
     C                   Z-ADD     F3DAM2        SAMT                                         185612
     C                   ENDIF                                                                185612
                                                                                              185612
     C/COPY WNCPYSRC,FXH00072
     C                   CALLB     'FXMDDRAMT'                                                185612
                                                                                              185612
      ** Outputs from this procedure                                                          185612
      ** ---------------------------                                                          185612
      ** Return code (10A, returned to caller)                                                185612
     C                   PARM                    ReturnCode                                   185612
      ** Maximum Daily Delivery Risk fields:                                                  185612
     C                   PARM                    DDMDDR           16                          185612
     C                   PARM                    DDEXP1           16                          185612
     C                   PARM                    DDEXP2           16                          185612
     C                   PARM                    DDLIMT            6                          185612
     C                   PARM                    DDLIM1            3                          185612
     C                   PARM                    DDLIM2            3                          185612
     C                   PARM                    DDLIM3            9                          185612
                                                                                              185612
      ** Inputs to this procedure                                                             185612
      ** ------------------------                                                             185612
                                                                                              185612
     C** Action code                                                                          185612
     C                   PARM                    DDACTN                                       185612
     C** Customer                                                                             185612
     C                   PARM                    DDCUST                                       185612
     C** Buy Currency                                                                         185612
     C                   PARM                    DDBCCY                                       185612
     C** Sell Currency                                                                        185612
     C                   PARM                    DDSCCY                                       185612
     C** Run Day Number from SDBANKPD                                                         185612
     C                   PARM                    BJRDNB                                       185612
      ** System Location Code from SDBANKPD                                                   185612
     C                   PARM                    BJSLCD                                       185612
      ** Buy Amount                                                                           185612
     C                   PARM                    BAMT                                         185612
      ** Sell Amount                                                                          185612
     C                   PARM                    SAMT                                         185612
      ** Exposure Management indicator                                                        185612
     C                   PARM                    BGEXMG                                       185612
      ** Value Date in day number format                                                      185612
     C                   PARM                    F3VDDN                                       185612
      *                                                                                       185612
      ** Error fields/message IDs/message data (arrays) from/to caller                        185612
      *                                                                                       185612
     C                   PARM                    WFldNamArr                                   185612
     C                   PARM                    WMsgIdArr                                    185612
     C                   PARM                    WMsgDtaArr                                   185612
     C                   PARM                    WIdx                                         185612
      ** Booking Branch                                                                       185612
     C                   PARM                    DDBRSN                                       185612
     C/COPY WNCPYSRC,FXH00073
     C                   ENDIF                                                                185612
      *
      * WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'FXFXDLDSP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    NwDlScnFmt
      *
      * NET BUY/SELL REFERENCE
     C                   PARM                    DDNBRF
     C                   PARM                    DDNSRF
      *
      * DEAL STATUS
     C                   PARM                    DDSTS
     C/COPY WNCPYSRC,FXH00126
      *
      * FIELDS IN ERROR
     C                   PARM                    FXEFXD
     C/COPY WNCPYSRC,FXH00052
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C**********         PARM      'N'           @EKYFD                                       258601
     C                   PARM                    @EKYFD                                       258601
     C**********         PARM      'N'           @EDTFD                                       258601
     C                   PARM                    @EDTFD                                       258601
      *
      * ENABLED FUNCTION KEYS
     C**********         PARM      'N'           @EINKG                                       258601
     C                   PARM                    @EINKG                                       258601
     C**********         PARM      'N'           @EINKH                                       258601
     C                   PARM                    @EINKH                                       258601
     C**********         PARM      'N'           @EINKJ                                       258601
     C                   PARM                    @EINKJ                                       258601
     C**********         PARM      'N'           @EINKN                                       258601
     C                   PARM                    @EINKN                                       258601
     C**********         PARM      'N'           @EINKP                                       258601
     C                   PARM                    @EINKP                                       258601
      *
      * SUCCESFUL INSERT DEAL
     C                   PARM                    @SIDN             6
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      'N'           WriteOnly         1
     C/COPY WNCPYSRC,FXFXDLSC29
      *                                                                                       185612
      ** Maximum Daily Delivery Risk fields:                                                  185612
      *                                                                                       185612
     C                   PARM                    DDMDDR           16                          185612
     C                   PARM                    DDEXP1           16                          185612
     C                   PARM                    DDEXP2           16                          185612
     C                   PARM                    DDLIM1            3                          185612
     C                   PARM                    DDLIM2            3                          185612
     C                   PARM                    DDLIM3            9                          185612
      *
      * RESET ERRORS
      *
     C/COPY WNCPYSRC,FXH00127
     C                   MOVE      *ALL'Y'       FXEFXD
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      * CK/12 - CANCEL ON CONFIRMATION SCREEN
      *
     C     @INKL         CASEQ     '1'           CANC@C
      *
      * EXIT CONFIRMATION SCREEN
      *
     C     ERRFSR        CASEQ     'Y'           VAL@M                                        258601
     C                   CAS                     EXIT@C
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@C - CANCEL ON CONFIRMATION SCREEN
      *****************************************************************
     C     CANC@C        BEGSR
      *
      * RETURN TO MAIN DETAILS SCREEN
      *
     C                   MOVEL     'M'           @SCRN
      *
      * Initialize field status on main details screen
      *
     C                   EXSR      IFDS@M
      *
      * Set function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFKS@M
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@C - EXIT FROM CONFIRMATION SCREEN
      *****************************************************************
     C     EXIT@C        BEGSR
      *
      * IF NO ERRORS IN VALIDATION
      *
     C     Idx           IFEQ      *ZERO
      *
      * CONTINUE WITH UPDATES
      *
     C                   MOVEL     'U'           @SCRN
      *
      * ELSE, RETURN TO MAIN DETAILS SCREEN
      *
     C                   ELSE
     C                   MOVEL     'M'           @SCRN
      *
      * Initialize field status on main details screen
      *
     C                   EXSR      IFDS@M
      *
      * Set function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFKS@M
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        BEGSR
      *
     C/COPY WNCPYSRC,FXFXDLSC45
      * IF DEAL NUMBER NOT DEFINED (ON INSERT),
      * GET NEXT AVAILABLE DEAL NUMBER
      *
     C     DDDLNO        IFEQ      *BLANK
      *
     C     I#DDDLNO      IFNE      *BLANK
     C                   MOVEL     I#DDDLNO      DDDLNO
     C                   ELSE
     C                   CALLB     'CAGETNXTDL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       @@MSG1            7
     C                   PARM                    DDDLNO
     C                   PARM      *ZERO         F3DN38
      *
      * DATABASE ERROR
      *
     C     @@MSG1        IFNE      *BLANK
     C                   MOVEL     'CAGTNXDL'    DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 002*
     C                   MOVEL     DDDLNO        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
     C                   MOVEL     DDDLNO        @SIDN
     C                   END
      *
      * UPDATE VALID DEAL: DEAL NUMBER
      *
     C                   MOVEL     DDDLNO        F3DN38
      *
      * UPDATE VALID DEAL: LAST ACTION CODE
      *
     C                   MOVEL     DDACTN        F3LACT
     C/COPY WNCPYSRC,FXH00053
      *
      * FOREIGN EXCHANGE DATABASE UPDATES
      *
     C                   CALLB     'FXFXDLUPF'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM                    NwDlFilFmt
     C/COPY WNCPYSRC,FXFXDLSC48
      *
      * DEALS UPDATES
      *
     C     @RTCD         IFEQ      *BLANK
     C                   CALLB     'FXFXDLUPD'
     C                   PARM                    @RTCD
     C                   PARM                    NwDlFilFmt
     C                   END
     C/COPY WNCPYSRC,FXFXDLSC44
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C*****@RTCD         ANDNE     '*RECUPD'                                           CAP006 251029
      *                                                                                       231306
     C     @RTCD         IFEQ      '*RECUPD'                                                  231306
     C     @RTCD         OREQ      '*RECLCK'                                                  231306
     C                   ROLBK                                                                231306
      *                                                                                       231306
     C                   ELSE                                                                 231306
     C                   If        (CSC022 = 'N')                                             CSC022
     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
     C                   ROLBK
     C                   EndIf                                                                CSC022
     C                   EXSR      *PSSR
     C                   ENDIF                                                                231306
     C                   ELSE
     C                   If        (CSC022 = 'N')                                             CSC022
     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   MOVEL     *BLANKS       WFldNamArr                                   CAS004
     C                   MOVEL     *BLANKS       WMsgIdArr                                    CAS004
     C                   MOVEL     *BLANKS       WMsgDtaArr                                   CAS004
     C                   MOVE      *ALL'Y'       FXEFXD                                       CAS004
     C/COPY WNCPYSRC,FXFXDLSC40
     C                   END
      *
     C** If update not done due to record being updated by another              CAP006
     C** workstation send message to screen.                                    CAP006
     C                                                                          CAP006
     C     @RTCD         IFEQ      '*RECUPD'                                    CAP006
     C     @RTCD         OREQ      '*RECLCK'                                                  231306
      *                                                                                       231306
      ** Blank deal number variables if return code is an error due to                        231306
      ** object lock (Recupd).  Deal number generation needs to be                            231306
      ** reset until database update is successful.                                           231306
      *                                                                                       231306
     C     DDACTN        IFEQ      'I'                                                        231306
     C                   MOVE      *BLANKS       DDDLNO                                       231306
     C                   MOVE      *BLANKS       @SIDN                                        231306
     C                   ENDIF                                                                231306
      *                                                                                       231306
     C                                                                          CAP006
     C                   MOVEL     '*ANY'        FldNameArr(1)                  CAP006
      *                                                                                       231306
     C     @RTCD         IFEQ      '*RECUPD'                                                  231306
     C                   MOVEL     'MMM1067'     MsgIdArr(1)                    CAP006
     C                   ELSE                                                                 231306
     C                   MOVEL     'MMM1068'     MsgIdArr(1)                                  231306
      *                                                                                       231306
      ** Even if action "I"nsert was done thru F15, message needs to be                       231306
      ** displayed on main screen to prevent lost of inserted values.                         231306
      *                                                                                       231306
     C                   MOVE      *BLANKS       SAVRDNB           1                          231306
     C                   MOVE      @RDNB         SAVRDNB                                      231306
     C                   MOVE      *BLANKS       @RDNB                                        231306
      *                                                                                       231306
     C                   ENDIF                                                                231306
      *                                                                                       231306
     C                                                                          CAP006
     C**********         END                                                           CAP006 231306
     C                   ELSE                                                                 231306
     C                                                                          CAP006
      * BLANK THE MAIN DETAILS SCREEN
      *
     C                   MOVEL     *BLANK        NwDlScnFmt
     C                   MOVEL     *BLANK        DDSTS
     C                   MOVEL     *BLANK        DDNBRF
     C                   MOVEL     *BLANK        DDNSRF
     C/COPY WNCPYSRC,FXFXDLSC04
      *                                                                         183225
      ** Blank the settlement screen, reset temporary fields                    183225
      *                                                                         183225
     C                   CLEAR                   ##PAYF                         183225
     C                   CLEAR                   ##RECF                         183225
     C                   MOVEL     *BLANK        ##ACTN                         183225
     C                   MOVEL     *BLANK        ##DLNO                         183225
     C                   MOVEL     *BLANK        ##PCCY                         183225
     C                   MOVEL     *BLANK        ##RCCY                         183225
     C                   MOVEL     *BLANK        ##CSNM                         183225
     C                   MOVEL     *BLANK        ##CLSS                         CDL008
      *
      * Initialize field and function key status on main details screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
      *                                                                                       231306
     C     SAVRDNB       IFNE      *BLANKS                                                    231306
     C                   MOVE      SAVRDNB       @RDNB                                        231306
     C                   ENDIF                                                                231306
      *                                                                                       231306
     C                   ENDIF                                                                231306
      *
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C/COPY WNCPYSRC,FXFXDLSC30
     C                   ELSE
      *
      * ELSE, RETURN TO MAIN DETAILS SCREEN
      *
     C                   MOVEL     'M'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - END PROGRAM
      *****************************************************************
     C     ENDP          BEGSR
      *
      * Issue rollback to clear any possible updates in window function
      *
     C     BGWDPR        IFEQ      'Y'
     C                   If        (CSC022 = 'N')                                             CSC022
     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   SetOn                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   END
      *
     C                   MOVEL     'T'           @SCRN
     C/COPY WNCPYSRC,FXFXDLSC01
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
     C                   MOVEL     'FXFXDLSIN'   DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
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
      *                                                                         CDL008
      ** Access SAR details file to determine if CDL008 is on.                  CDL008
      ** (Continuous Linked Settlement)                                         CDL008
      *                                                                         CDL008
     C                   CALLB     'AOSARDR0'                                   CDL008
     C                   PARM      *BLANKS       @RTCD                          CDL008
     C                   PARM      '*VERIFY'     @OPTN                          CDL008
     C                   PARM      'CDL008'      @SARD                          CDL008
     C     SCSARD        PARM      SCSARD        DSFDY                          CDL008
     C     @RTCD         IFNE      *BLANKS                                      CDL008
     C     @RTCD         ANDNE     '*NRF   '                                    CDL008
     C                   MOVEL     'SCSARDPD'    DBFILE                         CDL008
     C                   MOVEL     '903'         DBASE                          CDL008
     C                   MOVEL     'CDL008'      DBKEY                          CDL008
     C                   EXSR      *PSSR                                        CDL008
     C                   ENDIF                                                  CDL008
     C     @RTCD         IFEQ      *BLANKS                                      CDL008
     C                   MOVEL     'Y'           CDL008            1            CDL008
     C                   ELSE                                                   CDL008
     C                   MOVEL     'N'           CDL008                         CDL008
     C                   ENDIF                                                  CDL008
     C/COPY WNCPYSRC,FXFXDLSC31
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      * Start on Main Details Screen
      *
     C                   MOVEL     'M'           @SCRN             1
      *
      * Initialize field and function key status on main details screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
     C/COPY WNCPYSRC,FXH00074
      *

      ** Access SAR details file to determine if Commitment Control                           CSC022
      ** Changes is switched on.                                                              CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD                                        CSC022
     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
     C                   Parm      'CSC022'      @SARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C/COPY WNCPYSRC,FXH00028
     C                   If        @RTCD = *BLANKS                                            CSC022
      *                                                                                       CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        ComitNum > 0                                               CSC022
      ** Check if Current Job exists in the Commitment Job Names                              CSC022
      ** Data Area.                                                                           CSC022
     C                   MoveA     wComitJob     CmtJobNArr                                   CSC022
     C     PSJOBNAME     LookUp    CmtJobNArr                             20                  CSC022
     C                   If        *IN20                                                      CSC022
     C                   Eval      wCommitSkip = 'Y'                                          CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   Else                                                                 CSC022
      ** Database error                                                                       CSC022
     C                   If        @RTCD <> '*NRF'                                            CSC022
     C     *LOCK         In        LDA                                                        CSC022
     C                   Eval      DBKey = 'CSC022'                                           CSC022
     C                   Eval      DBPgm = 'FXFXDLSIN'                                        CSC022
     C                   Eval      DBFile = 'SCSARDPD'                                        CSC022
     C                   Eval      DBase = 904                                                CSC022
     C                   Out       LDA                                                        CSC022
     C                   ExSr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FXFXDLS010

     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY WNCPYSRC,FXFXDLSIC2
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
