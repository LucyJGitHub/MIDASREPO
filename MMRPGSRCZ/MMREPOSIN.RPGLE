     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Repo and bond lending input')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMREPOSIN - REPO MAINTENANCE                                 *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for repo deals.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR701789           Date 26Sep16               *
      *                 MD036070           Date 19Oct15               *
      *                 CGL165             Date 23Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CSW210             Date 04May10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 244860             Date 15Feb07               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CAP087             Date 22Aug05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CDL033             Date 10Feb05               *
      *                 CMM105             Date 22Jun04               *
      *                 BUG2876            Date 28May04               *
      *                 CGL014             DAte 24May04               *
      *                 BUG2804            Date 20May04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 196380             Date 15May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 204662             Date 16Apr02               *
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 200400             Date 20Nov01               *
      *                 192530             Date 15May01               *
      *                 192829             Date 08May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002             Date 08Aug00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 179510             Date 09Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 182224             Date 30Aug00               *
      * Midas DBA 3.02 Patch Z ---------------------------------------*
      *                 177547             Date 07Apr00               *
      *                 176883             Date 24Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006  *CREATE    Date 11May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR701789 - Unable to reject a deal amendment. Add a new      *
      *             parameter to indicate reject transaction.         *
      *             Applied for MD041482                              *
      *  MD036070 - No way to go back to main deal details screen     *
      *             after reaching settlement screen.  Introduce new  *
      *             function key F11.                                 *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  244860 - ERZ135 changes missing.                             *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP087 - Depot Movement API - Java Wrapper in Midasplus.     *
      *           Change due to additional parameter added to         *
      *           call MMRPDLUPD.                                     *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL033 - Floating Rate CDs Issued                            *
      *         - Incomplete parameter list passed to MMLDNIUPM.      *
      *  CMM105 - Core changes for GBO005                             *
      *         - Fixed Deposits Held Under Lien                      *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:MMREPOS008,MMREPOSC01,MMREPOSC02,*
      *                              MMREPOSC03                       *
      *           Core hooks added:MMREPOSC06                         *
      *  BUG2876- Parameter mismatch in MMLDNIDSP caused by CDL016    *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  BUG2804- Parameter mismatch in MMLDNIRTV caused by CDL016    *
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
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  196380 - Added parameter to MMLDNIRTV call.                  *
      *  204662 - Depot reference should be the same than deal number *
      *  CAP067 - Repurchase Agreements API.                          *
      *  200400 - Reverse fix 179510                                  *
      *  192530 - Pass the correct date to ZASETINSIN.                *
      *  192829 - Wrong module name passed to WN0010.                 *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *  179510 - For Settlement method 04 , fields  xxMORI &  xxMOPI *
      *           Midas  Our  Receive/ Pay  Instructions  respectively*
      *           are not  correctly  updated .  Introduced  new  Data
      *           Structure  @MORPI  which is used  for that purpose .*
      *  182224 - Deal Numbers are skipped by  Auto-allocation  process
      *           in   FX &  MM  input options .  When  F12  is pressed
      *           from  the last confirmation  screen ,  the  ROLBK   *
      *           is not performed  every time .                      *
      *  177547 - Duplicate hook numbers to MMLDNISIN                 *
      *  176883 - Errors found as a result of creating DBAR3.02       *
      *           Meridian repository file.                           *
      *           Recompiled due to mismatch between parameter calls  *
      *           to ZASETINDFT.                                      *
      *  CSE006 - Create Repo maintenance program                     *
      *                                                               *
      *****************************************************************
 
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
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
     D ##CM            S              1    DIM(58) CTDATA PERRCD(58)
     D ##CF            S              1    DIM(21) CTDATA PERRCD(21)
     D ##OX1           S              1    DIM(78) CTDATA PERRCD(78)
     D ##OX2           S              1    DIM(78) CTDATA PERRCD(78)
     D ##OX3           S              1    DIM(68) CTDATA PERRCD(68)
     D ##OX4           S              1    DIM(68) CTDATA PERRCD(68)
     D ##OX5           S              1    DIM(68) CTDATA PERRCD(68)
     D ##OX6           S              1    DIM(68) CTDATA PERRCD(68)
     D ##OX7           S              1    DIM(68) CTDATA PERRCD(68)
     D ##OX8           S              1    DIM(71) CTDATA PERRCD(71)
     D ##OX9           S              1    DIM(71) CTDATA PERRCD(71)
     D ##CN1           S              1    DIM(81) CTDATA PERRCD(81)
     D ##CT1           S              1    DIM(81) CTDATA PERRCD(81)
     D ##CN2           S              1    DIM(78) CTDATA PERRCD(78)
     D ##CT2           S              1    DIM(78) CTDATA PERRCD(78)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D CrDlFilFmt    E DS                  EXTNAME(MMDELDPP)
      * Current Deal in File Format
 
     D CrDlScnFmt    E DS                  EXTNAME(MMLDNIPD)
      * (Current) Deal in Screen Format
     D                                     PREFIX(@)
     D InfData       E DS                  EXTNAME(MMLDIFPD)
     D                                     PREFIX(IF_)
      * MM Extra Data - File (D/B) format
 
     D NwDlFilFmt    E DS                  EXTNAME(MMVLDNIPD)
      * New Deal in File Format
     D QQDOR1        E                     EXTFLD(QQDORI)                                     CGL029
     D QQMOR1        E                     EXTFLD(QQMORI)                                     CGL029
     D QQDOP1        E                     EXTFLD(QQDOPI)                                     CGL029
     D QQMOP1        E                     EXTFLD(QQMOPI)                                     CGL029
     D QQRON1        E                     EXTFLD(QQRONS)                                     CGL029
     D QQPON1        E                     EXTFLD(QQPONS)                                     CGL029
     D QQINS1        E                     EXTFLD(QQINSA)                                     CGL029
     D  IKREC                456    524
     D  IKPAY                525   1083
 
     D NwDlScnFmt    E DS                  EXTNAME(MMLDNIPD)
      * New Deal in Screen Format
 
     D MMELDN        E DS                  EXTNAME(MMELDNIPD)
      * Error indicators
 
     D**  Data structure of Depot Movement File                                               CAP087
     D DPTXX         E DS                  EXTNAME(DPTMVDL1) PREFIX(D)                        CAP087
 
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
 
     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      ** SCREEN RECEIVE INSTRUCTIONS
 
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      ** SCREEN PAYMENT INSTRUCTIONS
 
     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      ** SCREEN FRA/IRS INSTRUCTIONS
                                                                                              CDL033
     D #FPAYF        E DS                  EXTNAME(SDFSFPPD)                                  CDL033
      ** File - Payment Further Settlement Instructions                                       CDL033
                                                                                              CDL033
     D #FRECF        E DS                  EXTNAME(SDFSFRPD)                                  CDL033
      ** File - Receive Further Settlement Instructions                                       CDL033
 
     D @SETIN          DS
      ** Receive / Pay Settlement Currency, Method & Nostro
     D  @@RSCY                 1      3
     D  @@RSTM                 4      5  0
     D  @@RONS                 6     17
     D  @@PSCY                18     20
     D  @@PSTM                21     22  0
     D  @@PONS                23     34
 
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
      ***Midas*Our Receive / Pay  Instructions (for Settl Meth = 04 )                  179510 200400
     D**@@MORI****             1     12                                                179510 200400
     D**@@MOPI****            13     24                                                179510 200400
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** MIDAS MODULES DETAILS ACCESSED VIA ACCESS PROGRAM
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D ExtData       E DS                  EXTNAME(MMLDEXPD)
      * MM (LDNI) Extra Data - File (D/B) format
 
     D*CO*Y*QWINDSRC*MMLDNISDTA*******************                                            177547
     D/COPY QWINDSRC,MMREPOSDTA                                                               177547
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
                                                                                              CDL033
     D PCONF           S              1A                                                      CDL033
     D PAFRCD          S            100A                                                      CDL033
     D PBFRCD          S            100A                                                      CDL033
                                                                                              CAP087
      ** Flag to indicate caller of MMRPDLUPD                                                 CAP087
      ** 'Y' - called from Securities module                                                  CAP087
      ** 'N' - called from Money Markey module                                                CAP087
     D DepotPos        S              1A                                                      CAP087
                                                                                              CAP087
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *CO*Y*WNCPYSRC*MMLDNIS008*******************                                            177547
      /COPY WNCPYSRC,MMREPOS008                                                               177547
 
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
 
      *CO*Y*WNCPYSRC*MMLDNIS001*******************                                            177547
      /COPY WNCPYSRC,MMREPOS001                                                               177547
 
      * READ NEXT BROWSE SUBFILE RECORD
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   END
 
      *CO*Y*WNCPYSRC*MMLDNIS002**********************                                         177547
      /COPY WNCPYSRC,MMREPOS002                                                               177547
 
      * DO WHILE SCREEN: MAIN DETAILS
     C     @SCRN         DOWEQ     'M'
     C                   EXSR      SCRN@M
     C                   END
 
      *CO*Y*WNCPYSRC*MMLDNIS003**********************                                         177547
      /COPY WNCPYSRC,MMREPOS003                                                               177547
 
      * SCREEN: WINDOW
     C     @SCRN         IFEQ      'W'
     C                   EXSR      WINDOW
     C                   END
 
      *CO*Y*WNCPYSRC*MMLDNIS004**********************                                         177547
      /COPY WNCPYSRC,MMREPOS004                                                               177547
 
      * DO WHILE SCREEN: SETTLEMENT DETAILS
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      SCRN@S
     C                   END
 
      *CO*Y*WNCPYSRC*MMLDNIS005**********************                                         177547
      /COPY WNCPYSRC,MMREPOS005                                                               177547
 
      * DO WHILE SCREEN: REPO DELIVERY DETAILS
     C     @SCRN         DOWEQ     'D'
     C                   EXSR      SCRN@D
     C                   END
 
      *CO*Y*WNCPYSRC*MMLDNIS005**********************                                         177547
      /COPY WNCPYSRC,MMREPOS011                                                               177547
 
      * SCREEN: CONFIRMATION OF INPUT
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   END
 
      *CO*Y*WNCPYSRC*MMLDNIS006**********************                                         177547
      /COPY WNCPYSRC,MMREPOS006                                                               177547
 
      * DO FILE UPDATES
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   END
 
      *CO*Y*WNCPYSRC*MMLDNIS007**********************                                         177547
      /COPY WNCPYSRC,MMREPOS007                                                               177547
 
      * TERMINATE PROGRAM
     C     @SCRN         IFEQ      'T'
     C                   MOVE      '1'           *INLR
     C                   END
      *****************************************************************
 
      * Hook to enable non-core subroutines to be included
      *CO*Y*WNCPYSRC*MMLDNIS009**********************                                         177547
      /COPY WNCPYSRC,MMREPOS009                                                               177547
 
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
     C     DDDLNO        IFNE      @PDLNO
     C     @CCI@M        ORNE      @PCI@M
                                                                                              182224
      * Check for the work field indicating Deal No. allocation has run                       182224
     C     @WFRUN        OREQ      'Y'                                                        182224
                                                                                              182224
     C                   ROLBK
                                                                                              182224
     C                   EVAL      @WFRUN = *BLANKS                                           182224
     C                   END
     C                   END
      *
      * Update 'previous' deal number & screen control indicator
      *
     C                   MOVEL     DDDLNO        @PDLNO            6
     C                   MOVEL     @CCI@M        @PCI@M
      *
      * WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'MMLDNIDSP'
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
      ** Collateral Status
     C                   PARM                    DDCSTS           10
      *
      * FIELDS IN ERROR
     C                   PARM                    MMELDN
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
     C                   PARM      'N'           @EINKT            1
      *
      * SUCCESFUL INSERT DEAL
     C                   PARM                    @SIDN             6
      * CALLING PGM                                                                           CAP067
     C                   PARM      'MMREPOSIN '  CPGM             10                          CAP067
      *                                                                                      BUG2876
      ** Blocked/Unblock Action                                                              BUG2876
     C                   PARM                    BUACT                                       BUG2876
      *                                                                                       CAP067
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
     C                   PARM      '0'           @INKT             1
     C                   PARM      'N'           WriteOnly         1
     C                   PARM      'Y'           RepoFlag          1
     C/COPY WNCPYSRC,MMLDNIXC05                                                               244860
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       MMELDN
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
     C                   EXSR      RTVDEL
      *
      * If action code, deal number or booking branch are NOT OK
      * Re-output screen with error messages on it
      *
     C     OKACTN        IFEQ      'N'
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
      * If action code is delete, enquire or authorize
      * or action code is amend and deal number has changed
      *   Put the deal on the main details screen
      *
     C     DDACTN        IFEQ      'D'
     C     DDACTN        OREQ      'E'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'A'
     C     DDDLNO        ANDNE     @PDLNO
     C                   EXSR      PUTD@M
     C                   END
      *
      * If deal number or screen control indicators have changed
      *   Re-output screen
      *
     C     DDDLNO        IFNE      @PDLNO
     C     DDACTN        ANDNE     'I'
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
      *
      * Call MMRPDLSFL to delete out depot movements
      *
     C                   CALLB     'MMRPDLSFL'
     C                   PARM                    NwDlScnFmt
     C                   PARM      *BLANKS       OldDlNo           6
     C                   PARM      *BLANKS       ReturnCode
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
     C                   MOVEL     'D'           @SCRN                                        CAP067
     C*****@RDNB         IFEQ      'Y'                                                        CAP067
     C**********         MOVEL     'R'           @SCRN                                        CAP067
     C**********         END                                                                  CAP067
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
     C                   MOVE      *ALL'Y'       MMELDN
     C                   CLEAR                   NwDlFilFmt
     C                   Z-ADD     *ZERO         IKRSTM
     C**********         Z-ADD     *ZERO         IKROBN                                       CSD027
     C**********         Z-ADD     *ZERO         IKROCN                                       CSD027
     C                   EVAL      IKROBN = *BLANKS                                           CSD027
     C                   EVAL      IKROCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         IKPSTM
     C**********         Z-ADD     *ZERO         IKPOBN                                       CSD027
     C**********         Z-ADD     *ZERO         IKPOCN                                       CSD027
     C                   EVAL      IKPOBN = *BLANKS                                           CSD027
     C                   EVAL      IKPOCN = *BLANKS                                           CSD027
      *
      * IF AMEND
      *
     C     DDACTN        IFEQ      'A'
      *
      * Update Deal in File Format
      *
     C                   MOVEL     CrDlFilFmt    NwDlFilFmt
      *
      * Validate whether non-amenable fields have been changed
      *
     C                   CALLB     'MMLDNIAMD'
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
     C                   PARM                    MMELDN
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
     C                   CALLB     'MMLDNIVAL'
     C                   PARM                    RespMode
     C                   PARM                    NwDlScnFmt
     C                   PARM                    ACTRJ                                      AR701789
     C                   PARM                    InfData
     C                   PARM      IKSTCY        @@RSCY
     C                   PARM      IKRSTM        @@RSTM
     C                   PARM      IKRONS        @@RONS
     C                   PARM      IKSTCY        @@PSCY
     C                   PARM      IKPSTM        @@PSTM
     C                   PARM      IKPONS        @@PONS
     C                   PARM      IKFRNT        @@FRNT           20            CPB002
     C                   PARM                    ExtData
     C                   PARM                    MMELDN
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwDlFilFmt
     C                   PARM      'Y'           RepoFlag
      ** Called from confirmation screen?                                                     CDL033
     C                   PARM      'N'           PCONF                                        CDL033
     C/COPY WNCPYSRC,MMREPOSC01
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
     C                   MOVE      *ALL'Y'       MMELDN
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * Write out screen to remove error messages
      *
     C                   CALLB     'MMLDNIDSP'
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
      *                                                                                       CGL011
      ** Collateral Status
     C                   PARM                    DDCSTS           10
      *
      * FIELDS IN ERROR
     C                   PARM                    MMELDN
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
     C                   PARM      'N'           @EINKT            1
      *
      * SUCCESFUL INSERT DEAL
     C                   PARM                    @SIDN             6
      * CALLING PGM                                                                           CAP067
     C                   PARM      'MMREPOSIN '  CPGM             10                          CAP067
      *                                                                                      BUG2876
      ** Blocked/Unblock Action                                                              BUG2876
     C                   PARM                    BUACT                                       BUG2876
      *                                                                                       CAP067
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
     C                   PARM      '0'           @INKT             1
     C                   PARM      'Y'           WriteOnly         1
     C                   PARM      'Y'           RepoFlag
     C/COPY WNCPYSRC,MMLDNIXC05                                                               244860
      *
      * IF DEAL NUMBER NOT DEFINED (ON INSERT),
      * GET NEXT AVAILABLE DEAL NUMBER
      *
     C     DDDLNO        IFEQ      *BLANK
     C                   CALLB     'CAGETNXTDL'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       @@MSG1            7
     C                   PARM                    I#DDDLNO          6
     C                   PARM      *ZERO         IKDN38
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
                                                                                              182224
     C                   END
      *
     C*CO*Y*QWINDSRC*MMLDNISMV1*******************                                            177547
     C/COPY WNCPYSRC,MMREPOSMV1                                                               177547
      *
     C                   CALL      'WN0010'
     C**********         PARM      'MMLDNISIN'   #PGM             10                          192829
     C                   PARM      'MMREPOSIN'   #PGM             10                          192829
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
     C     @RDNB         IFEQ      'Y'
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
     C                   EVAL      @SCRN = 'M'
     C                   END
     C                   ELSE
     C     DDACTN        IFEQ      'E'
     C                   EVAL      @SCRN = 'D'
     C                   ELSE
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
     C                   CALLB     'MMLDNIRED'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '      '      @@MODE            6
      *
      * ACTION CODE
     C                   PARM                    DDACTN            1
      *
      * DEAL NUMBER POINTER
     C                   PARM                    DDDLNO            6
      *
      * Front Office ID
     C                   PARM                    DDFRTN           20
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
      *
      * Front Office ID READ
     C                   PARM      *BLANK        @FTRED           20
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
      *
      * BUILD BROWSE SUBFILE
      *
     C                   CALLB     'MMLDNIBRW'
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
     C                   CALLB     'MMLDNIBRW'
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
      *
      * IF DEAL READ FROM SUBFILE
      *
     C     @DLSEL        IFNE      *BLANK
      *
      * Retrieve deal details
      *
     C                   MOVEL     @OPSEL        DDACTN
     C                   MOVEL     @DLSEL        DDDLNO
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
     C                   CALLB     'MMLDNIRTV'
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
      *                                                                                       196380
      * (Midas) Depot Movement Reference                                                      196380
     C                   PARM                    DDDDMR                                       196380
      *
      * (Midas) Associated Deal Number
     C                   PARM                    DDDADN
      *
      * Booking branch
     C                   PARM                    DDBRCA            3
      *                                                                                       CAP067
      * REPO Flag                                                                             CAP067
     C                   PARM      'N'           RepoFlag          1                          CAP067
      *
      * OUTPUTS
      *
      * (Current) deal in file format
     C                   PARM                    CrDlFilFmt
      *                                                                                     AR701789
     C                   PARM                    ACTRJ             1                        AR701789
      *
      * OK - Action code
     C                   PARM      *BLANK        OKACTN
      *
      * OK - Deal Number
     C                   PARM      *BLANK        OKDLNO
      *
      * OK - Booking branch
     C                   PARM      *BLANK        OKBRCA
      ** Blocked/Unblock Action                                                              BUG2804
     C                   PARM                    BUACT             1                         BUG2804
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
                                                                                              CAS004
      ** Warning flds/message IDs/message data (arrays) from/to caller                        CAS004
                                                                                              CAS004
     C                   PARM                    WFldNamArr                                   CAS004
     C                   PARM                    WMsgIdArr                                    CAS004
     C                   PARM                    WMsgDtaArr                                   CAS004
                                                                                              CAS004
      ** Array index (3P0) from/to caller                                                     CAS004
                                                                                              CAS004
     C                   PARM                    WIdx                                         CAS004
     C/COPY WNCPYSRC,MMREPOSC06
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PUTD@M - PUT A DEAL ON THE MAIN DETAILS SCREEN
      *****************************************************************
     C     PUTD@M        BEGSR
      *
      * Call program to fill screen fields with data from MMDELDPP
      *
     C                   CALLB     'MMLDNICVT'
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
      * Deal Status
     C                   PARM                    DDSTS            24
      *
      ** Collateral Status
     C                   PARM                    DDCSTS           10
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
      ** DETERMINE IF LOAN OR DEPOSIT                                                         192530
      *                                                                                       192530
     C     DDTYPE        IFEQ      'IP'                                                       192530
     C     DDTYPE        OREQ      'TI'                                                       192530
     C     DDTYPE        OREQ      'LN'                                                       192530
     C     DDTYPE        OREQ      'CL'                                                       192530
     C     DDTYPE        OREQ      'DL'                                                       192530
     C                   MOVEL     'L'           ##LOD             1                          192530
     C                   ELSE                                                                 192530
     C                   MOVEL     'D'           ##LOD                                        192530
     C                   END                                                                  192530
      *                                                                                       192530
      ** PAYMENT DATE = VALUE DATE FOR LOAN, MATURITY DATE FOR DEPOSIT                        192530
      *                                                                                       192530
     C     ##LOD         IFEQ      'L'                                                        192530
     C                   Z-ADD     IKDVSD        ##DATP                                       192530
     C                   ELSE                                                                 192530
     C     IKMATD        IFEQ      0                                                          192530
     C                   Z-ADD     99999         ##DATP                                       192530
     C                   ELSE                                                                 192530
     C                   Z-ADD     IKMATD        ##DATP                                       192530
     C                   END                                                                  192530
     C                   END                                                                  192530
      *                                                                                       192530
      ** RECEIVE DATE = MATURITY DATE FOR LOAN, VALUE DATE FOR DEPOSIT                        192530
      *                                                                                       192530
     C     ##LOD         IFEQ      'L'                                                        192530
     C     IKMATD        IFEQ      0                                                          192530
     C                   Z-ADD     99999         ##DATR                                       192530
     C                   ELSE                                                                 192530
     C                   Z-ADD     IKMATD        ##DATR                                       192530
     C                   END                                                                  192530
     C                   ELSE                                                                 192530
     C                   Z-ADD     IKDVSD        ##DATR                                       192530
     C                   END                                                                  192530
      *
      * IF FIRST TIME FOR ACTION CODE, DEAL NUMBER, CURRENCY OR CUSTOMER
      *
     C     DDACTN        IFNE      ##ACTN
     C     DDDLNO        ORNE      ##DLNO
     C     DDCCY         ORNE      ##PCCY
     C     DDCUST        ORNE      ##CSNM
      *
      * DETERMINE PARAMETERS FOR SETTLEMENT DETAILS INPUT
      *
     C                   EXSR      DETP@S
     C                   END
      *
      * SETTLEMENT INSTRUCTIONS INPUT
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
     C                   PARM      'LDNI'        ##CALP            4
      *
      * Payment currency
     C                   PARM      DDCCY         ##PCCY            3
      *
      * Receive currency
     C                   PARM      DDCCY         ##RCCY            3
      *
      * Customer shortname
     C                   PARM      DDCUST        ##CSNM           10
      *
      * Transaction Type
     C                   PARM      DDTYPE        ##TTYP            2
      *
      * Federal Funds Ind.
     C                   PARM      DDFEDF        ##FFND            1
      *
      * Booking branch
     C                   PARM      DDBRCA        ##BRCA            3
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
      **MIDAS*Our*Receive/ Pay Instructions (for Settlm Meth = 04 )                    179510 200400
     C************       PARM                    @MORPI                                179510 200400
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
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DETP@S - DETERMINE PARAMETERS FOR SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     DETP@S        BEGSR
      *
      * DETERMINE IF LOAN OR DEPOSIT
      *
     C     DDTYPE        IFEQ      'IP'
     C     DDTYPE        OREQ      'TI'
     C     DDTYPE        OREQ      'LN'
     C     DDTYPE        OREQ      'CL'
     C     DDTYPE        OREQ      'DL'
     C                   MOVEL     'L'           ##LOD             1
     C                   ELSE
     C                   MOVEL     'D'           ##LOD
     C                   END
      *
      * PAYMENT DATE = VALUE DATE FOR LOAN, MATURITY DATE FOR DEPOSIT
      *
     C     ##LOD         IFEQ      'L'
     C                   Z-ADD     IKDVSD        ##DATP
     C                   ELSE
     C     IKMATD        IFEQ      0
     C                   Z-ADD     99999         ##DATP
     C                   ELSE
     C                   Z-ADD     IKMATD        ##DATP
     C                   END
     C                   END
      *
      * RECEIVE DATE = MATURITY DATE FOR LOAN, VALUE DATE FOR DEPOSIT
      *
     C     ##LOD         IFEQ      'L'
     C     IKMATD        IFEQ      0
     C                   Z-ADD     99999         ##DATR
     C                   ELSE
     C                   Z-ADD     IKMATD        ##DATR
     C                   END
     C                   ELSE
     C                   Z-ADD     IKDVSD        ##DATR
     C                   END
      *
      * Convert Transaction Date to a Midas Day Number
      *
     C                   Z-ADD     IKDTYY        @@YY
     C                   Z-ADD     IKDTMM        @@MM
     C                   Z-ADD     IKDTDD        @@DD
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
     C**********         MOVEL     IKPAY         FLPAY                                        CGL029
     C                   EVAL      %SUBST(FLPAY:1:2) = %SUBST(IKPAY:1:2)                      CGL029
     C                   EVAL      %SUBST(FLPAY:3:18) = IKPONS                                CGL029
     C                   EVAL      %SUBST(FLPAY:21:545) = %SUBST(IKPAY:15:545)                CGL029
     C                   MOVEL     IKPOBR        FLPOBR
     C                   MOVEL     IKCVMR        FLCVMR
     C                   MOVEL     IKSTCY        FLPSCY
     C                   MOVEL     IKIC72        FLIC72
      *
      * SET UP RECEIVE INSTRUCTIONS FROM DEAL
      * (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C**********         MOVEL     IKREC         FLREC                                        CGL029
     C                   EVAL      %SUBST(FLREC:1:2) = %SUBST(IKREC:1:2)                      CGL029
     C                   EVAL      %SUBST(FLREC:3:18) = IKRONS                                CGL029
     C                   EVAL      %SUBST(FLREC:21:55) = %SUBST(IKREC:15:55)                  CGL029
     C                   MOVEL     IKROBR        FLROBR
     C                   MOVEL     IKSTCY        FLRSCY
      *
      * IF SETTLEMENT INSTRUCTIONS ARE NOT DEFINED,
      * AND PAYMENT/RECEIPT DATES ARE NOT IN THE PAST, DEFAULT THEM
      *
     C     FLPSTM        IFEQ      *ZERO
     C     ##PPAY        ANDNE     'Y'
     C     FLRSTM        ANDEQ     *ZERO
     C     ##PREC        ANDNE     'Y'
     C     DDACTN        ANDNE     'E'
      *
     C                   CALLB     'ZASETINDFT'
      *
      * INPUTS
      *
      * Calling program
     C                   PARM      'LDNI'        ##CALP            4
      *
      * Payment currency
     C                   PARM      DDCCY         ##PCCY            3
      *
      * Receive currency
     C                   PARM      DDCCY         ##RCCY            3
      *
      * Customer shortname
     C                   PARM      DDCUST        ##CSNM           10
      *
      * Transaction Type
     C                   PARM      DDTYPE        ##TTYP            2
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
     C                   PARM      DDCCY         ##RCCY                                      CSF011A
     C                   PARM      DDCCY         ##PCCY                                      CSF011A
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
      * SET SCREEN INDICATOR TO PROCESS THIRD SCREEN
      *
     C                   EVAL      @SCRN='D'
 
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
     C                   MOVE      *ALL'Y'       MMELDN
      *
      * Validate deal details
      *
     C                   CALLB     'MMLDNIVAL'
     C                   PARM                    RespMode
     C                   PARM                    NwDlScnFmt
     C                   PARM                    ACTRJ                                      AR701789
     C                   PARM                    InfData
     C                   PARM      IKSTCY        @@RSCY
     C                   PARM      IKRSTM        @@RSTM
     C                   PARM      IKRONS        @@RONS
     C                   PARM      IKSTCY        @@PSCY
     C                   PARM      IKPSTM        @@PSTM
     C                   PARM      IKPONS        @@PONS
     C                   PARM      IKFRNT        @@FRNT           20            CPB002
     C                   PARM                    ExtData
     C                   PARM                    MMELDN
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *ZERO         Idx               3 0
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      *ZERO         WIdx              3 0
     C                   PARM                    NwDlFilFmt
     C                   PARM                    RepoFlag
      ** Called from confirmation screen?                                                     CDL033
     C                   PARM      'Y'           PCONF                                        CDL033
     C/COPY WNCPYSRC,MMREPOSC02
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
     C                   CALLB     'MMLDNIDSP'
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
      *                                                                                       CGL011
      ** Collateral Status
     C                   PARM                    DDCSTS           10
      *
      * FIELDS IN ERROR
     C                   PARM                    MMELDN
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
     C                   PARM      'N'           @EINKT
      *
      * SUCCESFUL INSERT DEAL
     C                   PARM                    @SIDN             6
      * CALLING PGM                                                                           CAP067
     C                   PARM      'MMREPOSIN '  CPGM             10                          CAP067
      *                                                                                      BUG2876
      ** Blocked/Unblock Action                                                              BUG2876
     C                   PARM                    BUACT                                       BUG2876
      *                                                                                       CAP067
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
     C                   PARM      '0'           @INKT             1
     C                   PARM      'N'           WriteOnly         1
     C                   PARM      'Y'           RepoFlag          1
     C/COPY WNCPYSRC,MMLDNIXC05                                                               244860
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       MMELDN
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
      /EJECT
      *****************************************************************
      * SCRN@D - PROCESS SCREEN: REPO DELIVERY DETAILS
      *          EVOKED FOR INSERTS, AMENDS, ENQUIRIES & AUTHORIZATIONS
      *****************************************************************
     C     SCRN@D        BEGSR
     C*
     C* CREATE TEMPORARY FILES FOR CERTIFICATES PROCESSING
     C*
     C                   Z-ADD     78            MESLEN
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##CN2
     C                   PARM                    MESLEN
 
     C                   Z-ADD     78            MESLEN
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##CT2
     C                   PARM                    MESLEN
 
     C*
     C* Override SECRTNTPPD to QTEMP/SECRTNTPPD
     C*
     C                   Z-ADD     78            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX1
     C                   PARM                    MESLEN
     C*
     C* Override SECRTTTPPD to QTEMP/SECRTTTPPD
     C*
     C                   Z-ADD     78            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX2
     C                   PARM                    MESLEN
      *
      *
     C                   CALLB     'MMRPDLSFL'
     C                   PARM                    NwDlScnFmt
     C                   PARM      *BLANKS       OldDlNo           6
     C                   PARM      *BLANKS       ReturnCode
      *
      * DATABASE ERROR
      *
     C     ReturnCode    IFEQ      '*Error '
     C                   MOVEL     'MMRPDLSFL'   DBFILE                         ************
     C                   MOVEL     '003'         DBASE                          * DBERR 001*
     C                   MOVEL     DDDLNO        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      * F3 Pressed
      *
     C     ReturnCode    CASEQ     'F3        '  ENDP
      *
      * F12 Pressed
      *
     C     ReturnCode    CASEQ     'F12       '  CANC@S
      *
     C                   ENDCS
      *
      * CONTINUE WITH CONFIRMATION SCREEN
      *
     C     ReturnCode    IFEQ      *BLANKS
      *
     C     DDACTN        IFEQ      'E'
     C     @RDNB         IFEQ      'Y'
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
     C                   EVAL      @SCRN = 'M'
     C                   END
     C                   ELSE
     C                   MOVEL     'C'           @SCRN
     C                   END
      * UPDATE VALID DEAL: PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C**********         MOVEL     FLPAY         IKPAY                                        CGL029
     C                   EVAL      %SUBST(IKPAY:1:2) = %SUBST(FLPAY:1:2)                      CGL029
     C                   EVAL      IKPONS = %SUBST(FLPAY:3:18)                                CGL029
     C                   EVAL      %SUBST(IKPAY:15:545) = %SUBST(FLPAY:21:545)                CGL029
     C                   MOVEL     FLPOBR        IKPOBR
     C                   MOVEL     FLCVMR        IKCVMR
      *
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **DataStructure**into*the**correspondent**file**field**.*******                  179510 200400
      ************                                                                     179510 200400
     C*****DDPSTM*       IFEQ      '04'                                                179510 200400
     C************       MOVE      @@MOPI        IKMOPI                                179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
      * UPDATE VALID DEAL: RECEIPT SETTLEMENT INSTRUCTIONS
      *
     C**********         MOVEL     FLREC         IKREC                                        CGL029
     C                   EVAL      %SUBST(IKREC:1:2) = %SUBST(FLREC:1:2)                      CGL029
     C                   EVAL      IKRONS = %SUBST(FLREC:3:18)                                CGL029
     C                   EVAL      %SUBST(IKREC:15:55) = %SUBST(FLREC:21:55)                  CGL029
     C                   MOVEL     FLROBR        IKROBR
      *
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **DataStructure**into*the**correspondent**file**field**.*******                  179510 200400
      ************                                                                     179510 200400
     C*****DDRSTM*       IFEQ      '04'                                                179510 200400
     C************       MOVE      @@MORI        IKMORI                                179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
      * UPDATE VALID DEAL: SETTLEMENT CURRENCY & 'IN' CCY IN FIELD 72
      *
     C                   MOVEL     FLPSCY        IKSTCY
     C                   MOVEL     FLIC72        IKIC72
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        BEGSR
      *
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
     C                   PARM      *ZERO         IKDN38
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
     C                   MOVEL     DDDLNO        IKDN38
      *
      * UPDATE VALID DEAL: LAST ACTION CODE
      *
     C                   MOVEL     DDACTN        IKLACT
      *
      * MONEY MARKET UPDATES
      *
     C                   MOVEL     DDDLNO        IKDDMR                                       204662
     C                   CALLB     'MMLDNIUPM'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM                    NwDlFilFmt
     C                   PARM                    #FPAYF                                       CDL033
     C                   PARM                    #FRECF                                       CDL033
      ** FRCD Issued Extension details before update                                          CDL033
     C                   PARM      *BLANKS       PBFRCD                                       CDL033
      ** FRCD Issued Extension details after update                                           CDL033
     C                   PARM      *BLANKS       PAFRCD                                       CDL033
     C/COPY WNCPYSRC,MMREPOSC03
      *
      * DEALS UPDATES
      *
     C     @RTCD         IFEQ      *BLANK
     C                   CALLB     'MMLDNIUPD'
     C                   PARM                    @RTCD
     C                   PARM                    NwDlFilFmt
     C                   END
      *
      * REPO DELIVERY DETAILS UPDATE
      *
     C*
     C* Override SECRTNTPPD to QTEMP/SECRTNTPPD
     C*
     C                   Z-ADD     78            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX1
     C                   PARM                    MESLEN
     C*
     C* Override SECRTTTPPD to QTEMP/SECRTTTPPD
     C*
     C                   Z-ADD     78            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX2
     C                   PARM                    MESLEN
     C*
     C* Override DPTMVDL1 to DPTMVDL1 SHARE(*NO)
     C*
     C                   Z-ADD     68            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX3
     C                   PARM                    MESLEN
     C*
     C* Override DPTMVDY1 to DPTMVDY1 SHARE(*NO)
     C*
     C                   Z-ADD     68            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX4
     C                   PARM                    MESLEN
     C*
     C* Override DPTMVDY2 to DPTMVDY2 SHARE(*NO)
     C*
     C                   Z-ADD     68            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX5
     C                   PARM                    MESLEN
     C*
     C* Override SEDMRPX1 to SEDMRPX1 SHARE(*NO)
     C*
     C                   Z-ADD     68            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX6
     C                   PARM                    MESLEN
     C*
     C* Override SEDMRPX2 to SEDMRPX2 SHARE(*NO)
     C*
     C                   Z-ADD     68            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX7
     C                   PARM                    MESLEN
     C*
     C* Override SECRTNL1 to SECRTNL1 SHARE(*NO)
     C*
     C                   Z-ADD     71            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX8
     C                   PARM                    MESLEN
     C*
     C* Override SECRTTL1 to SECRTTL1 SHARE(*NO)
     C*
     C                   Z-ADD     71            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX9
     C                   PARM                    MESLEN
     C
     C     @RTCD         IFEQ      *BLANK
     C                   CALLB     'MMRPDLUPD'
     C                   PARM                    @RTCD
     C                   PARM                    NwDlFilFmt
     C                   PARM                    DPTXX                                        CAP087
     C                   PARM      'N'           DepotPos                                     CAP087
     C                   END
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
     C                   COMMIT
     C/COPY WNCPYSRC,MMREPOSC04
      ** Call MMCREPOCMT to Commit changes for all activation groups.
      ** Otherwise record lock remains on MEMOS file and further update
      ** will cause database error.
      *
     C                   CALL      'MMCREPOCMT'
     C                   END
      *
     C** If update not done due to record being updated by another
     C** workstation send message to screen.
     C
     C     @RTCD         IFEQ      '*RECUPD'
     C
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1067'     MsgIdArr(1)
     C
     C                   ELSE
     C*
     C* CREATE TEMPORARY FILES FOR CERTIFICATES PROCESSING
     C*
     C                   Z-ADD     78            MESLEN
     C                   CALL      'QCMDEXC'                            9999
     C                   PARM                    ##CN2
     C                   PARM                    MESLEN
 
     C                   Z-ADD     78            MESLEN
     C                   CALL      'QCMDEXC'                            9999
     C                   PARM                    ##CT2
     C                   PARM                    MESLEN
 
     C                   END
     C
      * BLANK THE MAIN DETAILS SCREEN
      *
     C                   MOVEL     *BLANK        NwDlScnFmt
     C                   MOVEL     *BLANK        DDSTS
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
     C                   MOVEL     'MMREPOSIN'   DBPGM
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
     C*
     C* CREATE TEMPORARY DEPOT MOVEMENTS FOR REPOS FILE
     C*
     C                   Z-ADD     58            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##CM
     C                   PARM                    MESLEN
     C*
     C* Clear temporary depot movements file
     C*
     C                   Z-ADD     21            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##CF
     C                   PARM                    MESLEN
     C*
     C* CREATE TEMPORARY FILES FOR CERTIFICATES PROCESSING
     C*
     C                   Z-ADD     81            MESLEN
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##CN1
     C                   PARM                    MESLEN
 
     C                   Z-ADD     81            MESLEN
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##CT1
     C                   PARM                    MESLEN
     C*
      *
      * Start on Main Details Screen
      *
     C                   MOVEL     'M'           @SCRN             1
      *
      * Initialize field and function key status on main details screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
 
      *  Hook to enable non-core initial processing to be included
      *CO*Y*WNCPYSRC*MMLDNIS010**********************                                         177547
      /COPY WNCPYSRC,MMREPOS010                                                               177547
     C
 
     C                   ENDSR
      *****************************************************************
      /EJECT
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
** ##CM
CPYF FROMFILE(DPTMVD) TOFILE(QTEMP/SEDMRPXX) CRTFILE(*YES)
** ##CF
CLRPFM QTEMP/SEDMRPXX
** ##OX1
OVRDBF FILE(SECRTNTPPD) TOFILE(QTEMP/SECRTNTPPD) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX2
OVRDBF FILE(SECRTTTPPD) TOFILE(QTEMP/SECRTTTPPD) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX3
OVRDBF FILE(DPTMVDL1) TOFILE(DPTMVDL1) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX4
OVRDBF FILE(DPTMVDY1) TOFILE(DPTMVDY1) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX5
OVRDBF FILE(DPTMVDY2) TOFILE(DPTMVDY2) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX6
OVRDBF FILE(SEDMRPX1) TOFILE(SEDMRPX1) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX7
OVRDBF FILE(SEDMRPX2) TOFILE(SEDMRPX2) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX8
OVRDBF FILE(SECRTNL1) TOFILE(SECRTNL1) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX9
OVRDBF FILE(SECRTTL1) TOFILE(SECRTTL1) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##CN1
CPYF FROMFILE(SECRTNTPPD) TOFILE(QTEMP/SECRTNTPPD) CRTFILE(*YES) MBROPT(*REPLACE)
** ##CT1
CPYF FROMFILE(SECRTTTPPD) TOFILE(QTEMP/SECRTTTPPD) CRTFILE(*YES) MBROPT(*REPLACE)
** ##CN2
CPYF FROMFILE(SECRTNPD) TOFILE(QTEMP/SECRTNTPPD) CRTFILE(*NO) MBROPT(*REPLACE)
** ##CT2
CPYF FROMFILE(SECRTTPD) TOFILE(QTEMP/SECRTTTPPD) CRTFILE(*NO) MBROPT(*REPLACE)
