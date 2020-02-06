     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate RFT credit')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTM1012VL  - Validate MT101 Credit detail screen             *
      *                                                               *
      *  Function: This Program Validates screens  of the RFT Credit  *
      *            transaction maintenance function (FTM1011DP).      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG10602           Date 16Feb06               *
      *                 221761             Date 01Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 01Dec99               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  CFT006 - Swift Messages MT101/MT102                          *
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
     D FTM1012DDF      C                   CONST(01)
     D FTM1013DDF      C                   CONST(02)
     D FTM1014DDF      C                   CONST(03)
 
     D LASTSCREEN      C                   CONST(03)
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D FldNmArr1       S                   LIKE(FldNameArr) DIM(ArrayMax)       PF0008
     D MsgIdArr1       S                   LIKE(MsgIdArr)   DIM(ArrayMax)       PF0008
     D MsgDtArr1       S                   LIKE(MsgDtaArr)  DIM(ArrayMax)       PF0008
     D FldNmArr2       S                   LIKE(FldNameArr) DIM(ArrayMax)       PF0008
     D MsgIdArr2       S                   LIKE(MsgIdArr)   DIM(ArrayMax)       PF0008
     D MsgDtArr2       S                   LIKE(MsgDtaArr)  DIM(ArrayMax)       PF0008
     D FldNmArr3       S                   LIKE(FldNameArr) DIM(ArrayMax)       PF0008
     D MsgIdArr3       S                   LIKE(MsgIdArr)   DIM(ArrayMax)       PF0008
     D MsgDtArr3       S                   LIKE(MsgDtaArr)  DIM(ArrayMax)       PF0008
     D WFldNmArr1      S                   LIKE(WFldNamArr) DIM(ArrayMax)       PF0008
     D WMsgIdArr1      S                   LIKE(WMsgIdArr)  DIM(ArrayMax)       PF0008
     D WMsgDtArr1      S                   LIKE(WMsgDtaArr) DIM(ArrayMax)       PF0008
     D WFldNmArr2      S                   LIKE(WFldNamArr) DIM(ArrayMax)       PF0008
     D WMsgIdArr2      S                   LIKE(WMsgIdArr)  DIM(ArrayMax)       PF0008
     D WMsgDtArr2      S                   LIKE(WMsgDtaArr) DIM(ArrayMax)       PF0008
     D WFldNmArr3      S                   LIKE(WFldNamArr) DIM(ArrayMax)       PF0008
     D WMsgIdArr3      S                   LIKE(WMsgIdArr)  DIM(ArrayMax)       PF0008
     D WMsgDtArr3      S                   LIKE(WMsgDtaArr) DIM(ArrayMax)       PF0008
 
      ** Current screen
     D CurScreen       DS
     D ScreenCur                      2  0
 
      ** Screen memorized
     D MemScreen       DS
     D ScreenMem                           LIKE(ScreenCur)
 
      *
      ** Current Incoming Debit Details
     D HdrScnIn      E DS                  EXTNAME(FT101HSPD) PREFIX(SH)
      *
      ** Current Incoming Debit Details
     D DtlScnIn      E DS                  EXTNAME(FT101DSPD)
      *
      ** Array to memorize warnings send on screen 1
     D FldMsgA1        DS                  OCCURS(ArrayMax)
     D   Fld1                              LIKE(FldNameArr)
     D   Msg1                              LIKE(MsgIdArr)
      *
      ** Array to memorize warnings send on screen 2
     D FldMsgA2        DS                  OCCURS(ArrayMax)
     D   Fld2                              LIKE(FldNameArr)
     D   Msg2                              LIKE(MsgIdArr)
      *
      ** Array to memorize warnings send on screen 3
     D FldMsgA3        DS                  OCCURS(ArrayMax)
     D   Fld3                              LIKE(FldNameArr)
     D   Msg3                              LIKE(MsgIdArr)
 
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
     D WrnToDsp        S                   LIKE(Reinit)
 
      ** Ok RFT Credit Details
     D OkCre1        E DS                  EXTNAME(FTE101S1PD) PREFIX(OC)
     D OkCre2        E DS                  EXTNAME(FTE101S2PD)
     D OkCre3        E DS                  EXTNAME(FTE101S3PD)
 
      ** Index of error message Id arrays
     D IdxErr1         S              3P 0
     D IdxErr2         S                   LIKE(IdxErr1)
     D IdxErr3         S                   LIKE(IdxErr2)
 
      ** Index of warning message Id arrays
     D IdxWrn1         S              3P 0
     D IdxWrn2         S                   LIKE(IdxWrn1)
     D IdxWrn3         S                   LIKE(IdxWrn1)
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
 
     C                   MOVEL     'N'           WrnToDsp
     C                   MOVE      *ALL'Y'       OkCre1
     C                   MOVE      *ALL'Y'       OkCre2
     C                   MOVE      *ALL'Y'       OkCre3
     C                   Z-ADD     0             IdxErr1
     C                   Z-ADD     0             IdxErr2
     C                   Z-ADD     0             IdxErr3
     C                   Z-ADD     0             IdxWrn1
     C                   Z-ADD     0             IdxWrn2
     C                   Z-ADD     0             IdxWrn3
     C                   CLEAR                   WFldNmArr1
     C                   CLEAR                   WMsgIdArr1
     C                   CLEAR                   WMsgDtArr1
     C                   CLEAR                   WFldNmArr2
     C                   CLEAR                   WMsgIdArr2
     C                   CLEAR                   WMsgDtArr2
     C                   CLEAR                   WFldNmArr3
     C                   CLEAR                   WMsgIdArr3
     C                   CLEAR                   WMsgDtArr3
     C                   CLEAR                   FldNmArr1
     C                   CLEAR                   MsgIdArr1
     C                   CLEAR                   MsgDtArr1
     C                   CLEAR                   FldNmArr2
     C                   CLEAR                   MsgIdArr2
     C                   CLEAR                   MsgDtArr2
     C                   CLEAR                   FldNmArr3
     C                   CLEAR                   MsgIdArr3
     C                   CLEAR                   MsgDtArr3
 
      ** If we need to reinitialize warnings already memorized
     C     Reinit        IFEQ      'Y'
     C                   MOVEL     'N'           Reinit
     C                   CLEAR                   FldMsgA1
     C                   CLEAR                   FldMsgA2
     C                   CLEAR                   FldMsgA3
     C                   ENDIF
 
      ** If we change of level of screen
      ** then we reinitialize the working arrays
     C     CurScreen     IFNE      MemScreen
     C                   MOVEL     CurScreen     MemScreen
 
     C                   SELECT
     C     ScreenCur     WHENEQ    FTM1012DDF
     C                   CLEAR                   FldMsgA1
     C     ScreenCur     WHENEQ    FTM1013DDF
     C                   CLEAR                   FldMsgA2
     C     ScreenCur     WHENEQ    FTM1014DDF
     C                   CLEAR                   FldMsgA3
     C                   ENDSL
 
     C                   ENDIF
 
      **************   Call Validation Modules in Sequence   **************
      *
      ** Depending on current screen displayed determine which VAL module to
      ** call
      *
     C                   IF        ScreenCur >=  FTM1012DDF
     C                   EXSR      VAL1
     C                   ENDIF
 
     C                   IF        ScreenCur >=  FTM1013DDF
     C                   EXSR      VAL2
     C                   ENDIF
 
     C                   IF        ScreenCur >=  FTM1014DDF
     C                   EXSR      VAL3
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * VAL1   - Calls Validation module 1 for credit details
      *****************************************************************
      *
     C     VAL1          BEGSR
 
     C                   CALLB     'FTM1013VL'                          90
     C                   PARM                    RetCodeIn
     C                   PARM                    RespMode
     C                   PARM                    ActionCode
     C                   PARM                    HdrScnIn
     C                   PARM                    DtlScnIn
     C                   PARM                    OkCre1
     C                   PARM                    FldNmArr1
     C                   PARM                    MsgIdArr1
     C                   PARM                    MsgDtArr1
     C                   PARM                    IdxErr1
     C                   PARM                    WFldNmArr1
     C                   PARM                    WMsgIdArr1
     C                   PARM                    WMsgDtArr1
     C                   PARM                    IdxWrn1
 
     C                   IF        RetCodeIn <> *BLANKS OR *IN90
     C                   EVAL      DBFILE = 'FTM1013VL'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = '*CALL'
     C                   EXSR      *PSSR
     C                   ENDIF
 
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
     C                   MOVEL     *ALL'Y'       OkCre1
     C                   MOVEL     *BLANK        WFldNmArr1                     PF0008
     C                   MOVEL     *BLANK        WMsgIdArr1                     PF0008
     C                   MOVEL     *BLANK        WMsgDtArr1                     PF0008
     C                   ELSE
     C                   EVAL      WrnToDsp  = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL2   - Calls Validation module 2 for credit screen validation
      *****************************************************************
      *
     C     VAL2          BEGSR
 
     C                   CALLB     'FTM1014VL'                          90
     C                   PARM                    RetCodeIn
     C                   PARM                    RespMode
     C                   PARM                    ActionCode
     C                   PARM                    HdrScnIn
     C                   PARM                    DtlScnIn
     C                   PARM                    OkCre2
     C                   PARM                    FldNmArr2
     C                   PARM                    MsgIdArr2
     C                   PARM                    MsgDtArr2
     C                   PARM                    IdxErr2
     C                   PARM                    WFldNmArr2
     C                   PARM                    WMsgIdArr2
     C                   PARM                    WMsgDtArr2
     C                   PARM                    IdxWrn2
 
     C                   IF        RetCodeIn <> *BLANKS OR *IN90
     C                   EVAL      DBFILE = 'FTM1014VL'
     C                   EVAL      DBASE = 002                                  PF0004
     C                   EVAL      DBKEY = '*CALL'
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
     C                   MOVEL     *ALL'Y'       OkCre2
     C                   MOVEL     *BLANK        WFldNmArr2                     PF0008
     C                   MOVEL     *BLANK        WMsgIdArr2                     PF0008
     C                   MOVEL     *BLANK        WMsgDtArr2                     PF0008
     C                   ELSE
     C                   EVAL      WrnToDsp  = 'Y'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL3   - Calls Validation module 3 for credit screen validation
      *****************************************************************
 
     C     VAL3          BEGSR
 
     C                   CALLB     'FTM1015VL'                          90
     C                   PARM                    RetCodeIn
     C                   PARM                    RespMode
     C                   PARM                    ActionCode
     C                   PARM                    HdrScnIn
     C                   PARM                    DtlScnIn
     C                   PARM                    OkCre3
     C                   PARM                    FldNmArr3
     C                   PARM                    MsgIdArr3
     C                   PARM                    MsgDtArr3
     C                   PARM                    IdxErr3
     C                   PARM                    WFldNmArr3
     C                   PARM                    WMsgIdArr3
     C                   PARM                    WMsgDtArr3
     C                   PARM                    IdxWrn3
 
     C                   IF        RetCodeIn <> *BLANKS OR *IN90
     C                   EVAL      DBFILE = 'FTM1015VL'
     C                   EVAL      DBASE = 003                                  PF0004
     C                   EVAL      DBKEY = '*CALL'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** We will memorize the warnings that have been displayed only
      ** if there are no errors because we don't want them to be hidden
      ** by the error messages.
      ** Conversely we stop to memorize them if there are any errors
     C                   IF        IdxErr3 <> 0
     C                   CLEAR                   FldMsgA3
 
     C                   ELSE
     C                   Z-ADD     0             WrnMem
     C                   Z-ADD     1             i
     C                   DOW       i <= %ELEM(WFldNmArr3)
     C                   IF        WFldNmArr3(i) = *BLANK
     C                   LEAVE
     C                   ENDIF
 
     C                   Z-ADD     1             j
 
     C                   EVAL      Found   = 'N'
     C                   EVAL      MgFlFld = WFldNmArr3(i)
     C                   EVAL      MgFlMsg = WMsgIdArr3(i)
 
     C                   DOW       j <= %ELEM(FldMsgA3)
 
     C     j             OCCUR     FldMsgA3
     C     FldMsgA3      IFEQ      *BLANK
     C                   LEAVE
     C                   ENDIF
     C     FldMsgA3      IFEQ      ArgMgFl
     C                   EVAL      Found   = 'Y'
     C                   LEAVE
     C                   ENDIF
 
     C                   ADD       1             j
     C                   ENDDO
 
     C                   IF        Found   = 'Y'
     C                   ADD       1             WrnMem
     C                   ELSE
     C                   IF        j <= %ELEM(FldMsgA3)
     C     j             OCCUR     FldMsgA3
     C                   EVAL      FldMsgA3 = ArgMgFl
     C                   ENDIF
     C                   ENDIF
 
     C                   ADD       1             i
     C                   ENDDO
 
      ** If all the warnings have been already displayed
      ** We reset all the warning arrays
     C                   IF        WrnMem  = IdxWrn3
     C                   EVAL      WrnToDsp  = 'N'
     C                   MOVEL     *ALL'Y'       OkCre3
     C                   MOVEL     *BLANK        WFldNmArr3                     PF0008
     C                   MOVEL     *BLANK        WMsgIdArr3                     PF0008
     C                   MOVEL     *BLANK        WMsgDtArr3                     PF0008
     C                   ELSE
     C                   EVAL      WrnToDsp  = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUT PARAMETERS
     C                   PARM                    RetCodeIn
      * Response mode (1A), from source system common header (A or S)
     C                   PARM                    RespMode
      * Current screen
     C                   PARM                    CurScreen
      * Action Code
     C                   PARM                    ActionCode
      * Reinitialize screen
     C                   PARM                    Reinit
      * Header information (DS) from source system in screen format
     C                   PARM                    HdrScnIn
      * Detail information (DS) from source system in screen format
     C                   PARM                    DtlScnIn
 
      ** OUTPUT PARAMETERS
 
      * Warnings to display
     C                   PARM                    WrnToDsp
      * OK Flags Data Structure - Screens
     C                   PARM                    OkCre1
     C                   PARM                    OkCre2
     C                   PARM                    OkCre3
      * Array index from/to caller
     C                   PARM                    IdxErr1
     C                   PARM                    IdxErr2
     C                   PARM                    IdxErr3
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNmArr1
     C                   PARM                    MsgIdArr1
     C                   PARM                    MsgDtArr1
     C                   PARM                    FldNmArr2
     C                   PARM                    MsgIdArr2
     C                   PARM                    MsgDtArr2
     C                   PARM                    FldNmArr3
     C                   PARM                    MsgIdArr3
     C                   PARM                    MsgDtArr3
      * Array index from/to caller
     C                   PARM                    IdxWrn1
     C                   PARM                    IdxWrn2
     C                   PARM                    IdxWrn3
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmArr1
     C                   PARM                    WMsgIdArr1
     C                   PARM                    WMsgDtArr1
     C                   PARM                    WFldNmArr2
     C                   PARM                    WMsgIdArr2
     C                   PARM                    WMsgDtArr2
     C                   PARM                    WFldNmArr3
     C                   PARM                    WMsgIdArr3
     C                   PARM                    WMsgDtArr3
 
     C                   CLEAR                   FldMsgA1
     C                   CLEAR                   FldMsgA2
     C                   CLEAR                   FldMsgA3
 
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
(c) Finastra International Limited 2001
