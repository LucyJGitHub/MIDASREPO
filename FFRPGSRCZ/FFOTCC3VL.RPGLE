     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Currency OTC LUX Validate')
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FFOTCC3VL - FF Currency OTC LUX Validate                     *
      *                                                               *
      *  Function: This Function validates FF Currency OTC for        *
      *            input into the Midas database.                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER001 - Lux Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
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
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes definitions for the above
      ** fields as #ProcPgm, #ProcMod and #ProcName.  They are based on
      ** the corresponding fields in the PSDS /COPY member, so that
      ** member must be included where this one is used.
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
 
      ** New Future and Option in File Format
     D NwDlFilFmt    E DS                  EXTNAME(FFVTNLX1PD)
 
      ** New Future and Option in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(FFOTRXPD)
 
      ** Error fields indicators
     D OkFlags       E DS                  EXTNAME(FFEOTLX1PD)
 
      ** Data passed from caller program
     D DATALUX         DS          1024
     D  #1ISTT                 1      5
     D  #1TNBR                 6     11
     D  #1MRKT                12     13
     D  #1FOTR                14     33
     D  #1TMST                34     59Z
 
      **
      **   Declared variables
      **   ==================
      **
 
      ** "Standard" *entry parameters
 
     D ACTN            S              1
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
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
     D     WMSGID5     S                   LIKE(#MsgID)
     D     WMSGID6     S                   LIKE(#MsgID)
     D     WMSGID7     S                   LIKE(#MsgID)
 
      ** Error message substitution data received as a parameter
     D MSGDATA         S                   LIKE(#MsgData)
     D MSGDATA2        S                   LIKE(#MsgData)
     D MSGDATA3        S                   LIKE(#MsgData)
     D MSGDATA4        S                   LIKE(#MsgData)
 
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
     C                   EXSR      SRTIME
     C                   EXSR      SRCABR
      *
      ** If no errors set up outstanding fields for valid file
      *
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
      *  SRRSETERRS - Reset error information that is received back   *
      *    from each validation module.                               *
      *                                                               *
      *****************************************************************
     C     SRRSETERRS    BEGSR
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
      *  SRTIME - Routine to validate FFTIME                          *
      *****************************************************************
     C     SRTIME        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      SRRSETERRS
      *
     C                   CALLB     'FFVFFTIME'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXTIME
      *
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'L6LXTIME'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXTIME
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCABR - Routine to validate FFCABR                          *
      *****************************************************************
     C     SRCABR        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      SRRSETERRS
      *
     C                   CALLB     'FFVFFCABR'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXCABR
      *
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'L6LXCABR'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXCABR
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
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
      ** one where the input & database formats are different, e.g.
      ** dates, amounts.  This SR sets up the fields with the same (or
      ** compatible) attributes
      *
     C                   MOVE      #1TNBR        #6LXFFTNBR
      *
     C                   MOVE      L6LXTIME      #6LXFFTIME
     C                   MOVE      *BLANKS       #6LXFFEXFL
     C                   MOVE      L6LXCABR      #6LXFFCABR
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
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    ACTN
     C                   PARM                    DATALUX
     C                   PARM                    NwDlScnFmt
     C                   PARM                    OKFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwDlFilFmt
      *
      ** Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'FFOTCC3VL'   DBPGM
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
