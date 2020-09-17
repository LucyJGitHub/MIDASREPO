     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Invalid depot movements repair')              *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading  Module                           *
      *                                                               *
      *  SEDPMVRPR - SE Depot Movement Invalid Transaction Repair     *
      *              Function Module.                                 *
      *                                                               *
      *  Function:  This function allows invalid Depot Movement       *
      *             Transaction to be 'repaired' and applied to the   *
      *             Midas database.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247884             Date 21May07               *
      *                 246166             Date 07Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 05May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CAP087             Date 24Aug05               *
      *                 CSE075             Date 17Nov05               *
      *                 BUG9096            Date 10Aug05               *
      *                 BUG9079            Date 09Aug05               *
      *                 CER001             Date 25Apr05               *
      *                 235844             Date 05Sep05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE071             Date 19Jul05               *
      *                 CSC022             Date 24Feb04               *
      *                 222373             Date 22Oct03               *
      *                 222727             Date 05Nov03               *
      *                 CAS006             Date 21Jan03               *
      *                 CSE039             Date 21Jan03               *
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 207006             Date 18Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE028             Date 06Jun01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      *                 174742             Date 17Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      *                 183768             Date 15Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 167486             Date 07Apr00               *
      *                 174857             Date 23Feb00               *
      *                 166907             Date 27Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE015             Date 06Dec99               *
      *                 CSE017             Date 20Oct99               *
      *                 CSE012             Date 16Aug99               *
      *                 CPB001             Date 26Aug99               *
      *                 CAP014             Date 29Nov99               *
      *                 CAP013             Date 07Sep99               *
      *                 CAP011             Date 07Sep99               *
      *                 168345             Date 13Oct99               *
      *                 167221             Date 08Sep99               *
      *                 163820             Date 12Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP006             DATE 17Mar99               *
      *                 CAP004             Date 01Sep98               *
      *                 CAP003  *CREATE    Date 27May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247884 - Cannot proceed to Depot Movement Walk In/Out repair *
      *           screen. Recompiled due to signature violation.      *
      *  246166 - To complete fix 244007. Add repo indicator from     *
      *           repurchased agreement input.                        *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP087 - Depot Movement - Java Wrapper in Midasplus.         *
      *           New parameter added to call to SEDPMVRTV.           *
      *           Also due to changes in file SEDMWIPD, SEDMWOPD      *
      *           and SEEDMWIPD)                                      *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  BUG9096 - Should proceed to the next screen after the second *
      *            screen regardless of the action code.              *
      *  BUG9079 - Action 'N' updates the database files even with    *
      *            errors.                                            *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  235844 - Parameter missing when call SEDPMVUPD.              *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  222373 - Parameter Mismatch                                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE039 - Auto-settle of trades                               *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  207006 - Add Counterparty & Market Centre to SSI (Recompile) *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CSE028 - Standing Settlement Instructions Enhancement.       *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  174742 - Walk in transactions showing on Walk out screen with*
      *         - Walk out transactions showing on Walk in screen     *
      *  CSE023 - Treaty Withholding Tax (Recompiled over SECTYD)     *
      *  183768 - Error in Switchable feature processing              *
      *           - features are always set on.                       *
      *  167486 - Call SE1807 to access extension file allowing input *
      *           of the fields needed to produce SWIFT Messages.     *
      *  174857 - Program name passed to WN0010 is SIN instead of RPR *
      *  166907 - Display 'Deal No. 999999 successfully inserted.'    *
      *           in the correct screen.                              *
      *  CSE015 - Forward Valued Depot Movements (Recompiled)         *
      *  CSE017 - Cun/Ex Indicator on Depot Movements (Recompiled)    *
      *  CSE012 - SE Depot Movement Narratives                        *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *         - 'Private Banking' Module                            *
      *  CAP014 - Repair function enhancements                        *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  CAP011 - Substitution of Midas database flds for externl i/fs*
      *  168345 - Prevent two users from accessing same transaction   *
      *           in repair screen at the same cycle, and converting  *
      *           it into two different Midas Deal No.s  .            *
      *           Second user should not be allowed to repair the tran-
      *           saction and convert it into a another Midas Deal.   *
      *  167221 - Duplicate depot movements as wrong reference assignd*
      *  163820 - Transactions Repair Function performs SPF checking  *
      *           to find if user is authorised to the Branch , but   *
      *           does that against User's Default Branch code instead*
      *           of the selected transaction's Booking/Origin branch *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP006 - Check for deal being updated by another workstation *
      *  CAP004 - API's Phase 3.                                      *
      *           Add extra parm for Extra Data                       *
      *           Remove MSGTYPE field as not needed.                 *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
     FSEIDPMVL0 IF   E           K DISK    INFSR(*PSSR)
 
     FSEIDPMVL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEIDPMVD0:SEIDPMVD1)
     F                                     COMMIT
 
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
     FSECTY     IF   E           K DISK    PREFIX(SEC_)                                       167486
     F                                     INFSR(*PSSR)                                       167486
                                                                                              167486
     FDPTMVDY1  UF A E           K DISK    INFSR(*PSSR)                                       167486
     F                                     COMMIT                                             167486
                                                                                              CSC011
      ** API Invalid Log File                                                                 CSC011
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
                                                                                              CSC011
     FSEDPX1L0  IF   E           K DISK    INFSR(*PSSR) USROPN                                CER001
     F                                     RENAME(DPTMVDF6:RTVIDX)                            CER001
                                                                                              CER001
     FSEIDMLX1L0UF   E           K DISK    INFSR(*PSSR) USROPN                                CER001
     F                                     RENAME(SEIDMLXD6:RTVIDX1)                          CER001
     F                                     COMMIT                                             CER001
                                                                                              CER001
     FERLUICL1  IF   E           K DISK    INFSR(*PSSR) USROPN                                CER001
     F                                     COMMIT                                             CER001
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SEDPMVR008
 
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
 
     D @EI             S              1    DIM(60)
                                                                                              CSC022
     D WCmtJobArr      S             10A   DIM(10)                                            CSC022
      ** Array for commitment job names                                                       CSC022
 
     ** Depot Movement Details Data Structures
     ** --------------------------------------
 
     ** Screen Fields
      ** Rename In Depot/Date to avoid be used for Walk In/Walk Out.
     ** Fields Ok Indicator
     ** Current Transaction In file Format
     ** Transaction file Format
 
     D NwScrnRec     E DS                  EXTNAME(SEDMWIPD)
     D DDDEPOT       E                     EXTFLD(DDDPID)
     D DDDATE        E                     EXTFLD(DDDPMD)
     D CrScrnRec     E DS                  EXTNAME(SEDMWIPD)                    CAP011
     D                                     PREFIX(@)                            CAP011
 
     D OKIndFile     E DS                  EXTNAME(SEEDMWIPD)
 
     D OldDPMVRec    E DS                  EXTNAME(DPTMVD)
     D                                     PREFIX(Old)
 
     D NewDPMVRec    E DS                  EXTNAME(DPTMVD)
 
      ** ICD/SD Data Structures
      ** ----------------------
 
      ** External DS for Bank Details
      ** Midas Modules Details Accessed Via Access Program
      ** API ICD                                                                CAP011
      ** DS for Access Programs, Short DS
      ** Security Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP011
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     167486
     D*SECTY*********E DS                  EXTNAME(SECTYD)                                    167486
     D SECTY_DS      E DS                  EXTNAME(SECTYD)                                    167486
     D                                     PREFIX(SEC)
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  167486
     D SCA_LCD       E                     EXTFLD(LCD)                                        167486
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)                                  167486
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
                                                                                              CAP004
     D ExtData       E DS                  EXTNAME(SEDMEXPD)                                  CAP004
     D RegData       E DS                  EXTNAME(SEDMRXPD)                                  CER001
 
     D CrDlFilFmt    E DS                  EXTNAME(SEDPX1L0)                                  CER001
      ** Current Depot in File Format (WN)                                                    CER001
     D NwDlFilFmt    E DS                  EXTNAME(SEVDMLX1PD)                                CER001
      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SDSTAT data area                                                                     CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC022
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
     D  ComitJob               4    103                                                       CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
                                                                                              CSC011
      ** Additional entry parameter for Midas Compliance Watch                                CSD015
     D PMCWL           DS          9999                                                       CSD015
     D/COPY QWINDSRC,SEDMSINDTA
 
     D DATALUX         DS          1024                                                       CER001
     D  #1FLD2                 1      6  0                                                    CER001
     D  #1DPSS                 1     10                                                       CER001
     D  #1DPRN                11     16                                                       CER001
     D  #1DPMV                17     18                                                       CER001
     D  #1FOTR                19     38                                                       CER001
     D  #1TMST                39     64Z                                                      CER001
     D  #1DEXT                65     65                                                       CER001
      *                                                                                       CER001
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
                                                                                              CGL031
     D CGL031          S              1A                                                      CGL031
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
     D @TStmpSel       S             26Z
 
      ** -------------------------------------------------------------------
      ** Fields for getting the starting field number from file (parameters
      ** to ZAGETFLDNO, plus the offset to the requested field).
     D Format          S             10A
 
     D Field           S             10A   INZ('DDACTN')
     D FieldExt        S             10A   INZ('DDACTN')                                      CER001
 
     D FieldNo         S              5P 0
 
     D FldOffset       S              5P 0
     D FldOffsetExt    S              5P 0                                                    CER001
 
     D*WDPRN****       S              6S 0                                                   CSD027A
     D WDPRN           S              6A                                                     CSD027A
 
     D CSC011          S              1A                                                      CSC011
     D KMsgType        S              8A                                                      CSC011
     D KFrntOffID      S             20A                                                      CSC011
     D KTimeStamp      S                   LIKE(ABTMESTMP)                                    CSC011
                                                                                              CSC011
      ** End of fields for getting starting field number
      ** -------------------------------------------------------------------
                                                                                              CSC022
     D CSC022          S              1A                                                      CSC022
                                                                                              CSC022
     D WCommitSkip     S              1A                                                      CSC022
      ** Commitment Skip Field                                                                CSC022
 
      ** Introduced by CER001                                                                 CER001
      *                                                                                       CER001
     D ULX602          S              1A                                                      CER001
     D ULX008          S              1A                                                      CER001
     D P@RETCODEIN     S              1A                                                      CER001
     D P@ACTCDE        S              1A                                                      CER001
     D WFIND           S              1A                                                      CER001
     D PDDACTN         S              1A                                                      CER001
     D/COPY WNCPYSRC,SEH00062
      *                                                                                       CER001
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SEDPMVR009
 
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
      /COPY WNCPYSRC,SEDPMVR001
      *
      ** Browse
      *
     C     WScrnMode     IFEQ      'B'
     C                   EXSR      SRBrowse
     C                   END
      *
      /COPY WNCPYSRC,SEDPMVR002
      *
      ** Read Next Browse Subfile Record
      *
     C     WScrnMode     IFEQ      'R'
     C                   EXSR      SRRdBrwRec
     C                   END
      *
      /COPY WNCPYSRC,SEDPMVR003
      *
      ** Do While Screen: Main Details
      *
     C     WScrnMode     DOWEQ     'M'
     C                   EXSR      SRMainScrn
     C                   END
      *
      /COPY WNCPYSRC,SEDPMVR004
      *                                                                                       CSE012
      ** Do While Screen: Second Screen                                                       CSE012
      *                                                                                       CSE012
     C     WScrnMode     DOWEQ     'S'                                                        CSE012
     C                   EXSR      SRSecScrn                                                  CSE012
     C                   ENDDO                                                                CSE012
      *
      ** Window
      *
     C     WScrnMode     IFEQ      'W'
     C                   EXSR      SRWindow
     C                   END
      *
      /COPY WNCPYSRC,SEDPMVR005
      *
      ** Confirmation
      *
     C     WScrnMode     DOWEQ     'C'
     C                   EXSR      SRConfScrn
     C                   END
      *
      /COPY WNCPYSRC,SEDPMVR006
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
      /COPY WNCPYSRC,SEDPMVR007
      *                                                                                       CER001
      ** Display extension fields' validation                                                 CER001
      *                                                                                       CER001
     C                   IF        WScrnMode = 'L'                                            CER001
     C                   EXSR      SREXTLUX                                                   CER001
     C                   ENDIF                                                                CER001
      *
      ** Terminate Program
      *
     C     WScrnMode     IFEQ      'T'
     C                   MOVE      '1'           *INLR
     C                   END
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SEDPMVR010
 
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
      *         SRValEntry                                            *
      *         SRCancel                                              *
      *         SREnd                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRMainScrn    BEGSR
      *
      ** Issue A RollBack to clear any updates in window Function.
      *
     C                   IF        BGWDPR = 'Y'
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
 
     C                   SELECT
 
     C****************** WHEN      DDACTN = 'I'                                 CAP014
     C******************           OR DDACTN = 'A'                              CAP014
     C                   WHEN      @OptSel = 'U' AND (DDACTN = 'I'              CAP014
     C                                               OR DDACTN = 'A')           CAP014
     C                   EVAL      @EDTFD = 'Y'
     C                   EVAL      @EINKJ = 'N'
 
     C                   WHEN      DDACTN = 'D'
     C                   EVAL      @EDTFD = 'N'
     C                   EVAL      @EINKJ = 'Y'
 
     C/COPY WNCPYSRC,SEDPMVRC01
 
     C                   ENDSL
 
      *
      ** Update 'previous' Reference Number
      *
     C                   MOVEL     DDDPRN        WPrevDPRN         6
     C                   MOVEL     PortCusInd    WPrevCInd         1
      *
      ** Write/Read Display Screen
      *
     C     DPMVType      CASEQ     'WI'          SRWIScrn
     C     DPMVType      CASEQ     'WO'          SRWOScrn
     C                   ENDCS
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
 
     C     @INKC         CASEQ     '1'           SREnd
     C     @INKL         CASEQ     '1'           SRCancel
     C                   CAS                     SRValEntry
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
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
 
     C                   MOVEL     DDDPRN        WPrevDPRN
 
     C                   CALLB     'SEDMWIDSP'
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      ** Security                                                                             CSE039
     C                   PARM                    DPMVSety         10                          CSE039
      ** Transaction Number                                                                   CSE039
     C                   PARM                    DPMVTrno          6                          CSE039
 
     ** Received parameters
     ** -------------------
 
     ** Transaction Details
      * Transaction Status
      * Security Status
      * Transaction screen format
      * Exchange Rate
      * M/D Indicator
      * Portfolio Customer Indicator
      * Fields in error
     C                   PARM                    DDTranSts         7
     C                   PARM                    DDSecSts          7
     C                   PARM                    NwScrnRec
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
     C                   PARM                    PortCusInd
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
     C                   PARM      'N'           @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      * ENABLED FUNCTION KEYS
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      * KN = COMMAND KEY 14 = SETTLEMENT DETAILS
      * KP = COMMAND KEY 15 = BROWSE
     C                   PARM      'N'           @EINKG            1
     C                   PARM      'N'           @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM      'N'           @EINKN            1
     C                   PARM      'N'           @EINKP            1
      *
      ** SUCCESFUL INSERT DEAL
     C                   PARM                    @SIDN
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
     C                   PARM      '0'           @INKW             1                          CSE039
     C                   PARM      'Y'           @INKWDisp         1                          CSE039
      *
      ** Write screen with no read indicator
      *
     C                   PARM      'N'           WriteOnly         1
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
      * Portfolio Customer Indicator
      * Private Banking Customer Indicator                                      CPB001
      * Private Banking Field process Indicator                                 CPB001
      * FIELDS IN ERROR
     C                   PARM                    DDTranSts
     C                   PARM                    DDSecSts
     C                   PARM                    NwScrnRec
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
     C                   PARM                    PortCusInd
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
     C                   PARM      'N'           @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      ** ENABLED FUNCTION KEYS
      ** KG = COMMAND KEY 07 = READ PREVIOUS
      ** KH = COMMAND KEY 08 = READ NEXT
      ** KJ = COMMAND KEY 10 = CONFIRM DELETE
      ** KN = COMMAND KEY 14 = SETTLEMENT DETAILS
      ** KP = COMMAND KEY 15 = BROWSE
     C                   PARM      'N'           @EINKG            1
     C                   PARM      'N'           @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM      'N'           @EINKN            1
     C                   PARM      'N'           @EINKP            1
      *
      * SUCCESFUL INSERT DEAL
     C                   PARM                    @SIDN
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
     C                   PARM      '0'           @INKW             1                          CSE039
     C                   PARM      'Y'           @INKWDisp         1                          CSE039
      *
      * Write screen with no read indicator
      *
     C                   PARM      'N'           WriteOnly         1
                                                                                              CGL031
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
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
     C     SRBrowse      BEGSR
      *
      ** Reset Read Next Browse Subfile Record
      *
     C                   MOVEL     *BLANK        WRdNxBwRec        1
 
     C                   CALLB     'SEDPMVRPB'
 
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM                    DPMVType          2
     C                   PARM      'Y'           @BldSfl           1
     C                   PARM      *BLANK        @RdSfl            1
      *
      * Error in update of previous deal                                        CAP006
     C                   PARM                    @ERRUP            1            CAP006
      *
      ** Returned Parameters
      ** -------------------
      *
      ** Command Keys
      ** F3
      ** F12
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      ** Error Code
      *
     C                   PARM                    @ERRMS            7
      ** Option Selected
      ** Action Code Selected
      ** Front Office Id Selected
      ** Time Stamp of the Transaction selected
      ** Transaction Reference Number Selected
      ** Security Shortname Selected
     C                   PARM                    @OptSel           1
     C                   PARM                    @ActSel           1
     C                   PARM                    @FrntIdSel       20
     C                   PARM                    @TStmpSel
     C                   PARM                    @DPRNSel          6
     C                   PARM                    @DPSSSel         10
      *                                                                         166907
      ** Successfully Inserted Deal Number                                      166907
      *                                                                         166907
     C                   PARM                    @SIDN             6            166907
     C                   PARM                    CSC011                                       CSC011
      *
      ** If error message returned from browse, send it to detail screen
      *
     C     @ERRMS        IFEQ      *BLANK
     C                   MOVE      '1'           *INU6
     C                   END
      *
      ** If CK/12 not taken in browse
      ** Read next browse subfile record
      *
     C     @INKL         IFEQ      '1'
     C     @INKC         OREQ      '1'
     C     @ERRMS        ORNE      *BLANK
 
     C                   EXSR      SREnd
 
     C                   ELSE
     C                   MOVE      'Y'           WRdNxBwRec
     C                   MOVEL     'R'           WScrnMode
     C                   END
 
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                                                  CSE012
      *****************************************************************                       CSE012
      *                                                               *                       CSE012
      * SRSecScrn - Second Screen Processing                          *                       CSE012
      *                                                               *                       CSE012
      * Called by: Main Processing                                    *                       CSE012
      *                                                               *                       CSE012
      * Calls:  None                                                  *                       CSE012
      *                                                               *                       CSE012
      *****************************************************************                       CSE012
      *                                                                                       CSE012
     C     SRSecScrn     BEGSR                                                                CSE012
      *                                                                                       CSE012
     C     BGWDPR        IFEQ      'Y'                                                        CSE012
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
     C                   PARM                    DDDPNR2          35                          CSE012
     C                   PARM                    DDDPNR3          35                          CSE012
     C                   PARM                    DDDPNR4          35                          CSE012
     C                   PARM                    DDDPNR5          35                          CSE012
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
     C                   PARM      'N'           @EINKG            1                          CSE012
     C                   PARM      'N'           @EINKH            1                          CSE012
     C                   PARM      'N'           @EINKJ            1                          CSE012
     C                   PARM      'N'           @EINKN            1                          CSE012
     C                   PARM      'N'           @EINKP            1                          CSE012
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
      *                                                                                       CSE012
     C     @INKC         CASEQ     '1'           SREnd                                        CSE012
     C     @INKL         CASEQ     '1'           SRCancel                                     CSE012
     C                   CAS                     SRValSEntry                                  CSE012
     C                   ENDCS                                                                CSE012
      *                                                                                       CSE012
     C                   ENDSR                                                                CSE012
      *****************************************************************                       CSE012
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdBrwRec - Processed all selected Browse records.           *
      *                                                               *
      * Called by: SRMainScrn                                         *
      *                                                               *
      * Calls:  SRRetrieve                                            *
      *         SRConvert                                             *
      *         SRMsgMain                                             *
      *                                                               *
      *****************************************************************
     C     SRRdBrwRec    BEGSR
 
     C                   CALLB     'SEDPMVRPB'
 
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM                    DPMVType          2
     C                   PARM      *BLANK        @BldSfl           1
     C                   PARM      'Y'           @RdSfl            1
      *
      * Error in update of previous deal                                        CAP006
     C                   PARM                    @ERRUP            1            CAP006
      *
      ** Returned Parameters
      ** -------------------
      *
      ** Command Keys
      ** F3
      ** F12
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      ** Error Code
      *
     C                   PARM      *BLANK        @ERRMS            7
      ** Option Selected
      ** Action Code Selected
      ** Front Office Id Selected
      ** Time Stamp of the selected Transaction
      ** Transaction Reference Number Selected
      ** Security Shortname Selected
     C                   PARM      *BLANK        @OptSel           1
     C                   PARM      *BLANK        @ActSel           1
     C                   PARM      *BLANK        @FrntIdSel       20
     C                   PARM                    @TStmpSel
     C                   PARM      *BLANK        @DPRNSel          6
     C                   PARM      *BLANK        @DPSSSel         10
      *                                                                         166907
      ** Successfully Inserted Deal Number                                      166907
      *                                                                         166907
     C                   PARM                    @SIDN             6            166907
     C                   PARM                    CSC011                                       CSC011
      *                                                                         CAP004
      * If CK/3 taken within invalid transaction deletion function,             CAP004
      * End program                                                             CAP004
      *                                                                         CAP004
     C     @INKC         IFEQ      '1'                                          CAP004
     C                   EXSR      SREnd                                        CAP004
     C                   GOTO      ERDNBRW                                      CAP004
     C                   END                                                    CAP004
 
     C     @OptSel       IFNE      *BLANK
      *
      ** Reset Main Transaction Details
      *
     C                   MOVE      *BLANK        NewDPMVRec
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
      ** Retrieve Deal Details
      *
     C                   MOVE      @FrntIdSel    FOTRID
     C                   MOVE      @ActSel       DDACTN
     C                   MOVE      @DPRNSel      DDDPRN
     C                   MOVE      @DPSSSel      DDDPSS
     C*******************MOVE      '*FRONT'      ModeofOp                       CAP013
      *                                                                         163820
      * Make sure Invalid transaction's  details are passed to 'Retreive'       163820
      * module for SPF checking .                                               163820
      *                                                                         163820
     C     IFileKey      CHAIN     SEIDPMVL0                          99        163820
      *                                                                                       CER001
      ** Retrieve record in extension file                                                    CER001
      *                                                                                       CER001
     C                   IF        ULX602 = 'Y'                                               CER001
     C                   MOVE      DDDPSS        K@DPSS                                       CER001
     C                   MOVE      DDDPRN        K@DPRN                                       CER001
     C     K@KEY         CHAIN(N)  RTVIDX                             85                      CER001
     C                   IF        *IN85 = *OFF                                               CER001
     C                   EXSR      SRFTOS                                                     CER001
     C                   ELSE                                                                 CER001
     C                   EXSR      SRINZ                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Now overwrite the fields on the details screen with those                            CER001
      ** on the invalid extended depots file                                                  CER001
      *                                                                                       CER001
     C     IFileKey      CHAIN     RTVIDX1                            85                      CER001
      *                                                                                       CER001
     C                   IF        *IN85 = *OFF                                               CER001
     C                   EVAL      L6LXOPTP = #6LXOPTP                                        CER001
     C                   EVAL      L6LXEXCF = #6LXEXCF                                        CER001
     C                   IF        ULX008 = 'Y'                                               CER001
     C                   EVAL      L6LXTTIM = #6LXTTIM                                        CER001
     C                   EVAL      L6LXCABR = #6LXCABR                                        CER001
     C                   EVAL      L6LXCNBR = #6LXCNBR                                        CER001
     C                   ENDIF                                                                CER001
     C                   MOVE      'Y'           #1DEXT                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                         CAP013
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)            CAP013
      *  if insert                                                              CAP013
      *  if not insert and Midas transaction ID is not present                  CAP013
      * Otherwise                                                               CAP013
      *  Set retrieve mode to blank  (Access using Midas transaction ID).       CAP013
      *                                                                         CAP013
     C     DDACTN        IFEQ      'I'                                          CAP013
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
     C                   ELSE                                                   CAP013
     C     DDDPRN        IFEQ      *BLANK                                       CAP013
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
     C                   ELSE                                                   CAP013
     C                   MOVEL     '      '      ModeofOp                       CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
      *
      ** Validate key fields
      *
     C                   EXSR      SRRetrieve
      *
      ** If the deal is already existing, display the details.
      *
     C     OldRECI       IFNE      *BLANK
     C     DDACTN        ANDNE     'I'
      *
      ** Convert file details to screen details.
      *
     C                   EXSR      SRConvert
     C                   END
     C
     C     IFileKey      KLIST
     C                   KFLD                    @TStmpSel
     C                   KFLD                    @FrntIdSel
      *
      ** By performing a Chain operation into the invalid file, the screen
      ** details are updated accordingly. The Depot Reference Number should
      ** be retain.
      *
     C                   MOVEL     DDDPRN        ##DDDPRN          6
 
     C     IFileKey      CHAIN     SEIDPMVL0                          99
 
     C     OldRECI       IFNE      *BLANK                                       CAP011
     C     DDACTN        ANDNE     'I'                                          CAP011
     C                   MOVEL     ##DDDPRN      DDDPRN
     C                   END                                                    CAP011
      *                                                                         CAP011
      * If depot movement details were retrieved and this is an amendment       CAP011
      * Do data substitution if the substitution character is present           CAP011
      *                                                                         CAP011
     C     OldRECI       IFNE      *BLANK                                       CAP011
     C     DDACTN        ANDEQ     'A'                                          CAP011
     C     GHSUBS        ANDNE     *BLANK                                       CAP011
     C     GHSUBS        SCAN      NwScrnRec                              99    CAP011
     C     *IN99         IFEQ      *ON                                          CAP011
     C                   EXSR      TDtDtaSubs                                   CAP011
     C                   END                                                    CAP011
     C                   END                                                    CAP011
      *
      ** Set Field and Function key status Accordingly
      *
      *
      * If action code, or Ref. number were not OK
      * blank out action code so that the input cannot proceed
      *
     C     DDACTNOk      IFEQ      'N'
     C     DDDPRNOk      OREQ      'N'
     C                   MOVEL     *BLANK        DDACTN
     C                   END
 
     C                   EXSR      SRMsgMain
 
     C                   MOVE      'M'           WScrnMode
 
     C                   ELSE
      *
      ** Reset Read Next Browse Record Indicator
      *
     C                   MOVE      'B'           WScrnMode
     C                   END
 
 
     C     ERDNBRW       ENDSR                                                  CAP004
     C*******************ENDSR                                                  CAP004
 
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
     C                   CALLB     'SEDPMVVAL'
 
     C                   PARM                    NwScrnRec
     C                   PARM                    ExtData                        CAP004
     C*******************PARM                    SECTY                                        167486
     C                   PARM                    SECTY_DS                                     167486
     C                   PARM                    DPMVType          2
     C                   PARM                    DDDRID                                       246166
     C                   PARM                    RespMode
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
     C                   PARM                    PortCusInd        1
     C                   PARM                    PBCusInd          1            CPB001
     C                   PARM                    PBFieldInd        1            CPB001
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
      *
      ** Check Error Index
      *
     C     Idx           IFEQ      *ZERO
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = '*ANY'
     C                   EVAL      WMsgIDArr (WIdx) = 'MMM1030'
     C                   END
      *                                                                                       CSE012
      ** If CSE012 is installed, Call SEDPMV2VL                                               CSE012
      *                                                                                       CSE012
     C     CSE012        IFEQ      'Y'                                                        CSE012
      *                                                                                       CSE012
     C                   CALLB     'SEDPMV2VL'                                                CSE012
      *                                                                                       CSE012
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
      *                                                                                       CSE012
     C                   CALLB     'SEDPMV2DP'                                                CSE012
     C                   PARM                    RetrnCod          6                          CSE012
     C                   PARM                    DDACTN            1                          CSE012
     C                   PARM                    DDDPSS           10                          CSE012
     C                   PARM                    DDDPRN            6                          CSE012
     C                   PARM                    DDDPNR2          35                          CSE012
     C                   PARM                    DDDPNR3          35                          CSE012
     C                   PARM                    DDDPNR4          35                          CSE012
     C                   PARM                    DDDPNR5          35                          CSE012
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
     C                   PARM      '0'           @INKC                                        CSE012
     C                   PARM      '0'           @INKG                                        CSE012
     C                   PARM      '0'           @INKH                                        CSE012
     C                   PARM      '0'           @INKL                                        CSE012
     C                   PARM      '0'           @INKN                                        CSE012
     C                   PARM      '0'           @INKP                                        CSE012
     C                   PARM      'N'           WriteOnly                                    CSE012
      *                                                                                       CSE012
     C                   ELSE                                                                 CSE012
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
     C                   PARM                    PortCusInd
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
     C                   PARM                    @SIDN
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
      ** Security                                                                             222373
     C                   PARM                    DPMVSety                                     222373
      ** Transaction Number                                                                   222373
     C                   PARM                    DPMVTrno                                     222373
     C                   PARM                    DDTranSts
     C                   PARM                    DDSecSts
     C                   PARM                    NwScrnRec
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
     C                   PARM                    PortCusInd
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
     C                   PARM                    @SIDN
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKW             1                          222373
     C                   PARM      'Y'           @INKWDisp         1                          222373
     C                   PARM      'N'           WriteOnly         1
     C                   PARM                    CGL031                                       CGL031
     C                   END
      *                                                                         CSE012
     C                   ENDIF                                                  CSE012
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
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SRUpdate      BEGSR
 
 
     C                   IF        DDDPRN = *BLANKS
     C                             AND DDACTN = 'I'
 
     C**********         IF        WDPRN = *ZERO                                             CSD027A
     C                   IF        WDPRN = *BLANKS                                           CSD027A
     C                   EXSR      SRGenRefNo
     C                   END
 
     C                   MOVE      WDPRN         DDDPRN
     C                   MOVE      DDDPRN        DPRN
     C                   MOVE      DPRN          @SIDN             6
 
     C                   END
      *
      ** Update Change Type to reflect changes in the system files
      *
     C                   MOVE      DDACTN        CHTP
     C/COPY WNCPYSRC,SEH00063
      *                                                                         CAP013
      ** Update front office transaction ID                                     CAP013
      *                                                                         CAP013
     C                   MOVEL     @FrntIdSel    DMFRNT                         CAP013
 
     C                   CALLB     'SEDPMVUPD'
     C/COPY WNCPYSRC,SEH00064
     C                   PARM      *BLANKS       RetCodeIn
     C/COPY WNCPYSRC,SEH00065
     C                   PARM                    NewDPMVRec
      ** Added parameter for Midas Compliance Watch                                           CSD015
     C                   PARM                    PMCWL                                        CSD015
     C                   PARM                    DSNOTM
     C                   PARM                    DSMSGK
     C                   PARM                    CGL031                                       235844
 
     C                   IF        RetCodeIn = *BLANKS AND ULX602 = 'Y'                       CER001
     C                   EXSR      SRUPDAT                                                    CER001
     C                   ENDIF                                                                CER001
                                                                                              CER001
     C     RetCodeIn     IFNE      *BLANKS                                                    168345
     C*****RetCodeIn     IFEQ      '*ERROR '                                                  168345
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        (WCommitSkip <> 'Y')                                       CSC022
     C                   ROLBK                                                                CSC022
     C                   Else                                                                 CSC022
     C                   Seton                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C     RetCodeIn     IFEQ      '*ERROR '                                                  168345
     C                   EXSR      *PSSR
     C                   END                                                                  168345
      *                                                                                       168345
     C                   ELSE
 
     C                   MOVEL     ' '           PortCusInd
     C**********         Z-ADD     *ZERO         WDPRN                                       CSD027A
     C                   Eval      WDPRN = *Blanks                                           CSD027A
 
     C     IFileKey2     KLIST
     C                   KFLD                    @FrntIdSel
     C                   KFLD                    @TStmpSel
 
     C     IFILEKey2     CHAIN     SEIDPMVD1                          99
 
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANKS       DBKEY
     C                   MOVEL     @FrntIdSel    DBKEY
     C                   MOVE      @TStmpSel     DBKEY
     C                   MOVEL     'SEIDPMVPD'   DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   ROLBK
     C                   EndIf                                                                CSC022
     C                   EXSR      *PSSR                                        ************
 
     C                   ELSE
 
     C                   DELETE    SEIDPMVD1                            99
 
     C                   IF        *IN99 = *OFF AND                                           CER001
     C                             ULX602 = 'Y'
     C     IFileKey      CHAIN     RTVIDX1                            98                      CER001
     C                   IF        *IN98 = *OFF                                               CER001
     C                   DELETE    RTVIDX1                              99                    CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
                                                                                              CER001
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANKS       DBKEY
     C                   MOVEL     @FrntIdSel    DBKEY
     C                   MOVE      @TStmpSel     DBKEY
     C                   MOVEL     'SEIDPMVPD'   DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 002*
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   ROLBK
     C                   EndIf                                                                CSC022
     C                   EXSR      *PSSR                                        ************
     C                   ELSE
                                                                                              CSC011
      ** Delete invalid record from the log file.                                             CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (LIBR = S1SUPP)                         CSC011
                                                                                              CSC011
     C                   IF        DPMVType = 'WI'                                            CSC011
     C                   EVAL      KMsgType = 'SEDMWI'                                        CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      KMsgType = 'SEDMWO'                                        CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   EVAL      KFrntOffID = @FrntIdSel                                    CSC011
     C                   EVAL      KTimeStamp = @TStmpSel                                     CSC011
                                                                                              CSC011
     C     KAPILOGL0     CHAIN     APILOGL0                           99                      CSC011
     C                   IF        *IN99 = *OFF                                               CSC011
     C                   DELETE    APILOGL0                                                   CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   END
 
     C                   END
     C                   END
      *
      * If error occurred in updating last transaction set on flag to           CAP006
      * display message on 'browse' screen.                                     CAP006
     C     @RTCD         IFEQ      '*RECUPD'                                    CAP006
     C                   MOVE      'Y'           @ERRUP                         CAP006
     C                   ELSE                                                   CAP006
     C                   MOVE      'N'           @ERRUP                         CAP006
     C                   END                                                    CAP006
     C                                                                          CAP006
      ** Clear screen fields/status.
      *
     C                   CLEAR                   NwScrnRec
     C                   MOVEL     *BLANK        DDSPXR
     C                   MOVEL     *BLANK        DDSPMD
      *
      ** Initialise field status and function keys status
      *
 
     C     WRdNxBwRec    IFEQ      'Y'
     C                   MOVE      'R'           WScrnMode
     C                   ELSE
     C                   MOVE      'M'           WScrnMode
     C                   END
 
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
     C                   MOVEL     '906'         DBASE                                        167486
     C                   EXSR      *PSSR                                                      167486
                                                                                              167486
     C                   ELSE                                                                 167486
                                                                                              167486
     C     @OptSel       IFEQ      'N'                                                        167486
     C     DDACTN        IFEQ      'I'                                                        167486
                                                                                              167486
     C                   EXSR      SRUpdExtF                                                  167486
                                                                                              167486
     C                   END                                                                  167486
     C                   EVAL      PACTN = 'E'                                                167486
     C                   ELSE                                                                 167486
     C                   MOVE      DDACTN        PACTN                                        167486
     C                   END                                                                  167486
                                                                                              167486
     C                   MOVE      DPSS          PPDPSS                                       167486
     C                   MOVE      DPRN          PPDPRN                                       167486
     C                   MOVE      DPBA          PDPBA                                        167486
     C                   MOVE      DPBN          PDPBN                                        167486
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
     C                   Z-ADD     ORED          PORED                                        167486
     C                   Z-ADD     MKTP          PMKTP                                        167486
     C                   MOVE      DPMS          PDPMS                                        CSE028
     C                   MOVEL     *BLANKS       DFT                                          167486
     C                   MOVEL     *BLANKS       MSGS                                         167486
                                                                                              167486
     C                   CALL      'SE1807'                                                   167486
     C                   PARM      '00'          PCMD              2                          167486
     C                   PARM      'N'           PERR              1                          167486
     C                   PARM                    PDATA                                        167486
     C                   PARM                    DFT               1                          167486
     C                   PARM                    MSGS             10                          167486
      ** Added parameter for Midas Compliance Watch                                           CSD015
     C                   PARM                    PMCWL                                        CSD015
                                                                                              167486
     C                   SELECT                                                               167486
                                                                                              167486
     C                   WHEN      PCMD = '03'                                                167486
     C                   EXSR      SREnd                                                      167486
                                                                                              167486
     C                   WHEN      PCMD = '12'                                                167486
     C                   EVAL      WScrnMode = 'M'                                            167486
                                                                                              167486
     C                   WHEN      PERR = 'U'                                                 167486
     C                   MOVEL     '*ANY'        FldNameArr(1)                                167486
     C                   MOVEL     'SE03030'     MsgIdArr(1)                                  167486
     C                   EVAL      WScrnMode = 'M'                                            167486
                                                                                              167486
     C                   WHEN      DDACTN = 'I'                                               167486
     C                             OR DDACTN = 'A'                                            167486
     C/COPY WNCPYSRC,SEDPMVRC02
     C                   EVAL      WScrnMode = 'U'                                            167486
                                                                                              167486
     C                   OTHER                                                                167486
     C                   EVAL      WScrnMode = 'M'                                            167486
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
     C**********         PARM      *ZERO         WDPRN                                       CSD027A
     C                   PARM      *Blanks       WDPRN                                       CSD027A
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
      * SRCanConf - Cancel Confiramtion screen                        *
      *                                                               *
      * Called by: SRConfScrn                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRCanConf     BEGSR
      *
      ** Proceed to Main Screen Validation
      *
     C     CSE012        IFEQ      'Y'                                                        CSE012
     C                   MOVE      'S'           WScrnMode                                    CSE012
     C                   ELSE                                                                 CSE012
     C                   MOVE      'M'           WScrnMode
     C                   ENDIF                                                                CSE012
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRExitConf - Exit Confirmation screen                         *
      *                                                               *
      * Called by: SRConfScrn                                         *
      *                                                               *
      * Calls: None                                                   *
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
 
     C                   ELSE
                                                                                              167486
     C     S01401        IFEQ      'Y'                                                        167486
     C     DDACTN        ANDNE     'D'                                                        167486
     C                   MOVE      'E'           WScrnMode                                    167486
     C                   ELSE                                                                 167486
     C                   MOVE      'U'           WScrnMode
     C                   END                                                                  167486
                                                                                              167486
     C/COPY WNCPYSRC,SEDPMVRC03
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
      *                                                                         CAP011
      * Update 'Current' Depot Movement in Screen Format                        CAP011
      *                                                                         CAP011
     C                   MOVEL     NwScrnRec     CrScrnRec                      CAP011
 
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
      *
     C/COPY WNCPYSRC,SEH00133
     C                   CALLB     'SEDPMVRTV'
     C                   PARM                    DDACTN
     C                   PARM                    DDDPRN
     C                   PARM                    DDDPBA
     C                   PARM                    DDORBR
     C                   PARM                    ModeOfOp          6
     C                   PARM      'S'           RespMode
     C                   PARM                    FOTRID           20
     C                   PARM                    DPMVType                                     174742
     C                   PARM      'SEDPMVRPR'   CallProg         10                          CSE039
     C                   PARM                    DDDPSS                                       CAP087
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *ZERO         Idx               3 0
     C                   PARM                    OldDPMVRec
     C/COPY WNCPYSRC,SEH00134
     C                   PARM      *BLANK        DDACTNOk
     C/COPY WNCPYSRC,SEH00135
     C                   PARM      *BLANK        DDDPRNOk
     C                   PARM      *BLANK        DDDPBAOk
     C                   PARM      *BLANK        DDORBROk
 
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
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCancel      BEGSR
 
      *
      ** If records are still to be read from the subfile, continue
      ** Else, Return to Browse Mode.
      *
     C     WRdNxBwRec    IFEQ      'Y'
     C                   MOVE      'R'           WScrnMode
     C                   ELSE
     C                   MOVE      'B'           WScrnMode
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValEntry - Validation Routine                               *
      *                                                               *
      * Called by: SRMainScrn                                         *
      *                                                               *
      * Calls:  SRRetrieve                                            *
      *         SRConvert                                             *
      *         SRUpdate                                              *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
      ** Retrieve deal details
      *
     C     SRValEntry    BEGSR
 
     C                   MOVE      *BLANKS       ModeofOp
 
     C                   EXSR      SRRetrieve
      *
      ** If action code, and Ref. number are not valid
      ** Re-output screen with error messages on it
      *
     C     DDACTNOk      IFEQ      'Y'
     C     DDDPRNOk      ANDEQ     'Y'
      *
      ** ---------------------------------------------------------------
      *
      ** Put the deal on the main details screen if Deletion/Enquiry.
      ** Also if amending a new transaction.
      *
     C     DDACTN        IFEQ      'D'
     C     DDACTN        OREQ      'A'
     C     DDDPRN        ANDNE     WPrevDPRN
      *
      ** Convert the deal to screen format
     C/COPY WNCPYSRC,SEDPMVRC04
      *
     C                   EXSR      SRConvert
     C                   END
      *
      ** If Ref number or screen control indicators have changed
      ** Re-output screen
      *
     C     DDDPRN        IFNE      WPrevDPRN
     C     DDACTN        ANDNE     'I'
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
      *
      ** IF CK/10 TAKEN, GO ONTO UPDATES
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVEL     'U'           WScrnMode
     C                   END
 
     C                   END
     C/COPY WNCPYSRC,SEDPMVRC05
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
      *                                                                                       CSE012
      ** If Insert, just move the key fields to the new File Format                           CSE012
      *                                                                                       CSE012
     C                   ELSE                                                                 CSE012
     C                   MOVE      DDDPRN        DPRN                                         CSE012
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
     C                   PARM                    RespMode          1
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
     C                   PARM                    PortCusInd        1
     C                   PARM                    PBCusInd          1            CPB001
     C                   PARM                    PBFieldInd        1            CPB001
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
 
 
     C                   IF        Idx <> 0
     C                             OR  PortCusInd <> WPrevCInd
     C                             AND WPrevCInd <> *BLANKS
      *
      ** Re-Display screen to contain error messages.
      *
     C                   MOVEL     'M'           WScrnMode
 
     C                   ELSE
      *                                                                                       CSE012
      ** If CSE012 is installed, set screen mode to 'S'                                       CSE012
      *                                                                                       CSE012
     C     CSE012        IFEQ      'Y'                                                        CSE012
     C                   MOVEL     'S'           WScrnMode                                    CSE012
     C                   Else                                                                 CSE012
      *
      ** Proceed to window routine if applicable.
      *
     C                   IF        ULX602 = 'Y'                                               CER001
     C                   EVAL      WScrnMode = 'L'                                            CER001
     C                   ELSE                                                                 CER001
     C                   IF        BGWDPR = 'Y'
     C                   MOVEL     'W'           WScrnMode
     C                   ELSE
      *
      ** Proceed to Confirmation.
      *
     C                   IF        @OPTSEL <> 'N'                                            BUG9079
     C                   MOVE      'C'           WScrnMode
     C                   ELSE                                                                BUG9079
     C     WRdNxBwRec    IFEQ      'Y'                                                       BUG9079
     C                   MOVEL     'R'           WScrnMode                                   BUG9079
     C                   ELSE                                                                BUG9079
     C                   MOVEL     'B'           WScrnMode                                   BUG9079
     C                   ENDIF                                                               BUG9079
     C                   ENDIF                                                               BUG9079
     C                   END
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CSE012
     C                   END
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
      *                                                                                       CSE012
     C     CSE012        IFEQ      'Y'                                                        CSE012
     C                   CALLB     'SEDPMV2DP'                                                CSE012
     C                   PARM                    RetrnCod          6                          CSE012
     C                   PARM                    DDACTN            1                          CSE012
     C                   PARM                    DDDPSS           10                          CSE012
     C                   PARM                    DDDPRN            6                          CSE012
     C                   PARM                    DDDPNR2          35                          CSE012
     C                   PARM                    DDDPNR3          35                          CSE012
     C                   PARM                    DDDPNR4          35                          CSE012
     C                   PARM                    DDDPNR5          35                          CSE012
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
     C                   PARM      '0'           @INKC                                        CSE012
     C                   PARM      '0'           @INKG                                        CSE012
     C                   PARM      '0'           @INKH                                        CSE012
     C                   PARM      '0'           @INKL                                        CSE012
     C                   PARM      '0'           @INKN                                        CSE012
     C                   PARM      '0'           @INKP                                        CSE012
     C                   PARM      'Y'           WriteOnly                                    CSE012
      *                                                                                       CSE012
     C                   ELSE                                                                 CSE012
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
      *
      ** Write out screen to remove error messages
      *
     C     DPMVType      IFEQ      'WI'
 
     C                   CALLB     'SEDMWIDSP'
     C                   PARM      *BLANK        RetCodeIn
      ** Security                                                                             222373
     C                   PARM                    DPMVSety                                     222373
      ** Transaction Number                                                                   222373
     C                   PARM                    DPMVTrno                                     222373
     C                   PARM                    DDTranSts         7
     C                   PARM                    DDSecSts          7
     C                   PARM                    NwScrnRec
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
     C                   PARM                    PortCusInd
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
     C                   PARM                    @SIDN
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKW             1                          222373
     C                   PARM      'Y'           @INKWDisp         1                          222373
     C                   PARM      'Y'           WriteOnly         1
     C                   PARM                    CGL031                                       CGL031
     C                   END
 
     C     DPMVType      IFEQ      'WO'
     C                   CALLB     'SEDMWODSP'
     C                   PARM      *BLANK        RetCodeIn
      ** Security                                                                             222373
     C                   PARM                    DPMVSety                                     222373
      ** Transaction Number                                                                   222373
     C                   PARM                    DPMVTrno                                     222373
     C                   PARM                    DDTranSts
     C                   PARM                    DDSecSts
     C                   PARM                    NwScrnRec
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
     C                   PARM                    PortCusInd
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
     C                   PARM                    @SIDN
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKW             1                          222373
     C                   PARM      'Y'           @INKWDisp         1                          222373
     C                   PARM      'Y'           WriteOnly         1
     C                   PARM                    CGL031                                       CGL031
     C                   END
      *                                                                         CSE012
     C                   ENDIF                                                  CSE012
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
     C**********         PARM      'SEDPMVSIN'   #PGM             10                          174857
     C                   PARM      'SEDPMVRPR'   #PGM             10                          174857
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
      *  If Cmd12 pressed, return to main details screen;
      *  otherwise, go to Confirmation screen
      *
     C     #RTRN         IFEQ      'USR0790'
     C     DDACTN        OREQ      'E'
 
     C     S01401        IFEQ      'Y'                                                        167486
     C                   EVAL      WScrnMode = 'E'                                            167486
     C                   ELSE                                                                 167486
                                                                                              167486
     C     WRdNxBwRec    IFEQ      'Y'
     C                   EVAL      WScrnMode = 'R'
     C                   ELSE
     C     CSE012        IFEQ      'Y'                                                        CSE012
     C                   EVAL      WScrnMode = 'S'                                            CSE012
     C                   ELSE                                                                 CSE012
     C                   EVAL      WScrnMode = 'M'
     C                   ENDIF                                                                CSE012
     C                   END
                                                                                              167486
     C                   END                                                                  167486
 
     C                   ELSE
 
     C/COPY WNCPYSRC,SEDPMVRC06
     C                   IF        @OPTSEL <> 'N'                                            BUG9079
     C                   EVAL      WScrnMode = 'C'
     C                   ELSE                                                                BUG9079
     C     WRdNxBwRec    IFEQ      'Y'                                                       BUG9079
     C                   MOVEL     'R'           WScrnMode                                   BUG9079
     C                   ELSE                                                                BUG9079
     C                   MOVEL     'B'           WScrnMode                                   BUG9079
     C                   ENDIF                                                               BUG9079
     C                   ENDIF                                                               BUG9079
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
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
      ** If the current control indicators are different to the previous                      CSE012
      ** control indicators, go to the end of the subroutine                                  CSE012
      *                                                                                       CSE012
     C*****DDACTN        IFNE      'I'                                                CSE012 BUG9096
     C**********         GOTO      EndValS                                            CSE012 BUG9096
     C**********         END                                                          CSE012 BUG9096
      *                                                                                       CSE012
      ** If Action Code is I or A                                                             CSE012
      *                                                                                       CSE012
     C     DDACTN        IFEQ      'I'                                                        CSE012
     C     DDACTN        OREQ      'A'                                                        CSE012
      *                                                                                       CSE012
     C                   Z-Add     *Zeros        Idx                                          CSE012
     C                   Z-Add     *Zeros        WIdx                                         CSE012
      *                                                                                       CSE012
     C                   CALLB     'SEDPMV2VL'                                                CSE012
      *                                                                                       CSE012
      ** Input Parameters                                                                     CSE012
      ** Return Code                                                                          CSE012
      ** Narrative 2                                                                          CSE012
      ** Narrative 3                                                                          CSE012
      ** Narrative 4                                                                          CSE012
      ** Narrative 5                                                                          CSE012
      *                                                                                       CSE012
     C                   PARM                    RetrnCod          6                          CSE012
     C                   PARM                    DDDPNR2          35                          CSE012
     C                   PARM                    DDDPNR3          35                          CSE012
     C                   PARM                    DDDPNR4          35                          CSE012
     C                   PARM                    DDDPNR5          35                          CSE012
     C                   PARM                    NewDPMVRec                                   CSE012
      *                                                                                       CSE012
      ** Output Parameters                                                                    CSE012
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSE012
      *                                                                                       CSE012
     C                   PARM                    FldNameArr                                   CSE012
     C                   PARM                    MsgIDArr                                     CSE012
     C                   PARM                    MsgDtaArr                                    CSE012
      *                                                                                       CSE012
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CSE012
      *                                                                                       CSE012
     C                   PARM                    WFldNamArr                                   CSE012
     C                   PARM                    WMsgIDArr                                    CSE012
     C                   PARM                    WMsgDtaArr                                   CSE012
      *                                                                                       CSE012
      ** Array index (3P0) from/to caller                                                     CSE012
      ** Array index (3P0) from/to caller                                                     CSE012
      *                                                                                       CSE012
     C                   PARM                    Idx                                          CSE012
     C                   PARM                    WIdx                                         CSE012
      *                                                                                       CSE012
     C     Idx           IFNE      *Zeros                                                     CSE012
     C                   EVAL      WScrnMode = 'S'                                            CSE012
     C                   ELSE                                                                 CSE012
     C                   IF        ULX602 = 'Y'                                               CER001
     C                   EVAL      WScrnMode = 'L'                                            CER001
     C                   ELSE                                                                 CER001
     C     BGWDPR        IFEQ      'Y'                                                        CSE012
     C                   EVAL      WScrnMode = 'W'                                            CSE012
     C                   ELSE                                                                 CSE012
     C                   IF        @OPTSEL <> 'N'                                            BUG9079
     C                   EVAL      WScrnMode = 'C'                                            CSE012
     C                   ELSE                                                                BUG9079
     C     WRdNxBwRec    IFEQ      'Y'                                                       BUG9079
     C                   MOVEL     'R'           WScrnMode                                   BUG9079
     C                   ELSE                                                                BUG9079
     C                   MOVEL     'B'           WScrnMode                                   BUG9079
     C                   ENDIF                                                               BUG9079
     C                   ENDIF                                                               BUG9079
     C                   ENDIF                                                                CSE012
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CSE012
     C                   ENDIF                                                                CSE012
      *                                                                                       CSE012
     C     EndValS       ENDSR                                                                CSE012
                                                                                              CSE012
      *****************************************************************                       CSE012
      /EJECT
      *****************************************************************                       167486
      *                                                               *                       167486
      * SRUpdExtF - Extension File Details update routine             *                       167486
      *                                                               *                       167486
      * Called by: Main processing                                    *                       167486
      *                                                               *                       167486
      * Calls: None                                                   *                       167486
      *                                                               *                       167486
      *****************************************************************                       167486
                                                                                              167486
     C     SRUpdExtF     BEGSR                                                                167486
                                                                                              167486
      *                                                                                       167486
      ** Clear extension file fields                                                          167486
      *                                                                                       167486
     C                   CLEAR                   DPTMVDD1                                     167486
      *                                                                                       167486
      ** Default fields                                                                       167486
      *                                                                                       167486
     C                   MOVE      DPSS          DPDPSS                                       167486
     C                   MOVE      DPRN          DPDPRN                                       167486
     C                   MOVE      'N'           DPCONG                                       167486
     C                   MOVE      'N'           DPRCDG                                       167486
     C                   Z-ADD     BJRDNB        DPLCD                                        167486
     C                   MOVE      'N'           DPGMES                                       167486
     C                   MOVE      'F'           DPFIND                                       167486
     C                   MOVE      'N'           DPGMEC                                       167486
                                                                                              167486
     C                   TIME                    WWTIME            6 0                        167486
     C                   MOVEL     WWTIME        DPTRTT                                       167486
                                                                                              167486
     C                   MOVE      'Y'           DPSCMG                                       167486
     C                   MOVE      'S'           DPWHEN                                       167486
      *                                                                                       167486
      ** Write details of record to extension file                                            167486
      *                                                                                       167486
     C                   WRITE     DPTMVDD1                                                   167486
                                                                                              167486
     C                   ENDSR                                                                167486
     C****************************************************************                        167486
      /EJECT                                                                                  167486
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
      ** Add error message to array passed to detail screen
      *
     C                   Z-ADD     Idx           E                 3 0
      *
      ** Read error messages for deal
      *
      *
      ** If there are fundamental errors in this transaction
      ** Identify this fact.
      *
     C     DDACTNOk      IFEQ      'N'
     C     DDDPRNOk      OREQ      'N'
     C                   ADD       1             E
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     'APM0110'     MsgIdArr(E)
     C                   ENDIF
 
     C                   MOVEA     OkIndFile     @EI
 
     C     ZATRNKD0      KLIST
     C                   KFLD                    @FrntIdSel
     C                   KFLD                    @TStmpSel
 
     C     ZATRNKX0      KLIST
     C                   KFLD                    @TStmpSel
     C                   KFLD                    @FrntIdSel
                                                                                              CSC011
     C     KAPILOGL0     KLIST                                                                CSC011
     C                   KFLD                    KMsgType                                     CSC011
     C                   KFLD                    KFrntOffID                                   CSC011
     C                   KFLD                    KTimeStamp                                   CSC011
      *                                                                                       CER001
     C     *LIKE         DEFINE    DDDPSS        K@DPSS                                       CER001
     C     *LIKE         DEFINE    DDDPRN        K@DPRN                                       CER001
      *                                                                                       CER001
     C     K@KEY         KLIST                                                                CER001
     C                   KFLD                    K@DPSS                                       CER001
     C                   KFLD                    K@DPRN                                       CER001
      *
      ** Read error messages for deal
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
     C                   IF        ULX602 = 'N' Or                                            CER001
     C                             ULX602 = 'Y' And ABFIELDID <= FldOffsetExt                 CER001
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffset     F
 
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   END
     C                   MOVE      'N'           @EI(F)
     C                   ENDIF                                                                CER001
 
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
 
     C                   END
 
     C                   MOVEA     @EI           OkIndFile
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                                    CAP011
      *****************************************************************         CAP011
      *                                                               *         CAP011
      * TDtDtaSubs - Transaction Details Data Substitution            *         CAP011
      *                                                               *         CAP011
      *****************************************************************         CAP011
                                                                                CAP011
     C     TDtDtaSubs    BEGSR                                                  CAP011
                                                                                CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      NwScrnRec     IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      CrScrnRec     CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       NwScrnRec                      CAP011
                                                                                CAP011
     C                   ENDSR                                                  CAP011
      *****************************************************************         CAP011
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      * SRUPDAT - Update the extension file                           *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     SRUPDAT       BEGSR                                                                CER001
      *                                                                                       CER001
     C                   EVAL      #6LXWNDPRN = DPRN                                          CER001
     C                   CALLB     'SEDPMV2UP'                                                CER001
     C                   PARM      DDACTN        P@ACTCDE                                     CER001
     C                   PARM      *BLANK        RetCodeIn                                    CER001
     C                   PARM                    WFIND                                        CER001
     C                   PARM                    NwDlFilFmt                                   CER001
     C                   PARM                    CrDlFilFmt                                   CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      * SREXTLUX - Call extension screen repair                       *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     SREXTLUX      BEGSR                                                                CER001
      *                                                                                       CER001
     C                   EVAL      #1DPSS = DDDPSS                                            CER001
     C                   EVAL      #1DPRN = DDDPRN                                            CER001
     C                   EVAL      #1DPMV = DPMVType                                          CER001
     C                   EVAL      #1FOTR = FOFFID                                            CER001
     C                   EVAL      #1TMST = DDTSTMP                                           CER001
      *                                                                                       CER001
      ** Change mode to Enquire only when Option selected is "N"                              CER001
      *                                                                                       CER001
     C                   IF        @OPTSEL = 'N'                                              CER001
     C                   EVAL      PDDACTN = DDACTN                                           CER001
     C                   EVAL      DDACTN = 'E'                                               CER001
     C                   EVAL      #1DEXT = 'Y'                                               CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   CALL      'SEDPMV2RP'                                                CER001
     C                   PARM      DDACTN        ACTION                                       CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM      *BLANKS       #RTRN                                        CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    NwDlFilFmt                                   CER001
     C                   EVAL      #1DEXT = *BLANK                                            CER001
      *                                                                                       CER001
     C                   IF        @OPTSEL = 'N'                                              CER001
     C                   EVAL      DDACTN = PDDACTN                                           CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   SELECT                                                               CER001
      *                                                                                       CER001
      ** Return code is Exit                                                                  CER001
      *                                                                                       CER001
     C                   WHEN      #RTRN = 'Y2U9999'                                          CER001
     C                   EXSR      SREnd                                                      CER001
      *                                                                                       CER001
      ** If F12 pressed, return to previous screen                                            CER001
      *                                                                                       CER001
     C                   WHEN      #RTRN = 'USR0790'                                          CER001
     C     CSE012        IFEQ      'Y'                                                        CER001
     C                   EVAL      WScrnMode = 'S'                                            CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      WScrnMode = 'M'
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Else if ENTER key was pressed,                                                       CER001
      *                                                                                       CER001
     C                   OTHER                                                                CER001
      *                                                                                       CER001
     C                   IF        BGWDPR = 'Y'                                               CER001
     C                   EVAL      WScrnMode = 'W'                                            CER001
     C                   ELSE                                                                 CER001
     C                   IF        @OPTSEL <> 'N'                                             CER001
     C                   EVAL      WScrnMode = 'C'                                            CER001
     C                   ELSE                                                                 CER001
     C     WRdNxBwRec    IFEQ      'Y'                                                        CER001
     C                   MOVEL     'R'           WScrnMode                                    CER001
     C                   ELSE                                                                 CER001
     C                   MOVEL     'B'           WScrnMode                                    CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDSL                                                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      * SRINZ - Initialize screen fields                              *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     SRINZ         BEGSR                                                                CER001
      *                                                                                       CER001
     C                   MOVE      *BLANKS       WFIND                                        CER001
      *                                                                                       CER001
     C                   MOVE      '000'         L6LXOPTP                                     CER001
     C                   MOVE      '0'           L6LXEXCF                                     CER001
     C                   IF        ULX008 = 'Y'                                               CER001
     C                   TIME                    WKTIME            6 0                        CER001
     C                   MOVE      WKTIME        L6LXTTIM                                     CER001
     C                   MOVE      *BLANKS       L6LXCNBR                                     CER001
      *                                                                                       CER001
      ** The default value is 'To be included in the CAB'                                     CER001
      ** maintained on LF/ERLUICL1                                                            CER001
      *                                                                                       CER001
     C     *LOVAL        SETLL     ERLUICL1                                                   CER001
     C                   READ      ERLUICL1                               80                  CER001
      *                                                                                       CER001
      ** If no found, database error                                                          CER001
      *                                                                                       CER001
     C                   IF        *IN80 = *ON                                                CER001
     C                   MOVEL     'ERLUICL1'    DBFILE                                       CER001
     C                   MOVEL     '003'         DBASE                                        CER001
     C                   MOVEL     '*FIRST'      DBKEY                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** The default value is the opposite value of the field                                 CER001
      ** maintained on the record                                                             CER001
      *                                                                                       CER001
     C                   IF        ULX008 = 'Y'                                               CER001
     C                   IF        VPDMOV = 'Y'                                               CER001
     C                   MOVE      'N'           L6LXCABR                                     CER001
     C                   ELSE                                                                 CER001
     C                   MOVE      'Y'           L6LXCABR                                     CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      * SRFTOS - Move file fields to screen fields                    *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     SRFTOS        BEGSR                                                                CER001
      *                                                                                       CER001
     C                   MOVE      'Y'           WFIND                                        CER001
      *                                                                                       CER001
     C                   MOVE      WNOPTP        L6LXOPTP                                     CER001
     C                   MOVE      WNEXCF        L6LXEXCF                                     CER001
     C                   IF        ULX008 = 'Y'                                               CER001
     C                   MOVE      WNTIME        L6LXTTIM                                     CER001
     C                   MOVE      WNCABR        L6LXCABR                                     CER001
     C                   MOVE      WNCNBR        L6LXCNBR                                     CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT
      *****************************************************************
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
      ** Depot Movement Type
      *
     C                   PARM                    DPMVType          2
      *
      ** Initialize program name
      *
     C                   MOVEL     'SEDPMVRPR'   DBPGM
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
      *
      ** Check if switchable feature S01401 is switched on.
      *
     C                   MOVE      'N'           S01401            1
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01401'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01401'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   EXSR      *PSSR                                        ************
     C                   ELSE
     C     @RTCD         IFEQ      *BLANKS                                      183768
     C                   MOVE      'Y'           S01401
     C                   END                                                    183768
     C                   END
      *
      ** Check if switchable feature S01511 is switched on.
      *
     C                   MOVE      'N'           S01511            1
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01511'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01511'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '903'         DBASE                          * DBERR 903*
     C                   EXSR      *PSSR                                        ************
     C                   ELSE
     C     @RTCD         IFEQ      *BLANKS                                      183768
     C                   MOVE      'Y'           S01511
     C                   END                                                    183768
     C                   END
      *                                                                          CSE012
      ** Access Switchable Features File, for SE Depot Movement Narratives       CSE012
      *                                                                          CSE012
     C                   MOVE      'N'           CSE012            1             CSE012
     C                   CALLB     'AOSARDR0'                                    CSE012
     C                   PARM      *BLANKS       PRTCD             7             CSE012
     C                   PARM      '*VERIFY'     POPTN             7             CSE012
     C                   PARM      'CSE012'      PSARD             6             CSE012
      *                                                                          CSE012
     C     PRTCD         IFEQ      *BLANKS                                       CSE012
     C                   MOVE      'Y'           CSE012
     C                   ENDIF                                                   CSE012
      *                                                                         CSE012
      ** Database Error                                                         CSE012
      *                                                                         CSE012
     C     PRTCD         IFNE      *BLANKS                                      CSE012
     C     PRTCD         ANDNE     '*NRF   '                                    CSE012
     C                   MOVEL     'CSE012 '     DBKEY                          CSE012
     C                   MOVEL     'SCSARDPD'    DBFILE                         CSE012
     C                   MOVEL     '904'         DBASE                          CSE012
     C                   EXSR      *PSSR                                        CSE012
     C                   ENDIF                                                  CSE012
     C/COPY WNCPYSRC,SEH00066
                                                                                              CGL031
      ** Access Switchable Features File, for Taxation for Savings Income                     CGL031
                                                                                              CGL031
     C                   MOVE      'N'           CGL031                                       CGL031
     C                   CALLB     'AOSARDR0'                                                 CGL031
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
      *                                                                         CAP011
      ** Access API ICD Details                                                 CAP011
      *                                                                         CAP011
     C                   CALLB     'AOAPIR0'                                    CAP011
     C                   PARM      *BLANKS       @RTCD                          CAP011
     C                   PARM      '*FIRST '     @OPTN                          CAP011
     C     SDAPI         PARM      SDAPI         DSFDY                          CAP011
      *                                                                         CAP011
      * DATABASE ERROR                                                          CAP011
      *                                                                         CAP011
     C     @RTCD         IFNE      *BLANKS                                      CAP011
     C                   MOVEL     'SDAPIPD '    DBFILE                         CAP011
     C                   MOVEL     '904'         DBASE                          CAP011
     C                   MOVEL     @OPTN         DBKEY                          CAP011
     C                   EXSR      *PSSR                                        CAP011
     C                   END                                                    CAP011
      ** Message Type
 
     C*******************MOVEL     'SEDPMV'      @MSGTYPE          8            CAP004
 
      ** Get the field number for the action code field; the screen fields
      ** start from that number.  Subtract one from it to give the value
      ** to subtract from each field's number.
 
     C     DPMVtype      IFEQ      'WI'
     C                   MOVEL     'SEDMWIPD'    Format
     C                   END
 
     C     DPMVType      IFEQ      'WO'
     C                   MOVEL     'SEDMWOPD'    Format
     C                   END
 
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    Format
     C                   PARM                    Field
     C                   PARM                    FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffset = FieldNo - 1
 
      ** If there was an error default the offset to 13
     C                   ELSE
     C                   EVAL      FldOffset = 13
     C                   ENDIF
      *                                                                                       CER001
      ** Get the field number for the action code field; the screen fields                    CER001
      ** start from that number.  Subtract one from it to give the value                      CER001
      ** to subtract from each field's number.                                                CER001
      *                                                                                       CER001
     C                   CALLB     'ZACGTFLDNO'                                               CER001
     C                   PARM                    ReturnCode                                   CER001
     C                   PARM                    Format                                       CER001
     C                   PARM                    FieldExt                                     CER001
     C                   PARM                    FieldNo                                      CER001
                                                                                              CER001
     C                   IF        ReturnCode   = *Blank                                      CER001
     C                   EVAL      FldOffsetExt = FieldNo - 1                                 CER001
                                                                                              CER001
      ** If there was an error default the offset to 13                                       CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      FldOffsetExt = 140                                         CER001
     C                   ENDIF                                                                CER001
 
     C                   MOVE      *BLANKS       @SIDN
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
     C                   MOVEL     '905'         DBASE                                        167486
     C                   MOVEL     '*FIRST'      DBKEY                                        167486
     C                   EXSR      *PSSR                                                      167486
     C                   END                                                                  167486
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *BLANKS                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   OPEN      APILOGL0                                                   CSC011
     C                   IN        SC24X7                                                     CSC011
     C**********         IN        SDSTAT                                              CSC011 CSD015
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   IF        PRTCD <> '*NRF   '                                         CSC011
     C                   EVAL      DBKEY  = 'CSC011'                                          CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE  = 907                                               CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                       CER001
      ** ULX602 - API Luxembourg - Function SEDPMV                                            CER001
      *                                                                                       CER001
     C                   EVAL      ULX602 = 'N'                                               CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX602'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *BLANKS                                            CER001
     C                   EVAL      ULX602 = 'Y'                                               CER001
      *                                                                                       CER001
      ** Do not process lux extension details when Lux Return indicator is                    CER001
      ** not set to 'Y'                                                                       CER001
      *                                                                                       CER001
     C                   IF         BGLRIN <> 'Y'                                             CER001
     C                   EVAL       ULX602 = 'N'                                              CER001
     C                   ELSE                                                                 CER001
     C                   OPEN      SEDPX1L0                                                   CER001
     C                   OPEN      SEIDMLX1L0                                                 CER001
     C                   OPEN      ERLUICL1                                                   CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** If return code <> *NRF, call program exception error routine                         CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS AND                                       CER001
     C                             @RTCD <> '*NRF'                                            CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBKEY = 'ULX602'                                           CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBASE = 909                                                CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Check if switchable feature ULX008 is installed.                                     CER001
      *                                                                                       CER001
     C                   EVAL      ULX008 = 'N'                                               CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX008'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *BLANKS                                            CER001
     C                   EVAL      ULX008 = 'Y'                                               CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** If return code <> *NRF, call program exception error routine                         CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS AND                                       CER001
     C                             @RTCD <> '*NRF'                                            CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBKEY = 'ULX008'                                           CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBASE = 910                                                CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
                                                                                              CSD015
     C                   IN        SDSTAT                                                     CSD015
                                                                                              CSC011
      *
      ** Start on Browse Screen
      *
     C                   MOVEL     'B'           WScrnMode         1
 
     C                   MOVEL     ' '           PortCusInd        1
 
      *                                                                                       CSC022
      ** Access Switchable Features File, for CSC022                                          CSC022
      *                                                                                       CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       PRTCD                                        CSC022
     C                   Parm      '*VERIFY'     POPTN                                        CSC022
     C                   Parm      'CSC022'      PSARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
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
     C                   EVAL      DBASE = 908                                                CSC022
     C                   OUT       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SEDPMVR011
 
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
