     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE DPMV - Validation')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading ILE Module                        *
      *                                                               *
      *  SEDPMV3VL - SE Depot Movements Validation                    *
      *                                                               *
      *  Function: This Program validates SE Extended Depot Movements *
      *            Fields for input into the Midas Database.          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027A            Date 05May06               *
      *  Prev Amend No. CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CER001 - LUX Upgrade to MidasPlus.                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
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
      ** fields as #ProcPgm, #ProcMod and #ProcName.  They are based
      ** on the corresponding fields in the PSDS /COPY member, so that
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
      ** New Depot in File Format
     D NwDlFilFmt    E DS                  EXTNAME(SEVDMLX1PD)
 
      ** New Depot in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(SEDMRXPD)
 
      ** Error fields indicators
     D OkFlags       E DS                  EXTNAME(SEEDMLX1PD)
 
 
      ** Data passed from caller program
     D DATALUX         DS          1024
     D**#1FLD1**               1      6  0                                                   CSD027A
     D  #1DPSS                 1     10
     D  #1DPRN                11     16
     D  #1DPMV                17     18
     D  #1FOTR                19     38
     D  #1TMST                39     64Z
      **
      **   Declared variables
      **   ==================
      **
 
      ** "Standard" *entry parameters
 
     D ACTN            S              1
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** "Extra" *entry parameters
 
     D ULX008          S              1
 
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
     C                   EXSR      SROPTP
     C                   EXSR      SREXCF
      *
      ** If ULX008 is present and Depot is 'WI' or 'WO'.
      *
     C                   IF        ULX008 = 'Y'
     C                   EXSR      SRTIME
     C                   EXSR      SRCABR
     C                   EXSR      SRCNBR
     C                   ENDIF
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
      * SROPTP - Routine to validate WNOPTP
      *****************************************************************
     C     SROPTP        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SEVWNOPTP'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXOPTP
     C                   PARM                    #1DPMV
      *
     C                   IF        MSG1 <> *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'L6LXOPTP'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXOPTP
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SREXCF - Routine to validate WNEXCF
      *****************************************************************
     C     SREXCF        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SEVWNEXCF'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXEXCF
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx  =  Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXEXCF'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXEXCF
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRTIME - Routine to validate WNTIME
      *****************************************************************
     C     SRTIME        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SEVWNTIME'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXTTIM
      *
     C                   IF        MSG1  <> *BLANK
     C                   EVAL      Idx  = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXTTIM'
     C                   EVAL      MsgIDArr(Idx)   = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXTTIM
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCABR - Routine to validate WNCABR
      *****************************************************************
     C     SRCABR        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SEVWNCABR'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXCABR
      *
     C                   IF        MSG1  <> *BLANK
     C                   EVAL      Idx  = Idx + 1
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
      * SRCNBR - Routine to validate WNCNBR
      *****************************************************************
     C     SRCNBR        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SEVWNCNBR'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXCNBR
      *
     C                   IF        MSG1  <> *BLANK
     C                   EVAL      Idx  = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXCNBR'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ELSE
      *
     C                   IF        ReturnCode = '?'
     C                   EVAL      Idx  = Idx + 1
     C                   EVAL      ReturnCode = *Blanks
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXCNBR
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSETUP - Set up additional fields that are needed on the     *
      *           Valid file record.                                  *
      *                                                               *
      *****************************************************************
     C     SRSETUP       BEGSR
      *
      ** Other VLxxxx fields are set up during validation, such as the
      ** ones where the input & database formats are different.
      ** This SR sets up the fields with the same attributes
      *
     C                   MOVE      #1DPSS        #6LXWNDPSS
     C                   MOVE      #1DPRN        #6LXWNDPRN
      *
     C                   MOVE      L6LXOPTP      #6LXWNOPTP
     C                   MOVE      L6LXEXCF      #6LXWNEXCF
      *
      **  If feature ULX008 is installed
      *
     C                   IF        ULX008  = 'Y'
     C                   MOVE      L6LXTTIM      #6LXWNTIME
     C                   MOVE      L6LXCABR      #6LXWNCABR
     C                   MOVE      L6LXCNBR      #6LXWNCNBR
     C                   IF        ACTN    = 'I'
     C                   EVAL      #6LXWNEXFL = *BLANKS
     C                   ENDIF
     C                   ELSE
     C                   EVAL      #6LXWNTIME = 0
     C                   ENDIF
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
     C                   PARM                    ULX008
      *
      ** Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'SEDPMV3VL'
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
