     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Loans/Deposits LUX Validate')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Module                                  *
      *                                                               *
      *  MMLDNI2VL - MM Loans/Deposits LUX Validate                   *
      *                                                               *
      *  Function: This Function validates MM Extended Deals fields   *
      *            for input into the Midas database.                 *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
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
 
      *
      ** DS for access programs, short Data
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      *
      ** DS for Dealing Details
      *
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
 
      *
      ** New Deal in File Format
      *
     D NwDlFilFmt    E DS                  EXTNAME(MMVLDLX1PD)
 
      *
      ** New Deal in Screen Format
      *
     D NwDlScnFmt    E DS                  EXTNAME(MMLDRXPD)
 
      *
      ** Error fields indicators
      *
     D OkFlags       E DS                  EXTNAME(MMELDLX1PD)
 
 
      *
      ** Data passed from caller program
      *
     D DataLUX         DS          1024
     D  #1FLD1                 1      6  0
     D  #1DN38                 1      6
     D  #1DLTP                 7      8
     D  #1CNUM                 9     14
     D  #1CCY                 15     17
     D  #1AMNT                18     32  0
     D  #1VDAT                33     38
     D  #1MDAT                39     44
     D  #1FOTR                45     64
     D  #1TMST                65     90Z
 
      *
      **   Declared variables
      **   ==================
      *
      *
      ** "Standard" *entry parameters
      *
     D ACTN            S              1
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      *
      ** Define parameters for call module
      *
     D W6LXLURA        S              4P 0
 
      *
      ** "Extra" *entry parameters
      *
     D @@ER91          S              1
 
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
 
      *
      ** Error message substitution data received as a parameter
      *
     D MSGDATA         S                   LIKE(#MsgData)
 
      ** Define Work fields
 
     D W1AMNT          S             15  0
 
 
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
     C                   IF        #1AMNT < 0
     C                   Z-SUB     #1AMNT        #1AMNT
     C                   ENDIF
      *
      ** Lump-Sum Code
      *
     C                   EXSR      SRLUSU
      *
      ** Note IML 93/93
      *
     C                   EXSR      SRIM93
      *
      ** Claims Type
      *
     C                   EXSR      SRCLAT
      *
      ** Correction Amount
      *
     C                   EXSR      SRCOAM
      *
      ** Subordinate
      *
     C                   EXSR      SRSUBR
      *
      ** Mobilisable Customer
      *
     C                   EXSR      SRMOBL
      *
      ** Risk Code
      *
     C                   EXSR      SRRISC
      *
      ** Guarantee Code
      *
     C                   EXSR      SR1UAC
      *
      ** Import/Export Code
      *
     C                   EXSR      SRIMEX
      *
      ** Property Sector Code
      *
     C                   EXSR      SRPPSC
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
      * SRLUSU - Routine to validate VLLUSU                           *
      *****************************************************************
     C     SRLUSU        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
     C                   EVAL      W6LXLURA = 0
      *
     C                   CALLB     'MMVVLLUSU'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXLUSU
     C                   PARM                    W6LXLURA
      *
     C                   IF        MSG1 <>  *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXLUSU'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXLUSU
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRIM93 - Routine to validate VLIM93                           *
      *****************************************************************
     C     SRIM93        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'MMVVLIM93'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXIM93
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXIM93'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXIM93
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCLAT - Routine to validate VLCLAT                           *
      *****************************************************************
     C     SRCLAT        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'MMVVLCLAT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXCLAT
     C                   PARM                    L6LXSUBR
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXCLAT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXCLAT
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCOAM - Routine to validate VLCOAM                           *
      *****************************************************************
     C     SRCOAM        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   EVAl      W1AMNT = #1AMNT
     C                   CALLB     'MMVVLCOAM'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXCOAM
     C                   PARM                    #6LXVLCOAM
     C                   PARM                    W1AMNT
     C                   PARM                    #1CCY
      *
      ** Decimal separator (1A, from SDDEALPD, via caller
      *
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
     C                   PARM                    OK#6LXCOAM
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSUBR - Routine to validate VLSUBR                           *
      *****************************************************************
     C     SRSUBR        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'MMVVLSUBR'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXSUBR
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXSUBR'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXSUBR
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRMOBL - Routine to validate VLMOBL                           *
      *****************************************************************
     C     SRMOBL        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'MMVVLMOBL'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXMOBL
     C                   PARM                    #6LXVLMOBL
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
     C                   PARM                    OK#6LXMOBL
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRISC - Routine to validate VLRISC                           *
      *****************************************************************
     C     SRRISC        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'MMVVLRISC'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXRISC
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXRISC'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXRISC
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SR1UAC - Routine to validate VL1UAC                           *
      *****************************************************************
     C     SR1UAC        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'MMVVL1UAC'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXGUAC
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXGUAC'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXGUAC
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRIMEX - Routine to validate VLIMEX                           *
      *****************************************************************
     C     SRIMEX        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'MMVVLIMEX'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXIMEX
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXIMEX'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXIMEX
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRPPSC - Routine to validate VLPPSC                           *
      *****************************************************************
     C     SRPPSC        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'MMVVLPPSC'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    L6LXPPSC
      *
     C                   IF        MSG1 <> *BLANK
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'L6LXPPSC'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#6LXPPSC
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
      ** dates, amounts.
      ** This SR sets up the fields with the same (or compatible)
      ** attributes
      *
     C                   MOVE      #1DN38        #6LXVLDN38
      *
     C                   MOVE      L6LXSUBR      #6LXVLSUBR
     C                   MOVE      L6LXRISC      #6LXVLRISC
     C                   MOVE      L6LXIMEX      #6LXVLIMEX
     C                   MOVE      L6LXPPSC      #6LXVLPPSC
     C                   MOVE      L6LXIM93      #6LXVLIM93
     C                   MOVE      L6LXCLAT      #6LXVLCLAT
      *
     C                   EVAL      #6LXVL1UAC = 0
     C                   IF        L6LXGUAC = '5'
     C                   MOVE      L6LXGUAC      #6LXVL1UAC
     C                   ENDIF
      *
     C                   MOVE      L6LXLUSU      #6LXVLLUSU
     C                   EVAL      #6LXVLLURA = W6LXLURA
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
      *
      ** Action Code
      *
     C                   PARM                    ACTN
      *
      ** Data from deal
      *
     C                   PARM                    DataLUX
      *
      ** New deal screen form
      *
     C                   PARM                    NwDlScnFmt
      *
      ** Field OK Flags
      *
     C                   PARM                    OKFlags
      *
      ** Errors Fields
      *
     C                   PARM                    FldNameArr
      *
      ** Errors Fields
      *
     C                   PARM                    MsgIDArr
      *
      ** Errors Fields
      *
     C                   PARM                    MsgDtaArr
      *
      ** Error array index
      *
     C                   PARM                    Idx
      *
      ** Warnings fields
      *
     C                   PARM                    WFldNamArr
      *
      ** Warnings fields
      *
     C                   PARM                    WMsgIDArr
      *
      ** Warning fields
      *
     C                   PARM                    WMsgDtaArr
      *
      ** Warning array index
      *
     C                   PARM                    WIdx
      *
      ** New deal file format
      *
     C                   PARM                    NwDlFilFmt
      *
      ** Guar/Coll pgm call ?
      *
     C                   PARM                    @@ER91
      *
      ** Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'MMLDNI2VL'   DBPGM
     C                   OUT       LDA
      *
      ** Access Dealing details via access program
      ** (database error handling done in access program)
      *
     C                   CALLB     'AODEALR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDDEAL        PARM      SDDEAL        DSFDY
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
(c) Finastra International Limited 2005
