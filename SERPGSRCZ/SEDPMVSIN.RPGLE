     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE DPMV screen input controller')                *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEDPMVSIN - SE Depot Movement Screen Input.                  *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for Depot Movement Transaction.                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR551823           Date 18Jun10               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 246166             Date 07Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CAP087             Date 24Aug05               *
      *                 CSE075             Date 17Nov05               *
      *                 FIX002             Date 28Nov05               *
      *                 234691             Date 05Jul05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE071             Date 19Jul05               *
      *                 CSC022             Date 24Feb04               *
      *                 225965  (BUG1569)  Date 23Mar04               *
      *                 222373             Date 22Oct03               *
      *                 222727             Date 05Nov03               *
      *                 CAS006             Date 21Jan03               *
      *                 CSE039             Date 21Jan03               *
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 209867             Date 10Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209934             Date 07Nov02               *
      *                 209009             Date 03Sep02               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 207006             Date 18Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 201232             Date 20Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE028             Date 06Jun01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      *                 174742             Date 17Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 167486             Date 07Apr00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE015             Date 06Dec99               *
      *                 CSE017             Date 20Oct99               *
      *                 CSE012             Date 16Aug99               *
      *                 CPB001             Date 20Aug99               *
      *                 167221             Date 08Sep99               *
      *                 165402             DATE 04Aug99               *
      *                 CGL011             Date 20Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP006             DATE 17Mar99               *
      *                 CAP004             Date 07Sep98               *
      *                 CAP003  *CREATE    Date 14May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR551823 - DELETE indicator is still appears after inquire   *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  246166 - To complete fix 244007. Add repo indicator from     *
      *           repurchased agreement input.                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP087 - Depot Movement - Java Wrapper in Midasplus.         *
      *           New parameter DDDPSS added to call to               *
      *           SEDPMVRTV. Also due to new fields added to          *
      *           SEDMWIPD and SEEDMWIPD.                             *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  FIX002 - Immediately pressing enter will protect the screen. *
      *  234691 - Fixes EU Taxes                                      *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  225965 - Two user can update the same record at the same     *
      *           time.                                               *
      *  222373 - Parameter Mismatch                                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE039 - Auto-settle of trades.                              *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  209867 - No rollback when F3 pressed. Msg ENDCMTCTL not      *
      *           allowed at signoff due to updates in window pgm.    *
      *  209934 - Beneficial Customer should be passed to SE1807      *
      *           if Counterparty is blank                            *
      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
      *           FXCPYSRC.                                           *
      *  207006 - Add Counterparty & Market Centre to SSI             *
      *  201232 - Amendment of Walk In/ Walk Out needs to be done     *
      *           twice.                                              *
      *  CSE028 - Standing Settlement Instructions Enhancement.       *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  174742 - Walk in transactions showing on Walk out screen with*
      *         - Walk out transactions showing on Walk in screen     *
      *  CSE023 - Treaty Withholding Tax (Recompiled over SECTYD)     *
      *  167486 - Call SE1807 to access extension file allowing input *
      *           of the fields needed to produce SWIFT Messages.     *
      *  CSE015 - Forward Valued Depot Movements (Recompiled)         *
      *  CSE017 - Cum/Ex Indicator on Depot Movements (Recompiled)    *
      *  CSE012 - SE Depot Movement Narratives                        *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *         - 'Private Banking' Module                            *
      *  167221 - Duplicate depot movements as wrong reference assignd*
      *  165402 - Fields on deals are being corrupted on amendment    *
      *  CGL011 - Collateral Processing for Midas. Recompile.         *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP006 - Check for deal being updated by another workstation *
      *  CAP004 - API's Phase 3.                                      *
      *           Add extra parm for Extar Data                       *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
     FSECTY     IF   E           K DISK    PREFIX(SEC_)                                       167486
     F                                     INFSR(*PSSR)                                       167486
                                                                                              167486
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
 
      ** Include the FX standard declares
     D*/COPY*FXCPYSRC,STDDECLARE***                                                           209009
     D/COPY ZACPYSRC,STDDECLARE                                                               209009
 
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
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      **--------------------------------------------------------------------------------------------
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
     ** Depot Movement Details Data Structures
     ** --------------------------------------
 
     ** Screen Fields
      ** Rename In Depot/Date to be used for both Walk In/Walk Out.
     ** Fields Ok Indicator
     ** Current Transaction In file Format
     ** Transaction file Format
                                                                                              CSC022
     D WCmtJobArr      S             10A   DIM(10)                                            CSC022
      ** Array for commitment job names                                                       CSC022
 
     D NwScrnRec     E DS                  EXTNAME(SEDMWIPD)
     D DDDEPOT       E                     EXTFLD(DDDPID)
     D DDDATE        E                     EXTFLD(DDDPMD)
 
     D OKIndFile     E DS                  EXTNAME(SEEDMWIPD)
 
     D OldDPMVRec    E DS                  EXTNAME(DPTMVD)
     D                                     PREFIX(Old)
 
     D NewDPMVRec    E DS                  EXTNAME(DPTMVD)
 
      ** ICD/SD Data Structures
      ** ----------------------
 
      ** External DS for Bank Details
      ** Midas Modules Details Accessed Via Access Program
      ** Security Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
     D*SECTY*********E DS                  EXTNAME(SECTYD)                                    167486
     D SECTY_DS      E DS                  EXTNAME(SECTYD)                                    167486
     D                                     PREFIX(SEC)
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  167486
     D SCA_LCD       E                     EXTFLD(LCD)                                        167486
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)                                  167486
                                                                                CAP004
     D ExtData       E DS                  EXTNAME(SEDMEXPD)                    CAP004
 
      ** DS for Access Programs, Short DS
     D DSFDY         E DS                  EXTNAME(DSFDY)
                                                                                              167486
      ** DS for Access Programs, Long DS                                                      167486
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     167486
                                                                                              167486
      ** Data structure for RunDate.                                                          167486
     D RUNDAT          DS            13                                                       167486
     D  RunDate                8     10P 0                                                    167486
                                                                                              167486
      ** DS to pass parameters to SE1807 for MT5xxs                                           167486
     D PDATA         E DS                  EXTNAME(SE70DT)                                    167486
     D PPDPSS        E                     EXTFLD(PDPSS)                                      167486
     D PPDPRN        E                     EXTFLD(PDPRN)                                      167486
     D PPTFR         E                     EXTFLD(PTFR)                                       CSE028
     D PMCWL           DS          9999                                                       CSD015
 
     D/COPY QWINDSRC,SEDMSINDTA
 
      ** Current Control Indicators for Main Detail screen
     D @CCI@M          DS
     D  @EKYFD                 1      1
     D  @EDTFD                 2      2
     D  @EINKG                 3      3
     D  @EINKH                 4      4
     D  @EINKJ                 5      5
     D  @EINKN                 6      6
     D  @EINKP                 7      7
 
      ** Previous Control Indicators for Main Detail screen
     D @PCI@M          DS             7
 
     D WDPRN           S              6S 0
                                                                                              CSC022
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
     D  ComitJob               4    103                                                       CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *                                                                                       201232
      ** Work array for warning message Ids                                                   201232
     D WPrvWarnAr      S                   Dim(ArrayMax)                                      201232
     D                                     Like(WMsgIDArr)                                    201232
     D WReDisplay      S              1A                                                      201232
     D WiX             S              3P 0                                                    201232
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
                                                                                              CGL031
      ** CGL031                                                                               CGL031
     D CGL031          S              1A                                                      CGL031
                                                                                              CSC022
     D CSC022          S              1A                                                      CSC022
                                                                                              CSC022
     D WCommitSkip     S              1A                                                      CSC022
      ** Commitment Skip Field                                                                CSC022
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SEDPMVS007
 
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
      /COPY WNCPYSRC,SEDPMVS001
      *
      ** Read Next Browse Subfile Record
      *
     C     WScrnMode     IFEQ      'R'
     C                   EXSR      SRRdBrwRec
     C                   END
      *
      /COPY WNCPYSRC,SEDPMVS002
      *
      ** Do While Screen: Main Details
      *
     C     WScrnMode     DOWEQ     'M'
     C                   EXSR      SRMainScrn
     C                   END
      *                                                                                       CSE012
      ** Do While Screen: Main Details                                                        CSE012
      *                                                                                       CSE012
     C     WScrnMode     DOWEQ     'S'                                                        CSE012
     C                   EXSR      SRSecScrn                                                  CSE012
     C                   END                                                                  CSE012
      *
      /COPY WNCPYSRC,SEDPMVS003
      *
      ** Screen: Window
      *
     C     WScrnMode     IFEQ      'W'
     C                   EXSR      SRWindow
     C                   END
      *
      /COPY WNCPYSRC,SEDPMVS004
      *
      ** Confirmation
      *
     C     WScrnMode     DOWEQ     'C'
     C                   EXSR      SRConfScrn
     C                   END
      *
      /COPY WNCPYSRC,SEDPMVS005
      *
      ** Update
      *
     C     WScrnMode     DOWEQ     'U'
     C                   EXSR      SRUpdate
     C                   END
      *                                                                                       167486
      ** Screen: Extension (Swift) Details                                                    167486
      *                                                                                       167486
     C     WScrnMode     IFEQ      'E'                                                        167486
     C                   EXSR      SRExtDet                                                   167486
     C                   END                                                                  167486
      *
      /COPY WNCPYSRC,SEDPMVS006
      *
      ** Terminate Program
      *
     C     WScrnMode     IFEQ      'T'
     C                   MOVE      '1'           *INLR
     C                   END
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SEDPMVS008
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMainScrn - Process Screen: Main Details                     *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls:  SRWIScrn                                              *
      *         SRWOScrn                                              *
      *         SRRoll                                                *
      *         SRValEntry                                            *
      *         SRCancel                                              *
      *         SREnd                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRMainScrn    BEGSR
 
     C                   IF        BGWDPR = 'Y'
 
     C     @CCI@M        IFNE      @PCI@M
     C     DDACTN        ORNE      @PACTN                                       165402
     C     DDDPRN        ORNE      WPrevDPRN
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        (WCommitSkip <> 'Y')                                       CSC022
     C                   ROLBK                                                                CSC022
     C                   Else                                                                 CSC022
     C                   Seton                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   END
 
     C                   END
      *
      ** Update 'previous' Reference Number and Security Shortname
      ** Screen Control
      *
     C                   MOVEL     DDDPRN        WPrevDPRN         6
     C                   MOVEL     PortCusInd    WPrevCInd         1
     C                   MOVEL     PBCusInd      WPvPBInd          1            CPB001
     C                   MOVEL     DDACTN        @PACTN            1            165402
     C                   MOVEL     @CCI@M        @PCI@M
      *
      ** Write/Read Display Screen
      *
      * If this module has been called from elsewhere then do not call                        CSE039
      * relevenat WI/WO display module on the first time through.                             CSE039
     C     CallProg      IfNe      *BLANKS                                                    CSE039
     C     FirstCall     AndEq     'Y'                                                        CSE039
     C                   Move      'E'           DDACTN                                       CSE039
     C                   Move      DPMVSety      DDDPSS                                       CSE039
     C                   Move      DPMVTrno      DDDPRN                                       CSE039
     C                   Move      'N'           FirstCall                                    CSE039
     C                   Else                                                                 CSE039
     C     DPMVType      CASEQ     'WI'          SRWIScrn
     C     DPMVType      CASEQ     'WO'          SRWOScrn
     C                   ENDCS
     C                   EndIf                                                                CSE039
      *                                                                                       201232
      ** Save warning message ids array of this screen.                                       201232
      *                                                                                       201232
     C                   MOVEA     WMsgIDArr     WPrvWarnAr                                   201232
      *
      ** Reset Errors
      *
     C                   MOVE      *ALL'Y'       OKIndFile
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
     C     CallProg      IfNe      *BLANKS                                                    CSE039
     C     @INKC         IfEq      '1'                                                        CSE039
     C                   Move      'Y2U9999'     DPMVRtrn                                     CSE039
     C                   Move      '1'           *INLR                                        CSE039
     C                   Return                                                               CSE039
     C                   Else                                                                 CSE039
     C     @INKL         IfEq      '1'                                                        CSE039
     C                   Move      'USR0790'     DPMVRtrn                                     CSE039
     C                   Move      '1'           *INLR                                        CSE039
     C                   Return                                                               CSE039
     C                   EndIf                                                                CSE039
     C                   EndIf                                                                CSE039
     C                   EndIf                                                                CSE039
      *                                                                                       CSE039
     C     @INKP         CASEQ     '1'           SRBrowse
     C     @INKG         CASEQ     '1'           SRRoll
     C     @INKH         CASEQ     '1'           SRRoll
     C     @INKC         CASEQ     '1'           SREnd
     C     @INKL         CASEQ     '1'           SRCancel
     C     @INKW         CASEQ     '1'           DSPMOV                                       CSE039
     C                   CAS                     SRValEntry
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CSE012
      *****************************************************************                       CSE012
      *                                                               *                       CSE012
      * SRSecScrn - Second Screen Processing                          *                       CSE012
      *                                                               *                       CSE012
      * Called by: Main                                               *                       CSE012
      *                                                               *                       CSE012
      * Calls:  None                                                  *                       CSE012
      *                                                               *                       CSE012
      *****************************************************************                       CSE012
                                                                                              CSE012
     C     SRSecScrn     BEGSR                                                                CSE012
      *                                                                                       CSE012
      ** If window processing is on                                                           CSE012
      *                                                                                       CSE012
     C     BGWDPR        IFEQ      'Y'                                                        CSE012
      *                                                                                       CSE012
      ** If the Current Control Indicators are different to the Previous                      CSE012
      ** Control Indicators or the Reference Number is different to the                       CSE012
      ** Previous Reference Number, Rollback changes                                          CSE012
      *                                                                                       CSE012
     C     @CCI@M        IFNE      @PCI@M                                                     CSE012
     C     DDDPRN        ORNE      WPrevDPRN                                                  CSE012
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                   ROLBK                                                                CSE012
     C                   Else                                                                 CSC022
     C                   If        (WCommitSkip <> 'Y')                                       CSC022
     C                   ROLBK                                                                CSC022
     C                   Else                                                                 CSC022
     C                   Seton                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   ENDIF                                                                CSE012
     C                   ENDIF                                                                CSE012
      *                                                                                       CSE012
     C                   MOVEL     @CCI@M        @PCI@M                                       CSE012
     C                   MOVEL     DDDPRN        WPrevDPRN                                    CSE012
      *                                                                                       CSE012
      ** Call SEDPMV2DP                                                                       CSE012
      *                                                                                       CSE012
     C                   CALLB     'SEDPMV2DP'                                                CSE012
      *                                                                                       CSE012
      ** Return Code                                                                          CSE012
      ** Action Code                                                                          CSE012
      ** Security Shortname                                                                   CSE012
      ** Reference                                                                            CSE012
      ** Narrative 2                                                                          CSE012
      ** Narrative 3                                                                          CSE012
      ** Narrative 4                                                                          CSE012
      ** Narrative 5                                                                          CSE012
      *                                                                                       CSE012
     C                   PARM                    RetrnCod          6                          CSE012
     C                   PARM                    DDACTN            1                          CSE012
     C                   PARM                    DDDPSS           10                          CSE012
     C                   PARM                    DDDPRN            6                          CSE012
     C                   PARM                    DDDPNR2                                      CSE012
     C                   PARM                    DDDPNR3                                      CSE012
     C                   PARM                    DDDPNR4                                      CSE012
     C                   PARM                    DDDPNR5                                      CSE012
      *                                                                                       CSE012
      ** Errors                                                                               CSE012
      *                                                                                       CSE012
     C                   PARM                    FldNameArr                                   CSE012
     C                   PARM                    MsgIdArr                                     CSE012
     C                   PARM                    MsgDtaArr                                    CSE012
      *                                                                                       CSE012
      ** Warnings                                                                             CSE012
      *                                                                                       CSE012
     C                   PARM                    WFldNamArr                                   CSE012
     C                   PARM                    WMsgIdArr                                    CSE012
     C                   PARM                    WMsgDtaArr                                   CSE012
      *                                                                                       CSE012
      ** Enabled Key & Detail Fields                                                          CSE012
      *                                                                                       CSE012
     C                   PARM                    @EKYFD            1                          CSE012
     C                   PARM                    @EDTFD            1                          CSE012
      *                                                                                       CSE012
      ** Enabled Function Keys                                                                CSE012
      ** KG = Command Key 07 = Read Previous                                                  CSE012
      ** KH = Command Key 08 = Read Next                                                      CSE012
      ** KH = Command Key 10 = Delete                                                         CSE012
      ** KN = Command Key 14 = Settlement Details                                             CSE012
      ** KP = Command Key 15 = Browse                                                         CSE012
      *                                                                                       CSE012
     C                   PARM                    @EINKG            1                          CSE012
     C                   PARM                    @EINKH            1                          CSE012
     C                   PARM      'N'           @EINKJ            1                          CSE012
     C                   PARM      'N'           @EINKN            1                          CSE012
     C                   PARM                    @EINKP            1                          CSE012
      *                                                                                       CSE012
      ** Output Parameters                                                                    CSE012
      ** Function Keys                                                                        CSE012
      *                                                                                       CSE012
     C                   PARM                    @INKC                                        CSE012
     C                   PARM                    @INKG                                        CSE012
     C                   PARM                    @INKH                                        CSE012
     C                   PARM                    @INKL                                        CSE012
     C                   PARM                    @INKN                                        CSE012
     C                   PARM                    @INKP                                        CSE012
     C                   PARM      'N'           WriteOnly                                    CSE012
      *                                                                                       201232
      ** Save warning message ids array of this screen.                                       201232
      *                                                                                       201232
     C                   MOVEA     WMsgIDArr     WPrvWarnAr                                   201232
      *                                                                                       CSE012
      ** Reset error indicators                                                               CSE012
      *                                                                                       CSE012
     C                   Move      *Blanks       FldNameArr                                   CSE012
     C                   Move      *Blanks       MsgIdArr                                     CSE012
     C                   Move      *Blanks       MsgDtaArr                                    CSE012
      *                                                                                       CSE012
     C     @INKP         CASEQ     '1'           SRBrowse                                     CSE012
     C     @INKG         CASEQ     '1'           SRRoll                                       CSE012
     C     @INKH         CASEQ     '1'           SRRoll                                       CSE012
     C     @INKC         CASEQ     '1'           SREnd                                        CSE012
     C     @INKL         CASEQ     '1'           SRCanc                                       CSE012
     C                   CAS                     SRValSEntry                                  CSE012
     C                   ENDCS                                                                CSE012
      *                                                                                       CSE012
     C                   ENDSR                                                                CSE012
      *****************************************************************                       CSE012
      /EJECT                                                                                  CSE012
      *****************************************************************                       CSE012
      *                                                               *                       CSE012
      * SRValSEntry - Validate Second Screen Entry                    *                       CSE012
      *                                                               *                       CSE012
      * Called by: SRSecScrn                                          *                       CSE012
      *                                                               *                       CSE012
      * Calls:  None                                                  *                       CSE012
      *                                                               *                       CSE012
      *****************************************************************                       CSE012
      *                                                                                       CSE012
     C     SRValSEntry   BEGSR                                                                CSE012
      *                                                                                       CSE012
      ** Set field and function key status on main details screen                             CSE012
      ** (according to action code)                                                           CSE012
      *                                                                                       CSE012
     C                   EXSR      SRSetFldS                                                  CSE012
     C                   EXSR      SRSetFkyS                                                  CSE012
      *                                                                                       CSE012
      ** If Action code is 'E'                                                                CSE012
      *                                                                                       CSE012
     C     DDACTN        IFEQ      'E'                                                        CSE012
     C     @CCI@M        ANDEQ     @PCI@M                                                     CSE012
     C/COPY WNCPYSRC,SEDPMVSC01
      *                                                                                       CSE012
     C                   SELECT                                                               CSE012
     C                   WHEN      S01401 = 'Y'                                               201232
     C                   MOVE      'E'           WScrnMode                                    201232
                                                                                              201232
     C                   WHEN      BGWDPR = 'Y'                                               CSE012
     C                   MOVE      'W'           WScrnMode                                    CSE012
      *                                                                                       CSE012
     C                   WHEN      WRdNxBwRec = 'Y'                                           CSE012
     C                   MOVE      'R'           WScrnMode                                    CSE012
      *                                                                                       CSE012
     C                   ENDSL                                                                CSE012
      *                                                                                       CSE012
     C                   ENDIF                                                                CSE012
      *                                                                                       CSE012
      ** If Action Code is Insert or Amend                                                    CSE012
      *                                                                                       CSE012
     C     DDACTN        IFEQ      'I'                                                        CSE012
     C     DDACTN        OREQ      'A'                                                        CSE012
      *                                                                                       CSE012
      ** Reset Error Indicators                                                               CSE012
      *                                                                                       CSE012
     C                   Z-ADD     *Zeros        Idx                                          CSE012
     C                   Z-ADD     *Zeros        WIdx                                         CSE012
      *                                                                                       CSE012
     C                   CALLB     'SEDPMV2VL'                                                CSE012
     C                   PARM                    RetrnCod          6                          CSE012
     C                   PARM                    DDDPNR2          35                          CSE012
     C                   PARM                    DDDPNR3          35                          CSE012
     C                   PARM                    DDDPNR4          35                          CSE012
     C                   PARM                    DDDPNR5          35                          CSE012
     C                   PARM                    NewDPMVRec                                   CSE012
     C                   PARM                    FldNameArr                                   CSE012
     C                   PARM                    MsgIDArr                                     CSE012
     C                   PARM                    MsgDtaArr                                    CSE012
     C                   PARM                    WFldNamArr                                   CSE012
     C                   PARM                    WMsgIDArr                                    CSE012
     C                   PARM                    WMsgDtaArr                                   CSE012
     C                   PARM                    Idx                                          CSE012
     C                   PARM                    WIdx                                         CSE012
      *                                                                                       201232
     C                   EVAL      WReDisplay = *BLANK                                        201232
      *                                                                                       201232
      ** If no errors occurred during validation of key fields, check                         201232
      ** if there are warnings which have not been displayed yet.                             201232
      *                                                                                       201232
     C                   IF        IDx = *ZERO                                                201232
                                                                                              201232
     C                   Z-ADD     1             WiX                                          201232
                                                                                              201232
     C                   DOW       WiX <= WIDx AND WReDisplay = *BLANK                        201232
                                                                                              201232
     C                   IF        WMsgIdArr(WiX) <> WPrvWarnAr(WiX)                          201232
     C                   EVAL      WReDisplay = 'Y'                                           201232
     C                   ELSE                                                                 201232
     C                   EVAL      WiX = WiX + 1                                              201232
     C                   ENDIF                                                                201232
                                                                                              201232
     C                   ENDDO                                                                201232
                                                                                              201232
     C                   ENDIF                                                                201232
      *                                                                                       CSE012
      ** If Errors exist                                                                      CSE012
      *                                                                                       CSE012
     C     Idx           IFNE      *Zeros                                                     CSE012
     C     WReDisplay    OREQ      'Y'                                                        201232
     C                   Move      'S'           WScrnMode                                    CSE012
     C                   ELSE                                                                 CSE012
                                                                                              201232
     C                   IF        S01401 = 'Y'                                               201232
     C                   MOVE      'E'           WScrnMode                                    201232
     C                   GOTO      EndValS                                                    201232
     C                   ENDIF                                                                201232
      *                                                                                       CSE012
     C     BGWDPR        IFEQ      'Y'                                                        CSE012
     C                   Move      'W'           WScrnMode                                    CSE012
     C                   Else                                                                 CSE012
     C                   Move      'C'           WScrnMode                                    CSE012
     C                   Endif                                                                CSE012
     C                   Endif                                                                CSE012
      *                                                                                       CSE012
     C                   ENDIF                                                                CSE012
      *                                                                                       CSE012
     C     EndValS       ENDSR                                                                CSE012
      *****************************************************************                       CSE012
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWIScrn - Calls Walk In Display Screen                       *
      *                                                               *
      * Called by: SRMainScrn                                         *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRWIScrn      BEGSR
 
     C                   MOVEL     @CCI@M        @PCI@M
     C                   MOVEL     DDDPRN        WPrevDPRN
 
     C                   CALLB     'SEDMWIDSP'
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      ** Security                                                                             CSE039
     C                   PARM                    DPMVSety                                     CSE039
      ** Transaction Number                                                                   CSE039
     C                   PARM                    DPMVTrno                                     CSE039
 
     ** Received parameters
     ** -------------------
 
     ** Transaction Details
      * Transaction Status
      * Security Status
      * Transaction screen format
      * Exchange Rate
      * M/D Indicator
      * Portfolio Customer Indicator
      * Private Banking Customer Indicator                                      CPB001
      * Private Banking Field to process indicator                              CPB001
      * Fields in error
     C                   PARM                    DDTranSts         7
     C                   PARM                    DDSecSts          7
     C                   PARM                    NwScrnRec
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
     C                   PARM                    PortCusInd        1
     C                   PARM                    PBCusInd          1            CPB001
     C                   PARM                    PBFieldInd        1            CPB001
     C                   PARM                    OKIndFile
      *
      ** ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      **ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      * ENABLED FUNCTION KEYS
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      * KN = COMMAND KEY 14 = SETTLEMENT DETAILS
      * KP = COMMAND KEY 15 = BROWSE
      * KV = COMMAND KEY 22 = MOVEMENT STATUS                                                 CSE039
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM      'N'           @EINKN            1
     C                   PARM                    @EINKP            1
      *
      ** Succesful Insert Deal
     C                   PARM                    @SIDN             6
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKN             1
     C                   PARM                    @INKP             1
     C                   PARM      '0'           @INKW             1                          CSE039
     C                   PARM      'Y'           @INKWDisp         1                          CSE039
     C                   PARM      'N'           WriteOnly         1
                                                                                              CGL031
      ** CGL031 Switchable Feature                                                            CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWOScrn - Calls Walk Out Display Screen                      *
      *                                                               *
      * Called by: SRMainScrn                                         *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRWOScrn      BEGSR
 
     C                   MOVEL     @CCI@M        @PCI@M
     C                   MOVEL     DDDPRN        WPrevDPRN
 
     C                   CALLB     'SEDMWODSP'
      ** Retrun Code
     C                   PARM                    RetCodeIn
      ** Security                                                                             CSE039
     C                   PARM                    DPMVSety                                     CSE039
      ** Transaction Number                                                                   CSE039
     C                   PARM                    DPMVTrno                                     CSE039
 
     ** Received parameters
     ** -------------------
 
     ** Transaction Details
      * Transaction Status
      * Security Status
      * Transaction Screen Format
      * Exchange Rate
      * M/D Indicator
      * Portfolio customer Indicator
      * Private Banking Customer Indicator                                      CPB001
      * Private Banking Field process Indicator                                 CPB001
      * FIELDS IN ERROR
     C                   PARM                    DDTranSts
     C                   PARM                    DDSecSts
     C                   PARM                    NwScrnRec
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
     C                   PARM                    PortCusInd        1
     C                   PARM                    PBCusInd          1            CPB001
     C                   PARM                    PBFieldInd        1            CPB001
     C                   PARM                    OKIndFile
      *
      ** ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      ** ENABLED FUNCTION KEYS
      ** KG = COMMAND KEY 07 = READ PREVIOUS
      ** KH = COMMAND KEY 08 = READ NEXT
      ** KJ = COMMAND KEY 10 = CONFIRM DELETE
      ** KN = COMMAND KEY 14 = SETTLEMENT DETAILS
      ** KP = COMMAND KEY 15 = BROWSE
      ** KV = COMMAND KEY 22 = MOVEMENT STATUS                                                CSE039
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM      'N'           @EINKN            1
     C                   PARM                    @EINKP            1
      *
      ** Succesful Insert Deal
     C                   PARM                    @SIDN             6
      *
      ** OUTPUT PARAMETERS
      *
      ** FUNCTION KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKN             1
     C                   PARM                    @INKP             1
     C                   PARM      '0'           @INKW             1                          CSE039
     C                   PARM      'Y'           @INKWDisp         1                          CSE039
     C                   PARM      'N'           WriteOnly         1
     C                   PARM                    CGL031                                       CGL031
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBrowse - Browse Function Routine                            *
      *                                                               *
      * Called by: SRMainScrn                                         *
      *                                                               *
      * Calls:  SRend                                                 *
      *         SRMsgMain                                             *
      *                                                               *
      *****************************************************************
     C     SRBrowse      BEGSR
      *
      ** Reset Read Next Browse Subfile Record
      *
     C                   MOVEL     *BLANK        WRdNxBwRec        1
 
     C                   CALLB     'SEDPMVBRW'
 
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM                    DDACTN            1
     C                   PARM      DDDPRN        @DDPRN            6
     C                   PARM      DDDPSS        @DDPSS           10
     C                   PARM                    DPMVType          2
     C                   PARM                    CallProg                                     CSE039
     C                   PARM      'Y'           @BldSfl           1
     C                   PARM      *BLANK        @RdSfl            1
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      *BLANK        @ERRMS            7
     C                   PARM      *BLANK        @OptSel           1
     C                   PARM      *BLANK        @RefSel           6
     C                   PARM      *BLANK        @SecSel          10
      *
      * If called from SE4400 then if F3 or F12 taken, return to                              CSE039
      * SE4400 passing appropriate parameter.                                                 CSE039
     C     CallProg      IfNe      *Blanks                                                    CSE039
      *                                                                                       CSE039
     C     @INKC         IfEq      '1'                                                        CSE039
     C                   Move      'Y2U9999'     DPMVRtrn                                     CSE039
     C                   Move      '1'           *INLR                                        CSE039
     C                   Return                                                               CSE039
     C                   EndIf                                                                CSE039
     C                   EndIf                                                                CSE039
      *                                                                                       CSE039
      * If Called from SE4400 then ensure action remains 'E' depsite                          CSE039
      * what entered on browse screen.                                                        CSE039
     C     CallProg      IfNe      *BLANKS                                                    CSE039
     C                   MOVE      'E'           DDACTN                                       CSE039
     C                   EndIf                                                                CSE039
      ** If F3 taken in browse, end program
      *
     C     @INKC         IFNE      '1'
      *
      ** If error message returned from browse, send it to detail screen
      *
     C     @ERRMS        IFEQ      *BLANK
      *
      ** If CK/12 not taken in browse
      ** Read next browse subfile record
      *
     C     @INKL         IFNE      '1'
     C                   MOVE      'Y'           WRdNxBwRec
     C                   MOVEL     'R'           WScrnMode
     C                   END
 
     C                   ELSE
     C                   EXSR      SRMsgMain
     C                   END
 
     C                   ELSE
     C                   EXSR      SREnd
     C                   END
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdBrwRec - Processed all selected Browse records.           *
      *                                                               *
      * Called by: SRMainScrn                                         *
      *                                                               *
      * Calls:  SRRetrieve                                            *
      *         SRConvert                                             *
      *         SRSEtFldS                                             *
      *         SRSEtFKyS                                             *
      *                                                               *
      *****************************************************************
     C     SRRdBrwRec    BEGSR
 
     C                   CALLB     'SEDPMVBRW'
 
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM                    DDACTN            1
     C                   PARM                    DDDPRN
     C                   PARM                    DDDPSS
     C                   PARM                    DPMVType          2
     C                   PARM                    CallProg                                     CSE039
     C                   PARM      *BLANK        @BldSfl           1
     C                   PARM      'Y'           @RdSfl            1
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      *BLANK        @ERRMS            7
     C                   PARM      *BLANK        @OptSel           1
     C                   PARM      *BLANK        @RefSel           6
     C                   PARM      *BLANK        @SecSel          10
      *
      ** If the transactions , end program
      *
     C     @RefSel       IFNE      *BLANK
      *
      ** Retreive Transaction Details
      *
     C                   MOVE      @SecSel       DDDPSS
     C                   MOVE      @RefSel       DDDPRN
     C                   MOVE      @OptSel       DDACTN
      *
      * If called from SE4400 then if F3 or F12 taken, return to                              CSE039
      * SE4400 passing appropriate parameter.                                                 CSE039
     C     CallProg      IfNe      *Blanks                                                    CSE039
      *                                                                                       CSE039
      *                                                                                       CSE039
     C     @INKC         IfEq      '1'                                                        CSE039
     C                   Move      'Y2U9999'     DPMVRtrn                                     CSE039
     C                   Move      '1'           *INLR                                        CSE039
     C                   Return                                                               CSE039
     C                   EndIf                                                                CSE039
     C                   EndIf                                                                CSE039
      * If Called from SE4400 then ensure action remains 'E' depsite                          CSE039
      * what entered on browse screen.                                                        CSE039
     C     CallProg      IfNe      *BLANKS                                                    CSE039
     C                   MOVE      'E'           DDACTN                                       CSE039
     C                   EndIf                                                                CSE039
      *                                                                                       CSE039
      ** Retreive Deal Details
      *
     C                   EXSR      SRRetrieve
      *
      ** Set Field and Function key status Accordingly
      *
     C                   EXSR      SRSetFldS
     C                   EXSR      SRSetFkyS
      *
      ** Convert file details to screen details.
      *
     C                   EXSR      SRConvert
     C                   ELSE
      *
      ** Reset Read Next Browse Record Indicator
      *
     C                   MOVE      *BLANK        WRdNxBwRec
     C                   END
 
     C                   MOVE      'M'           WScrnMode
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRConfScrn - Confirmation of Input.                           *
      *              Evoked for Inserts and Amend                     *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: SRCanConf                                              *
      *        SRExitConf                                             *
      *        SREnd                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRConfScrn    BEGSR
 
     C                   MOVE      *ALL'Y'       OKIndFile
      *
      ** Reset Warning Messages
      *
     C                   Z-ADD     0             WIdx
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ** Call Validation Routine for Secondary Checking.
      *
     C**********         CALLB     'SEDPMVVAL'                                                201232
 
     C**********         PARM                    NwScrnRec                                    201232
     C**********         PARM                    ExtData                               CAP004 201232
     C*******************PARM                    SECTY                                        167486
     C**********         PARM                    SECTY_DS                              167486 201232
     C**********         PARM                    DPMVType          2                          201232
     C**********         PARM                    RespMode                                     201232
     C**********         PARM                    DDSPXR           14                          201232
     C**********         PARM                    DDSPMD            1                          201232
     C**********         PARM                    PortCusInd                                   201232
     C**********         PARM                    PBCusInd                              CPB001 201232
     C**********         PARM                    PBFieldInd                            CPB001 201232
     C**********         PARM                    NewDPMVRec                                   201232
     C**********         PARM                    OKIndFile                                    201232
     C**********         PARM                    FldNameArr                                   201232
     C**********         PARM                    MsgIDArr                                     201232
     C**********         PARM                    MsgDtaArr                                    201232
     C**********         PARM                    WFldNamArr                                   201232
     C**********         PARM                    WMsgIDArr                                    201232
     C**********         PARM                    WMsgDtaArr                                   201232
     C**********         PARM                    Idx                                          201232
     C**********         PARM                    WIdx                                         201232
      *
      ** Check Error Index
      *
     C*****Idx**         IFEQ      *ZERO                                                      201232
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = '*ANY'
     C                   EVAL      WMsgIDArr (WIdx) = 'MMM1030'
     C**********         END                                                                  201232
      *                                                                                       CSE012
      ***If*CSE012 is installed, Validate  second screen                               CSE012 201232
      *                                                                                       CSE012
     C*****CSE012        IFEQ      'Y'                                                        CSE012
      *                                                                                       CSE012
     C**********         CALLB     'SEDPMV2VL'                                         CSE012 201232
      *                                                                                       CSE012
      ***Input*Parameters                                                              CSE012 201232
      ***Return*Code                                                                   CSE012 201232
      ***Narrative 2                                                                   CSE012 201232
      ***Narrative 3                                                                   CSE012 201232
      ***Narrative 4                                                                   CSE012 201232
      ***Narrative 5                                                                   CSE012 201232
      ***New Screen Record                                                             CSE012 201232
      *                                                                                       CSE012
     C**********         PARM                    RetrnCod          6                   CSE012 201232
     C**********         PARM                    DDDPNR2          35                   CSE012 201232
     C**********         PARM                    DDDPNR3          35                   CSE012 201232
     C**********         PARM                    DDDPNR4          35                   CSE012 201232
     C**********         PARM                    DDDPNR5          35                   CSE012 201232
     C**********         PARM                    NewDPMVRec                            CSE012 201232
      *                                                                                       CSE012
      ***Output*Parameters                                                             CSE012 201232
      ***Error*fields/message IDs/message data (arrays) from/to caller                 CSE012 201232
      *                                                                                       CSE012
     C**********         PARM                    FldNameArr                            CSE012 201232
     C**********         PARM                    MsgIDArr                              CSE012 201232
     C**********         PARM                    MsgDtaArr                             CSE012 201232
      *                                                                                       CSE012
      ***Warning fields/message IDs/message data (arrays) from/to caller               CSE012 201232
      *                                                                                       CSE012
     C**********         PARM                    WFldNamArr                            CSE012 201232
     C**********         PARM                    WMsgIDArr                             CSE012 201232
     C**********         PARM                    WMsgDtaArr                            CSE012 201232
      *                                                                                       CSE012
      ***Array*index (3P0) from/to caller                                              CSE012 201232
      ***Array*index (3P0) from/to caller                                              CSE012 201232
      *                                                                                       CSE012
     C**********         PARM                    Idx                                   CSE012 201232
     C**********         PARM                    WIdx                                  CSE012 201232
     C**********         Endif                                                         CSE012 201232
      *                                                                                       CSE012
     C*****CSE012        IFEQ      'Y'                                                 CSE012 201232
     C**********         CALLB     'SEDPMV2DP'                                         CSE012 201232
     C**********         PARM                    RetrnCod          6                   CSE012 201232
     C**********         PARM                    DDACTN            1                   CSE012 201232
     C**********         PARM                    DDDPSS           10                   CSE012 201232
     C**********         PARM                    DDDPRN            6                   CSE012 201232
     C**********         PARM                    DDDPNR2                               CSE012 201232
     C**********         PARM                    DDDPNR3                               CSE012 201232
     C**********         PARM                    DDDPNR4                               CSE012 201232
     C**********         PARM                    DDDPNR5                               CSE012 201232
     C**********         PARM                    FldNameArr                            CSE012 201232
     C**********         PARM                    MsgIdArr                              CSE012 201232
     C**********         PARM                    MsgDtaArr                             CSE012 201232
     C**********         PARM                    WFldNamArr                            CSE012 201232
     C**********         PARM                    WMsgIdArr                             CSE012 201232
     C**********         PARM                    WMsgDtaArr                            CSE012 201232
     C**********         PARM      'N'           @EKYFD            1                   CSE012 201232
     C**********         PARM      'N'           @EDTFD            1                   CSE012 201232
     C**********         PARM      'N'           @EINKG            1                   CSE012 201232
     C**********         PARM      'N'           @EINKH            1                   CSE012 201232
     C**********         PARM      'N'           @EINKJ            1                   CSE012 201232
     C**********         PARM      'N'           @EINKN            1                   CSE012 201232
     C**********         PARM      'N'           @EINKP            1                   CSE012 201232
     C**********         PARM      '0'           @INKC                                 CSE012 201232
     C**********         PARM      '0'           @INKG                                 CSE012 201232
     C**********         PARM      '0'           @INKH                                 CSE012 201232
     C**********         PARM      '0'           @INKL                                 CSE012 201232
     C**********         PARM      '0'           @INKN                                 CSE012 201232
     C**********         PARM      '0'           @INKP                                 CSE012 201232
     C**********         PARM      'N'           WriteOnly                             CSE012 201232
     C**********         ELSE                                                          CSE012 201232
      *
      ** Re-Display Details
      *
     C     DPMVType      IFEQ      'WI'
 
     C                   CALLB     'SEDMWIDSP'
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM                    DPMVSety                                     CSE039
     C                   PARM                    DPMVTrno                                     CSE039
     C                   PARM                    DDTranSts         7
     C                   PARM                    DDSecSts          7
     C                   PARM                    NwScrnRec
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
     C                   PARM                    PortCusInd        1
     C                   PARM                    PBCusInd          1            CPB001
     C                   PARM                    PBFieldInd        1            CPB001
     C                   PARM                    OKIndFile
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      'N'           @EKYFD            1
     C                   PARM      'N'           @EDTFD            1
     C                   PARM      'N'           @EINKG            1
     C                   PARM      'N'           @EINKH            1
     C                   PARM      'N'           @EINKJ            1
     C                   PARM      'N'           @EINKN            1
     C                   PARM      'N'           @EINKP            1
     C                   PARM                    @SIDN             6
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKW             1                          CSE039
     C                   PARM      'Y'           @INKWDisp         1                          CSE039
     C                   PARM      'N'           WriteOnly         1
     C                   PARM                    CGL031                                       CGL031
     C                   END
 
     C     DPMVType      IFEQ      'WO'
     C                   CALLB     'SEDMWODSP'
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM                    DPMVSety                                     CSE039
     C                   PARM                    DPMVTrno                                     CSE039
     C                   PARM                    DDTranSts
     C                   PARM                    DDSecSts
     C                   PARM                    NwScrnRec
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
     C                   PARM                    PortCusInd        1
     C                   PARM                    PBCusInd          1            CPB001
     C                   PARM                    PBFieldInd        1            CPB001
     C                   PARM                    OKIndFile
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      'N'           @EKYFD            1
     C                   PARM      'N'           @EDTFD            1
     C                   PARM      'N'           @EINKG            1
     C                   PARM      'N'           @EINKH            1
     C                   PARM      'N'           @EINKJ            1
     C                   PARM      'N'           @EINKN            1
     C                   PARM      'N'           @EINKP            1
     C                   PARM                    @SIDN             6
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKW             1                          CSE039
     C                   PARM      'Y'           @INKWDisp         1                          CSE039
     C                   PARM      'N'           WriteOnly         1
     C                   PARM                    CGL031                                       CGL031
     C                   END
      *                                                                                       CSE012
     C**********         ENDIF                                                         CSE012 201232
      *
      ** Reset Errors
      *
     C                   MOVE      *ALL'Y'       OKIndFile
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ** If F3, end program
      ** If F12, Cancel confirmation screen
      ** Exit confirmation screen
      *
     C     @INKC         CASEQ     '1'           SREnd
     C     @INKL         CASEQ     '1'           SRCanConf
     C                   CAS                     SRExitConf
     C                   ENDCS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdate - Database Update routine                            *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: SRRsetFldS                                             *
      *        SRRsetFkyS                                             *
      *                                                               *
      *****************************************************************
 
     C     SRUpdate      BEGSR
      *
      ** Setup the change type
      *
     C                   SELECT
 
     C                   WHEN      DDACTN = 'I'
     C                   EVAL      CHTP = 'I'
 
     C                   WHEN      DDACTN = 'D'
     C                   EVAL      CHTP = 'D'
 
     C                   WHEN      DDACTN = 'A'
     C                   EVAL      CHTP = 'A'
 
     C/COPY WNCPYSRC,SEDPMVSC02
     C                   ENDSL
 
     C                   IF        DDDPRN = *BLANKS
     C                             AND DDACTN = 'I'
 
     C                   IF        WDPRN = *ZERO
     C                   EXSR      SRGenRefNo
     C                   END
 
     C                   MOVE      WDPRN         DDDPRN
     C                   MOVE      DDDPRN        DPRN
     C                   MOVE      DPRN          @SIDN
     C                   END
 
     C                   CALLB     'SEDPMVUPD'
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM                    NewDPMVRec
     C                   PARM                    PMCWL                                        CSD015
     C                   PARM                    DSNOTM                                       CSE039
     C                   PARM                    DSMSGK                                       CSE039
     C                   PARM                    CGL031                                       CGL031
 
     C     RetCodeIn     IFNE      *BLANK
     C     RetCodeIn     ANDNE     '*RECUPD'                                    CAP006
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   ROLBK
     C                   EndIf                                                                CSC022
     C                   EXSR      *PSSR
 
     C                   ELSE
      *
      ** Clear screen fields/status.
      *
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   CLEAR                   NwScrnRec
     C                   MOVEL     *BLANK        DDSPXR
     C                   MOVEL     *BLANK        DDSPMD
     C                   MOVEL     ' '           PortCusInd
     C                   MOVEL     ' '           PBCusInd                       CPB001
     C                   MOVEL     ' '           PBFieldInd                     CPB001
     C                   Z-ADD     *ZERO         WDPRN
      *
      ** Initialise field status and function keys status
      *
     C                   EXSR      SRRsetFldS
     C                   EXSR      SRRsetFkyS
 
     C     WRdNxBwRec    IFEQ      'Y'
     C                   MOVE      'R'           WScrnMode
     C                   ELSE
     C                   MOVE      'M'           WScrnMode
     C                   END
     C/COPY WNCPYSRC,SEDPMVSC03
 
     C                   END
 
     C** If update not done due to record being updated by another              CAP006
     C** workstation send message to screen.                                    CAP006
     C                                                                          CAP006
     C     RetCodeIn     IFEQ      '*RECUPD'                                    CAP006
     C                                                                          CAP006
     C                   MOVEL     '*ANY'        FldNameArr(1)                  CAP006
     C                   MOVEL     'MMM1067'     MsgIdArr(1)                    CAP006
     C                                                                          CAP006
     C                   END                                                    CAP006
     C                                                                          CAP006
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************                       167486
      *                                                               *                       167486
      * SRExtDet - Extension Details Routine                          *                       167486
      *                                                               *                       167486
      * Called by: Main                                               *                       167486
      *                                                               *                       167486
      * Calls:  None                                                  *                       167486
      *                                                               *                       167486
      *****************************************************************                       167486
                                                                                              167486
     C     SRExtDet      BEGSR                                                                167486
      *                                                                                       201232
      ** Set up depo reference if not yet entered.                                            201232
      *                                                                                       201232
     C                   IF        DDDPRN = *BLANKS                                           201232
     C                             AND DDACTN = 'I'                                           201232
                                                                                              201232
     C                   IF        WDPRN = *ZERO                                              201232
     C                   EXSR      SRGenRefNo                                                 201232
     C                   ENDIF                                                                201232
                                                                                              201232
     C                   MOVE      WDPRN         DDDPRN                                       201232
     C                   MOVE      DDDPRN        DPRN                                         201232
     C                   ENDIF                                                                201232
                                                                                              167486
      *                                                                                       167486
      ** Retreive Nominal Currency and Market Indicator                                       167486
      *                                                                                       167486
     C     DPSS          CHAIN     SECTY                              99                      167486
      *                                                                                       167486
      ** DATABASE ERROR                                                                       167486
      *                                                                                       167486
     C     *IN99         IFEQ      '1'                                                        167486
                                                                                              167486
     C                   MOVEL     DPSS          DBKEY                                        167486
     C                   MOVEL     'SECTYD'      DBFILE                                       167486
     C                   MOVEL     '905'         DBASE                                        167486
     C                   EXSR      *PSSR                                                      167486
                                                                                              167486
     C                   ELSE                                                                 167486
                                                                                              167486
     C                   MOVE      DDACTN        PACTN                                        167486
     C                   MOVE      DPSS          PPDPSS                                       167486
     C                   MOVE      DPRN          PPDPRN                                       167486
     C                   MOVE      DPBA          PDPBA                                        167486
     C     CSE029        IFEQ      'Y'                                                        207006
     C                   MOVE      DDMRKT        PMRKT                                        207006
     C**********         Z-ADD     CPTY          PDPBN                                 207006 CSD027
     C                   EVAL      PDPBN = CPTY                                               CSD027
     C                   ELSE                                                                 207006
     C                   MOVE      DPBN          PDPBN                                        167486
     C                   ENDIF                                                                207006
     C**********         IF        CPTY = *ZEROS                                       209934 CSD027
     C                   IF        CPTY = *BLANKS                                             CSD027
     C                   MOVE      DPBN          PDPBN                                        209934
     C                   ENDIF                                                                209934
     C                   MOVE      DPMV          PDPMV                                        167486
     C                   MOVE      DPMVType      PTNTP                                        167486
     C                   MOVE      DDDate        PDPDO                                        167486
     C                   MOVE      DDDate        PDPMD                                        167486
     C**********         Z-ADD     DPID          PDPID                                 167486 CSD027
     C                   EVAL      PDPID = DPID                                               CSD027
     C                   MOVE      BVDR1         PDC01                                        167486
     C                   MOVE      BVDR2         PDC02                                        167486
     C**********         Z-ADD     DPOD          PDPOD                                 167486 CSD027
     C                   EVAL      PDPOD = DPOD                                               CSD027
     C                   Z-ADD     RunDate       PLCD                                         167486
     C                   MOVE      SEC_NMCY      PNMCY                                        167486
     C                   MOVE      SEC_MKTI      PDPMK                                        167486
     C                   MOVE      DPNA          PDPNA                                        167486
     C                   MOVE      DPMS          PDPMS                                        CSE028
     C                   Z-ADD     ORED          PORED                                        167486
     C                   Z-ADD     MKTP          PMKTP                                        167486
     C                   MOVEL     *BLANKS       DFT                                          167486
     C                   MOVEL     *BLANKS       MSGS                                         167486
                                                                                              167486
     C                   CALL      'SE1807'                                                   167486
     C                   PARM      '00'          PCMD              2                          167486
     C                   PARM      'N'           PERR              1                          167486
     C                   PARM                    PDATA                                        167486
     C                   PARM                    DFT               1                          167486
     C                   PARM                    MSGS             10                          167486
     C                   PARM                    PMCWL                                        CSD015
                                                                                              167486
     C                   SELECT                                                               167486
                                                                                              167486
     C                   WHEN      PCMD = '03'                                                167486
     C                   EXSR      SREnd                                                      167486
                                                                                              167486
     C                   WHEN      PCMD = '12'                                                167486
     C     CSE012        IFEQ      'Y'                                                        201232
     C                   EVAL      WScrnMode = 'S'                                            201232
     C                   ELSE                                                                 201232
     C                   EVAL      WScrnMode = 'M'                                            167486
     C                   ENDIF                                                                201232
                                                                                              167486
     C                   WHEN      PERR = 'U'                                                 167486
     C                   MOVEL     '*ANY'        FldNameArr(1)                                167486
     C                   MOVEL     'SE03030'     MsgIdArr(1)                                  167486
     C                   EVAL      WScrnMode = 'M'                                            167486
                                                                                              167486
     C**********         WHEN      WRdNxBwRec = 'Y'                                    167486 201232
     C**********         EVAL      WScrnMode = 'R'                                     167486 201232
                                                                                              167486
     C                   WHEN      DDACTN = 'I'                                               167486
     C                             OR DDACTN = 'A'                                            167486
     C/COPY WNCPYSRC,SEDPMVSC04
     C**********         EVAL      WScrnMode = 'U'                                     167486 201232
     C                   EVAL      WScrnMode = 'C'                                            201232
                                                                                              167486
     C                   OTHER                                                                167486
      *                                                                                       201232
     C                   CLEAR                   NwScrnRec                                    201232
     C                   MOVEL     *BLANK        DDSPXR                                       201232
     C                   MOVEL     *BLANK        DDSPMD                                       201232
     C                   MOVEL     ' '           PortCusInd                                   201232
     C                   MOVEL     ' '           PBCusInd                                     201232
     C                   MOVEL     ' '           PBFieldInd                                   201232
     C                   Z-ADD     *ZERO         WDPRN                                        201232
      *                                                                                       201232
      ** Initialise field status and function keys status                                     201232
      *                                                                                       201232
     C                   EXSR      SRRsetFldS                                                 201232
     C                   EXSR      SRRsetFkyS                                                 201232
                                                                                              201232
     C     WRdNxBwRec    IFEQ      'Y'                                                        201232
     C                   MOVE      'R'           WScrnMode                                    201232
     C                   ELSE                                                                 201232
     C                   EVAL      WScrnMode = 'M'                                            167486
     C                   ENDIF                                                                201232
                                                                                              167486
     C                   ENDSL                                                                167486
                                                                                              167486
     C                   END                                                                  167486
                                                                                              167486
     C                   ENDSR                                                                167486
      *****************************************************************                       167486
      /EJECT                                                                                  167486
      *****************************************************************
      *                                                               *
      * SRCanConf - Cancel Confiramtion screen                        *
      *                                                               *
      * Called by: SRConfScrn                                         *
      *                                                               *
      * Calls: SRRsetFldS                                             *
      *        SRSetFkyS                                              *
      *                                                               *
      *****************************************************************
 
     C     SRCanConf     BEGSR
      *
      ** Proceed to Main Screen Validation
      *
     C*****CSE012        IFEQ      'Y'                                                 CSE012 201232
     C**********         Move      'S'           WScrnMode                             CSE012 201232
     C**********         ELSE                                                          CSE012 201232
     C                   MOVE      'M'           WScrnMode
     C**********         ENDIF                                                         CSE012 201232
      *
      ** Initialise field status and Set function keys
      *
     C                   EXSR      SRRsetFldS
 
     C                   EXSR      SRSetFkyS
 
     C                   IF        DDACTN = 'I' AND                                           201232
     C                             @SIDN = *BLANKS                                            201232
     C                   MOVE      *BLANKS       DDDPRN                                       201232
     C                   Z-ADD     *ZERO         WDPRN                                        201232
     C                   ENDIF                                                                201232
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRExitConf - Exit Confirmation screen                         *
      *                                                               *
      * Called by: SRConfScrn                                         *
      *                                                               *
      * Calls: SRRsetFldS                                             *
      *        SRSetFkyS                                              *
      *                                                               *
      *****************************************************************
 
     C     SRExitConf    BEGSR
 
     C     Idx           IFNE      *ZERO
      *
      ** Error found, Proceed to Main Screen Validation
      *
     C     CSE012        IFEQ      'Y'                                                        CSE012
     C                   MOVEL     'S'           WScrnMode                                    CSE012
     C                   ELSE                                                                 CSE012
     C                   MOVEL     'M'           WScrnMode
     C                   ENDIF                                                                CSE012
      *
      ** Initialise field status and Set function keys
      *
     C                   EXSR      SRRsetFldS
     C                   EXSR      SRSetFkyS
 
     C                   ELSE
                                                                                              167486
     C*****S01401        IFEQ      'Y'                                                 167486 201232
     C*****DDACTN        ANDNE     'D'                                                 167486 201232
     C**********         MOVE      'E'           WScrnMode                             167486 201232
     C**********         ELSE                                                          167486 201232
     C                   MOVE      'U'           WScrnMode
     C**********         END                                                           167486 201232
                                                                                              167486
     C                   END
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRConvert - Convert the selected transaction to Screen format *
      *             to be displayed on the screen.                    *
      *                                                               *
      * Called by: SRRdBrwRec                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRConvert     BEGSR
 
     C                   CALLB     'SEDPMVCVT'
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM                    OldDPMVRec
     C                   PARM                    NwScrnRec
     C                   PARM      *BLANK        DDSPXR           14
     C                   PARM      *BLANK        DDSPMD            1
     C                   PARM                    DDSecSts          7
     C                   PARM                    DDTranSts         7
     C                   PARM                    PBCusInd          1            CPB001
     C                   PARM                    PBFieldInd        1            CPB001
     C                   PARM                    CGL031                                       CGL031
      *
      ** The Customer Delivery/Widthrawal Indicator can only be 'Y', 'N'
      ** or *Blank. It is Blank if the Customer is not a portfolio Customer.
      ** Protect Portfolio details if such.
      *
     C                   IF        DDCWDI = ' '
     C                   EVAL      PortCusInd = 'N'
     C                   END
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRetrieve -  Retrieve the Details of the Deal.               *
      *                                                               *
      * Called by: SRMainScrn                                         *
      *                                                               *
      * Calls:  SRRdBrwRec                                            *
      *                                                               *
      *****************************************************************
     C     SRRetrieve    BEGSR
 
     C                   CALLB     'SEDPMVRTV'
     C                   PARM                    DDACTN
     C                   PARM                    DDDPRN
     C                   PARM                    DDDPBA
     C                   PARM                    DDORBR
     C                   PARM      *BLANKS       ModeOfOP          6
     C                   PARM                    RespMode
     C                   PARM      *BLANKS       FOTRID           20
     C                   PARM                    DPMVType                                     174742
     C                   PARM                    CallProg                                     CSE039
     C                   PARM                    DDDPSS                                       CAP087
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *ZERO         Idx               3 0
     C                   PARM                    OldDPMVRec
     C                   PARM                    DDACTNOk
     C                   PARM                    DDDPRNOk
     C                   PARM                    DDDPBAOk
     C                   PARM                    DDORBROk
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRoll - RollUp/RollDwn Function Routine                      *
      *                                                               *
      * Called by: SRMainScrn                                         *
      *                                                               *
      * Calls:  SRMsgMain                                             *
      *         SRRetrieve                                            *
      *         SRConvert                                             *
      *         SRRsetFldS                                            *
      *         SRSetFkyS                                             *
      *                                                               *
      *****************************************************************
     C     SRRoll        BEGSR
      *                                                                                       CSE012
     C     CSE012        IFEQ      'Y'                                                        CSE012
     C                   Movel     'M'           WScrnMode                                    CSE012
     C                   Endif                                                                CSE012
      *
      ** Default action code to enquiry if not valid
      *
     C     DDACTN        IFNE      'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'X'
     C/COPY WNCPYSRC,SEDPMVSC05
     C                   MOVE      'E'           DDACTN
     C                   END
      *
      ** Read next or Previous record on file
      ** according to command key taken (CK/7 OR CK/8)
      *
     C     @INKG         IFEQ      '1'
     C                   MOVEL     *BLANK        @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     *BLANK        @RDBCK
     C                   END
 
     C                   CALLB     'SEDPMVRED'
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM                    DDACTN            1
     C                   PARM                    DPMVType          2
     C                   PARM                    CallProg         10                          222373
     C                   PARM                    DDDPRN            6
     C                   PARM                    DDDPSS           10
     C                   PARM                    @RDFWD            1
     C                   PARM                    @RDBCK            1
     C                   PARM                    @ERRMS            7
     C                   PARM                    @DPRNSel          6
     C                   PARM                    @DPSSSel         10
      *
      ** If error message returned from read, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
      *
      ** Reset Action Code
      *
     C     @DPRNSel      IFEQ      *BLANK
     C     DDDPRN        ANDEQ     *BLANK
     C                   MOVE      *BLANKS       DDACTN
     C                   END
 
     C                   EXSR      SRMsgMain
     C                   ELSE
      *
      ** If SE deal read
      *
     C     @DPRNSel      IFNE      *BLANK
     C     @DPSSSel      ANDNE     *BLANK
      *
      ** Retrieve deal details
      *
     C                   MOVEL     @DPRNSel      DDDPRN
     C                   MOVEL     @DPSSSel      DDDPSS
 
     C                   EXSR      SRRetrieve
      *
      ** Set Field and Function key status Accordingly
      *
     C                   EXSR      SRSetFldS
     C                   EXSR      SRSetFkyS
      *
      ** Convert the transcation into file format
      *
     C                   EXSR      SRConvert
     C                   END
 
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnd -  Termination Routine                                  *
      *                                                               *
      * Called by: SRMainScrn                                         *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
     C     SREnd         BEGSR
      *                                                                                       209867
      ** Issue rollback to clear any possible updates in window function                      209867
      *                                                                                       209867
     C     BGWDPR        IFEQ      'Y'                                                        209867
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                   ROLBK                                                                209867
     C                   Else                                                                 CSC022
     C                   If        (WCommitSkip <> 'Y')                                       CSC022
     C                   ROLBK                                                                CSC022
     C                   Else                                                                 CSC022
     C                   Seton                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   END                                                                  209867
 
     C                   MOVE      'T'           WScrnMode
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCancel - Cancelation Function Routine                       *
      *                                                               *
      * Called by: SRMainScrn                                         *
      *                                                               *
      * Calls:  SRRsetFldS                                            *
      *         SRSetFkyS                                             *
      *                                                               *
      *****************************************************************
     C     SRCancel      BEGSR
 
      *
      ** Reset Read Next Browse Subfile Record
      *
     C                   MOVE      *BLANK        WRdNxBwRec
      *
      ** If Input fields are enabled, Reset the main details screen.
      *
     C     @EKYFD        IFEQ      'Y'
     C     @EDTFD        OREQ      'Y'
     C                   MOVEL     *BLANK        NwScrnRec
     C                   MOVEL     *BLANK        DDSPXR
     C                   MOVEL     *BLANK        DDSPMD
     C                   MOVEL     *BLANK        PortCusInd                     CPB001
     C                   MOVEL     *BLANK        PBCusInd                       CPB001
     C                   MOVEL     *BLANK        PBFieldInd                     CPB001
     C                   MOVE      *BLANKS       DDTranSts                                  AR551823
     C                   END
      *
      ** Initialize field and function key status on main details screen
      *
     C                   EXSR      SRRsetFldS
     C                   EXSR      SRRsetFkyS
 
     C/COPY WNCPYSRC,SEDPMVSC06
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CSE012
      *****************************************************************                       CSE012
      *                                                               *                       CSE012
      * SRCanc - Cancel Second Screen                                 *                       CSE012
      *                                                               *                       CSE012
      * Called by: SRSecScrn                                          *                       CSE012
      *                                                               *                       CSE012
      * Calls:  None                                                  *                       CSE012
      *                                                               *                       CSE012
      *****************************************************************                       CSE012
     C     SRCanc        BEGSR                                                                CSE012
      *                                                                                       CSE012
     C                   Movel     'M'           WScrnMode                                    CSE012
      *                                                                                       CSE012
     C                   ENDSR                                                                CSE012
      *****************************************************************                       CSE012
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValEntry - Validation Routine                               *
      *                                                               *
      * Called by: SRMainScrn                                         *
      *                                                               *
      * Calls:  SRRetrieve                                            *
      *         SRSetFldS                                             *
      *         SRSetFkyS                                             *
      *         SRConvert                                             *
      *         SRUpdate                                              *
      *                                                               *
      *****************************************************************
      *
      ** Retrieve deal details
      *
     C     SRValEntry    BEGSR
 
     C     DDACTN        IFNE      'I'                                                        225965
     C     DDDPRN        ANDNE     WPrevDPRN                                                  225965
     C                   EXSR      SRRetrieve
     C                   ENDIF                                                                225965
      *
      ** If action code, Ref. number, Security or Booking branch or
      ** Originating Branch are invalid
      ** Re-output screen with error messages on it
      *
     C     DDACTNOk      IFEQ      'Y'
     C     DDDPRNOk      ANDEQ     'Y'
     C     DDORBROk      ANDEQ     'Y'
     C     DDDPBAOk      ANDEQ     'Y'
      *
      ** ---------------------------------------------------------------
      *
      ** Set field and function key status on main details screen
      ** (according to action code)
      *
     C                   EXSR      SRSetFldS
     C                   EXSR      SRSetFkyS
      *
      ** Put the deal on the main details screen if Deletion/Enquiry.
      ** Also if amending a new transaction.
      *
     C     DDACTN        IFEQ      'E'
     C     DDACTN        OREQ      'D'
     C     DDACTN        OREQ      'A'
     C     DDDPRN        ANDNE     WPrevDPRN
     C     DDACTN        OREQ      'A'                                          165402
     C     DDACTN        ANDNE     @PACTN                                       165402
     C/COPY WNCPYSRC,SEDPMVSC07
      *
      ** Convert the deal to screen format
      *
     C                   EXSR      SRConvert
     C                   END
      *
      ** If Ref number or screen control indicators have changed
      ** Re-output screen
      *
     C     DDDPRN        IFNE      WPrevDPRN
     C     DDACTN        ANDNE     'I'
     C     @CCI@M        ORNE      @PCI@M
     C     DDACTN        ORNE      @PACTN                                       165402
     C                   GOTO      ENDVAL
     C                   END
 
      *
      ** DELETE
      ** ------
      *
     C     DDACTN        IFEQ      'D'
      *
      ** Update Deal in File Format
      *
     C                   MOVEL     OLDDPMVRec    NewDPMVRec
      *                                                                                       234691
      ** Prior to validation, initialize error indicators as 'OK'                             234691
      ** and clear SE Deal in File Format                                                     234691
      *                                                                                       234691
     C     CGL031        IFEQ      'Y'                                                        234691
     C                   Z-ADD     *ZERO         Idx                                          234691
     C                   Z-ADD     *ZERO         WIdx                                         234691
     C                   MOVE      *ALL'Y'       OKIndFile                                    234691
      *                                                                                       234691
      ** Validate deal details                                                                234691
      *                                                                                       234691
     C                   CALLB     'SEDPMVVAL'                                                234691
                                                                                              234691
     C                   PARM                    NwScrnRec                                    234691
     C                   PARM                    ExtData                                      234691
     C                   PARM                    SECTY_DS                                     234691
     C                   PARM                    DPMVType                                     234691
     C                   PARM                    DDDRID                                       246166
     C                   PARM                    RespMode                                     234691
     C                   PARM                    DDSPXR                                       234691
     C                   PARM                    DDSPMD                                       234691
     C                   PARM                    PortCusInd                                   234691
     C                   PARM                    PBCusInd                                     234691
     C                   PARM                    PBFieldInd                                   234691
     C                   PARM                    NewDPMVRec                                   234691
     C                   PARM                    OKIndFile                                    234691
     C                   PARM                    FldNameArr                                   234691
     C                   PARM                    MsgIDArr                                     234691
     C                   PARM                    MsgDtaArr                                    234691
     C                   PARM                    WFldNamArr                                   234691
     C                   PARM                    WMsgIDArr                                    234691
     C                   PARM                    WMsgDtaArr                                   234691
     C                   PARM                    Idx                                          234691
     C                   PARM                    WIdx                                         234691
     C                   PARM                    CGL031                                       234691
                                                                                              234691
      *                                                                                       234691
     C     CGL031        IFEQ      'Y'                                                        234691
     C     Idx           ANDEQ     0                                                          234691
     C     CGL031        ORNE      'Y'                                                        234691
      *
      ** IF CK/10 TAKEN, GO ONTO UPDATES
      *
     C     @INKJ         IFEQ      '1'
     C                   EXSR      SRUpdate
     C                   END
     C                   ELSE                                                                 234691
                                                                                              234691
     C     Idx           IFNE      0                                                          234691
     C                   MOVEL     'M'           WScrnMode                                    234691
     C                   ENDIF                                                                234691
     C                   ENDIF                                                                234691
                                                                                              234691
     C                   ENDIF                                                                234691
 
     C                   END
      *
      ** ENQUIRE
      ** -------
      *
     C     DDACTN        IFEQ      'E'
      *
      ** Update Deal in File Format
      *
     C                   MOVEL     OldDPMVRec    NewDPMVRec
      *
      *
      ** If F12, proceed to Main routine
      ** If windows processing on, call window routine
      ** If MT5xx Message Generation installed, call ext. detail scrn                         167486
      ** If Browse outstanding read next Browse subfile record
      *
     C                   SELECT
 
     C                   WHEN      CSE012 = 'Y'                                               CSE012
     C                   MOVEL     'S'           WScrnMode                                    CSE012
      *                                                                                       CSE012
     C                   WHEN      S01401 = 'Y'                                               201232
     C                   MOVEL     'E'           WScrnMode                                    201232
                                                                                              201232
     C                   WHEN      BGWDPR = 'Y'
     C                   MOVEL     'W'           WScrnMode
 
     C**********         WHEN      S01401 = 'Y'                                        167486 201232
     C**********         MOVEL     'E'           WScrnMode                             167486 201232
                                                                                              167486
     C                   WHEN      WRdNxBwRec = 'Y'
     C                   MOVEL     'R'           WScrnMode
 
     C                   ENDSL
 
     C                   END
     C/COPY WNCPYSRC,SEDPMVSC08
      *
      ** INSERT OR AMEND
      ** ---------------
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
      ** Prior to validation, initialize error indicators as 'OK'
      ** and clear SE Deal in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   MOVE      *ALL'Y'       OKIndFile
 
     C                   CLEAR                   NewDPMVRec
      *
      ** If Amend, Update Deal in File Format
      *
     C     DDACTN        IFEQ      'A'
     C                   MOVEL     OldDPMVRec    NewDPMVRec
     C                   ELSE
      *
      ** If Insert, just move the key fields to the new File Format
      *
     C                   MOVE      DDDPRN        DPRN
     C                   END
      *
      ** Validate deal details
      *
     C                   CALLB     'SEDPMVVAL'
 
     C                   PARM                    NwScrnRec
     C                   PARM                    ExtData                        CAP004
     C*******************PARM                    SECTY                                        167486
     C                   PARM                    SECTY_DS                                     167486
     C                   PARM                    DPMVType          2
     C                   PARM                    DDDRID            1                          246166
     C                   PARM                    RespMode
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
     C                   PARM                    PortCusInd
     C                   PARM                    PBCusInd                       CPB001
     C                   PARM                    PBFieldInd                     CPB001
     C                   PARM                    NewDPMVRec
     C                   PARM                    OKIndFile
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WIdx
     C                   PARM                    CGL031                                       CGL031
 
      *                                                                                       201232
     C                   EVAL      WReDisplay = *BLANK                                        201232
      *                                                                                       201232
      ** If no errors occurred during validation of key fields, check                         201232
      ** if there are warnings which have not been displayed yet.                             201232
      *                                                                                       201232
     C                   IF        IDx = *ZERO                                                201232
                                                                                              201232
     C                   Z-ADD     1             WiX                                          201232
                                                                                              201232
     C                   DOW       WiX <= WIDx AND WReDisplay = *BLANK                        201232
                                                                                              201232
     C                   IF        WMsgIdArr(WiX) <> WPrvWarnAr(WiX)                          201232
     C                   EVAL      WReDisplay = 'Y'                                           201232
     C                   ELSE                                                                 201232
     C                   EVAL      WiX = WiX + 1                                              201232
     C                   ENDIF                                                                201232
                                                                                              201232
     C                   ENDDO                                                                201232
                                                                                              201232
     C                   ENDIF                                                                201232
 
     C                   SELECT
 
     C                   WHEN      Idx <> 0
     C                             OR WReDisplay = 'Y'                                        201232
     C                             OR  PortCusInd <> WPrevCInd
     C                             AND WPrevCInd <> *BLANKS
     C                             OR  PBCusInd <> WPvPBInd                     CPB001
     C                             AND WPvPBInd <> *BLANKS                      CPB001
     C                   MOVEL     'M'           WScrnMode
 
     C                   WHEN      CSE012 = 'Y'                                               CSE012
     C                   MOVEL     'S'           WScrnMode                                    CSE012
      *                                                                                       CSE012
     C                   WHEN      S01401 = 'Y'                                               201232
     C                   MOVEL     'E'           WScrnMode                                    201232
                                                                                              201232
     C                   WHEN      BGWDPR = 'Y'
     C                   MOVEL     'W'           WScrnMode
 
     C                   WHEN      BGWDPR <> 'Y'
     C                   MOVEL     'C'           WScrnMode
 
     C                   ENDSL
 
      *
     C                   END
      *
      **----------------------------------------------------------------
      *
     C                   END
 
 
     C     ENDVAL        ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWindow - Window Manager                                     *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRWindow      BEGSR
      *
      * Reset erros
      *
     C                   MOVE      *ALL'Y'       OkIndFile
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *                                                                                       CSE012
      ** If CSE012 is installed                                                               CSE012
      *                                                                                       CSE012
     C     CSE012        IFEQ      'Y'                                                        CSE012
     C                   CALLB     'SEDPMV2DP'                                                CSE012
     C                   PARM                    RetrnCod          6                          CSE012
     C                   PARM                    DDACTN            1                          CSE012
     C                   PARM                    DDDPSS           10                          CSE012
     C                   PARM                    DDDPRN            6                          CSE012
     C                   PARM                    DDDPNR2                                      CSE012
     C                   PARM                    DDDPNR3                                      CSE012
     C                   PARM                    DDDPNR4                                      CSE012
     C                   PARM                    DDDPNR5                                      CSE012
     C                   PARM                    FldNameArr                                   CSE012
     C                   PARM                    MsgIdArr                                     CSE012
     C                   PARM                    MsgDtaArr                                    CSE012
     C                   PARM                    WFldNamArr                                   CSE012
     C                   PARM                    WMsgIdArr                                    CSE012
     C                   PARM                    WMsgDtaArr                                   CSE012
     C                   PARM      'N'           @EKYFD            1                          CSE012
     C                   PARM      'N'           @EDTFD            1                          CSE012
     C                   PARM      'N'           @EINKG            1                          CSE012
     C                   PARM      'N'           @EINKH            1                          CSE012
     C                   PARM      'N'           @EINKJ            1                          CSE012
     C                   PARM      'N'           @EINKN            1                          CSE012
     C                   PARM      'N'           @EINKP            1                          CSE012
     C                   PARM                    @INKC                                        CSE012
     C                   PARM                    @INKG                                        CSE012
     C                   PARM                    @INKH                                        CSE012
     C                   PARM                    @INKJ                                        CSE012
     C                   PARM                    @INKL                                        CSE012
     C                   PARM                    @INKP                                        CSE012
     C                   PARM      'Y'           WriteOnly         1                          CSE012
     C                   ELSE                                                                 CSE012
      *
      ** Write out screen to remove error messages
      *
     C     DPMVType      IFEQ      'WI'
 
     C                   CALLB     'SEDMWIDSP'
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM                    DPMVSety                                     CSE039
     C                   PARM                    DPMVTrno                                     CSE039
     C                   PARM                    DDTranSts         7
     C                   PARM                    DDSecSts          7
     C                   PARM                    NwScrnRec
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
     C                   PARM                    PortCusInd        1
     C                   PARM                    PBCusInd          1            CPB001
     C                   PARM                    PBFieldInd        1            CPB001
     C                   PARM                    OKIndFile
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      'N'           @EKYFD            1
     C                   PARM      'N'           @EDTFD            1
     C                   PARM      'N'           @EINKG            1
     C                   PARM      'N'           @EINKH            1
     C                   PARM      'N'           @EINKJ            1
     C                   PARM      'N'           @EINKN            1
     C                   PARM      'N'           @EINKP            1
     C                   PARM                    @SIDN             6
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKW             1                          CSE039
     C                   PARM      'Y'           @INKWDisp         1                          CSE039
     C                   PARM      'Y'           WriteOnly         1
     C                   PARM                    CGL031                                       CGL031
     C                   END
 
     C     DPMVType      IFEQ      'WO'
     C                   CALLB     'SEDMWODSP'
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM                    DPMVSety                                     CSE039
     C                   PARM                    DPMVTrno                                     CSE039
     C                   PARM                    DDTranSts
     C                   PARM                    DDSecSts
     C                   PARM                    NwScrnRec
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
     C                   PARM                    PortCusInd        1
     C                   PARM                    PBCusInd          1            CPB001
     C                   PARM                    PBFieldInd        1            CPB001
     C                   PARM                    OKIndFile
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      'N'           @EKYFD            1
     C                   PARM      'N'           @EDTFD            1
     C                   PARM      'N'           @EINKG            1
     C                   PARM      'N'           @EINKH            1
     C                   PARM      'N'           @EINKJ            1
     C                   PARM      'N'           @EINKN            1
     C                   PARM      'N'           @EINKP            1
     C                   PARM                    @SIDN             6
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKW             1                          CSE039
     C                   PARM      'Y'           @INKWDisp         1                          CSE039
     C                   PARM      'Y'           WriteOnly         1
     C                   PARM                    CGL031                                       CGL031
     C                   END
      *                                                                                       CSE012
     C                   ENDIF                                                                CSE012
      *
      ** For inserts generate Reference number
      *
     C                   IF        DDACTN = 'I'
     C                             AND DDDPRN = *BLANKS
     C                   EXSR      SRGenRefNo
     C                   ENDIF
      *
     C/COPY WNCPYSRC,SEDMSINMV1
      *
     C                   CALL      'WN0010'
     C                   PARM      'SEDPMVSIN'   #PGM             10
     C                   PARM                    FKEY              2
     C                   PARM      DDACTN        ACTION            1
     C                   PARM                    DATA
     C                   PARM      *BLANKS       #RTRN             7
     C                   PARM                    SPAREW          256
      *
      * Process returned command keys
      *
     C     #RTRN         IFEQ      'Y2U9999'
     C                   EXSR      SREnd
     C                   ELSE
      *
      *  If Cmd12 pressed, or in enquiry, return to main details screen;
      *  otherwise, go to Confirmation screen
      *
     C     #RTRN         IFEQ      'USR0790'
     C     DDACTN        OREQ      'E'
 
     C*****S01401        IFEQ      'Y'                                                 167486 201232
     C**********         EVAL      WScrnMode = 'E'                                     167486 201232
     C**********         ELSE                                                          167486 201232
                                                                                              167486
     C     WRdNxBwRec    IFEQ      'Y'
     C                   EVAL      WScrnMode = 'R'
     C                   ELSE
      *                                                                                       CSE012
      ** If CSE012 is installed                                                               CSE012
      *                                                                                       CSE012
     C     CSE012        IFEQ      'Y'                                                        CSE012
     C                   EVAL      WScrnMode = 'S'                                            CSE012
     C                   ELSE                                                                 CSE012
     C                   EVAL      WScrnMode = 'M'
     C                   ENDIF                                                                CSE012
     C                   END
                                                                                              167486
     C**********         END                                                           167486 201232
 
     C                   ELSE
 
     C/COPY WNCPYSRC,SEDPMVSC09
     C                   EVAL      WScrnMode = 'C'
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGenRefNo - Reference Number Generation Routine.             *
      *                                                               *
      * Called by: SRUpdate                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRGenRefNo    BEGSR
 
     C                   CALLB     'ZATRNRTV'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      'SE'          MODU              2
     C*******************PARM      'T'           TRTY              1            167221
     C                   PARM      'D'           TRTY              1            167221
     C                   PARM                    DPRN
     C                   PARM      *ZERO         WDPRN
      *
      ** DATABASE ERROR
      *
     C     RetCodeOut    IFNE      *BLANK
     C                   MOVEL     'ZATRNRTV'    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   MOVEL     DDDPRN        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMsgMain  - Send a message to Main Details Screen            *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRMsgMain     BEGSR
      *
      ** If single branching, user can't browse file
      *
     C     @ERRMS        IFEQ      'FXM0292'
     C                   MOVE      'N'           DDACTNOK
     C                   END
      *
      ** Deal number on screen must be blank or numeric for pointer
      *
     C     @ERRMS        IFEQ      'MMA0425'
     C                   MOVE      'N'           DDDPRNOK
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
      *                                                               *
      * SRSetFldS - Set Field Status on Main details Screen with      *
      *             Regards to the action Code.                       *
      *                                                               *
      * Called by: SRRdBrwRec                                         *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
     C     SRSetFldS     BEGSR
 
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     DDACTN        OREQ      *BLANK                                                     FIX002
     C                   MOVEL     'Y'           @EKYFD
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EKYFD
     C                   MOVEL     'N'           @EDTFD
     C                   END
     C/COPY WNCPYSRC,SEDPMVSC10
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetFkyS - Set Function Key Status on Main Details Screen    *
      *             to correspond with the action code.               *
      *                                                               *
      * Called by: SRRdBrwRec                                         *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRSetFkyS     BEGSR
      *
      ** Enable/disable function keys on main details screen
      *
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      *
     C                   MOVEL     'Y'           @EINKG
     C                   MOVEL     'Y'           @EINKH
      *
      ** KJ = COMMAND KEY 10 = CONFIRM DELETE
      *
     C     DDACTN        IFEQ      'D'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
      *
      ** KN = COMMAND KEY 14 = SETTLEMENT DETAILS
      ** (Action codes I, A, X display settlement details automatically)
      ** (No futher screens are available from action code D)
      *
     C     DDACTN        IFEQ      'E'
     C                   MOVEL     'Y'           @EINKN
     C                   ELSE
     C                   MOVEL     'N'           @EINKN
     C                   END
      *
      ** KP = COMMAND KEY 15 = BROWSE
      *
     C                   MOVEL     'Y'           @EINKP
 
     C/COPY WNCPYSRC,SEDPMVSC11
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRsetFldS - Initialize Field Status on Main details Screen.  *
      *                                                               *
      * Called by: *InzSR                                             *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
     C     SRRsetFldS    BEGSR
 
     C                   MOVEL     'Y'           @EKYFD
     C                   MOVEL     'Y'           @EDTFD
     C                   MOVEL     'Y'           FirstCall         1                          CSE039
     C/COPY WNCPYSRC,SEDPMVSC12
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRsetFkyS - Initialize Function Key Status on Main Details   *
      *             Screen.                                           *
      *                                                               *
      * Called by: *InzSR                                             *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
     C     SRRsetFkyS    BEGSR
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
     C/COPY WNCPYSRC,SEDPMVSC13
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DSPMOV  - Show movements for Trade                                                    CSE039
      *****************************************************************                       CSE039
     C     DSPMOV        BEGSR                                                                CSE039
                                                                                              CSE039
     C     DDACTN        IFEQ      'E'                                                        CSE039
     C                   MOVE      'E'           @MODE                                        CSE039
     C                   ENDIF                                                                CSE039
     C     DDACTN        IFEQ      'A'                                                        CSE039
     C                   MOVE      'M'           @MODE                                        CSE039
     C                   ENDIF                                                                CSE039
      *                                                                                       CSE039
     C                   CALL      'SEC025'                                                   CSE039
     C                   PARM      'SEMVTSSIN'   @PGM             10                          CSE039
     C                   PARM                    DDDPRN                                       CSE039
     C                   PARM      'W'           @TYPR             1                          CSE039
     C                   PARM                    @MODE             1                          CSE039
     C                   PARM                    @endF3            1                          CSE039
     C                   PARM                    @endF12           1                          CSE039
                                                                                              CSE039
     C     @endF3        IfEq      'Y'                                                        CSE039
     C                   SETON                                        LR                      CSE039
     C                   RETURN                                                               CSE039
     C                   ENDIF                                                                CSE039
                                                                                              CSE039
     C                   ENDSR                                                                CSE039
      *****************************************************************                       CSE039
      /EJECT                                                                                  CSE039
      *****************************************************************                       CSE039
      *                                                               *
      * *InzSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *InzSR        BEGSR
      *
     C     *Entry        PLIST
      *
      ** Transaction Type
      *
     C                   PARM                    DPMVType          2
     C/COPY WNCPYSRC,SEDPMVSC14
      *                                                                                       CSE039
      * Fields passed in if called from SE4400                                                CSE039
      * Security, Transaction Number and Return Code                                          CSE039
     C                   PARM                    DPMVSety         10                          CSE039
     C                   PARM                    DPMVTrno          6                          CSE039
     C                   PARM                    DPMVRtrn          7                          CSE039
     C                   PARM                    CallProg         10                          CSE039
     C
      *
      ** Initialize program name
      *
     C                   MOVEL     'SEDPMVSIN'   DBPGM
      *                                                                                       167486
      ** Read data area - RUNDAT                                                              167486
      *                                                                                       167486
     C     *DTAARA       DEFINE                  RUNDAT                                       167486
     C                   IN        RUNDAT                                                     167486
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
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
     C                   CALLB     'AOMMODR0'
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
      *                                                                                       167486
      ** Access SAR details file to determine if S01401                                       167486
      ** (MT5XX Message Generation) is on.                                                    167486
      *                                                                                       167486
     C                   CALLB     'AOSARDR0'                                                 167486
     C                   PARM      *BLANKS       @RTCD                                        167486
     C                   PARM      '*VERIFY'     @OPTN                                        167486
     C                   PARM      'S01401'      @SARD             6                          167486
     C     SCSARD        PARM      SCSARD        DSFDY                                        167486
      *                                                                                       167486
      * DATABASE ERROR                                                                        167486
      *                                                                                       167486
     C     @RTCD         IFNE      *BLANKS                                                    167486
     C     @RTCD         ANDNE     '*NRF   '                                                  167486
     C                   MOVEL     'SCSARDPD'    DBFILE                                       167486
     C                   MOVEL     '903'         DBASE                                        167486
     C                   MOVEL     'S01401'      DBKEY                                        167486
     C                   EXSR      *PSSR                                                      167486
     C                   END                                                                  167486
      *                                                                                       167486
     C     @RTCD         IFEQ      *BLANK                                                     167486
     C                   MOVEL     'Y'           S01401            1                          167486
     C                   ELSE                                                                 167486
     C                   MOVEL     'N'           S01401                                       167486
     C                   END                                                                  167486
      *                                                                                       167486
      ** Get Securities Trading Data by access object                                         167486
      *                                                                                       167486
     C                   CALL      'AOSTRDR0'                                                 167486
     C                   PARM      '*DBERR '     @RTCD                                        167486
     C                   PARM      '*FIRST '     @OPTN                                        167486
     C     SDSTRD        PARM      SDSTRD        DSSDY                                        167486
                                                                                              167486
     C     @RTCD         IFNE      *BLANKS                                                    167486
     C                   MOVEL     'SDSTRDPD'    DBFILE                                       167486
     C                   MOVEL     '904'         DBASE                                        167486
     C                   MOVEL     '*FIRST'      DBKEY                                        167486
     C                   EXSR      *PSSR                                                      167486
     C                   END                                                                  167486
      *                                                                                       CSE012
      ** Access Switchable Features File, for SE Depot Movement Narratives                    CSE012
      *                                                                                       CSE012
     C                   MOVE      'N'           CSE012            1                          CSE012
     C                   CALLB     'AOSARDR0'                                                 CSE012
     C                   PARM      *BLANKS       PRTCD             7                          CSE012
     C                   PARM      '*VERIFY'     POPTN             7                          CSE012
     C                   PARM      'CSE012'      PSARD             6                          CSE012
      *                                                                                       CSE012
     C     PRTCD         IFEQ      *BLANKS                                                    CSE012
     C                   MOVE      'Y'           CSE012                                       CSE012
     C                   ENDIF                                                                CSE012
      *                                                                                       CSE012
      ** Database Error                                                                       CSE012
      *                                                                                       CSE012
     C     PRTCD         IFNE      *BLANKS                                                    CSE012
     C     PRTCD         ANDNE     '*NRF   '                                                  CSE012
     C                   MOVEL     'CSE012 '     DBKEY                                        CSE012
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSE012
     C                   MOVEL     '903'         DBASE                                        CSE012
     C                   EXSR      *PSSR                                                      CSE012
     C                   ENDIF                                                                CSE012
      *                                                                                       207006
      ** Access Switchable Features File, to check for CSE029                                 207006
      *                                                                                       207006
     C                   MOVE      'N'           CSE029            1                          207006
     C                   CALLB     'AOSARDR0'                                                 207006
     C                   PARM      *BLANKS       PRTCD                                        207006
     C                   PARM      '*VERIFY'     POPTN                                        207006
     C                   PARM      'CSE029'      PSARD                                        207006
      *                                                                                       207006
     C     PRTCD         IFEQ      *BLANKS                                                    207006
     C                   MOVE      'Y'           CSE029                                       207006
     C                   ENDIF                                                                207006
      *                                                                                       207006
      ** Database Error                                                                       207006
      *                                                                                       207006
     C     PRTCD         IFNE      *BLANKS                                                    207006
     C     PRTCD         ANDNE     '*NRF   '                                                  207006
     C                   MOVEL     'CSE029 '     DBKEY                                        207006
     C                   MOVEL     'SCSARDPD'    DBFILE                                       207006
     C                   MOVEL     '906'         DBASE                                        207006
     C                   EXSR      *PSSR                                                      207006
     C                   ENDIF                                                                207006
                                                                                              CGL031
      ** Access Switchable Features File, for Taxation Savings Income CGL031                  CGL031
                                                                                              CGL031
     C                   MOVE      'N'           CGL031                                       CGL031
     C                   CALL      'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRTCD                                        CGL031
     C                   PARM      '*VERIFY'     POPTN                                        CGL031
     C                   PARM      'CGL031'      PSARD                                        CGL031
                                                                                              CGL031
     C                   IF        PRTCD = *BLANKS                                            CGL031
     C                   MOVE      'Y'           CGL031                                       CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
      ** Database Error                                                                       CGL031
                                                                                              CGL031
     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CGL031
     C                   MOVEL     'CGL031 '     DBKEY                                        CGL031
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL031
     C                   MOVEL     '907'         DBASE                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
      *
      ** Start on Main Details Screen
      *
     C                   MOVEL     'M'           WScrnMode         1
 
     C                   MOVEL     ' '           PortCusInd        1
     C                   MOVEL     ' '           PBCusInd          1            CPB001
     C                   MOVEL     ' '           PBFieldInd        1            CPB001
      *
      ** Initialize field and function key status on main details screen
      *
     C                   EXSR      SRRsetFldS
     C                   EXSR      SRRsetFkyS
      *
      ** Access Switchable Features File, for CSC022                                          CSC022
      *                                                                                       CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       PRTCD                                        CSC022
     C                   Parm      '*VERIFY'     POPTN                                        CSC022
     C                   Parm      'CSC022'      PSARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        167486
      *                                                                                       CSC022
     C                   If        PRtCd = *Blanks                                            CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
     C                   Eval      WCommitSkip = 'N'                                          CSC022
      *                                                                                       CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        ComitNum > 0                                               CSC022
     C                   MoveA     ComitJob      WCmtJobArr                                   CSC022
      *                                                                                       CSC022
     C     PSJOBNAME     LOOKUP    WCmtJobArr                             87                  CSC022
     C                   If        *IN87 = *ON                                                CSC022
     C                   Eval      WCommitSkip = 'Y'                                          CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   Else                                                                 CSC022
      *                                                                                       CSC022
      ** If return code <> *NRF, call program exception error routine                         CSC022
      *                                                                                       CSC022
     C                   If        PRtCd <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 907                                                CSC022
     C                   OUT       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SEDPMVS009
 
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
