     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Original Deal Number & dft date')    *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Maintenance Module                           *
      *                                                               *
      *  MMVORGDLNO -  Midas MM Validate Original Deal Number and     *
      *                default dates                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23437           Date 20Mar09               *
      *                 CER020  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23437 - Correct validation of Initial start date and      *
      *             Final maturity date.                              *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to Midas   *
      *           Plus                                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRVOrgDlNo - Validate Original Deal Number                   *
      *  SRZDate1: Routine to Convert Date to Day Number              *
      *  SRZDate10 : Routine to Convert Date to Day Number            *
      *  *INZSR - Program Initialisation routine                      *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas MM Deals File
     FMMDEALLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(MMDELDP0)
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
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
     D DSDATE          DS
     D  Wyy                    1      4  0
     D  Wmm                    5      6  0
     D  Wdd                    7      8  0
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
     D DDDADN          S              6A
     D DDMDAT          S              6A
     D DDFMDT          S              6A
     D DDVDAT          S              6A
     D DDISDT          S              6A
     D DDORDN          S              6A
     D BJDFIN          S              1A
      *
      ** Work Variables
     D WRvDat          S              5P 0
     D WRmDat          S              5P 0
     D WMtDat          S              5P 0
      *
     D KDlNo           S              6P 0
      *
      ** Parameters
     D PError          S                   LIKE(ErrorFound)
     D PMsg            S                   LIKE(#MsgID)
     D PReturnCode     S             10A
     D PZErrCd         S              7A
     D PZDtFmt         S              1A
     D PZDate          S              6P 0
     D PZDayNo         S              5P 0
     D PZaDate         S              7A
     D PZDayIn         S              8S 0
     D PZDayOut        S              5P 0
     D PDefISFlg       S              1A
     D PDefFMFlg       S              1A
     D PDefISVal       S              6P 0
     D PDefFMVal       S              6P 0
     D PRtcd           S              7
     D POptn           S              7
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
      *****************************************************************
      * MAIN PROCESSING
      *****************************************************************
      *
      ** Reset Date Error Flag
      *
     C                   RESET                   PError
      *
      ** Validat Original Deal Number
      *
     C                   EXSR      SRVOrgDlNo
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVOrgDlNo - Validate Original Deal Number                   *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRVOrgDlNo    BEGSR
      *
      ** Original deal number in case of Rollover
      *
     C                   IF        DDDADN <> *BLANKS
      *
     C                   MOVEL     DDDADN        KDlNo
     C     KDlNo         CHAIN     MMDEALLL
      *
     C                   IF        %FOUND(MMDEALLL)
      *
     C                   IF        HKORDN <> *BLANKS
      *
     C                   EVAL      DDORDN = HKORDN
     C                   ELSE
     C                   EVAL      DDORDN = DDDADN
      *
     C                   ENDIF
      *
     C**********         ENDIF                                                              BUG23437
      *
     C**********         ENDIF                                                              BUG23437
      *
      ** If Original Deal Number is NON BLANKS
      *
     C                   IF        DDORDN <> *BLANKS
      *
     C                   EVAL      Wdd = HKVDDD
     C                   EVAL      Wmm = HKVDMM
     C                   EVAL      Wyy = HKVDYY
     C                   EVAL      PZDayIn = %DEC(DSDATE:8:0)
     C                   EXSR      SRZDate10
     C                   EVAL      WRvDat = PZDayOut
     C                   EVAL      Wdd = HKMDDD
     C                   EVAL      Wmm = HKMDMM
     C                   EVAL      Wyy = HKMDYY
     C                   EVAL      PZDayIn = %DEC(DSDATE:8:0)
     C                   EXSR      SRZDate10
     C                   EVAL      WRmDat = PZDayOut
      *
      ** Set Initial Start Date and Final Maturity Date values from
      ** rolled over deal, if different
      *
     C                   IF        HKISDT <> WRvDat OR
     C                             HKFMDT <> WRmDat
      *
     C                   CALL      'ZDATE2'
     C                   PARM      HKISDT        PZDayNo
     C                   PARM                    PZDtFmt
     C                   PARM      *ZEROS        PZDate
     C                   PARM      *BLANKS       PZaDate
      *
     C                   IF        DDISDT = *BLANKS
     C                   MOVEL     PZDate        DDISDT
     C                   ENDIF
      *
      ** Set up the default flag and value for comparison
      *
     C                   EVAL      PDefISFlg = 'Y'
     C                   MOVEL     PZDate        PDefISVal
      *
      ** Convert Maturity Date into Day Number
      *
     C                   MOVEL     DDMDAT        PZDate
     C                   EXSR      SRZDate1
     C                   EVAL      WMtDat = PZDayNo
      *
     C                   IF         HKFMDT > WMtDat
      *
     C                   CALL      'ZDATE2'
     C                   PARM      HKFMDT        PZDayNo
     C                   PARM                    PZDtFmt
     C                   PARM      *ZEROS        PZDate
     C                   PARM      *BLANKS       PZaDate
      *
     C                   IF        DDFMDT = *BLANKS
     C                   EVAL      DDFMDT = %CHAR(PZDate)
     C                   ENDIF
      *
     C                   EVAL      PDefFMFlg = 'Y'
     C                   EVAL      PDefFMVal = PZDate
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF                                                              BUG23437
      *                                                                                     BUG23437
     C                   ENDIF                                                              BUG23437
      *                                                                                     BUG23437
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
      *  SRZDate10 : Routine to Convert Date to Day Number            *
      *                                                               *
      *  Called by: SRVInStDt                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRZDate10     BEGSR
      *
     C                   CALLB     'ZDATE10'
     C                   PARM                    PZDayIn
     C                   PARM                    PZDayOut
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
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Inputs
      *
      ** Return Code
      *
     C                   PARM                    PReturnCode
      *
      ** Error message Id
      *
     C                   PARM                    PMsg
      *
      ** Value Date
      *
     C                   PARM                    DDVDAT
      *
      ** Maturity Date
      *
     C                   PARM                    DDMDAT
      *
      ** Rollover Deal Number
      *
     C                   PARM                    DDDADN
      *
      ** Initial Start Date
      *
     C                   PARM                    DDISDT
      *
      ** Final Maturity Date
      *
     C                   PARM                    DDFMDT
      *
      ** Original Deal Number
      *
     C                   PARM                    DDORDN
      *
      ** Date Format
      *
     C                   PARM                    BJDFIN
      *
      ** Outputs
      *
      ** Initial Start Date Flag
      *
     C                   PARM                    PDefISFlg
      *
      ** Valid Initial Start Date
      *
     C                   PARM                    PDefISVal
      *
      ** Final Mauturity Date Flag
      *
     C                   PARM                    PDefFMFlg
      *
      ** Valid Final Maturity Date
      *
     C                   PARM                    PDefFMVal
      *
     C                   EVAL      PZDtFmt = BJDFIN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
