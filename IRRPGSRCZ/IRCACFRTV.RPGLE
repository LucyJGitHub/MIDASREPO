     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Caps/Collars/Floors Retrieve')                *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRCACFRTV - Caps/Collars/Floors Retreive                     *
      *                                                               *
      *  Function:  This module retrieves a Cap/Collars/Floor deal    *
      *             from the database.  As it does so, it validates   *
      *             the action code, deal number and deal type.       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 MD000091           Date 08May13               *
      *                 AR996631           Date 28Jun12               *
      *                 AR816302           Date 18Aug11               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAP185             Date 21Apr06               *
      *                 CDL049             Date 07Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7411            Date 01Jun05               *
      *                 229544             Date 15Sep04               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG4756            Date 05Nov04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CAP084             Date 11Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      *                 CSD015             Date 14Oct02               *
      *                 CAS004             Date 26Jun02               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01 ----------------------- -------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      *                 CAP005  *CREATE    Date 13Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  MD000091 - Event Codes Substitution                          *
      *  AR996631 - System should not validate deal number range      *
      *             if PEA indicator is on                            *
      *  AR816302 - MMM0797: Item under review by Compliance Officer  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  CAP185 - MQ Series Interface                                 *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG7411- CDL028 fields missing from DLGHISPD (Recompile)     *
      *  229544 - Recompiled due to inserted fields in DLCHISPD.      *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  BUG4756 - Authorisation error. Call SFC000026                *
      *            for each authorisation check.                      *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  CAP084 - ThinClient API enhancement.                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  217684 - Authorisation User Malfunction                      *
      *  CAP056 - Automatic Authorisation of Interface deals          *
      *           Recompile over changed PF/DEALSDG                   *
      *  CIR008 - FRA/IRS Deals Authorisation                         *
      *  CAP055 - APIs for FRA/IRS Caps/Collars/Floors                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRValFront - Validation for Front Office Transaction         *
      *               Interface                                       *
      *  SRValidate - Validation of Action Code, Deal Type and Deal   *
      *               Number                                          *
      *  SRValEnq - Validation of Action Code 'E'                     *
      *  SRValIns - Validation of Action Code 'I'                     *
      *  SRValAmd - Validation of Action Code 'A'                     *
      *  SRValDel - Validation of Action Code 'D'                     *
      *  SRSecChk - Access Security Checking                          *
      *  SRInitial - Initialization Subroutine                        *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FIRFRAL0   IF   E           K DISK    INFSR(*PSSR)
      ** FRA/IRS by Front Office ID
 
     FDLCACFL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DEALSDGF:DLCACFLL)
     F
      ** All Caps/Collars/Floors Deal Type = 'RR', 'RP' and 'RF'
 
     FDEALSALL  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FXDEALP0:FXDLALL)
     F                                     RENAME(MMDELDP0:MMDELALL)
     F                                     RENAME(MMDENSP0:MMDESALL)
     F                                     RENAME(MMDENBP0:MMDEBALL)
     F                                     RENAME(DEALSDGF:DLSDGALL)
      ** All Deals File
 
     FFDDLNMLL  IF   E             DISK    INFSR(*PSSR)
      ** Deal Number Record
 
     FSDCWHTL1  IF   E           K DISK    INFSR(*PSSR)                                       CSD015
      ** Compliance Watch Hit List by Function                                                CSD015
                                                                                              CSD015
                                                                                              CAP185
      ** Midas AP API Configuration                                                           CAP185
     FAPICFGL0  IF   E           K DISK    INFSR(*PSSR)                                       CAP185
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** Standard D-specs
      ** ================
 
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
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
 
      ** External DS for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
                                                                                              CSD015
      ** DS for Access Program, Long Data Structure                                           CSD015
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSD015
                                                                                              CSD015
      ** Midas Functions for Watch List Checking Details File                                 CSD015
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
                                                                                              CSD015
      ** External DS for SAR Details                                                          CSD015
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD015
     D  @LCD         E                     EXTFLD(LCD)                                        CSD015
                                                                                              CSD015
      ** SD Status DataArea Layout                                                            CSD015
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSD015
                                                                                              CSD015
      ** 24X7 Status DataArea Layout                                                          CSD015
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSD015
 
      ** Deal in File Format
     D CACFFmt       E DS                  EXTNAME(DEALSDG)
 
      ** Deal in File Format
     D CrIRFilFmt    E DS                  EXTNAME(DEALSDG)
     D                                     PREFIX(Cr)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** OK flags
     D OKACCD          S              1
     D OKDLNO          S              1
     D OKDTYP          S              1
     D OKBRCA          S              1
 
     ** Switchable Features                                                                   CSD015
     D CSD015          S              1A                                                      CSD015
     D CSC011          S              1A                                                      CSD015
                                                                                              CSD015
     ** Work Variables                                                                        CSD015
     D WBranch         S              3A                                                      CSD015
     D WFunction       S              8A                                                      CSD015
     D WIdentifier     S             40A                                                      CSD015
     D PFunc           S              8A                                                      CSD015
     D POptn           S              7A                                                      CSD015
     D PSard           S              6A                                                      CSD015
                                                                                              CSD015
     D ModeofOp        S              6
     D RespMode        S              1
     D PAcCd           S              1
     D PFOTrId         S             20
     D PFOAsId         S             20
     D PDlNo           S              6
     D PLnkd           S              6
     D P1Brca          S              3
     D PDtyp           S              2
     D WTest           S              1
     D WkDlNo          S              6  0
     D WkDTyp          S              2
     D PAction         S              1
     D PError          S              1  0
     D PRtCd           S              7
     D POption         S              7
     D PBranch         S              3
     D P2Brca          S              3
     D CIR008          S              1A                                                      CIR008
 
     D BJSBRC          S              3
     D PkDBRC          S              3
     D BKOBUV          S              1
     D BQFIAU          S              1A                                                      CIR008
     D BQFIRA          S              1A                                                      CIR008
      *                                                                                     AR996631
     D PSysVal1        C                   CONST('PEAIndicator')                            AR996631
     D PRetCode        S              7A                                                    AR996631
     D P@OP01          S             20A                                                    AR996631
     D P@VL01          S            200A                                                    AR996631
     D P@OP02          S             20A                                                    AR996631
     D P@VL02          S            200A                                                    AR996631
     D P@OP03          S             20A                                                    AR996631
     D P@VL03          S            200A                                                    AR996631
     D P@OP04          S             20A                                                    AR996631
     D P@VL04          S            200A                                                    AR996631
     D P@OP05          S             20A                                                    AR996631
     D P@VL05          S            200A                                                    AR996631
     D P@OP06          S             20A                                                    AR996631
     D P@VL06          S            200A                                                    AR996631
     D P@OP07          S             20A                                                    AR996631
     D P@VL07          S            200A                                                    AR996631
     D P@OP08          S             20A                                                    AR996631
     D P@VL08          S            200A                                                    AR996631
     D P@OP09          S             20A                                                    AR996631
     D P@VL09          S            200A                                                    AR996631
     D P@OP10          S             20A                                                    AR996631
     D P@VL10          S            200A                                                    AR996631
     D WPEAInd         S              1A                                                    AR996631
     D CSC054          S              1A                                                    AR996631
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                            MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   EXSR      SRInitial
 
      ** If the mode is 'Front Office Transaction Interface',
      ** perform validation for Front Office Transaction Interface
 
     C                   IF        ModeofOp = '*FRONT'
     C                   EXSR      SRValFront
 
      ** Carry out no further validation if errors have occurred.
 
     C                   IF        OKACCD = 'N' OR OKDLNO = 'N'
     C                             OR OKDTYP = 'N'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate Action Code, Deal Number and Deal Type
 
     C                   EXSR      SRValidate
 
      **  Carry out no further validation if errors have occurred.
 
     C                   IF        OKACCD = 'N' OR OKDLNO = 'N'
     C                             OR OKDTYP = 'N'
     C                   RETURN
     C                   ENDIF
 
      ** Validation of Action Codes
 
     C                   SELECT
 
      ** Validation for Action Code 'E'
 
     C                   WHEN      PAcCd = 'E'
     C                   EXSR      SRValEnq
                                                                                              CIR008
      ** Validation for Action Code 'X'                                                       CIR008
                                                                                              CIR008
     C                   WHEN      PAcCd = 'X' AND CIR008 = 'Y'                               CIR008
     C                   EXSR      SRValAuth                                                  CIR008
 
      ** Validation for Action Code 'I', if deal number is not to be
      ** generated
 
     C                   WHEN      PAcCd = 'I' and PDlNo <> *BLANKS
     C                   EXSR      SRValIns
 
      ** Validation for Action Code 'A'
 
     C                   WHEN      PAcCd = 'A'
     C                   EXSR      SRValAmd
 
      ** Validation for Action Code 'D'
 
     C                   WHEN      PAcCd= 'R'
     C                   EXSR      SRValDel
 
     C                   ENDSL
 
      ** Carry out no further validation if errors occurred
 
     C                   IF        OKACCD = 'N' OR OKDLNO = 'N'
     C                             OR OKDTYP = 'N'
     C                   RETURN
     C                   ENDIF
      *
      ** If Action is not Insert, move file values to outout
      ** parameter if action code and key fields are valid.
      *
     C                   IF        PAcCd <> 'I'
     C                   EVAL      CrIRFilFmt = CACFFmt
     C                   ENDIF
 
      ** Access Security Checking
 
     C                   IF        RespMode = 'S'
     C                   EXSR      SRSecChk
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValFront - Validation for Front Office Transaction         *
      *               Interface                                       *
      *                                                               *
      *****************************************************************
 
     C     SRValFront    BEGSR
 
      ** Error if Action Code is not 'I', 'A', 'R'
      ** ... or 'X' if CIR008 is installed                                                    CIR008
 
     C                   IF        PAcCd <> 'I' AND PAcCd <> 'A' AND
     C                             PAcCd <> 'R'
     C                   IF        CIR008 = 'N' OR  PAcCd <> 'X'                              CIR008
     C                   EVAL      OKACCD = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#0ACCD'
     C                   IF        CIR008 = 'N'                                               CIR008
     C                   EVAL      MsgIdArr(Idx) = 'MMM3005'
     C                   ELSE                                                                 CIR008
     C                   EVAL      MsgIdArr(Idx) = 'MMM3012'                                  CIR008
     C                   ENDIF                                                                CIR008
     C                   ENDIF
     C                   ENDIF                                                                CIR008
 
      ** Error if Front Office Transaction ID is Blank
 
     C                   IF        PFOTrId = *BLANK
     C                   EVAL      OKACCD = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#0ACCD'
     C                   EVAL      MsgIdArr(Idx) = 'APM0101'
     C                   ENDIF
      *
     C                   IF        OKACCD = 'N'
     C                   GOTO      EValFrnt
     C                   ENDIF
 
      ** Access Deal with Front Office Transaction ID
 
     C     PFOTrId       CHAIN     IRFRAL0
 
      ** If Insert
 
     C                   IF        PAcCd = 'I'
 
      ** Front Office Transaction ID cannot be present already
 
     C                   IF        %FOUND(IRFRAL0)
     C                   EVAL      OKACCD = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#0ACCD'
     C                   EVAL      MsgIdArr(Idx) = 'APM0102'
     C**********         EVAL      MsgDtaArr(Idx) = PFOTrId                                 MD000091
     C                   EVAL      BLen = %Len(%Trim(PFOTrId))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(PFOTrId)                  MD000091
     C                   GOTO      EValFrnt
     C                   ENDIF
 
     C                   ELSE
 
      ** If not insert, Front Office Transaction ID must be present
 
     C                   IF        NOT %FOUND(IRFRAL0)
     C                   EVAL      OKACCD = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#0ACCD'
     C                   EVAL      MsgIdArr(Idx) = 'APM0103'
     C**********         EVAL      MsgDtaArr(Idx) = PFOTrId                                 MD000091
     C                   EVAL      BLen = %Len(%Trim(PFOTrId))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(PFOTrId)                  MD000091
     C                   GOTO      EValFrnt
     C                   ENDIF
 
      ** If not insert, update Midas Deal Number
 
     C                   MOVEL     DLNO          PDlNo
     C                   MOVEL     DTYP          PDTyp
 
     C                   ENDIF
 
     C     EValFrnt      ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValidate - Validation of Action Code, Deal Type and Deal   *
      *               Number                                          *
      *                                                               *
      *****************************************************************
 
     C     SRValidate    BEGSR
 
      ** Check that the action code is valid
 
     C                   IF        (PAcCd <> 'I') AND (PAcCd <> 'A') AND
     C                             (PAcCd <> 'R') AND (PAcCd <> 'E')
                                                                                              CIR008
     C                   IF        CIR008 = 'N' OR                                            CIR008
     C                             BQFIAU = 'N' AND BQFIRA = 'N'                              CIR008
     C                   EVAL      OKACCD = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#0ACCD'
     C                   IF        CIR008 = 'Y'                                               CIR008
     C                   EVAL      MsgIdArr(Idx) = 'MMM9034'                                  CIR008
     C                   ELSE                                                                 CIR008
     C                   EVAL      MsgIdArr(Idx) = 'FDM0101'
     C                   ENDIF                                                                CIR008
     C                   GOTO      EValid
     C                   ENDIF                                                                CIR008
     C                                                                                        CIR008
     C                   ENDIF
                                                                                              CIR008
      ** CIR008 is installed.                                                                 CIR008
                                                                                              CIR008
     C                   IF        CIR008 = 'Y' AND                                           CIR008
     C                             (BQFIAU = 'Y' OR BQFIRA = 'Y') AND                         CIR008
     C                             PAcCd <> 'I' AND PAcCd <> 'A' AND                          CIR008
     C                             PAcCd <> 'R' AND PAcCd <> 'E' AND                          CIR008
     C                             PAcCd <> 'X'                                               CIR008
     C                   EVAL      OKACCD = 'N'                                               CIR008
     C                   EVAL      Idx = Idx + 1                                              CIR008
     C                   EVAL      FldNameArr(Idx) = 'SACCD '                                 CIR008
     C                   EVAL      MsgIdArr(Idx) = 'MMM9035'                                  CIR008
     C                   ENDIF                                                                CIR008
      *
     C                   IF        PDlNo = *BLANKS AND PAcCd <> 'I'
     C                   EVAL      OKDLNO = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#0DLNO'
     C                   EVAL      MsgIdArr(Idx) = 'MMM0111'
     C                   GOTO      EValid
     C                   ENDIF
 
      **  If the deal number is not blank, check that it is numeric.
 
     C                   TESTN                   PDlNo                30
     C                   MOVE      PDlNo         WTest
     C                   TESTZ                   WTest                    31
 
     C                   IF        (PDlNo <> *BLANKS AND *IN30 = *OFF) OR
     C                             (PDlNo <> *BLANKS AND *IN31 = *OFF)
     C                   EVAL      OKDLNO = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#0DLNO'
     C                   EVAL      MsgIdArr(Idx) = 'MMM0162'
     C                   GOTO      EValid
     C                   ENDIF
 
      ** Get Deal Type
 
     C                   IF        PAcCd <> 'I' AND PDTyp = *BLANKS
     C                   MOVEL     PDlNo         WkDlNo
     C     WkDlNo        CHAIN     DEALSALL                           01
 
      ** If deal is found,
 
     C                   IF        *IN01 = *OFF
 
      ** If deal type is not a Cap/Collar/Floor, error message
 
     C                   IF        DTYP <> 'RP' AND DTYP <> 'RR' AND
     C                             DTYP <> 'RF'
     C                   EVAL      OKDTYP = 'N'
     C                   EVAL      OKDLNO = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#0DTYP'
     C                   EVAL      MsgIdArr(Idx) = 'MMM3010'
     C                   GOTO      EValid
     C                   ENDIF
 
      ** Else, its correct type, if action is amend, enquire or reverse
      ** get deal type
 
     C                   EVAL      PDTyp = DTYP
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Error if Deal Type is not 'RR', 'RF' or 'RP'
 
     C                   IF        PDtyp <> 'RR' AND PDtyp <> 'RF' AND
     C                             PDtyp <> 'RP'
     C                   EVAL      OKDTYP = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#0DTYP'
     C                   EVAL      MsgIdArr(Idx) = 'MMM3004'
     C                   ENDIF
 
     C     EValid        ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValEnq - Validation of Action Code 'E'                     *
      *                                                               *
      *****************************************************************
 
     C     SRValEnq      BEGSR
 
      ** If the deal number is blank, it is an error
 
     C                   MOVEL     PDlNo         WkDlNo
     C                   MOVEL     PDTyp         WkDTyp
     C     KCACF         CHAIN     DLCACFL0
 
      ** If there is no valid record on DLCACFL0, it is an error.
 
     C                   IF        NOT %FOUND(DLCACFL0)
     C                   EVAL      OKDLNO = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#0DLNO'
     C                   EVAL      MsgIdArr(Idx) = 'MMM2623'
     C                   GOTO      EValEnq                                                    CIR008
     C                   ENDIF
                                                                                              CIR008
      ** If the deal status is not C, A, R or M, it is an error                               CIR008
                                                                                              CIR008
     C                   IF        CIR008 = 'Y' AND                                           CIR008
     C                             FIDSTS <> 'C' AND FIDSTS <> 'A' AND                        CIR008
     C                             FIDSTS <> 'R' AND FIDSTS <> 'M'                            CIR008
     C                   EVAL      OKDLNO = 'N'                                               CIR008
     C                   EVAL      Idx = Idx + 1                                              CIR008
     C                   EVAL      FldNameArr(Idx) = '#0DLNO'                                 CIR008
     C                   EVAL      MsgIdArr(Idx)   = 'MMM9033'                                CIR008
     C                   GOTO      EValEnq                                                    CIR008
     C                   ENDIF                                                                CIR008
 
     C     EValEnq       ENDSR
 
      *****************************************************************
      /EJECT                                                                                  CIR008
      *****************************************************************                       CIR008
      *                                                               *                       CIR008
      *  SRValAuth - Validation of Action Code 'X'                    *                       CIR008
      *                                                               *                       CIR008
      *****************************************************************                       CIR008
                                                                                              CIR008
     C     SRValAuth     BEGSR                                                                CIR008
                                                                                              CIR008
     C                   MOVEL     PDlNo         WkDlNo                                       CIR008
     C                   MOVEL     PDTyp         WkDTyp                                       CIR008
     C     KCACF         CHAIN     DLCACFL0                                                   CIR008
                                                                                              CIR008
      ** If there is no valid record on DLCACFL0, it is an error.                             CIR008
                                                                                              CIR008
     C                   IF        NOT %FOUND(DLCACFL0) OR RECI <> 'D'                        CIR008
     C                   EVAL      OKDLNO = 'N'                                               CIR008
     C                   EVAL      Idx = Idx + 1                                              CIR008
     C                   EVAL      FldNameArr(Idx) = '#0DLNO'                                 CIR008
     C                   EVAL      MsgIdArr(Idx) = 'MMM9031'                                  CIR008
     C                   GOTO      EValAuth                                                   CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
      ** Deal Status must be 'C' or 'R'                                                       CIR008
                                                                                              CIR008
     C                   IF        FIDSTS <> 'C' AND FIDSTS <> 'R'                            CIR008
     C                   EVAL      OKDLNO = 'N'                                               CIR008
     C                   EVAL      Idx = Idx + 1                                              CIR008
     C                   EVAL      FldNameArr(Idx) = '#0DLNO'                                 CIR008
     C                   EVAL      MsgIdArr(Idx) = 'MMM0171'                                  CIR008
     C                   GOTO      EValAuth                                                   CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
      ** Determine whether program is running interactively or in batch                       CAP185
      **  ( 0 = batch 1 = interactive)                                                        CAP185
      *                                                                                       CAP185
     C                   CALLB     'ZARTVJOBA'                                                CAP185
     C                   PARM                    @Return           6                          CAP185
     C                   PARM                    @Type             1                          CAP185
      *                                                                                       CAP185
     C                   IF        CAP185 = 'N' OR                                            CAP185
     C                             CAP185 = 'Y' AND                                           CAP185
     C                             @AUTHO = 'N' OR                                            CAP185
     C                             CAP185 = 'Y' AND                                           CAP185
     C                             @AUTHO = 'Y' AND                                           CAP185
     C                             @TYPE = '1'                                                CAP185
                                                                                              CAP185
      ***Original*Input*User*must*be*different*from*the*Authorisation*User             CIR008 217684
      ** Authorise User must be different from Original Input User                            217684
      ** and Amend User                                                                       217684
                                                                                             BUG4756
     C                   CALL      'SFC000026'                                               BUG4756
     C                   PARM      *BLANKS       USER                                        BUG4756
                                                                                             BUG4756
     C                   IF        USER <> *BLANKS                                           BUG4756
     C                   EVAL      PSUser = USER                                             BUG4756
     C                   ENDIF                                                               BUG4756
                                                                                              CIR008
     C                   IF        FIUSRI = PSUser                                            CIR008
     C                             or FIUSRA = PSUser                                         217684
     C                   EVAL      OKDLNO = 'N'                                               CIR008
     C                   EVAL      Idx = Idx + 1                                              CIR008
     C                   EVAL      FldNameArr(Idx) = '#0DLNO'                                 CIR008
     C                   EVAL      MsgIdArr(Idx) = 'MMM9032'                                  CIR008
     C                   GOTO      EValAuth                                                   CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
     C                   ENDIF                                                                CAP185
                                                                                              CAP185
      ** Check transaction for Compliance watch                                               CSD015
                                                                                              CSD015
     C                   IF        (CSD015 = 'Y')  AND  (W1EWLC = 'Y')                        CSD015
                                                                                              CSD015
     C                   IF        (CSC011 = 'Y' AND S1MAIN = LIBR)                           CSD015
     C                             OR CSC011 = 'N'                                            CSD015
                                                                                              CSD015
     C                   EVAL      WFunction = 'DEALSDG'                                      CSD015
     C                   EVAL      WIdentifier = PDlNo                                        CSD015
     C                   EVAL      WBranch = BRCA                                             CSD015
     C     CWHTKy        CHAIN     SDCWHTL1                                                   CSD015
                                                                                              CSD015
      ** If record found and trade under investigation, display error message                 CSD015
      ** 'Item under review by Compliance Officer'.                                           CSD015
                                                                                              CSD015
     C                   IF        %FOUND(SDCWHTL1)  AND  W3TREL <> 'Y'                       CSD015
     C                   EVAL      OKDLNO = 'N'                                               CSD015
     C                   EVAL      Idx = Idx + 1                                              CSD015
     C                   EVAL      FldNameArr(Idx) = '#0DLNO'                                 CSD015
     C                   EVAL      MsgIdArr(Idx) = 'MMM0797'                                  CSD015
     C                   GOTO      EValAuth                                                   CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C     EValAuth      ENDSR                                                                CIR008
                                                                                              CIR008
      *****************************************************************                       CIR008
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValIns - Validation of Action Code 'I'                     *
      *                                                               *
      *****************************************************************
 
     C     SRValIns      BEGSR
 
      ** Check that the deal does not exist on any Deals File
      ** Midas or DRS
 
     C                   IF        PDlNo <> *BLANKS
     C                   MOVEL     PDlNo         WkDlNo
     C                   ENDIF
     C     WkDlNo        SETLL     DEALSALL                               32
     C                   IF        *IN32 = *ON
     C                   EVAL      OKDLNO = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#0DLNO'
     C                   EVAL      MsgIdArr(Idx) = 'MMM0163'
     C                   GOTO      EValIns
     C                   ENDIF
 
      ** Check that the deal number is in the allowed range, if not
      ** generated through APIs
     C                   IF        WPEAInd <> 'Y'                                           AR996631
 
     C                   IF        WkDlNo < NORDLN
     C                             OR WkDlNo = 999999
     C                   IF        ModeofOp <> '*FRONT'
     C                             and ModeofOp <> '*RPR  '
     C                   EVAL      OKDLNO = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#0DLNO'
     C                   EVAL      MsgIdArr(Idx) = 'MMM0164'
     C                   GOTO      EValIns
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                              AR996631
 
     C     EValIns       ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValAmd - Validation of Action Code 'A'                     *
      *                                                               *
      *****************************************************************
 
     C     SRValAmd      BEGSR
 
     C                   MOVEL     PDlNo         WkDlNo
     C                   MOVEL     PDTyp         WkDTyp
     C     KCACF         CHAIN     DLCACFL0
 
      ** Error if there is no valid, undeleted record on DLCACFL0
 
     C                   IF        NOT %FOUND(DLCACFL0) OR
     C                             (%FOUND(DLCACFL0) AND RECI <> 'D')
     C                   EVAL      OKDLNO = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#0DLNO'
     C                   EVAL      MsgIdArr(Idx) = 'FXM0003'
     C                   ENDIF
                                                                                              CIR008
      ** If the deal exists, the status must be C, A or R                                     CIR008
                                                                                              CIR008
     C                   IF        CIR008 = 'Y' AND                                           CIR008
     C                             FIDSTS <> 'C' AND FIDSTS <> 'A' AND                        CIR008
     C                             FIDSTS <> 'R'                                              CIR008
     C                   EVAL      OKDLNO = 'N'                                               CIR008
     C                   EVAL      Idx = Idx + 1                                              CIR008
     C                   EVAL      FldNameArr(Idx) = '#0DLNO'                                 CIR008
     C                   EVAL      MsgIDArr(Idx) = 'MMM0166'                                  CIR008
     C                   GOTO      EValAmd                                                    CIR008
     C                   ENDIF                                                                CIR008
 
     C     EValAmd       ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValDel - Validation of Action Code 'D'                     *
      *                                                               *
      *****************************************************************
 
     C     SRValDel      BEGSR
 
     C                   MOVEL     PDlNo         WkDlNo
     C                   MOVEL     PDTyp         WkDTyp
     C     KCACF         CHAIN     DLCACFL0
 
      ** Error if there is no valid, undeleted record on DLCACFL0
 
     C                   IF        NOT %FOUND(DLCACFL0) OR
     C                             (%FOUND(DLCACFL0) AND RECI <> 'D')
     C                   EVAL      OKDLNO = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#0DLNO'
     C                   EVAL      MsgIdArr(Idx) = 'FXM0003'
     C                   ENDIF
                                                                                              CIR008
      ** The deal status must be 'C' or 'A'                                                   CIR008
                                                                                              CIR008
     C                   IF        CIR008 = 'Y' AND                                           CIR008
     C                             FIDSTS <> 'C' AND FIDSTS <> 'A'                            CIR008
     C                   EVAL      OKDLNO = 'N'                                               CIR008
     C                   EVAL      Idx = Idx + 1                                              CIR008
     C                   EVAL      FldNameArr(Idx) = '#0DLNO'                                 CIR008
     C                   EVAL      MsgIdArr(Idx) = 'MMM0169'                                  CIR008
     C                   GOTO      EVALDel                                                    CIR008
     C                   ENDIF                                                                CIR008
 
     C     EValDel       ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSecChk - Access Security Checking                          *
      *                                                               *
      *****************************************************************
 
     C     SRSecChk      BEGSR
 
      ** If not multi-branching, check authority to action code only
 
     C                   IF        BJSBRC <> *BLANK
 
     C                   CALL      'ZVACTU'
     C                   PARM      PAcCd         PAction
     C                   PARM                    PError
 
     C                   IF        PError = 1
     C                   EVAL      OKACCD = 'N'
     C                   EVAL      OKDLNO = 'N'
     C                   EVAL      OKDTYP = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#0ACCD'
     C                   EVAL      MsgIdArr(Idx) = 'FXM0292'
     C                   GOTO      ESecChk
     C                   ENDIF
 
     C                   ENDIF
 
      ** If multi-branching, check authority to booking branch
 
     C                   IF        BJSBRC = *BLANK
 
     C                   IF        PAcCd = 'I'
 
     C                   IF        P1Brca = *BLANKS
     C                   EVAL      P2Brca = PkDBRC
     C                   EVAL      P1Brca = PkDBRC
     C                   ELSE
     C                   EVAL      P2Brca = P1Brca
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      P2Brca = BRCA
     C                   ENDIF
 
     C                   IF        PAcCd = 'I'
 
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POption
     C                   PARM      P1Brca        PBranch
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      OKBRCA = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#0BRCA'
     C                   EVAL      MsgIdArr(Idx) = 'MMM0115'
     C                   GOTO      ESecChk
     C                   ELSE
     C                   EVAL      P2Brca = A8BRCD
     C                   EVAL      P1Brca = A8BRCD
     C                   ENDIF
 
     C                   ENDIF
 
     C                   CALL      'ZVACTBU'
     C                   PARM      PAcCd         PAction
     C                   PARM                    P2Brca
     C                   PARM                    PError
 
     C                   IF        PError = 1 OR PError = 2
     C                   EVAL      OKACCD = 'N'
 
      ** If Insert, then highlight branch field else deal number
 
     C                   IF        PAcCd = 'I'
     C                   EVAL      OKBRCA = 'N'
     C                   ELSE
     C                   EVAL      OKDLNO = 'N'
     C                   ENDIF
 
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#0ACCD'
 
     C                   IF        PError = 1
     C                   EVAL      MsgIdArr(Idx) = 'FXM0290'
     C                   ELSE
     C                   EVAL      MsgIdArr(Idx) = 'FXM0291'
     C                   ENDIF
 
     C                   GOTO      ESecChk
     C                   ENDIF
 
      ** Check authority to originating branch
 
     C                   IF        BKOBUV = 'Y' AND PAcCd <> 'E'
     C                             AND PAcCd <> 'I'
 
     C                   CALL      'ZVOBU'
     C                   PARM      ORBR          PBranch
     C                   PARM                    PError
 
     C                   IF        PError = 1
     C                   EVAL      OKACCD = 'N'
     C                   EVAL      OKDLNO = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#0ACCD'
     C                   EVAL      MsgIdArr(Idx) = 'FXM0287'
     C                   ENDIF
 
     C                   IF        PError = 2
     C                   EVAL      OKACCD = 'N'
     C                   EVAL      OKDLNO = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#0ACCD'
     C                   EVAL      MsgIdArr(Idx) = 'FXM0288'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     ESecChk       ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInitial - Initialization Subroutine                        *
      *                                                               *
      *****************************************************************
 
     C     SRInitial     BEGSR
 
      ** Clear Outputs
 
     C                   CLEAR                   CrIRFilFmt
     C                   EVAL      CrDLNO = *ZEROS
     C                   EVAL      CrRCDC = *ZEROS
     C**********         EVAL      CrCNUM = *ZEROS                                            CSD027
     C                   EVAL      CrCNUM = *BLANKS                                           CSD027
     C                   EVAL      CrDDAT = *ZEROS
     C                   EVAL      CrVDAT = *ZEROS
     C                   EVAL      CrMDAT = *ZEROS
     C                   EVAL      CrCDAS = *ZEROS
     C                   EVAL      CrBAGE = *ZEROS
     C                   EVAL      CrLNKDN = *ZEROS
     C                   EVAL      CrUPAMT = *ZEROS
     C                   EVAL      CrUBRTT = *ZEROS
     C                   EVAL      CrUSTRT = *ZEROS
     C                   EVAL      CrUBRTE = *ZEROS
     C                   EVAL      CrURTSP = *ZEROS
     C                   EVAL      CrUEINR = *ZEROS
     C                   EVAL      CrUICBS = *ZEROS
     C                   EVAL      CrUFRFD = *ZEROS
     C                   EVAL      CrUINFD = *ZEROS
     C                   EVAL      CrUSLIP = *ZEROS
     C                   EVAL      CrUNICD = *ZEROS
     C                   EVAL      CrUICBD = *ZEROS
     C                   EVAL      CrUICFD = *ZEROS
     C                   EVAL      CrUNIPD = *ZEROS
     C                   EVAL      CrUIPBD = *ZEROS
     C                   EVAL      CrUIPFD = *ZEROS
     C                   EVAL      CrUBCXR = *ZEROS
     C                   EVAL      CrUIACD = *ZEROS
     C                   EVAL      CrUIALC = *ZEROS
     C                   EVAL      CrUAITC = *ZEROS
     C                   EVAL      CrUAIPD = *ZEROS
     C                   EVAL      CrUAIAN = *ZEROS
     C                   EVAL      CrUAIAP = *ZEROS
     C                   EVAL      CrUIPRD = *ZEROS
     C                   EVAL      CrUIPRM = *ZEROS
     C                   EVAL      CrUNSAM = *ZEROS
     C                   EVAL      CrUTAXD = *ZEROS
     C                   EVAL      CrUTAXM = *ZEROS
     C                   EVAL      CrTPAMT = *ZEROS
     C                   EVAL      CrTBRTT = *ZEROS
     C                   EVAL      CrTSTRT = *ZEROS
     C                   EVAL      CrTBRTE = *ZEROS
     C                   EVAL      CrTRTSP = *ZEROS
     C                   EVAL      CrTEINR = *ZEROS
     C                   EVAL      CrTICBS = *ZEROS
     C                   EVAL      CrTFRFD = *ZEROS
     C                   EVAL      CrTINFD = *ZEROS
     C                   EVAL      CrTSLIP = *ZEROS
     C                   EVAL      CrTNICD = *ZEROS
     C                   EVAL      CrTICBD = *ZEROS
     C                   EVAL      CrTICFD = *ZEROS
     C                   EVAL      CrTNIPD = *ZEROS
     C                   EVAL      CrTIPBD = *ZEROS
     C                   EVAL      CrTIPFD = *ZEROS
     C                   EVAL      CrTBCXR = *ZEROS
     C                   EVAL      CrTIACD = *ZEROS
     C                   EVAL      CrTIALC = *ZEROS
     C                   EVAL      CrTAITC = *ZEROS
     C                   EVAL      CrTAIPD = *ZEROS
     C                   EVAL      CrTAIAN = *ZEROS
     C                   EVAL      CrTAIAP = *ZEROS
     C                   EVAL      CrTIPRD = *ZEROS
     C                   EVAL      CrTIPRM = *ZEROS
     C                   EVAL      CrTNSAM = *ZEROS
     C                   EVAL      CrTTAXD = *ZEROS
     C                   EVAL      CrTTAXM = *ZEROS
     C                   EVAL      CrCLRAT = *ZEROS
     C                   EVAL      CrFLRAT = *ZEROS
     C                   EVAL      CrAVPER = *ZEROS
     C                   EVAL      CrTIRAT = *ZEROS
     C                   EVAL      CrAACRT = *ZEROS
     C                   EVAL      CrRSETM = *ZEROS
     C                   EVAL      CrPSETM = *ZEROS
     C                   EVAL      CrSDCAR = *ZEROS
     C                   EVAL      CrULPCD = *ZEROS
     C                   EVAL      CrTLPCD = *ZEROS
     C                   EVAL      CrUAEXA = *ZEROS
     C                   EVAL      CrTAEXA = *ZEROS
     C                   EVAL      CrUNRL = *ZEROS
     C                   EVAL      CrUNRLP = *ZEROS
     C                   EVAL      CrDDTM = *ZEROS
     C                   EVAL      CrBRSQ = *ZEROS
     C                   EVAL      CrLSWC = *ZEROS
     C                   EVAL      CrLSWS = *ZEROS
     C                   EVAL      CrORED = *ZEROS
     C                   EVAL      CrLCD = *ZEROS
     C                   EVAL      CrTNLU = *ZEROS
     C                   EVAL      CrUNPCD = *ZEROS
     C                   EVAL      CrTNPCD = *ZEROS
     C                   EVAL      CrUPVD = *ZEROS
     C                   EVAL      CrUPFE = *ZEROS
     C                   EVAL      CrUPAD = *ZEROS
     C                   EVAL      CrBODD = *ZEROS
     C                   EVAL      CrBOVD = *ZEROS
     C                   EVAL      CrBOAM = *ZEROS
     C                   EVAL      CrOUSI = *ZEROS
     C                   EVAL      CrOUSA = *ZEROS
     C                   EVAL      CrTUSI = *ZEROS
     C                   EVAL      CrTUSA = *ZEROS
     C                   EVAL      CrUOBRT = *ZEROS
     C                   EVAL      CrTOBRT = *ZEROS
     C                   EVAL      CrUOPAM = *ZEROS
     C                   EVAL      CrTOPAM = *ZEROS
     C                   EVAL      CrRSTM = *ZEROS
     C**********         EVAL      CrROBN = *ZEROS                                            CSD027
     C**********         EVAL      CrROCN = *ZEROS                                            CSD027
     C                   EVAL      CrROBN = *BLANKS                                           CSD027
     C                   EVAL      CrROCN = *BLANKS                                           CSD027
     C                   EVAL      CrPSTM = *ZEROS
     C**********         EVAL      CrPOBN = *ZEROS                                            CSD027
     C**********         EVAL      CrPOCN = *ZEROS                                            CSD027
     C                   EVAL      CrPOBN = *BLANKS                                           CSD027
     C                   EVAL      CrPOCN = *BLANKS                                           CSD027
     C                   EVAL      CrISDA = *ZEROS
     C                   EVAL      CrAGDT = *ZEROS
     C                   EVAL      CrAGVV = *ZEROS
     C                   EVAL      CrPLULRC = *ZEROS
     C                   EVAL      CrPLTLRC = *ZEROS
     C                   EVAL      CrAGVC = *ZEROS
 
     C                   CLEAR                   CACFFmt
     C                   EVAL      DLNO = *ZEROS
     C                   EVAL      RCDC = *ZEROS
     C**********         EVAL      CNUM = *ZEROS                                              CSD027
     C                   EVAL      CNUM = *BLANKS                                             CSD027
     C                   EVAL      DDAT = *ZEROS
     C                   EVAL      VDAT = *ZEROS
     C                   EVAL      MDAT = *ZEROS
     C                   EVAL      CDAS = *ZEROS
     C                   EVAL      BAGE = *ZEROS
     C                   EVAL      LNKDN = *ZEROS
     C                   EVAL      UPAMT = *ZEROS
     C                   EVAL      UBRTT = *ZEROS
     C                   EVAL      USTRT = *ZEROS
     C                   EVAL      UBRTE = *ZEROS
     C                   EVAL      URTSP = *ZEROS
     C                   EVAL      UEINR = *ZEROS
     C                   EVAL      UICBS = *ZEROS
     C                   EVAL      UFRFD = *ZEROS
     C                   EVAL      UINFD = *ZEROS
     C                   EVAL      USLIP = *ZEROS
     C                   EVAL      UNICD = *ZEROS
     C                   EVAL      UICBD = *ZEROS
     C                   EVAL      UICFD = *ZEROS
     C                   EVAL      UNIPD = *ZEROS
     C                   EVAL      UIPBD = *ZEROS
     C                   EVAL      UIPFD = *ZEROS
     C                   EVAL      UBCXR = *ZEROS
     C                   EVAL      UIACD = *ZEROS
     C                   EVAL      UIALC = *ZEROS
     C                   EVAL      UAITC = *ZEROS
     C                   EVAL      UAIPD = *ZEROS
     C                   EVAL      UAIAN = *ZEROS
     C                   EVAL      UAIAP = *ZEROS
     C                   EVAL      UIPRD = *ZEROS
     C                   EVAL      UIPRM = *ZEROS
     C                   EVAL      UNSAM = *ZEROS
     C                   EVAL      UTAXD = *ZEROS
     C                   EVAL      UTAXM = *ZEROS
     C                   EVAL      TPAMT = *ZEROS
     C                   EVAL      TBRTT = *ZEROS
     C                   EVAL      TSTRT = *ZEROS
     C                   EVAL      TBRTE = *ZEROS
     C                   EVAL      TRTSP = *ZEROS
     C                   EVAL      TEINR = *ZEROS
     C                   EVAL      TICBS = *ZEROS
     C                   EVAL      TFRFD = *ZEROS
     C                   EVAL      TINFD = *ZEROS
     C                   EVAL      TSLIP = *ZEROS
     C                   EVAL      TNICD = *ZEROS
     C                   EVAL      TICBD = *ZEROS
     C                   EVAL      TICFD = *ZEROS
     C                   EVAL      TNIPD = *ZEROS
     C                   EVAL      TIPBD = *ZEROS
     C                   EVAL      TIPFD = *ZEROS
     C                   EVAL      TBCXR = *ZEROS
     C                   EVAL      TIACD = *ZEROS
     C                   EVAL      TIALC = *ZEROS
     C                   EVAL      TAITC = *ZEROS
     C                   EVAL      TAIPD = *ZEROS
     C                   EVAL      TAIAN = *ZEROS
     C                   EVAL      TAIAP = *ZEROS
     C                   EVAL      TIPRD = *ZEROS
     C                   EVAL      TIPRM = *ZEROS
     C                   EVAL      TNSAM = *ZEROS
     C                   EVAL      TTAXD = *ZEROS
     C                   EVAL      TTAXM = *ZEROS
     C                   EVAL      CLRAT = *ZEROS
     C                   EVAL      FLRAT = *ZEROS
     C                   EVAL      AVPER = *ZEROS
     C                   EVAL      TIRAT = *ZEROS
     C                   EVAL      AACRT = *ZEROS
     C                   EVAL      RSETM = *ZEROS
     C                   EVAL      PSETM = *ZEROS
     C                   EVAL      SDCAR = *ZEROS
     C                   EVAL      ULPCD = *ZEROS
     C                   EVAL      TLPCD = *ZEROS
     C                   EVAL      UAEXA = *ZEROS
     C                   EVAL      TAEXA = *ZEROS
     C                   EVAL      UNRL = *ZEROS
     C                   EVAL      UNRLP = *ZEROS
     C                   EVAL      DDTM = *ZEROS
     C                   EVAL      BRSQ = *ZEROS
     C                   EVAL      LSWC = *ZEROS
     C                   EVAL      LSWS = *ZEROS
     C                   EVAL      ORED = *ZEROS
     C                   EVAL      LCD = *ZEROS
     C                   EVAL      TNLU = *ZEROS
     C                   EVAL      UNPCD = *ZEROS
     C                   EVAL      TNPCD = *ZEROS
     C                   EVAL      UPVD = *ZEROS
     C                   EVAL      UPFE = *ZEROS
     C                   EVAL      UPAD = *ZEROS
     C                   EVAL      BODD = *ZEROS
     C                   EVAL      BOVD = *ZEROS
     C                   EVAL      BOAM = *ZEROS
     C                   EVAL      OUSI = *ZEROS
     C                   EVAL      OUSA = *ZEROS
     C                   EVAL      TUSI = *ZEROS
     C                   EVAL      TUSA = *ZEROS
     C                   EVAL      UOBRT = *ZEROS
     C                   EVAL      TOBRT = *ZEROS
     C                   EVAL      UOPAM = *ZEROS
     C                   EVAL      TOPAM = *ZEROS
     C                   EVAL      RSTM = *ZEROS
     C**********         EVAL      ROBN = *ZEROS                                              CSD027
     C**********         EVAL      ROCN = *ZEROS                                              CSD027
     C                   EVAL      ROBN = *BLANKS                                             CSD027
     C                   EVAL      ROCN = *BLANKS                                             CSD027
     C                   EVAL      PSTM = *ZEROS
     C**********         EVAL      POBN = *ZEROS                                              CSD027
     C**********         EVAL      POCN = *ZEROS                                              CSD027
     C                   EVAL      POBN = *BLANKS                                             CSD027
     C                   EVAL      POCN = *BLANKS                                             CSD027
     C                   EVAL      ISDA = *ZEROS
     C                   EVAL      AGDT = *ZEROS
     C                   EVAL      AGVV = *ZEROS
     C                   EVAL      PLULRC = *ZEROS
     C                   EVAL      PLTLRC = *ZEROS
     C                   EVAL      AGVC = *ZEROS
     C                   EVAL      OKACCD = 'Y'
     C                   EVAL      OKDLNO = 'Y'
     C                   EVAL      OKDTYP = 'Y'
     C                   EVAL      OKBRCA = 'Y'
 
      ** Check whether user is a web browser user, if so overwrite              CAP084
     C                   CALL      'SFC000026'                                  CAP084
     C                   PARM      *BLANKS       USER             10            CAP084
      *                                                                         CAP084
     C                   IF        USER <> *BLANKS                              CAP084
     C                   EVAL      PSUser = USER                                CAP084
     C                   ENDIF                                                  CAP084
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
      ** Inputs:
      ** Return code
      ** Mode = '*FRONT' or *BLANK
      ** Response mode
 
     C                   PARM                    RetCodeIn
     C                   PARM                    ModeofOp
     C                   PARM                    RespMode
 
      ** Action Code
      ** Front Office Transaction ID
      ** Front Office Associated Transaction Id
      ** (Midas) Deal Number
      ** (Midas) Associated Deal Number
      ** Booking branch
      ** Deal Type
 
     C                   PARM                    PAcCd
     C                   PARM                    PFOTrId
     C                   PARM                    PFOAsId
     C                   PARM                    PDlno
     C                   PARM                    PLnkd
     C                   PARM                    P1Brca
     C                   PARM                    PDTyp
 
      ** Single Branch Code from SDBANKPD
      ** Default Branch for ZMUSER
      ** Originating Branch/User Validation Required for SDGELRPD
      ** FRA/IRS Authorisation Required                                                       CIR008
      ** FRA/IRS Re-authorise Amended Deals                                                   CIR008
 
     C                   PARM                    BJSBRC
     C                   PARM                    PkDBRC
     C                   PARM                    BKOBUV
     C                   PARM                    BQFIAU                                       CIR008
     C                   PARM                    BQFIRA                                       CIR008
                                                                                              CIR008
      ** FRA/IRS Deals Authorisation                                                          CIR008
                                                                                              CIR008
     C                   PARM                    CIR008                                       CIR008
 
      ** Outputs:
      ** Current Deal in File Format
      ** Action Code OK flag
      ** Deal Number OK flag
      ** Deal Type OK flag
 
     C                   PARM                    CrIRFilFmt
     C                   PARM                    OKACCD
     C                   PARM                    OKDLNO
     C                   PARM                    OKBRCA
     C                   PARM                    OKDTYP
 
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
 
      ** Access Deal Number Record
 
     C     1             CHAIN     FDDLNMLL
 
      ** Database Error
 
     C                   IF        NOT %FOUND(FDDLNMLL) or NODLTF = '*'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'FDDLNMLL'
     C                   EVAL      DBASE = 4
     C                   EVAL      DBKEY = '1     '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Parameters in chaining DLCACFL0
 
     C     KCACF         KLIST
     C                   KFLD                    WkDlNo
     C                   KFLD                    WkDtyp
 
      ** Parameters in chaining SDCWHTPD                                                      CSD015
                                                                                              CSD015
     C     CWHTKy        KLIST                                                                CSD015
     C                   KFLD                    WFunction                                    CSD015
     C                   KFLD                    WIdentifier                                  CSD015
     C                   KFLD                    WBranch                                      CSD015
                                                                                              CSD015
     C                   IN        SDSTAT                                                     CSD015
                                                                                              CSD015
      ** Check if Compliance Watch Enhancement (CSD015) is installed                          CSD015
                                                                                              CSD015
     C                   EVAL      CSC011 = 'N'                                               CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *Blank        PRtCd                                        CSD015
     C                   PARM      '*VERIFY'     POptn                                        CSD015
     C                   PARM      'CSC011'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (PRtCd <> *BLANKS) AND                                     CSD015
     C                             (PRtCd <> '*NRF   ')                                       CSD015
     C                   EVAL      DBKey = 'CSC011'                                           CSD015
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBase = 5                                                  CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRtCd = *Blank                                             CSD015
     C                   EVAL      CSC011 = 'Y'                                               CSD015
     C                   IN        SC24X7                                                     CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check if Compliance Watch Enhancement (CSD015) is installed                          CSD015
                                                                                              CSD015
     C                   EVAL      CSD015 = 'N'                                               CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *Blank        PRtCd                                        CSD015
     C                   PARM      '*VERIFY'     POptn                                        CSD015
     C                   PARM      'CSD015'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (PRtCd <> *BLANKS) AND                                     CSD015
     C                             (PRtCd <> '*NRF   ')                                       CSD015
     C                   EVAL      DBKey = 'CSD015'                                           CSD015
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBase = 6                                                  CSD015
     C                   EXSR      *PSSR                                                      CSD015
                                                                                              CSD015
     C**********         ELSE                                                        CSD015 AR816302
     C                   ENDIF                                                              AR816302
                                                                                            AR816302
     C                   IF        PRtCd = *BLANKS                                          AR816302
     C                   EVAL      CSD015 = 'Y'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check if function code is being monitored by the compliance watch                    CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y'                                               CSD015
     C                   CLEAR                   SDWLCC                                       CSD015
     C                   CALLB     'AOWLCCR0'                                                 CSD015
     C                   PARM      *Blank        PRtCd                                        CSD015
     C                   PARM      '*KEY   '     POptn                                        CSD015
     C                   PARM      'DEALING'     PFunc                                        CSD015
     C     SDWLCC        PARM      SDWLCC        DSSDY                                        CSD015
                                                                                              CSD015
      ** If return code not blank, then issue database errror                                 CSD015
                                                                                              CSD015
     C                   IF        PRtCd <> *Blanks                                           CSD015
     C                             AND PRtCd <> '*NRF  '                                      CSD015
     C                   EVAL      DBKey = 'DEALING'                                          CSD015
     C                   EVAL      DBFile = 'SDWLCCPD'                                        CSD015
     C                   EVAL      DBase = 7                                                  CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
                                                                                              CAP185
      ** Check if CAP185 is installed                                                         CAP185
     C                   CALLB     'AOSARDR0'                                                 CAP185
     C                   PARM      *BLANKS       @RTCD             7                          CAP185
     C                   PARM      '*VERIFY'     @OPTN             7                          CAP185
     C                   PARM      'CAP185'      @SARD             6                          CAP185
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP185
     C*                                                                                       CAP185
     C                   IF        @RTCD = *BLANK                                             CAP185
     C                   MOVE      'Y'           CAP185            1                          CAP185
      *                                                                                       CAP185
      ** Determine if Auto-authorise                                                          CAP185
     C     *LIKE         DEFINE    APNAME        @APINAME                                     CAP185
     C                   MOVEL     'CACF'        @APINAME                                     CAP185
     C     @APINAME      CHAIN     APICFGL0                                                   CAP185
     C                   IF        %FOUND(APICFGL0)                                           CAP185
     C                   MOVE      APAUT         @AUTHO            1                          CAP185
     C                   ENDIF                                                                CAP185
      *                                                                                       CAP185
     C                   ELSE                                                                 CAP185
     C                   IF        @RTCD = '*NRF'                                             CAP185
     C                   MOVE      'N'           CAP185                                       CAP185
     C                   ELSE                                                                 CAP185
     C*                                                                                       CAP185
     C**    Database error processing                                                         CAP185
     C*                                                                                       CAP185
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CAP185
     C                   MOVEL     '185'         DBASE                          * DBERR 185 * CAP185
     C                   MOVEL     'CAP185'      DBKEY                          ************* CAP185
     C                   EXSR      *PSSR                                                      CAP185
     C                   END                                                                  CAP185
     C                   END                                                                  CAP185
                                                                                              CSD083
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALL      'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRTCD                                        CSD083
     C                   PARM      '*VERIFY'     POPTN                                        CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   If        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBKEY = 'CSD083'                                           CSD083
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBASE = 8                                                  CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
      *                                                                                       CSD083
     C                   IF        PRTCD = *BLANKS                                            CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
      ** Check if CSC054 is on                                                              AR996631
      *                                                                                     AR996631
     C                   CALLB     'AOSARDR0'                                               AR996631
     C                   PARM      *BLANKS       PRTCD                                      AR996631
     C                   PARM      '*VERIFY'     POPTN                                      AR996631
     C                   PARM      'CSC054'      PSARD                                      AR996631
     C     SCSARD        PARM      SCSARD        DSFDY                                      AR996631
      *                                                                                     AR996631
      ** An NRF (No Record Found) return code is valid.                                     AR996631
      ** Issue database error only for error return codes.                                  AR996631
      *                                                                                     AR996631
     C                   IF        PRTCD <> *BLANKS                                         AR996631
     C                             AND PRTCD <> '*NRF   '                                   AR996631
     C                   EVAL      DBFile = 'SCSARDPD'                                      AR996631
     C                   EVAL      DBKey = 'CSC054'                                         AR996631
     C                   EVAL      DBASE = 3                                                AR996631
     C                   EXSR      *PSSR                                                    AR996631
     C                   ENDIF                                                              AR996631
      *                                                                                     AR996631
     C                   EVAL      CSC054 = 'N'                                             AR996631
     C                   EVAL      WPEAInd = 'N'                                            AR996631
     C                   IF        PRTCD = *BLANKS                                          AR996631
     C                   EVAL      CSC054 = 'Y'                                             AR996631
      *                                                                                     AR996631
     C                   CALL      'AOSVALR0'                                               AR996631
     C                   PARM      *BLANKS       PRetCode                                   AR996631
     C                   PARM      PSysVal1      P@OP01                                     AR996631
     C                   PARM      *BLANKS       P@VL01                                     AR996631
     C                   PARM      *BLANKS       P@OP02                                     AR996631
     C                   PARM      *BLANKS       P@VL02                                     AR996631
     C                   PARM      *BLANKS       P@OP03                                     AR996631
     C                   PARM      *BLANKS       P@VL03                                     AR996631
     C                   PARM      *BLANKS       P@OP04                                     AR996631
     C                   PARM      *BLANKS       P@VL04                                     AR996631
     C                   PARM      *BLANKS       P@OP05                                     AR996631
     C                   PARM      *BLANKS       P@VL05                                     AR996631
     C                   PARM      *BLANKS       P@OP06                                     AR996631
     C                   PARM      *BLANKS       P@VL06                                     AR996631
     C                   PARM      *BLANKS       P@OP07                                     AR996631
     C                   PARM      *BLANKS       P@VL07                                     AR996631
     C                   PARM      *BLANKS       P@OP08                                     AR996631
     C                   PARM      *BLANKS       P@VL08                                     AR996631
     C                   PARM      *BLANKS       P@OP09                                     AR996631
     C                   PARM      *BLANKS       P@VL09                                     AR996631
     C                   PARM      *BLANKS       P@OP10                                     AR996631
     C                   PARM      *BLANKS       P@VL10                                     AR996631
      *                                                                                     AR996631
     C                   IF        PRetCode  <> *BLANKS                                     AR996631
     C                   EVAL      DBFile = 'SDSVALPD'                                      AR996631
     C                   EVAL      DBKEy = '*KEY   '                                        AR996631
     C                   EVAL      DBase = 4                                                AR996631
     C                   EXSR      *PSSR                                                    AR996631
     C                   ENDIF                                                              AR996631
      *                                                                                     AR996631
     C                   MOVEL     P@VL01        WPEAInd                                    AR996631
      *                                                                                     AR996631
     C                   ENDIF                                                              AR996631
      *                                                                                       CAP185
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
