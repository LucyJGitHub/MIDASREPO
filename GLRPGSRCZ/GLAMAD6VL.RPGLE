     H DEBUG
     H COPYRIGHT ('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL AMAD LUX Validate')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMAD6VL - GL AMAD LUX Validate                             *
      *                                                               *
      *  Function: This Program validates GL Extended Account         *
      *            Fields for input into the Midas Database.          *
      *                                                               *
      *  Component of: SP6GL0003 Service Program                      *
      *                                                               *
      *  (c) Misys Internaional Banking Systems Ltd. 2005             *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      /EJECT
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
      ** the PSDS. They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes definitions for the above
      ** fields as #ProcPgm, #ProcMod and #ProcName. They are based
      ** on the corresponding fields in the PSDS /COPY member,
      ** so that member must be included where this one is used.
     D/COPY ZACPYSRC,PROCPARMS
 
      ** The following /COPY line includes the definitions for error &
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      **
      **   Named constants
      **   ===============
      **
 
      **
      **   Arrays and Data Structures
      **   ==========================
      **
 
      ** New Account in File Format
     D NwDlFilFmt    E DS                  EXTNAME(GLVAMLX1PD)
 
      ** New Account in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(GLAMRXPD)
 
      ** Error fields indicators
     D OkFlags       E DS                  EXTNAME(GLEAMLX1PD)
 
     D DATALUX         DS          1024
     D  #1FLD1                 1      6  0
     D  #1CNUM                 1      6
     D  #1CCY                  7      9
     D  #1ACOD                10     19
     D  #1ACSQ                20     21
     D  #1BRCA                22     24
     D  #1ATYP                25     25
     D  #1STFQ                26     26
     D  #1AMNT                27     41  0
     D  #1FOTR                45     64
     D  #1TMST                65     90Z
 
      **
      **   Declared variables
      **   ==================
      **
 
      ** "Standard" *entry parameters
 
      ** Action Code, Decimal Separator, Index Error Array
      **   and Index Warning Array
     D ACTN            S              1
     D BNDCSP          S              1
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Define parameters for call module
     D W6LXLURA        S              4P 0
 
      ** Error message fields received as parameters
     D     Msg1        S                   LIKE(#MsgID)
     D     Msg2        S                   LIKE(#MsgID)
     D     Msg3        S                   LIKE(#MsgID)
     D     Msg4        S                   LIKE(#MsgID)
     D     Msg5        S                   LIKE(#MsgID)
     D     Msg6        S                   LIKE(#MsgID)
     D     Msg7        S                   LIKE(#MsgID)
 
      ** Warning error message fields received as parameters
     D     WMSGID1     S                   LIKE(#MsgID)
     D     WMSGID2     S                   LIKE(#MsgID)
     D     WMSGID3     S                   LIKE(#MsgID)
     D     WMSGID4     S                   LIKE(#MsgID)
 
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
      **
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      **
      *
      ** Guarantee Code
     C                   EXSR      SRGUAC
      ** Lump-Sum Code
     C                   EXSR      SRLUSU
      ** Correction Amount
     C                   EXSR      SRCOAM
      *
      ** Correction Account
     C                   IF        L6LXCOAC <> *BLANKS
     C                   EXSR      SRCOAC
     C                   ENDIF
      *
      ** If no errors set up outstanding fields for valid file
     C                   IF        Idx = 0
     C                   EXSR      SRSETUP
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RESETERRS - Reset error information that is received back    *
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
 
     C                   EVAL      ReturnCode = *BLANKS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGUAC - Routine to validate WE1UAC                          *
      *                                                               *
      *****************************************************************
     C     SRGUAC        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVWE1UAC'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LX1UAC
      *
     C                   IF        MSG1 <> *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'L6LX1UAC'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM      'Y'           OK#6LX1UAC
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLUSU - Routine to validate WELUSU                          *
      *                                                               *
      *****************************************************************
     C     SRLUSU        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
     C                   Z-ADD     0             W6LXLURA
      *
     C                   CALLB     'GLVWELUSU'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXLUSU
     C                   PARM                    W6LXLURA
      *
     C                   IF        MSG1 <> *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'L6LXLUSU'
     C                   EVAL      MsgIDArr(Idx) = MSG1
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
      *                                                               *
      *  SRCOAM - Routine to validate WECOAM                          *
      *                                                               *
      *****************************************************************
     C     SRCOAM        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVWECOAM'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXCOAM
     C                   PARM                    #6LXWECOAM
     C                   PARM                    #1CCY
      ** Decimal separator (1A, from SDDEALPD, via caller)
     C                   PARM                    BNDCSP
      *
     C                   IF        MSG1 <> *BLANK
     C                   ADD       1             Idx
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
      *                                                               *
      *  SRCOAC - Routine to validate WECOAC and WECOBR               *
      *                                                               *
      *****************************************************************
     C     SRCOAC        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVWECOAC'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    L6LXCOAC
     C                   PARM                    L6LXCOBR
     C                   PARM                    #6LXWECOAM
     C                   PARM                    #1CCY
      *
     C                   IF        MSG1 <> *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'L6LXCOAC'
     C                   EVAL      MsgIDArr(Idx) = MSG1
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM      'Y'           OK#6LXCOAC
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
     C                   IF        MSG2 <> *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'L6LXCOBR'
     C                   EVAL      MsgIDArr(Idx) = MSG2
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM      'Y'           OK#6LXCOBR
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
      ** If correction amount and correction account entered,
      ** set the field correction amount in error
      *
     C                   IF        MSG1 = 'ER89006'
     C                   CALLB     'ZASETOKFLG'
     C                   PARM      'Y'           OK#6LXCOAM
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSETUP - Set up additional fields that are needed on the    *
      *           Valid file record.                                  *
      *                                                               *
      *****************************************************************
     C     SRSETUP       BEGSR
      *
      ** Other VLxxxx fields are set up during validation, such as the
      ** ones where the input & database formats are different,
      ** e.g. dates, amounts. This SR sets up the fields
      ** with the same (or compatible) attributes
      *
     C                   MOVE      #1CNUM        #6LXWECNUM
     C                   EVAL      #6LXWECCYC = #1CCY
     C                   MOVE      #1ACOD        #6LXWEACOD
     C                   MOVE      #1ACSQ        #6LXWEACSQ
     C                   EVAL      #6LXWEBRCA = #1BRCA
     C                   EVAL      #6LXWEATYP = #1ATYP
      *
     C                   IF        L6LX1UAC = '5'
     C                   MOVE      L6LX1UAC      #6LXWE1UAC
     C                   ELSE
     C                   EVAL      #6LXWE1UAC = 0
     C                   ENDIF
      *
     C                   MOVE      L6LXLUSU      #6LXWELUSU
     C                   EVAL      #6LXWELURA = W6LXLURA
     C                   EVAL      #6LXWECOAC = L6LXCOAC
     C                   EVAL      #6LXWECOBR = L6LXCOBR
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      ** Action Code, Data from Depot, New Depot Screen Form
     C                   PARM                    ACTN
     C                   PARM                    DATALUX
     C                   PARM                    NwDlScnFmt
      ** Decimal separator (1A, from SDDEALPD, via caller)
     C                   PARM                    BNDCSP
      ** Field OK Flags
     C                   PARM                    OKFlags
      ** Error Fields
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      ** Error Array Index
     C                   PARM                    Idx
      ** Warning Fields
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      ** Warning Array Index and New Depot File Format
     C                   PARM                    WIdx
     C                   PARM                    NwDlFilFmt
      *
      ** Move program name into *LDA field.
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'GLAMAD6VL'
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
      * The following /COPY sets these values, and also defines LDA as
      * an external data area
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
