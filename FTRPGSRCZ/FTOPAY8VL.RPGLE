     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT OPAY - Validation')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTOPAY8VL - FT Outgoing Payments Validation                  *
      *                                                               *
      *  Function: This Function validates FT Extended Outgoing       *
      *            Payments fields for input into the Midas database. *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CFT120             Date 28Sep12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CFT032             Date 11Sep06               *
      *                 CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CER001 - LUX Upgrade to MidasPlus                            *
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
 
      ** Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** DS for Access progrmas
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for General Ledger Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** New Outgoing payments in File Format
     D NwDlFilFmt    E DS                  EXTNAME(FTVOPLX1PD)
 
      ** New Outgoing payments in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(FTOPRXPD)
 
      ** Error fields indicators
     D OkFlags       E DS                  EXTNAME(FTEOPLX1PD)
 
      ** Fields used in module FTOPLXVXL
     D Valfields     E DS                  EXTNAME(OTPAY)
 
      ** Data passed from caller program
     D PData           DS
     D  #1FLD1                 1      6  0
     D  PREF1                  7     21
     D  #1FOTR                22     41
     D  #1TMST                42     67Z
     D  #1ORCT                68     68
     D  #1ORBK                69     80
     D  #1ORC1                81    115
     D  #1SMCY               116    118
     D  #1ORBT               119    119
     D  #1SMAM               120    132P 0
     D  #1PCCY               133    135
     D  #1SNCT               136    136
     D  #1SNCO               137    146
     D  #1DSTT               147    147
     D  #1DST1               148    182
 
      **
      **   Declared variables
      **   ==================
      **
 
      ** "Standard" *entry parameters
 
     D ACTN            S              1
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** "Extra" *entry parameters
 
      ** Define parameters for call module
     D WWCUTY          S              2A
     D @CLIM           S             15P 0
     D @ILIM           S             15P 0
 
     D ZCCYT           s              3
     D ZRATET          s             13P 8
     D ZMDINT          s              1
     D ZCDPT           s              1P 0
 
      ** Define parameters for call pgm
     D @CURR           S              3A
     D @TYPE           S              1A
     D @LINE           S             35A
     D @OPCL           S              1  0
     D @ACCD           S             10A
     D @CUST           S              6A
     D @FOUND          S              1A
 
     D @@CCY           S              3A
     D @@RT1T          S              1A
     D @@RT1           S             18A
     D @@RT2T          S              1A
     D @@RT2           S             35A
     D @@RET           S              1a
     D @@SETT          S              1A
     D @@BOAF          S              1A
 
     D  @CCY           S              3A
 
     D PSMAM           S             13P 0
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
 
 
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      **  Initial processing is performed automatically: the *INZSR is
      **  executed at program activation.
      *
     C                   EXSR      SRORTY
      *
     C                   EXSR      SRBETY
      *
      **  Operation code should be validated if Ordering type and
      **  Beneficiary type are OK
      *
     C                   IF        OK#LLXORTY <> 'N' AND
     C                             OK#LLXBETY <> 'N'
     C                   EXSR      SROPCO
      *
      **  Country code, Identification Code and Identification number
      **  are validated if Operation code is OK
      *
     C                   IF        OK#LLXOPCO <> 'N'
     C                   EXSR      SRCOCO
      *
     C                   EXSR      SRIDCN
      *
     C                   ENDIF
     C                   ENDIF
      *
      **  If no errors set up outstanding fields for valid file
      *
     C                   IF        Idx = 0
     C                   EXSR      SRSETUP
     C                   ENDIF
      *
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *                                                               *
      *****************************************************************
      *
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
      /EJECT
      *****************************************************************
      * SRORTY - Routine to validate OPORTY
      *****************************************************************
      *
     C     SRORTY        BEGSR
      *
      **  Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'FTVOPORTY2'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    LLLXORTY
     C                   PARM                    PREF1
     C                   PARM                    WWCUTY
      *
     C                   IF        MSG1 <> *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'LLLXORTY'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      **  Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXORTY
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRBETY - Routine to validate OPBETY
      *****************************************************************
      *
     C     SRBETY        BEGSR
      *
      **  Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'FTVOPBETY2'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    LLLXBETY
      *
     C                   IF        MSG1 <> *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'LLLXBETY'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      **  Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXBETY
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SROPCO - Routine to validate OPOPCO
      *****************************************************************
      *
     C     SROPCO        BEGSR
      *
      **  Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   Z-ADD     #1SMAM        PSMAM
     C                   CALLB     'FTVOPOPCO2'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    LLLXOPCO
     C                   PARM                    LLLXORTY
     C                   PARM                    LLLXBETY
     C                   PARM                    #1SMCY
     C                   PARM                    PSMAM
     C                   PARM                    @@SETT
     C                   PARM                    ZCCYT
     C                   PARM                    ZRATET
     C                   PARM                    ZMDINT
     C                   PARM                    ZCDPT
     C                   PARM                    @CUST
     C                   PARM                    @@BOAF
     C                   PARM      *ZEROS        @CLIM
     C                   PARM      *ZEROS        @ILIM
      *
     C                   IF        MSG1 <> *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'LLLXOPCO'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      **  Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXOPCO
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRCOCO - Routine to validate OPCOCO
      *****************************************************************
      *
     C     SRCOCO        BEGSR
      *
      **  Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   Z-ADD     #1SMAM        PSMAM
     C                   CALLB     'FTVOPCOCO2'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    LLLXCOCO
     C                   PARM                    LLLXOPCO
     C                   PARM                    PSMAM
     C                   PARM                    @CLIM
      *
     C                   IF        MSG1 <> *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'LLLXCOCO'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *
      **  Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXCOCO
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRIDCN - Routine to validate OPIDCO, OPIDCN
      *****************************************************************
      *
     C     SRIDCN        BEGSR
      *
      **  Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   Z-ADD     #1SMAM        PSMAM
     C                   CALLB     'FTVOPIDCN2'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    LLLXIDCO
     C                   PARM                    LLLXIDEN
     C                   PARM                    LLLXOPCO
     C                   PARM                    PSMAM
     C                   PARM                    @ILIM
     C                   PARM                    @CUST
      *
     C                   IF        MSG1 <> *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'LLLXIDCO'
     C                   EVAL      MsgIDArr(Idx) = MSG1
      *
      **  Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXIDCO
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
     C                   IF        MSG2 <> *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'LLLXIDEN'
     C                   EVAL      MsgIDArr(Idx) = MSG2
      *
      **  Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OK#LLXIDEN
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSETUP - Set up additional fields that are needed on the     *
      *           Valid file record.                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRSETUP       BEGSR
      *
      **  where the input & database formats are different, e.g. dates,
      **  amounts. Sets up the fields with the same (or compatible)
      **  attributes
      *
     C                   EVAL      #LLXOPPREF  =  PREF1
     C                   EVAL      #LLXOPORTY  =  LLLXORTY
     C                   EVAL      #LLXOPBETY  =  LLLXBETY
     C                   EVAL      #LLXOPOPCO  =  LLLXOPCO
     C                   EVAL      #LLXOPCOCO  =  LLLXCOCO
     C                   EVAL      #LLXOPIDCO  =  LLLXIDCO
     C                   EVAL      #LLXOPIDEN  =  LLLXIDEN
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      **  Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    ACTN
     C                   PARM                    PData
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
     C                   PARM                    WWCUTY
     C                   PARM                    @CUST
     C                   PARM                    Valfields
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'FTOPAY8VL'
     C                   OUT       LDA
      *
      **  Find IBLC settlement type
      *
     C                   EVAL      @@CCY  = #1PCCY
     C                   EVAL      @@RT1T = #1SNCT
     C                   EVAL      @@RT1  = #1SNCO
     C                   EVAL      @@RT2T = #1DSTT
     C                   EVAL      @@RT2  = #1DST1
      *
     C                   CALL      'IL0420'
     C                   PARM                    @@CCY
     C                   PARM                    @@RT1T
     C                   PARM                    @@RT1
     C                   PARM                    @@RT2T
     C                   PARM                    @@RT2
     C                   PARM      *BLANKS       @@SETT
     C                   PARM      *BLANKS       @@BOAF
      *
     C                   ENDSR
      *
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
