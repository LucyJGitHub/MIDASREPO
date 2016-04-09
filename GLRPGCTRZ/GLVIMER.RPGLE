     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate JE Item Error Overrides')            *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVIMER    - Validate Journal Batch Entry Item Error         *
      *               Overrides                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD024980           Date 26Mar14               *
      *  Prev Amend No. MD000091           Date 08May13               *
      *                 MD020266           Date 07May13               *
      *                 AR802562           Date 27Aug11               *
      *                 AR913756           Date 16Feb12               *
      *                 CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 254823             Date 11Jun08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 238884             Date 21Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 TCA102             Date 02Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP032  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD024980 - Incomplete error description for Blocked and      *
      *             Refer DR and CR, Inactive, Bad debt, Bankrupt     *
      *  MD000091 - Event Codes Substitution                          *
      *  MD020266 - Field Block All Postings checked, upon complete   *
      *             only credits were blocked and debit block is blank*
      *             on Nostro Account Maintenance. Batch entry was    *
      *             completed.                                        *
      *             with blocked credit entry. User Override for      *
      *  AR802562 - Error in the validation of User Override for      *
      *             Non - GL Accounts. Applied User Override to GL    *
      *             Accounts only. (Child: AR802563)                  *
      *  AR913756 - Null error encountered when account used          *
      *             was tagged as inactive. WMsgArray amended         *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  254823 - JE Unexpected Error during batch inout:             *
      *           GLX0999: Inactive;                                  *
      *  238884 - Authorisation of Overrides                          *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  TCA102 - Various errors on Journal Entry input (Recompile).  *
      *  CAP032 - Conversion of Journal Batch Entry inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
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
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Error message array
     D WMsgArr         S             45    DIM(4) CTDATA PERRCD(1)
      *
      ** Valid JE Item (DS) - for file update
     D PVBITP        E DS                  EXTNAME(GLVBITPPD)
      *
      ** Account details (DS)
     D F1ACCT        E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(F1)
      *
      ** Retail Override data area DS
     D GLREOV          DS
     D  WRRE01                 1      1
     D  WRRE02                 2      2
     D  WRRE03                 3      3
     D  WRRE04                 4      4
     D  WRRE05                 5      5
     D  WRRE06                 6      6
     D  WRRE07                 7      7
     D  WRRE08                 8      8
     D  WRRE09                 9      9
     D  WRRE10                10     10
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D Idx             S              3P 0
      *
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
      *                                                                                     MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
     C                   Z-ADD     *ZERO         Idx
      *
     C                   MOVE      'O'           WRERST            1
     C                   MOVE      *BLANKS       WError            8
      *
     C                   MOVE      'N'           WRINE             1
     C                   MOVE      *BLANKS       POverride
     C                   IN        GLREOV                                                   AR802562
      *
      ** Validate Error Overrides.
      *
     C                   EXSR      SRProc
      *
     C     DDRinoOK      IFEQ      'N'
     C     DDRineOK      OREQ      'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
     C     WRINE         IFEQ      'N'
     C                   EVAL      DDRINO = *BLANKS
     C                   ENDIF
      *
     C                   EVAL      B2RINO = DDRINO
     C                   EVAL      B2RINE = WRINE
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Process Error Overrides                             *
      *                                                               *
      *****************************************************************
      *
     C     SRProc        BEGSR
      *
      ** Check Retail Account status if Account is acceptable.
      *
     C     B2ACTY        IFEQ      'R'
     C     B2ACTY        OREQ      'N'                                                      MD020266
      *
     C     PAccount      IFEQ      *BLANKS
     C                   EXSR      SRAcSt
     C                   EXSR      SRAcOt
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If Block GL Accounts feature is switched on and account
      ** type is GL, check overrideable GL errors.
      *
     C     CGL002        IFEQ      'Y'
     C     B2ACTY        ANDEQ     'G'
     C                   EXSR      SRAcSt
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAcSt - Check Account Error Status                          *
      *                                                               *
      *****************************************************************
      *
     C     SRAcSt        BEGSR
      *
      ** Check Refer Debits.
      *
     C     B2DCIN        IFEQ      'D'
     C                   TESTB     '0'           F1RETB            1      01
     C     *IN01         IFEQ      *ON
     C                   MOVE      'Refer Dr'    WError
     C     WRRE01        IFNE      'Y'
     C     WUAUTH        ANDNE     'Y'                                                        238884
     C     B2ACTY        ANDEQ     'G'                                                      AR802562
     C     WRRE01        ORNE      'Y'                                                      AR802562
     C     B2ACTY        ANDNE     'G'                                                      AR802562
     C                   EVAL      WRERST = 'E'
     C                   ENDIF
     C                   EXSR      SROvrd
     C                   ENDIF
     C                   ENDIF
      *
      ** Check Refer Credits.
      *
     C     B2DCIN        IFEQ      'C'
     C                   TESTB     '1'           F1RETB                   01
     C     *IN01         IFEQ      *ON
     C                   MOVE      'Refer Cr'    WError
     C     WRRE02        IFNE      'Y'
     C     WUAUTH        ANDNE     'Y'                                                        238884
     C     B2ACTY        ANDEQ     'G'                                                      AR802562
     C     WRRE02        ORNE      'Y'                                                      AR802562
     C     B2ACTY        ANDNE     'G'                                                      AR802562
     C                   EVAL      WRERST = 'E'
     C                   ENDIF
     C                   EXSR      SROvrd
     C                   ENDIF
     C                   ENDIF
      *
      ** Check Block Debits.
      *
     C     B2DCIN        IFEQ      'D'
     C                   TESTB     '2'           F1RETB                   01
     C     *IN01         IFEQ      *ON
     C                   MOVE      'Block Dr'    WError
     C     WRRE03        IFNE      'Y'
     C     WUAUTH        ANDNE     'Y'                                                        238884
     C     B2ACTY        ANDEQ     'G'                                                      AR802562
     C     WRRE03        ORNE      'Y'                                                      AR802562
     C     B2ACTY        ANDNE     'G'                                                      AR802562
     C                   EVAL      WRERST = 'E'
     C                   ENDIF
     C                   EXSR      SROvrd
     C                   ENDIF
     C                   ENDIF
      *
      ** Check Block Credits.
      *
     C     B2DCIN        IFEQ      'C'
     C                   TESTB     '3'           F1RETB                   01
     C     *IN01         IFEQ      *ON
     C                   MOVE      'Block Cr'    WError
     C     WRRE04        IFNE      'Y'
     C     WUAUTH        ANDNE     'Y'                                                        238884
     C     B2ACTY        ANDEQ     'G'                                                      AR802562
     C     WRRE04        ORNE      'Y'                                                      AR802562
     C     B2ACTY        ANDNE     'G'                                                      AR802562
     C                   EVAL      WRERST = 'E'
     C                   ENDIF
     C                   EXSR      SROvrd
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAcOt - Check Account's Other Error Status                  *
      *                                                               *
      *****************************************************************
      *
     C     SRAcOt        BEGSR
      *
      ** Check Inactive A/c.
      *
     C                   TESTB     '4'           F1RETB                   01
     C     *IN01         IFEQ      *ON
     C                   MOVE      'Inactive'    WError
     C     WRRE05        IFNE      'Y'
     C                   EVAL      WRERST = 'E'
     C                   ENDIF
     C                   EXSR      SROvrd
     C                   ENDIF
      *
      ** Check if Bankrupt.
      *
     C                   TESTB     '6'           F1RETB                   01
     C     *IN01         IFEQ      *ON
     C                   MOVE      'Bankrupt'    WError
     C     WRRE07        IFNE      'Y'
     C                   EVAL      WRERST = 'E'
     C                   ENDIF
     C                   EXSR      SROvrd
     C                   ENDIF
      *
      ** Check Bad Debt.
      *
     C                   TESTB     '7'           F1RETB                   01
     C     *IN01         IFEQ      *ON
     C                   MOVE      'Bad Debt'    WError
     C     WRRE08        IFNE      'Y'
     C                   EVAL      WRERST = 'E'
     C                   ENDIF
     C                   EXSR      SROvrd
     C                   ENDIF
      *
      ** Check Stopped Cheque.
      *
     C     PSTOP         IFEQ      '*STOP  '
     C                   MOVE      'Chq.Stop'    WError
     C     WRRE09        IFNE      'Y'
     C                   EVAL      WRERST = 'E'
     C                   ENDIF
     C                   EXSR      SROvrd
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROvrd - Issue appropriate Override error message            *
      *                                                               *
      *****************************************************************
      *
     C     SROvrd        BEGSR
      *
     C                   SELECT
      *
      ** Error is non-overrideable.  Set Retail Override Indicator
      ** to 'N'.  Set Non-overrideable flag to 'Y'.
      *
     C     WRERST        WHENEQ    'E'
     C                   MOVE      'N'           DDRineOK
     C                   ADD       1             Idx
     C**********         MOVEL     'DDRINE'      FldNamXAr(Idx)                             MD024980
     C                   MOVEL     'DDACID'      FldNamXAr(Idx)                             MD024980
     C                   MOVEL     'GLX0999'     MsgIdXAr(Idx)
     C     B2ACTY        IFEQ      'R'
     C**********         MOVEL     WMsgArr(1)    MsgDtaXAr(Idx)                             MD000091
     C**********         EVAL      BLen = %Len(%Trim(WMsgArr(1)))                  MD000091 MD024980
     C**********         EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(WMsgArr(1))      MD000091 MD024980
     C                   MOVEL     WMsgArr(1)    MsgDtaTmp                                  MD024980
     C                   ELSE
     C**********         MOVEL     WMsgArr(2)    MsgDtaXAr(Idx)                             MD000091
     C**********         EVAL      BLen = %Len(%Trim(WMsgArr(2)))                  MD000091 MD024980
     C**********         EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(WMsgArr(2))      MD000091 MD024980
     C                   MOVEL     WMsgArr(2)    MsgDtaTmp                                  MD024980
     C                   ENDIF
     C**********         MOVEL     WError        MsgDtaXAr(Idx)                             MD000091
     C**********         EVAL      BLen = %Len(%Trim(WError))                      MD000091 MD024980
     C**********         EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(WError)          MD000091 MD024980
     C                   MOVEL     WError        MsgDtaTmp                                  MD024980
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD024980
     C                   EVAL      MsgDtaXAr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD024980
      *
     C                   MOVE      'N'           DDRINO
     C                   MOVE      'Y'           POverride
      *
      ** Error is overrideable.
      *
     C     WRERST        WHENEQ    'O'
     C     DDRINO        IFEQ      'N'
     C     DDRINO        OREQ      *BLANK
     C                   MOVE      'N'           DDRineOK
     C                   ADD       1             Idx
     C**********         MOVEL     'DDRINE'      FldNamXAr(Idx)                               254823
     C                   MOVEL     'DDRINO'      FldNamXAr(Idx)                               254823
     C                   MOVEL     'GLX0999'     MsgIdXAr(Idx)
     C**********         MOVEL     WMsgArr(3)    MsgDtaXAr(Idx)                             MD000091
     C**********         MOVEL     WError        MsgDtaXAr(Idx)                             MD000091
     C                   MOVEL     WMsgArr(3)    MsgDtaTmp                                  MD000091
     C                   MOVEL     WError        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   ENDIF
     C     DDRINO        IFNE      'Y'
     C     DDRINO        ANDNE     'N'
     C     DDRINO        ANDNE     *BLANK
     C                   MOVE      'N'           DDRinoOK
     C                   MOVE      'N'           DDRineOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRINO'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0999'     MsgIdXAr(Idx)
     C**********         MOVEL     WMsgArr(4)    MsgDtaXAr(Idx)                             MD000091
     C**********         MOVEL     WError        MsgDtaXAr(Idx)                             MD000091
     C                   MOVEL     WMsgArr(4)    MsgDtaTmp                                  MD000091
     C                   MOVEL     WError        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   ENDIF
      *
     C                   ENDSL
      *
      ** Reset Overrideable Error status.
      *
     C                   MOVE      'O'           WRERST
      *
      ** Set Retail Indicator in Error to 'Y'.
      *
     C                   MOVE      'Y'           WRINE
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Retail Override Indicator
     C                   PARM                    DDRINO            1
      *
      ** Return code for Stopped Cheque validation
     C                   PARM                    PSTOP             7
      *
      ** Account flag
     C                   PARM                    PAccount          5
      *
      ** Account details (DS)
     C                   PARM                    F1ACCT
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Block GL Accounts feature
     C                   PARM                    CGL002            1
      *                                                                                       238884
      ** Authorised to override                                                               238884
     C                   PARM                    WUAUTH            1                          238884
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Retail/GL Overrides - OK indicator
     C                   PARM                    DDRinoOK          1
      *
      ** Retail Error Indicator - OK indicator
     C                   PARM                    DDRineOK          1
      *
      ** Non-overrideable flag
     C                   PARM                    POverride         1
      *
      ** Valid JE Item (DS) - for file update
     C                   PARM                    PVBITP
      *
      ** Access Overrides data area.
      *
     C     *DTAARA       DEFINE                  GLREOV
     C                   IN        GLREOV
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
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
      ** Amended WMsgArr to use '-' instead of ':'                                          AR913756
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** WMsgArr
XXXXXXXX- RE error override not allowed.                                                    MD024980
XXXXXXXX- GL error override not allowed.
XXXXXXXX- Please override.
XXXXXXXX- Override invalid. Must be Y or N.
