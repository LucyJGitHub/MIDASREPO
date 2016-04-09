     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR FRA retrieval + act code/deal validation')    *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRFRARTV - Forward Rate Aggreements Retrieve                 *
      *             (WITH ACTION CODE VERSUS DEAL NUMBER VALIDATION   *
      *                                                               *
      *  Function:  This module retrieves an FRA deal from            *
      *             the database. As it does so, it validates the     *
      *             action code and deal number.                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 MD000091           Date 08May13               *
      *                 AR996631           Date 28Jun12               *
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
      *                 CDL028             Date 07Feb05               *
      *                 229544             Date 15Sep04               *
      *                 BUG5268            Date 24Jan05               *
      *                 BUG4756            Date 05Nov04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 225811 (BG1770)    Date 18Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAP084             Date 30Jul03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 CSD015             Date 14Oct02               *
      *                 CAS004             Date 26Jun02               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR005             Date 21Jan00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP006             Date 15Mar97               *
      *                 CAP003  *CREATE    Date 22Jun98               *
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
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  229544 - Recompiled due to inserted fields in DLCHISPD.      *
      *  BUG5268 - Cannot authorise FRA when signed on as different   *
      *            user than input user.                              *
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
      *  225811 - User on FRAs/IRSs sent through APISERVER is ignored *
      *           BG1770 is applying this Release 5.0 fix to MidasPlus*
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAP084 - API wrapper project                                 *
      *         - Re-compile due to change in IRFRAPD                 *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  217684 - Authorisation User Malfunction                      *
      *  CAP056 - Automatic Authorisation of Interface deals          *
      *           Initialise numeric fields of File format DS to zero *
      *  CIR008 - FRA/IRS Deals Authorisation                         *
      *  CIR005 - FRA/IRS Business Day Conventions. Recompiled.       *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP006 - Do not check for FXM0164 if deal number has been    *
      *           generated through APIs                              *
      *  CAP003 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FIRFRAL0   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DEALSDGF:IRFRAL0F)
     FDLDLDGLE  IF   E           K DISK    INFSR(*PSSR)
     F
     FDEALSALL  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FXDEALP0:FXDLALL)
     F                                     RENAME(MMDELDP0:MMDELALL)
     F                                     RENAME(MMDENSP0:MMDESALL)
     F                                     RENAME(MMDENBP0:MMDEBALL)
     F                                     RENAME(DEALSDGF:DLSDGALL)
     FFDDLNMLL  IF   E             DISK    INFSR(*PSSR)
                                                                                              CSD015
      ** Compliance Watch Hit List                                                            CSD015
     FSDCWHTL1  IF   E           K DISK    INFSR(*PSSR)                                       CSD015
                                                                                              CAP185
      ** Midas AP API Configuration                                                           CAP185
     FAPICFGL0  IF   E           K DISK    INFSR(*PSSR)                                       CAP185
 
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
 
      ** 24X7 status data area                                                                CSD015
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSD015
                                                                                              CSD015
      ** SD data area                                                                         CSD015
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSD015
                                                                                              CSD015
      **  Data structure for file status of FRA deals file.
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D  ACCDBK       E                     EXTFLD(QQACCD)                                     CGL029
      ** EXTERNAL DS FOR DEALING DETAILS
 
     D SDFAIS        E DS                  EXTNAME(SDFAISPD)                                  CIR008
      ** External DS for FRA/IRS ICD Dat                                                      CIR008
                                                                                              CIR008
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** EXTERNAL DS FOR BRANCH DETAILS
     D/COPY WNCPYSRC,IRH00048
 
      ** External DS for SAR details                                                          CSD015
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD015
     D  #LCD         E                     EXTFLD(LCD)                                        CSD015
                                                                                              CSD015
      ** External DS for Compliance Watch Transaction Details                                 CSD015
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
                                                                                              CSD015
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D ZMUSER          DS            17
     D**USRID***************** 1     10                                                CAP084 225811
     D  ZUSER                  1     10                                                       225811
     D  BRC                   11     13
     D  DEPT                  14     16
 
     D DealFilFmt    E DS                  EXTNAME(DEALSDG)
      ** Deal in File Format
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
                                                                                              CIR008
     D CIR008          S              1                                                       CIR008
     D PRetCode        S              7                                                       CIR008
     D POption         S              7                                                       CIR008
                                                                                              CSD015
     D CSC011          S              1                                                       CSD015
     D CSD015          S              1                                                       CSD015
     D WFuncType       S              8                                                       CSD015
     D WIdntifier      S             40                                                       CSD015
     D WBranch         S              3                                                       CSD015
     D PSard           S              6                                                       CSD015
     D PFunc           S              8                                                       CSD015
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
     D PSysVal1        C                   CONST('PEAIndicator')                            AR996631
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
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * INITIALIZATION
     C                   EXSR      INIT
 
      * IF THE MODE IS 'FRONT OFFICE TRANSACTION INTERFACE'
      * DO (EXTRA) VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
     C     ModeofOp      IFEQ      '*FRONT'
     C                   EXSR      VFRNT
 
      **  Carry out no further validation if errors have occurred.
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   RETURN
     C                   END
     C/COPY WNCPYSRC,IRH00024
     C                   END
 
      * VALIDATE ACTION CODE & DEAL NUMBER
     C                   EXSR      VAL
 
      **  Carry out no further validation if errors have occurred.
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   RETURN
     C                   END
 
      *  *--------------------------------*
      *  * Validation for Action Code 'E' *
      *  *--------------------------------*
     C     SACCD         IFEQ      'E'
     C                   EXSR      VALACE
     C                   END
                                                                                              CIR008
      ** Validation for Action Code 'X'                                                       CIR008
                                                                                              CIR008
     C                   IF        SACCD = 'X' AND CIR008 = 'Y'                               CIR008
     C                   EXSR      SRValAcX                                                   CIR008
     C                   ENDIF                                                                CIR008
 
      *  *--------------------------------*
      *  * Validation for Action Code 'I' *
      *  *--------------------------------*
      *  (only if the deal no. is not to be generated.)
     C/COPY WNCPYSRC,IRFRAIC001
     C     SACCD         IFEQ      'I'
     C     SDLNO         ANDNE     *BLANKS
     C                   EXSR      VALACI
     C                   END
 
      *  *--------------------------------*
      *  * Validation for Action Code 'A' *
      *  *--------------------------------*
     C     SACCD         IFEQ      'A'
     C                   EXSR      VALACA
     C                   END
 
      *  *--------------------------------*
      *  * Validation for Action Code 'D' *
      *  *--------------------------------*
     C     SACCD         IFEQ      'R'
     C                   EXSR      VALACD
     C                   END
 
     C/COPY WNCPYSRC,IRH00025
      **  Carry out no further validation if errors occurred.
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   RETURN
     C                   END
 
      *  *-----------------------------------------------*
      *  * Access Security Checking                      *
      *  *-----------------------------------------------*
     C     RespMode      IFEQ      'S'
     C                   EXSR      ACSSEC
     C                   END
 
      * Return
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *****************************************************************
     C     VFRNT         BEGSR
 
      * ERROR IF ACTION CODE IS NOT 'I', 'A, or 'D'
     C     SACCD         IFNE      'I'
     C     SACCD         ANDNE     'A'
     C     SACCD         ANDNE     'R'
                                                                                              CIR008
     C     CIR008        IFEQ      'N'                                                        CIR008
     C     SACCD         ORNE      'X'                                                        CIR008
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SACCD '
     C**********         MOVEL     'APM0100'     MsgIdArr(Idx)                                CIR008
     C                   IF        CIR008 = 'N'                                               CIR008
     C                   EVAL      MsgIdArr(Idx) = 'MMM3005'                                  CIR008
     C                   ELSE                                                                 CIR008
     C                   EVAL      MsgIdArr(Idx) = 'MMM3012'                                  CIR008
     C                   ENDIF                                                                CIR008
     C                   GOTO      EVFRNT
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
     C                   END
 
      * ERROR IF FRONT OFFICE TRANSACTION ID IS BLANK
     C     FOTRID        IFEQ      *BLANK
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SACCD '
     C                   MOVEL     'APM0101'     MsgIdArr(Idx)
     C                   GOTO      EVFRNT
     C                   END
 
      * ACCESS DEAL WITH FRONT OFFICE TRANSACTION ID
     C     FOTRID        CHAIN     IRFRAL0F                           99
 
      * IF INSERT
     C     SACCD         IFEQ      'I'
 
      * FRONT OFFICE TRANSACTION ID CAN'T BE PRESENT ALREADY
     C     *IN99         IFEQ      '0'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SACCD '
     C                   MOVEL     'APM0102'     MsgIdArr(Idx)
     C**********         MOVEL     FOTRID        MsgDtaArr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(FOTRID)                   MD000091
     C                   GOTO      EVFRNT
     C                   END
 
     C                   ELSE
 
      * IF NOT INSERT, FRONT OFFICE TRANSACTION ID MUST BE PRESENT
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SACCD '
     C                   MOVEL     'APM0103'     MsgIdArr(Idx)
     C**********         MOVEL     FOTRID        MsgDtaArr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(FOTRID)                   MD000091
     C                   GOTO      EVFRNT
     C                   END
 
      * IF NOT INSERT, UPDATE MIDAS DEAL NUMBER
     C                   MOVEL     DLNO          SDLNO
 
     C                   END
 
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - VALIDATION OF ACTION CODE AND DEAL NUMBER
      *****************************************************************
     C     VAL           BEGSR
 
      **  Check that the action code is valid
 
     C     SACCD         IFNE      'I'
     C     SACCD         ANDNE     'A'
     C     SACCD         ANDNE     'R'
     C     SACCD         ANDNE     'E'
                                                                                              CIR008
     C                   IF        CIR008 = 'N' OR                                            CIR008
     C                             BQFIAU = 'N' AND BQFIRA = 'N'                              CIR008
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SACCD '
     C                   IF        CIR008 = 'Y'                                               CIR008
     C                   EVAL      MsgIdArr(Idx) = 'MMM9034'                                  CIR008
     C                   ELSE                                                                 CIR008
     C                   MOVEL     'FDM0101'     MsgIdArr(Idx)
     C                   ENDIF                                                                CIR008
     C                   ENDIF                                                                CIR008
     C                                                                                        CIR008
     C                   END
                                                                                              CIR008
      ** CIR008 is installed.                                                                 CIR008
                                                                                              CIR008
     C                   IF        CIR008 = 'Y' AND                                           CIR008
     C                             (BQFIAU = 'Y' OR BQFIRA = 'Y') AND                         CIR008
     C                             SACCD <> 'I' AND SACCD <> 'A' AND                          CIR008
     C                             SACCD <> 'R' AND SACCD <> 'E' AND                          CIR008
     C                             SACCD <> 'X'                                               CIR008
     C                   EVAL      OKACTN = 'N'                                               CIR008
     C                   EVAL      Idx = Idx + 1                                              CIR008
     C                   EVAL      FldNameArr(Idx) = 'SACCD '                                 CIR008
     C                   EVAL      MsgIdArr(Idx) = 'MMM9035'                                  CIR008
     C                   ENDIF                                                                CIR008
 
      **  If the deal number is not blank, check that it is numeric.
     C                   TESTN                   SDLNO                98
     C                   MOVE      SDLNO         @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C     SDLNO         IFNE      *BLANKS
     C     *IN98         ANDEQ     '0'
     C     SDLNO         ORNE      *BLANKS
     C     *IN99         ANDEQ     '0'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SDLNO '
     C                   MOVEL     'MMM0162'     MsgIdArr(Idx)
     C                   GOTO      EVAL
     C                   END
 
      **  Set up the deal number as a numeric field.
     C                   MOVE      SDLNO         @@DLNO            6 0
      *
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACE - VALIDATION OF ACTION CODE 'E'
      *****************************************************************
     C     VALACE        BEGSR
 
      **  If the deal number is blank, it is an error.
 
     C     SDLNO         IFEQ      *BLANKS
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SDLNO '
     C                   MOVEL     'MMM0111'     MsgIdArr(Idx)
     C                   GOTO      EVALAE
     C                   END
 
     C**  If there is no valid record on DLDLDGLE, it is an error.
     C     @@DLNO        CHAIN     DLDLDGLE                           65
 
      **  Check for a valid record.
     C     *IN65         IFEQ      '1'
     C     DTYP          ORNE      'FR'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SDLNO '
     C                   MOVEL     'FXM0098'     MsgIdArr(Idx)
     C                   GOTO      EVALAE
     C                   END
                                                                                              CIR008
      ** If the deal status is not C, A, R or M, it is an error                               CIR008
                                                                                              CIR008
     C                   IF        CIR008 = 'Y' AND                                           CIR008
     C                             FIDSTS <> 'C' AND FIDSTS <> 'A' AND                        CIR008
     C                             FIDSTS <> 'R' AND FIDSTS <> 'M'                            CIR008
     C                   EVAL      OKDLNO = 'N'                                               CIR008
     C                   EVAL      Idx = Idx + 1                                              CIR008
     C                   EVAL      FldNameArr(Idx) = 'SDLNO '                                 CIR008
     C                   EVAL      MsgIdArr(Idx)   = 'MMM9033'                                CIR008
     C                   GOTO      EVALAE                                                     CIR008
     C                   ENDIF                                                                CIR008
 
     C     EVALAE        ENDSR
      *****************************************************************
      /EJECT                                                                                  CIR008
      *****************************************************************                       CIR008
      *                                                               *                       CIR008
      *  SRValAcX - Validation for Action Code 'X'                    *                       CIR008
      *                                                               *                       CIR008
      *****************************************************************                       CIR008
     C     SRValAcX      BEGSR                                                                CIR008
                                                                                              CIR008
      **  If the deal number is blank, it is an error.                                        CIR008
                                                                                              CIR008
     C                   IF        SDLNO = *BLANKS                                            CIR008
     C                   EVAL      OKDLNO = 'N'                                               CIR008
     C                   EVAL      Idx = Idx + 1                                              CIR008
     C                   EVAL      FldNameArr(Idx) = 'SDLNO '                                 CIR008
     C                   EVAL      MsgIdArr(Idx) = 'MMM0111'                                  CIR008
     C                   GOTO      ESrValX                                                    CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
     C     @@DLNO        CHAIN     DLDLDGLE                           65                      CIR008
                                                                                              CIR008
     C                   IF        *IN65 = *ON OR DTYP <> 'FR'OR RECI <> 'D'                  CIR008
     C                   EVAL      OKDLNO = 'N'                                               CIR008
     C                   EVAL      Idx = Idx + 1                                              CIR008
     C                   EVAL      FldNameArr(Idx) = 'SDLNO '                                 CIR008
     C                   EVAL      MsgIdArr(Idx) = 'MMM9031'                                  CIR008
     C                   GOTO      ESrValX                                                    CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
      ** Deal Status must be 'C' or 'R'                                                       CIR008
                                                                                              CIR008
     C                   IF        FIDSTS <> 'C' AND FIDSTS <> 'R'                            CIR008
     C                   EVAL      OKDLNO = 'N'                                               CIR008
     C                   EVAL      Idx = Idx + 1                                              CIR008
     C                   EVAL      FldNameArr(Idx) = 'SDLNO '                                 CIR008
     C                   EVAL      MsgIdArr(Idx) = 'MMM0171'                                  CIR008
     C                   GOTO      ESrValX                                                    CIR008
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
                                                                                              CIR008
     C*******************IF        FIUSRI = PSUser                                     CIR008 CAP084
     C*******************          or FIUSRA = PSUser                                  217684 CAP084
     C*******************IF        FIUSRI = USRID                                      CAP084 225811
     C*******************          or FIUSRA = USRID                                   CAP084 225811
                                                                                             BUG4756
     C                   CALL      'SFC000026'                                               BUG4756
     C                   PARM      *BLANKS       USER             10                         BUG4756
                                                                                             BUG4756
     C                   IF        USER <> *BLANKS                                           BUG4756
     C                   EVAL      PSUser = USER                                             BUG4756
     C                   ENDIF                                                               BUG4756
                                                                                             BUG4756
     C                   IF        FIUSRI = ZUSER                                             225811
     C                             or FIUSRA = ZUSER                                          225811
     C                   EVAL      OKDLNO = 'N'                                               CIR008
     C                   EVAL      Idx = Idx + 1                                              CIR008
     C                   EVAL      FldNameArr(Idx) = 'SDLNO '                                 CIR008
     C                   EVAL      MsgIdArr(Idx) = 'MMM9032'                                  CIR008
     C                   GOTO      ESrValX                                                    CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
     C                   ENDIF                                                                CAP185
                                                                                              CAP185
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                              CSD015
     C                             AND (CSC011 = 'N' OR CSC011 = 'Y'                          CSD015
     C                             AND LIBR = S1MAIN)                                         CSD015
                                                                                              CSD015
      ** If the FRA transaction exists in the hit list, setup error message                   CSD015
                                                                                              CSD015
     C                   EVAL      WFuncType = 'DEALSDG'                                      CSD015
     C                   MOVEL     DLNO          WIdntifier                                   CSD015
     C                   EVAL      WBranch = BRCA                                             CSD015
                                                                                              CSD015
     C     KCwFld        CHAIN     SDCWHTL1                                                   CSD015
     C                   IF        %FOUND(SDCWHTL1) AND W3TREL <> 'Y'                         CSD015
     C                   EVAL      OKDLNO = 'N'                                               CSD015
     C                   EVAL      Idx = Idx + 1                                              CSD015
     C                   EVAL      FldNameArr(Idx) = 'DLNO  '                                 CSD015
     C                   EVAL      MsgIdArr(Idx) = 'MMM0797'                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              225811
     C                   EVAL      FIUSRX = ZUSER                                             225811
                                                                                              CSD015
     C     ESrValX       ENDSR                                                                CIR008
      *****************************************************************                       CIR008
      /EJECT
      *****************************************************************
      * VALACI - VALIDATION OF ACTION CODE 'I'
      *****************************************************************
     C     VALACI        BEGSR
 
      **  Check that the deal does not exist on any Deals File
      **  Midas or DRS. If it does it's an error.
     C     @@DLNO        SETLL     DEALSALL                               65
     C     *IN65         IFEQ      '1'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SDLNO '
     C                   MOVEL     'MMM0163'     MsgIdArr(Idx)
     C                   GOTO      EVALAI
     C                   END
 
     C                   IF        WPEAInd <> 'Y'                                           AR996631
      **  Check that the deal number is in the allowed range.
      ** (do not check if deal number generated through APIs)                   CAP006
     C     @@DLNO        IFLT      NORDLN
     C     @@DLNO        OREQ      999999
     C     ModeofOp      IFNE      '*FRONT'                                     CAP006
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SDLNO '
     C                   MOVEL     'MMM0164'     MsgIdArr(Idx)
     C                   GOTO      EVALAI
     C                   END                                                    CAP006
     C                   END
     C                   ENDIF                                                              AR996631
                                                                                              225811
     C                   EVAL      FIUSRI = ZUSER                                             225811
 
     C     EVALAI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACA - VALIDATION OF ACTION CODE 'A'
      *****************************************************************
     C     VALACA        BEGSR
 
      **  If the deal number is blank, it is an error.
     C     SDLNO         IFEQ      *BLANKS
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SDLNO '
     C                   MOVEL     'MMM0111'     MsgIdArr(Idx)
     C                   GOTO      EVALAA
     C                   END
 
      **  If there is no valid, undeleted record on DLDLDGLE, it is an
      **  error.
     C     @@DLNO        CHAIN     DLDLDGLE                           65
 
      **  Check for a valid record.
     C     *IN65         IFEQ      '1'
     C     RECI          ORNE      'D'
     C     DTYP          ORNE      'FR'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SDLNO '
     C                   MOVEL     'FXM0003'     MsgIdArr(Idx)
     C                   GOTO      EVALAA
     C                   END
 
      **  If the deal has been deleted, then it may not be amended.
     C     RECI          IFEQ      'R'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SDLNO '
     C                   MOVEL     'FXM0007'     MsgIdArr(Idx)
     C                   GOTO      EVALAA
     C                   END
                                                                                              CIR008
      ** If the deal exists, the status must be C, A or R                                     CIR008
                                                                                              CIR008
     C                   IF        CIR008 = 'Y' AND                                           CIR008
     C                             FIDSTS <> 'C' AND FIDSTS <> 'A' AND                        CIR008
     C                             FIDSTS <> 'R'                                              CIR008
     C                   EVAL      OKDLNO = 'N'                                               CIR008
     C                   EVAL      Idx = Idx + 1                                              CIR008
     C                   EVAL      FldNameArr(Idx) = 'SDLNO '                                 CIR008
     C                   EVAL      MsgIDArr(Idx) = 'MMM0166'                                  CIR008
     C                   GOTO      EVALAA                                                     CIR008
     C                   ENDIF                                                                CIR008
                                                                                              225811
     C                   EVAL      FIUSRA = ZUSER                                             225811
 
     C     EVALAA        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACD - VALIDATION OF ACTION CODE 'D'
      *****************************************************************
     C     VALACD        BEGSR
 
      **  If the deal number is blank, it is an error.
     C     SDLNO         IFEQ      *BLANKS
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SDLNO '
     C                   MOVEL     'MMM0111'     MsgIdArr(Idx)
     C                   GOTO      EVALAD
     C                   END
 
      **  If there is no valid, undeleted record on DLDLDGLE, it is an
      **  error.
     C     @@DLNO        CHAIN     DLDLDGLE                           65
 
      **  Check for a valid record.
     C     *IN65         IFEQ      '1'
     C     DTYP          ORNE      'FR'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SDLNO '
     C                   MOVEL     'MMM2623'     MsgIdArr(Idx)
     C                   GOTO      EVALAD
     C                   END
 
      **  If a valid record exists but has already been deleted
      **  it is an error.
     C     RECI          IFEQ      'R'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SDLNO '
     C                   MOVEL     'MMM0172'     MsgIdArr(Idx)
     C                   GOTO      EVALAD
     C                   END
                                                                                              CIR008
      ** The deal status must be 'C' or 'A'                                                   CIR008
                                                                                              CIR008
     C                   IF        CIR008 = 'Y' AND                                           CIR008
     C                             FIDSTS <> 'C' AND FIDSTS <> 'A'                            CIR008
     C                   EVAL      OKDLNO = 'N'                                               CIR008
     C                   EVAL      Idx = Idx + 1                                              CIR008
     C                   EVAL      FldNameArr(Idx) = 'SDLNO '                                 CIR008
     C                   EVAL      MsgIdArr(Idx) = 'MMM0169'                                  CIR008
     C                   GOTO      EVALAD                                                     CIR008
     C                   ENDIF                                                                CIR008
 
     C     EVALAD        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSSEC - ACCESS SECURITY CHECKING
      *****************************************************************
     C     ACSSEC        BEGSR
 
      * If not multi-branching, check authority to only action code
     C     BJSBRC        IFNE      *BLANK
     C                   CALL      'ZVACTU'
     C                   PARM      SACCD         ZACTN             1
     C                   PARM                    @@ERR             1 0
     C     @@ERR         IFEQ      1
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SACCD '
     C                   MOVEL     'FXM0292'     MsgIdArr(Idx)
     C                   GOTO      EACSSE
     C                   END
     C                   END
 
      * If multi-branching, check authority to booking branch
     C     BJSBRC        IFEQ      *BLANK
     C     SACCD         IFEQ      'I'
     C     SBRCA         IFEQ      *BLANKS
     C                   MOVE      BRC           ZBR
     C                   MOVE      BRC           SBRCA
     C                   ELSE
     C                   MOVE      SBRCA         ZBR
     C                   END
     C                   ELSE
     C                   MOVE      BRCA          ZBR
     C                   END
     C     SACCD         IFEQ      'I'
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      SBRCA         @DSNB             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           OKBRCA
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SBRCA '
     C                   MOVEL     'MMM0115'     MsgIdArr(Idx)
     C                   GOTO      EACSSE
     C                   ELSE
     C                   MOVEL     A8BRCD        ZBR
     C                   MOVEL     A8BRCD        SBRCA
     C                   END
     C                   END
     C                   CALL      'ZVACTBU'
     C                   PARM      SACCD         ZACTN             1
     C                   PARM                    ZBR               3
     C                   PARM                    @@ERR             1 0
     C     @@ERR         IFEQ      1
     C                   MOVE      'N'           OKACTN
 
      ** (If Insert then highlight branch field else deal number)
     C     SACCD         IFEQ      'I'
     C                   MOVE      'N'           OKBRCA
     C                   ELSE
     C                   MOVE      'N'           OKDLNO
     C                   END
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SACCD '
     C                   MOVEL     'FXM0290'     MsgIdArr(Idx)
     C                   GOTO      EACSSE
     C                   END
     C     @@ERR         IFEQ      2
     C                   MOVE      'N'           OKACTN
 
      ** (If Insert then highlight branch field else deal number)
     C     SACCD         IFEQ      'I'
     C                   MOVE      'N'           OKBRCA
     C                   ELSE
     C                   MOVE      'N'           OKDLNO
     C                   END
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SACCD '
     C                   MOVEL     'FXM0291'     MsgIdArr(Idx)
     C                   GOTO      EACSSE
     C                   END
 
      * Check authority to originating branch
     C     BKOBUV        IFEQ      'Y'
     C     SACCD         ANDNE     'E'
     C     SACCD         ANDNE     'I'
     C                   CALL      'ZVOBU'
     C                   PARM      ORBR          ZOBRX             3
     C                   PARM                    @@ERR             1 0
     C     @@ERR         IFEQ      1
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SACCD '
     C                   MOVEL     'FXM0287'     MsgIdArr(Idx)
     C                   GOTO      EACSSE
     C                   END
     C     @@ERR         IFEQ      2
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SACCD '
     C                   MOVEL     'FXM0288'     MsgIdArr(Idx)
     C                   GOTO      EACSSE
     C                   END
     C                   END
     C                   END
 
     C     EACSSE        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
 
      * CLEAR OUTPUTS
     C                   CLEAR                   DealFilFmt
     C                   EVAL      DLNO = *ZEROS                                              CAP056
     C                   EVAL      RCDC = *ZEROS                                              CAP056
     C**********         EVAL      CNUM = *ZEROS                                       CAP056 CSD027
     C                   EVAL      CNUM = *BLANKS                                             CSD027
     C                   EVAL      DDAT = *ZEROS                                              CAP056
     C                   EVAL      VDAT = *ZEROS                                              CAP056
     C                   EVAL      MDAT = *ZEROS                                              CAP056
     C                   EVAL      CDAS = *ZEROS                                              CAP056
     C                   EVAL      BAGE = *ZEROS                                              CAP056
     C                   EVAL      LNKDN = *ZEROS                                             CAP056
     C                   EVAL      UPAMT = *ZEROS                                             CAP056
     C                   EVAL      UBRTT = *ZEROS                                             CAP056
     C                   EVAL      USTRT = *ZEROS                                             CAP056
     C                   EVAL      UBRTE = *ZEROS                                             CAP056
     C                   EVAL      URTSP = *ZEROS                                             CAP056
     C                   EVAL      UEINR = *ZEROS                                             CAP056
     C                   EVAL      UICBS = *ZEROS                                             CAP056
     C                   EVAL      UFRFD = *ZEROS                                             CAP056
     C                   EVAL      UINFD = *ZEROS                                             CAP056
     C                   EVAL      USLIP = *ZEROS                                             CAP056
     C                   EVAL      UNICD = *ZEROS                                             CAP056
     C                   EVAL      UICBD = *ZEROS                                             CAP056
     C                   EVAL      UICFD = *ZEROS                                             CAP056
     C                   EVAL      UNIPD = *ZEROS                                             CAP056
     C                   EVAL      UIPBD = *ZEROS                                             CAP056
     C                   EVAL      UIPFD = *ZEROS                                             CAP056
     C                   EVAL      UBCXR = *ZEROS                                             CAP056
     C                   EVAL      UIACD = *ZEROS                                             CAP056
     C                   EVAL      UIALC = *ZEROS                                             CAP056
     C                   EVAL      UAITC = *ZEROS                                             CAP056
     C                   EVAL      UAIPD = *ZEROS                                             CAP056
     C                   EVAL      UAIAN = *ZEROS                                             CAP056
     C                   EVAL      UAIAP = *ZEROS                                             CAP056
     C                   EVAL      UIPRD = *ZEROS                                             CAP056
     C                   EVAL      UIPRM = *ZEROS                                             CAP056
     C                   EVAL      UNSAM = *ZEROS                                             CAP056
     C                   EVAL      UTAXD = *ZEROS                                             CAP056
     C                   EVAL      UTAXM = *ZEROS                                             CAP056
     C                   EVAL      TPAMT = *ZEROS                                             CAP056
     C                   EVAL      TBRTT = *ZEROS                                             CAP056
     C                   EVAL      TSTRT = *ZEROS                                             CAP056
     C                   EVAL      TBRTE = *ZEROS                                             CAP056
     C                   EVAL      TRTSP = *ZEROS                                             CAP056
     C                   EVAL      TEINR = *ZEROS                                             CAP056
     C                   EVAL      TICBS = *ZEROS                                             CAP056
     C                   EVAL      TFRFD = *ZEROS                                             CAP056
     C                   EVAL      TINFD = *ZEROS                                             CAP056
     C                   EVAL      TSLIP = *ZEROS                                             CAP056
     C                   EVAL      TNICD = *ZEROS                                             CAP056
     C                   EVAL      TICBD = *ZEROS                                             CAP056
     C                   EVAL      TICFD = *ZEROS                                             CAP056
     C                   EVAL      TNIPD = *ZEROS                                             CAP056
     C                   EVAL      TIPBD = *ZEROS                                             CAP056
     C                   EVAL      TIPFD = *ZEROS                                             CAP056
     C                   EVAL      TBCXR = *ZEROS                                             CAP056
     C                   EVAL      TIACD = *ZEROS                                             CAP056
     C                   EVAL      TIALC = *ZEROS                                             CAP056
     C                   EVAL      TAITC = *ZEROS                                             CAP056
     C                   EVAL      TAIPD = *ZEROS                                             CAP056
     C                   EVAL      TAIAN = *ZEROS                                             CAP056
     C                   EVAL      TAIAP = *ZEROS                                             CAP056
     C                   EVAL      TIPRD = *ZEROS                                             CAP056
     C                   EVAL      TIPRM = *ZEROS                                             CAP056
     C                   EVAL      TNSAM = *ZEROS                                             CAP056
     C                   EVAL      TTAXD = *ZEROS                                             CAP056
     C                   EVAL      TTAXM = *ZEROS                                             CAP056
     C                   EVAL      CLRAT = *ZEROS                                             CAP056
     C                   EVAL      FLRAT = *ZEROS                                             CAP056
     C                   EVAL      AVPER = *ZEROS                                             CAP056
     C                   EVAL      TIRAT = *ZEROS                                             CAP056
     C                   EVAL      AACRT = *ZEROS                                             CAP056
     C                   EVAL      RSETM = *ZEROS                                             CAP056
     C                   EVAL      PSETM = *ZEROS                                             CAP056
     C                   EVAL      SDCAR = *ZEROS                                             CAP056
     C                   EVAL      ULPCD = *ZEROS                                             CAP056
     C                   EVAL      TLPCD = *ZEROS                                             CAP056
     C                   EVAL      UAEXA = *ZEROS                                             CAP056
     C                   EVAL      TAEXA = *ZEROS                                             CAP056
     C                   EVAL      UNRL = *ZEROS                                              CAP056
     C                   EVAL      UNRLP = *ZEROS                                             CAP056
     C                   EVAL      DDTM = *ZEROS                                              CAP056
     C                   EVAL      BRSQ = *ZEROS                                              CAP056
     C                   EVAL      LSWC = *ZEROS                                              CAP056
     C                   EVAL      LSWS = *ZEROS                                              CAP056
     C                   EVAL      ORED = *ZEROS                                              CAP056
     C                   EVAL      LCD = *ZEROS                                               CAP056
     C                   EVAL      TNLU = *ZEROS                                              CAP056
     C                   EVAL      UNPCD = *ZEROS                                             CAP056
     C                   EVAL      TNPCD = *ZEROS                                             CAP056
     C                   EVAL      UPVD = *ZEROS                                              CAP056
     C                   EVAL      UPFE = *ZEROS                                              CAP056
     C                   EVAL      UPAD = *ZEROS                                              CAP056
     C                   EVAL      BODD = *ZEROS                                              CAP056
     C                   EVAL      BOVD = *ZEROS                                              CAP056
     C                   EVAL      BOAM = *ZEROS                                              CAP056
     C                   EVAL      OUSI = *ZEROS                                              CAP056
     C                   EVAL      OUSA = *ZEROS                                              CAP056
     C                   EVAL      TUSI = *ZEROS                                              CAP056
     C                   EVAL      TUSA = *ZEROS                                              CAP056
     C                   EVAL      UOBRT = *ZEROS                                             CAP056
     C                   EVAL      TOBRT = *ZEROS                                             CAP056
     C                   EVAL      UOPAM = *ZEROS                                             CAP056
     C                   EVAL      TOPAM = *ZEROS                                             CAP056
     C                   EVAL      RSTM = *ZEROS                                              CAP056
     C**********         EVAL      ROBN = *ZEROS                                       CAP056 CSD027
     C**********         EVAL      ROCN = *ZEROS                                       CAP056 CSD027
     C                   EVAL      ROBN = *BLANKS                                             CSD027
     C                   EVAL      ROCN = *BLANKS                                             CSD027
     C                   EVAL      PSTM = *ZEROS                                              CAP056
     C**********         EVAL      POBN = *ZEROS                                       CAP056 CSD027
     C**********         EVAL      POCN = *ZEROS                                       CAP056 CSD027
     C                   EVAL      POBN = *BLANKS                                             CSD027
     C                   EVAL      POCN = *BLANKS                                             CSD027
     C                   EVAL      ISDA = *ZEROS                                              CAP056
     C                   EVAL      AGDT = *ZEROS                                              CAP056
     C                   EVAL      AGVV = *ZEROS                                              CAP056
     C                   EVAL      PLULRC = *ZEROS                                            CAP056
     C                   EVAL      PLTLRC = *ZEROS                                            CAP056
     C                   EVAL      AGVC = *ZEROS                                              CAP056
     C                   EVAL      FSRKVL = *ZEROS                                            CAS006
     C                   MOVEL     'Y'           OKACTN
     C                   MOVEL     'Y'           OKDLNO
     C                   MOVEL     'Y'           OKBRCA
      **  GET ZMUSER to access default branch.                                               BUG5268
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG5268
     C                   IN        ZMUSER                                                    BUG5268
     C                   UNLOCK    ZMUSER                                                    BUG5268
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
 
      * Parameters
     C     *ENTRY        PLIST
 
      * INPUTS
      * Return code
     C                   PARM                    RetCodeIn
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      * Response mode
     C                   PARM                    RespMode          1
      * Action Code
     C                   PARM                    SACCD             1
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      * Front Office Associated Transaction Id
     C                   PARM                    FOASID           20
      * (Midas) Deal Number
     C                   PARM                    SDLNO             6
      * (Midas) Associated Deal Number
     C                   PARM                    SLNKDN            6
      * Booking branch
     C                   PARM                    SBRCA             3
      ** Switchable feature CIR008                                                            CIR008
     C                   PARM                    CIR008                                       CIR008
 
      * OUTPUTS
      * (Current) deal in file format
     C                   PARM                    DealFilFmt
      * OK - Action code
     C                   PARM                    OKACTN            1
      * OK - Deal Number
     C                   PARM                    OKDLNO            1
      * OK - Booking branch
     C                   PARM                    OKBRCA            1
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      ** Initialize program name
 
     C                   MOVEL     'IRFRARTV'    DBPGM
 
      ** ACCESS BANK DETAILS
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * DATABASE ERROR
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
 
      ** ACCESS GENERAL LEDGER DETAILS
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      * DATABASE ERROR
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
 
      ** ACCESS DEALING DETAILS
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
      * DATABASE ERROR
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDDEALPD'    DBFILE                         *************
     C                   MOVEL     '903'         DBASE                          * DBERR 903 *
     C                   EXSR      *PSSR                                        *************
     C                   END
                                                                                              CIR008
      ** Access FRA/IRS ICD Data                                                              CIR008
                                                                                              CIR008
     C                   CALL      'AOFAISR0'                                                 CIR008
     C                   PARM      *BLANKS       PRetCode                                     CIR008
     C                   PARM      '*FIRST '     POption                                      CIR008
     C     SDFAIS        PARM      SDFAIS        DSFDY                                        CIR008
                                                                                              CIR008
     C                   IF        PRetCode <> *BLANKS                                        CIR008
     C                   EVAL      DBKEY = POption                                            CIR008
     C                   EVAL      DBFILE = 'SDFAISPD'                                        CIR008
     C                   EVAL      DBASE = 905                                                CIR008
     C                   EXSR      *PSSR                                                      CIR008
     C                   ENDIF                                                                CIR008
     C/COPY WNCPYSRC,IRH00049
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
     C                   MOVEL     'FRA '        @APINAME                                     CAP185
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
      *                                                                                       CAP185
 
      ** ACCESS DEAL NUMBER RECORD
     C     1             CHAIN     FDDLNMLL                           99
 
      * DATABASE ERROR
     C     *IN99         IFEQ      '1'
     C     NODLTF        OREQ      '*'
     C                   MOVEL     '1     '      DBKEY
     C                   MOVEL     'FDDLNMLL'    DBFILE                         *************
     C                   MOVEL     '904'         DBASE                          * DBERR 904 *
     C                   EXSR      *PSSR                                        *************
     C                   END
 
      ****GET*ZMUSER*to*access*default*branch.                                               BUG5268
     C******DTAARA*******DEFINE****              ZMUSER                                      BUG5268
     C*******************IN********ZMUSER                                                    BUG5268
     C*******************UNLOCK****ZMUSER                                                    BUG5268
                                                                                              CSD015
      ** Check if CSC011 is installed                                                         CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRetCode                                     CSD015
     C                   PARM      '*VERIFY'     POption                                      CSD015
     C                   PARM      'CSC011'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
     C                   IF        PRetCode = *Blanks                                         CSD015
     C                   EVAL      CSC011 = 'Y'                                               CSD015
     C                   IN        SC24X7                                                     CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      CSC011 = 'N'                                               CSD015
                                                                                              CSD015
     C                   IF        PRetCode <> '*NRF'                                         CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = 'CSC011'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 908                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IN        SDSTAT                                                     CSD015
                                                                                              CSD015
      ** Check if Compliance Watch Enhancment (CSD015) is on.                                 CSD015
                                                                                              CSD015
     C                   EVAL      CSD015 = 'N'                                               CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRetCode                                     CSD015
     C                   PARM      '*VERIFY'     POption                                      CSD015
     C                   PARM      'CSD015'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (PRetCode <> *BLANKS) and                                  CSD015
     C                             (PRetCode <> '*NRF   ')                                    CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = 'CSD015'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 906                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRetCode = *BLANKS                                         CSD015
     C                   EVAL      CSD015 = 'Y'                                               CSD015
                                                                                              CSD015
      ** Access Compliance Watch Transaction details                                          CSD015
                                                                                              CSD015
     C                   CALL      'AOWLCCR0'                                                 CSD015
     C                   PARM      *BLANKS       PRetCode                                     CSD015
     C                   PARM      '*KEY    '    POption                                      CSD015
     C                   PARM      'DEALING '    PFunc                                        CSD015
     C     SDWLCC        PARM      SDWLCC        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database Error                                                                       CSD015
                                                                                              CSD015
     C                   IF        PRetCode <> *BLANKS                                        CSD015
     C                             AND PRetCode <> '*NRF   '                                  CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = POption                                            CSD015
     C                   EVAL      DBFILE = 'SDWLCCPD'                                        CSD015
     C                   EVAL      DBASE = 907                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   END                                                                  CSD015
                                                                                              CSD015
     C     KCwFld        KLIST                                                                CSD015
     C                   KFLD                    WFuncType                                    CSD015
     C                   KFLD                    WIdntifier                                   CSD015
     C                   KFLD                    WBranch                                      CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALLB     'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRetCode                                     CSD083
     C                   PARM      '*VERIFY'     POption                                      CSD083
     C                   PARM      'CSD083'      PSard                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
      ** Database error                                                                       CSD083
                                                                                              CSD083
     C                   IF        (PRetCode <> *BLANKS) AND                                  CSD083
     C                             (PRetCode <> '*NRF   ')                                    CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBKEY = 'CSD083'                                           CSD083
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBASE = 910                                                CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        PRetCode = *BLANKS                                         CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
      ** Check if CSC054 is on                                                              AR996631
      *                                                                                     AR996631
     C                   CALLB     'AOSARDR0'                                               AR996631
     C                   PARM      *BLANKS       @RTCD                                      AR996631
     C                   PARM      '*VERIFY'     @OPTN                                      AR996631
     C                   PARM      'CSC054'      PSARD                                      AR996631
     C     SCSARD        PARM      SCSARD        DSFDY                                      AR996631
      *                                                                                     AR996631
      ** An NRF (No Record Found) return code is valid.                                     AR996631
      ** Issue database error only for error return codes.                                  AR996631
      *                                                                                     AR996631
     C                   IF        @RTCD <> *BLANKS                                         AR996631
     C                             AND @RTCD <> '*NRF   '                                   AR996631
     C                   EVAL      DBFile = 'SCSARDPD'                                      AR996631
     C                   EVAL      DBKey = 'CSC054'                                         AR996631
     C                   EVAL      DBASE = 3                                                AR996631
     C                   EXSR      *PSSR                                                    AR996631
     C                   ENDIF                                                              AR996631
      *                                                                                     AR996631
     C                   EVAL      CSC054 = 'N'                                             AR996631
     C                   EVAL      WPEAInd = 'N'                                            AR996631
     C                   IF        @RTCD = *BLANKS                                          AR996631
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
(c) Misys International Banking Systems Ltd. 2001
