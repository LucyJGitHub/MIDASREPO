     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NAs Purchased LUX Validate')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Module                                  *
      *                                                               *
      *  MMNASP2VL - MM NA Purchased LUX Validate                     *
      *                                                               *
      *  Function: This Function validates NA Purchased extension     *
      *            fields.                                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027A            Date 03May06               *
      *  Prev Amend No. BUG9711            Date 26Jan06               *
      *                 CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027A - Conversion of customer number to alpha (post       *
      *            build 103). Recompiled.                            *
      *  BUG9711- Changes to MMVNASPPD/MMVNASSPD (re-compile)         *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                    error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      *
      ** The following /COPY line includes definitions for the above
      ** fields as #ProcPgm, #ProcMod and #ProcName. They are based
      ** on the corresponding fields in the PSDS /COPY member, so that
      ** member must be included where this one is used.
      *
     D/COPY ZACPYSRC,PROCPARMS
 
      *
      ** The following /COPY line includes the definitions for error &
      ** warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** New Deal in File Format
     D NwDlFilFmt    E DS                  EXTNAME(MMVNPLX1PD)
      *
      ** New Deal in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(MMNPRXPD)
      *
      ** New Deal Valids file format
     D NwDlFilFmtMainE DS                  EXTNAME(MMVNASPPD)
      *
      ** Error fields indicators
     D OkFlags       E DS                  EXTNAME(MMENPLX1PD)
 
 
      **   Declared variables
      **   ==================
     D Idx             S              3P 0
     D WIdx            S              3P 0
      *
      ** Define parameters for call module
     D BNDCSP          S              1A
     D WIHAMNP         S             15P 0
     D W6LXLURA        S              4P 0
      *
      ** Error message fields received as parameters
     D     Msg1        S                   LIKE(#MsgID)
     D     Msg2        S                   LIKE(#MsgID)
     D     Msg3        S                   LIKE(#MsgID)
     D     Msg4        S                   LIKE(#MsgID)
     D     Msg5        S                   LIKE(#MsgID)
     D     Msg6        S                   LIKE(#MsgID)
     D     Msg7        S                   LIKE(#MsgID)
      *
      ** Warning error message fields received as parameters
     D     WMSGID1     S                   LIKE(#MsgID)
     D     WMSGID2     S                   LIKE(#MsgID)
     D     WMSGID3     S                   LIKE(#MsgID)
     D     WMSGID4     S                   LIKE(#MsgID)
      *
      ** Error message substitution data received as a parameter
     D MSGDATA         S                   LIKE(#MsgData)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      *
      ** Lump-Sum Code
     C                   EXSR      SRLUSU
      *
      ** Note IML 93/93
     C                   EXSR      SRIM93
      *
      ** Claims Type
     C                   EXSR      SRCLAT
      *
      ** Correction Amount
     C                   EXSR      SRCOAM
      *
      ** Subordinate
     C                   EXSR      SRSUBR
      *
      ** Mobilisable Customer
     C                   EXSR      SRMOBL
      *
      ** Risk Code
     C                   EXSR      SRRISC
      *
      ** Rating Office Code
     C                   EXSR      SRROFC
      *
      ** Rating Code
     C                   EXSR      SRRATC
      *
      ** Quoted/Not quoted
     C                   EXSR      SRSECQ
      *
      ** Security Type
     C                   EXSR      SRSECT
      *
      ** Consumer Credit Code
     C                   EXSR      SRGUAC
      *
      ** Evaluation method
     C                   EXSR      SREVMT
      *
      ** Operation Type
     C                   EXSR      SROPTP
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *                                                               *
      *****************************************************************
     C     RESETERRS     BEGSR
      *
     C                   RESET                   Msg1
     C                   RESET                   Msg2
     C                   RESET                   Msg3
     C                   RESET                   Msg4
     C                   RESET                   Msg5
     C                   RESET                   Msg6
     C                   RESET                   Msg7
 
     C                   RESET                   WMsgID1
     C                   RESET                   WMsgID2
     C                   RESET                   WMsgID3
     C                   RESET                   WMsgID4
 
     C                   RESET                   MSGDATA
 
     C                   EVAL      ReturnCode= *Blanks
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRLUSU - Routine to validate LUSU                             *
      *****************************************************************
     C     SRLUSU        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'MMVVLLUSU'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      *BLANKS       MSG1
     C                   PARM                    L6LXLUSU
     C                   PARM                    W6LXLURA
      *
     C                   IF        MSG1 <>  *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXLUSU'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ELSE
     C                   MOVE      L6LXLUSU      #6LXVMLUSU
     C                   EVAL      #6LXVMLURA = W6LXLURA
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM      'Y'           OK#6LXLUSU
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRIM93 - Routine to validate IM93                             *
      *****************************************************************
     C     SRIM93        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'MMVVLIM93'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      *BLANKS       MSG1
     C                   PARM                    L6LXIM93
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXIM93'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ELSE
     C                   MOVE      L6LXIM93      #6LXVMIM93
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM      'Y'           OK#6LXIM93
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCLAT - Routine to validate CLAT                             *
      *****************************************************************
     C     SRCLAT        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'MMVVLCLAT'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      *BLANKS       MSG1
     C                   PARM                    L6LXCLAT
     C                   PARM                    L6LXSUBR
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXCLAT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ELSE
     C                   MOVE      L6LXCLAT      #6LXVMCLAT
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM      'Y'           OK#6LXCLAT
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCOAM - Routine to validate COAM                             *
      *****************************************************************
     C     SRCOAM        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   EVAL      WIHAMNP = %Abs(IHAMNP)
     C                   CALLB     'MMVVLCOAM'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      *BLANKS       MSG1
     C                   PARM                    L6LXCOAM
     C                   PARM                    #6LXVMCOAM
     C                   PARM                    WIHAMNP
     C                   PARM                    IHCCY
      *
      ** Decimal separator (1A, from SDDEALPD, via caller
     C                   PARM                    BNDCSP
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXCOAM'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM      'Y'           OK#6LXCOAM
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSUBR - Routine to validate SUBR                             *
      *****************************************************************
     C     SRSUBR        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'MMVVLSUBR'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      *BLANKS       MSG1
     C                   PARM                    L6LXSUBR
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXSUBR'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ELSE
     C                   EVAL      #6LXVMSUBR = L6LXSUBR
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM      'Y'           OK#6LXSUBR
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRMOBL - Routine to validate MOBL                             *
      *****************************************************************
     C     SRMOBL        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'MMVVLMOBL'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      *BLANKS       MSG1
     C                   PARM                    L6LXMOBL
     C                   PARM                    #6LXVMMOBL
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXMOBL'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ELSE
      *
     C                   IF        ReturnCode = '?'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ReturnCode = *Blanks
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM      'Y'           OK#6LXMOBL
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRISC - Routine to validate RISC                             *
      *****************************************************************
     C     SRRISC        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'MMVVLRISC'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      *BLANKS       MSG1
     C                   PARM                    L6LXRISC
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXRISC'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ELSE
     C                   MOVE      L6LXRISC      #6LXVMRISC
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM      'Y'           OK#6LXRISC
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRROFC - Routine to validate ROFC                             *
      *****************************************************************
     C     SRROFC        BEGSR
 
     C                   EVAL      #6LXVMROFC = L6LXROFC
     C                   EVAL      OK#6LXROFC = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRATC - Routine to validate RATC                             *
      *****************************************************************
     C     SRRATC        BEGSR
 
     C                   EVAL      #6LXVMRATC = L6LXRATC
     C                   EVAL      OK#6LXRATC = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRSECQ - Routine to validate SECQ                            *
      *****************************************************************
     C     SRSECQ        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'MMVVSECQ'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    L6LXSECQ
     C                   PARM      *ZERO         #6LXVMSECQ
     C                   PARM      *BLANKS       MSG1
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXSECQ'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM      'Y'           OK#6LXSECQ
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRSECT - Routine to validate SECT                            *
      *****************************************************************
     C     SRSECT        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'MMVVSECT'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    L6LXSECT
     C                   PARM      *BLANKS       MSG1
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXSECT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ELSE
     C                   MOVE      L6LXSECT      #6LXVMSECT
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM      'Y'           OK#6LXSECT
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SR1UAC - Routine to validate GUAC                             *
      *****************************************************************
     C     SRGUAC        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'MMVVL1UAC'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      *BLANKS       MSG1
     C                   PARM                    L6LXGUAC
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXGUAC'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ELSE
     C                   MOVE      L6LXGUAC      #6LXVMGUAC
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM      'Y'           OK#6LXGUAC
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SREVMT - Routine to validate EVMT                            *
      *****************************************************************
     C     SREVMT        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'MMVVEVMT'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    L6LXEVMT
     C                   PARM      *BLANKS       MSG1
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXEVMT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ELSE
     C                   MOVE      L6LXEVMT      #6LXVMEVMT
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM      'Y'           OK#6LXEVMT
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SROPTP - Routine to validate OPTP                            *
      *****************************************************************
     C     SROPTP        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'MMVVOPTP'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    L6LXOPTP
     C                   PARM      *BLANKS       MSG1
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXOPTP'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ELSE
     C                   MOVE      L6LXOPTP      #6LXVMOPTP
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM      'Y'           OK#6LXOPTP
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUT
      ** Lux regional extra fields
     C                   PARM                    NwDlScnFmt
      ** Master Valids transaction details
     C                   PARM                    NwDlFilFmtMain
      ** Decimal separator (1A, from SDDEALPD, via caller
     C                   PARM                    BNDCSP
 
      ** INPUT/OUTPUT
      ** Field OK Flags
     C                   PARM                    OKFlags
 
      ** Error arrays/fields
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
 
      ** Warnings arrays/fields
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
 
      ** New deal file format
     C                   PARM                    NwDlFilFmt
      *
      ** Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'MMNASP2VL'   DBPGM
     C                   OUT       LDA
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Program, module and procedure names for database error process*
      *                                                               *
      *****************************************************************
      *
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,DBERREXIT
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
