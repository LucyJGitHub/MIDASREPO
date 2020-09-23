     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Rollover Instr retr + act/loan validation')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LELERIRTV - Rollover Instructions retrieve                   *
      *              (with action code versus loan reference          *
      *               validation)                                     *
      *                                                               *
      *  Function:  This module retrieves a customer loan from        *
      *             the database. As it does so, it validates the     *
      *             action code and loan reference                    *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 CLE071             Date 18Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE141             Date 08Feb16               *
      *                 MD000091           Date 09May13               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 242751             Date 05Oct06               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244314             30Mar07Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 240968             Date 10Jul06               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9737            Date 29Dec05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG3760            Date 22Jul04               *
      *                 BUG3813            Date 26Jul04               *
      *                 BUG19  (CAP084)    Date 09Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 11Oct02               *
      *                 CLE030             Date 29Aug02               *
      *                 CAP076  *CREATE    Date 10Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  MD000091 - Event Codes Substitution                          *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  242751 - Include CLE056 processing                           *
      *           Authorisation on Lending Transactions               *
      *  244314 - If system value CLAuthSameORED = 'Y', then allow    *
      *           original input user to re-authorise a transaction   *
      *           that was previously authorised and has been amended *
      *           by a second user.                                   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  240968 - If system value CLAuthORED = 'Y', when authorising  *
      *           do not check insert user is different to authorise  *
      *           user if rollover status is 'R'                      *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9737- Must included in CLE106 delivery due to changes made*
      *           CLE036 in loans file.(Recompile)                    *
      *  CAP086 - Introduce Auto Authorisation to the API's w/o it    *
      *  BUG3760 - Compliance Watch (CSD015) changes missing from the *
      *            Lending APIs                                       *
      *  BUG3813- Missing Rule of 78s (CLE028) change in the Lending  *
      *           APIs as description in the amendment history.       *
      *  BUG19  - Midas Plus API development (CAP084)                 *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Midas Plus API development                          *
      *  CLE030 - Release Authorisation processing                    *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FLECLIPL0  IF   E           K DISK    INFSR(*PSSR)
      ***  Loans by front office id
     F                                     RENAME(CLOANCLF:LOANFOIDL)
     F                                     RENAME(CLOANCKF:LOANFOIDK)
      *
     FLECLIPL2  IF   E           K DISK    INFSR(*PSSR)
      ***  Midas LE Loans File
      *
     FSDCWHTL1  IF   E           K DISK    INFSR(*PSSR)                                      BUG3760
      ** Compliance Watch Hit List                                                           BUG3760
      *
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
      ******True*******logical*=**on*(for*indcator*processing)*********                       CAP084
      ******False******logical*=**off*(for*indcator*processing)********                       CAP084
      **    True       logical = *on (for indicator processing)                               CAP084
      **    False      logical = *off (for indicator processing)                              CAP084
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
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
     D CLAuthORED      C                   Const('CLAuthORED')                                240968
     D CLAuthSMDT      C                   Const('CLAuthSameORED')                            244314
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ***  External DS for General Ledger details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ***  External DS for branch details
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ***  Midas modules details
      *
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      ***  Customer lending ICD
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
                                                                                             BUG3760
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                    BUG3760
      ** 24X7 status data area                                                               BUG3760
                                                                                             BUG3760
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                    BUG3760
      ** SD data area                                                                        BUG3760
                                                                                             BUG3760
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                 BUG3760
     D  #LCD         E                     EXTFLD(LCD)                                       BUG3760
      ** External DS for SAR details                                                         BUG3760
                                                                                             BUG3760
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                 BUG3760
      ** External DS for Compliance Watch Transaction Details                                BUG3760
                                                                                             BUG3760
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                 BUG3760
      ** External DS for Compliance Watch List Configuration Data                            BUG3760
                                                                                             BUG3760
     D ZMUSER          DS            17
     D  BRC                   11     13
     D  DEPT                  14     16
      *
     D LnCLFilFmt    E DS                  EXTNAME(CLOANCL)
      ***  Loan in File Format CL
      *
     D LnCKFilFmt    E DS                  EXTNAME(CLOANCK)
      ***  Loan in File Format CK
     D  KRECI        E                     EXTFLD(RECI)
     D  KLNRF        E                     EXTFLD(LNRF)
     D  KRCDT        E                     EXTFLD(RCDT)
     D  KMRIN        E                     EXTFLD(MRIN)
     D  KORED        E                     EXTFLD(ORED)
     D  KLCD         E                     EXTFLD(LCD)
     D  KCHTP        E                     EXTFLD(CHTP)
     D  KTNLU        E                     EXTFLD(TNLU)
     D  KFRNT        E                     EXTFLD(FRNT)
     D  KAFRT        E                     EXTFLD(AFRT)
     D  KREPA        E                     EXTFLD(REPA)
     D  KTMST        E                     EXTFLD(TMST)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
                                                                                             BUG3760
     D CSC011          S              1                                                      BUG3760
     D CCF001          S              1                                                      BUG3760
     D CSD015          S              1                                                      BUG3760
     D WFuncType       S              8                                                      BUG3760
     D WIdntifier      S             40                                                      BUG3760
     D WBranch         S              3                                                      BUG3760
     D PRetCode        S              7                                                      BUG3760
     D POption         S              7                                                      BUG3760
     D PSARD           S              6                                                      BUG3760
     D PFUNC           S              8                                                      BUG3760
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
     D CAP086          S              1A                                                      CAP086
      *                                                                                       240968
     D PSysVal01       S             20A                                                      240968
     D PCurSet01       S            200A                                                      240968
     D PSysVal02       S             20A                                                      240968
     D PCurSet02       S            200A                                                      240968
     D PSysVal03       S             20A                                                      240968
     D PCurSet03       S            200A                                                      240968
     D PSysVal04       S             20A                                                      240968
     D PCurSet04       S            200A                                                      240968
     D PSysVal05       S             20A                                                      240968
     D PCurSet05       S            200A                                                      240968
     D PSysVal06       S             20A                                                      240968
     D PCurSet06       S            200A                                                      240968
     D PSysVal07       S             20A                                                      240968
     D PCurSet07       S            200A                                                      240968
     D PSysVal08       S             20A                                                      240968
     D PCurSet08       S            200A                                                      240968
     D PSysVal09       S             20A                                                      240968
     D PCurSet09       S            200A                                                      240968
     D PSysVal10       S             20A                                                      240968
     D PCurSet10       S            200A                                                      240968
     D CLE056          S              1A                                                      242751
 
     D wLoanAlpha      S              1A                                                      CLE148
     D PLNRF           S              6A                                                      CLE148
     D PValid          S              6A                                                      CLE148
     D PChkDigit       S              1A                                                      CLE148
     D PData           S              2A                                                      CLE148
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                            MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      * Rename input fields (must be included in DS LnCKFilFmt)
     ICLOANCKF
     I              RECI                        KRECI
     I              LNRF                        KLNRF
     I              RCDT                        KRCDT
     I              MRIN                        KMRIN
     I              ORED                        KORED
     I              LCD                         KLCD
     I              CHTP                        KCHTP
     I              TNLU                        KTNLU
     I              FRNT                        KFRNT
     I              AFRT                        KAFRT
     I              REPA                        KREPA
     I              TMST                        KTMST
 
      *****************************************************************
      /EJECT
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Check whether user is a web browser user, if so overwrite              CAP084
     C                   CALL      'SFC000026'                                  CAP084
     C                   PARM      *BLANKS       USER             10            CAP084
      *                                                                         CAP084
     C                   IF        USER <> *BLANKS                              CAP084
     C                   EVAL      PSUSER = USER                                CAP084
     C                   ENDIF                                                  CAP084
                                                                                              CAP086
      ** If the mode is 'Front Office Transaction Interface'                                  CAP086
      ** Do authorisations are required                                                       CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'  AND                                          CAP086
     C                             ModeofOp = *BLANKS                                         CAP086
     C                   EVAL      AUTH = *BLANKS                                             CAP086
     C                   ENDIF                                                                CAP086
      *
      ***  Initialization
      *
     C                   EXSR      INIT
      *
      ***  If the mode is 'FRONT OFFICE TRANSACTION INTERFACE'
      ***  do (EXTRA) validation for front office transaction interface
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C                   EXSR      VFRNT
      *
      ***  Carry out no further validation if errors have occurred.
      *
     C     OKACTN        IFEQ      'N'
     C     OKLNRF        OREQ      'N'
     C                   RETURN
     C                   END
     C                   END
      *
      ***  Validate action code & loan number
      *
     C                   EXSR      VAL
      *
      ***  Carry out no further validation if errors have occurred
      *
     C     OKACTN        IFEQ      'N'
     C     OKLNRF        OREQ      'N'
     C                   RETURN
     C                   END
      *
      *  *------------------------------------------------------*
      *  * Validation for Action Code 'E'                       *
      *  *------------------------------------------------------*
      *
     C     DDACTN        IFEQ      'E'
     C                   EXSR      VALACE
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'X' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'X'
     C                   EXSR      VALACX
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'A' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'A'
     C                   EXSR      VALACA
     C                   END
      *                                                                                       CLE030
      *  *--------------------------------*                                                   CLE030
      *  * Validation for Action Code 'Q' *                                                   CLE030
      *  *--------------------------------*                                                   CLE030
      *                                                                                       CLE030
     C     DDACTN        IFEQ      'Q'                                                        CLE030
     C                   EXSR      VALACQ                                                     CLE030
     C                   END                                                                  CLE030
      *
      ***  Carry out no further validation if errors occurred
      *    ==================================================
      *
     C     OKACTN        IFEQ      'N'
     C     OKLNRF        OREQ      'N'
     C                   RETURN
     C                   END
      *
      *  *-----------------------------------------------*
      *  * Access Security Checking                      *
      *  *-----------------------------------------------*
      *
     C     RespMode      IFEQ      'S'
     C                   EXSR      ACSSEC
     C                   END
      *
      ***  Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - Validation for front office transaction interface
      *****************************************************************
     C     VFRNT         BEGSR
      *
      ***  Error if action code is not  'A' or 'X'
      ***  OR 'Q'                                                                             CLE030
      *
     C     DDACTN        IFNE      'A'
     C     DDACTN        ANDNE     'X'
     C     DDACTN        ANDNE     'Q'                                                        CLE030
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEV9005'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
      *
      ***  Error if front office transaction ID is blank
      *
     C     FOTRID        IFEQ      *BLANK
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEV9006'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
      *
      ***  Access loan with front office transaction ID
      *
     C     FOTRID        CHAIN     LOANFOIDL                          99
      *
      ***  If not insert, front office transaction ID must be present
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEV9007'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT
     C                   END
      *
      ***  If not insert, update Midas loan number
      *
     C                   MOVEL     LNRF          DDLNRF
      *
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - Validation of action code and loan number
      *****************************************************************
     C     VAL           BEGSR
      *
     C     DDACTN        IFNE      *BLANK
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     'X'
     C     DDACTN        ANDNE     'Q'                                                        CLE030
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C**********         MOVEL     'LEV0021'     MsgIdArr(Ix)                                 CAP084
     C                   MOVEL     'LEV1007'     MsgIdArr(Ix)                                 CAP084
     C                   GOTO      EVAL
     C                   END
      *
      ***  If the loan number is not blank, check that it is numeric.
      *
     C     DDLNRF        IFNE      *BLANKS
     C                   TESTN                   DDLNRF               98
     C                   MOVE      DDLNRF        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C*****DDLNRF        IFNE      *BLANKS                                                    CLE148
     C******IN98         ANDEQ     '0'                                                        CLE148
     C*****DDLNRF        ORNE      *BLANKS                                                    CLE148
     C******IN99         ANDEQ     '0'                                                        CLE148
     C**********         MOVE      'N'           OKLNRF                                       CLE148
     C**********         ADD       1             Ix                                           CLE148
     C**********         MOVEL     'DDLNRF'      FldNameArr(Ix)                               CLE148
     C**********         MOVEL     'LEV0038'     MsgIdArr(Ix)                                 CLE148
     C**********         GOTO      EVAL                                                       CLE148
     C**********         END                                                                  CLE148
      *                                                                                       CLE148
     C                   IF        wLoanAlpha = 'Y'                                           CLE148
      *                                                                                       CLE148
      ** Call program 'LELOANISO' to validate the number.                                     CLE148
      *                                                                                       CLE148
     C                   EVAL      PLNRF = DDLNRF                                             CLE148
     C                   EVAL      PValid = *BLANKS                                           CLE148
     C                   EVAL      PChkDigit = *BLANK                                         CLE148
     C                   EVAL      PData = *BLANKS                                            CLE148
      *                                                                                       CLE148
     C                   CALL(E)   'LELOANISO'   P_LELOANISO                                  CLE148
      *                                                                                       CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   IF        (WLoanAlpha = 'N'                                          CLE148
     C                              AND (*IN98 = *OFF OR *IN99 = *OFF)                        CLE148
     C                              OR (WLoanAlpha='Y' AND PVALID<>*BLANKS))                  CLE148
     C                   MOVE      'N'           OKLNRF                                       CLE148
     C                   ADD       1             Ix                                           CLE148
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)                               CLE148
     C                   IF        WLoanAlpha = 'N'                                           CLE148
     C                   MOVEL     '5045551'     MsgIdArr(Ix)                                 CLE148
     C                   ELSE                                                                 CLE148
     C                   MOVEL     '5045549'     MsgIdarr(Ix)                                 CLE148
     C**********         MOVEL     PData         MsgDtaArr(Ix)                       CLE148 MD000091
     C                   EVAL      BLen = %Len(%Trim(PData))                                MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(PData)                     MD000091
     C                   ENDIF                                                                CLE148
     C                   GOTO      EVAL                                                       CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   END
      *
      ***  Set up the loan number as a numeric field
      *
     C                   MOVE      DDLNRF        K@LNRF
      *
      ***  Access loan with the loan reference if it's not insert
      ***  (CLOANCL)
      *
     C     DDACTN        IFNE      'I'
     C     K@LNRF        CHAIN(N)  CLOANCLF                           99
      *
      ***  The loan must be present
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLRNF'      FldNameArr(Ix)
     C                   MOVEL     'LEV1001'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   END
     C                   END
      *
      ***  Access loan with the loan reference if it's not insert
      ***  (CLOANCK)
      *
     C     DDACTN        IFNE      'I'
     C     K@LNRF        CHAIN(N)  CLOANCKF                           99
      *
      ***  The loan must be present
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLRNF'      FldNameArr(Ix)
     C                   MOVEL     'LEV1001'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   END
     C                   END
      *
     C                   SELECT
      *
      ***  Loan has already matured, it cannot be processed.
      *
     C     RECI          WHENEQ    'M'
      *
     C     RATF          IFNE      'Y'
     C     CLE005        ORNE      'Y'
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLRNF'      FldNameArr(Ix)
     C                   MOVEL     'LEV1002'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
      ***  Loan was already deleted, it cannot be processed.
      *
     C     RECI          WHENEQ    'R'
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLRNF'      FldNameArr(Ix)
     C                   MOVEL     'LEV1003'     MsgIdArr(Ix)
     C                   GOTO      EVAL
      *
     C     RECI          WHENNE    'D'
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLRNF'      FldNameArr(Ix)
     C                   MOVEL     'LEV0161'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDSL
      *
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACE - Validation of action code 'E'
      *****************************************************************
     C     VALACE        BEGSR
      *
      ***  If the loan number is blank, it is an error
      *
     C     DDLNRF        IFEQ      *BLANKS
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LEV0161'     MsgIdArr(Ix)
     C                   GOTO      EVALAE
     C                   END
      *
     C     EVALAE        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACX - Validation of action code 'X'
      *****************************************************************
     C     VALACX        BEGSR
      *
      ***  If authorization feature (CLE002) is not installed authorization action
      ***  is not allowed
      *
     C     CLE002        IFEQ      'N'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEV1008'     MsgIdArr(Ix)
     C                   GOTO      EVALAX
     C                   END
      *
      ***  If authorization feature is installed,
      ***  Check if Authorisation of Rollover is needed
      *
     C     BPROAU        IFNE      'Y'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEV1009'     MsgIdArr(Ix)
     C                   GOTO      EVALAX
     C                   END
                                                                                             BUG3760
      ** If the loan transaction exists in the hit list, setup error message                 BUG3760
                                                                                             BUG3760
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                             BUG3760
                                                                                             BUG3760
     C                   IF        (CSC011 = 'N' OR CSC011 = 'Y'                             BUG3760
     C                             AND LIBR = S1MAIN)                                        BUG3760
                                                                                             BUG3760
     C                   EVAL      WFuncType = 'CLOANCK'                                     BUG3760
     C                   EVAL      WIdntifier = DDLNRF                                       BUG3760
     C                   EVAL      WBranch = BRCA                                            BUG3760
                                                                                             BUG3760
     C     KCwFld        CHAIN     SDCWHTL1                                                  BUG3760
                                                                                             BUG3760
     C                   IF        %FOUND(SDCWHTL1) AND W3TREL <> 'Y'                        BUG3760
     C                   MOVE      'N'           OKACTN                                      BUG3760
     C                   EVAL      Ix = Ix + 1                                               BUG3760
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                              BUG3760
     C                   EVAL      MsgIdArr(Ix) = 'LEL0564'                                  BUG3760
     C                   GOTO      EVALAX                                                    BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
      *
      ***  If the loan number is blank, it is an error
      *
     C     DDLNRF        IFEQ      *BLANKS
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LEV0161'     MsgIdArr(Ix)
     C                   GOTO      EVALAX
     C                   END
      *
      ***  Authorised user must be different from the insert and
      ***  amend users
      ***  Unless CLE056 is enabled and not day of input and not last amender                 242751
      *
      * If system value CLAuthORED = 'Y' and status is 'R' then allow                         240968
      * allow authorise user to be same as insert user                                        240968
      * Or if system value CLAuthSameORED = 'Y' and status is 'R' then allow                  244314
      * allow authorise user to be same as insert user                                        244314
     C     ATHRATH       IFEQ      'Y'                                                        240968
     C     ATHSMDT       OREQ      'Y'                                                        244314
      *                                                                                       240968
     C     PSUser        IFEQ      RAUS                                                       240968
     C     PSUser        OREQ      RIUS                                                       240968
     C     RSTS          ANDNE     'R'                                                        240968
     C                   MOVE      'N'           OKACTN                                       240968
     C                   ADD       1             Ix                                           240968
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               240968
     C                   MOVEL     'LEV1010'     MsgIdArr(Ix)                                 240968
     C                   GOTO      EVALAX                                                     240968
     C                   END                                                                  240968
      *                                                                                       240968
     C                   ELSE                                                                 240968
      *                                                                                       240968
     C     PSUser        IFEQ      RIUS
     C     PSUser        OREQ      RAUS
      *                                                                                       242751
     C                   If        (CLE056 = 'N') or                                          242751
     C                             (CLE056 = 'Y' and ORED = BJRDNB                            242751
     C                                           and PSUser = RIUS) or                        242751
     C                             (CLE056 = 'Y' and LCD = BJRDNB and                         242751
     C                              CHTP = 'A'   and PSUser = RAUS)                           242751
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEV1010'     MsgIdArr(Ix)
     C                   GOTO      EVALAX
     C                   ENDIF                                                                242751
     C                   END
     C                   ENDIF                                                                240968
      *
      **  Status of rollover must be complete or requiring re-authori-
      **  sation
      *
     C     RSTS          IFNE      'C'
     C     RSTS          ANDNE     'R'
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LEV1011'     MsgIdArr(Ix)
     C                   GOTO      EVALAX
     C                   END
      *
     C     EVALAX        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACA - Validation of action code 'A'
      *****************************************************************
     C     VALACA        BEGSR
      *
      ***  If the loan number is blank, it is an error
      *
     C     DDLNRF        IFEQ      *BLANKS
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LEV0161'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   END
      *
      **  Early matured Discounted loan cannot be rollovered.
      *
     C     PTYP          IFEQ      63
     C     ORMD          ANDGT     *ZERO
     C     PTYP          OREQ      65
     C     ORMD          ANDGT     *ZERO
     C     PTYP          OREQ      67
     C     ORMD          ANDGT     *ZERO
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LEV0469'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   END
      *                                                                                      BUG3813
      **  Flat rate personal loans cannot be rollovered.                                     BUG3813
      *                                                                                      BUG3813
     C     CLE028        IFEQ      'Y'                                                       BUG3813
     C     PTYP          ANDEQ     80                                                        BUG3813
     C                   MOVE      'N'           OKLNRF                                      BUG3813
     C                   ADD       1             Ix                                          BUG3813
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)                              BUG3813
     C                   MOVEL     'LEV1064'     MsgIdArr(Ix)                                BUG3813
     C                   GOTO      EVALAA                                                    BUG3813
     C                   ENDIF                                                               BUG3813
      *                                                                                       CLE030
      ***  If the rollover status is 'Requires release' then action                           CLE030
      ***  code 'A' amend is not allowed.                                                     CLE030
      *                                                                                       CLE030
     C     RSTS          IFEQ      'Q'                                                        CLE030
     C                   MOVE      'N'           OKLNRF                                       CLE030
     C                   ADD       1             Ix                                           CLE030
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)                               CLE030
     C                   MOVEL     'LEV0162'     MsgIdArr(Ix)                                 CLE030
     C                   GOTO      EVALAA                                                     CLE030
     C                   END                                                                  CLE030
      *
     C     EVALAA        ENDSR
      *****************************************************************                       CLE030
      /EJECT                                                                                  CLE030
      *****************************************************************                       CLE030
      * VALACQ - Validation of action code 'Q'                                                CLE030
      *****************************************************************                       CLE030
     C     VALACQ        BEGSR                                                                CLE030
      *                                                                                       CLE030
      ***  If the Authorisation switchable feature CLE002 is not on                           CLE030
      ***  then this is an error.                                                             CLE030
      *                                                                                       CLE030
     C     CLE002        IFNE      'Y'                                                        CLE030
     C                   MOVE      'N'           OKLNRF                                       CLE030
     C                   ADD       1             Ix                                           CLE030
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)                               CLE030
     C                   MOVEL     'LEV0163'     MsgIdArr(Ix)                                 CLE030
     C                   GOTO      EVALAQ                                                     CLE030
     C                   ENDIF                                                                CLE030
      *                                                                                       CLE030
      ***  If the rollovers to be authorised field from the ICD                               CLE030
      ***  file is not 'Y' then this is an error.                                             CLE030
      *                                                                                       CLE030
     C     BPROAU        IFNE      'Y'                                                        CLE030
     C                   MOVE      'N'           OKLNRF                                       CLE030
     C                   ADD       1             Ix                                           CLE030
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)                               CLE030
     C                   MOVEL     'LEV0164'     MsgIdArr(Ix)                                 CLE030
     C                   GOTO      EVALAQ                                                     CLE030
     C                   ENDIF                                                                CLE030
      *                                                                                       CLE030
      ***  If the Release Authorisation switchable feature CLE030                             CLE030
      ***  is not on then this is an error.                                                   CLE030
      *                                                                                       CLE030
     C     CLE030        IFNE      'Y'                                                        CLE030
     C                   MOVE      'N'           OKLNRF                                       CLE030
     C                   ADD       1             Ix                                           CLE030
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)                               CLE030
     C                   MOVEL     'LEV0165'     MsgIdArr(Ix)                                 CLE030
     C                   GOTO      EVALAQ                                                     CLE030
     C                   ENDIF                                                                CLE030
      *                                                                                       CLE030
      ***  If the rollover status is not 'Requires release' then this                         CLE030
      ***  is an error.                                                                       CLE030
      *                                                                                       CLE030
     C     RSTS          IFNE      'Q'                                                        CLE030
     C                   MOVE      'N'           OKLNRF                                       CLE030
     C                   ADD       1             Ix                                           CLE030
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)                               CLE030
     C                   MOVEL     'LEV0166'     MsgIdArr(Ix)                                 CLE030
     C                   GOTO      EVALAQ                                                     CLE030
     C                   ENDIF                                                                CLE030
      *                                                                                       CLE030
      ***  If user field PSUser is the same as the Authorised user                            CLE030
      ***  field RXUS from CLOANCK then this is an error.                                     CLE030
      ***                                                                                     CLE030
      *                                                                                       CLE030
     C     PSUser        IFEQ      RXUS                                                       CLE030
     C                   MOVE      'N'           OKLNRF                                       CLE030
     C                   ADD       1             Ix                                           CLE030
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)                               CLE030
     C                   MOVEL     'LEV0167'     MsgIdArr(Ix)                                 CLE030
     C                   GOTO      EVALAQ                                                     CLE030
     C                   ENDIF                                                                CLE030
      *                                                                                       CLE030
     C     EVALAQ        ENDSR                                                                CLE030
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSSEC - Access security checking
      *****************************************************************
     C     ACSSEC        BEGSR
      *
      ***  For single branch system, check if user is authorised to the
      ***  action
      *
     C                   Z-ADD     0             @ERR              1 0
      *
     C     BGMBIN        IFEQ      'N'
      *
     C                   CALL      'ZVACTU'
     C                   PARM      DDACTN        @ZACTN            1
     C                   PARM                    @ERR
      *
     C     @ERR          IFNE      0
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEV0302'     MsgIdArr(Ix)
     C                   END
     C                   END
      *
      ***  For multibranching system, and action codes not I, branch code
      ***  on loans file must be valid for user
      *
     C     BGMBIN        IFEQ      'Y'
     C     DDACTN        ANDNE     'I'
     C                   MOVE      DDACTN        @ZACTN
     C                   MOVE      BRCA          @ZBR              3
      *
     C                   CALL      'ZVACTBU'
     C                   PARM                    @ZACTN
     C                   PARM                    @ZBR
     C                   PARM                    @ERR
      *
     C     @ERR          IFEQ      1
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEV0303'     MsgIdArr(Ix)
     C                   END
     C     @ERR          IFEQ      2
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEV0304'     MsgIdArr(Ix)
     C                   END
     C                   END
      *
      ***  For multibranching system, and action codes A/R, originating
      ***  branch on loans file must be valid for user
      *
     C     BGMBIN        IFEQ      'Y'
     C     BKOBUV        ANDEQ     'Y'
     C     BKOBRU        ANDEQ     'Y'
      *
     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'X'
      *
     C                   CALL      'ZVOBU'
     C                   PARM      ORBR          @ZOBRX            3
     C                   PARM                    @ERR
      *
     C     @ERR          IFEQ      1
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEV0305'     MsgIdArr(Ix)
     C                   END
     C     @ERR          IFEQ      2
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEV0306'     MsgIdArr(Ix)
     C                   END
     C                   END
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initialization
      *****************************************************************
     C     INIT          BEGSR
      *
      ***  Clear outputs
      *
     C                   CLEAR                   LnCLFilFmt
     C                   CLEAR                   LnCKFilFmt
     C                   MOVEL     'Y'           OKACTN
     C                   MOVEL     'Y'           OKLNRF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ***  Parameters
      *
     C     *ENTRY        PLIST
      *
      ***  INPUTS
      *    ======
      * Return code
     C                   PARM                    RetCodeIn
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      * Response mode
     C                   PARM                    RespMode          1
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      * (Midas) loan Number
     C                   PARM                    DDLNRF            6
      * Features
     C                   PARM                    CLE002            1
     C                   PARM                    CLE003            1
     C                   PARM                    CLE005            1
      *
      ***  OUTPUTS
      *    =======
      * (Current) loan in file format CL
     C                   PARM                    LnCLFilFmt
      * (Current) loan in file format CK
     C                   PARM                    LnCKFilFmt
      * OK - Action code
     C                   PARM                    OKACTN            1
      * OK - loan Number
     C                   PARM                    OKLNRF            1
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LELERIRTV'   DBPGM
      *
      ***  Key List
      *
     C     K@LOAN        KLIST
     C**********         KFLD                    K@LNRF            6 0                        CLE148
     C                   KFLD                    K@LNRF            6                          CLE148
      *
      ***  Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Access General Ledger details
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         *************
     C                   MOVEL     '002'         DBASE                          * DBERR 002 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Retrieve Lending ICD
      *
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDCLND        PARM      SDCLND        DSFDY                                        CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCLNDPD'    DBFILE                         *************
     C                   MOVEL     '003'         DBASE                          * DBERR 003 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ** Retrieve midas module details
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '004'         DBASE                          * DBERR 004 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
                                                                                              CLE148
     C                   EVAL      PSysVal03 = 'LoanAlphaAllow'                               CLE148
      *                                                                                       240968
      ** Check for system values                                                              240968
     C                   CALLB     'AOSVALR0'                                                 240968
     C                   PARM      *BLANKS       PRtCd             7                          240968
     C                   PARM      CLAuthORED    PSysVal01                                    240968
     C                   PARM      *BLANKS       PCurSet01                                    240968
     C**********         PARM      *BLANKS       PSysVal02                             240968 244314
     C                   PARM      CLAuthSMDT    PSysVal02                                    244314
     C                   PARM      *BLANKS       PCurSet02                                    240968
     C**********         PARM      *BLANKS       PSysVal03                             240968 CLE148
     C                   PARM                    PSysVal03                                    CLE148
     C                   PARM      *BLANKS       PCurSet03                                    240968
     C                   PARM      *BLANKS       PSysVal04                                    240968
     C                   PARM      *BLANKS       PCurSet04                                    240968
     C                   PARM      *BLANKS       PSysVal05                                    240968
     C                   PARM      *BLANKS       PCurSet05                                    240968
     C                   PARM      *BLANKS       PSysVal06                                    240968
     C                   PARM      *BLANKS       PCurSet06                                    240968
     C                   PARM      *BLANKS       PSysVal07                                    240968
     C                   PARM      *BLANKS       PCurSet07                                    240968
     C                   PARM      *BLANKS       PSysVal08                                    240968
     C                   PARM      *BLANKS       PCurSet08                                    240968
     C                   PARM      *BLANKS       PSysVal09                                    240968
     C                   PARM      *BLANKS       PCurSet09                                    240968
     C                   PARM      *BLANKS       PSysVal10                                    240968
     C                   PARM      *BLANKS       PCurSet10                                    240968
                                                                                              240968
     C                   If        PRtCd <> *Blanks                                           240968
     C                   Eval      DBFile = 'SDSVALPD'                                        240968
     C                   Eval      DBase = 013                                                240968
     C                   Eval      DBKey = '*KEY    '                                         240968
     C                   ExSR      *PSSR                                                      240968
     C                   EndIf                                                                240968
     C                   MOVEL     PCurSet01     ATHRATH           1                          240968
     C                   MOVEL     PCurSet02     ATHSMDT           1                          244314
     C                   MOVEL     PCurSet03     wLoanAlpha                                   CLE148
      *                                                                                       CLE030
      ***  Determine if Release authorisation enhancement feature                             CLE030
      ***  is installed                                                                       CLE030
      *                                                                                       CLE030
     C                   MOVE      'N'           CLE030            1                          CLE030
     C                   CALLB     'AOSARDR0'                                                 CLE030
     C                   PARM      *BLANKS       @RTCD                                        CLE030
     C                   PARM      '*VERIFY'     @OPTN                                        CLE030
     C                   PARM      'CLE030'      @SARD             6                          CLE030
      *                                                                                       CLE030
     C     @RTCD         IFEQ      *BLANKS                                                    CLE030
     C                   MOVE      'Y'           CLE030                                       CLE030
     C                   ELSE                                                                 CLE030
     C     @RTCD         IFEQ      '*NRF'                                                     CLE030
     C                   MOVE      'N'           CLE030                                       CLE030
     C                   ELSE                                                                 CLE030
      *                                                                                       CLE030
      * DATABASE ERROR                                                                        CLE030
      *                                                                                       CLE030
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE030
     C                   MOVEL     '005'         DBASE                          * DBERR 913 * CLE030
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE030
     C                   EXSR      *PSSR                                                      CLE030
     C                   ENDIF                                                                CLE030
     C                   ENDIF                                                                CLE030
      *                                                                                      BUG3813
      ** Determine if CLE028 for Flat Rate Personal Loans (Rule of 78s)                      BUG3813
      ** enhancement is installed.                                                           BUG3813
      *                                                                                      BUG3813
     C                   MOVE      'N'           CLE028            1                         BUG3813
     C                   CALLB     'AOSARDR0'                                                BUG3813
     C                   PARM      *BLANKS       @RTCD                                       BUG3813
     C                   PARM      '*VERIFY'     @OPTN                                       BUG3813
     C                   PARM      'CLE028'      @SARD             6                         BUG3813
      *                                                                                      BUG3813
     C     @RTCD         IFEQ      *BLANKS                                                   BUG3813
     C                   MOVE      'Y'           CLE028                                      BUG3813
     C                   ELSE                                                                BUG3813
     C     @RTCD         IFEQ      '*NRF'                                                    BUG3813
     C                   MOVE      'N'           CLE028                                      BUG3813
     C                   ELSE                                                                BUG3813
      *                                                                                      BUG3813
      ** DATABASE ERROR                                                                      BUG3813
      *                                                                                      BUG3813
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************BUG3813
     C                   MOVEL     '006'         DBASE                          * DBERR 006 *BUG3813
     C                   MOVEL     @OPTN         DBKEY                          *************BUG3813
     C                   EXSR      *PSSR                                                     BUG3813
     C                   ENDIF                                                               BUG3813
     C                   ENDIF                                                               BUG3813
      *
      *
      ***  Get ZMUSER to access default branch.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER
      *
     C     KCwFld        KLIST                                                               BUG3760
     C                   KFLD                    WFuncType                                   BUG3760
     C                   KFLD                    WIdntifier                                  BUG3760
     C                   KFLD                    WBranch                                     BUG3760
                                                                                             BUG3760
      ** Access the SDSTAT Data Area.                                                        BUG3760
                                                                                             BUG3760
     C                   IN        SDSTAT                                                    BUG3760
                                                                                             BUG3760
      ** Access SAR details to see if CSD015 is switched on.                                 BUG3760
                                                                                             BUG3760
     C                   EVAL      CSD015 = 'N'                                              BUG3760
     C                   CALL      'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*VERIFY'     POption                                     BUG3760
     C                   PARM      'CSD015'      PSARD                                       BUG3760
     C     SCSARD        PARM      *BLANKS       DSFDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        PRetCode = *BLANKS                                        BUG3760
                                                                                             BUG3760
     C                   EVAL      CSD015 = 'Y'                                              BUG3760
     C                   ELSE                                                                BUG3760
                                                                                             BUG3760
     C                   IF        PRetCode <> '*NRF'                                        BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = 'CSD015'                                          BUG3760
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG3760
     C                   EVAL      DBase = 7                                                 BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        CSD015 = 'Y'                                              BUG3760
                                                                                             BUG3760
      ** Check if transactions are being monitored by Compliance Watch.                      BUG3760
                                                                                             BUG3760
     C                   CALL      'AOWLCCR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*KEY   '     POption                                     BUG3760
     C                   PARM      'LENDING '    PFunc                                       BUG3760
     C     SDWLCC        PARM      SDWLCC        DSFDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        PRetCode <> *BLANKS AND                                   BUG3760
     C                             PRetCode <> '*NRF'                                        BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = 'LENDING'                                         BUG3760
     C                   EVAL      DBFile = 'SDWLCCPD'                                       BUG3760
     C                   EVAL      DBase = 8                                                 BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   CALL      'AOCWCDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*FIRST '     POption                                     BUG3760
     C     SDCWCD        PARM      SDCWCD        DSSDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        PRetCode <> *BLANKS                                       BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = POption                                           BUG3760
     C                   EVAL      DBFile = 'SDCWCDPD'                                       BUG3760
     C                   EVAL      DBase = 9                                                 BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Access SAR details to see if CSC011 is switched on.                                 BUG3760
                                                                                             BUG3760
     C                   EVAL      CSC011 = 'N'                                              BUG3760
     C                   CALL      'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*VERIFY'     POption                                     BUG3760
     C                   PARM      'CSC011'      PSARD                                       BUG3760
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        PRetCode = *BLANKS                                        BUG3760
                                                                                             BUG3760
     C                   EVAL      CSC011 = 'Y'                                              BUG3760
     C                   IN        SC24X7                                                    BUG3760
     C                   ELSE                                                                BUG3760
                                                                                             BUG3760
     C                   IF        PRetCode <> '*NRF'                                        BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = 'CSC011'                                          BUG3760
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG3760
     C                   EVAL      DBase = 10                                                BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Access SAR details to see if CCF001 is switched on.                                 BUG3760
                                                                                             BUG3760
     C                   EVAL      CCF001 = 'N'                                              BUG3760
     C                   CALL      'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*VERIFY'     POption                                     BUG3760
     C                   PARM      'CCF001'      PSARD                                       BUG3760
     C     SCSARD        PARM      *BLANKS       DSFDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        PRetCode = *BLANKS                                        BUG3760
                                                                                             BUG3760
     C                   EVAL      CCF001 = 'Y'                                              BUG3760
     C                   ELSE                                                                BUG3760
                                                                                             BUG3760
     C                   IF        PRetCode <> '*NRF'                                        BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = 'CCF001'                                          BUG3760
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG3760
     C                   EVAL      DBase = 11                                                BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                              CAP086
      ** Check if enhancement Automatic Authorisation(CAP086) is on                           CAP086
                                                                                              CAP086
     C                   EVAL      CAP086 = 'N'                                               CAP086
     C                   CALLB     'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       @RTCD                                        CAP086
     C                   PARM      '*VERIFY'     @OPTN                                        CAP086
     C                   PARM      'CAP086'      @SARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CAP086
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP086
     C                   EVAL      DBKey  = 'CAP086'                                          CAP086
     C                   EVAL      DBase  = 12                                                CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        @RTCD = *BLANKS                                            CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
                                                                                              242751
      ** Check if Authorisation on Lending Transactions (CLE056) is on                        242751
                                                                                              242751
     C                   EVAL      CLE056 = 'N'                                               242751
     C                   CALLB     'AOSARDR0'                                                 242751
     C                   PARM      *BLANKS       @RTCD                                        242751
     C                   PARM      '*VERIFY'     @OPTN                                        242751
     C                   PARM      'CLE056'      @SARD                                        242751
                                                                                              242751
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  242751
     C                   EVAL      DBFile = 'SCSARDPD'                                        242751
     C                   EVAL      DBKey  = 'CLE056'                                          242751
     C                   EVAL      DBase  = 13                                                242751
     C                   EXSR      *PSSR                                                      242751
     C                   ENDIF                                                                242751
                                                                                              242751
     C                   IF        @RTCD = *BLANKS                                            242751
     C                   EVAL      CLE056 = 'Y'                                               242751
     C                   ENDIF                                                                242751
                                                                                             BUG3760
     C     P_LELOANISO   PLIST                                                                CLE148
      *                                                                                       CLE148
      ** Loan Number (Input)                                                                  CLE148
      *                                                                                       CLE148
     C                   PARM                    PLNRF                                        CLE148
      *                                                                                       CLE148
      ** Validity Flags (Output)                                                              CLE148
      *                                                                                       CLE148
     C                   PARM                    PValid                                       CLE148
      *                                                                                       CLE148
      ** Check Digit (Output)                                                                 CLE148
      *                                                                                       CLE148
     C                   PARM                    PChkDigit                                    CLE148
     C                   PARM                    PData                                        CLE148
                                                                                              CLE148
      ** Check if Watch List Element (CSD083) is on                                           CSD083
      *                                                                                       CSD083
     C                   CALLB     'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRetCode                                     CSD083
     C                   PARM      '*VERIFY'     POption                                      CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        PRetCode <> *Blanks AND                                    CSD083
     C                             PRetCode <> '*NRF   '                                      CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBase = 14                                                 CSD083
     C                   EVAL      DBKey = 'CSD083'                                           CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
      *                                                                                       CSD083
     C                   IF        PRetCode = *BLANKS                                         CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
