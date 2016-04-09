     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate CCT header')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTM1021VL  - Validate MT102 Header Screen                    *
      *                                                               *
      *  Function: This program validates screens of the CCT header   *
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
      *                 CFT006  *CREATE    Date 17Nov99               *
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
     D FT1025DDF       C                   CONST(01)
     D FT1026DDF       C                   CONST(02)
 
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
     D HdrScnIn      E DS                  EXTNAME(FT102HSPD)
     D DtlScnIn      E DS                  EXTNAME(FT102DSPD) PREFIX(D)
 
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
     D OkFlag1       E DS                  EXTNAME(FTE102H1PD) PREFIX(OC)
     D OkFlag2       E DS                  EXTNAME(FTE102H2PD)
 
      ** Index of error message Id arrays
     D IdxErr1         S              3P 0
     D IdxErr2         S                   LIKE(IdxErr1)
 
      ** Index of warning message Id arrays
     D IdxWrn1         S                   Like(IdxErr1)
     D IdxWrn2         S                   LIKE(IdxErr1)
 
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
 
     C                   Eval      WrnToDsp = 'N'
     C                   MOVE      *ALL'Y'       OkFlag1
     C                   MOVE      *ALL'Y'       OkFlag2
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
     C                   If        Reinit = 'Y'
     C                   MOVEL     'N'           Reinit
     C                   Clear                   FldMsgA1
     C                   Clear                   FldMsgA2
     C                   Endif
 
      ** If we validate the last screen and no messages need
      ** then we reinitialize the working arrays
     C                   If        CurScreen <> MemScreen
     C                   Select
     C                   When      ScreenCur = FT1025DDF
     C                   Clear                   FldMsgA1
     C                   When      ScreenCur = FT1026DDF
     C                   Clear                   FldMsgA2
     C                   Endsl
     C                   Endif
 
      ** Call Validation Modules in Sequence
      ** Depending on current screen displayed determine which VAL module to
      ** call
 
     C                   If        ScreenCur >=  1
     C                   Exsr      SrVal1
     C                   Endif
 
     C                   If        ScreenCur >=  2
     C                   Exsr      SrVal2
     C                   Endif
 
     C                   Movel     CurScreen     MemScreen
 
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrVal1 - Calls Validation module 1 for header                 *
      *****************************************************************
     C     SrVal1        Begsr
 
     C                   CallB     'FTM1028VL'                          90
     C                   Parm      *Blanks       RetCodeIn
     C                   Parm                    RespMode
     C                   Parm                    ActionCode
     C                   Parm                    HdrScnIn
     C                   Parm                    DtlScnIn
     C                   Parm                    OkFlag1
     C                   Parm      *Blanks       FldNmArr1
     C                   Parm      *Blanks       MsgIdArr1
     C                   Parm      *Blanks       MsgDtArr1
     C                   Parm                    IdxErr1
     C                   Parm      *Blanks       WFldNmArr1
     C                   Parm      *Blanks       WMsgIdArr1
     C                   Parm      *Blanks       WMsgDtArr1
     C                   Parm                    IdxWrn1
 
     C                   If        RetCodeIn <> *Blanks or *IN90
     C                   Eval      DBFile = 'FTM1026VL'
     C                   Eval      DBase = 1
     C                   Eval      DBKey = '*CALL'
     C                   Exsr      *PSSR
     C                   Endif
 
      ** We will memorize the warnings that have been displayed only
      ** if there are no errors because we don't want them to be hidden
      ** by the error messages.
      ** Conversely we stop to memorize them if there are any errors
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
     C                   MOVEL     *ALL'Y'       OkFlag1
     C                   MOVEL     *BLANK        WFldNmArr1
     C                   MOVEL     *BLANK        WMsgIdArr1
     C                   MOVEL     *BLANK        WMsgDtArr1
     C                   ELSE
     C                   EVAL      WrnToDsp  = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrVal2 - Calls Validation module 2 for header                 *
      *****************************************************************
     C     SrVal2        Begsr
 
     C                   CallB     'FTM1027VL'                          90
     C                   Parm      *Blanks       RetCodeIn
     C                   Parm                    RespMode
     C                   Parm                    ActionCode
     C                   Parm                    HdrScnIn
     C                   Parm                    OkFlag2
     C                   Parm      *Blanks       FldNmArr2
     C                   Parm      *Blanks       MsgIdArr2
     C                   Parm      *Blanks       MsgDtArr2
     C                   Parm                    IdxErr2
     C                   Parm      *Blanks       WFldNmArr2
     C                   Parm      *Blanks       WMsgIdArr2
     C                   Parm      *Blanks       WMsgDtArr2
     C                   Parm                    IdxWrn2
 
     C                   If        RetCodeIn <> *Blanks OR *IN90
     C                   Eval      DBFile = 'FTM1027VL'
     C                   Eval      DBase = 2
     C                   Eval      DBKey = '*CALL'
     C                   Exsr      *PSSR
     C                   Endif
 
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
     C                   MOVEL     *ALL'Y'       OkFlag2
     C                   MOVEL     *BLANK        WFldNmArr2
     C                   MOVEL     *BLANK        WMsgIdArr2
     C                   MOVEL     *BLANK        WMsgDtArr2
     C                   ELSE
     C                   EVAL      WrnToDsp  = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        Begsr
 
     C     *Entry        PLIST
 
      ** INPUT PARAMETERS
     C                   Parm                    RetCodeIn
      ** Response mode (1A), from source system common header (A or S)
     C                   Parm                    RespMode
      ** Current screen
     C                   Parm                    CurScreen
      ** Action Code
     C                   Parm                    ActionCode
      ** Reinitialize screen
     C                   Parm                    Reinit
      ** Header information (DS) from source system in screen format
     C                   Parm                    HdrScnIn
 
      ** OUTPUT PARAMETERS
      ** Warnings to display
     C                   Parm                    WrnToDsp
      ** OK Flags Data Structure - Screens
     C                   Parm                    OkFlag1
     C                   Parm                    OkFlag2
      ** Array index from/to caller
     C                   Parm                    IdxErr1
     C                   Parm                    IdxErr2
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNmArr1
     C                   Parm                    MsgIdArr1
     C                   Parm                    MsgDtArr1
     C                   Parm                    FldNmArr2
     C                   Parm                    MsgIdArr2
     C                   Parm                    MsgDtArr2
      ** Array index from/to caller
     C                   Parm                    IdxWrn1
     C                   Parm                    IdxWrn2
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    WFldNmArr1
     C                   Parm                    WMsgIdArr1
     C                   Parm                    WMsgDtArr1
     C                   Parm                    WFldNmArr2
     C                   Parm                    WMsgIdArr2
     C                   Parm                    WMsgDtArr2
 
     C                   Clear                   FldMsgA1
     C                   Clear                   FldMsgA2
 
     C                   Endsr
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
