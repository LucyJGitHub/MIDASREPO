     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Cross ccy IRS screen input')                  *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Module                                       *
      *                                                               *
      *  IRCIRSSIN  - IRS Screen input                                *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for IRS cross currency deals.                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD036070           Date 19Oct15               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CIR014             Date 11May06               *
      *                 BUG11376           Date 11May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CAS008             Date 16Jun04               *
      *                 BUG6472            Date 20Apr05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG4307            Date 23Sep04               *
      *                 CGL014             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 CDL018             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 218641             Date 10Jun03               *
      *                 CAS004             Date 26Jun02               *
      *                 CAP043             Date 02May02               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      *                 CAS001             Date 23Nov01               *
      *                 CAP041             Date 10Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 200400             Date 20Nov01               *
      *                 198338             Date 03Oct01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 185057             Date 23Jan01               *
      *                 184560             Date 23Jan01               *
      *                 CIR003             Date 13Sep00               *
      *                 CIR006             Date 12Sep00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 187606             Date 12Dec00               *
      *                 179510             Date 17Jul00               *
      *                 182224             Date 30Aug00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR005             Date 21Jan00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSW097             Date 01Apr99               *
      *                 168628             Date 05Oct99               *
      *                 165402             DATE 04Aug99               *
      *                 162497             DATE 18Jun99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 168981             Date 20May99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP006             DATE 16Mar99               *
      *                 CAP004  *CREATE    Date 19Aug98               *
      *                 CAP003  *CREATE    Date 09Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD036070 - No way to go back to main deal details screen     *
      *             after reaching settlement screen.  Introduce new  *
      *             function key F11.                                 *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CIR014 - Mark to Market Cross-currency Interest Rate Swaps   *
      *           (Recompile)                                         *
      *  BUG11376-Remove the incorrect declaration of STDDECLARE      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CAS008 - IAS 39 Enhancements                                 *
      *  BUG6472- Added sign field for short term rate (Recompile)    *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  BUG4307- Database error when entering a deal where deal no   *
      *           is inserted                                         *
      *  CGL014 - Collaterals Processing                              *
      *  CLE025 - Credit Lines                                        *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  218641 - Adjust Yield Curve field position in the definition *
      *           file                                                *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CAP043 - Additional APIs for IRS Schedules                   *
      *  217684 - Authorisation User Malfunction (Recompile).         *
      *  CAP056 - Automatic Authorisation of Interface Deals          *
      *  CIR008 - FRA/IRS Deals Authorisations                        *
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  CAP041 - APIs for IRS Fees/Buy-Outs/Processing Method/Next   *
      *           Principal Change Date.                              *
      *  200400 - Reverse fix 179510.                                 *
      *  198338 - No decimals allowed in 'Amount' field in Our/ Their *
      *           Cash Flow Schedule  input-screens, when  Our/ Their *
      *           Int Paym Freq  is  'C'.                             *
      *           Amend the pgm to use  correct value for  WPNBDP ;   *
      *           WRNBDP  &  WNBDP -Number of Decimal places .        *
      *           Re-compiled  over changed  IRCIRSCHD  module .      *
      *  185057 - Validate 'Rate fix days' and 'Rate change Date,     *
      *           only if one of them has changed.                    *
      *           Pass the parameters down.                           *
      *  184560 - Validate Maturity date correctly against            *
      *           Our and Their Start/Last Int Pay Date.              *
      *  CIR003 - Principal Exchange on Cross Currencies IRS.         *
      *  CIR006 - FRA/IRS Amortisation of Caps/Collars/Floors &       *
      *           Individual Compounding Swaps. Coding done for       *
      *           Individual Compounding Swaps only.                  *
      *  187606 - Do not validate the Amount/Base Currency Rate       *
      *           in Amend mode.                                      *
      *  179510 - For Settlement method 04 , fields  RXURACC & RXUPACC*
      *           Our  Receiving/ Payment  Account   respectively  are*
      *           not  correctly  updated .  Introduced  new  coding  *
      *           to  validate these fields before the update &  Data *
      *           Structure  @MORPI  which is used  for that purpose .*
      *  182224 - Deal Numbers are skipped by  Auto-allocation  process
      *           in   FX &  MM  input options .  When  F12  is pressed
      *           from  the last confirmation  screen ,  the  ROLBK   *
      *           is not performed  every time .                      *
      *  CIR005 - FRA/IRS Business Day Conventions                    *
      *  CSW097 - Swift 97 changes to MT340s and MT360s               *
      *  168628 - Recompile for change to /COPY IRCIRSMOV2            *
      *  165402 - Fields on deals are being corrupted on amendment    *
      *  162497 - Errors in processing of settlement instructions     *
      *           (within ZASETINVAL and ZASETINSIN).                 *
      *  168981 - SWIFT 1997 Changes for FRAIRS MT34* and MT36*.      *
      *           (recompiled)                                        *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP006 - Check for deal being updated by another workstation *
      *  CAP004 - Add APIs Interest Rate Calendar processing          *
      *           Add extra parm for Extra Data                       *
      *  CAP003 - Conversion of transaction inputs into modular       *
      *           structure to use as APIs.                           *
      *                                                               *
      *****************************************************************
 
     F/COPY WNCPYSRC,IRCIRSSF01
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
 
      ** Array of error message IDs from IRC date schedule screens
     D @ErrAR          S                   DIM(10)
     D                                     LIKE(#MsgID)
     D @WerrAr         S                   DIM(10)
     D                                     LIKE(#MsgID)
      *                                                                         CIR005
      ** Error array used by IRCBSDYVAL                                         CIR005
     D MsgIdErr        S                   DIM(ArrayMax)                        CIR005
     D                                     LIKE(#MsgID)                         CIR005
      *                                                                         CIR005
      ** Array for fields in error                                              CIR005
     D FldNameErr      S             10A   DIM(ArrayMax)                        CIR005
      *                                                                         CIR005
      ** Warning array used by IRCBSDYVAL                                       CIR005
     D WMsgIdErr       S                   DIM(ArrayMax)                        CIR005
     D                                     LIKE(MsgIdArr)                       CIR005
      *                                                                         CIR005
      ** Array for fields in warning                                            CIR005
     D WFldNamErr      S                   DIM(ArrayMax)                        CIR005
     D                                     LIKE(FldNameArr)                     CIR005
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D CrDlFilFmt    E DS                  EXTNAME(DEALSDG)
      * Current Deal in File Format
                                                                                              CLE025
     D CrDlXFilFmt   E DS                  EXTNAME(DLDLDGQD)                                  CLE025
      ** Current Deal Extension in File Format                                                CLE025
 
     D CrDlScnFmt    E DS                  EXTNAME(IRCIRSPD)
      * (Current) Deal in Screen Format
     D                                     PREFIX(@)
 
     D NwDlFilFmt    E DS                  EXTNAME(IRVCIRSPD)
      * New Deal in File Format
     D  RXREC                716    784
     D  RXPAY                785   1343
     D  RXIRS               1345   1992
                                                                                              CLE025
     D NwDlXFilFmt   E DS                  EXTNAME(IRVXSIRPD)                                 CLE025
      * New Deal Extension in File Format                                                     CLE025
 
     D NwDlScnFmt    E DS                  EXTNAME(IRCIRSPD)
      * New Deal in Screen Format
                                                                                CIR005
     D*BsDayConv*************243    370                                                CIR005 218641
     D**RCcy1****************277    306                                                CIR005 218641
     D**RCcy2****************341    370                                                CIR005 218641
     D*BsDayConv*************253    380                                                218641 CAS005
     D**RCcy1****************287    316                                                218641 CAS005
     D**RCcy2****************351    380                                                218641 CAS005
     D*BsDayConv*************263    390                                                CAS005 CLE025
     D**RCcy1****************297    326                                                CAS005 CLE025
     D**RCcy2****************361    390                                                CAS005 CLE025
     D*BsDayConv             278    405                                                CLE025 CAS008
     D**RCcy1***             312    341                                                CLE025 CAS008
     D**RCcy2***             376    405                                                CLE025 CAS008
     D BsDayConv             288    415                                                       CAS008
     D  RCcy1                322    351                                                       CAS008
     D  RCcy2                386    415                                                       CAS008
      ** Cross Currency Business Day Conventions layout                         CIR005
 
     D IRECIRS       E DS                  EXTNAME(IRECIRSPD)
      * Error indicators
 
 
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
      ** FILE RECEIVE INSTRUCTIONS
     D***FLREC**                1     69                                                      CGL029
     D  FLREC                  1     75                                                       CGL029
 
     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
      *** FILE PAYMENT INSTRUCTIONS
     D***FLPAY**                1    559                                                      CGL029
     D  FLPAY                  1    565                                                       CGL029
 
     D ##RXIF        E DS                  EXTNAME(SDESFFPD)
      ** FILE FRA/IRS INSTRUCTIONS
     D**FLIRS******************1    648                                         CSW097
     D  FLIRS                  1    650                                         CSW097
 
     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      ** SCREEN RECEIVE INSTRUCTIONS
 
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      ** SCREEN PAYMENT INSTRUCTIONS
 
     D ##RXIS        E DS                  EXTNAME(SDESSFPD)
      ** SCREEN FRA/IRS INSTRUCTIONS
                                                                                CAP004
     D ExtData       E DS                  EXTNAME(IRCSEXPD)                    CAP004
      * IR Cross Ccy IRS Extra Data - File (D/B) format                         CAP004
 
     D ExtSett1      E DS                  EXTNAME(IRVXSETPD)                                 CIR003
     D                                     PREFIX(E1)                                         CIR003
      * External Settlement for Value Date                                                    CIR003
                                                                                              CIR003
     D ExtSett2      E DS                  EXTNAME(IRVXSETPD)                                 CIR003
     D                                     PREFIX(E2)                                         CIR003
      * External Settlement for Interest Date                                                 CIR003
                                                                                              CIR003
     D ExtSett3      E DS                  EXTNAME(IRVXSETPD)                                 CIR003
     D                                     PREFIX(E3)                                         CIR003
      * External Settlement for Maturity Date                                                 CIR003
                                                                                              CIR003
     D @SETIN          DS
      ** Receive / Pay Settlement Method & Nostro
     D  @@RSCY                 1      3
     D  @@RSTM                 4      5  0
     D***@@RONS*                6     17                                                      CGL029
     D***@@PSCY*               18     20                                                      CGL029
     D***@@PSTM*               21     22  0                                                   CGL029
     D***@@PONS*               23     34                                                      CGL029
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
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
     D  SCLCD        E                     EXTFLD(LCD)
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      ************                                                                     179510 200400
     D*@MORPI*****     DS                                                              179510 200400
      ***Midas*Our Receive / Pay  Instructions (for Settl Meth = 04 )                  179510 200400
     D**@@MORI****             1     12                                                179510 200400
     D**@@MOPI****            13     24                                                179510 200400
                                                                                              CGL014
     D DLUFBO        E DS                  EXTNAME(DLUFBOPD) DTAARA                           CGL014
      ** Up-front and Buy-out Details                                                         CGL014
 
     D/COPY QWINDSRC,IRCIRSGDTA
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** Screen/Server input flag (passed to IRCIRSUPD to indicate              CAP004
      ** source of transaction.                                                 CAP004
     D ScreenInpt      S              1A                                        CAP004
      *                                                                         CIR005
      ** First pass flag                                                        CIR005
     D WFrstPas        S              1A   INZ('Y')                             CIR005
      *                                                                         CIR005
      ** Validate Business Day Convention flag                                  CIR005
     D WValBDC         S              1A   INZ('N')                             CIR005
      *                                                                         CIR005
      ** Mode of operation received from controller                             CIR005
     D ModeOfOp        S              6A   INZ('*SIN  ')                        CIR005
                                                                                              CAP056
     D PModeOfOp       S              6A                                                      CAP056
                                                                                CIR005
     D POKFlags        S             60                                         CIR005
                                                                                CIR005
     D PFuncKey        S              2                                         CIR005
                                                                                CIR005
     D WSavBDC         S            128                                         CIR005
                                                                                CIR005
     D WrnFlag         S              1    INZ('N')                             CIR005
                                                                                CIR005
     D WSavRC1         S             30                                         CIR005
                                                                                CIR005
     D WSavRC2         S             30                                         CIR005
                                                                                CIR005
     D WFreqZ          S              1                                         CIR005
                                                                                CAP004
     D CIR008          S              1A                                                      CIR008
     D CAP056          S              1A                                                      CAP056
     D PRetCode        S              7A                                                      CIR008
     D POption         S              7A                                                      CIR008
     D PSard           S              6A                                                      CIR008
                                                                                              CIR008
     D CLE025          S              1A                                                      CLE025
     D CGL014          S              1A                                                      CGL014
                                                                                              CLE025
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
      /COPY WNCPYSRC,IRCIRSS009
 
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
      /COPY WNCPYSRC,IRCIRSS001                                                 CAP004
                                                                                CAP004
      * READ NEXT BROWSE SUBFILE RECORD
      *
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   END
      *
      /COPY WNCPYSRC,IRCIRSS002                                                 CAP004
                                                                                CAP004
      * DO WHILE SCREEN: MAIN DETAILS
      *
     C     @SCRN         DOWEQ     'M'
     C                   EXSR      SCRN@M
     C                   END
      *
      /COPY WNCPYSRC,IRCIRSS003                                                 CAP004
                                                                                CAP004
      * DO WHILE SCHEDULE DATES REQUIRE PROCESSING (FOR IRC FEATURE)
      *
     C     CIR001        IFEQ      'Y'
     C     @SCRN         ANDEQ     'X'
     C                   EXSR      SCHEDULES
     C                   END
      *
      * SHOW FEES/BUYOUT DETAILS IF SWITCHED ON                                               CAP041
     C     @SCRN         IFEQ      'F'                                                        CAP041
     C                   EXSR      SRFeeBuy                                                   CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
      /COPY WNCPYSRC,IRCIRSS004                                                 CAP004
                                                                                CAP004
      * SCREEN: WINDOW
      *
     C     @SCRN         IFEQ      'W'
     C                   EXSR      WINDOW
     C                   END
      *
      /COPY WNCPYSRC,IRCIRSS005                                                 CAP004
                                                                                CAP004
      * DO WHILE SCREEN: SETTLEMENT DETAILS
      *
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      SCRN@S
     C                   END
      *
      /COPY WNCPYSRC,IRCIRSS006                                                 CAP004
                                                                                CAP004
      * SCREEN: CONFIRMATION OF INPUT
      *
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   END
      *
      /COPY WNCPYSRC,IRCIRSS007                                                 CAP004
                                                                                CAP004
      * DO FILE UPDATES
      *
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   END
      *
      /COPY WNCPYSRC,IRCIRSS008                                                 CAP004
                                                                                CAP004
      * TERMINATE PROGRAM
      *
     C     @SCRN         IFEQ      'T'
     C                   MOVE      '1'           *INLR
     C                   END
      *****************************************************************
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,IRCIRSS010
 
      /EJECT
      *****************************************************************
      * SCRN@M - PROCESS SCREEN: MAIN DETAILS
      *****************************************************************
     C     SCRN@M        BEGSR
      *
      * Issue rollback to clear any possible updates in window function
      * Clear down any warning messages from IRC date schedule screens
      * (only if IRC feature on)
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
     C                   ROLBK
                                                                                              182224
     C                   EVAL      @WFRUN = *BLANKS                                           182224
                                                                                              182224
     C     CIR001        IFEQ      'Y'
     C                   MOVEL     *BLANK        @WerrAr
     C                   END
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
     C                   CALLB     'IRCIRSDSP'
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
     C                   PARM                    IRECIRS
     C/COPY WNCPYSRC,IRH00012
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
     C                   MOVE      *ALL'Y'       IRECIRS
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
     C/COPY WNCPYSRC,IRH00058
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
      *                                                                         CIR005
      ** Reset first pass field if action or deal no. has changed.              CIR005
     C                   IF        (CIR005 = 'Y')                               CIR005
     C                   IF        SDLNO <> @PDLNO                              CIR005
     C                             OR SACCD <> @PACTN                           CIR005
     C                   IF        (SACCD = 'I') Or (SACCD = 'A')               CIR005
     C                   EVAL      WFrstPas = 'Y'                               CIR005
     C                   EVAL      WSavBDC = *Blanks                            CIR005
     C                   EVAL      BsDayConv = *Blanks                          CIR005
     C                   ENDIF                                                  CIR005
     C                   ENDIF                                                  CIR005
     C                   ENDIF                                                  CIR005
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
     C                   MOVEL     URACC         RXURACC                                      CGL029
     C                   MOVEL     UPACC         RXUPACC                                      CGL029
     C                   MOVEL     RONS          RXRONS                                       CGL029
     C                   MOVEL     PONS          RXPONS                                       CGL029
     C     CLE025        IFEQ      'Y'                                                        CLE025
     C                   MOVEL     CrDlXFilFmt   NwDlXFilFmt                                  CLE025
     C                   ENDIF                                                                CLE025
      *
      * IF CK/10 TAKEN, GO ONTO UPDATES
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVEL     'U'           @SCRN
     C                   ELSE                                                   CIR005
      *                                                                         CIR005
      ** Display Business Day Convention Screen                                 CIR005
     C                   IF        CIR005 = 'Y' and                             CIR005
     C                             BsDayConv <> *Blanks                         CIR005
     C                   EXSR      SRBusDay                                     CIR005
      *                                                                         CIR005
      ** F12 pressed, back to main screen                                       CIR005
     C                   IF        PFuncKey = '12'                              CIR005
     C                   EVAL      @SCRN = 'M'                                  CIR005
     C                   EVAL      PFuncKey = *Blank                            CIR005
     C                   GOTO      EVAL@M                                       CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
      ** F3 pressed, end program                                                CIR005
     C                   IF        PFuncKey = '03'                              CIR005
     C                   EXSR      ENDP                                         CIR005
     C                   GOTO      EVAL@M                                       CIR005
     C                   ENDIF                                                  CIR005
                                                                                CIR005
     C                   ENDIF                                                  CIR005
                                                                                CIR005
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
     C                   MOVEL     URACC         RXURACC                                      CGL029
     C                   MOVEL     UPACC         RXUPACC                                      CGL029
     C                   MOVEL     RONS          RXRONS                                       CGL029
     C                   MOVEL     PONS          RXPONS                                       CGL029
     C     CLE025        IFEQ      'Y'                                                        CLE025
     C                   MOVEL     CrDlXFilFmt   NwDlXFilFmt                                  CLE025
     C                   ENDIF                                                                CLE025
      *
      * IF CK/14 TAKEN, CONTINUE TO SETTLEMENTS SCREEN
      ** If Fees/Buyouts on, show Fees/Buyout details                                         CAP041
      * If windows processing on, call window routine
      * IF BROWSE OUTSTANDING, READ NEXT BROWSE SUBFILE RECORD
      *
     C     @INKN         IFEQ      '1'
     C                   MOVEL     'S'           @SCRN
     C                   ELSE
     C     CIR001        IFEQ      'Y'
     C                   MOVEL     'X'           @SCRN
     C                   ELSE
     C     CAP041        IFEQ      'Y'                                                        CAP041
     C                   MOVEL     'F'           @SCRN                                        CAP041
     C                   ELSE                                                                 CAP041
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   END
     C                   END
     C                   ENDIF                                                                CAP041
     C                   END
      *                                                                         CIR005
      ** Display Business Day Convention Screen                                 CIR005
     C                   IF        CIR005 = 'Y' and                             CIR005
     C                             BsDayConv <> *Blank                          CIR005
     C                   EXSR      SRBusDay                                     CIR005
      *                                                                         CIR005
      ** F12 pressed, back to main screen                                       CIR005
     C                   IF        PFuncKey = '12'                              CIR005
     C                   EVAL      @SCRN = 'M'                                  CIR005
     C                   EVAL      PFuncKey = *Blank                            CIR005
     C                   GOTO      EVAL@M                                       CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
      ** F3 pressed, end program                                                CIR005
     C                   IF        PFuncKey = '03'                              CIR005
     C                   EXSR      ENDP                                         CIR005
     C                   GOTO      EVAL@M                                       CIR005
     C                   ENDIF                                                  CIR005
                                                                                CIR005
     C                   ENDIF                                                  CIR005
                                                                                CIR005
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
     C                   MOVEL     URACC         RXURACC                                      CGL029
     C                   MOVEL     UPACC         RXUPACC                                      CGL029
     C                   MOVEL     RONS          RXRONS                                       CGL029
     C                   MOVEL     PONS          RXPONS                                       CGL029
     C     CLE025        IFEQ      'Y'                                                        CLE025
     C                   EVAL      NwDlXFilFmt = CrDlXFilFmt                                  CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CIR008
      ** If CIR001 is installed, display the schedules,                                       CIR008
      ** otherwise, display the window                                                        CIR008
      ** otherwise, read next browse                                                          CIR008
                                                                                              CIR008
     C                   IF        CIR001 = 'Y'                                               CIR008
     C                   EVAL      @SCRN = 'X'                                                CIR008
     C                   ELSE                                                                 CIR008
     C                   IF        BGWDPR = 'Y'                                               CIR008
     C                   EVAL      @SCRN = 'W'                                                CIR008
     C                   ELSE                                                                 CIR008
     C                   IF        @RDNB = 'Y'                                                CIR008
     C                   EVAL      @SCRN = 'R'                                                CIR008
     C                   ENDIF                                                                CIR008
     C                   ENDIF                                                                CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
     C                   IF        CIR005 = 'Y' AND                                           CIR008
     C                             BsDayConv <> *BLANKS                                       CIR008
     C                   EXSR      SrBusDay                                                   CIR008
                                                                                              CIR008
      ** F12 pressed, back to main screen                                                     CIR008
                                                                                              CIR008
     C                   IF        PFuncKey = '12'                                            CIR008
     C                   EVAL      @SCRN = 'M'                                                CIR008
     C                   EVAL      PFuncKey = *BLANKS                                         CIR008
     C                   GOTO      EVAL@M                                                     CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
      ** F3 pressed, end program                                                              CIR008
                                                                                              CIR008
     C                   IF        PFuncKey = '03'                                            CIR008
     C                   EXSR      ENDP                                                       CIR008
     C                   GOTO      EVAL@M                                                     CIR008
     C                   ENDIF                                                                CIR008
     C                                                                                        CIR008
     C                   ENDIF                                                                CIR008
     C                                                                                        CIR008
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
     C                   MOVE      *ALL'Y'       IRECIRS
     C                   CLEAR                   NwDlFilFmt
     C                   CLEAR                   NwDlXFilFmt                                  CLE025
     C                   Z-ADD     *ZERO         RXRSTM
     C**********         Z-ADD     *ZERO         RXROBN                                       CSD027
     C**********         Z-ADD     *ZERO         RXROCN                                       CSD027
     C                   EVAL      RXROBN = *BLANKS                                           CSD027
     C                   EVAL      RXROCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         RXPSTM
     C**********         Z-ADD     *ZERO         RXPOBN                                       CSD027
     C**********         Z-ADD     *ZERO         RXPOCN                                       CSD027
     C                   EVAL      RXPOBN = *BLANKS                                           CSD027
     C                   EVAL      RXPOCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         RXUNPCD                                      CAP043
     C                   Z-ADD     *ZERO         RXTNPCD                                      CAP043
      *
      * IF AMEND
      *
     C     SACCD         IFEQ      'A'
      *
      * Update Deal in File Format
      *
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
     C/COPY WNCPYSRC,IRH00059
     C                   MOVEL     URACC         RXURACC                                      CGL029
     C                   MOVEL     UPACC         RXUPACC                                      CGL029
     C                   MOVEL     RONS          RXRONS                                       CGL029
     C                   MOVEL     PONS          RXPONS                                       CGL029
     C     CLE025        IFEQ      'Y'                                                        CLE025
     C                   MOVEL     CrDlXFilFmt   NwDlXFilFmt                                  CLE025
     C                   ENDIF                                                                CLE025
      *
      * Validate whether non-amenable fields have been changed
      *
     C                   CALLB     'IRCIRSAMD'
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
     C                   PARM                    IRECIRS
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
      *                                                                         CIR005
      ** If first pass to the main screen and Business Day Conventions          CIR005
      ** enhancement is switched on, skip validation of rate change             CIR005
      ** dates and interest payment dates against the Business Day              CIR005
      ** Convention currencies (WValBDC = 'N').                                 CIR005
      *                                                                         CIR005
     C                   IF        CIR005 = 'Y' and WFrstPas = 'Y'              CIR005
     C                   EVAL      WValBDC = 'N'                                CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
      ** Frenquency being used is 'Z', set validate BDC flag to 'N'             CIR005
     C                   IF        CIR005 = 'Y'                                 CIR005
     C                   IF        (SUICFR = 'Z') Or (SUIPFR = 'Z') Or          CIR005
     C                             (STICFR = 'Z') Or (STIPFR = 'Z')             CIR005
     C                   EVAL      WValBDC = 'N'                                CIR005
     C                   EVAL      WFreqZ = 'Y'                                 CIR005
     C                   ELSE                                                   CIR005
     C                   EVAL      WFreqZ = 'N'                                 CIR005
     C                   ENDIF                                                  CIR005
     C                   ENDIF                                                  CIR005
      *
      * Validate deal details
      *
     C                   CALLB     'IRCIRSVAL'
     C                   PARM                    ModeOfOp                       CIR005
     C                   PARM                    RespMode
     C                   PARM                    NwDlScnFmt
     C                   PARM      RXRSCY        @@RSCY
     C                   PARM      RXRSTM        @@RSTM
     C                   PARM      RXRONS        @@RONS
     C                   PARM      RXPSCY        @@PSCY
     C                   PARM      RXPSTM        @@PSTM
     C                   PARM      RXPONS        @@PONS
     C                   PARM                    ExtData                        CAP004
     C                   PARM                    WValBDC                        CIR005
     C                   PARM                    IRECIRS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwDlFilFmt
     C                   PARM                    NwDlXFilFmt                                  CLE025
      *                                                                                       187606
     C                   PARM                    SACCD                                        187606
     C                   PARM                    USLIP                                        184560
     C                   PARM                    TSLIP                                        184560
      *                                                                                       185057
      * Current Deal in Screen Format                                                         185057
     C                   PARM                    CrDlScnFmt                                   185057
      *
      * If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      EVAL@M
     C                   END
      *                                                                         CIR005
      ** Process Business Day Convention                                        CIR005
     C                   IF        (CIR005 = 'Y' and WFrstPas = 'Y')            CIR005
      *                                                                         CIR005
      ** Save previous Business Day Convention input                            CIR005
     C                   IF        BsDayConv <> *Blanks                         CIR005
     C                   EVAL      WSavBDC = BsDayConv                          CIR005
     C                   ENDIF                                                  CIR005
                                                                                CIR005
     C                   EXSR      SRBusDay                                     CIR005
                                                                                CIR005
     C                   SELECT                                                 CIR005
                                                                                CIR005
     C                   WHEN      PFuncKey = '03'                              CIR005
     C                   EXSR      ENDP                                         CIR005
     C                   GOTO      EVAL@M                                       CIR005
                                                                                CIR005
     C                   WHEN      PFuncKey = '12'                              CIR005
     C                   EVAL      @SCRN = 'M'                                  CIR005
     C                   EVAL      PFuncKey = *Blank                            CIR005
      *                                                                         CIR005
      ** Put back business day convention details only when the previous        CIR005
      ** detail workfield is not blank                                          CIR005
     C                   IF        WSavBDC <> *Blank                            CIR005
     C                   EVAL      BsDayConv = WSavBDC                          CIR005
     C                   ELSE                                                   CIR005
     C                   EVAL      BsDayConv = *Blank                           CIR005
     C                   ENDIF                                                  CIR005
     C                   GOTO      EVAL@M                                       CIR005
                                                                                CIR005
     C                   ENDSL                                                  CIR005
      *                                                                         CIR005
      ** No error found on call to Business Day Convention                      CIR005
     C                   IF        PFuncKey = *Blank                            CIR005
      *                                                                         CIR005
     C                   SELECT                                                 CIR005
      *                                                                         CIR005
      ** Enhancement CIR001(Schedule) is off or frequency being used            CIR005
      ** is not 'Z'.                                                            CIR005
     C                   WHEN      (CIR001 = 'N' and WValBDC = 'N')             CIR005
     C                             OR (CIR001 = 'Y' and WFreqZ = 'N')           CIR005
     C                   EVAL      WValBDC = 'Y'                                CIR005
     C                   EVAL      @SCRN = 'M'                                  CIR005
      *                                                                         CIR005
      ** Enhancement CIR001 is on and the frequencies being used are 'Z'        CIR005
     C                   WHEN      CIR001 = 'Y' and WFreqZ = 'Y'                CIR005
     C                   EVAL      @SCRN = 'X'                                  CIR005
      *                                                                         CIR005
     C                   ENDSL                                                  CIR005
      *                                                                         CIR005
     C                   EVAL      WFrstPas = 'N'                               CIR005
     C                   GOTO      EVAL@M                                       CIR005
      *                                                                         CIR005
     C                   ENDIF                                                  CIR005
     C                   ENDIF                                                  CIR005
      *
      * If IRC feature is on, then call schedule dates module
      * Else, if feature no on;
      ** If Fees/Buyouts switched on, show Fees/Buyout details, else                          CAP041
      * If windows processing on, call window routine
      * otherwise, continue to settlements screen
      *
     C     CIR001        IFEQ      'Y'
     C                   MOVEL     'X'           @SCRN
     C                   ELSE
     C     CAP041        IFEQ      'Y'                                                        CAP041
     C                   MOVEL     'F'           @SCRN                                        CAP041
     C                   ELSE                                                                 CAP041
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
     C                   MOVEL     'S'           @SCRN
     C                   END
     C                   ENDIF                                                                CAP041
     C                   END
      *
     C                   END
      *----------------------------------------------------------------
     C     EVAL@M        ENDSR
      /EJECT
      *****************************************************************         CIR005
      *                                                               *         CIR005
      *  SRBusDay - Business Day Conventions Input                    *         CIR005
      *                                                               *         CIR005
      *  Called by  : VAL@M - Validate input to main details screen   *         CIR005
      *                                                               *         CIR005
      *  Calls      : IRCBDYDSP - Bus Day Convention Cross Ccy Dsply  *         CIR005
      *               IRCBDYVAL - Bus Day Convention Cross Ccy Vldtn  *         CIR005
      *                                                               *         CIR005
      *****************************************************************         CIR005
     C     SRBusDay      BEGSR                                                  CIR005
      *                                                                         CIR005
     C                   EVAL      POKFlags = *All'Y'                           CIR005
     C                   MoveL     *Blanks       MsgIdErr                       CIR005
     C                   MoveL     *Blanks       WMsgIdErr                      CIR005
     C                   MoveL     *Blanks       WSavRC1                        CIR005
     C                   MoveL     *Blanks       WSavRC2                        CIR005
                                                                                CIR005
      ** Do until F3 or F12 is pressed or all screen fields are valid.          CIR005
                                                                                CIR005
     C                   DoU       MsgIdErr(1) = *Blanks                        CIR005
     C                             AND WrnFlag = 'N'                            CIR005
     C                             OR PFuncKey = '03'                           CIR005
     C                             OR PFuncKey = '12'                           CIR005
      *                                                                         CIR005
     C                   EVAL      WrnFlag = 'N'                                CIR005
      *                                                                         CIR005
      ** Display screen fields                                                  CIR005
     C                   CALLB     'IRCBDYDSP'                                  CIR005
     C                   PARM      *Blanks       RetCodeOut                     CIR005
     C                   PARM                    SACCD                          CIR005
     C                   PARM                    SDLNO                          CIR005
     C                   PARM                    POKFlags                       CIR005
     C                   PARM                    MsgIdErr                       CIR005
     C                   PARM                    WMsgIdErr                      CIR005
     C                   Parm                    BJMRDT                         CIR005
     C                   PARM                    BsDayConv                      CIR005
     C                   PARM      *Blanks       PFuncKey                       CIR005
      *                                                                         CIR005
      ** Error on call, execute std database error program.                     CIR005
     C                   IF        RetCodeOut <> *Blank                         CIR005
     C     *LOCK         IN        LDA                                          CIR005
     C                   MOVEL     'IRCBDYDSP'   DBFILE                         CIR005
     C                   Z-ADD     3             DBASE                          CIR005
     C                   MOVEL     SDLNO         DBKEY                          CIR005
     C                   OUT       LDA                                          CIR005
     C                   EXSR      *PSSR                                        CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
     C                   IF        PFuncKey <> '03' AND                         CIR005
     C                             PFuncKey <> '12' AND                         CIR005
     C                             SACCD = 'I'  OR                              CIR005
     C                             PFuncKey <> '03' AND                         CIR005
     C                             PFuncKey <> '12' AND                         CIR005
     C                             SACCD = 'A'                                  CIR005
      *                                                                         CIR005
      ** Validate all screen fields when action code is I or A.                 CIR005
     C                   CALLB     'IRCBDYVAL'                                  CIR005
     C                   PARM      *Blanks       RetCodeOut                     CIR005
     C                   PARM                    SACCD                          CIR005
     C                   PARM                    PLCcy             3            CIR005
     C                   PARM                    POKFlags                       CIR005
     C                   PARM      *Blanks       MsgIdErr                       CIR005
     C                   PARM      *Blanks       FldNameErr                     CIR005
     C                   PARM      *Blanks       WMsgIdErr                      CIR005
     C                   PARM      *Blanks       WFldNamErr                     CIR005
     C                   PARM                    BsDayConv                      CIR005
      *                                                                         CIR005
      ** Error on call, execute std database error program.                     CIR005
     C                   IF        RetCodeOut <> *Blank                         CIR005
     C     *LOCK         IN        LDA                                          CIR005
     C                   MOVEL     'IRCBDYVAL'   DBFILE                         CIR005
     C                   Z-ADD     4             DBASE                          CIR005
     C                   MOVEL     SDLNO         DBKEY                          CIR005
     C                   OUT       LDA                                          CIR005
     C                   EXSR      *PSSR                                        CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
     C                   IF        WMsgIdErr(1) <> *Blanks and                  CIR005
     C                             WSavRC1 <> RCcy1  or                         CIR005
     C                             WMsgIdErr(1) <> *Blanks and                  CIR005
     C                             WSavRC2 <> RCcy2                             CIR005
     C                   EVAL      WrnFlag = 'Y'                                CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
     C                   EVAL      WSavRC1 = RCcy1                              CIR005
     C                   EVAL      WSavRC2 = RCcy2                              CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
     C                   ENDDO                                                  CIR005
      *                                                                         CIR005
     C                   ENDSR                                                  CIR005
      *****************************************************************         CIR005
      /EJECT                                                                    CIR005
     C*****************************************************************
     C*                                                               *
     C*  SCHEDULES - Display Schedule Input                           *
     C*                                                               *
     C*  Called by  : MAIN   - Main Processing Routine                *
     C*                                                               *
     C*  Calls      : IRCIRSCHD - Date schedule controller            *
     C*                                                               *
     C*****************************************************************
     C     SCHEDULES     BEGSR
      *
      * IF DEAL NUMBER NOT DEFINED (ON INSERT),
      * GET NEXT AVAILABLE DEAL NUMBER
      *
     C/COPY WNCPYSRC,IRCIRSSC04
     C     SDLNO         IFEQ      *BLANK
     C     @WFRUN        ANDNE     'Y'                                                        182224
     C                   CALLB     'CAGETNXTDL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       @@MSG1
     C                   PARM                    I#SDLNO
     C                   PARM      *ZERO         RXDLNO
      *
      * DATABASE ERROR
      *
     C     @@MSG1        IFNE      *BLANK
     C                   MOVEL     'CAGTNXDL'    DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 002*
     C                   MOVEL     SDLNO         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
                                                                                              182224
      * Set up the work field indicating the Deal No. allocation has run                      182224
     C                   MOVE      'Y'           @WFRUN            1                          182224
                                                                                              182224
     C                   END
     C*
     C* Call schedule controlling module
     C*
     C                   CALLB     'IRCIRSCHD'
     C                   PARM                    RetCodeIn
     C                   PARM                    Mode              1
     C                   PARM                    NwDlScnFmt
     C                   PARM                    I#SDLNO
     C                   PARM                    RXRSCY
     C                   PARM                    RXPSCY
     C                   PARM                    RXMDAT
     C                   PARM                    RXVDAT
     C                   PARM                    BJDFIN
     C                   PARM                    @WerrAr
      *
      * Reset Mode parameter
      *
     C                   EVAL      Mode = *BLANK
     C*
     C* For each warning error code received, set up a message to be
     C* sent to the screen
     C*
     C                   Z-ADD     1             C                 2 0
     C     C             DOWLE     10
     C     @WERRAR(C)    ANDNE     *BLANKS
     C                   MOVEL     @WERRAR(C)    @WERRMS           7
     C                   EXSR      SNDW@M
     C                   ADD       1             C
     C                   END
     C*
     C* Set screen indicator or exit according to return code,
     C* i.e. F3, F12 or enter pressed
     C*
     C     RetCodeIn     IFEQ      'Y2U9999'
     C                   EXSR      ENDP
     C                   END
     C*
     C* If F12, go to main screen or process multiple browse selection
     C*
     C     RetCodeIn     IFEQ      'USR0790'
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
     C                   MOVEL     'M'           @SCRN
     C     CIR005        IFEQ      'Y'                                          CIR005
     C                   EVAL      WFrstPas = 'Y'                               CIR005
     C                   ENDIF                                                  CIR005
     C                   END
     C                   END
     C*
     C**If*enter*pressed,*call*window*manager*(if*window*processing*set*on)*                  CAP041
     C**otherwise*go*to*settlements,*if*not*enquiry.*If*enquiry,*call*window                  CAP041
     C**and*either*return*to*main*screen*or*read*next*browse*subfile*record*                  CAP041
      *                                                                                       CAP041
      ** If enter pressed, show Fee/Buyout details if on, otherwise                           CAP041
      ** if window processing is set on call window manageer, otherwise                       CAP041
      ** if not enquiry go to settlements, otherwise                                          CAP041
      ** either return to main screen or read next browse subfile record                      CAP041
      *
     C     RetCodeIn     IFEQ      *BLANKS
      *                                                                                       CAP041
     C     CAP041        IFEQ      'Y'                                                        CAP041
     C                   MOVEL     'F'           @SCRN                                        CAP041
     C                   ELSE                                                                 CAP041
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
     C     SACCD         IFNE      'E'
     C                   MOVEL     'S'           @SCRN
     C                   ELSE
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
     C                   MOVEL     'M'           @SCRN
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
     C                   ENDIF
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************                       CAP041
      *                                                               *                       CAP041
      *  SRFeeBuy - Process Fees and Buyout details                   *                       CAP041
      *                                                               *                       CAP041
      *****************************************************************                       CAP041
     C     SRFeeBuy      BEGSR                                                                CAP041
      *                                                                                       CAP041
      ** If details have changed, populate fields                                             CAP041
      *                                                                                       CAP041
     C                   MOVE      SDLNO         W#DLNO            6 0                        CAP041
     C     SACCD         IFNE      #1ACTN                                                     CAP041
     C     W#DLNO        ORNE      #1DLNO                                                     CAP041
     C     W#DLNO        ANDNE     *ZEROS                                                     CAP041
     C                   EVAL      CANCFM = 'N'                                               CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
      ** Populate fields in 'DATA' to be passed to IRS details pgm                            CAP041
      ** (If cancel not taken from confirmation screen)                                       CAP041
      *                                                                                       CAP041
     C     CANCFM        IFNE      'Y'                                                        CAP041
                                                                                              CAP041
     C/COPY QWINDSRC,IRCIRSMOV1                                                               CAP041
                                                                                              CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
      ** Call Fees and Buyouts program                                                        CAP041
      *                                                                                       CAP041
     C                   CALL      'IRFEBOSIN'                                                CAP041
     C                   PARM      *BLANKS       PRTRN             7                          CAP041
     C                   PARM                    DATA                                         CAP041
     C                   PARM                    CANCFM                                       CAP041
      *                                                                                       CAP041
      ** Process returned command keys                                                        CAP041
      *                                                                                       CAP041
     C                   SELECT                                                               CAP041
      *                                                                                       CAP041
      ** F3 pressed                                                                           CAP041
     C                   WHEN      PRTRN = 'Y2U9999'                                          CAP041
     C                   EXSR      ENDP                                                       CAP041
      *                                                                                       CAP041
      ** If Cmd12 pressed AND IRC feature is on, then call                                    CAP041
      *                                                                                       CAP041
     C                   WHEN      PRTRN = 'USR0790'                                          CAP041
      *                                                                                       CAP041
      ** Date Schedule module, with Mode parm set to backwards.                               CAP041
     C                   IF        CIR001 = 'Y'                                               CAP041
     C                   EVAL      @SCRN = 'X'                                                CAP041
     C                   EVAL      Mode = 'B'                                                 CAP041
     C                   GOTO      EndFeeBuy                                                  CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
      ** If read next browse is 'Y', browse next record                                       CAP041
     C                   IF        @RDNB = 'Y'                                                CAP041
     C                   EVAL      @SCRN = 'R'                                                CAP041
     C                   GOTO      EndFeeBuy                                                  CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
      ** Else, go to main screen                                                              CAP041
     C                   EVAL      @SCRN = 'M'                                                CAP041
     C                   IF        CIR005 = 'Y'                                               CAP041
     C                   EVAL      WFrstPas = 'Y'                                             CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
     C                   OTHER                                                                CAP041
                                                                                              CAP041
     C     SACCD         IFNE      'E'                                                        CAP041
                                                                                              CAP041
     C/COPY QWINDSRC,IRCIRSMOV2                                                               CAP041
                                                                                              CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
      ** If Window processing on show window, otherwise                                       CAP041
      *                                                                                       CAP041
     C     BGWDPR        IFEQ      'Y'                                                        CAP041
     C                   EVAL      @SCRN = 'W'                                                CAP041
     C                   GOTO      EndFeeBuy                                                  CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
      ** If in enquiry mode, go to main screen or read next browse record                     CAP041
     C     SACCD         IFEQ      'E'                                                        CAP041
     C     @RDNB         IFEQ      'Y'                                                        CAP041
     C                   EVAL      @SCRN = 'R'                                                CAP041
     C                   ELSE                                                                 CAP041
     C                   EVAL      @SCRN = 'M'                                                CAP041
     C                   ENDIF                                                                CAP041
     C                   GOTO      EndFeeBuy                                                  CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
      ** Otherwise, go to settlements screen                                                  CAP041
     C                   EVAL      @SCRN = 'S'                                                CAP041
     C                                                                                        CAP041
     C                   ENDSL                                                                CAP041
     C                                                                                        CAP041
     C     EndFEEBUY     ENDSR                                                                CAP041
      *****************************************************************                       CAP041
      /EJECT                                                                                  CAP041
      *****************************************************************
      * WINDOW - CALL WINDOW MANAGER
      *****************************************************************
     C     WINDOW        BEGSR
      *
      * Reset erros
      *
     C                   MOVE      *ALL'Y'       IRECIRS
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * Write out screen to remove error messages
      *
     C                   CALLB     'IRCIRSDSP'
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
     C                   PARM                    IRECIRS
     C/COPY WNCPYSRC,IRH00013
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
      * If deal number not defined (on insert),
      * get next available deal number
      * This routine will already be called if the Interest Rate
      * Calendar feature is present, therefore condition call on this
      * switch
      *
     C/COPY WNCPYSRC,IRCIRSSC05
     C     SDLNO         IFEQ      *BLANK
     C     CIR001        ANDNE     'Y'
     C                   CALLB     'CAGETNXTDL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       @@MSG1            7
     C                   PARM                    I#SDLNO           6
     C                   PARM      *ZERO         RXDLNO
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
     C                   IF        CAP041 = 'Y'                                               CAP041
     C                   MOVEL     'IRCIRSSINX'  #PGM                                         CAP041
     C                   ELSE                                                                 CAP041
     C                   MOVEL     'IRCIRSSIN'   #PGM                                         CAP041
     C/COPY QWINDSRC,IRCIRSMOV1
     C                   ENDIF                                                                CAP041
      *
     C                   CALL      'WN0010'
     C**********         PARM      'IRCIRSSIN'   #PGM             10                          CAP041
     C                   PARM                    #PGM             10                          CAP041
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
      ***If*Cmd12*pressed*AND*IRC*feature*is*on,*then*call***************                     CAP041
      ***Date*Schedule*module,*with*Mode*parm*set*to*backwards.**********                     CAP041
      ***If*IRC*feature*is*not*on*AND*Cmd12*pressed,*go*to*main*screen*or                     CAP041
      ***read*next*browse*record*****************************************                     CAP041
      *                                                                                       CAP041
      ** If Cmd12 pressed AND Fee/Buyout is on, show F/B details otherwise                    CAP041
      ** if IRC feature is on, then call Data Schedule module,                                CAP041
      ** with Mode parm set to backwards, otherwise                                           CAP041
      ** go to main screen or read next browse record                                         CAP041
      *
     C     #RTRN         IFEQ      'USR0790'
      *                                                                                       CAP041
     C     CAP041        IFEQ      'Y'                                                        CAP041
     C                   EVAL      @SCRN = 'F'                                                CAP041
     C                   ELSE                                                                 CAP041
     C     CIR001        IFEQ      'Y'
     C                   EVAL      @SCRN = 'X'
     C                   EVAL      Mode = 'B'
     C                   ELSE
     C     @RDNB         IFEQ      'Y'
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
     C                   EVAL      @SCRN = 'M'
     C     CIR005        IFEQ      'Y'                                          CIR005
     C                   EVAL      WFrstPas = 'Y'                               CIR005
     C                   ENDIF                                                  CIR005
     C                   END
     C                   END
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
     C                   ELSE
      *
      *  If Cmd12 not pressed;
      *  If in enquiry mode, go to main screen or read next browse record
      *  otherwise, go to settlements screen
      *
     C     SACCD         IFEQ      'E'
     C     @RDNB         IFEQ      'Y'
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
     C                   EVAL      @SCRN = 'M'
     C                   END
     C                   ELSE
      *
     C                   IF        CAP041 <> 'Y'                                              CAP041
     C/COPY QWINDSRC,IRCIRSMOV2
     C                   ENDIF                                                                CAP041
      *
     C                   EVAL      @SCRN = 'S'
     C                   ENDIF
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
     C                   CALLB     'IRCIRSRED'
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
     C                   CALLB     'IRCIRSBRW'
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
     C                   CALLB     'IRCIRSBRW'
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
                                                                                CIR005
     C                   IF        CIR005 = 'Y'                                 CIR005
     C                   CLEAR                   BsDayConv                      CIR005
     C                   ENDIF                                                  CIR005
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
      *                                                                         CIR005
     C                   IF        CIR005 = 'Y'                                 CIR005
     C                   EVAL      WFrstPas = 'Y'                               CIR005
     C                   ENDIF                                                  CIR005
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
     C                   CALLB     'IRCIRSRTV'
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
                                                                                              CLE025
      ** (Current) deal extension in file format                                              CLE025
     C                   PARM                    CrDlXFilFmt                                  CLE025
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
     C                   PARM                    CIR003                                       CIR003
     C                   PARM                    ExtSett1                                     CIR003
     C                   PARM                    ExtSett2                                     CIR003
     C                   PARM                    ExtSett3                                     CIR003
                                                                                              CAS005
      ** Warning flds/message IDs/message data (arrays) from/to caller                        CAS005
                                                                                              CAS005
     C                   PARM                    WFldNamArr                                   CAS005
     C                   PARM                    WMsgIdArr                                    CAS005
     C                   PARM                    WMsgDtaArr                                   CAS005
                                                                                              CAS005
      ** Array index (3P0) from/to caller                                                     CAS005
                                                                                              CAS005
     C                   PARM                    WIdx                                         CAS005
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
     C                   CALLB     'IRCIRSCVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Deal in file format
     C                   PARM                    CrDlFilFmt
     C                   PARM                    CrDlXFilFmt                                  CLE025
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
      ** Reset 'Cancel taken from Confirm Screen' indicator                                   CAP041
     C                   MOVEL     'N'           CANCFM                                       CAP041
      *                                                                                       CAP041
      * If input fields are enabled
      * Blank the main details screen
      *
     C     @EKYFD        IFEQ      'Y'
     C     @EDTFD        OREQ      'Y'
     C                   MOVEL     *BLANK        NwDlScnFmt
     C                   MOVEL     *BLANK        DDSTS
     C/COPY WNCPYSRC,IRH00014
     C                   END
      *
      * Initialize field and function key status on main details screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
      *                                                                         CIR005
     C                   IF        CIR005 = 'Y'                                 CIR005
     C                   EVAL      WFrstPas = 'Y'                               CIR005
     C                   EVAL      WSavBDC = *Blanks                            CIR005
     C                   ENDIF                                                  CIR005
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
      * SNDW@M - SEND A WARNING MESSAGE TO MAIN DETAILS SCREEN
      *****************************************************************
     C     SNDW@M        BEGSR
      *
      * If schedule amendment changes Our/Their Next Rate Change/Int Pay
      * dates, then set relevant field for warning error
      *
     C     @WERRMS       IFEQ      'MMA0600'
     C                   MOVE      'W'           OKUNICD
     C                   END
     C     @WERRMS       IFEQ      'MMA0601'
     C                   MOVE      'W'           OKUNIPD
     C                   END
     C     @WERRMS       IFEQ      'MMA0602'
     C                   MOVE      'W'           OKTNICD
     C                   END
     C     @WERRMS       IFEQ      'MMA0603'
     C                   MOVE      'W'           OKTNIPD
     C                   END
      *
      ** Add warning message to array passed to detail screen
      *
     C                   Z-ADD     1             E
     C     *BLANK        LOOKUP    WFldNamArr(E)                          99          *
     C                   MOVEL     '*ANY'        WFldNamArr(E)
     C                   MOVEL     @WERRMS       WMsgIdArr(E)
     C                   ADD       1             Widx
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
     C     STCUCY        ORNE      ##RCCY
     C     SCNUM         ORNE      ##CSNM
      *
      * DETERMINE PARAMETERS FOR SETTLEMENT DETAILS INPUT
      *
     C                   EXSR      DETP@S
     C                   END
                                                                                              CGL014
      ** Store the Up-front and Buy-out Details                                               CGL014
                                                                                              CGL014
     C                   IF        CGL014 = 'Y'                                               CGL014
     C     *LOCK         IN        DLUFBO                                                     CGL014
     C                   MOVE      SDLNO         DLDLNO                                       CGL014
     C                   EVAL      DLUPVD = RXUPVD                                            CGL014
     C                   EVAL      DLUPFE = RXUPFE                                            CGL014
     C                   EVAL      DLUPPR = RXUPPR                                            CGL014
     C                   EVAL      DLUCCY = SUCUCY                                            CGL014
     C                   EVAL      DLBOVD = RXBOVD                                            CGL014
     C                   EVAL      DLBOAM = RXBOAM                                            CGL014
     C                   EVAL      DLBOPR = RXBAPR                                            CGL014
     C                   EVAL      DLTCCY = STCUCY                                            CGL014
     C                   OUT       DLUFBO                                                     CGL014
     C                   ENDIF                                                                CGL014
      *
      * SETTLEMENT INSTRUCTIONS INPUT
      *
     C     CIR003        IFEQ      'Y'                                                        CIR003
     C                   CALLB     'IRCXSTDFT'                                                CIR003
     C                   PARM                    ##PREX                                       CIR003
      *                                                                                       CIR003
     C     SDLNO         IFEQ      *BLANKS                                                    CIR003
     C                   MOVEL     RXDLNO        ##DLNO                                       CIR003
     C                   ELSE                                                                 CIR003
     C                   MOVEL     SDLNO         ##DLNO                                       CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
      ** If CIR003 is On, perform new processing for extended sett. display                   CIR003
      *                                                                                       CIR003
     C                   CALLB     'IRCXSTSIN'                                                CIR003
      *                                                                                       CIR003
      * INPUTS                                                                                CIR003
      *                                                                                       CIR003
      * Return Code                                                                           CIR003
     C                   PARM      *BLANK        ##RTCD                                       CIR003
      *                                                                                       CIR003
      * Mode of Operation                                                                     CIR003
     C                   PARM                    MODEofOP                                     CIR003
      *                                                                                       CIR003
      * Action code                                                                           CIR003
     C                   PARM      SACCD         ##ACTN                                       CIR003
      *                                                                                       CIR003
      * Deal number                                                                           CIR003
     C                   PARM                    ##DLNO                                       CIR003
      *                                                                                       CIR003
      * Protect Payment                                                                       CIR003
     C                   PARM                    ##PPAY                                       CIR003
      *                                                                                       CIR003
      * Protect Receive                                                                       CIR003
     C                   PARM                    ##PREC                                       CIR003
      *                                                                                       CIR003
      * Customer shortname                                                                    CIR003
     C                   PARM      SCNUM         ##CSNM                                       CIR003
      *                                                                                       CIR003
      * Federal Funds Ind.                                                                    CIR003
     C                   PARM      SUFFI         ##FFND                                       CIR003
      *                                                                                       CIR003
      * Booking branch                                                                        CIR003
     C                   PARM      SBRCA         ##BRCA                                       CIR003
      *                                                                                       CIR003
      * Receipt Date                                                                          CIR003
     C                   PARM                    ##DATR                                       CIR003
      *                                                                                       CIR003
      * Payment Date                                                                          CIR003
     C                   PARM                    ##DATP                                       CIR003
      *                                                                                       CIR003
      * Payment instructions                                                                  CIR003
     C                   PARM                    ##PAYS                                       CIR003
      *                                                                                       CIR003
      * Receive instructions                                                                  CIR003
     C                   PARM                    ##RECS                                       CIR003
      *                                                                                       CIR003
      * FRA/IRS instructions                                                                  CIR003
     C                   PARM                    ##RXIS                                       CIR003
      *                                                                                       CIR003
      * Value Date Exchange indicator                                                         CIR003
     C                   PARM      SVDEI         ##VDEI            1                          CIR003
      *                                                                                       CIR003
      * Maturity Date Exchange Indicator                                                      CIR003
     C                   PARM      SMDEI         ##MDEI            1                          CIR003
      *                                                                                       CIR003
      * Principal Change Date Exchange Indicator                                              CIR003
     C                   PARM      SPDEI         ##PDEI            1                          CIR003
      *                                                                                       CIR003
      * Payment currency                                                                      CIR003
     C                   PARM      SUCUCY        ##UCCY            3                          CIR003
      *                                                                                       CIR003
      * Receive currency                                                                      CIR003
     C                   PARM      STCUCY        ##TCCY            3                          CIR003
      *                                                                                       CIR003
      * OUTPUTS                                                                               CIR003
      *                                                                                       CIR003
      * Exchange                                                                              CIR003
     C                   PARM                    ##PREX            3                          CIR003
      *                                                                                       CIR003
      * Payment instructions                                                                  CIR003
     C                   PARM                    ##PAYF                                       CIR003
      *                                                                                       CIR003
      * Receive instructions                                                                  CIR003
     C                   PARM                    ##RECF                                       CIR003
      *                                                                                       CIR003
      * FRA/IRS instructions                                                                  CIR003
     C                   PARM                    ##RXIF                                       CIR003
      * Extra Settlement Instructions                                                         CIR003
     C                   PARM                    ExtSett1                                     CIR003
     C                   PARM                    ExtSett2                                     CIR003
     C                   PARM                    ExtSett3                                     CIR003
      * Function Key                                                                          CIR003
     C                   PARM      *BLANK        PfuncKey                                     CIR003
      *                                                                                       CIR003
      * CK/3 - END PROGRAM                                                                    CIR003
      *                                                                                       CIR003
     C     PfuncKey      CASEQ     '03'          ENDP                                         CIR003
      *                                                                                       CIR003
      * CK/12 - CANCEL ON SETTLEMENT DETAILS                                                  CIR003
      *                                                                                       CIR003
     C     PfuncKey      CASEQ     '12'          CANC@S                                       CIR003
      *                                                                                       CIR003
      * EXIT FROM SETTLEMENT DETAILS                                                          CIR003
      *                                                                                       CIR003
     C                   CAS                     EXIT@S                                       CIR003
     C                   END                                                                  CIR003
      *                                                                                       CIR003
     C                   ELSE                                                                 CIR003
      *                                                                                       CIR003
     C/COPY WNCPYSRC,IRCIRSSC01
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
     C                   PARM      'CIRS'        ##CALP            4
      *
      * Payment currency
     C                   PARM      SUCUCY        ##PCCY            3
      *
      * Receive currency
     C                   PARM      STCUCY        ##RCCY            3
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
     C                   PARM                    ##RXIS
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
     C                   PARM                    ##RXIF
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKK             1                        MD036070
     C                   PARM      '0'           @INKL             1
      *
      **MIDAS*Our*Receive/ Pay Instructions (for Settlm Meth = 04 )                    179510 200400
     c************       PARM                    @MORPI                                179510 200400
      ************                                                                     179510 200400
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
      *                                                                                       CIR003
     C                   ENDIF                                                                CIR003
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DETP@S - DETERMINE PARAMETERS FOR SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     DETP@S        BEGSR
      *
      **PROTECT*PAYMENT/RECEIVE*INSTRUCTIONS*IF*DATES************************** 162497
      **ARE*IN*THE*PAST*AND*THE*DEAL*WAS*NOT*DONE*TODAY************************ 162497
      *******************                                                       162497
     C*****RXVDAT********IFLT      BJRDNB                                       162497
     C*****RXORED********ANDNE     BJRDNB                                       162497
     C*****RXORED********ANDNE     *ZERO                                        162497
     C*******************MOVEL     'Y'           ##PPAY                         162497
     C*******************MOVEL     'Y'           ##PREC                         162497
     C*******************ELSE                                                   162497
     C*******************MOVEL     'N'           ##PPAY                         162497
     C*******************MOVEL     'N'           ##PREC                         162497
     C*******************END                                                    162497
      *******************                                                       162497
      **SET*PAY/RECEIVE*DATES*FOR*NOSTRO*BACK-VALUE*CHECK********************** 162497
      *******************                                                       162497
     C*******************EVAL      ##DATP = RXVDAT                              162497
     C*******************EVAL      ##DATR = RXVDAT                              162497
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
     C**********         MOVEL     RXPAY         FLPAY                                        CGL029
     C                   EVAL      %SUBST(FLPAY:1:2) = %SUBST(RXPAY:1:2)                      CGL029
     C                   EVAL      %SUBST(FLPAY:3:18) = RXPONS                                CGL029
     C                   EVAL      %SUBST(FLPAY:21:545) = %SUBST(RXPAY:15:545)                CGL029
     C                   MOVEL     RXPOBR        FLPOBR
     C                   MOVEL     RXCVMR        FLCVMR
     C                   MOVEL     RXPSCY        FLPSCY
     C                   MOVEL     RXIC72        FLIC72
      *
      * SET UP RECEIVE INSTRUCTIONS FROM DEAL
      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C**********         MOVEL     RXREC         FLREC                                        CGL029
     C                   MOVEL     RXROBR        FLROBR
     C                   EVAL      %SUBST(FLREC:1:2) = %SUBST(RXREC:1:2)                      CGL029
     C                   EVAL      %SUBST(FLREC:3:18) = RXRONS                                CGL029
     C                   EVAL      %SUBST(FLREC:21:55) = %SUBST(RXREC:15:55)                  CGL029
     C                   MOVEL     RXRSCY        FLRSCY
      *
      * SET UP FRA/IRS SPECIFIC DATA
      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C                   MOVEL     RXIRS         FLIRS
     C                   MOVE      RXAGVC        FLAGVC                         CSW097
      *
      * IF SETTLEMENT INSTRUCTIONS ARE NOT DEFINED,
      * AND PAYMENT/RECEIPT DATES ARE NOT IN THE PAST, DEFAULT THEM
      *
     C     FLPSTM        IFEQ      *ZERO
     C     ##PPAY        ANDNE     'Y'
     C     FLRSTM        ANDEQ     *ZERO
     C     ##PREC        ANDNE     'Y'
     C     SACCD         ANDNE     'E'
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
     C                   PARM      'CIRS'        ##CALP            4
      *
      * Payment currency
     C                   PARM      SUCUCY        ##PCCY            3
      *
      * Receive currency
     C                   PARM      STCUCY        ##RCCY            3
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
     C                   PARM                    ##RXIF
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
     C                   PARM                    ##RXIF
      *
      ** OUTPUTS
      ** Screen Payment Settlement Instruction
     C                   PARM      *BLANK        ##PAYS
      *
      ** Screen Receipt Settlement Instruction
     C                   PARM      *BLANK        ##RECS
      *
      ** Screen FRA/IRS Settlement Instruction
     C                   PARM      *BLANK        ##RXIS
      ** Receive currency                                                                    CSF011A
     C                   PARM      STCUCY        ##RCCY                                      CSF011A
      ** Payment currency                                                                    CSF011A
     C                   PARM      SUCUCY        ##PCCY                                      CSF011A
      *
      ** Set screen numeric fields to blank, if zero on file
      *
     C     SACCD         IFNE      'I'
     C     AGDT          IFEQ      *ZERO
     C                   MOVE      *BLANK        DDAGDT
     C                   ENDIF
     C     AGVV          IFEQ      *ZERO
     C     AGVC          ANDEQ     *ZERO                                        CSW097
     C                   MOVE      *BLANK        DDAGVV
     C                   ENDIF
     C                   ENDIF
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
                                                                                CIR005
     C     CIR005        IFEQ      'Y'                                          CIR005
     C                   EVAL      WFrstPas = 'Y'                               CIR005
     C                   ENDIF                                                  CIR005
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
     C**********         MOVEL     FLPAY         RXPAY                                        CGL029
     C                   EVAL      %SUBST(RXPAY:1:2) = %SUBST(FLPAY:1:2)                      CGL029
     C                   EVAL      RXPONS = %SUBST(FLPAY:3:18)                                CGL029
     C                   EVAL      %SUBST(RXPAY:15:545) = %SUBST(FLPAY:21:545)                CGL029
     C                   MOVEL     FLPOBR        RXPOBR
     C                   MOVEL     FLCVMR        RXCVMR
      *
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **DataStructure**into*the**correspondent**file**field**.*******                  179510 200400
      ************                                                                     179510 200400
     C*****DDPSTM*       IFEQ      '04'                                                179510 200400
     C************       MOVE      @@MOPI        RXUPACC                               179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
      * UPDATE VALID DEAL: RECEIPT SETTLEMENT INSTRUCTIONS
      *
     C**********         MOVEL     FLREC         RXREC                                        CGL029
     C                   EVAL      %SUBST(RXREC:1:2) = %SUBST(FLREC:1:2)                      CGL029
     C                   EVAL      RXRONS = %SUBST(FLREC:3:18)                                CGL029
     C                   EVAL      %SUBST(RXREC:15:55) = %SUBST(FLREC:21:55)                  CGL029
     C                   MOVEL     FLROBR        RXROBR
      *
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **DataStructure**into*the**correspondent**file**field**.*******                  179510 200400
      ************                                                                     179510 200400
     C*****DDRSTM*       IFEQ      '04'                                                179510 200400
     C************       MOVE      @@MORI        RXURACC                               179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
      * UPDATE VALID DEAL: SETTLEMENT CURRENCY & 'IN' CCY IN FIELD 72
      *
     C                   MOVEL     FLRSCY        RXRSCY
     C                   MOVEL     FLPSCY        RXPSCY
     C                   MOVEL     FLIC72        RXIC72
      *
      * UPDATE VALID DEAL: FRA/IRS DETAILS
      *
     C                   MOVEL     FLIRS         RXIRS
     C                   MOVE      FLAGVC        RXAGVC                         CSW097
      *
      * Zeroise numeric fields in RXIRS for update (these fields may be
      * blank if Type is OTHER)
      *
     C     FLISDA        IFEQ      *BLANK                                       CSW097
     C                   Z-ADD     *ZERO         RXISDA                         CSW097
     C                   ENDIF                                                  CSW097
     C     FLAGDT        IFEQ      *BLANK
     C                   Z-ADD     *ZERO         RXAGDT
     C                   ENDIF
     C     FLAGVV        IFEQ      *BLANK
     C                   Z-ADD     *ZERO         RXAGVV
     C                   ENDIF
     C     FLAGVC        IFEQ      *BLANK                                       CSW097
     C                   Z-ADD     *ZERO         RXAGVC                         CSW097
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
     C                   MOVE      *ALL'Y'       IRECIRS
      *
      * Validate deal details
      *
     C                   CALLB     'IRCIRSVAL'
     C                   PARM                    ModeOfOp                       CIR005
     C                   PARM                    RespMode
     C                   PARM                    NwDlScnFmt
     C                   PARM      RXRSCY        @@RSCY
     C                   PARM      RXRSTM        @@RSTM
     C                   PARM      RXRONS        @@RONS
     C                   PARM      RXPSCY        @@PSCY
     C                   PARM      RXPSTM        @@PSTM
     C                   PARM      RXPONS        @@PONS
     C                   PARM                    ExtData                        CAP004
     C                   PARM                    WValBDC                        CIR005
     C                   PARM                    IRECIRS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *ZERO         Idx               3 0
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      *ZERO         WIdx              3 0
     C                   PARM                    NwDlFilFmt
     C                   PARM                    NwDlXFilFmt                                  CLE025
      *                                                                                       187606
     C                   PARM                    SACCD                                        187606
     C                   PARM                    USLIP                                        184560
     C                   PARM                    TSLIP                                        184560
      *                                                                                       185057
      * Current Deal in Screen Format                                                         185057
     C                   PARM                    CrDlScnFmt                                   185057
     C*
     C* For each warning error code set up in IRC schedule screens,
     C* set up message to be sent to the screen
     C*
     C                   Z-ADD     1             C
     C     C             DOWLE     10
     C     @WERRAR(C)    ANDNE     *BLANKS
     C                   MOVEL     @WERRAR(C)    @WERRMS
     C                   EXSR      SNDW@M
     C                   ADD       1             C
     C                   END
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
     C                   CALLB     'IRCIRSDSP'
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
     C                   PARM                    IRECIRS
     C/COPY WNCPYSRC,IRH00015
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
     C                   MOVE      *ALL'Y'       IRECIRS
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
     C                   MOVEL     'Y'           CANCFM            1                          CAP041
      *                                                                                       CAP041
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
                                                                                CIR005
     C                   IF        CIR005 = 'Y'                                 CIR005
     C                   EVAL      WFrstPas = 'Y'                               CIR005
     C                   ENDIF                                                  CIR005
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
      ** Reset 'Cancel taken from Confirm Screen' indicator                                   CAP041
     C                   MOVE      'N'           CANCFM                                       CAP041
      *                                                                                       CAP041
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
     C/COPY WNCPYSRC,IRCIRSSC03
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
     C                   PARM      *ZERO         RXDLNO
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
     C                   MOVEL     SDLNO         RXDLNO
     C     RDLNO         IFEQ      *BLANKS                                                   BUG4307
     C     RDLNO         OREQ      '000000'                                                  BUG4307
     C                   MOVE      SDLNO         RDLNO                                       BUG4307
     C                   ENDIF                                                               BUG4307
      *
      * UPDATE VALID DEAL: LAST ACTION CODE
      *
     C                   MOVEL     SACCD         RXCHTP
     C/COPY WNCPYSRC,IRH00016
      *
      * DEALS UPDATES
      * (Interest rate calender parameters must be zero as IRC dates            CAP004
      *  are not set up by IRCIRSUPP when input is via the screen)              CAP004
      *
     C                   CALLB     'IRCIRSUPD'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      *BLANKS       PModeofOp                                    CAP056
     C                   PARM                    NwDlFilFmt
     C                   PARM                    NwDlXFilFmt                                  CLE025
     C**********         PARM      *ZEROS        OurRatChgs      294                   CAP004 CAP043
     C**********         PARM      *ZEROS        OurPayDats      294                   CAP004 CAP043
     C**********         PARM      *ZEROS        ThrRatChgs      294                   CAP004 CAP043
     C**********         PARM      *ZEROS        ThrPayDats      294                   CAP004 CAP043
     C                   PARM      'Y'           ScreenInpt                     CAP004
     C                   PARM                    ExtSett1                                     CIR003
     C                   PARM                    ExtSett2                                     CIR003
     C                   PARM                    ExtSett3                                     CIR003
     C                   PARM                    CIR008                                       CIR008
     C                   PARM                    CAP056                                       CAP056
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTION, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'                                    CAP006
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
     C                   COMMIT
     C/COPY WNCPYSRC,IRCIRSSC02
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
     C                   MOVEL     *BLANK        @WerrAr
     C                   MOVEL     *BLANKS       DATA                                         CAP041
     C/COPY WNCPYSRC,IRH00017
     C                   MOVEL     *BLANK        WFldNamArr                                   CAS005
     C                   MOVEL     *BLANK        WMsgIdArr                                    CAS005
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CAS005
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
      *                                                                         CIR005
      ** Blank the Business Day Currency Convention fields                      CIR005
     C                   IF        CIR005 = 'Y'                                 CIR005
     C                   EVAL      WFrstPas = 'Y'                               CIR005
     C                   MOVEL     *Blank        BsDayConv                      CIR005
     C                   MOVEL     *Blank        WSavBDC                        CIR005
     C                   ENDIF                                                  CIR005
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
     C                   ROLBK
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
     C                   MOVEL     'IRCIRSSIN'   DBPGM
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
      *
      **  Access SAR details file to determine if IRC feature is on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR001'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************
     C                   MOVEL     '903'         DBASE                          * DBERR 903 *
     C                   MOVEL     'CIR001'      DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CIR001            1
     C                   ELSE
     C                   MOVEL     'N'           CIR001
     C                   END
      *
      **  Access SAR details file to determine if Compounding of Interest
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR002'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************
     C                   MOVEL     '904'         DBASE                          * DBERR 903 *
     C                   MOVEL     'CIR002'      DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CIR002            1
     C                   ELSE
     C                   MOVEL     'N'           CIR002
     C                   END
      *                                                                         CIR005
      **  Access SAR details file to determine if Bus. Day Convention is on.    CIR005
      *                                                                         CIR005
     C                   CALL      'AOSARDR0'                                   CIR005
     C                   PARM      *BLANKS       @RTCD                          CIR005
     C                   PARM      '*VERIFY'     @OPTN                          CIR005
     C                   PARM      'CIR005'      @SARD                          CIR005
     C     SCSARD        PARM      SCSARD        DSFDY                          CIR005
      *                                                                         CIR005
     C                   IF        @RTCD <> *BLANKS and @RTCD <> '*NRF   '      CIR005
     C     *LOCK         IN        LDA                                          CIR005
     C                   MOVEL     'SCSARDPD'    DBFILE                         CIR005
     C                   Z-ADD     905           DBASE                          CIR005
     C                   MOVEL     'CIR005'      DBKEY                          CIR005
     C                   OUT       LDA                                          CIR005
     C                   EXSR      *PSSR                                        CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
     C                   IF        @RTCD = *BLANKS                              CIR005
     C                   MOVEL     'Y'           CIR005            1            CIR005
     C                   ELSE                                                   CIR005
     C                   MOVEL     'N'           CIR005                         CIR005
     C                   ENDIF                                                  CIR005
      *
      ** Access SAR details file to determine if IRS Fees/Buy-Outs etc                        CAP041
      ** is switched on.                                                                      CAP041
      *                                                                                       CAP041
     C                   CALL      'AOSARDR0'                                                 CAP041
     C                   PARM      *BLANKS       @RTCD                                        CAP041
     C                   PARM      '*VERIFY'     @OPTN                                        CAP041
     C                   PARM      'CAP041'      @SARD                                        CAP041
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP041
      *                                                                                       CAP041
     C                   IF        (@RTCD <> *BLANKS) And (@RTCD <> '*NRF   ')                CAP041
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAP041
     C                   MOVEL     '908'         DBASE                                        CAP041
     C                   MOVEL     'CAP041'      DBKEY                                        CAP041
     C                   EXSR      *PSSR                                                      CAP041
     C                   ENDIF                                                                CAP041
      *                                                                                       CAP041
     C                   IF        @RTCD = *BLANKS                                            CAP041
     C                   MOVEL     'Y'           CAP041            1                          CAP041
     C                   ELSE                                                                 CAP041
     C                   MOVEL     'N'           CAP041                                       CAP041
     C                   ENDIF                                                                CAP041
                                                                                              CAP041
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
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CIR008
     C                   EVAL      DBASE = 3                                                  CIR008
     C                   EVAL      DBKEY = 'CIR008'                                           CIR008
     C                   EXSR      *PSSR                                                      CIR008
     C                   ENDIF                                                                CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
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
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP056
     C                   EVAL      DBASE = 4                                                  CAP056
     C                   EVAL      DBKEY = 'CAP056'                                           CAP056
     C                   EXSR      *PSSR                                                      CAP056
     C                   ENDIF                                                                CAP056
     C                   ENDIF                                                                CAP056
                                                                                              CAP056
      * Start on Main Details Screen
      *
     C                   MOVEL     'M'           @SCRN             1
      *                                                                         CIR005
     C                   IF        CIR005 = 'Y'                                 CIR005
     C                   EVAL      WFrstPas = 'Y'                               CIR005
     C                   MOVEL     *Blank        BsDayConv                      CIR005
     C                   MOVEL     *Blank        WSavBDC                        CIR005
     C                   ENDIF                                                  CIR005
      *
      * Initialize field and function key status on main details screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
      *
     C                   EVAL      PLCcy = BJLCCY                               CIR005
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,IRCIRSS011
 
      *                                                                                       CIR003
      **  Access SAR details file to determine if Additional Pay/Receive Msgs.                CIR003
      **  for Principal Exchanges on Cross-Ccy IRS is On.                                     CIR003
      *                                                                                       CIR003
     C                   CALL      'AOSARDR0'                                                 CIR003
     C                   PARM      *BLANKS       @RTCD                                        CIR003
     C                   PARM      '*VERIFY'     @OPTN                                        CIR003
     C                   PARM      'CIR003'      @SARD                                        CIR003
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR003
      *                                                                                       CIR003
     C     @RTCD         IFNE      *BLANKS                                                    CIR003
     C     @RTCD         ANDNE     '*NRF   '                                                  CIR003
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CIR003
     C                   MOVEL     '906'         DBASE                                        CIR003
     C                   MOVEL     'CIR003'      DBKEY                                        CIR003
     C                   EXSR      *PSSR                                                      CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C     @RTCD         IFEQ      *BLANKS                                                    CIR003
     C                   MOVEL     'Y'           CIR003            1                          CIR003
     C                   ELSE                                                                 CIR003
     C                   MOVEL     'N'           CIR003                                       CIR003
     C                   ENDIF                                                                CIR003
                                                                                              CIR003
      *                                                                                       CIR006
      **  Access SAR details file to determine if Amortisation of Caps/Collars/Floors &       CIR006
      **  Individual Compounding Swaps feature is installed.                                  CIR006
      *                                                                                       CIR006
     C                   CALL      'AOSARDR0'                                                 CIR006
     C                   PARM      *BLANKS       @RTCD                                        CIR006
     C                   PARM      '*VERIFY'     @OPTN                                        CIR006
     C                   PARM      'CIR006'      @SARD                                        CIR006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR006
      *                                                                                       CIR006
     C     @RTCD         IFNE      *BLANKS                                                    CIR006
     C     @RTCD         ANDNE     '*NRF   '                                                  CIR006
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CIR006
     C                   MOVEL     '907'         DBASE                                        CIR006
     C                   MOVEL     'CIR006'      DBKEY                                        CIR006
     C                   EXSR      *PSSR                                                      CIR006
     C                   ENDIF                                                                CIR006
      *                                                                                       CIR006
     C     @RTCD         IFEQ      *BLANKS                                                    CIR006
     C                   MOVEL     'Y'           CIR006            1                          CIR006
     C                   ELSE                                                                 CIR006
     C                   MOVEL     'N'           CIR006                                       CIR006
     C                   ENDIF                                                                CIR006
                                                                                              CIR006
      ** Check if enhancement CLE025 (Credit Lines) is on                                     CLE025
                                                                                              CLE025
     C                   CALL      'AOSARDR0'                                                 CLE025
     C                   PARM      *BLANKS       @RTCD                                        CLE025
     C                   PARM      '*VERIFY'     @OPTN                                        CLE025
     C                   PARM      'CLE025'      @SARD                                        CLE025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE025
                                                                                              CLE025
     C                   IF        @RTCD <> *BLANKS AND @RTCD <> '*NRF   '                    CLE025
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CLE025
     C                   MOVEL     '908'         DBASE                                        CLE025
     C                   MOVEL     'CLE025'      DBKEY                                        CLE025
     C                   EXSR      *PSSR                                                      CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
     C                   IF        @RTCD = *BLANKS                                            CLE025
     C                   EVAL      CLE025 = 'Y'                                               CLE025
     C                   ELSE                                                                 CLE025
     C                   EVAL      CLE025 = 'N'                                               CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CGL014
      ** Check if enhancement CGL014 (Collaterals Processing) is on                           CGL014
                                                                                              CGL014
     C                   CALL      'AOSARDR0'                                                 CGL014
     C                   PARM      *BLANKS       @RTCD                                        CGL014
     C                   PARM      '*VERIFY'     @OPTN                                        CGL014
     C                   PARM      'CGL014'      @SARD                                        CGL014
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL014
                                                                                              CGL014
     C                   IF        @RTCD <> *BLANKS AND @RTCD <> '*NRF   '                    CGL014
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL014
     C                   MOVEL     '909'         DBASE                                        CGL014
     C                   MOVEL     'CGL014'      DBKEY                                        CGL014
     C                   EXSR      *PSSR                                                      CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        @RTCD = *BLANKS                                            CGL014
     C                   EVAL      CGL014 = 'Y'                                               CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      CGL014 = 'N'                                               CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
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
(c) Misys International Banking Systems Ltd. 2001
