     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate CCT Detail')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTM1022VL  - Validate MT102 Detail Screen                    *
      *                                                               *
      *  Function: This program validates screens of the CCT detail   *
      *            transaction maintenance function.                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10602           Date 16Feb06               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 18Dec99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - SWIFT 2007 Changes (Recompiled)                     *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  CSW201 - SWIFT 2001 Standards Update (Recompiled)            *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  CFT006 - Funds Transfer/Swift Messages MT101/MT102           *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
     D/COPY ZACPYSRC,ERR_XARRYS
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
 
      ** Screen Name
     D FTM1022DDF      C                   CONST(01)
     D FTM1023DDF      C                   CONST(02)
 
     D LASTSCREEN      C                   CONST(02)
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D FldNmArr1       S                   LIKE(FldNameArr) DIM(ArrayMax)
     D MsgIdArr1       S                   LIKE(MsgIdArr)   DIM(ArrayMax)
     D MsgDtArr1       S                   LIKE(MsgDtaArr)  DIM(ArrayMax)
     D FldNmArr2       S                   LIKE(FldNameArr) DIM(ArrayMax)
     D MsgIdArr2       S                   LIKE(MsgIdArr)   DIM(ArrayMax)
     D MsgDtArr2       S                   LIKE(MsgDtaArr)  DIM(ArrayMax)
     D WFldNmArr1      S                   LIKE(WFldNamArr) DIM(ArrayMax)
     D WMsgIdArr1      S                   LIKE(WMsgIdArr)  DIM(ArrayMax)
     D WMsgDtArr1      S                   LIKE(WMsgDtaArr) DIM(ArrayMax)
     D WFldNmArr2      S                   LIKE(WFldNamArr) DIM(ArrayMax)
     D WMsgIdArr2      S                   LIKE(WMsgIdArr)  DIM(ArrayMax)
     D WMsgDtArr2      S                   LIKE(WMsgDtaArr) DIM(ArrayMax)
 
      ** Current screen
     D CurScreen       DS
     D ScreenCur                      2  0
 
      ** Screen memorized
     D MemScreen       DS
     D ScreenMem                           LIKE(ScreenCur)
 
      ** Current Incoming Debit Details
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD) PREFIX(H)
 
      ** Current Incoming Debit Details
     D DtlRcdIn      E DS                  EXTNAME(FT102DSPD)
 
      ** Array to memorize warnings send on screen 1
     D FldMsgA1        DS                  OCCURS(ArrayMax)
     D   Fld1                              LIKE(FldNameArr)
     D   Msg1                              LIKE(MsgIdArr)
 
      ** Array to memorize warnings send on screen 2
     D FldMsgA2        DS                  OCCURS(ArrayMax)
     D   Fld2                              LIKE(FldNameArr)
     D   Msg2                              LIKE(MsgIdArr)
      *
      ** Argument to look up in the working warning array
     D ArgMgFl         DS
     D   MgFlFld                           LIKE(FldNameArr)
     D   MgFlMsg                           LIKE(MsgIdArr)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * Response mode (1A), from source system common header (A or S)
     D RespMode        S              1
 
      * Reinitialize the program
     D Reinit          S              1
 
      * Index found in a array
     D Found           S                   LIKE(Reinit)
 
      * Warnings to display
     D WrnToDsp        S              1
 
      ** Ok CCt Header Details
     D OkFlagHs1     E DS                  EXTNAME(FTE102H1PD)
     D OkFlagHs2     E DS                  EXTNAME(FTE102H2PD)
 
      ** Ok CCt Details
     D OkFlagDs1     E DS                  EXTNAME(FTE102S1PD)
     D OkFlagDs2     E DS                  EXTNAME(FTE102S2PD)
 
      ** Index of error message Id arrays
     D IdxErr1         S              3P 0
     D IdxErr2         S                   LIKE(IdxErr1)
 
      ** Index of warning message Id arrays
     D IdxWrn1         S              3P 0
     D IdxWrn2         S                   LIKE(IdxWrn1)
     D i               S                   LIKE(IdxWrn1)
     D j               S                   LIKE(IdxWrn1)
     D WrnMem          S                   LIKE(IdxWrn1)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *
     C                   EVAL      WrnToDsp = 'N'
     C                   MOVE      *ALL'Y'       OKFlagDs1
     C                   MOVE      *ALL'Y'       OkFlagDs2
     C                   Z-ADD     0             IdxErr1
     C                   Z-ADD     0             IdxErr2
     C                   Z-ADD     0             IdxWrn1
     C                   Z-ADD     0             IdxWrn2
     C                   CLEAR                   WFldNmArr1
     C                   CLEAR                   WMsgIdArr1
     C                   CLEAR                   WMsgDtArr1
     C                   CLEAR                   WFldNmArr2
     C                   CLEAR                   WMsgIdArr2
     C                   CLEAR                   WMsgDtArr2
     C                   CLEAR                   FldNmArr1
     C                   CLEAR                   MsgIdArr1
     C                   CLEAR                   MsgDtArr1
     C                   CLEAR                   FldNmArr2
     C                   CLEAR                   MsgIdArr2
     C                   CLEAR                   MsgDtArr2
 
      ** If we need to reinitialize the screen
     C                   IF        Reinit = 'Y'
     C                   MOVEL     'N'           Reinit
     C                   CLEAR                   FldMsgA1
     C                   CLEAR                   FldMsgA2
     C                   ENDIF
 
      ** If we validate the last screen and no messages need
      ** then we reinitialize the working arrays
     C                   IF        CurScreen <> MemScreen
     C                   SELECT
     C                   WHEN      ScreenCur = FTM1022DDF
     C                   CLEAR                   FldMsgA1
     C                   WHEN      ScreenCur = FTM1023DDF
     C                   CLEAR                   FldMsgA2
     C                   ENDSL
     C                   ENDIF
 
      ** Call Validation Modules in Sequence
      ** Depending on current screen displayed determine which VAL module to
      ** call
 
     C                   IF        ScreenCur >=  1
     C                   EXSR      SrVal1
     C                   ENDIF
 
     C                   IF        ScreenCur >=  2
     C                   EXSR      SrVal2
     C                   ENDIF
 
     C                   MOVEL     CurScreen     MemScreen
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrVal1 - Calls Validation module 1 for detail                 *
      *****************************************************************
      *
     C     SrVal1        BEGSR
 
     C                   CALLB     'FTM1023VL'                          90
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM                    RespMode
     C                   PARM                    ActionCode
     C                   PARM                    HdrRcdIn
     C                   PARM                    DtlRcdIn
     C                   PARM                    OkFlagDS1
     C                   PARM                    OkFlagDS2
     C                   PARM                    OkFlagHS1
     C                   PARM                    OkFlagHS2
     C                   PARM      *Blanks       FldNmArr1
     C                   PARM      *Blanks       MsgIdArr1
     C                   PARM      *Blanks       MsgDtArr1
     C                   PARM                    IdxErr1
     C                   PARM      *Blanks       WFldNmArr1
     C                   PARM      *Blanks       WMsgIdArr1
     C                   PARM      *Blanks       WMsgDtArr1
     C                   PARM                    IdxWrn1
 
     C                   IF        RetCodeIn <> *Blanks or *IN90
     C                   EVAL      DBFile = 'FTM1023VL'
     C                   EVAL      DBase = 1
     C                   EVAL      DBKey = '*CALL'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** We will memorize the warnings that have been displayed only
      ** if there are no errors because we don't want them to be hidden
      ** by the error messages.
      ** Conversely we stop to memorize them if there are any errors
      *
     C                   IF        IdxErr1 <> 0
     C                   CLEAR                   FldMsgA1
 
     C                   ELSE
     C                   Z-ADD     0             WrnMem
     C                   Z-ADD     1             i
     C                   DOW       i <= %ELEM(WFldNmArr1)
     C                   IF        WFldNmArr1(i) = *BLANK
     C                   LEAVE
     C                   ENDIF
 
     C                   Z-ADD     1             j
 
     C                   EVAL      Found   = 'N'
     C                   EVAL      MgFlFld = WFldNmArr1(i)
     C                   EVAL      MgFlMsg = WMsgIdArr1(i)
 
     C                   DOW       j <= %ELEM(FldMsgA1)
 
     C     j             OCCUR     FldMsgA1
     C     FldMsgA1      IFEQ      *BLANK
     C                   LEAVE
     C                   ENDIF
     C     FldMsgA1      IFEQ      ArgMgFl
     C                   EVAL      Found   = 'Y'
     C                   LEAVE
     C                   ENDIF
 
     C                   ADD       1             j
     C                   ENDDO
 
     C                   IF        Found   = 'Y'
     C                   ADD       1             WrnMem
     C                   ELSE
     C                   IF        j <= %ELEM(FldMsgA1)
     C     j             OCCUR     FldMsgA1
     C                   EVAL      FldMsgA1 = ArgMgFl
     C                   ENDIF
     C                   ENDIF
 
     C                   ADD       1             i
     C                   ENDDO
 
      ** If all the warnings have been already displayed
      ** We reset all the warning arrays
     C                   IF        WrnMem  = IdxWrn1
     C                   EVAL      WrnToDsp  = 'N'
     C                   MOVEL     *ALL'Y'       OKFlagDs1
     C                   MOVEL     *BLANK        WFldNmArr1
     C                   MOVEL     *BLANK        WMsgIdArr1
     C                   MOVEL     *BLANK        WMsgDtArr1
     C                   ELSE
     C                   EVAL      WrnToDsp  = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrVal2 - Calls Validation module 2 for header                 *
      *****************************************************************
      *
     C     SrVal2        BEGSR
 
     C                   CALLB     'FTM1024VL'                          90
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM                    RespMode
     C                   PARM                    ActionCode
     C                   PARM                    HdrRcdIn
     C                   PARM                    DtlRcdIn
     C                   PARM                    OkFlagDS1
     C                   PARM                    OkFlagDS2
     C                   PARM                    OkFlagHS1
     C                   PARM                    OkFlagHS2
     C                   PARM      *Blanks       FldNmArr2
     C                   PARM      *Blanks       MsgIdArr2
     C                   PARM      *Blanks       MsgDtArr2
     C                   PARM                    IdxErr2
     C                   PARM      *Blanks       WFldNmArr2
     C                   PARM      *Blanks       WMsgIdArr2
     C                   PARM      *Blanks       WMsgDtArr2
     C                   PARM                    IdxWrn2
 
     C                   IF        RetCodeIn <> *Blanks OR *IN90
     C                   EVAL      DBFile = 'FTM1024VL'
     C                   EVAL      DBase = 2
     C                   EVAL      DBKey = '*CALL'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** We will memorize the warnings that have been displayed only
      ** if there are no errors because we don't want them to be hidden
      ** by the error messages.
      ** Conversely we stop to memorize them if there are any errors
     C                   IF        IdxErr2 <> 0
     C                   CLEAR                   FldMsgA2
 
     C                   ELSE
     C                   Z-ADD     0             WrnMem
     C                   Z-ADD     1             i
     C                   DOW       i <= %ELEM(WFldNmArr2)
     C                   IF        WFldNmArr2(i) = *BLANK
     C                   LEAVE
     C                   ENDIF
 
     C                   Z-ADD     1             j
 
     C                   EVAL      Found   = 'N'
     C                   EVAL      MgFlFld = WFldNmArr2(i)
     C                   EVAL      MgFlMsg = WMsgIdArr2(i)
 
     C                   DOW       j <= %ELEM(FldMsgA2)
 
     C     j             OCCUR     FldMsgA2
     C     FldMsgA2      IFEQ      *BLANK
     C                   LEAVE
     C                   ENDIF
     C     FldMsgA2      IFEQ      ArgMgFl
     C                   EVAL      Found   = 'Y'
     C                   LEAVE
     C                   ENDIF
 
     C                   ADD       1             j
     C                   ENDDO
 
     C                   IF        Found   = 'Y'
     C                   ADD       1             WrnMem
     C                   ELSE
     C                   IF        j <= %ELEM(FldMsgA2)
     C     j             OCCUR     FldMsgA2
     C                   EVAL      FldMsgA2 = ArgMgFl
     C                   ENDIF
     C                   ENDIF
 
     C                   ADD       1             i
     C                   ENDDO
 
      ** If all the warnings have been already displayed
      ** We reset all the warning arrays
     C                   IF        WrnMem  = IdxWrn2
     C                   EVAL      WrnToDsp  = 'N'
     C                   MOVEL     *ALL'Y'       OKFlagDs2
     C                   MOVEL     *BLANK        WFldNmArr2
     C                   MOVEL     *BLANK        WMsgIdArr2
     C                   MOVEL     *BLANK        WMsgDtArr2
     C                   ELSE
     C                   EVAL      WrnToDsp  = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      ** INPUT PARAMETERS
     C                   PARM                    RetCodeIn
      ** Response mode (1A), from source system common header (A or S)
     C                   PARM                    RespMode
      ** Current screen
     C                   PARM                    CurScreen
      ** Action Code
     C                   PARM                    ActionCode
      ** Reinitialize screen
     C                   PARM                    Reinit
      ** Header information (DS) from source system in screen format
     C                   PARM                    HdrRcdIn
     C                   PARM                    DtlRcdIn
 
      ** OUTPUT PARAMETERS
      ** Warnings to display
     C                   PARM                    WrnToDsp
      ** OK Flags Data Structure - Screens
     C                   PARM                    OkFlagDs1
     C                   PARM                    OkFlagDs2
     C                   PARM                    OkFlagHs1
     C                   PARM                    OkFlagHs2
      ** Array index from/to caller
     C                   PARM                    IdxErr1
     C                   PARM                    IdxErr2
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNmArr1
     C                   PARM                    MsgIdArr1
     C                   PARM                    MsgDtArr1
     C                   PARM                    FldNmArr2
     C                   PARM                    MsgIdArr2
     C                   PARM                    MsgDtArr2
      ** Array index from/to caller
     C                   PARM                    IdxWrn1
     C                   PARM                    IdxWrn2
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmArr1
     C                   PARM                    WMsgIdArr1
     C                   PARM                    WMsgDtArr1
     C                   PARM                    WFldNmArr2
     C                   PARM                    WMsgIdArr2
     C                   PARM                    WMsgDtArr2
 
     C                   Clear                   FldMsgA1
     C                   Clear                   FldMsgA2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
