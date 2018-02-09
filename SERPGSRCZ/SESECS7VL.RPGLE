     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities Details 2 LUX Validate')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading ILE Module                        *
      *                                                               *
      *  SESECS7VL - SE Securities Details 2 LUX Validate             *
      *                                                               *
      *  Function:  This function is the main validation process for  *
      *             Extended Securities Details                       *
      *                                                               *
      *  (c) Copyright Finastra International Limited 2005            *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                     error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
 
      *
      ** Program Status Data Structure
      ** The following /COPY line includes all the defined fields in
      ** the PSDS. They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
 
      *
      ** The following /COPY line includes definitions for the above
      ** fields as #ProcPgm, #ProcMod and #ProcName.  They are based on
      ** the corresponding fields in the PSDS /COPY member, so this
      ** later member must be included where this one is used.
      *
     D/COPY ZACPYSRC,PROCPARMS
 
      *
      ** The following /COPY line includes the definitions for error &
      ** warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      *
      ** Manually included D-specs
      ** =========================
      *
 
      *
      ** Named constants
      ** ---------------
      *
 
      *
      ** Arrays and Data Structures
      ** --------------------------
      *
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** Externally described DS for SAR details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access programs, short Data
      *
 
     D NwExFilFmt    E DS                  EXTNAME(SEVSELX3PD)
      *
      ** New Extension in File Format (#6LXVV)
      *
 
     D NwExScnFmt    E DS                  EXTNAME(SESERXPD)
      *
      ** New Extension in Screen Format (#nLX)
      *
 
     D OkFlags       E DS                  EXTNAME(SEESELX3PD)
      *
      ** Error indicators (OK#6LX)
      *
 
      *
      ** Data passed from caller program
      *
     D/COPY QWINDSRC,SESECSDTA
     D DATALUX         DS          1024
     D  L1SESN                 1     10A
     D  L1FOTR                11     30A
     D  L1ISNO                31     42A
 
      *
      ** Declared variables
      ** ------------------
      *
 
      *
      ** "Standard" *entry parameters
      *
     D ACTN            S              1
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      *
      ** Output parameters for call to individual validation modules
      *
     D WWSECT          S                   LIKE(#6LXVVSECT)
     D WWROFC          S                   LIKE(#6LXVVROFC)
     D WWRATC          S                   LIKE(#6LXVVRATC)
     D WWIM93          S                   LIKE(#6LXVVIM93)
     D WWCLAT          S                   LIKE(#6LXVVCLAT)
     D WWSUBR          S                   LIKE(#6LXVVSUBR)
     D WWLUSU          S                   LIKE(#6LXVVLUSU)
     D WWLURA          S                   LIKE(#6LXVVLURA)
     D WWVOTR          S                   LIKE(#6LXVVVOTR)
     D WWSECD          S                   LIKE(#6LXVVSECD)
     D WWSNCD          S                   LIKE(#6LXVVSNCD)
     D WWEEEM          S                   LIKE(#6LXVVEEEM)
     D WWQUOT          S                   LIKE(#6LXVVQUOT)
 
      *
      ** Error message fields received as parameters
      *
     D MsgId1          S                   LIKE(#MsgID)
     D MsgId2          S                   LIKE(#MsgID)
     D MsgId3          S                   LIKE(#MsgID)
     D MsgId4          S                   LIKE(#MsgID)
     D MsgId5          S                   LIKE(#MsgID)
     D MsgId6          S                   LIKE(#MsgID)
     D MsgId7          S                   LIKE(#MsgID)
 
      *
      ** Warning error message fields received as parameters
      *
     D WmsgId1         S                   LIKE(#MsgID)
     D WmsgId2         S                   LIKE(#MsgID)
     D WmsgId3         S                   LIKE(#MsgID)
     D WmsgId4         S                   LIKE(#MsgID)
     D WmsgId5         S                   LIKE(#MsgID)
     D WmsgId6         S                   LIKE(#MsgID)
     D WmsgId7         S                   LIKE(#MsgID)
 
      *
      ** Error message substitution data received as a parameter
      *
     D MsgData1        S                   LIKE(#MsgData)
     D MsgData2        S                   LIKE(#MsgData)
     D MsgData3        S                   LIKE(#MsgData)
     D MsgData4        S                   LIKE(#MsgData)
     D MsgData5        S                   LIKE(#MsgData)
     D MsgData6        S                   LIKE(#MsgData)
     D MsgData7        S                   LIKE(#MsgData)
 
      *****************************************************************
      *                M A I N  P R O C E S S I N G                   *
      *****************************************************************
      *
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      *
 
      *
      ** Validates screen fields
      *
     C                   EXSR      SRLUSU
     C                   EXSR      SRSUBR
     C                   EXSR      SRIM93
     C                   EXSR      SRCLAT
     C                   EXSR      SRSECT
     C                   EXSR      SRROFC
     C                   EXSR      SRRATC
     C                   EXSR      SRVOTR
     C                   EXSR      SRSECD
     C                   EXSR      SRSNCD
     C                   EXSR      SREEEM
     C                   EXSR      SRQUOT
 
      *
      ** If no errors sets up valid file record
      *
     C                   IF        Idx = 0
     C                   EXSR      SRSETUP
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      * RESETERRS - Reset error information sent back by validation   *
      *             modules                                           *
      *****************************************************************
     C     RESETERRS     BEGSR
 
     C                   RESET                   MsgId1
     C                   RESET                   MsgId2
     C                   RESET                   MsgId3
     C                   RESET                   MsgId4
     C                   RESET                   MsgId5
     C                   RESET                   MsgId6
     C                   RESET                   MsgId7
 
     C                   RESET                   WMsgId1
     C                   RESET                   WMsgId2
     C                   RESET                   WMsgId3
     C                   RESET                   WMsgId4
     C                   RESET                   WMsgId5
     C                   RESET                   WMsgId6
     C                   RESET                   WMsgId7
 
     C                   RESET                   MsgData1
     C                   RESET                   MsgData2
     C                   RESET                   MsgData3
     C                   RESET                   MsgData4
     C                   RESET                   MsgData5
     C                   RESET                   MsgData6
     C                   RESET                   MsgData7
 
     C                   EVAL      ReturnCode = *Blanks
 
     C                   ENDSR
 
      *****************************************************************
      * SRLUSU - Validates Lump-Sum Code field                        *
      *****************************************************************
     C     SRLUSU        BEGSR
 
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
 
      *
      ** Call the specific validation module
      *
     C                   CALLB     'SEVSELUSU'
     C                   PARM                    ReturnCode
     C                   PARM                    MsgId1
     C                   PARM                    MsgData1
     C                   PARM                    L6LXLUSU
     C                   PARM                    WWLUSU
     C                   PARM                    WWLURA
 
      *
      ** If an error was found
      *
     C                   IF        MsgId1  <> *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'L6LXLUSU'
     C                   EVAL      MsgIDArr(Idx)   = MsgId1
     C                   EVAL      MsgDtaArr(Idx)  = MsgData1
     C                   ENDIF
 
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXLUSU
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
     C                   ENDSR
 
      *****************************************************************
      * SRSUBR - Validates Subordinate field                          *
      *****************************************************************
     C     SRSUBR        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
 
      *
      ** Call the specific validation module
      *
     C                   CALLB     'SEVSESUBR'
     C                   PARM                    ReturnCode
     C                   PARM                    MsgId1
     C                   PARM                    MsgData1
     C                   PARM                    L6LXSUBR
     C                   PARM                    WWSUBR
 
      *
      ** If an error was found
      *
     C                   IF        MsgId1  <> *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'L6LXSUBR'
     C                   EVAL      MsgIDArr(Idx)   = MsgId1
     C                   EVAL      MsgDtaArr(Idx)  = MsgData1
     C                   ELSE
     C                   EVAL      L6LXSUBR = WWSUBR
     C                   ENDIF
 
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXSUBR
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
     C                   ENDSR
 
      *****************************************************************
      * SRIM93 - Validates Note IML 96 / 127 field                    *
      *****************************************************************
     C     SRIM93        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
 
      *
      ** Call the specific validation module
      *
     C                   CALLB     'SEVSEIM93'
     C                   PARM                    ReturnCode
     C                   PARM                    MsgId1
     C                   PARM                    MsgData1
     C                   PARM                    L6LXIM93
     C                   PARM                    WWIM93
 
      *
      ** If an error was found
      *
     C                   IF        MsgId1 <> *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'L6LXIM93'
     C                   EVAL      MsgIDArr(Idx)   = MsgId1
     C                   EVAL      MsgDtaArr(Idx)  = MsgData1
     C                   ENDIF
 
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXIM93
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
     C                   ENDSR
 
      *****************************************************************
      * SRCLAT - Validates Claims Type field                          *
      *****************************************************************
     C     SRCLAT        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
 
      *
      ** Call the specific validation module
      *
     C                   CALLB     'SEVSECLAT'
     C                   PARM                    ReturnCode
     C                   PARM                    MsgId1
     C                   PARM                    MsgData1
     C                   PARM                    L6LXCLAT
     C                   PARM                    L6LXSUBR
     C                   PARM                    WWCLAT
 
      *
      ** If an error was found
      *
     C                   IF        MsgId1 <> *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'L6LXCLAT'
     C                   EVAL      MsgIDArr(Idx)   = MsgId1
     C                   EVAL      MsgDtaArr(Idx)  = MsgData1
     C                   ENDIF
 
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXCLAT
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
     C                   ENDSR
 
      *****************************************************************
      * SRSECT - Validates Security type field                        *
      *****************************************************************
     C     SRSECT        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
 
      *
      ** Call the specific validation module
      *
     C                   CALLB     'SEVSESECT'
     C                   PARM                    ReturnCode
     C                   PARM                    MsgId1
     C                   PARM                    MsgData1
     C                   PARM                    L6LXSECT
     C                   PARM                    WWSECT
 
      *
      ** If an error was found
      *
     C                   IF        MsgId1 <> *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'L6LXSECT'
     C                   EVAL      MsgIDArr(Idx)   = MsgId1
     C                   EVAL      MsgDtaArr(Idx)  = MsgData1
     C                   ENDIF
 
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXSECT
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
     C                   ENDSR
 
      *****************************************************************
      * SRROFC - Validates Rating Office Code field                   *
      *****************************************************************
     C     SRROFC        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
 
      *
      ** Call the specific validation module
      *
     C                   CALLB     'SEVSEROFC'
     C                   PARM                    ReturnCode
     C                   PARM                    MsgId1
     C                   PARM                    MsgData1
     C                   PARM                    L6LXROFC
     C                   PARM                    WWROFC
 
      *
      ** If an error was found
      *
     C                   IF        MsgId1 <> *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'L6LXROFC'
     C                   EVAL      MsgIDArr(Idx)   = MsgId1
     C                   EVAL      MsgDtaArr(Idx)  = MsgData1
     C                   ENDIF
 
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXROFC
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
     C                   ENDSR
 
      *****************************************************************
      * SRRATC - Validates Rating Code field                          *
      *****************************************************************
     C     SRRATC        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
 
      *
      ** Call the specific validation module
      *
     C                   CALLB     'SEVSERATC'
     C                   PARM                    ReturnCode
     C                   PARM                    MsgId1
     C                   PARM                    MsgData1
     C                   PARM                    L6LXRATC
     C                   PARM                    WWRATC
 
      *
      ** If an error was found
      *
     C                   IF        MsgId1 <> *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'L6LXRATC'
     C                   EVAL      MsgIDArr(Idx)   = MsgId1
     C                   EVAL      MsgDtaArr(Idx)  = MsgData1
     C                   ENDIF
 
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXRATC
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
     C                   ENDSR
 
      *****************************************************************
      * SRVOTR - Validates Voting Right in % field                    *
      *****************************************************************
     C     SRVOTR        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
 
      *
      ** Call the specific validation module
      *
     C                   CALLB     'SEVSEVOTR'
     C                   PARM                    ReturnCode
     C                   PARM                    MsgId1
     C                   PARM                    MsgData1
     C                   PARM                    L6LXVOTR
     C                   PARM                    WWVOTR
 
      *
      ** If an error was found
      *
     C                   IF        MsgId1  <> *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'L6LXVOTR'
     C                   EVAL      MsgIDArr(Idx)   = MsgId1
     C                   EVAL      MsgDtaArr(Idx)  = MsgData1
     C                   ELSE
     C                   EVAL      L6LXVOTR = %CHAR(WWVOTR)
     C                   ENDIF
 
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXVOTR
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
     C                   ENDSR
 
      *****************************************************************
      * SRSECD - Validates Security Code field                        *
      *****************************************************************
     C     SRSECD        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
 
      *
      ** Call the specific validation module
      *
     C                   CALLB     'SEVSESECD'
     C                   PARM                    ReturnCode
     C                   PARM                    MsgId1
     C                   PARM                    MsgData1
     C                   PARM                    L6LXSECD
     C                   PARM                    ULX008
     C                   PARM                    L1ISNO
     C                   PARM                    WWSECD
 
      *
      ** If an error was found
      *
     C                   IF        MsgId1  <> *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'L6LXSECD'
     C                   EVAL      MsgIDArr(Idx)   = MsgId1
     C                   EVAL      MsgDtaArr(Idx)  = MsgData1
     C                   ELSE
     C                   EVAL      L6LXSECD = WWSECD
     C                   ENDIF
 
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXSECD
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
     C                   ENDSR
 
      *****************************************************************
      * SRSNCD - Validates Security National Code field               *
      *****************************************************************
     C     SRSNCD        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
 
      *
      ** Call the specific validation module
      *
     C                   CALLB     'SEVSESNCD'
     C                   PARM                    ReturnCode
     C                   PARM                    MsgId1
     C                   PARM                    MsgData1
     C                   PARM                    L6LXSNCD
     C                   PARM                    L6LXSECD
     C                   PARM                    ULX008
     C                   PARM                    WWSNCD
 
      *
      ** If an error was found
      *
     C                   IF        MsgId1  <> *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'L6LXSNCD'
     C                   EVAL      MsgIDArr(Idx)   = MsgId1
     C                   EVAL      MsgDtaArr(Idx)  = MsgData1
     C                   ELSE
     C                   EVAL      L6LXSNCD = WWSNCD
     C                   ENDIF
 
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXSNCD
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
     C                   ENDSR
 
      *****************************************************************
      * SREEEM - Validates Quoted on EEE Market field                 *
      *****************************************************************
     C     SREEEM        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
 
      *
      ** Call the specific validation module
      *
     C                   CALLB     'SEVSEEEEM'
     C                   PARM                    ReturnCode
     C                   PARM                    MsgId1
     C                   PARM                    MsgData1
     C                   PARM                    L6LXEEEM
     C                   PARM                    ULX008
     C                   PARM                    WWEEEM
 
      *
      ** If an error was found
      *
     C                   IF        MsgId1  <> *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'L6LXEEEM'
     C                   EVAL      MsgIDArr(Idx)   = MsgId1
     C                   EVAL      MsgDtaArr(Idx)  = MsgData1
     C                   ELSE
     C                   EVAL      L6LXEEEM = WWEEEM
     C                   ENDIF
 
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXEEEM
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
     C                   ENDSR
 
      *****************************************************************
      * SRQUOT - Validates Quoted (Y/N)                               *
      *****************************************************************
     C     SRQUOT        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
 
      *
      ** Call the specific validation module
      *
     C                   CALLB     'SEVSEQUOT'
     C                   PARM                    ReturnCode
     C                   PARM                    MsgId1
     C                   PARM                    MsgData1
     C                   PARM                    L6LXQUOT
     C                   PARM                    ULX046
     C                   PARM                    WWQUOT
 
      *
      ** If an error was found
      *
     C                   IF        MsgId1  <> *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'L6LXQUOT'
     C                   EVAL      MsgIDArr(Idx)   = MsgId1
     C                   EVAL      MsgDtaArr(Idx)  = MsgData1
     C                   ELSE
     C                   EVAL      L6LXQUOT = WWQUOT
     C                   ENDIF
 
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXQUOT
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
     C                   ENDSR
 
      *****************************************************************
      * SRSETUP - Sets up the fields needed in the valid file record  *
      *****************************************************************
     C     SRSETUP       BEGSR
 
     C                   MOVE      L1FOTR        #6LXVVTOPR
 
     C                   MOVE      L1SESN        #6LXVVSESN
     C                   MOVE      WWSECT        #6LXVVSECT
     C                   MOVE      WWROFC        #6LXVVROFC
     C                   MOVE      WWRATC        #6LXVVRATC
     C                   MOVE      WWIM93        #6LXVVIM93
     C                   MOVE      WWCLAT        #6LXVVCLAT
     C                   MOVE      WWSUBR        #6LXVVSUBR
     C                   MOVE      WWLUSU        #6LXVVLUSU
     C                   MOVE      WWLURA        #6LXVVLURA
     C                   MOVE      WWVOTR        #6LXVVVOTR
     C                   MOVE      WWSECD        #6LXVVSECD
     C                   MOVE      WWSNCD        #6LXVVSNCD
     C                   MOVE      WWEEEM        #6LXVVEEEM
     C                   MOVE      WWQUOT        #6LXVVQUOT
 
     C                   ENDSR
 
      *****************************************************************
      * *INZSR - Program initialisation                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    ACTN
     C                   PARM                    DATALUX
     C                   PARM                    NwExScnFmt
     C                   PARM                    OKFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwExFilFmt
 
      *
      ** Move program name into *LDA field
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     PSProcPgm     DBPGM
     C                   OUT       LDA
 
      *
      ** ULX008 - Commissariat aux Bourses
      *
     C                   MOVE      'N'           ULX008            1
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'ULX008'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           ULX008
     C                   ENDIF
 
      *
      ** ULX046 - Circulars 2002/170-174-175 Integration
      *
     C                   MOVE      'N'           ULX046            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'ULX046'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           ULX046
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *  Program, module and procedure names for database error       *
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
**  CPY@
(c) Copyright Finastra International Limited 2005
