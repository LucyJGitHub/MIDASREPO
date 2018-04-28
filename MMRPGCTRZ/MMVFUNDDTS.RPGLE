     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Funding Details')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVFUNDDTS - Validate Funding Details                        *
      *                                                               *
      *  Function:  This module receives a funding spread/rate,       *
      *             a funding spread sign and funding profit centre   *
      *             and validates these 3 fields. If all of them are  *
      *             valid the 10A return code will be blank; if any   *
      *             are not it will contain 'Error'                   *
      *                                                               *
      *  Component of: MMVALIDTE - MM validation service program      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. 245692             Date 12Dec13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 24Jan00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 01Aug97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *         - Applied for MD23981.                                *
      *  208221 - Changes identified during alpha site                *
      *  CDE002 - Revenue Analysis - new entry parm and validation    *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External data structure for Profit Centre details
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
 
      ** Short data structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for SAR Details                                                          208221
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  208221
                                                                                              208221
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message code 1 received as a parameter
     D Msgid1          S                   LIKE(#MSGID)
      ** Error message code 2 received as a parameter
     D Msgid2          S                   LIKE(#MSGID)
      ** Error message code 2 received as a parameter
     D Msgid3          S                   LIKE(#MSGID)
      ** Warning message code 1 received as a parameter
     D WMsgid1         S                   LIKE(#MSGID)
 
      ** Decimal separator                                                                    245692
     D BNDCSP          S              1A                                                      245692
                                                                                              245692
      ** Parameter list for ZA0840                                                            245692
      ** =========================                                                            245692
      ** Return code for numeric validation module call                                       245692
     D @Rtcde          S             10A                                                      245692
      ** Alpha field for numeric validation                                                   245692
     D @@ALPH          S             16A                                                      245692
      ** Number of decimal places field for numeric validation                                245692
     D @@IDP           S              2  0                                                    245692
      ** Number of integers field for numeric validation                                      245692
     D @@IINT          S              2  0                                                    245692
      ** Millions/Thousands id (Y=function on)                                                245692
     D @@MTID          S              1A                                                      245692
      ** Amount calculation field                                                             245692
     D @@AMT           S             15  0                                                    245692
      ** Error return code for ZA0840 module                                                  245692
     D @@ERCD          S              1  0                                                    245692
 
      ** Error indicators (1A, returned to caller)
     D ErrFundRat      S                   LIKE(ErrorFound)
     D ErrFundSgn      S                   LIKE(ErrorFound)
     D ErrFundPrf      S                   LIKE(ErrorFound)
 
 
     D FTTFRT          S              3S 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset the error flags to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   WarnFound
     C                   RESET                   Msgid1
     C                   RESET                   Msgid2
     C                   RESET                   Msgid3
     C                   RESET                   WMsgid1
     C                   RESET                   ErrFundRat
     C                   RESET                   ErrFundSgn
     C                   RESET                   ErrFundPrf
 
      ** Reset output fields
 
     C                   Z-ADD     *ZERO         TranFSRP
     C                   MOVEL     *BLANK        TranFSGN
     C                   MOVEL     *BLANK        TranFPRC
      *
      **  If all fields are blank, return to the calling program.
      *
     C     DDFSRP        IFEQ      *BLANKS
     C     DDFSGN        ANDEQ     *BLANKS
     C     DDFPRC        ANDEQ     *BLANKS
     C                   RETURN
     C                   ENDIF
      *
      **  Validate Funding Spread Sign.
      *
     C     DDFSGN        IFNE      *BLANKS
     C                   EXSR      VAL_FSGN
     C                   ENDIF
      *
      **  Validate Funding Spread/Rate.
      *
     C                   EXSR      VAL_FSRP
      *
      **  Validate Funding Profit Centre
      *
     C                   EXSR      VAL_FPRC
      *
      **  If the funding spread/rate, sign and profit centre are all valid
      **  determine the actual funding rate.
      *
     C     ErrFundRat    IFNE      'Y'
     C     ErrFundSgn    ANDNE     'Y'
     C     ErrFundPrf    ANDNE     'Y'
     C     DDFSRP        ANDNE     *BLANKS
     C                   EXSR      CAL_FRATE
     C                   ENDIF
 
      ** If an error was found, set the return code appropriately
 
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * VAL_FSGN - Validate funding spread sign                       *
      *                                                               *
      *****************************************************************
     C     VAL_FSGN      BEGSR
      *
      **  If the Funding Spread/Rate field has not been entered,display
      **  error message 'Funding Spread Sign entry invalid if no
      **  Funding Spread/Rate entered."
      *
     C     DDFSRP        IFEQ      *BLANKS
      *
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'Y'           ErrFundSgn
     C                   MOVEL     'AAM0018'     Msgid2
      *
     C                   ELSE
      *
      **  If the Spread Sign is not '+', '-' or blank, display error
      **  message "Funding Spread Sign must be '+', '-' or blank".
      *
     C     DDFSGN        IFNE      '+'
     C     DDFSGN        ANDNE     '-'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'Y'           ErrFundSgn
     C                   MOVEL     'AAM0001'     Msgid2
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEL     DDFSGN        TranFSGN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * VAL_FSRP - Validate funding spread/rate                       *
      *                                                               *
      *****************************************************************
     C     VAL_FSRP      BEGSR
      *
      **      If Funding Spread/Rate is not valid, display error
      **      message "Funding Spread/Rate is not a valid numeric rate"
      *
     C                   Z-ADD     0             @@AMT                                        245692
     C                   Z-ADD     0             @@ERCD                                       245692
     C     DDFSRP        IFNE      *BLANKS
     C**********         MOVE      *BLANKS       ZFIELD                                       245692
     C**********         MOVE      DDFSRP        ZFIELD                                       245692
     C**********         Z-ADD     4             ZADIG                                        245692
     C**********         Z-ADD     7             ZADEC                                        245692
     C                   MOVE      *BLANKS       @@ALPH                                       245692
     C                   MOVE      DDFSRP        @@ALPH                                       245692
     C                   Z-ADD     4             @@IINT                                       245692
     C                   Z-ADD     7             @@IDP                                        245692
     C**********         CALLB     'ZALIGN'                                                   245692
     C**********         PARM                    ZALIGNok          1                          245692
     C**********         PARM                    ZFIELD           16                          245692
     C**********         PARM                    ZADEC             1 0                        245692
     C**********         PARM                    ZADIG             2 0                        245692
     C                   CALLB     'ZA0840'                                                   245692
     C                   PARM                    @Rtcde                                       245692
     C                   PARM                    @@ALPH                                       245692
     C                   PARM                    @@IDP                                        245692
     C                   PARM                    @@IINT                                       245692
     C                   PARM                    @@MTID                                       245692
     C                   PARM                    @@ERCD                                       245692
     C                   PARM                    @@AMT                                        245692
     C                   PARM                    BNDCSP                                       245692
     C*****ZALIGNok      IFEQ      'N'                                                        245692
     C     @@ERCD        IFNE      0                                                          245692
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'Y'           ErrFundRat
     C                   MOVEL     'AAM0002'     Msgid1
     C                   ELSE
     C**********         MOVE      ZFIELD        TranFSRP                                     245692
     C                   MOVE      @@AMT         TranFSRP                                     245692
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * VAL_FPRC - Validate funding profit centre                     *
      *                                                               *
      *****************************************************************
     C     VAL_FPRC      BEGSR
      *
      **  If Funding Profit Centre is entered
      *
     C     DDFPRC        IFNE      *BLANKS
      *
      **  If Analytical Accounting is not installed (BGN0ST = 'N')              CDE002
      **  entry to Funding Profit Centre is prohibited.                         CDE002
     C                   IF        BGN0ST <> 'Y'                                CDE002
     C                   MOVE      'Y'           ErrorFound                     CDE002
     C                   MOVE      'Y'           ErrFundPrf                     CDE002
     C                   MOVEL     'AAM0019'     Msgid3                         CDE002
     C                   ELSE                                                   CDE002
      *                                                                         CDE002
      **  If the Funding Spread/Rate is blank, display error message
      **  "Entry on Funding Profit Centre is prohibited if no Funding
      **  Spread/Rate has been defined."
      *
     C     DDFSRP        IFEQ      *BLANKS
      *
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'Y'           ErrFundPrf
     C                   MOVEL     'AAM0004'     Msgid3
      *
     C                   ELSE
      *
      **  If the Funding Spread/Rate is non-blank, check if the entry
      **  is a valid profit centre. If not, display error message
      **  "Profit Centre entered is not defined on the system".
      *
     C                   CALLB     'AOPRFCR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      DDFPRC        @PCCD             4
     C     SDPRFC        PARM      SDPRFC        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'Y'           ErrFundPrf
     C                   MOVEL     'AAM0005'     Msgid3
     C*
     C                   ELSE
     C*
     C                   MOVE      DSPCCD        DDFPRC
     C*
     C**  If the Direct Funding Indicator is 'N', display error message
     C**  "Profit Centre entered is not capable of direct funding".
     C*
     C     DSDFPR        IFEQ      'N'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'Y'           ErrFundPrf
     C                   MOVEL     'AAM0006'     Msgid3
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C                   ENDIF                                                  CDE002
      *                                                                         CDE002
     C                   ELSE
      *
      **  If Funding Profit Centre is not entered... and the Funding
      **  Spread/Rate has been entered...
      **  (N.B. Bypass this if Analytical Accounting is not on)                 CDE002
      *
     C     DDFSRP        IFNE      *BLANKS
     C     BGN0ST        ANDEQ     'Y'                                          CDE002
      *                                                                         CDE002
      **  If the Transaction Profit Centre is not entered, display
      **  error message 'Funding Profit Centre should be entered.'
      *
     C     TranPCCD      IFEQ      *BLANKS
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'Y'           ErrFundPrf
     C                   MOVEL     'AAM0015'     Msgid3
      *
     C                   ELSE
      *
      **  Default the value of the Funding Profit Centre.
      *
     C                   CALLB     'AOPRFCR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      TranPCCD      @PCCD
     C     SDPRFC        PARM      SDPRFC        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C     TranCCY       IFEQ      BJLCCY
     C                   MOVE      DSLFPC        DDFPRC
     C                   ELSE
     C                   MOVE      DSFFPC        DDFPRC
     C                   ENDIF
     C                   ENDIF
      *
      **  If the Funding Profit Centre is still blank, display
      **  error message 'Funding Profit Centre should be entered.'
      *
     C     DDFPRC        IFEQ      *BLANKS
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'Y'           ErrFundPrf
     C                   MOVEL     'AAM0015'     Msgid3
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      DDFPRC        TranFPRC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CAL_FRATE - Calculate effective funding rate                  *
      *                                                               *
      *****************************************************************
     C     CAL_FRATE     BEGSR
      *
     C     DDFSGN        IFEQ      *BLANKS
     C                   Z-ADD     TranFSRP      WAFSRP           11 7
     C                   ENDIF
      *
     C     DDFSGN        IFEQ      '+'
     C     TranINTR      ADD       TranFSRP      WAFSRP
     C                   ENDIF
      *
     C     DDFSGN        IFEQ      '-'
     C     TranINTR      SUB       TranFSRP      WAFSRP
     C                   ENDIF
      *
      **  Compute the maximum and minimum allowable amount based on the
      **  tolerance for Funding Rate.
      *
     C     FTTFRT        DIV       100           WTRATE            3 2
      *
     C     1             ADD       WTRATE        WMAXTL            4 2
     C     TranINTR      MULT(H)   WMAXTL        WMAXRT           11 7
      *
     C     1             SUB       WTRATE        WMINTL            4 2
     C     TranINTR      MULT      WMINTL        WMINRT           11 7
      *                                                                                       208221
      ** Do not show the warning if CDE002 feature is on                                      208221
      *                                                                                       208221
     C     CDE002        IFNE      'Y'                                                        208221
      *
      **  If the Actual Funding Rate is greater the the maximum or less
      **  than the minimum amount, display warning message "Warning -
      **  Effective deal funding rate must be within tolerance level
      **  defined."
      *
     C     WAFSRP        IFGT      WMAXRT
     C     WAFSRP        ORLT      WMINRT
     C                   MOVE      'Y'           WarnFound
     C                   MOVE      'W'           ErrFundRat
     C                   MOVEL     'AAM0014'     WMsgId1
     C                   ENDIF
      *                                                                                       208221
     C                   ENDIF                                                                208221
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    Msgid1
     C                   PARM                    Msgid2
     C                   PARM                    Msgid3
     C                   PARM                    WMsgid1
     C                   PARM                    ErrFundRat
     C                   PARM                    ErrFundSgn
     C                   PARM                    ErrFundPrf
     C                   PARM                    DDFSRP           12
     C                   PARM                    DDFSGN            1
     C                   PARM                    DDFPRC            4
     C                   PARM                    TranCCY           3
     C                   PARM                    TranPCCD          4
     C                   PARM                    TranINTR         11 7
     C                   PARM                    BJLCCY            3
     C                   PARM                    FTTFRT
     C                   PARM                    TranFSRP         11 7
     C                   PARM                    TranFSGN          1
     C                   PARM                    TranFPRC          4
     C                   PARM                    BGN0ST            1            CDE002
     C                   PARM                    BNDCSP                                       245692
 
      ** Initialise error flags (can't be done using INZ keyword in
      ** D-specs because they are on the parameter list)
     C                   EVAL            ErrFundRat = 'N'
     C                   EVAL            ErrFundSgn = 'N'
     C                   EVAL            ErrFundPrf = 'N'
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
      *                                                                                       208221
      ** Access SAR details file to determine if CDE002 is switched on                        208221
      *                                                                                       208221
     C                   CallB     'AOSARDR0'                                                 208221
     C                   Parm      *Blanks       PRTCD             7                          208221
     C                   Parm      '*VERIFY'     POPTN             7                          208221
     C                   Parm      'CDE002'      PSARD             6                          208221
     C     SCSARD        Parm      SCSARD        DSFDY                                        208221
      *                                                                                       208221
     C                   Move      'N'           CDE002            1                          208221
     C                   If        PRTCD = *Blanks                                            208221
     C                   Eval      CDE002 = 'Y'                                               208221
     C                   Endif                                                                208221
      *                                                                                       208221
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
