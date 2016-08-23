     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD CUSD - Validation - LU Window')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUSD9VL - SD Customers Validation - LU Window              *
      *                                                               *
      *  Function: This Function validates SD Extended Customers      *
      *            fields for input into the Midas database.          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. BUG13596           Date 20Mar07               *
      *  Prev Amend No. BUG13228           Date 07Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 05May06               *
      *                 CER001  *Create    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG13596 - Subject to Minimum Reserve not being highlighted  *
      *  BUG13228- Do not call SDVVFNCOS if ULX004 is off             *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
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
      **                              error handler)
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
 
      ** DS for access programs, short Data
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** New Customer in File Format
     D NwDlFilFmt    E DS                  EXTNAME(SDVCULX2PD)
 
      ** New Customer in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(SDCURXPD)
 
      ** Error fields indicators
     D OkFlags       E DS                  EXTNAME(SDECULX2PD)
 
      ** Data passed from caller program
     D/COPY QWINDSRC,SDCUSDDTA
     D PDATA           DS          1024
     D**#1FLD1**               1      6  0                                                   CSD027A
 
     D  #1CUST                 1      6
     D  #1PAIN                 7      7
     D  #1PCNB                 8     13
     D  #1COLC                15     16
     D  #1LINC                17     18
     D  #1BRCD                19     21
     D  #1BNBI                22     22
     D  #2CNCZ                23     24
     D  #1FOTR                45     64
     D  #1TMST                65     90Z
     D  #1CRNM                91    110
 
      **
      **   Declared variables
      **   ==================
      **
      *
      ** "Standard" *entry parameters
      *
     D ACTN            S              1
     D Idx             S              3P 0
     D WIdx            S              3P 0
      *
      ** "Extra" *entry parameters
      *
     D ULX008          S              1
     D ULX012          S              1
     D ULX004          S              1                                                     BUG13228
      *
      ** Error message fields received as parameters
      *
     D     Msg1        S                   LIKE(#MsgID)
     D     Msg2        S                   LIKE(#MsgID)
     D     Msg3        S                   LIKE(#MsgID)
     D     Msg4        S                   LIKE(#MsgID)
     D     Msg5        S                   LIKE(#MsgID)
     D     Msg6        S                   LIKE(#MsgID)
     D     Msg7        S                   LIKE(#MsgID)
      *
      ** Warning error message fields received as parameters
      *
     D     WMSGID1     S                   LIKE(#MsgID)
     D     WMSGID2     S                   LIKE(#MsgID)
     D     WMSGID3     S                   LIKE(#MsgID)
     D     WMSGID4     S                   LIKE(#MsgID)
     D     WMSGID5     S                   LIKE(#MsgID)
     D     WMSGID6     S                   LIKE(#MsgID)
     D     WMSGID7     S                   LIKE(#MsgID)
      *
      ** Error message substitution data received as a parameter
      *
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
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      *
     C                   EXSR      SRPAPS
     C                   EXSR      SRCGRP
     C                   EXSR      SRCONS
     C                   EXSR      SRECOS
                                                                                            BUG13228
     C                   IF        ULX004 = 'Y'                                             BUG13228
     C                   EXSR      SRNCOS
     C                   ENDIF                                                              BUG13228
                                                                                            BUG13228
     C                   EXSR      SRINRF
     C                   EXSR      SRPERF
     C                   EXSR      SRSMRS
 
     C                   IF        ULX012 = 'Y'
     C                   EXSR      SRAUTG
     C                   EXSR      SRPROG
     C                   EXSR      SRASSP
 
     C                   ENDIF
 
     C                   IF        ULX008 = 'Y'
     C                   EXSR      SRICCD
     C                   EXSR      SRMCID
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
      * SRPAPS - Routine to validate VFPAPS                           *
      *****************************************************************
     C     SRPAPS        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SDVVFPAPS'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXPAPS
     C                   PARM                    #6LXVFPAPS
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXPAPS'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXPAPS
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCGRP - Routine to validate VFCGRP                           *
      *****************************************************************
     C     SRCGRP        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SDVVFCGRP'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXCGRP
     C                   PARM                    #6LXVFCGRP
     C                   PARM                    #1PAIN
     C                   PARM                    #1PCNB
     C                   PARM                    #1CUST
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXCGRP'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ELSE
      *
     C                   IF        ReturnCode = '?'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ReturnCode = *Blanks
     C                   ENDIF
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXCGRP
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCONS - Routine to validate VFCONS                           *
      *****************************************************************
     C     SRCONS        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SDVVFCONS'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXCONS
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXCONS'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXCONS
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRECOS - Routine to validate VFECOS                           *
      *****************************************************************
     C     SRECOS        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SDVVFECOS'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXECOS
     C                   PARM                    #1LINC
     C                   PARM                    #1COLC
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXECOS'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXECOS
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRNCOS - Routine to validate VFNCOS                           *
      *****************************************************************
     C     SRNCOS        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SDVVFNCOS'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXNCOS
     C                   PARM                    #1COLC
     C                   PARM                    #1LINC
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXNCOS'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXNCOS
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRINRF - Routine to validate VFINRF                           *
      *****************************************************************
     C     SRINRF        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SDVVFINRF'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXINRF
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXINRF'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXINRF
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRPERF - Routine to validate VFPERF                           *
      *****************************************************************
     C     SRPERF        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SDVVFPERF'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXPERF
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXPERF'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXPERF
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSMRS - Routine to validate VFSMRS                           *
      *****************************************************************
     C     SRSMRS        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SDVVFSMRS'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXSMRS
     C                   PARM                    L6LXNCOS
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNameArr(Idx) = '#6LXSMRF'                             BUG13596
     C                   EVAL      FldNameArr(Idx) = 'L6LXSMRS'                             BUG13596
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXSMRS
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRAUTG - Routine to validate VFAUTG                           *
      *****************************************************************
     C     SRAUTG        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SDVVFAUTG'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXAUTG
     C                   PARM                    L6LXCGRP
     C                   PARM                    OK#6LXCGRP
     C                   PARM                    #1CUST
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXAUTG'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXAUTG
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRPROG - Routine to validate VFPROG                           *
      *****************************************************************
     C     SRPROG        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SDVVFPROG'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXPROG
     C                   PARM                    L6LXCGRP
     C                   PARM                    #1CUST
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXPROG'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXPROG
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRASSP - Routine to validate VFASSP                           *
      *****************************************************************
     C     SRASSP        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SDVVFASSP'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXASSP
     C                   PARM                    L6LXAUTG
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXASSP'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXASSP
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRICCD - Routine to validate VFICCD                           *
      *****************************************************************
     C     SRICCD        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SDVVFICCD'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXICCD
     C                   PARM                    #2CNCZ
     C                   PARM                    #1COLC
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXICCD'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ELSE
      *
     C                   IF        ReturnCode = '?'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ReturnCode = *Blanks
     C                   ENDIF
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXICCD
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRMCID - Routine to validate VFMCID                           *
      *****************************************************************
     C     SRMCID        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SDVVFMCID'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXMCID
     C                   PARM                    #1CUST
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXMCID'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXMCID
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
      ** ones where the input & database formats are different, e.g.
      ** dates, amounts. This SR sets up the fields with the same
      ** (or compatible) attributes
      *
     C                   MOVE      #1CUST        #6LXVFCUST
     C                   MOVE      L6LXCONS      #6LXVFCONS
     C                   MOVE      L6LXECOS      #6LXVFECOS
     C                   MOVE      L6LXINRF      #6LXVFINRF
     C                   MOVE      L6LXPERF      #6LXVFPERF
     C                   MOVE      L6LXSMRS      #6LXVFSMRS
     C                   MOVE      L6LXNCOS      #6LXVFNCOS
     C                   MOVE      L6LXCGRP      #6LXVFCGRP
 
     C                   IF        ULX012 = 'Y'
     C                   MOVE      L6LXAUTG      #6LXVFAUTG
     C                   MOVE      L6LXPROG      #6LXVFPROG
     C                   MOVE      L6LXASSP      #6LXVFASSP
     C                   ENDIF
 
     C                   IF        ULX008 = 'Y'
     C                   MOVE      L6LXICCD      #6LXVFICCD
     C                   MOVE      L6LXMCID      #6LXVFMCID
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
     C                   PARM                    PDATA
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
     C                   PARM                    ULX012
     C                   PARM                    ULX004                                     BUG13228
      *
      ** Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCUSD9VL'   DBPGM
     C                   OUT       LDA
      *
     C                   ENDSR
      *
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
