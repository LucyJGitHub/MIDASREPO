     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC 24x7 Validate Message Time')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SCVMTIM   - Validate Message Time                            *
      *                                                               *
      *  Function:  This module validates the Message Time field.     *
      *                                                               *
      *  Component of: SCWMSGVAL                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    12         Lookup indicator                                *
      *    90-99      Used by Standard Subroutines                    *
      *                                                               *
      *    U7+U8      Database Error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRVMsgTime - Validate Message Time                           *
      *  SRInit - Initialisation                                      *
      *                                                               *
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
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D WrkArr          S                   DIM(XArrayMax) LIKE(#MsgId) ASCEND
 
     D                 DS
     D WTimeChar               1      5
     D WTimeNum                1      5  0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D OKMTIM          S              1
 
     D PMType          S              1
     D PMinutes        S              3
     D PSeconds        S              2
     D PAlignOK        S              1
     D PCheck          S             16
     D PNoDec          S              1  0
     D PNoDig          S              2  0
 
     D WSecNum         S              2  0
     D Idx             S              3P 0
 
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
 
      ** Initialise fields.
 
     C                   EXSR      SRInit
 
      ** Validate Message Time.
 
     C                   EXSR      SRVMsgTime
 
     C                   IF        OKMTIM = 'N'
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVMsgTime - Validate Message Time                           *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls    : ZALIGN                                            *
      *                                                               *
      *****************************************************************
 
     C     SRVMsgTime    BEGSR
 
     C                   IF        PMType = 'C' OR PMType = 'S' OR PMType = 'M'
     C                             OR PMType = 'V' OR PMType = 'W'
 
      ** Message Time must be specified and must not be 0.
 
     C                   IF        WTimeChar = *BLANKS OR WTimeNum = *ZERO
     C                   EVAL      OKMTIM = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = '#2MTIM'
     C                   EVAL      MsgIdXAr(Idx) = 'SCC0017'
 
     C                   ELSE
     C                   EVAL      PCheck = PMinutes
     C                   EVAL      PNoDec = 0
     C                   EVAL      PNoDig = 3
 
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       PAlignOK
     C                   PARM                    PCheck
     C                   PARM                    PNoDec
     C                   PARM                    PNoDig
 
      ** Message Time (minutes) must be numeric.
 
     C                   IF        PAlignOK = 'N'
     C                   EVAL      OKMTIM = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = '#2MTIM'
     C                   EVAL      MsgIdXAr(Idx) = 'SCC0018'
 
     C                   ELSE
     C                   MOVE      PCheck        PMinutes
     C                   ENDIF
 
     C                   EVAL      PCheck = PSeconds
     C                   EVAL      PNoDec = 0
     C                   EVAL      PNoDig = 2
 
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       PAlignOK
     C                   PARM                    PCheck
     C                   PARM                    PNoDec
     C                   PARM                    PNoDig
 
      ** Message Time (seconds) must be numeric.
 
     C                   IF        PAlignOK = 'N'
     C                   MOVEA     MsgIdXAr      WrkArr
     C     'SCC0018'     LOOKUP    WrkArr                                 12
     C                   IF        *IN12 = '0'
     C                   EVAL      OKMTIM = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = '#2MTIM'
     C                   EVAL      MsgIdXAr(Idx) = 'SCC0018'
     C                   ENDIF
 
     C                   ELSE
     C                   MOVE      PCheck        PSeconds
     C                   MOVE      PSeconds      WSecNum
 
      ** Message Time (seconds) must be less than 60.
 
     C                   IF        WSecNum > 59
     C                   EVAL      OKMTIM = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = '#2MTIM'
     C                   EVAL      MsgIdXAr(Idx) = 'SCC0019'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Initialisation                                      *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRInit        BEGSR
 
     C                   EVAL      OKMTIM = 'Y'
     C                   EVAL      Idx = 0
     C                   EVAL      WTimeChar = PMinutes + PSeconds
     C                   RESET                   WrkArr
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly upon program activation                *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Message Type
 
     C                   PARM                    PMType
 
      ** Message Time
 
     C                   PARM                    PMinutes
     C                   PARM                    PSeconds
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warnings
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      ** Message Time OK
 
     C                   PARM                    OKMTIM
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
** CPY@
(c) Finastra International Limited 2001
