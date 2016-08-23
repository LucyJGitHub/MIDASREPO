     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validation function module')                  *
/*OVR *  OVRDBF FILE(FOCLTLXX) TOFILE(FOCLT) SHARE(*NO)               *
/*OVR *  OVRDBF FILE(FCLTYLXX) TOFILE(FCLTY) SHARE(*NO)               *
/*OVR *  OVRDBF FILE(CLOANLXX) TOFILE(CLOAN) SHARE(*NO)               *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLCOLAVAL - GL Collateral Allocation Validation Function     *
      *              Module                                           *
      *                                                               *
      *  Function:  This API module will serve as the validation mo   *
      *             dule of the complete API program and will be made *
      *             switchable under enhancement number CGL011.       *
      *                                                               *
      *  Called By: GLCOLASIN                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11623           Date 27Jun06               *
      *                 CGL072             Date 10Jul06               *
      *                 CDL049             Date 07Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG8550            Date 05Oct05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG7411            Date 01Jun05               *
      *                 CDL038             Date 10May05               *
      *                 CSW037A            Date 02May05               *
      *                 CDL028             Date 07Feb05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 224995             Date 11Feb04               *
      *                 CAP084             Date 04Nov03               *
      *                 222727             Date 05Nov03               *
      *                 CGL018             Date 27Sep02               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CGL011  *CREATE    Date 20Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  BUG11623 - Sequence No. column should be included (Recompile)*
      *  CGL072 - Allow GL Accounts in Collateral.                    *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG7411- CDL028 fields missing from DLGHISPD (Recompile)     *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
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
      *  224995 - Move ADACID instead of ADREAC into FldNameArr       *
      *           for field highlighting in MidasPlus.                *
      *  CAP084 - GLCOLAPD fields were blanked out before update.     *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CGL018 - Risk Weighted Assets                                *
      *  CGL011 - Collateral Processing for Midas DBA.                *
      *                                                               *
      *****************************************************************
 
     FFOCLTLXX  IF   E           K DISK    INFSR(*PSSR)
     FFCLTYLXX  IF   E           K DISK    INFSR(*PSSR)
     FCLOANLXX  IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF:CLOANCKF:CLOANZ1F)
      *                                                                         CGL018
      ** Deal Details File                                                      CGL018
     FDEALSALL  IF   E           K DISK    INFSR(*PSSR)                         CGL018
     F                                     INCLUDE(DEALSDCF)                    CGL018
 
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
 
      ** Include the standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the standard program name,proce-
      ** dures etc.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      ** Collateral Allocation File Format
     D ValidTran     E DS                  EXTNAME(GLCOLAPD)
 
      ** Collateral Allocation Screen Format(Current)
     D TranIn        E DS                  EXTNAME(GLSCLAPD)
 
      ** Collateral Allocation Screen Error Format
     D OKFlags       E DS                  EXTNAME(GLECLAPD)
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Module Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Dealing ICD
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
 
      ** Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D SDCUDFAC      E                     EXTFLD(QQDFAC)                                     CGL029
 
      ** Client Limits Details
     D SDCLLM        E DS                  EXTNAME(SDCLLMPD)
 
      ** Facility Types Details
     D SDFACT        E DS                  EXTNAME(SDFACTPD)
 
      ** Retail Standing Data
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D SDREACCD      E                     EXTFLD(QQACCD)                                     CGL029
 
      ** Retail Account Details
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
 
      ** SAR descriptions                                                                     CGL018
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL018
     D                                     PREFIX(S1)                                         CGL018
      ** DS for Access Object Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for Access Object Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for Access Object Programs
     D DSLDY         E DS                  EXTNAME(DSLDY)
                                                                                              224995
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)                     224995
      ** Java user information                                                                224995
 
      ** Display Account Data Structure
     D DSADREAC        DS
     D  WReAcctNo              1     10
     D  WBrnch                 1      3
     D  WCustNo                4      9
     D  WCurrency             10     12
     D**WAcctCde              13     16                                                       CGL029
     D**WAcctSeq              17     18                                                       CGL029
     D  WAcctCde              13     22                                                       CGL029
     D  WAcctSeq              23     24                                                       CGL029
 
     ** DS to check whether ADREAC only contain Retail Account (WEnd = ' ')
     D**WEnd                  11     18                                                       CGL029
     D  WEnd                  11     24                                                       CGL029
 
      ** Facility
     D DSADFCTY        DS            11
     D  WFcty1                 1      6
     D  WFcty2                 7      9
     D  WFcty3                10     11
 
      ** Index for arrays of of error message ids etc
     D RIdx            S              3P 0
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
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
                                                                                             BUG8550
      ** Retrieve ZMUSER details                                                             BUG8550
      ** If the user is connected via a browser, the job user name is QUSER -                BUG8550
      ** their user name is stored in ZMUSER                                                 BUG8550
                                                                                             BUG8550
     C                   IN        ZMUSER                                                    BUG8550
                                                                                             BUG8550
     C     USRID         IFNE      *BLANKS                                                   BUG8550
     C     USRID         ANDNE     PSUser                                                    BUG8550
     C                   MOVE      'Y'           JAVAUSER          1                         BUG8550
     C                   ELSE                                                                BUG8550
     C                   MOVE      'N'           JAVAUSER                                    BUG8550
     C                   ENDIF                                                               BUG8550
 
      ** Reset error variable RIdx
 
     C                   Eval      RIdx = 0
 
      ** Validate Action code
 
     C                   ExSr      SrActCde
 
      ** Validate input fields when action is 'I' or 'A'
 
     C                   If        (ADACTN = 'I') Or (ADACTN = 'A')
 
      ** Validate Branch code
 
     C                   ExSr      SrBrCd
 
      ** Validate Customer
 
     C                   ExSr      SrCustNo
 
      ** Validate Module
 
     C                   ExSr      SrModule
 
      ** Validate Priority
 
     C                   ExSr      SrPrSq
 
      ** Validate Facility
 
     C                   ExSr      SrFclty
 
      ** Validate Loan/Limit
 
     C                   ExSr      SrLnLm
 
      ** Validate Account
 
     C                   ExSr      SrAcct
 
      ** Validate Amount/Percentage indicator
 
     C                   ExSr      SrAmPc
 
      ** Validate Amount
 
     C                   ExSr      SrAmnt
 
      ** Validate Percentage
 
     C                   ExSr      SrPct
 
      ** No error on validations
 
     C                   If        RIdx = 0
     C                   ExSr      SrSetValid
     C                   EndIf
     C                   EndIf
 
      ** If Action is 'D', setup external data structure(Validtran) from the
      ** current screen format data structure(TranIn). No validation is
      ** needed
 
     C                   If        ADACTN = 'D'
     C                   ExSr      SrSetDel
     C                   EndIf
 
     C                   Return
 
      *****************************************************************
      *                                                               *
      * SR/*InzSr: Initialisation Routine                             *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * AOBANKR0   Access Object                                      *
      * AOMMODR0   Access Object                                      *
      * AODEALR0   Access Object                                      *
      *                                                               *
      *****************************************************************
 
     C     *InzSr        BegSr
 
      ** Entry Parameters
 
     C     *Entry        PList
     C                   Parm                    RespMode          1
     C                   Parm                    TranIn
     C                   Parm                    OkFlags
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIdArr
     C                   Parm                    MsgDtaArr
     C                   Parm                    Idx
     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIdArr
     C                   Parm                    WMsgDtaArr
     C                   Parm                    WIdx
     C                   Parm                    ValidTran
     C                   Parm                    PColRef          10
     C                   Parm                    PColCur           3
     C                   Parm                    SBlank            1
     C                   Parm                    WChgDel           1
     C                   Parm                    CGL072            1                          CGL072
 
      *
      ** Access SAR details file to determine if CGL018 is on.                                CGL018
      *                                                                                       CGL018
     C                   CALLB     'AOSARDR0'                                                 CGL018
     C                   PARM      *BLANKS       @RTCD                                        CGL018
     C                   PARM      '*VERIFY'     @OPTN                                        CGL018
     C                   PARM      'CGL018'      @SARD                                        CGL018
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL018
      *                                                                                       CGL018
      ** Database Error                                                                       CGL018
      *                                                                                       CGL018
     C     @RTCD         IFNE      *BLANKS                                                    CGL018
     C     @RTCD         ANDNE     '*NRF   '                                                  CGL018
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************  CGL018
     C                   Z-ADD     6             DBASE                          * DBERR 06 *  CGL018
     C                   MOVEL     'CGL018'      DBKEY                          ************  CGL018
     C                   EXSR      *PSSR                                                      CGL018
     C                   END                                                                  CGL018
      *                                                                                       CGL018
     C     @RTCD         IFEQ      *BLANK                                                     CGL018
     C                   MOVE      'Y'           CGL018            1                          CGL018
     C                   ELSE                                                                 CGL018
     C                   MOVE      'N'           CGL018                                       CGL018
     C                   END                                                                  CGL018
 
     C/COPY WNCPYSRC,GLCOLAVC07
      ** Initialise Program name
 
     C                   Eval      DbPgm = 'GLCOLAVAL'
 
      ** Access Bank Details via Access Object AOBANKR0
 
     C                   Call      'AOBANKR0'
     C                   Parm      '*DBERR '     @RtCd
     C                   Parm      '*FIRST '     @Optn
     C     SDBANK        Parm      SDBANK        DSFDY
 
     C     @RtCd         IfNe      *BLANKS
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   MoveL     'SDBANKPD'    DbFile                         ************
     C                   Z-Add     001           Dbase                          * DBERR 01 *
     C                   MoveL     @Optn         DbKey                          ************
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** Access Module details
 
     C                   Call      'AOMMODR0'
     C                   Parm      '*DBERR '     @Rtcd
     C                   Parm      '*FIRST '     @Optn
     C     SDMMOD        Parm      SDMMOD        DSFDY
 
     C     @Rtcd         IfNe      *BLANKS
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   Z-Add     002           DBase                          ************
     C                   MoveL     'SDMMODPD'    DBFile                         * DBERR 02 *
     C                   MoveL     '*FIRST'      DBKey                          ************
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** Dealing Module switched *ON
 
     C     BGDLMM        IfEq      'Y'
 
      ** Access Dealing ICD
 
     C**********         Call      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   Parm      '*DBERR '     @Rtcd
     C                   Parm      '*FIRST '     @Optn
     C*****SDDEAL        Parm      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
     C     @Rtcd         IfNe      *BLANKS
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   Z-Add     003           DBase                          ************
     C                   MoveL     'SDDEALPD'    DBFile                         * DBERR 03 *
     C                   MoveL     '*FIRST'      DBKey                          ************
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** Dealing Module not installed
 
     C                   Else
     C                   Movel     '.'           BNDCSP
     C                   EndIf
 
      * If the user is connected via a browser, the job user name is QUSER -                  224995
      * their user name is stored in ZMUSER                                                   224995
     C**********         IN        ZMUSER                                             224995 BUG8550
                                                                                              224995
     C*****USRID         IFNE      *BLANKS                                            224995 BUG8550
     C*****USRID         ANDNE     PSUser                                             224995 BUG8550
     C**********         MOVE      'Y'           JAVAUSER          1                  224995 BUG8550
     C**********         ELSE                                                         224995 BUG8550
     C**********         MOVE      'N'           JAVAUSER                             224995 BUG8550
     C**********         ENDIF                                                        224995 BUG8550
                                                                                              224995
      ** Parameter list for AOCLLMR0
 
     C     PAoCllmR0     PList
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm                    WKeyA             6
     C                   Parm                    WKeyB             1
     C                   Parm                    WKeyC             3
     C     SDCLLM        Parm      SDCLLM        DSFDY
 
      ** Parameter list for ZA0840
 
     C     PZA0840       PList
     C                   Parm                    RetCodeOut
     C                   Parm                    W@ALPH           16
     C                   Parm                    W@IDP             3 0
     C                   Parm                    W@IINT            3 0
     C                   Parm                    W@MTID            1
     C                   Parm                    W@ERCD            1 0
     C                   Parm                    W@AMT            15 0
     C                   Parm                    BNDCSP
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrActCde: Validate Action Code                             *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrActCde      BegSr
 
      ** Action code not 'I' 'A' or 'D'
 
     C                   If        (ADACTN <> 'I') And
     C                             (ADACTN <> 'A') And
     C                             (ADACTN <> 'D')
     C                   Add       1             Idx
     C                   Add       1             RIdx
 
     C                   If        Idx <= 75
     C*******************Eval      FldNameArr(Idx) = ADACTN                                   CAP084
     C                   Eval      FldNameArr(Idx) = 'ADACTN'                                 CAP084
     C                   Eval      MsgIdArr(Idx) = 'GLM0200'
     C                   Else
     C                   Eval      Idx = 75
     C                   EndIf
 
     C                   Eval      OKActn = 'N'
 
      ** Action Code is 'I' and the global field SBlank is not 'Y'
 
     C                   Else
     C                   If        (ADACTN = 'I') And (SBlank = 'N')
     C                   Add       1             Idx
     C                   Add       1             RIdx
 
     C                   If        Idx <= 75
     C*******************Eval      FldNameArr(Idx) = ADACTN                                   CAP084
     C                   Eval      FldNameArr(Idx) = 'ADACTN'                                 CAP084
     C                   Eval      MsgIdArr(Idx) = 'GLM0201'
     C                   Else
     C                   Eval      Idx = 75
     C                   EndIf
 
     C                   Eval      OKActn = 'N'
     C                   EndIf
 
      ** Action code is 'D' and change in input fields has been trapped
 
     C                   If        (ADACTN = 'D') And (WChgDel = 'Y')
     C                   Add       1             Idx
     C                   Add       1             RIdx
 
     C                   If        Idx <= 75
     C*******************Eval      FldNameArr(Idx) = ADACTN                                   CAP084
     C                   Eval      FldNameArr(Idx) = 'ADACTN'                                 CAP084
     C                   Eval      MsgIdArr(Idx) = 'GLM0202'
     C                   Else
     C                   Eval      Idx = 75
     C                   EndIf
 
     C                   Eval      OKActn = 'N'
     C                   EndIf
 
     C                   EndIf
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrBrCd: Validate Branch Code                               *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * AOBRCHR0   Access Object                                      *
      *                                                               *
      *****************************************************************
 
     C     SrBrCd        BegSr
 
      ** Branch not blank validate branch by calling access object AO
      ** BRCHR0
 
     C                   Movel     ADBRCA        WBrca             1
 
     C                   If        ADBRCA <> *Blank
     C**********         Call      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm      ADBRCA        WKey              3
     C*****SDBRCH        Parm      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
     C     @Rtcd         IfNe      *BLANKS
     C                   Add       1             Idx
     C                   Add       1             RIdx
 
     C                   If        Idx <= 75
     C*******************Eval      FldNameArr(Idx) = ADBRCA                                   CAP084
     C                   Eval      FldNameArr(Idx) = 'ADBRCA'                                 CAP084
     C                   Eval      MsgIdArr(Idx) = 'GLM0203'
     C                   Else
     C                   Eval      Idx = 75
     C                   EndIf
 
     C                   Eval      OKBRCA = 'N'
     C                   Else
 
     C                   If        (WBrca = '?')
     C                   Eval      ADBRCA = A8BRCD
     C                   EndIf
     C
     C                   EndIf
     C                   EndIf
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrCustNo: Validate Customer Number/Shortname               *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * AOCUSTR1   Access Object                                      *
      *                                                               *
      *****************************************************************
 
     C     SrCustNo      BegSr
 
     C**********         Z-Add     0             WCsNo             6 0                        CSD027
     C                   Move      *BLANKS       WCsNo             6                          CSD027
 
      ** Validate customer number via AOCUSTR1
 
     C                   Movel     ADCUSN        WCust             1
 
     C                   Call      'AOCUSTR1'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm      ADCUSN        WKey1            10
     C                   Parm      *Blanks       WKyst             7
     C     SDCUST        Parm      SDCUST        DSLDY
 
     C     @Rtcd         IfNe      *BLANKS
     C                   Add       1             Idx
     C                   Add       1             RIdx
 
     C                   If        Idx <= 75
     C*******************Eval      FldNameArr(Idx) = ADCUSN                                   CAP084
     C                   Eval      FldNameArr(Idx) = 'ADCUSN'                                 CAP084
     C                   Eval      MsgIdArr(Idx) = 'GLM0204'
     C                   Else
     C                   Eval      Idx = 75
     C                   EndIf
 
     C                   Eval      OKCUSN = 'N'
     C                   Else
 
      ** Valid Customer
 
     C                   If        (WCust = '?')
     C                   Eval      ADCUSN = BBCUST
     C                   EndIf
 
     C                   Movel     BBCUST        WCsNo
     C                   EndIf
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrModule: Validate Module Field                            *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * SrValMod  - Validate Module                                   *
      *                                                               *
      *****************************************************************
 
     C     SrModule      BegSr
 
      ** Validate Module field, if not blank
 
     C                   If        ADMODI <> *Blank
     C                   ExSr      SrValMod
     C                   EndIf
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrValMod: Validate Module Field                            *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * AOCLLMR0   Access Object                                      *
      *                                                               *
      *****************************************************************
 
     C     SrValMod      BegSr
 
      ** Validate Module field
 
     C                   If        (ADMODI <> 'LE') And
     C                             (ADMODI <> 'RE') And
     C                             (ADMODI <> 'MM') And
     C                             (ADMODI <> 'FX') And
     C                             (ADMODI <> 'FO') And
     C                             (ADMODI <> 'CM')
     C                             AND (ADMODI <> 'GL')                                       CGL072
     C                             Or (ADMODI = 'GL' and CGL072 = 'N')                        CGL072
     C/COPY WNCPYSRC,GLCOLAVC01
     C                   Add       1             Idx
     C                   Add       1             RIdx
 
     C                   If        Idx <= 75
     C*******************Eval      FldNameArr(Idx) = ADMODI                                   CAP084
     C                   Eval      FldNameArr(Idx) = 'ADMODI'                                 CAP084
     C                   Eval      MsgIdArr(Idx) = 'GLM0205'
     C                   IF        CGL072 = 'Y'                                               CGL072
     C                   Eval      MsgIdArr(Idx) = 'GLM0254'                                  CGL072
     C                   ENDIF                                                                CGL072
     C/COPY WNCPYSRC,GLCOLAVC02
     C                   Else
     C                   Eval      Idx = 75
     C                   EndIf
 
     C                   Eval      OKMODI = 'N'
     C                   Else
 
      ** Module 'LE' and lending not switched *On
 
     C                   If        (ADMODI = 'LE') And  (BGCSLN = 'N')
     C                   Add       1             Idx
     C                   Add       1             RIdx
 
     C                   If        Idx <= 75
     C*******************Eval      FldNameArr(Idx) = ADMODI                                   CAP084
     C                   Eval      FldNameArr(Idx) = 'ADMODI'                                 CAP084
     C                   Eval      MsgIdArr(Idx) = 'GLM0206'
     C                   Else
     C                   Eval      Idx = 75
     C                   EndIf
 
     C                   Eval      OKMODI = 'N'
     C                   EndIf
 
      ** Module 'MM' and Money Market not switched *On
 
     C                   If        (ADMODI = 'MM') And  (BGDLMM = 'N')
     C                   Add       1             Idx
     C                   Add       1             RIdx
 
     C                   If        Idx <= 75
     C*******************Eval      FldNameArr(Idx) = ADMODI                                   CAP084
     C                   Eval      FldNameArr(Idx) = 'ADMODI'                                 CAP084
     C                   Eval      MsgIdArr(Idx) = 'GLM0207'
     C                   Else
     C                   Eval      Idx = 75
     C                   EndIf
 
     C                   Eval      OKMODI = 'N'
     C                   EndIf
 
      ** Module 'MM' and Module OK Flag is 'Y'
 
     C                   If        (ADMODI = 'MM') And  (OKMODI = 'Y')
 
      ** Access Client Limits
 
     C                   If        ADBRCA <> *Blank
     C                   Movel     WCsNo         WKeyA
     C                   Eval      WKeyB = 'B'
     C                   Eval      WKeyC = ADBRCA
     C                   Else
     C                   Movel     WCsNo         WKeyA
     C                   Eval      WKeyB = ' '
     C                   Eval      WKeyC = *Blanks
     C                   EndIf
 
     C                   Call      'AOCLLMR0'    PAoCllmR0
 
     C     @Rtcd         IfNe      *Blank
     C     DZLLAM        OrEq      0
     C                   If        (CGL018='Y') and (ADLNLM<>*Blank)                          CGL018
     C                   Else                                                                 CGL018
     C                   Add       1             WIdx
 
     C                   If        WIdx <= 75
     C*******************Eval      WFldNamArr (WIdx) = ADMODI                                 CAP084
     C                   Eval      WFldNamArr (WIdx) = 'ADMODI'                               CAP084
     C                   Eval      WMsgIdArr(WIdx) = 'GLM0208'
     C                   Else
     C                   Eval      WIdx = 75
     C                   EndIf
     C                   Eval      OKMODI = 'N'
     C                   EndIf                                                                CGL018
     C                   EndIf
 
     C                   EndIf
 
      ** Module 'FX' and Foreign Exchange  not switched *On
 
     C                   If        (ADMODI = 'FX') And  (BGDLFX = 'N')
     C                   Add       1             Idx
     C                   Add       1             RIdx
 
     C                   If        Idx <= 75
     C*******************Eval      FldNameArr(Idx) = ADMODI                                   CAP084
     C                   Eval      FldNameArr(Idx) = 'ADMODI'                                 CAP084
     C                   Eval      MsgIdArr(Idx) = 'GLM0209'
     C                   Else
     C                   Eval      Idx = 75
     C                   EndIf
 
     C                   Eval      OKMODI = 'N'
     C                   EndIf
 
      ** Module 'FX' and Module OK Flag is 'Y'
 
     C                   If        (ADMODI = 'FX') And  (OKMODI = 'Y')
 
      ** Access Client Limits
 
     C                   If        ADBRCA <> *Blank
     C                   Movel     WCsNo         WKeyA
     C                   Eval      WKeyB = 'B'
     C                   Eval      WKeyC = ADBRCA
     C                   Else
     C                   Movel     WCsNo         WKeyA
     C                   Eval      WKeyB = ' '
     C                   Eval      WKeyC = *Blanks
     C                   EndIf
 
     C                   Call      'AOCLLMR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm                    WKeyA
     C                   Parm                    WKeyB
     C                   Parm                    WKeyC
     C     SDCLLM        Parm      SDCLLM        DSFDY
 
     C     @Rtcd         IfNe      *Blank
     C     DZFLAM        OrEq      0
     C                   Add       1             WIdx
 
     C                   If        WIdx <= 75
     C*******************Eval      WFldNamArr (WIdx) = ADMODI                                 CAP084
     C                   Eval      WFldNamArr (WIdx) = 'ADMODI'                               CAP084
     C                   Eval      WMsgIdArr(WIdx) = 'GLM0210'
     C                   Else
     C                   Eval      WIdx = 75
     C                   EndIf
     C                   Eval      OKMODI = 'N'
     C                   EndIf
 
     C                   EndIf
 
      ** Module 'FO' and Futures and Option is not switched *On
 
     C                   If        (ADMODI = 'FO') And  (BGFUOP = 'N')
     C                   Add       1             Idx
     C                   Add       1             RIdx
 
     C                   If        Idx <= 75
     C*******************Eval      FldNameArr(Idx) = ADMODI                                   CAP084
     C                   Eval      FldNameArr(Idx) = 'ADMODI'                                 CAP084
     C                   Eval      MsgIdArr(Idx) = 'GLM0211'
     C                   Else
     C                   Eval      Idx = 75
     C                   EndIf
 
     C                   Eval      OKMODI = 'N'
     C                   EndIf
 
      ** Module 'FO' and Module OK Flag is 'Y'
 
     C                   If        (ADMODI = 'FO') And  (OKMODI = 'Y')
     C     WCsNo         Chain     FOCLTLXX                           30
 
     C                   If        (*IN30 = *On) Or
     C                             (*IN30 = *Off) And  (RECI <> 'D')
     C                   Add       1             WIdx
 
     C                   If        WIdx <= 75
     C*******************Eval      WFldNamArr (WIdx) = ADMODI                                 CAP084
     C                   Eval      WFldNamArr (WIdx) = 'ADMODI'                               CAP084
     C                   Eval      WMsgIdArr(WIdx) = 'GLM0212'
     C                   Else
     C                   Eval      WIdx = 75
     C                   EndIf
     C                   Eval      OKMODI = 'N'
     C                   EndIf
     C                   EndIf
 
     C                   EndIf
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrPrSq: Validate Priority Sequence                         *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrPrSq        BegSr
 
      ** Priority Sequence not blank
 
     C                   If        ADPRSQ <> *Blank
     C                   TesTn                   ADPRSQ               31
     C                   If        (*IN31 = *Off) Or
     C                             (ADPRSQ = '000')
     C                   Add       1             Idx
     C                   Add       1             RIdx
 
     C                   If        Idx <= 75
     C*******************Eval      FldNameArr(Idx) = ADPRSQ                                   CAP084
     C                   Eval      FldNameArr(Idx) = 'ADPRSQ'                                 CAP084
     C                   Eval      MsgIdArr(Idx) = 'GLM0213'
     C                   Else
     C                   Eval      Idx = 75
     C                   EndIf
 
     C                   Eval      OKPRSQ = 'N'
     C                   EndIf
     C                   Else
 
      ** Default to 001
 
     C                   Eval      ADPRSQ = '001'
     C                   EndIf
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrFclty: Validate Facility Field                           *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * AOCUSTR1   Access Object                                      *
      *                                                               *
      *****************************************************************
 
     C     SrFclty       BegSr
 
      ** If Facility fields are not blank and module is not 'LE'
 
     C                   Eval      DSADFCTY = ADFCTY
 
     C                   If        (ADFCTY <> *Blank) And
     C                             (ADMODI <> 'LE')
     C                   Add       1             Idx
     C                   Add       1             RIdx
 
     C                   If        Idx <= 75
     C*******************Eval      FldNameArr(Idx) = ADFCTY                                   CAP084
     C                   Eval      FldNameArr(Idx) = 'ADFCTY'                                 CAP084
     C                   Eval      MsgIdArr(Idx) = 'GLM0214'
     C                   Else
     C                   Eval      Idx = 75
     C                   EndIf
 
     C                   Eval      OKFCTY = 'N'
     C                   EndIf
 
      ** Facility Flag OK, Validate customer portion of the facility
 
     C                   If        (ADMODI = 'LE') And (ADFCTY <> *Blank)
     C                   Movel     WFcty1        WFct1             1
 
     C                   If        OKFCTY = 'Y'
     C                   Call      'AOCUSTR1'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm      WFcty1        WKey1
     C                   Parm      *Blanks       WKyst
     C     SDCUST        Parm      SDCUST        DSLDY
 
     C     @Rtcd         IfNe      *BLANKS
     C                   Add       1             Idx
     C                   Add       1             RIdx
 
     C                   If        Idx <= 75
     C*******************Eval      FldNameArr(Idx) = WFcty1                                   CAP084
     C                   Eval      FldNameArr(Idx) = 'ADFCTY'                                 CAP084
     C                   Eval      MsgIdArr(Idx) = 'GLM0215'
     C                   Else
     C                   Eval      Idx = 75
     C                   EndIf
 
     C                   Eval      OKFCTY = 'N'
     C                   Else
 
     C                   If        (WFct1 = '?')
     C                   Eval      WFcty1 = BBCUST
     C                   EndIf
     C
     C                   EndIf
     C                   EndIf
 
      ** Facility Flag still OK, Validate Facility type
 
     C                   Movel     WFcty2        WFct2             1
 
     C                   If        OKFCTY = 'Y'
     C                   Call      'AOFACTR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm      WFcty2        @Ftyp             3
     C     SDFACT        Parm      SDFACT        DSFDY
 
     C     @Rtcd         IfNe      *BLANKS
     C                   Add       1             Idx
     C                   Add       1             RIdx
 
     C                   If        Idx <= 75
     C*******************Eval      FldNameArr(Idx) = WFcty2                                   CAP084
     C                   Eval      FldNameArr(Idx) = 'ADFCTY'                                 CAP084
     C                   Eval      MsgIdArr(Idx) = 'GLM0216'
     C                   Else
     C                   Eval      Idx = 75
     C                   EndIf
 
     C                   Eval      OKFCTY = 'N'
     C                   Else
 
     C                   If        (WFct2 = '?')
     C                   Eval      WFcty2 = AMFCTY
     C                   EndIf
 
     C                   EndIf
     C                   EndIf
 
      ** Facility Flag still OK, Validate sequence no. if numeric
 
     C                   If        OKFCTY = 'Y'
     C                   TesTn                   WFcty3               31
     C                   If        (*IN31 = *Off) Or
     C                             (ADPRSQ = '00')
     C                   Add       1             Idx
     C                   Add       1             RIdx
 
     C                   If        Idx <= 75
     C*******************Eval      FldNameArr(Idx) = WFcty3                                   CAP084
     C                   Eval      FldNameArr(Idx) = 'ADFCTY'                                 CAP084
     C                   Eval      MsgIdArr(Idx) = 'GLM0217'
     C                   Else
     C                   Eval      Idx = 75
     C                   EndIf
 
     C                   Eval      OKFCTY = 'N'
     C                   EndIf
     C                   EndIf
 
     C                   Eval      ADFCTY = DSADFCTY
 
      ** Facility Flag still OK, Validate the whole facility field
 
     C                   If        OKFCTY = 'Y'
 
      ** Keyflds on chaining Facility
 
     C**********         Move      WFcty1        WKfldCus          6 0                        CSD027
     C                   Move      WFcty1        WKfldCus          6                          CSD027
     C                   Move      WFcty2        WKfldTyp          3 0
     C                   Move      WFcty3        WKfldSeq          2 0
 
     C     WKeyFcty      Klist
     C                   KFld                    WKfldCus
     C                   KFld                    WKfldTyp
     C                   KFld                    WKfldSeq
 
     C     WKeyFcty      Chain     FCLTYLXX                           32
 
     C                   If        (*IN32 = *On) Or
     C                             (*IN32 = *Off) And  (RECI <> 'D')
     C                   Add       1             WIdx
 
     C                   If        WIdx <= 75
     C*******************Eval      WFldNamArr (WIdx) = ADFCTY                                 CAP084
     C                   Eval      WFldNamArr (WIdx) = 'ADFCTY'                               CAP084
     C                   Eval      WMsgIdArr(WIdx) = 'GLM0218'
     C                   Else
     C                   Eval      WIdx = 75
     C                   EndIf
     C                   Eval      OKFCTY = 'N'
     C                   EndIf
 
     C                   EndIf
     C                   EndIf
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrLnLm: Validate Loan/Limit Field                          *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrLnLm        BegSr
 
      ** If Loan/Limit not blank and module is not 'LE' or 'CM'
 
     C**********         If        ((ADLNLM <> *Blank) And                                    CGL018
     C**********                   (ADMODI <> 'LE') And                                       CGL018
     C**********                   (ADMODI <> 'CM') and (ADMODI <> 'MM'))                     CGL018
     C                   If        (ADLNLM <> *Blank) And                                     CGL018
     C                             (ADMODI <> 'LE') And                                       CGL018
     C                             (ADMODI <> 'CM')                                           CGL018
 
      * Error if module RE, FX and FO. For MM, only error if CGL018                           CAP084
      * is switched off.                                                                      CAP084
                                                                                              CAP084
     C                   If        (ADMODI <> 'MM') Or                                        CAP084
     C                             (ADMODI = 'MM' And CGL018 = 'N')                           CAP084
                                                                                              CAP084
     C                   Add       1             Idx
     C                   Add       1             RIdx
 
     C                   If        Idx <= 75
     C*******************Eval      FldNameArr(Idx) = ADLNLM                                   CAP084
     C                   Eval      FldNameArr(Idx) = 'ADLNLM'                                 CAP084
     C                   Eval      MsgIdArr(Idx) = 'GLM0219'
     C                   Else
     C                   Eval      Idx = 75
     C                   EndIf
 
     C                   Eval      OKLNLM = 'N'
                                                                                              CAP084
     C                   EndIf                                                                CAP084
     C                   EndIf
                                                                                              CGL018
     C                   IF        CGL018 = 'Y' and ADMODI = 'MM'                             CGL018
     C                   IF        ADLNLM <> *blanks                                          CGL018
     C                   MOVE      ADLNLM        WWLNLM            6 0                        CGL018
     C     WWLNLM        CHAIN     DEALSALL                           89                      CGL018
                                                                                              CAP084
     C*******************ENDIF                                                         CGL018 CAP084
     C*******************IF        *IN89 = *on or RECI <> 'D'                          CGL018 CAP084
     C*******************          or ADLNLM = *blanks                                 CGL018 CAP084
                                                                                              CAP084
     C                   IF        (*IN89 = *ON) OR (RECI <> 'D')                             CAP084
                                                                                              CAP084
     C                   Add       1             Idx                                          CGL018
     C                   Add       1             RIdx                                         CGL018
                                                                                              CGL018
     C                   If        Idx <= 75                                                  CGL018
     C*******************Eval      FldNameArr(Idx) = ADLNLM                            CGL018 CAP084
     C                   Eval      FldNameArr(Idx) = 'ADLNLM'                          CGL018 CAP084
     C                   Eval      MsgIdArr(Idx) = 'COL0130'                                  CGL018
     C                   Else                                                                 CGL018
     C                   Eval      Idx = 75                                                   CGL018
     C                   EndIf                                                                CGL018
     C                   Eval      OKLNLM = 'N'                                               CGL018
                                                                                              CGL018
     C                   Else                                                                 CGL018
     C                   IF        DTYP <> 'IP' and DTYP <> 'CL'                              CGL018
     C                             and DTYP <> 'TI'                                           CGL018
     C                   Add       1             Idx                                          CGL018
     C                   Add       1             RIdx                                         CGL018
                                                                                              CGL018
     C                   If        Idx <= 75                                                  CGL018
     C*******************Eval      FldNameArr(Idx) = ADLNLM                            CGL018 CAP084
     C                   Eval      FldNameArr(Idx) = 'ADLNLM'                          CGL018 CAP084
     C                   Eval      MsgIdArr(Idx) = 'COL0131'                                  CGL018
     C                   Else                                                                 CGL018
     C                   Eval      Idx = 75                                                   CGL018
     C                   EndIf                                                                CGL018
     C                   Eval      OKLNLM = 'N'                                               CGL018
     C                   ENDIF                                                                CGL018
     C                   ENDIF                                                                CGL018
                                                                                              CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
     C                   ENDIF                                                                CGL018
 
      ***If*Loan/Limit*not*blank*and*OKLNLM*=*'Y'*(Module*=*LE*or*CM)                         CLE148
 
     C**********         If        (ADLNLM <> *Blank) And                                     CLE148
     C**********                   (OKLNLM = 'Y')                                             CLE148
     C                   IF        ADMODI <> 'LE'                                             CLE148
     C                   TesTn                   ADLNLM               31
     C                   If        (*IN31 = *Off) Or
     C                             (ADLNLM = '000000')
     C                   Add       1             Idx
     C                   Add       1             RIdx
 
     C                   If        Idx <= 75
     C*******************Eval      FldNameArr(Idx) = ADLNLM                            CGL018 CAP084
     C                   Eval      FldNameArr(Idx) = 'ADLNLM'                                 CAP084
     C                   Eval      MsgIdArr(Idx) = 'GLM0220'
     C                   Else
     C                   Eval      Idx = 75
     C                   EndIf
 
     C                   Eval      OKLNLM = 'N'
     C                   EndIf
     C                   EndIf
 
      ** Module = 'LE'
      ** Facility already been entered, loan cannot be entered
 
     C                   If        ADMODI = 'LE'
     C                   If        (ADFCTY <> *Blank) And (ADLNLM <> *Blank)
     C                             And (OKFCTY = 'Y') And (OKLNLM = 'Y')
     C                   Add       1             Idx
     C                   Add       1             RIdx
 
     C                   If        Idx <= 75
     C*******************Eval      FldNameArr(Idx) = ADLNLM                            CGL018 CAP084
     C                   Eval      FldNameArr(Idx) = 'ADLNLM'                                 CAP084
     C                   Eval      MsgIdArr(Idx) = 'GLM0221'
     C                   Else
     C                   Eval      Idx = 75
     C                   EndIf
 
     C                   Eval      OKLNLM = 'N'
     C                   EndIf
 
      ** Loan/Limit Flag still OK, Check if existing
 
     C**********         Move      ADLNLM        WLnLm             6 0                        CLE148
     C                   MOVE      ADLNLM        WLnLmA            6                          CLE148
 
     C                   If        (OKLNLM = 'Y') And (ADLNLM <> *Blank)
     C*****WLnLm         Chain     CLOANLXX                           33                      CLE148
     C     WLnLmA        CHAIN     CLOANLXX                           33                      CLE148
 
     C                   If        (*IN33 = *On) Or
     C                             (*IN33 = *Off) And  (RECI <> 'D')
     C                   If        (ADFCTY = *Blank)
     C                   Add       1             WIdx
 
     C                   If        WIdx <= 75
     C*******************Eval      WFldNamArr (WIdx) = ADLNLM                                 CAP084
     C                   Eval      WFldNamArr (WIdx) = 'ADLNLM'                               CAP084
     C                   Eval      WMsgIdArr(WIdx) = 'GLM0222'
     C                   Else
     C                   Eval      WIdx = 75
     C                   EndIf
     C                   Eval      OKLNLM = 'N'
     C                   EndIf
     C                   Else
 
      ** Loan found, must have a valid loan processing type(not parts sold)
 
     C                   If        (PTYP = 66) Or (PTYP = 67) Or
     C                             (PTYP = 69) Or (PTYP = 72)
     C                   Add       1             Idx
     C                   Add       1             RIdx
 
     C                   If        Idx <= 75
     C*******************Eval      FldNameArr(Idx) = ADLNLM                                   CAP084
     C                   Eval      FldNameArr(Idx) = 'ADLNLM'                                 CAP084
     C                   Eval      MsgIdArr(Idx) = 'GLM0223'
     C                   Else
     C                   Eval      Idx = 75
     C                   EndIf
 
     C                   Eval      OKLNLM = 'N'
     C                   Endif
     C                   Endif
     C                   Endif
 
     C                   EndIf
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrAcct: Validate Account Field                             *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * AOACCTR0   Access Object                                      *
      *                                                               *
      *****************************************************************
 
     C     SrAcct        BegSr
 
      ** If Account field not blank and module not 'RE'
 
     C                   Eval      DSADREAC = ADREAC
 
     C/COPY WNCPYSRC,GLCOLAVC03
      *** If CGL072 is on then allow GL accounts.                                             CGL072
      *** Account can only be entered if module is 'RE' or 'GL'                               CGL072
      *                                                                                       CGL072
     C                   IF        (CGL072 = 'Y')                                             CGL072
     C                   If        (ADREAC <> *Blank) And                                     CGL072
     C                             (ADMODI <> 'RE' AND ADMODI <> 'GL')                        CGL072
     C                   Add       1             Idx                                          CGL072
     C                   Add       1             RIdx                                         CGL072
                                                                                              CGL072
     C                   If        Idx <= 75                                                  CGL072
     C                   Eval      FldNameArr(Idx) = ADREAC                                   CGL072
     C                   Eval      MsgIdArr(Idx) = 'GLM0255'                                  CGL072
     C                   Else                                                                 CGL072
     C                   Eval      Idx = 75                                                   CGL072
     C                   EndIf                                                                CGL072
                                                                                              CGL072
     C                   Eval      OKREAC = 'N'                                               CGL072
     C                   EndIf                                                                CGL072
     C                   ELSE                                                                 CGL072
      *                                                                                       CGL072
     C                   If        (ADREAC <> *Blank) And
     C                             (ADMODI <> 'RE')
     C                   Add       1             Idx
     C                   Add       1             RIdx
 
     C                   If        Idx <= 75
     C*******************Eval      FldNameArr(Idx) = ADREAC                                   CAP084
     C     JAVAUSER      IFEQ      'Y'                                                        224995
     C                   Eval      FldNameArr(Idx) = 'ADACID'                                 224995
     C                   ELSE                                                                 224995
     C                   Eval      FldNameArr(Idx) = 'ADREAC'                                 CAP084
     C                   END                                                                  224995
     C                   Eval      MsgIdArr(Idx) = 'GLM0224'
     C                   Else
     C                   Eval      Idx = 75
     C                   EndIf
 
     C                   Eval      OKREAC = 'N'
     C                   EndIf
      *                                                                                       CGL072
     C                   ENDIF                                                                CGL072
      *                                                                                       CGL072
     C/COPY WNCPYSRC,GLCOLAVC04
 
      ** If Account field not blank and OKACCT = 'Y' (Module = RE)
 
     C                   If        (ADREAC <> *Blank) And
     C                             (OKREAC = 'Y')
 
      ** Check if Retail account number supported
 
     C                   Call      'AORETLR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*FIRST  '    @Optn
     C     SdRetl        Parm      SdRetl        Dsfdy
 
     C     @Rtcd         IfNe      *BLANKS
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   Z-Add     005           DBase                          ************
     C                   MoveL     'SDRETLPD'    DBFile                         * DBERR 05 *
     C                   MoveL     '*FIRST'      DBKey                          ************
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** Retail account number not supported
 
     C                   If        (WEnd = *Blank) And (BMRANR = 'N') Or
     C**********                   (WEnd = '00000000') And (BMRANR = 'N')                     CGL029
     C                             (WEnd = '00000000000000') And (BMRANR = 'N')               CGL029
     C                   Add       1             Idx
     C                   Add       1             RIdx
 
     C                   If        Idx <= 75
     C*******************Eval      FldNameArr(Idx) = ADREAC                                   CAP084
     C     JAVAUSER      IFEQ      'Y'                                                        224995
     C                   Eval      FldNameArr(Idx) = 'ADACID'                                 224995
     C                   ELSE                                                                 224995
     C                   Eval      FldNameArr(Idx) = 'ADREAC'                                 CAP084
     C                   END                                                                  224995
     C                   Eval      MsgIdArr(Idx) = 'GLM0231'
     C                   Else
     C                   Eval      Idx = 75
     C                   EndIf
 
     C                   Eval      OKREAC = 'N'
     C                   EndIf
 
      ** Set up parameter
 
     C                   If        (WEnd = *Blank) And (BMRANR = 'Y') Or
     C**********                   (WEnd = '00000000') And (BMRANR = 'Y')                     CGL029
     C                             (WEnd = '00000000000000') And (BMRANR = 'Y')               CGL029
     C                   Eval      W@Retl = WReAcctNo
     C                   Eval      W@Brch = *Blank
     C                   Eval      WCusN = *Blank
     C                   Eval      W@Cur = *Blank
     C                   Eval      W@Acctcde = *Blank
     C                   Eval      W@AcctSeq = *Blank
     C                   Else
     C                   Eval      W@Retl = *Blank
     C                   Eval      W@Brch = WBrnch
     C                   Eval      WCusN = WCustNo
     C                   Eval      W@Cur = WCurrency
     C                   Eval      W@Acctcde = WAcctCde
     C                   Eval      W@AcctSeq = WAcctSeq
     C                   EndIf
     C
     C                   Call      'AOACCTR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY    '    @Optn
     C                   Parm                    W@Retl           10
     C                   Parm                    WCusN             6
     C                   Parm                    W@Cur             3
     C**********         Parm                    W@Acctcde         4                          CGL029
     C                   Parm                    W@Acctcde        10                          CGL029
     C                   Parm                    W@AcctSeq         2
     C                   Parm                    W@Brch            3
     C     ACCNT         Parm      ACCNT         DSSDY
 
     C/COPY WNCPYSRC,GLCOLAVC05
      *** If CGL072 & 'GL': error message 'Account number not valid'                          CGL072
      *** Core processing: check ATYP = 'R', warning message GLM0225                          CGL072
      *                                                                                       CGL072
     C                   IF        (CGL072 = 'Y' AND ADMODI = 'GL')                           CGL072
     C     @Rtcd         IfNe      *Blank                                                     CGL072
     C     ACST          OrEq      'C'                                                        CGL072
     C     RECI          OrEq      'C'                                                        CGL072
     C     RECI          OrEq      'R'                                                        CGL072
     C                   Add       1             Idx                                          CGL072
                                                                                              CGL072
     C                   If        Idx <= 75                                                  CGL072
     C                   Eval      FldNameArr (Idx) = ADREAC                                  CGL072
     C                   Eval      MsgIdArr(Idx) = 'GLX0054'                                  CGL072
     C                   Else                                                                 CGL072
     C                   Eval      Idx = 75                                                   CGL072
     C                   EndIf                                                                CGL072
     C                   Eval      OKREAC = 'N'                                               CGL072
     C                   EndIf                                                                CGL072
     C                   ELSE                                                                 CGL072
      *                                                                                       CGL072
     C     @Rtcd         IfNe      *Blank
     C     ATYP          OrNe      'R'
     C     ACST          OrEq      'C'
     C     RECI          OrEq      'C'
     C     RECI          OrEq      'R'
     C                   Add       1             WIdx
 
     C                   If        WIdx <= 75
     C*******************Eval      WFldNamArr (WIdx) = ADREAC                                 CAP084
     C     JAVAUSER      IFEQ      'Y'                                                        224995
     C                   Eval      WFldNamArr (WIdx) = 'ADACID'                               224995
     C                   ELSE                                                                 224995
     C                   Eval      WFldNamArr (WIdx) = 'ADREAC'                               CAP084
     C                   END                                                                  224995
     C                   Eval      WMsgIdArr(WIdx) = 'GLM0225'
     C                   Else
     C                   Eval      WIdx = 75
     C                   EndIf
     C                   Eval      OKREAC = 'N'
     C                   EndIf
     C                   EndIf
 
      *                                                                                       CGL072
     C                   ENDIF                                                                CGL072
      *                                                                                       CGL072
     C/COPY WNCPYSRC,GLCOLAVC06
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrAmPc: Validate Amt/Pct Field                             *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrAmPc        BegSr
 
      ** Default Amt/Pct to 'A' if blank
 
     C                   If        (ADAMPC = *Blank)
     C                   Eval      ADAMPC = 'A'
     C                   EndIf
 
      ** Invalid Amt/Pct entered
 
     C                   If        (ADAMPC <> 'A') And
     C                             (ADAMPC <> 'P')
     C                   Add       1             Idx
     C                   Add       1             RIdx
 
     C                   If        Idx <= 75
     C*******************Eval      FldNameArr(Idx) = ADAMPC                                   CAP084
     C                   Eval      FldNameArr(Idx) = 'ADAMPC'                                 CAP084
     C                   Eval      MsgIdArr(Idx) = 'GLM0226'
     C                   Else
     C                   Eval      Idx = 75
     C                   EndIf
 
     C                   Eval      OKAMPC = 'N'
     C                   EndIf
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrAmnt: Validate Amount Field                              *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * ZA0840    - Validate numeric fields                           *
      * AOCURRR0    Access Object                                     *
      *                                                               *
      *****************************************************************
 
     C     SrAmnt        BegSr
 
      ** Amount not blank while Amt/Pct field is not 'A'
 
     C                   If        (ADAMPC <> 'A') And
     C                             (ADAMNT <> *Blank)
     C                   Add       1             Idx
     C                   Add       1             RIdx
 
     C                   If        Idx <= 75
     C*******************Eval      FldNameArr(Idx) = ADAMNT                                   CAP084
     C                   Eval      FldNameArr(Idx) = 'ADAMNT'                                 CAP084
     C                   Eval      MsgIdArr(Idx) = 'GLM0227'
     C                   Else
     C                   Eval      Idx = 75
     C                   EndIf
 
     C                   Eval      OKAMNT = 'N'
     C                   EndIf
 
      ** Amount OK field still 'Y', validate amount
 
     C                   If        (ADAMPC = 'A') And (OKAMNT = 'Y')
     C                   Call      'AOCURRR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm      PColCur       @Ajcd             3
     C     SdCurr        Parm      SdCurr        Dssdy
 
     C     @Rtcd         IfNe      *BLANK
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   Z-Add     004           DBase                          ************
     C                   MoveL     'SDCURRPD'    DBFile                         * DBERR 04 *
     C                   MoveL     PCOlCur       DBKey                          ************
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** Set up parameter for ZA0840
 
     C                   Z-Add     A6NBDP        W@IDP
     C     15            Sub       W@IDP         W@IINT
     C                   Move      *Blanks       W@ALPH
     C                   Movel     ADAMNT        W@ALPH
     C                   Move      'Y'           W@MTID
 
     C                   CallB     'ZA0840'      PZA0840
 
      ** Error on validation
 
     C                   If        (W@ERCD <> 0) Or (W@Amt = 0)
     C                   Add       1             Idx
     C                   Add       1             RIdx
 
     C                   If        Idx <= 75
     C*******************Eval      FldNameArr(Idx) = ADAMNT                                   CAP084
     C                   Eval      FldNameArr(Idx) = 'ADAMNT'                                 CAP084
     C                   Eval      MsgIdArr(Idx) = 'GLM0228'
     C                   Else
     C                   Eval      Idx = 75
     C                   EndIf
 
     C                   Eval      OKAMNT = 'N'
     C                   Else
     C                   Eval      ADAMNT = W@ALPH
     C                   Z-Add     W@AMT         WZAMT            15 0
     C                   EndIf
     C                   Else
     C                   Z-Add     *Zero         WZAMT
     C                   EndIf
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrPct: Validate Percent Field                              *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * ZA0840    - Validate numeric fields                           *
      *                                                               *
      *****************************************************************
 
     C     SrPct         BegSr
 
      ** Percent field not blank while Amt/Pct field is not 'P'
 
     C                   If        (ADAMPC <> 'P') And
     C                             (ADPRCT <> *Blank)
     C                   Add       1             Idx
     C                   Add       1             RIdx
 
     C                   If        Idx <= 75
     C*******************Eval      FldNameArr(Idx) = ADPRCT                                   CAP084
     C                   Eval      FldNameArr(Idx) = 'ADPRCT'                                 CAP084
     C                   Eval      MsgIdArr(Idx) = 'GLM0229'
     C                   Else
     C                   Eval      Idx = 75
     C                   EndIf
 
     C                   Eval      OKPRCT = 'N'
     C                   EndIf
 
      ** Percent OK field still 'Y', validate Percent
 
     C                   If        (ADPRCT <> *Blank) And
     C                             (OKPRCT = 'Y')
 
      ** Set up parameter for ZA0840
 
     C                   Z-Add     2             W@IDP
     C                   Z-Add     3             W@IINT
     C                   Move      *Blanks       W@ALPH
     C                   Movel     ADPRCT        W@ALPH
     C                   Move      'N'           W@MTID
 
     C                   CallB     'ZA0840'      PZA0840
 
      ** Error on validation
 
     C                   If        (W@ERCD <> 0) Or
     C                             (W@AMT < 00001) Or
     C                             (W@AMT > 10000)
     C                   Add       1             Idx
     C                   Add       1             RIdx
 
     C                   If        Idx <= 75
     C*******************Eval      FldNameArr(Idx) = ADPRCT                                   CAP084
     C                   Eval      FldNameArr(Idx) = 'ADPRCT'                                 CAP084
     C                   Eval      MsgIdArr(Idx) = 'GLM0230'
     C                   Else
     C                   Eval      Idx = 75
     C                   EndIf
 
     C                   Eval      OKPRCT = 'N'
     C                   Else
     C                   Move      W@ALPH        ADPRCT
     C     W@AMT         Div       100           WZPCT             5 2
     C                   EndIf
     C                   Else
     C                   Z-Add     *Zero         WZPCT
     C                   EndIf
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrSetValid: Move all valid fields to file fields           *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrSetValid    BegSr
 
     C*******************Eval      CACREF = PColRef                                           CAP084
     C*******************Eval      CAFRNT = *Blanks                                           CAP084
     C*******************Eval      CAREPA = *Blanks                                           CAP084
     C*******************Eval      CATMST = *Blanks                                           CAP084
      *                                                                                       CAP084
      ** Update CACREF with ADCREF (Tranin) in insert mode.                                   CAP084
      *                                                                                       CAP084
     C                   If        ADACTN = 'I'                                               CAP084
     C                   Eval      CACREF = ADCREF                                            CAP084
     C                   Endif                                                                CAP084
      *                                                                                       CAP084
     C                   Eval      CABRCA = ADBRCA
     C                   Eval      CACNUM = WCsNo
     C                   Eval      CAAPCT = ADAMPC
     C                   Z-Add     WZPCT         CAPCNT
     C                   Z-Add     WZAMT         CAAMT
     C                   Movel     ADPRSQ        CAPRTY
     C                   Eval      CAMODS = ADMODI
     C                   Movel     WFcty1        CAFCUS
     C                   Movel     WFcty2        CAFTYP
     C                   Movel     WFcty3        CAFSEQ
     C                   Movel     ADLNLM        CALNLM
 
     C                   If        (ADMODI = 'RE') And
     C                             (ADREAC <> *Blank)
     C                   If        (OKREAC = 'N')
     C**********         If        (WEnd = *Blank) Or (WEnd = '00000000')                     CGL029
     C                   If        (WEnd = *Blank) Or (WEnd = '00000000000000')               CGL029
     C                   Eval      CASBRC = WBrnch
     C                   Move      WCustNo       CASCNM
     C                   Eval      CASCCY = WCurrency
     C                   Move      WAcctCde      CASACD
     C                   Move      WAcctSeq      CASSEQ
     C                   Move      WReAcctNo     CASACN
     C                   Else
     C                   Eval      CASBRC = WBrnch
     C                   Move      WCustNo       CASCNM
     C                   Eval      CASCCY = WCurrency
     C                   Move      WAcctCde      CASACD
     C                   Move      WAcctSeq      CASSEQ
     C                   Move      *Zeros        CASACN
     C                   EndIf
 
     C                   Else
     C                   Eval      CASBRC = BRCA
     C                   Eval      CASCNM = CNUM
     C                   Eval      CASCCY = CCY
     C                   Eval      CASACD = ACOD
     C                   Eval      CASSEQ = ACSQ
     C                   Eval      CASACN = ACNO
     C                   EndIf
 
     C                   Else
     C                   Eval      CASBRC = *Blank
     C**********         Eval      CASCNM = *Zero                                             CSD027
     C                   Eval      CASCNM = *Blanks                                           CSD027
     C                   Eval      CASCCY = *Blank
     C                   Eval      CASACD = *Zero
     C                   Eval      CASSEQ = *Zero
     C                   Eval      CASACN = *Zero
     C                   EndIf
 
     C                   Eval      CACHTP = ADACTN
     C                   Eval      CALCD  = BJRDNB
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrSetDel: Setup ValidTran data structure for action delete *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrSetDel      BegSr
 
      ** Setup Key fields of file GLCOLAL0 to be use in chaining record
      ** in module GLCOLAUPD
 
     C                   Eval      CACREF = PColRef
     C                   Eval      CAFRNT = *Blanks
     C                   Eval      CAREPA = *Blanks
     C                   Eval      CATMST = *Blanks
     C                   Eval      CABRCA = ADBRCA
     C                   Movel     ADCUSN        CACNUM
     C                   Eval      CAAPCT = ADAMPC
 
      ** Setup Amount
 
     C                   Call      'AOCURRR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm      PColCur       @Ajcd
     C     SdCurr        Parm      SdCurr        Dssdy
 
     C     @Rtcd         IfNe      *BLANK
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   Z-Add     006           DBase                          ************
     C                   MoveL     'SDCURRPD'    DBFile                         * DBERR 04 *
     C                   MoveL     PCOlCur       DBKey                          ************
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** Set up parameter for ZA0840 for amount conversion
 
     C                   Z-Add     A6NBDP        W@IDP
     C     15            Sub       W@IDP         W@IINT
     C                   Move      *Blanks       W@ALPH
     C                   Movel     ADAMNT        W@ALPH
     C                   Move      'Y'           W@MTID
 
      ** Convert amount from char to numeric
 
     C                   CallB     'ZA0840'      PZA0840
     C                   Eval      CAAMT = W@AMT
 
      ** Set up parameter for ZA0840 for Percentage conversion
 
     C                   Z-Add     2             W@IDP
     C                   Z-Add     3             W@IINT
     C                   Move      *Blanks       W@ALPH
     C                   Movel     ADPRCT        W@ALPH
     C                   Move      'N'           W@MTID
 
     C                   CallB     'ZA0840'      PZA0840
     C     W@AMT         Div       100           CAPCNT
 
     C                   Movel     ADPRSQ        CAPRTY
     C                   Eval      CAMODS = ADMODI
     C                   Movel     WFcty1        CAFCUS
     C                   Movel     WFcty2        CAFTYP
     C                   Movel     WFcty3        CAFSEQ
     C                   Movel     ADLNLM        CALNLM
     C                   Eval      DSADREAC = ADREAC
 
     C**********         If        (WEnd = *Blank) Or (WEnd = '00000000')                     CGL029
     C                   If        (WEnd = *Blank) Or (WEnd = '00000000000000')               CGL029
     C                   Movel     WReAcctNo     CASACN
     C                   Else
     C                   Z-Add     *Zeros        CASACN
     C                   EndIf
 
     C                   Eval      DSADFCTY = ADFCTY
     C                   Eval      CASBRC = WBrnch
     C                   Move      WCustNo       CASCNM
     C                   Eval      CASCCY = WCurrency
     C                   Move      WAcctCde      CASACD
     C                   Move      WAcctSeq      CASSEQ
     C                   Eval      CACHTP = ADACTN
     C                   Eval      CALCD  = BJRDNB
 
     C                   EndSr
 
      ****************************************************************
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
(c) Misys International Banking Systems Ltd. 2002
