     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Final Maturity Date')                *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Maintenance Module                           *
      *                                                               *
      *  MMVFNMTDAT - Midas MM Validate Final Maturity Date           *
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
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to Midas   *
      *           Plus                                                *
      *                                                               *
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
     D PReturnCode     S             10A
     D IKFMDT          S              5P 0
     D DDMDAT          S              6A
     D DDFMDT          S              6A
     D DDTYPE          S              2A
     D DDCCY           S              3A
     D BJDFIN          S              1A
     D WMtDat          S              5P 0
     D WFmtDt          S              5P 0
     D PZErrCd         S              7A
     D PZDtFmt         S              1A
     D PZDate          S              6P 0
     D PZDayNo         S              5P 0
     D PCcy            S              3A
     D PZloc           S              3A
     D PZInd           S              1A
     D PDefFMVal       S              6P 0
     D PDefFMFlg       S              1A
     D WCompVal        S              6P 0
     D PRtcd           S              7
     D POptn           S              7
     D PMsg            S                   LIKE(#MsgID)
     D PWMsgID         S                   LIKE(#MsgID)
     D PErrFmtDat      S                   LIKE(ErrorFound)
     D PWrnFmtDat      S                   LIKE(WarnFound)
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
     C                   RESET                   PErrFmtDat
     C                   RESET                   PWrnFmtDat
      *
      ** Validat Final Maturity Date
      *
     C                   EXSR      SRVFnMtDt
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVFnMtDt - Validate Final Maturity Date                     *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRVFnMtDt     BEGSR
      *
      ** Default the Final Maturity Date with the Maturity Date, if
      ** Blanks
      *
     C                   IF        DDMDAT <> *BLANKS AND
     C                             DDFMDT = *BLANKS
     C                   EVAL      DDFMDT = DDMDAT
     C                   ENDIF
      *
      ** If call Deals
      *
     C                   IF         DDTYPE = 'CD' OR
     C                              DDTYPE = 'CL' OR
     C                              DDTYPE = 'DL'
      *
      ** If Maturity date is blank then Final Maturity Date must also
      ** be blanks
      *
     C                   IF        DDMDAT = *BLANKS AND
     C                             DDFMDT <> *BLANKS
      *
     C                   EVAL      PErrFmtDat = 'Y'
     C                   EVAL      PMsg = 'MMM4104'
      *
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Term Deal, Final Maturity Date should not be blanks
      *
     C                   IF        DDFMDT = *BLANKS
      *
     C                   EVAL      PErrFmtDat = 'Y'
     C                   EVAL      PMsg = 'MMM4105'
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Final maturity date not blank
      *
     C                   IF        DDFMDT <> *BLANKS
      *
      ** Test if date is numeric                                                            BUG22992
      *
     C     Number        CHECK     DDFMDT:1      X                                          BUG22992
     C                   IF        %FOUND                                                   BUG22992
     C                   EVAL      PErrFmtDat = 'Y'                                         BUG22992
     C                   EVAL      PMsg = 'MMM1079'                                         BUG22992
     C                   GOTO      ERROR                                                    BUG22992
     C                   ENDIF                                                              BUG22992
                                                                                            BUG22992
      ** Check whether Final Maturity Date is a valid date
      *
     C                   MOVE      DDFMDT        PZDate
     C                   EVAL      PZDtFmt = BJDFIN
     C                   EXSR      SRZDate1
      *
     C                   IF         PZErrCd <> *BLANKS
      *
     C                   EVAL      PErrFmtDat = 'Y'
     C                   EVAL      PMsg = 'MMM4106'
      *
     C                   ELSE
     C                   EVAL      WFmtDt = PZDayNo
      *
     C                   ENDIF
      *
      ** Set up the value with which to compare
      *
     C                   IF        PDefFMFlg <> 'Y'
      *
     C                   MOVE      DDMDAT        WCompVal
     C                   ELSE
     C                   EVAL      WCompVal = PDefFMVal
      *
     C                   ENDIF
      *
     C                   EVAL      PZDate = WCompVal
     C                   EXSR      SRZDate1
     C                   EVAL      WMtDat = PZDayNo
      *
      ** Final Maturity Date must not be lower than the value permitted
      *
     C                   IF        WFmtDt < WMtDat
     C                   EVAL      PErrFmtDat = 'Y'
      *
     C                   IF        PDefFMFlg <> 'Y'
      *
     C                   EVAL      PMsg = 'MMM4107'
     C                   ELSE
     C                   EVAL      PMsg = 'MMM4112'
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Final Maturity Date should not to be a holiday
      *
     C                   CALLB     'ZCHKH'
     C                   PARM      WFmtDt        PZDayNo
     C                   PARM      DDCCY         PCcy
     C                   PARM      *BLANKS       PZLoc
     C                   PARM      *BLANKS       PZInd
      *
     C                   IF        PZind = 'H'
      *
     C                   EVAL      PWrnFmtDat = 'Y'
     C                   EVAL      PWMsgID = 'MMM4108'
      *
     C                   ENDIF
      *
     C                   ELSE
      *
      ** if Final maturity date blank
      *
     C                   EVAL      WFmtDt = *ZEROS
      *
     C                   ENDIF
      *
      ** If an error was found
      *
     C     ERROR         TAG                                                                BUG22992
     C                   IF        PErrFmtDat = 'Y'
      *
     C                   EVAL      PReturnCode = 'Error'
     C                   ELSEIF    PWrnFmtDat = 'Y'
     C                   EVAL      PReturnCode = 'Warning'
      *
     C                   ENDIF
      *
     C                   IF        PErrFmtDat <> 'Y'
     C                   EVAL      IKFMDT = WFmtDt
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDate1: Routine to Convert Date to Day Number              *
      *                                                               *
      *  Called by: SRVFnMtDt                                         *
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
      ** Valid Final Maturity Date
      *
     C                   PARM                    IKFMDT
      *
      ** Maturity Date
      *
     C                   PARM                    DDMDAT
      *
      ** Final Maturity Date
      *
     C                   PARM                    DDFMDT
      *
      ** Type
      *
     C                   PARM                    DDTYPE
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
      ** Flag for Final Maturity Date
      *
     C                   PARM                    PDefFMFlg
      *
      ** Valid Final Maturity Date
      *
     C                   PARM                    PDefFMVal
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
