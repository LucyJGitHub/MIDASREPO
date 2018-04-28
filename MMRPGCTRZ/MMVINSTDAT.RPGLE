     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Initial Start Date')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Maintenance Module                           *
      *                                                               *
      *  MMVINSTDAT -  Midas MM Validate Initial Start Date           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG22992           Date 20Jan09               *
      *                 CER020  *CREATE    Date 19May08               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22992 - Misleading Error Message                          *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus                                          *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line include (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures. They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the
      ** size of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D IKISDT          S              5P 0
     D DDISDT          S              6A
     D DDVDAT          S              6A
     D DDCCY           S              3A
     D BJDFIN          S              1A
     D WInsDt          S              5P 0
     D WViDat          S              5P 0
     D PReturnCode     S             10A
     D PZErrCd         S              7A
     D PZDtFmt         S              1A
     D PZDate          S              6P 0
     D PZDayNo         S              5P 0
     D PCcy            S              3A
     D PZloc           S              3A
     D PZInd           S              1A
     D PDefISVal       S              6P 0
     D PDefISFlg       S              1A
     D WCompVal        S              6P 0
     D WVlDat          S              5P 0
     D PRtcd           S              7
     D POptn           S              7
     D PMsg            S                   LIKE(#MsgID)
     D PWMsgID         S                   LIKE(#MsgID)
     D PErrInsDat      S                   LIKE(ErrorFound)
     D PWrnInsDat      S                   LIKE(WarnFound)
     D Number          C                   '0123456789'                                     BUG22992
     D X               S              1  0                                                  BUG22992
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Reset Date Error Flag
      *
     C                   RESET                   PErrInsDat
     C                   RESET                   PWrnInsDat
      *
      ** Validat Final Maturity Date
      *
     C                   EXSR      SRVInStDt
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVInStDt - Validate Initial Start Date                      *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRVInStDt     BEGSR
      *
      * If Initial Start Date was entered, check if numeric                                 BUG22992
     C                   IF        DDISDT <> *BLANKS                                        BUG22992
     C     Number        CHECK     DDISDT:1      X                                          BUG22992
     C                   IF        %FOUND                                                   BUG22992
     C                   EVAL      PErrInsDat = 'Y'                                         BUG22992
     C                   EVAL      PMsg = 'MMM1078'                                         BUG22992
     C                   GOTO      ERROR                                                    BUG22992
     C                   ENDIF                                                              BUG22992
     C                   ENDIF                                                              BUG22992
                                                                                            BUG22992
      ** Default the Initial Start Date with the Value Date if blanks
      *
     C                   IF        DDISDT = *BLANKS
     C                   EVAL      DDISDT = DDVDAT
     C                   ENDIF
      *
      ** If the value input is not a valid date
      *
     C                   MOVEL     DDISDT        PZDate
     C                   EVAL      PZDtFmt = BJDFIN
     C                   EXSR      SRZDate1
      *
      ** If Invalid Date Entered
      *
     C                   IF        PZErrCd <> *BLANKS
      *
     C                   EVAL      PErrInsDat = 'Y'
     C                   EVAL      PMsg = 'MMM4101'
      *
     C                   ELSE
     C                   EVAL      WInsDt = PZDayNo
      *
     C                   ENDIF
      *
      ** Set up the value with which to compare
      *
     C                   IF        PDefIsFlg <> 'Y'
      *
     C                   MOVE      DDVDAT        WCompVal
     C                   ELSE
     C                   EVAL      WCompVal = PDefIsVal
      *
     C                   ENDIF
      *
     C                   EVAL      PZDate = WCompVal
     C                   EXSR      SRZDate1
     C                   EVAL      WVlDat = PZDayNo
      *
      ** If the date input is greater than the value permitted
      *
     C                   IF        WInsDt > WVlDat
      *
     C                   EVAL      PErrInsDat = 'Y'
      *
     C                   IF        PDefIsFlg <> 'Y'
      *
     C                   EVAL      PMsg = 'MMM4102'
     C                   ELSE
     C                   EVAL      PMsg = 'MMM4111'
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Initial Start date ought not to be a holiday
      *
     C                   CALLB     'ZCHKH'
     C                   PARM      WInsDt        PZDayNo
     C                   PARM      DDCCY         PCcy
     C                   PARM      *BLANKS       PZLoc
     C                   PARM      *BLANKS       PZInd
      *
     C                   IF        PZind = 'H'
      *
     C                   EVAL      PWrnInsDat = 'Y'
     C                   EVAL      PWMsgID = 'MMM4103'
      *
     C                   ENDIF
      *
      ** If an error was found, set the return code appropriately
      *
     C     ERROR         TAG                                                                BUG22992
     C                   IF        PErrInsDat = 'Y'
      *
     C                   EVAL      PReturnCode = 'Error'
     C                   ELSEIF    PWrnInsDat = 'Y'
     C                   EVAL      PReturnCode = 'Warning'
      *
     C                   ENDIF
      *
     C                   IF        PErrInsDat <> 'Y'
     C                   EVAL      IKISDT = WInsDt
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDate1: Routine to Convert Date to Day Number              *
      *                                                               *
      *  Called by: SRVInStDt                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRZDate1      BEGSR
      *
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       PZErrCd
     C                   PARM                    PZDate
     C                   PARM                    PZDtFmt
     C                   PARM                    PZDayNo
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Inputs
      *
      ** Return Code
      *
     C                   PARM      *BLANKS       PReturnCode
      *
      ** Error message Id
      *
     C                   PARM                    PMsg
      *
      ** Warning message Id
      *
     C                   PARM                    PWMsgID
      *
      ** Valid Initial start date
      *
     C                   PARM                    IKISDT
      *
      ** Value date
      *
     C                   PARM                    DDVDAT
      *
      ** Initial start date
      *
     C                   PARM                    DDISDT
      *
      ** Currency
      *
     C                   PARM                    DDCCY
      *
      ** Date Format
      *
     C                   PARM                    BJDFIN
      *
      ** Outputs
      *
      ** Flag for Initial start date
      *
     C                   PARM                    PDefISFlg
      *
      ** Valid Initial start date
      *
     C                   PARM                    PDefISVal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
