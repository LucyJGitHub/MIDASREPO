     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR FRA screen input')                            *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Module                                       *
      *                                                               *
      *  IRFRASIN  - FRA Screen input                                 *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for FRA deals.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD036070           Date 19Oct15               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11376           Date 11May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7166            Date 12May05               *
      *                 CDL028             Date 07Feb05               *
      *                 CDL018             Date 03Feb04               *
      *                 TDA011             Date 31Mar04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAP084             Date 30Jul03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 200400             Date 20Nov01               *
      *                 179510             Date 06Nov00               *
      *                 182224             Date 30Aug00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR005             Date 21Jan00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSW097             Date 02Dec99               *
      *                 162497             Date 18Jun99               *
      *                 165402             DATE 04Aug99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 168981             Date 20May99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP006             DATE 12Mar99               *
      *                 CAP004             Date 20Oct98               *
      *                 CAP003  *CREATE    Date 06Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  MD036070 - No way to go back to main deal details screen     *
      *             after reaching settlement screen.  Introduce new  *
      *             function key F11.                                 *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  BUG11376-Remove the incorrect declaration of STDDECLARE      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG7166- Valid file does not match DEALSDG (Recompile)       *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TDA011 - Rate Fix Ccy writes to the wrong field (Recompile)  *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAP084 - API wrapper project                                 *
      *         - Re-compile due to change in IRFRAPD                 *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  217684 - Authorisation User Malfunction                      *
      *  CAP056 - Automatic Authorisation of Interface Deals          *
      *  CIR008 - FRA/IRS Deals Authorisations                        *
      *  200400 - Reverse fix 179510.                                 *
      *  179510 - For Settlement method 04 , fields  RXURACC & RXUPACC*
      *           Our  Receiving/ Payment  Account   respectively  are*
      *           not  correctly  updated .  Introduced  new  coding  *
      *           to  validate these fields before the update &  Data *
      *           Structure  @MORPI  which is used  for that purpose .*
      *  182224 - Deal Numbers are skipped by auto-allocation process *
      *           in FX & MM input options. When F12 is pressed       *
      *           from the last confirmation screen, the ROLBK        *
      *           is not performed every time.                        *
      *  CIR005 - FRA/IRS Business Day Conventions. Recompiled.       *
      *  CSW097 - SWIFT 1997 Changes for FRAIRS MT34* and MT36*.      *
      *  162497 - Errors in processing of settlement instructions     *
      *           (within ZASETINVAL and ZASETINSIN).                 *
      *  165402 - Fields on deals are being corrupted on amendment    *
      *  168981 - SWIFT 1997 Changes for FRAIRS MT34* and MT36*.      *
      *           (recompiled)                                        *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP006 - Check for deal being updated by another workstation *
      *  CAP004 - Fix to prevent settlement details defaulting when   *
      *           action code = 'E'. (omitted from prev. collection)  *
      *           Add extra parm for Extra Data                       *
      *  CAP003 - Conversion of transaction inputs into modular       *
      *           structure to use as APIs.                           *
      *                                                               *
      *****************************************************************

     F/COPY WNCPYSRC,IRFRASF001
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

      ** Include the FRA/IRS standard declares
     D***/COPY IRCPYSRC,STDDECLARE                                                          BUG11376

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

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

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

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
     D CrDlFilFmt    E DS                  EXTNAME(DEALSDG)
     D**WkCrAutDet          2191   2202                                                CIR008 CGL029
     D  WkCrAutDet          2201   2212                                                       CGL029
      * Current Deal in File Format

     D CrDlScnFmt    E DS                  EXTNAME(IRFRAPD)
      * (Current) Deal in Screen Format
     D                                     PREFIX(@)

     D NwDlFilFmt    E DS                  EXTNAME(IRVFRAPD)
      * New Deal in File Format
     D  FRREC                716    784
     D  FRPAY                785   1343
     D  FRIRS               1345   1992
     D  WkNwAutDet          2093   2104                                                       CIR008

     D NwDlScnFmt    E DS                  EXTNAME(IRFRAPD)
      * New Deal in Screen Format

     D IREFRA        E DS                  EXTNAME(IREFRAPD)
      * Error indicators


     D ##RECF        E DS                  EXTNAME(SDESFRPD)
      ** FILE RECEIVE INSTRUCTIONS
     D**FLREC***               1     69                                                       CGL029
     D  FLREC                  1     75                                                       CGL029

     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
      *** FILE PAYMENT INSTRUCTIONS
     D**FLPAY***               1    559                                                       CGL029
     D  FLPAY                  1    565                                                       CGL029

     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      ** FILE FRA/IRS INSTRUCTIONS
     D**FLFRA******************1    648                                         CSW097
     D  FLFRA                  1    650                                         CSW097

     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      ** SCREEN RECEIVE INSTRUCTIONS

     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      ** SCREEN PAYMENT INSTRUCTIONS

     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      ** SCREEN FRA/IRS INSTRUCTIONS

     D @SETIN          DS
      ** Receive / Pay Settlement Currency, Method & Nostro
     D  @@RSCY                 1      3
     D  @@RSTM                 4      5  0
     D**@@RONS**               6     17                                                       CGL029
     D**@@PSCY**              18     20                                                       CGL029
     D**@@PSTM**              21     22  0                                                    CGL029
     D**@@PONS**              23     34                                                       CGL029
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

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** MIDAS MODULES DETAILS ACCESSED VIA ACCESS PROGRAM

     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CIR008
     D  SCLCD        E                     EXTFLD(LCD)                                        CIR008
      ** SC Switchable features                                                               CIR008
                                                                                              CIR008
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      ************                                                                     179510 200400
     D*@MORPI*****     DS                                                              179510 200400
      ***Midas*Our Receive / Pay  Instructions (for Settl Meth = 04 )                  179510 200400
     D**@@MORI****             1     12                                                179510 200400
     D**@@MOPI****            13     24                                                179510 200400
                                                                                CAP004
     D ExtData       E DS                  EXTNAME(IRFREXPD)                    CAP004
      * IR FRA Extra Data - File (D/B) format                                   CAP004

     D/COPY QWINDSRC,IRFRASIDTA

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')

     D CIR008          S              1                                                       CIR008
     D CAP056          S              1                                                       CAP056
     D PRetCode        S              7                                                       CIR008
     D POption         S              7                                                       CIR008
     D PSard           S              6                                                       CIR008
                                                                                              CIR008
      ** Work variables for CSC022                                                            CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D wCommitSkip     S              1A   INZ('N')                                           CSC022
                                                                                              CSC022
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A
                                                                                              CSD095
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
                                                                                              CSD095
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,IRFRASI008

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
      /COPY WNCPYSRC,IRFRASI001                                                 CAP004
                                                                                CAP004
      * READ NEXT BROWSE SUBFILE RECORD
      *
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   END
      *
      /COPY WNCPYSRC,IRFRASI002                                                 CAP004
                                                                                CAP004
      * DO WHILE SCREEN: MAIN DETAILS
      *
     C     @SCRN         DOWEQ     'M'
     C                   EXSR      SCRN@M
     C                   END
      *
      /COPY WNCPYSRC,IRFRASI003                                                 CAP004
                                                                                CAP004
      * SCREEN: WINDOW
      *
     C     @SCRN         IFEQ      'W'
     C                   EXSR      WINDOW
     C                   END
      *
      /COPY WNCPYSRC,IRFRASI004                                                 CAP004
                                                                                CAP004
      * DO WHILE SCREEN: SETTLEMENT DETAILS
      *
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      SCRN@S
     C                   END
      *
      /COPY WNCPYSRC,IRFRASI005                                                 CAP004
                                                                                CAP004
      * SCREEN: CONFIRMATION OF INPUT
      *
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   END
      *
      /COPY WNCPYSRC,IRFRASI006                                                 CAP004
                                                                                CAP004
      * DO FILE UPDATES
      *
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   END
      *
      /COPY WNCPYSRC,IRFRASI007                                                 CAP004
                                                                                CAP004
      * TERMINATE PROGRAM
      *
     C     @SCRN         IFEQ      'T'
     C                   MOVE      '1'           *INLR
     C                   END
      *****************************************************************

      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,IRFRASI009

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
     C     SDLNO         IFNE      @PDLNO
     C     SACCD         ORNE      @PACTN                                       165402
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
     C                   EVAL      @WFRUN = *BLANKS                                           182224
                                                                                              182224
     C                   END
     C                   END
      *
      * Update 'previous' deal number & screen control indicator
      *
     C                   MOVEL     SDLNO         @PDLNO            6
     C                   MOVEL     SACCD         @PACTN            1            165402
     C                   MOVEL     @CCI@M        @PCI@M
      *
      * WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'IRFRADSP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    NwDlScnFmt
      *
      * DEAL STATUS
     C                   PARM                    DDSTS            24
      *
      * FIELDS IN ERROR
     C                   PARM                    IREFRA
     C/COPY WNCPYSRC,IRH00026
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
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       IREFRA
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
     C/COPY WNCPYSRC,IRH00060
     C                   EXSR      RTVDEL
      *
      * If action code, deal number or booking branch are NOT OK
      * Re-output screen with error messages on it
      *
     C     OKACCD        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C     OKBRCA        OREQ      'N'
     C                   GOTO      EVAL@M
     C                   END
      *
      * Set field and function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      * If action code is delete  or enquire
      * or action code is amend and deal number has changed
      *   Put the deal on the main details screen
      *
     C     SACCD         IFEQ      'R'
     C     SACCD         OREQ      'E'
     C     SACCD         OREQ      'A'
     C     SDLNO         ANDNE     @PDLNO
     C     SACCD         OREQ      'A'                                          165402
     C     SACCD         ANDNE     @PACTN                                       165402
     C     SACCD         OREQ      'X'                                                        CIR008
     C     CIR008        ANDEQ     'Y'                                                        CIR008
     C                   EXSR      PUTD@M
     C                   END
      *
      * If deal number or screen control indicators have changed
      *   Re-output screen
      *
     C     SDLNO         IFNE      @PDLNO
     C     SACCD         ANDNE     'I'
     C     SACCD         ORNE      @PACTN                                       165402
     C     @CCI@M        ORNE      @PCI@M
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      * IF DELETE
      *
     C     SACCD         IFEQ      'R'
      *
      * Update Deal in File Format
      *
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
     C                   EVAL      WkNwAutDet = WkCrAutDet                                    CIR008
     C                   MOVEL     URACC         FRURACC                                      CGL029
     C                   MOVEL     UPACC         FRUPACC                                      CGL029
     C                   MOVEL     RONS          FRRONS                                       CGL029
     C                   MOVEL     PONS          FRPONS                                       CGL029
      *
      * IF CK/10 TAKEN, GO ONTO UPDATES
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVEL     'U'           @SCRN
     C                   END
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      * IF ENQUIRE
      *
     C     SACCD         IFEQ      'E'
      *
      * Update Deal in File Format
      *
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
     C                   EVAL      WkNwAutDet = WkCrAutDet                                    CIR008
     C                   MOVEL     URACC         FRURACC                                      CGL029
     C                   MOVEL     UPACC         FRUPACC                                      CGL029
     C                   MOVEL     RONS          FRRONS                                       CGL029
     C                   MOVEL     PONS          FRPONS                                       CGL029
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
                                                                                              CIR008
      *----------------------------------------------------------------                       CIR008
      ** If Authorize                                                                         CIR008
                                                                                              CIR008
     C                   IF        SACCD = 'X'                                                CIR008
                                                                                              CIR008
      ** Update Deal in File Format                                                           CIR008
                                                                                              CIR008
     C                   EVAL      NwDlFilFmt = CrDlFilFmt                                    CIR008
     C                   EVAL      WkNwAutDet = WkCrAutDet                                    CIR008
     C                   MOVEL     URACC         FRURACC                                      CGL029
     C                   MOVEL     UPACC         FRUPACC                                      CGL029
     C                   MOVEL     RONS          FRRONS                                       CGL029
     C                   MOVEL     PONS          FRPONS                                       CGL029
                                                                                              CIR008
      ** If windows processing on, call window routine                                        CIR008
      ** If Browse outstanding, read next browse subfile record                               CIR008
                                                                                              CIR008
     C                   IF        BGWDPR = 'Y'                                               CIR008
     C                   EVAL      @SCRN = 'W'                                                CIR008
     C                   ELSE                                                                 CIR008
     C                   IF        @RDNB = 'Y'                                                CIR008
     C                   EVAL      @SCRN = 'R'                                                CIR008
     C                   ENDIF                                                                CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
     C                   GOTO      EVAL@M                                                     CIR008
     C                   ENDIF                                                                CIR008
      *
      *----------------------------------------------------------------
      * IF INSERT OR AMEND
      *
     C     SACCD         IFEQ      'I'
     C     SACCD         OREQ      'A'
      *
      * Prior to validation, initialize error indicators as 'OK'
      * and clear Deal in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   MOVE      *ALL'Y'       IREFRA
     C                   CLEAR                   NwDlFilFmt
     C                   Z-ADD     *ZERO         FRRSTM
     C**********         Z-ADD     *ZERO         FRROBN                                       CSD027
     C**********         Z-ADD     *ZERO         FRROCN                                       CSD027
     C                   EVAL      FRROBN = *BLANKS                                           CSD027
     C                   EVAL      FRROCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         FRPSTM
     C**********         Z-ADD     *ZERO         FRPOBN                                       CSD027
     C**********         Z-ADD     *ZERO         FRPOCN                                       CSD027
     C                   EVAL      FRPOBN = *BLANKS                                           CSD027
     C                   EVAL      FRPOCN = *BLANKS                                           CSD027
      *
      * IF AMEND
      *
     C     SACCD         IFEQ      'A'
      *
      * Update Deal in File Format
      *
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
     C                   EVAL      WkNwAutDet = WkCrAutDet                                    CIR008
     C/COPY WNCPYSRC,IRH00061
     C                   MOVEL     URACC         FRURACC                                      CGL029
     C                   MOVEL     UPACC         FRUPACC                                      CGL029
     C                   MOVEL     RONS          FRRONS                                       CGL029
     C                   MOVEL     PONS          FRPONS                                       CGL029
      *
      * Validate whether non-amenable fields have been changed
      *
     C                   CALLB     'IRFRAAMD'
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
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    IREFRA
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
     C                   CALLB     'IRFRAVAL'
     C                   PARM                    RespMode
     C                   PARM                    NwDlScnFmt
     C                   PARM      FRRSCY        @@RSCY
     C                   PARM      FRRSTM        @@RSTM
     C                   PARM      FRRONS        @@RONS
     C                   PARM      FRPSCY        @@PSCY
     C                   PARM      FRPSTM        @@PSTM
     C                   PARM      FRPONS        @@PONS
     C                   PARM                    ExtData                        CAP004
     C                   PARM                    IREFRA
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwDlFilFmt
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
     C                   MOVE      *ALL'Y'       IREFRA
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * Write out screen to remove error messages
      *
     C                   CALLB     'IRFRADSP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    NwDlScnFmt
      *
      * DEAL STATUS
     C                   PARM                    DDSTS            24
      *
      * FIELDS IN ERROR
     C                   PARM                    IREFRA
     C/COPY WNCPYSRC,IRH00027
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
      *
      * IF DEAL NUMBER NOT DEFINED (ON INSERT),
      * GET NEXT AVAILABLE DEAL NUMBER
      *
     C/COPY WNCPYSRC,IRFRASC004
     C     SDLNO         IFEQ      *BLANK
     C                   CALLB     'CAGETNXTDL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       @@MSG1            7
     C                   PARM                    I#SDLNO           6
     C                   PARM      *ZERO         FRDLNO
      *
      * DATABASE ERROR
      *
     C     @@MSG1        IFNE      *BLANK
     C                   MOVEL     'CAGTNXDL'    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   MOVEL     SDLNO         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
                                                                                              182224
      * Set up the work field indicating the Deal No. allocation has run                      182224
     C                   MOVE      'Y'           @WFRUN            1                          182224
                                                                                              182224
     C                   END
      *
     C/COPY WNCPYSRC,IRFRASIMV1
      *
     C                   CALL      'WN0010'
     C                   PARM      'IRFRASIN '   #PGM             10
     C                   PARM                    FKEY              2
     C                   PARM      SACCD         ACTION            1
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
     C     SACCD         OREQ      'E'
     C     @RDNB         IFEQ      'Y'
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
     C                   EVAL      @SCRN = 'M'
     C                   END
     C                   ELSE
     C                   EVAL      @SCRN = 'S'
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
     C     SACCD         IFNE      'A'
     C     SACCD         ANDNE     'R'
     C     CIR008        ANDEQ     'N'                                                        CIR008
     C     SACCD         ORNE      'A'                                                        CIR008
     C     SACCD         ANDNE     'R'                                                        CIR008
     C     SACCD         ANDNE     'X'                                                        CIR008
     C     CIR008        ANDEQ     'Y'                                                        CIR008
     C                   MOVE      'E'           SACCD
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
     C                   CALLB     'IRFRARED'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * ACTION CODE
     C                   PARM                    SACCD
      *
      * DEAL NUMBER POINTER
     C                   PARM                    SDLNO
      *
      * READ FORWARDS
     C                   PARM                    @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM                    @RDBCK            1
                                                                                              CIR008
      ** Switchable feature CIR008                                                            CIR008
     C                   PARM                    CIR008                                       CIR008
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * DEAL NUMBER READ
     C                   PARM      *BLANK        @DLRED            6
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
     C                   MOVEL     @DLRED        SDLNO
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
      *
      * BUILD BROWSE SUBFILE
      *
     C                   CALLB     'IRFRABRW'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * ACTION CODE
     C                   PARM                    SACCD             1
      *
      * DEAL NUMBER POINTER
     C                   PARM                    SDLNO             6
      *
      * BUILD SUB-FILE
     C                   PARM      'Y'           @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      *BLANK        @RDSFL            1
                                                                                              CIR008
      ** Switchable feature CIR008                                                            CIR008
     C                   PARM                    CIR008                                       CIR008
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
      *
      * READ NEXT SUBFILE RECORD
      *
     C                   CALLB     'IRFRABRW'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * ACTION CODE
     C                   PARM                    SACCD             1
      *
      * DEAL NUMBER POINTER
     C                   PARM                    SDLNO             6
      *
      * BUILD SUB-FILE
     C                   PARM      *BLANK        @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      'Y'           @RDSFL            1
                                                                                              CIR008
      ** Switchable feature CIR008                                                            CIR008
     C                   PARM                    CIR008                                       CIR008
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
      *
      * IF DEAL READ FROM SUBFILE
      *
     C     @DLSEL        IFNE      *BLANK
      *
      * Retrieve deal details
      *
     C                   MOVEL     @OPSEL        SACCD
     C                   MOVEL     @DLSEL        SDLNO
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
      *
      * ELSE, RESET READ NEXT BROWSE SUBFILE RECORD
      *
     C                   ELSE
     C                   MOVEL     *BLANK        @RDNB
     C                   END
      *
      * GO TO MAIN DETAILS SCREEN
      *
     C                   MOVE      'M'           @SCRN
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
     C                   CALLB     'IRFRARTV'
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
     C                   PARM                    SACCD
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * Front Office Associated Transaction Id
     C                   PARM                    FOASID           20
      *
      * (Midas) Deal Number
     C                   PARM                    SDLNO
      *
      * (Midas) Associated Deal Number
     C                   PARM                    SLNKDN
      *
      * Booking branch
     C                   PARM                    SBRCA
                                                                                              CIR008
      ** Switchable feature CIR008                                                            CIR008
     C                   PARM                    CIR008                                       CIR008
      *
      * OUTPUTS
      *
      * (Current) deal in file format
     C                   PARM                    CrDlFilFmt
      *
      * OK - Action code
     C                   PARM      *BLANK        OKACCD
      *
      * OK - Deal Number
     C                   PARM      *BLANK        OKDLNO
      *
      * OK - Booking branch
     C                   PARM      *BLANK        OKBRCA
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PUTD@M - PUT A DEAL ON THE MAIN DETAILS SCREEN
      *****************************************************************
     C     PUTD@M        BEGSR
      *
      * Call program to fill screen fields with data from DEALSDG
      *
     C                   CALLB     'IRFRACVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Deal in file format
     C                   PARM                    CrDlFilFmt
                                                                                              CIR008
      ** Switchable feature CIR008                                                            CIR008
     C                   PARM                    CIR008                                       CIR008
      *
      * OUTPUTS
      *
      * Deal in screen format
     C                   PARM                    NwDlScnFmt
      *
      * Deal Status
     C                   PARM                    DDSTS            24
      *
      * Update 'Current' Deal with Deal in Screen Format
      *
     C                   MOVEL     NwDlScnFmt    CrDlScnFmt
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
      * (Action code can only be 'I', 'A', 'E', or 'R')
      *
     C     SACCD         IFEQ      'I'
     C     SACCD         OREQ      'A'
     C                   MOVEL     'Y'           @EKYFD
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EKYFD
     C                   MOVEL     'N'           @EDTFD
     C                   END
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
     C     SACCD         IFEQ      'R'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
      *
      * KN = COMMAND KEY 14 = SETTLEMENT DETAILS
      * (Action codes I and A display settlement details automatically)
      * (No futher screens are available from action code D)
      *
     C     SACCD         IFEQ      'E'
     C                   MOVEL     'Y'           @EINKN
     C                   ELSE
     C                   MOVEL     'N'           @EINKN
     C                   END
      *
      * KP = COMMAND KEY 15 = BROWSE
      *
     C                   MOVEL     'Y'           @EINKP
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
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@M - CANCEL ON MAIN DETAILS SCREEN
      *****************************************************************
     C     CANC@M        BEGSR
      *
      * Reset Read Next Browse Subfile Record (if active)
      *
     C                   MOVEL     *BLANK        @RDNB
      *
      * If input fields are enabled
      * Blank the main details screen
      *
     C     @EKYFD        IFEQ      'Y'
     C     @EDTFD        OREQ      'Y'
     C                   MOVEL     *BLANK        NwDlScnFmt
     C                   MOVEL     *BLANK        DDSTS
     C/COPY WNCPYSRC,IRH00028
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
     C                   MOVE      'N'           OKACCD
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
      *
      * IF FIRST TIME FOR ACTION CODE, DEAL NUMBER, CURRENCY OR CUSTOMER
      *
     C     SACCD         IFNE      ##ACTN
     C     SDLNO         ORNE      ##DLNO
     C     SUCUCY        ORNE      ##PCCY
     C     SCNUM         ORNE      ##CSNM
      *
      * DETERMINE PARAMETERS FOR SETTLEMENT DETAILS INPUT
      *
     C                   EXSR      DETP@S
     C                   END
      *
      * SETTLEMENT INSTRUCTIONS INPUT
      *
     C/COPY WNCPYSRC,IRFRASC001
     C                   CALLB     'ZASETINSIN'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        ##RTCD           10
      *
      * Action code
     C                   PARM      SACCD         ##ACTN            1
      *
      * Deal number
     C                   PARM      SDLNO         ##DLNO            6
      *
      * Protect Payment
     C                   PARM                    ##PPAY            1
      *
      * Protect Receive
     C                   PARM                    ##PREC            1
      *
      * Calling program
     C                   PARM      'FRA '        ##CALP            4
      *
      * Payment currency
     C                   PARM      SUCUCY        ##PCCY            3
      *
      * Receive currency
     C                   PARM      SUCUCY        ##RCCY            3
      *
      * Customer shortname
     C                   PARM      SCNUM         ##CSNM           10
      *
      * Transaction Type
     C                   PARM      SDTYP         ##TTYP            2
      *
      * Federal Funds Ind.
     C                   PARM      SUFFI         ##FFND            1
      *
      * Booking branch
     C                   PARM      SBRCA         ##BRCA            3
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
      ************                                                                     179510 200400
      **MIDAS*Our*Receive/ Pay Instructions (for Settlm Meth = 04 )                    179510 200400
     C************       PARM                    @MORPI                                179510 200400
      *
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
      **PROTECT*PAYMENT/RECEIVE INSTRUCTIONS IF DATES                           162497
      **ARE*IN*THE*PAST*AND THE DEAL WAS NOT DONE TODAY                         162497
      *******************                                                       162497
     C*****FRVDAT********IFLT      BJRDNB                                       162497
     C*****FRORED********ANDNE     BJRDNB                                       162497
     C*****FRORED********ANDNE     *ZERO                                        162497
     C*******************MOVEL     'Y'           ##PPAY                         162497
     C*******************MOVEL     'Y'           ##PREC                         162497
     C*******************ELSE                                                   162497
     C*******************MOVEL     'N'           ##PPAY                         162497
     C*******************MOVEL     'N'           ##PREC                         162497
     C*******************END                                                    162497
      *******************                                                       162497
      **SET*PAY/RECEIVE*DATES*FOR*NOSTRO*BACK-VALUE*CHECK                       162497
      *******************                                                       162497
     C*******************EVAL      ##DATP = FRVDAT                              162497
     C*******************EVAL      ##DATR = FRVDAT                              162497
      *                                                                         162497
      * SET PAY/RECEIVE PROTECTION INDICATORS & DATES                           162497
      *                                                                         162497
     C                   MOVEL     'N'           ##PPAY                         162497
     C                   MOVEL     'N'           ##PREC                         162497
     C                   EVAL      ##DATP = BJRDNB                              162497
     C                   EVAL      ##DATR = BJRDNB                              162497
      *
      * SET UP PAYMENT INSTRUCTIONS FROM DEAL
      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C**********         MOVEL     FRPAY         FLPAY                                        CGL029
     C                   EVAL      %SUBST(FLPAY:1:2) = %SUBST(FRPAY:1:2)                      CGL029
     C                   EVAL      %SUBST(FLPAY:3:18) = FRPONS                                CGL029
     C                   EVAL      %SUBST(FLPAY:21:545) = %SUBST(FRPAY:15:545)                CGL029
     C                   MOVEL     FRPOBR        FLPOBR
     C                   MOVEL     FRCVMR        FLCVMR
     C                   MOVEL     FRPSCY        FLPSCY
     C                   MOVEL     FRIC72        FLIC72
      *
      * SET UP RECEIVE INSTRUCTIONS FROM DEAL
      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C**********         MOVEL     FRREC         FLREC                                        CGL029
     C                   EVAL      %SUBST(FLREC:1:2) = %SUBST(FRREC:1:2)                      CGL029
     C                   EVAL      %SUBST(FLREC:3:18) = FRRONS                                CGL029
     C                   EVAL      %SUBST(FLREC:21:55) = %SUBST(FRREC:15:55)                  CGL029
     C                   MOVEL     FRROBR        FLROBR
     C                   MOVEL     FRRSCY        FLRSCY
      *
      * SET UP FRA/IRS SPECIFIC DATA
      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C                   MOVEL     FRIRS         FLFRA
     C                   MOVE      FRAGVC        FLAGVC                         CSW097
      *
      * IF SETTLEMENT INSTRUCTIONS ARE NOT DEFINED,
      * AND PAYMENT/RECEIPT DATES ARE NOT IN THE PAST, DEFAULT THEM
      *
     C     FLPSTM        IFEQ      *ZERO
     C     ##PPAY        ANDNE     'Y'
     C     FLRSTM        ANDEQ     *ZERO
     C     ##PREC        ANDNE     'Y'
     C     SACCD         ANDNE     'E'                                          CAP004
     C     CIR008        ANDEQ     'N'                                                        CIR008
     C     FLPSTM        OREQ      *ZERO                                                      CIR008
     C     ##PPAY        ANDNE     'Y'                                                        CIR008
     C     FLRSTM        ANDEQ     *ZERO                                                      CIR008
     C     ##PREC        ANDNE     'Y'                                                        CIR008
     C     SACCD         ANDNE     'E'                                                        CIR008
     C     SACCD         ANDNE     'X'                                                        CIR008
     C     CIR008        ANDEQ     'Y'                                                        CIR008
      *
     C                   CALLB     'ZASETINDFT'
      *
      * INPUTS
      *
      * Calling program
     C                   PARM      'FRA '        ##CALP            4
      *
      * Payment currency
     C                   PARM      SUCUCY        ##PCCY            3
      *
      * Receive currency
     C                   PARM      SUCUCY        ##RCCY            3
      *
      * Customer shortname
     C                   PARM      SCNUM         ##CSNM           10
      *
      * Transaction Type
     C                   PARM      SDTYP         ##TTYP            2
      *
      * Federal Funds Ind.
     C                   PARM      SUFFI         ##FFND            1
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
                                                                                CSW097
      ** Version of ISDA Agreement century                                      CSW097
     C                   PARM                    BQAGVC            2            CSW097
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
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
     C                   PARM                    ##FRIF
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
     C                   PARM      SUCUCY        InRCCY                                      CSF011A
     C                   PARM      SUCUCY        InPCCY                                      CSF011A
                                                                                CSW097
      *                                                                         CSW097
      ** Set screen numeric fields to blank, if zero on file                    CSW097
      *                                                                         CSW097
     C     SACCD         IFNE      'I'                                          CSW097
     C     AGDT          IFEQ      *ZERO                                        CSW097
     C                   MOVE      *BLANK        DDAGDT                         CSW097
     C                   ENDIF                                                  CSW097
     C     AGVV          IFEQ      *ZERO                                        CSW097
     C     AGVC          ANDEQ     *ZERO                                        CSW097
     C                   MOVE      *BLANK        DDAGVV                         CSW097
     C                   ENDIF                                                  CSW097
     C                   ENDIF                                                  CSW097
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@S - CANCEL ON SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     CANC@S        BEGSR
      *
      * Return to Main Details Screen
      *
     C                   MOVEL     'M'           @SCRN
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
     C**********         MOVEL     FLPAY         FRPAY                                        CGL029
     C                   EVAL      %SUBST(FRPAY:1:2) = %SUBST(FLPAY:1:2)                      CGL029
     C                   EVAL      FRPONS = %SUBST(FLPAY:3:18)                                CGL029
     C                   EVAL      %SUBST(FRPAY:15:545) = %SUBST(FLPAY:21:545)                CGL029
     C                   MOVEL     FLPOBR        FRPOBR
     C                   MOVEL     FLCVMR        FRCVMR
      *
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **DataStructure**into*the**correspondent**file**field**.*******                  179510 200400
      ************                                                                     179510 200400
     C*****DDPSTM*       IFEQ      '04'                                                179510 200400
     C************       MOVE      @@MOPI        FRUPACC                               179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
      * UPDATE VALID DEAL: RECEIPT SETTLEMENT INSTRUCTIONS
      *
     C**********         MOVEL     FLREC         FRREC                                        CGL029
     C                   EVAL      %SUBST(FRREC:1:2) = %SUBST(FLREC:1:2)                      CGL029
     C                   EVAL      FRRONS = %SUBST(FLREC:3:18)                                CGL029
     C                   EVAL      %SUBST(FRREC:15:55) = %SUBST(FLREC:21:55)                  CGL029
     C                   MOVEL     FLROBR        FRROBR
      *
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **DataStructure**into*the**correspondent**file**field**.*******                  179510 200400
      ************                                                                     179510 200400
     C*****DDRSTM*       IFEQ      '04'                                                179510 200400
     C************       MOVE      @@MORI        FRURACC                               179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
      * UPDATE VALID DEAL: SETTLEMENT CURRENCY & 'IN' CCY IN FIELD 72
      *
     C                   MOVEL     FLRSCY        FRRSCY
     C                   MOVEL     FLPSCY        FRPSCY
     C                   MOVEL     FLIC72        FRIC72
      *
      * UPDATE VALID DEAL: FRA/IRS DETAILS
      *
     C                   MOVEL     FLFRA         FRIRS
     C                   MOVEL     FLAGVC        FRAGVC                         CSW097
      ******                                                                    CSW097
      **Zeroise*numeric*fields*in*FRIRS*for*update*(these*fields*are*not        CSW097
      **used*for*FRAs)                                                          CSW097
      ******                                                                    CSW097
     C******             Z-ADD     *ZERO         FRISDA                         CSW097
     C******             Z-ADD     *ZERO         FRAGDT                         CSW097
     C******             Z-ADD     *ZERO         FRAGVV                         CSW097
      *                                                                         CSW097
      * Zeroise numeric fields in FRIRS for update (these fields may be         CSW097
      * blank if Type is OTHER)                                                 CSW097
      *                                                                         CSW097
     C     FLISDA        IFEQ      *BLANK                                       CSW097
     C                   Z-ADD     *ZERO         FRISDA                         CSW097
     C                   ENDIF                                                  CSW097
     C     FLAGDT        IFEQ      *BLANK                                       CSW097
     C                   Z-ADD     *ZERO         FRAGDT                         CSW097
     C                   ENDIF                                                  CSW097
     C     FLAGVV        IFEQ      *BLANK                                       CSW097
     C                   Z-ADD     *ZERO         FRAGVV                         CSW097
     C                   ENDIF                                                  CSW097
     C     FLAGVC        IFEQ      *BLANK                                       CSW097
     C                   Z-ADD     *ZERO         FRAGVC                         CSW097
     C                   ENDIF                                                  CSW097
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
     C                   MOVE      *ALL'Y'       IREFRA
      *
      * Validate deal details
      *
     C                   CALLB     'IRFRAVAL'
     C                   PARM                    RespMode
     C                   PARM                    NwDlScnFmt
     C                   PARM      FRRSCY        @@RSCY
     C                   PARM      FRRSTM        @@RSTM
     C                   PARM      FRRONS        @@RONS
     C                   PARM      FRPSCY        @@PSCY
     C                   PARM      FRPSTM        @@PSTM
     C                   PARM      FRPONS        @@PONS
     C                   PARM                    ExtData                        CAP004
     C                   PARM                    IREFRA
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *ZERO         Idx               3 0
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      *ZERO         WIdx              3 0
     C                   PARM                    NwDlFilFmt
      *
      * If transaction is valid output message 'Press enter to accept'
      *
     C     Idx           IFEQ      *ZERO
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1030'     MsgIdArr(1)
     C                   END
      *
      * WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'IRFRADSP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    NwDlScnFmt
      *
      * DEAL STATUS
     C                   PARM                    DDSTS            24
      *
      * FIELDS IN ERROR
     C                   PARM                    IREFRA
     C/COPY WNCPYSRC,IRH00029
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
     C                   PARM      'N'           @EKYFD
     C                   PARM      'N'           @EDTFD
      *
      * ENABLED FUNCTION KEYS
     C                   PARM      'N'           @EINKG
     C                   PARM      'N'           @EINKH
     C                   PARM      'N'           @EINKJ
     C                   PARM      'N'           @EINKN
     C                   PARM      'N'           @EINKP
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
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       IREFRA
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
     C/COPY WNCPYSRC,IRFRASC003
      * IF DEAL NUMBER NOT DEFINED (ON INSERT),
      * GET NEXT AVAILABLE DEAL NUMBER
      *
     C     SDLNO         IFEQ      *BLANK
      *
     C     I#SDLNO       IFNE      *BLANK
     C                   MOVEL     I#SDLNO       SDLNO
     C                   ELSE
     C                   CALLB     'CAGETNXTDL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       @@MSG1            7
     C                   PARM                    SDLNO
     C                   PARM      *ZERO         FRDLNO
      *
      * DATABASE ERROR
      *
     C     @@MSG1        IFNE      *BLANK
     C                   MOVEL     'CAGTNXDL'    DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 002*
     C                   MOVEL     SDLNO         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
     C                   MOVEL     SDLNO         @SIDN
     C                   END
      *
      * UPDATE VALID DEAL: DEAL NUMBER
      *
     C                   MOVEL     SDLNO         FRDLNO
      *
      * UPDATE VALID DEAL: LAST ACTION CODE
      *
     C                   MOVEL     SACCD         FRCHTP
     C/COPY WNCPYSRC,IRH00030
      *
      * DEALS UPDATES
      *
     C                   CALLB     'IRFRAUPD'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '      '      @@MODE                                       CAP056
     C                   PARM                    NwDlFilFmt
     C                   PARM                    CIR008                                       CIR008
     C                   PARM                    CAP056                                       CAP056
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTION, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'                                    CAP006
     C                   If        (CSC022 = 'N')                                             CSC022
     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
     C                   ROLBK
     C                   EndIf                                                                CSC022
     C                   EXSR      *PSSR
     C                   ELSE
     C                   If        (CSC022 = 'N')                                             CSC022
     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                  CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C/COPY WNCPYSRC,IRFRASC002
     C                   END
      *
     C** If update not done due to record being updated by another              CAP006
     C** workstation send message to screen.                                    CAP006
     C                                                                          CAP006
     C     @RTCD         IFEQ      '*RECUPD'                                    CAP006
     C                                                                          CAP006
     C                   MOVEL     '*ANY'        FldNameArr(1)                  CAP006
     C                   MOVEL     'MMM1067'     MsgIdArr(1)                    CAP006
     C                                                                          CAP006
     C                   END                                                    CAP006
     C                                                                          CAP006
      * BLANK THE MAIN DETAILS SCREEN
      *
     C                   MOVEL     *BLANK        NwDlScnFmt
     C                   MOVEL     *BLANK        DDSTS
     C/COPY WNCPYSRC,IRH00031
      *
      * Initialize field and function key status on main details screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
      *
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
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
     C                   MOVEL     'IRFRASIN '   DBPGM
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
                                                                                              CIR008
      ** Check if FRA/IRS Deals Authorisations is installed                                   CIR008
                                                                                              CIR008
     C                   EVAL      CIR008 = 'N'                                               CIR008
     C                   CALL      'AOSARDR0'                                                 CIR008
     C                   PARM      *BLANKS       PRetCode                                     CIR008
     C                   PARM      '*VERIFY'     POption                                      CIR008
     C                   PARM      'CIR008'      PSard                                        CIR008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR008
                                                                                              CIR008
     C                   IF        PRetCode = *Blanks                                         CIR008
     C                   EVAL      CIR008 = 'Y'                                               CIR008
     C                   ELSE                                                                 CIR008
     C                   IF        PRetCode <> '*NRF   '                                      CIR008
     C     *LOCK         IN        LDA                                                        CIR008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CIR008
     C                   EVAL      DBASE = 3                                                  CIR008
     C                   EVAL      DBKEY = 'CIR008'                                           CIR008
     C                   OUT       LDA                                                        CIR008
     C                   EXSR      *PSSR                                                      CIR008
     C                   ENDIF                                                                CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CAP056
      ** Check if Automatic Authorisation of Interface deals is installed                     CAP056
                                                                                              CAP056
     C                   EVAL      CAP056 = 'N'                                               CAP056
     C                   CALL      'AOSARDR0'                                                 CAP056
     C                   PARM      *BLANKS       PRetCode                                     CAP056
     C                   PARM      '*VERIFY'     POption                                      CAP056
     C                   PARM      'CAP056'      PSard                                        CAP056
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP056
                                                                                              CAP056
     C                   IF        PRetCode = *Blanks                                         CAP056
     C                   EVAL      CAP056 = 'Y'                                               CAP056
     C                   ELSE                                                                 CAP056
     C                   IF        PRetCode <> '*NRF   '                                      CAP056
     C     *LOCK         IN        LDA                                                        CAP056
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP056
     C                   EVAL      DBASE = 4                                                  CAP056
     C                   EVAL      DBKEY = 'CAP056'                                           CAP056
     C                   OUT       LDA                                                        CAP056
     C                   EXSR      *PSSR                                                      CAP056
     C                   ENDIF                                                                CAP056
     C                   ENDIF                                                                CAP056
      *
      * Start on Main Details Screen
      *
     C                   MOVEL     'M'           @SCRN             1
      *
      * Initialize field and function key status on main details screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
      *

      ** Access SAR details file to determine if Commitment Control                           CSC022
      ** Changes is switched on.                                                              CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD                                        CSC022
     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
     C                   Parm      'CSC022'      @SARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
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
     C                   Eval      DBPgm = 'IRFRASIN '                                        CSC022
     C                   Eval      DBFile = 'SCSARDPD'                                        CSC022
     C                   Eval      DBase = 903                                                CSC022
     C                   Out       LDA                                                        CSC022
     C                   ExSr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,IRFRASI010

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
