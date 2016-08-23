     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('RE Stopped Cheques Screen Validation')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE004245 - RE Stopped Cheques Screen Validation Program      *
      *                                                               *
      *  Function:  This program will provide additional validation   *
      *             for Stopped Cheques when feature CRE019 (Cheque   *
      *             Book Processing) is switched on. Upon return, it  *
      *             will pass corresponding return code and warning   *
      *             messages.                                         *
      *                                                               *
      *  Called By: REC004245 - RE Stopped Cheques Screen Validation  *
      *                         Program                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. AR1096685          Date 22Mar13               *
      *                 AR895153           Date 31Jan12               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSC041  *CREATE    Date 26Nov09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  AR1096685 - Replace message IDs with event codes             *
      *  AR895153 - STOPPED CHEQUE warning message is displaying      *
      *             only letter W                                     *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSC041 - 4-Eyes Checking Gaps (Applied BUG23951)             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    65         Cheque has not been issued                      *
      *    66         Cheque has already been presented               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SrResetErrs   - Reset the errors                              *
      * SrAcctDetails - Get the account details                       *
      * SrStopCheque  - Verify if Stopped Cheque is already in place  *
      * SrSrChqIssPre - Verify if a Cheque Number is already issued   *
      *                  or presented to the account holder           *
      * SrChequeBook  - Validate a Cheque Book                        *
      * SrEditMessage - Edit the message for output                   *
      * SrAlignCheque - Right-align the Cheque Number                 *
      * *PSSR     - Error processing                                  *
      * *INZSR    - Program initialisation                            *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Cheque Book Details
     FCHQBKPD   IF   E           K DISK
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** error arrays, including the named constant giving the size of
      ** the arrays.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Account details
     D ACCNTB        E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(#)
 
      ** Array of Fields in error
     D FldNameArr      S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDArr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data
     D MsgDtaArr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Array of Fields with warnings
     D WFldNamArr      S             10A   DIM(XArrayMax)
 
      ** Array of warning message IDs
     D WMsgIDArr       S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of warning message data
     D WMsgDtaArr      S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** File information DS for parameter PACNT
     D PACNT           DS            34
     D  WBRCA                  1      3
     D  WCUST                  4      9
     D  WRETL                  1     10                                                     BUG23951
     D  WCURR                 10     12
     D  WACNO                 13     22
     D  WSEQN                 23     24
     D  WZZZZ                 25     34
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PREFN           S              3A
     D PFCHQ           S              8A
     D PTCHQ           S              8A
     D PRTCD           S              1A
     D PERMSG          S          32000A   VARYING
 
      ** Access objects
     D PRetCode        S              7A
     D POption         S              7A
     D PACID           S             10
     D PCYCD           S              3A
     D PACCD           S             10
     D PRETL           S             10                                                     BUG23951
     D PACSN           S              2
     D PBRCA           S              3A
     D PTYPE           S              7
     D PNOSN           S              2
     D PCHQAM          S             13S 0
     D PCHQNO          S              8S 0
     D PRETAC          S             10S 0
     D PCNUM           S              6
 
      ** ZALIGN Parameters
     D PZAlignOk       S              1A   INZ(*BLANKS)
     D PZField         S             16A   INZ(*BLANKS)
     D PZADec          S              1P 0 INZ(*ZEROS)
     D PZAdig          S              2P 0 INZ(*ZEROS)
 
      ** KCHQ1 Key List fields
     D WRETN           S             10S 0
     D WCHQ            S              8S 0
 
      ** Work variables
     D @RUN            S              1    INZ(*BLANKS)
     D WPTCHQ          S              8  0
     D WSCQN           S              8S 0
     D WOFSET          S              8S 0
     D WI              S              2S 0
     D WBITN           S              1S 0
     D WAR             S              1A   DIM(20)
     D WErrExist       S              1N   INZ(*OFF)
     D MsgArrOUT       S           9999
     D WErrIdx         S              3S 0 INZ(*ZEROS)
     D APIName         S             20    INZ(*BLANKS)                                     AR895153
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     ** +--- Start of Main processing --------------------------------+
     ** ¦                                                             ¦
     ** ¦ Initial processing is performed automatically: the *INZSR   ¦
     ** ¦ is executed at program activation.                          ¦
     ** ¦                                                             ¦
     ** +-------------------------------------------------------------+
 
     C                   EXSR      SrResetErrs
 
     C                   EXSR      SrAcctDetails
 
     C                   EXSR      SrStopCheque
 
     C                   EXSR      SrChqIssPre
 
     C                   EXSR      SrEditMessage
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrResetErrs - Subroutine to reset the errors                  *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrResetErrs   BEGSR
 
     C                   EVAL      WErrExist = *OFF
     C                   EVAL      PRTCD = '1'
     C                   EVAL      WErrIdx = 0
 
     C                   EVAL      FldNameArr = *BLANKS
     C                   EVAL      MsgIDArr   = *BLANKS
     C                   EVAL      MsgDtaArr  = *BLANKS
     C                   EVAL      WFldNamArr = *BLANKS
     C                   EVAL      WMsgIDArr  = *BLANKS
     C                   EVAL      WMsgDtaArr = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAcctDetails - Subroutine to get the account details         *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: AOACCTV0                                               *
      *                                                               *
      *****************************************************************
     C     SrAcctDetails BEGSR
 
      *                                                                                     BUG23951
      ** Get account details using Retail Account Number                                    BUG23951
      *                                                                                     BUG23951
     C                   CALL      'AOACCTR0'                                               BUG23951
     C                   PARM      *BLANKS       PRetCode                                   BUG23951
     C                   PARM      '*KEY'        POption                                    BUG23951
     C                   PARM      WRETL         PRETL                                      BUG23951
     C                   PARM      *BLANKS       PCNUM                                      BUG23951
     C                   PARM      *BLANKS       PCYCD                                      BUG23951
     C                   PARM      *BLANKS       PACCD                                      BUG23951
     C                   PARM      *BLANKS       PACSN                                      BUG23951
     C                   PARM      *BLANKS       PBRCA                                      BUG23951
     C     ACCNTB        PARM      ACCNTB        DSSDY                                      BUG23951
                                                                                            BUG23951
      *                                                                                     BUG23951
      ** If not found, then get account details using full account                          BUG23951
      *                                                                                     BUG23951
     C                   IF        PRetCode <> *BLANKS                                      BUG23951
     C                   CALL      'AOACCTV0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      WCUST         PACID
     C                   PARM      WCURR         PCYCD
     C                   PARM      WACNO         PACCD
     C                   PARM      WSEQN         PACSN
     C                   PARM      WBRCA         PBRCA
     C                   PARM                    PTYPE
     C                   PARM                    PNOSN
     C     ACCNTB        PARM      ACCNTB        DSSDY
 
     C                   IF        PRetCode <> *BLANKS
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF                                                              BUG23951
                                                                                            BUG23951
     C                   EVAL      WRETN = #ACNO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrStopCheque - Subroutine to verify if Stopped Cheque is      *
      *                already in place                               *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: AOSTOPV0                                               *
      *                                                               *
      *****************************************************************
     C     SrStopCheque  BEGSR
 
     C                   IF        (PFCHQ <> *BLANKS) AND
     C                             (PTCHQ = *BLANKS)
 
     C                   EVAL      PZField = *BLANKS
     C                   MOVE      PFCHQ         PZField
     C                   EXSR      SrAlignCheque
     C                   MOVE      PZField       PCHQNO
      *
     C                   CALL      'AOSTOPV0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      *ZEROS        PCHQAM
     C                   PARM                    PCHQNO
     C                   PARM      WRETN         PRETAC
     C                   PARM                    PCNUM
     C                   PARM                    PCYCD
     C                   PARM                    PACCD
     C                   PARM                    PACSN
     C                   PARM                    PBRCA
 
     C                   IF        PRetCode = '*STOP  '
     C                   EVAL      WErrIdx = wErrIdx + 1
     C                   EVAL      WFldNamArr(wErrIdx) = 'FRCHEQUENO'
     C**********         EVAL      WMsgIDArr(wErrIdx) = 'USR1256'                          AR1096685
     C                   EVAL      WMsgIDArr(wErrIdx) = '5045911'                          AR1096685
     C                   EVAL      MsgFArray(wErrIdx) = 'GBRTSMSGF'
     C                   EVAL      WErrExist = *ON
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
      *
      ** If a range is given, loop from 'From Cheque Number' to
      ** 'To Cheque Number'
      *
     C                   IF        (PFCHQ <> *BLANKS) AND
     C                             (PTCHQ <> *BLANKS) AND
     C                             (PTCHQ > PFCHQ)
     C                   EVAL      PZField = *BLANKS
     C                   MOVE      PFCHQ         PZField
     C                   EXSR      SrAlignCheque
     C                   MOVE      PZField       WCHQ
      *
     C                   EVAL      PZField = *BLANKS
     C                   MOVE      PTCHQ         PZField
     C                   EXSR      SrAlignCheque
     C                   MOVE      PZField       WPTCHQ
      *
     C                   DOW       WCHQ <= WPTCHQ
     C                   CALL      'AOSTOPV0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM                    PCHQAM
     C                   PARM      WCHQ          PCHQNO
     C                   PARM      WRETN         PRETAC
     C                   PARM                    PCNUM
     C                   PARM                    PCYCD
     C                   PARM                    PACCD
     C                   PARM                    PACSN
     C                   PARM                    PBRCA
      *
     C                   IF        PRetCode = '*STOP  '
     C                   EVAL      WErrIdx = wErrIdx + 1
     C                   EVAL      WFldNamArr(wErrIdx) = 'FRCHEQUENO'
     C**********         EVAL      WMsgIDArr(wErrIdx) = 'USR1259'                          AR1096685
     C                   EVAL      WMsgIDArr(wErrIdx) = '5045914'                          AR1096685
     C                   EVAL      MsgFArray(wErrIdx) = 'GBRTSMSGF'
     C                   EVAL      WErrExist = *ON
     C                   LEAVESR
     C                   ENDIF
      *
     C                   EVAL      WCHQ = WCHQ + 1
     C                   ENDDO
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrChqIssPre - Subroutine to verify if a Cheque Number is      *
      *               already issued or presented to the account      *
      *               holder                                          *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrChqIssPre   BEGSR
 
     C                   IF        (PFCHQ <> *BLANKS) AND
     C                             (PTCHQ = *BLANKS)
     C                   EVAL      PZField = *BLANKS
     C                   MOVE      PFCHQ         PZField
     C                   EXSR      SrAlignCheque
     C                   MOVE      PZField       WCHQ
     C                   EXSR      SrChequeBook
      *
     C                   IF        *IN65 = *ON
     C                   EVAL      WErrIdx = wErrIdx + 1
     C                   EVAL      WFldNamArr(wErrIdx) = 'FRCHEQUENO'
     C**********         EVAL      WMsgIDArr(wErrIdx) = 'USR1254'                          AR1096685
     C                   EVAL      WMsgIDArr(wErrIdx) = '5045909'                          AR1096685
     C                   EVAL      MsgFArray(wErrIdx) = 'GBRTSMSGF'
     C                   EVAL      WErrExist = *ON
     C                   ENDIF
      *
     C                   IF        *IN66 = *ON
     C                   EVAL      WErrIdx = wErrIdx + 1
     C                   EVAL      WFldNamArr(wErrIdx) = 'FRCHEQUENO'
     C**********         EVAL      WMsgIDArr(wErrIdx) = 'USR1255'                          AR1096685
     C                   EVAL      WMsgIDArr(wErrIdx) = '5045910'                          AR1096685
     C                   EVAL      MsgFArray(wErrIdx) = 'GBRTSMSGF'
     C                   EVAL      WErrExist = *ON
     C                   ENDIF
     C                   ENDIF
      *
      ** If a range is given, loop from 'From Cheque Number' to
      ** 'To Cheque Number'
      *
     C                   IF        (PFCHQ <> *BLANKS) AND
     C                             (PTCHQ <> *BLANKS) AND
     C                             (PTCHQ > PFCHQ)
     C                   EVAL      PZField = *BLANKS
     C                   MOVE      PFCHQ         PZField
     C                   EXSR      SrAlignCheque
     C                   MOVE      PZField       WCHQ
      *
     C                   EVAL      PZField = *BLANKS
     C                   MOVE      PTCHQ         PZField
     C                   EXSR      SrAlignCheque
     C                   MOVE      PZField       WPTCHQ
      *
     C                   DOW       WCHQ <= WPTCHQ
     C                   EXSR      SrChequeBook
 
     C                   IF        *IN65 = *ON
     C                   EVAL      WErrIdx = wErrIdx + 1
     C                   EVAL      WFldNamArr(wErrIdx) = 'FRCHEQUENO'
     C**********         EVAL      WMsgIDArr(wErrIdx) = 'USR1257'                          AR1096685
     C                   EVAL      WMsgIDArr(wErrIdx) = '5045912'                          AR1096685
     C                   EVAL      MsgFArray(wErrIdx) = 'GBRTSMSGF'
     C                   EVAL      WErrExist = *ON
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        *IN66 = *ON
     C                   EVAL      WErrIdx = wErrIdx + 1
     C                   EVAL      WFldNamArr(wErrIdx) = 'FRCHEQUENO'
     C**********         EVAL      WMsgIDArr(wErrIdx) = 'USR1258'                          AR1096685
     C                   EVAL      WMsgIDArr(wErrIdx) = '5045913'                          AR1096685
     C                   EVAL      MsgFArray(wErrIdx) = 'GBRTSMSGF'
     C                   EVAL      WErrExist = *ON
     C                   LEAVESR
     C                   ENDIF
      *
     C                   EVAL      WCHQ = WCHQ + 1
     C                   ENDDO
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrChequeBook - Subroutine to validate a Cheque Book           *
      *                                                               *
      * Called by: SrChqIssPre                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrChequeBook  BEGSR
 
     C                   EVAL      *IN65 = *OFF
     C                   EVAL      *IN66 = *OFF
     C     KCHQ1         SETGT     CHQBKPD
     C                   READP     CHQBKPD
      *
      ** Record not found
      *
     C                   IF        %EOF(CHQBKPD)
     C                   EVAL      *IN65 = *ON
     C                   ELSE
     C                   IF        (WCHQ < SCQN) OR (WCHQ > ECQN)
     C                             OR (WRETN <> #ACNO)
     C                   EVAL      *IN65 = *ON
      *
      ** Verify if Cheque Number is already presented
      *
     C                   ELSE
     C                   Z-ADD     WCHQ          WSCQN
     C                   EVAL      WOFSET = WSCQN - SCQN
     C                   EVAL      WI = %DIV(WOFSET:8)
     C                   EVAL      WBITN = %REM(WOFSET:8)
     C                   EVAL      WI = WI + 1
      *
     C                   MOVEA     CQPS          WAR
     C                   IF        WBITN = 0
     C                   TESTB     '0'           WAR(WI)                  66
     C                   ENDIF
     C                   IF        WBITN = 1
     C                   TESTB     '1'           WAR(WI)                  66
     C                   ENDIF
     C                   IF        WBITN = 2
     C                   TESTB     '2'           WAR(WI)                  66
     C                   ENDIF
     C                   IF        WBITN = 3
     C                   TESTB     '3'           WAR(WI)                  66
     C                   ENDIF
     C                   IF        WBITN = 4
     C                   TESTB     '4'           WAR(WI)                  66
     C                   ENDIF
     C                   IF        WBITN = 5
     C                   TESTB     '5'           WAR(WI)                  66
     C                   ENDIF
     C                   IF        WBITN = 6
     C                   TESTB     '6'           WAR(WI)                  66
     C                   ENDIF
     C                   IF        WBITN = 7
     C                   TESTB     '7'           WAR(WI)                  66
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrEditMessage - Subroutine to edit the message for output     *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: APEDTMSGS                                              *
      *                                                               *
      *****************************************************************
     C     SrEditMessage BEGSR
 
     C                   IF        WErrExist = *ON
     C                   EVAL      APIName = 'STCQ'                                         AR895153
     C                   CALLB     'APEDTMSGS'
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    MsgArrOUT
     C                   PARM                    APIName                                    AR895153
 
     C                   EVAL      PERMSG = MsgArrOUT
     C                   EVAL      PRTCD = '0'
      *
     C                   ELSE
     C                   EVAL      MsgArrOUT = *BLANKS
     C                   EVAL      PERMSG = MsgArrOUT
     C                   EVAL      PRTCD = '1'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAlignCheque - Subroutine to right-align the Cheque Number   *
      *                 passed to this program                        *
      *                                                               *
      * Called by: SrStopCheque, SrChqIssPre                          *
      *                                                               *
      * Calls: ZALIGN                                                 *
      *                                                               *
      *****************************************************************
     C     SrAlignCheque BEGSR
 
     C                   EVAL      PZADec = 0
     C                   EVAL      PZAdig = 8
 
     C                   CALLB     'ZALIGN'
     C                   PARM      'Y'           PZAlignOk
     C                   PARM                    PZField
     C                   PARM                    PZADec
     C                   PARM                    PZAdig
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initialisation subroutine                            *
      *                                                               *
      * Called by: Automatically called                               *
      *                                                               *
      * Calls: AOBANKR0                                               *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      **---------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------
 
     C     *ENTRY        PLIST
     C                   PARM                    PACNT
     C                   PARM                    PREFN
     C                   PARM                    PFCHQ
     C                   PARM                    PTCHQ
     C                   PARM                    PRTCD
     C                   PARM                    PERMSG
 
     C     KCHQ1         KLIST
     C                   KFLD                    WRETN
     C                   KFLD                    WCHQ
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       pRetCode
     C                   PARM      '*FIRST'      pOption
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  POption
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  1
     C                   EVAL      DBMOD  =  PSProcMod
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: DBERRCTL                                               *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2009
