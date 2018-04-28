     H DEBUG
     H COPYRIGHT ('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL BITP - Validation - Extension')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLBPLX2VL - GL BITP Validation - Extension                   *
      *                                                               *
      *  Function: This Function validates GL Extended Journal entry  *
      *            interface fields for input into the Midas database.*
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
      ** fields as #ProcPgm, #ProcMod and #ProcName. They are based on
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
      **   Arrays and Data Structures
      **   ==========================
      **
 
      ** DS for access programs, short Data
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** New Customer in File Format
     D NwDlFilFmt    E DS                  EXTNAME(GLVBPLX1PD)
 
      ** New Customer in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(GLBPRXPD)
 
      ** Error fields indicators
     D OkFlags       E DS                  EXTNAME(GLEBPLX1PD)
 
      ** Data passed from caller program
     D/COPY QWINDSRC,GLBITPSDTA
      *
     D PDATA           DS          1024
     D  #1CUST                 1      6
     D  #1CYCD                 7      9
     D  #1BTNB                10     12
     D  #1BINB                13     15  0
     D  #1DCIN                16     16
     D  #DFMPA                17     30
     D  #1FOTR                31     50
     D  #1TMST                51     76Z
 
      **
      **   Declared variables
      **   ==================
      **
 
      ** "Standard" *entry parameters
 
      ** Action Code
     D ACTN            S              1
      ** Index Error Array
     D Idx             S              3P 0
      ** Index Warning Array
     D WIdx            S              3P 0
 
      ** "Extra" *entry parameters
 
      ** Define parameters for call module
     D WPTAF           S             13P 0
     D @CLIM           S             15P 0
     D @ILIM           S             15P 0
     D #LLXOPCN        S              8A
     D #LLXPTAN        S              8A
     D #LLXDCIN        S              8A
     D #LLXCOCN        S              8A
     D #LLXIDCN        S              8A
     D #LLXIDEN        S              8A
 
     D #LLXOPCF        S              3A
     D #LLXPTAF        S             14A
     D #LLXDCIF        S              1A
     D #LLXCOCF        S              2A
     D #LLXIDCF        S              2A
     D #LLXIDEF        S              9A
 
     D SVOPCF          S              3A
     D SVCOCF          S              2A
     D SVIDCF          S              2A
     D SVIDEF          S              9A
     D SVPTAF          S             14A
     D SVDCIF          S              1A
 
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
 
     D ZALIGNok        S              1A
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
      /EJECT
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
      ** Initialize Operation Codes to blanks if their values are '000'
      **    to avoid validating the other fields with no values.
      *
     C                   IF        LLLXOPC1 = '000'
     C                   EVAL      LLLXOPC1 = *BLANKS
     C                   ENDIF
     C                   IF        LLLXOPC2 = '000'
     C                   EVAL      LLLXOPC2 = *BLANKS
     C                   ENDIF
     C                   IF        LLLXOPC3 = '000'
     C                   EVAL      LLLXOPC3 = *BLANKS
     C                   ENDIF
      *
     C                   IF        LLLXOPC1 <> *BLANKS
     C                             OR LLLXCOC1 <> *BLANKS
     C                             OR LLLXIDC1 <> *BLANKS
     C                             OR LLLXIDE1 <> *BLANKS
     C                             OR LLLXPTA1 <> *BLANKS
     C                             OR LLLXDCI1 <> *BLANKS
      *
     C                   EVAL      #LLXOPCF = LLLXOPC1
     C                   EVAL      #LLXOPCN = 'LLLXOPC1'
     C                   EXSR      SROPC
      *
     C                   EVAL      #LLXPTAF = LLLXPTA1
     C                   EVAL      #LLXPTAN = 'LLLXPTA1'
     C                   EXSR      SRPTA
      *
     C                   EVAL      #LLXDCIF = LLLXDCI1
     C                   EVAL      #LLXDCIN = 'LLLXDCI1'
     C                   EXSR      SRDCI
      *
     C                   EVAL      #LLXCOCF = LLLXCOC1
     C                   EVAL      #LLXCOCN = 'LLLXCOC1'
     C                   EXSR      SRCOC
      *
     C                   EVAL      #LLXIDCF = LLLXIDC1
     C                   EVAL      #LLXIDEF = LLLXIDE1
     C                   EVAL      #LLXIDCN = 'LLLXIDC1'
     C                   EVAL      #LLXIDEN = 'LLLXIDE1'
     C                   EXSR      SRIDCE
      *
     C                   ENDIF
      *
     C                   IF        LLLXOPC2 <> *BLANKS
     C                             OR LLLXCOC2 <> *BLANKS
     C                             OR LLLXIDC2 <> *BLANKS
     C                             OR LLLXIDE2 <> *BLANKS
     C                             OR LLLXPTA2 <> *BLANKS
     C                             OR LLLXDCI2 <> *BLANKS
      *
     C                   EVAL      #LLXOPCF = LLLXOPC2
     C                   EVAL      #LLXOPCN = 'LLLXOPC2'
     C                   EXSR      SROPC
      *
     C                   EVAL      #LLXPTAF = LLLXPTA2
     C                   EVAL      #LLXPTAN = 'LLLXPTA2'
     C                   EXSR      SRPTA
      *
     C                   EVAL      #LLXDCIF = LLLXDCI2
     C                   EVAL      #LLXDCIN = 'LLLXDCI2'
     C                   EXSR      SRDCI
      *
     C                   EVAL      #LLXCOCF = LLLXCOC2
     C                   EVAL      #LLXCOCN = 'LLLXCOC2'
     C                   EXSR      SRCOC
      *
     C                   EVAL      #LLXIDCF = LLLXIDC2
     C                   EVAL      #LLXIDEF = LLLXIDE2
     C                   EVAL      #LLXIDCN = 'LLLXIDC2'
     C                   EVAL      #LLXIDEN = 'LLLXIDE2'
     C                   EXSR      SRIDCE
      *
     C                   ENDIF
      *
     C                   IF        LLLXOPC3 <> *BLANKS
     C                             OR LLLXCOC3 <> *BLANKS
     C                             OR LLLXIDC3 <> *BLANKS
     C                             OR LLLXIDE3 <> *BLANKS
     C                             OR LLLXPTA3 <> *BLANKS
     C                             OR LLLXDCI3 <> *BLANKS
      *
     C                   EVAL      #LLXOPCF = LLLXOPC3
     C                   EVAL      #LLXOPCN = 'LLLXOPC3'
     C                   EXSR      SROPC
      *
     C                   EVAL      #LLXPTAF = LLLXPTA3
     C                   EVAL      #LLXPTAN = 'LLLXPTA3'
     C                   EXSR      SRPTA
      *
     C                   EVAL      #LLXDCIF = LLLXDCI3
     C                   EVAL      #LLXDCIN = 'LLLXDCI3'
     C                   EXSR      SRDCI
      *
     C                   EVAL      #LLXCOCF = LLLXCOC3
     C                   EVAL      #LLXCOCN = 'LLLXCOC3'
     C                   EXSR      SRCOC
      *
     C                   EVAL      #LLXIDCF = LLLXIDC3
     C                   EVAL      #LLXIDEF = LLLXIDE3
     C                   EVAL      #LLXIDCN = 'LLLXIDC3'
     C                   EVAL      #LLXIDEN = 'LLLXIDE3'
     C                   EXSR      SRIDCE
      *
     C                   ENDIF
      *
      ** Save screen fields
      *
     C                   EVAL      SVOPCF = #LLXOPCF
     C                   EVAL      SVPTAF = #LLXPTAF
     C                   EVAL      SVDCIF = #LLXDCIF
     C                   EVAL      SVCOCF = #LLXCOCF
     C                   EVAL      SVIDCF = #LLXIDCF
     C                   EVAL      SVIDEF = #LLXIDEF
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
 
     C                   EVAL      ReturnCode = *BLANKS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROPC - Routine to validate JEOPC1, JEOPC2, JEOPC3           *
      *                                                               *
      *****************************************************************
     C     SROPC         BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVJEOPC2'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    #LLXOPCF
     C                   PARM                    #1CUST
     C                   PARM                    #1CYCD
     C                   PARM      *ZEROS        @CLIM
     C                   PARM      *ZEROS        @ILIM
      *
     C                   IF        MSG1 <> *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = #LLXOPCN
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   IF        #LLXOPCN = 'LLLXOPC1'
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXOPC1
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
     C                   IF        #LLXOPCN = 'LLLXOPC2'
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXOPC2
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
     C                   IF        #LLXOPCN = 'LLLXOPC3'
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXOPC3
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPTA - Routine to validate JEPTA1, JEPTA2, JEPTA3           *
      *                                                               *
      *****************************************************************
     C     SRPTA         BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVJEPTA2'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    #LLXPTAF
     C                   PARM                    #LLXOPCF
     C                   PARM                    #1CYCD
     C                   PARM                    #DFMPA
     C                   PARM      *ZEROS        WPTAF
      *
     C                   IF        MSG1 <> *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = #LLXPTAN
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   IF        #LLXPTAN = 'LLLXPTA1'
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXPTA1
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
     C                   IF        #LLXPTAN = 'LLLXPTA2'
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXPTA2
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
     C                   IF        #LLXPTAN = 'LLLXPTA3'
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXPTA3
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDCI - Routine to validate JEDCI1, JEDCI2, JEDCI3           *
      *                                                               *
      *****************************************************************
      *
     C     SRDCI         BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVJEDCI2'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    #LLXDCIF
     C                   PARM                    #LLXOPCF
     C                   PARM                    #1DCIN
      *
     C                   IF        MSG1 <> *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = #LLXDCIN
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   IF        #LLXDCIN = 'LLLXDCI1'
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXDCI1
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
     C                   IF        #LLXDCIN = 'LLLXDCI2'
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXDCI2
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
     C                   IF        #LLXDCIN = 'LLLXDCI3'
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXDCI3
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCOC - Routine to validate JECOC1, JECOC2, JECOC3           *
      *                                                               *
      *****************************************************************
      *
     C     SRCOC         BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVJECOC2'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    #LLXCOCF
     C                   PARM                    #LLXOPCF
     C                   PARM                    WPTAF
     C                   PARM                    @CLIM
      *
     C                   IF        MSG1 <> *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = #LLXCOCN
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   IF        #LLXCOCN = 'LLLXCOC1'
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXCOC1
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
     C                   IF        #LLXCOCN = 'LLLXCOC2'
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXCOC2
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
     C                   IF        #LLXCOCN = 'LLLXCOC3'
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXCOC3
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIDCE - Routine to validate JEIDC1, JEIDC2, JEIDC3, JEIDE1  *
      *           JEIDE2, JEIDE3                                      *
      *                                                               *
      *****************************************************************
      *
     C     SRIDCE        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVJEIDC2'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    WMSGID1
     C                   PARM                    #LLXIDCF
     C                   PARM                    #LLXIDEF
     C                   PARM                    #LLXOPCF
     C                   PARM                    #LLXCOCF
     C                   PARM                    #LLXDCIF
     C                   PARM                    #LLXPTAF
     C                   PARM                    #1CUST
     C                   PARM                    @ILIM
     C                   PARM                    WPTAF
     C                   PARM                    SVOPCF
     C                   PARM                    SVCOCF
     C                   PARM                    SVIDCF
     C                   PARM                    SVIDEF
     C                   PARM                    SVPTAF
     C                   PARM                    SVDCIF
      *
     C                   IF        WMSGID1 <> *BLANKS
     C                             OR MSG1 <> *BLANKS
      *
     C                   IF        WMSGID1 <> *BLANKS
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = #LLXIDCN
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = #LLXIDEN
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1
     C                   ENDIF
      *
     C                   IF        MSG1 <> *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = #LLXIDCN
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   IF        #LLXIDCN = 'LLLXIDC1'
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXIDC1
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
     C                   IF        #LLXIDCN = 'LLLXIDC2'
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXIDC2
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
     C                   IF        #LLXIDCN = 'LLLXIDC3'
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXIDC3
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        MSG2 <> *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = #LLXIDEN
     C                   EVAL      MsgIDArr(Idx) = MSG2
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   IF        #LLXIDEN = 'LLLXIDE1'
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXIDE1
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
     C                   IF        #LLXIDEN = 'LLLXIDE2'
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXIDE2
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
     C                   IF        #LLXIDEN = 'LLLXIDE3'
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXIDE3
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLIGN - Calls ZALIGN program.                               *
      *                                                               *
      *****************************************************************
     C     SRLIGN        BEGSR
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSETUP - Set up additional fields that are needed on the    *
      *            Valid file record.                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRSETUP       BEGSR
      *
      ** Other VLxxxx fields are set up during validation, such as the
      ** ones where the input & database formats are different,
      ** e.g. dates, amounts. This SR sets up the fields with the same
      ** (or compatible) attributes.
      *
     C                   EVAL      #LLXJEBTNB = #1BTNB
     C                   EVAL      #LLXJEBINB = #1BINB
     C                   EVAL      #LLXJECOC1 = LLLXCOC1
     C                   EVAL      #LLXJEIDC1 = LLLXIDC1
     C                   EVAL      #LLXJEIDE1 = LLLXIDE1
     C                   EVAL      #LLXJECOC2 = LLLXCOC2
     C                   EVAL      #LLXJEIDC2 = LLLXIDC2
     C                   EVAL      #LLXJEIDE2 = LLLXIDE2
     C                   EVAL      #LLXJECOC3 = LLLXCOC3
     C                   EVAL      #LLXJEIDC3 = LLLXIDC3
     C                   EVAL      #LLXJEIDE3 = LLLXIDE3
     C                   EVAL      #LLXJEDCI1 = LLLXDCI1
     C                   EVAL      #LLXJEDCI2 = LLLXDCI2
     C                   EVAL      #LLXJEDCI3 = LLLXDCI3
      *
     C                   MOVE      LLLXOPC1      #LLXJEOPC1
     C                   MOVE      LLLXOPC2      #LLXJEOPC2
     C                   MOVE      LLLXOPC3      #LLXJEOPC3
      *
     C                   EVAL      ZADEC = 2
     C                   EVAL      ZADIG = 13
     C                   MOVEL(P)  LLLXPTA1      ZFIELD
     C                   EXSR      SRLIGN
     C                   MOVE      ZFIELD        #LLXJEPTA1
      *
     C                   MOVEL(P)  LLLXPTA2      ZFIELD
     C                   EXSR      SRLIGN
     C                   MOVE      ZFIELD        #LLXJEPTA2
      *
     C                   MOVEL(P)  LLLXPTA3      ZFIELD
     C                   EXSR      SRLIGN
     C                   MOVE      ZFIELD        #LLXJEPTA3
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      ** Action Code
     C                   PARM                    ACTN
      ** Data from Customer
     C                   PARM                    PDATA
      ** New Cust Screen Form and Field OK Flags
     C                   PARM                    NwDlScnFmt
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
      ** Warning Array Index
     C                   PARM                    WIdx
      ** New Cust File Format
     C                   PARM                    NwDlFilFmt
      *
      ** Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'GLBPLX2VL'
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
