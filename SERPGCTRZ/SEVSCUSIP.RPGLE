     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate cusip number')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVSCUSIP - Validate Cusip Number                            *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                SESECSCTL                                      *
      *                SESECSRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD061462           Date 04Dec23               *
      *  Prev Amend No. MD058285           Date 22Jun21               *
      *                 CSD103             Date 10Aug20               *
      *                 MD046248           Date 27Oct17               *
      *                 MD000091           Date 15May13               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 CGL014             Date 20Oct03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 14May01               *
      *                 CAP060             Date 14May01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061462 - Error on warning messages with ampersand (&).     *
      *           - Pattern the fix with SEVSISNCD, missing the LenStr*
      *           - Concatenate the value of Security Report Name.    *
      *             Maximum warning message is only 45 characters in  *
      *             length. This is a system limitation. Added close  *
      *             parenthesis ')' on position 45 of warning message.*
      *  MD058285 - Change base rate code to alphanumeric (Recompile) *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSD006 - Market Data Feeds (recompile)                       *
      *  CAP060 - Midas APIs, Security Prices Full API (recompile)    *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs.                           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Securities by CUSIP Number
     FSECTYL0   IF   E           K DISK    INFSR(*PSSR)
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
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
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
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     D NwSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
      *
      ** Securities for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
      *
      ** Securities screen 1 error indicators
     D SEESEC1       E DS                  EXTNAME(SEESEC1PD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of warning error message ids, etc.
     D WIx             S              3P 0
      *
      ** Work variables
     D WFound          S              1A
     D WCSPN           S              9A
     D WMsg44          S             44A                                                    MD061462
     D WPos1           S              2S 0                                                  MD061462
     D WPos2           S              2S 0                                                  MD061462
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
                                                                                            MD000091
      *
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
      ** Initialise work variables.
     C                   EVAL      WIx = 0
      *
      ** Validate cusip number
      *
     C                   EXSR      SRValCusip
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKCSPN <> 'Y'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF

     C                   IF        OKCSPN <> 'N'
     C                   MOVEL     DDCSPN        S1CSPN
     C                   ENDIF

     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALCUSIP - Validation for Cusip Number                     *
      *                                                               *
      *****************************************************************
     C     SRValCusip    BEGSR
      *
      ** Check if cusip number already exist in securities file
      *
     C                   IF        DDCSPN <> *BLANKS

     C                   MOVE      DDCSPN        WCSPN
     C                   EVAL      WFound = 'N'
     C     WCSPN         SETLL     SECTYL0
     C     WCSPN         READE     SECTYL0                                01

     C                   DOW       *IN01 = *OFF AND
     C                             WFound = 'N'
      *
      ** Check if security shortname is different
     C                   IF        DDSESN <> SESN
     C                   EVAL      WFound = 'Y'
     C                   ENDIF

     C     WCSPN         READE     SECTYL0                                01
     C                   ENDDO
      *
      ** Cusip already exist in security file, send warning message
     C                   IF        WFound = 'Y'
     C                   MOVE      'W'           OKCSPN
     C                   ADD       1             WIx
     C                   MOVEL     'DDCSPN'      WFldNmXAr(WIx)
     C                   MOVEL     'SEA0237'     WMsgIdXAr(WIx)
     C**********         EVAL      WMsgDtXAr(WIx) = CSPN + SESN +                           MD000091
     C**********                                    '(' + SRPN + ')'                        MD000091
     C                   EVAL      BLen = %Len(%Trim(CSPN))                                 MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(CSPN)                     MD000091
     C                   EVAL      BLen = %Len(%Trim(SESN))                                 MD000091
     C                   EVAL      WMsgDtXAr(WIx) = %TRIM(WMsgDtXAr(WIx))                   MD000091
     C**********                                  + %TRIM(SESN)                    MD000091 MD061462
     C                                            + LenStr +%TRIM(SESN)                     MD061462
     C                   EVAL      MsgDtaTmp = '(' + SRPN + ')'                             MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      WMsgDtXAr(WIx) = %TRIM(WMsgDtXAr(WIx))                   MD000091
     C**********                                  + %TRIM(MsgDtaTmp)               MD000091 MD061462
     C                                            + LenStr +%TRIM(MsgDtaTmp)                MD061462
     C                   EXSR      ChkParenthesis                                           MD061462
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *                                                                                     MD061462
      *****************************************************************                     MD061462
      /EJECT                                                                                MD061462
      *****************************************************************                     MD061462
      *                                                               *                     MD061462
      *  ChkParenthesi - Check open and close parenthesis             *                     MD061462
      *                                                               *                     MD061462
      *****************************************************************                     MD061462
     C     ChkParenthesisBEGSR                                                              MD061462
                                                                                            MD061462
      ** Check Open Parenthesis                                                             MD061462
     C                   Eval      WPos1    = %Scan('(':WMsgDtXAr(WIx))                     MD061462
      ** Check Close Parenthesis                                                            MD061462
     C                   Eval      WPos2    = %Scan(')':WMsgDtXAr(WIx))                     MD061462
      ** Force ')' on column/array 45                                                       MD061462
     C                   If        WPos1 > 0                                                MD061462
     C                             and WPos2 = 0                                            MD061462
     C                   MOVEA     WMsgDtXAr(WIx)WMsg44                                     MD061462
     C                   EVAL      WMsgDtXAr(WIx)=WMsg44 + ')'                              MD061462
     C                   ENDIF                                                              MD061462
                                                                                            MD061462
     C                   ENDSR                                                              MD061462
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
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDxAr
     C                   PARM                    WMsgDtXAr
      *
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
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
**  CPY@
(c) Finastra International Limited 2001
