000100200604     H DEBUG
000200200604     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200604      *****************************************************************
000400200604/*STD *  RPGBASEBND                                                   *
000500200604/*EXI *  TEXT('Midas SD Validate system value ProjectedDaysRetail')   *
000600200604      *****************************************************************
000700200604      *                                                               *
000800200604      *  Midas - Standing Data Module                                 *
000900200604      *                                                               *
001000200604      *  SD009585 - Validate a Midas System Value for the following:  *
001100200604      *             - System value is a number between 1 and 999 incl.*
001200200604      *             - System value is <= No of Days Forward.          *
001300200604      *                                                               *
001400200604      *  (c) Finastra International Limited 2002                      *
001500200604      *                                                               *
001600200604      *  Last Amend No. 248270B            Date 01Jun20               *
001700200604      *  Prev Amend No. 248270A            Date 01Jun20               *
001800200604      *                 248270             Date 01Jun20               *
001900200604      *  Last Amend No. MD046248           Date 27Oct17               *
002000200604      * Bank Fusion Midas 1.4 Base -----------------------------------*
002100200604      * Midas Plus 1.4 Base 04 ---------------------------------------*
002200200604      * Midas Plus 1.4 Base ------------------------------------------*
002300200604      * Midas Plus 1.3 ----------- Base ------------------------------*
002400200604      *  Prev Amend No. CLE025             Date 20Oct03               *
002500200604      *                 CGL029             Date 01Sep03               *
002600200604      *                 CRE009  *CREATE    Date 12Sep02               *
002700200604      *                                                               *
002800200604      *---------------------------------------------------------------*
002900200604      *                                                               *
003000200604      *  248270B- If CLE025 is *off, check BMNDFV of RE-ICD against   *
003100200604      *           Current Setting inserted by user.                   *
003200200604      *  248270A- Improved error msgid USR4039 when Current Setting   *
003300200604      *           entry is incorrect.                                 *
003400200604      *  248270 - System Values Maintenance do not accept value for   *
003500200604      *           ProjectedDaysRetail.                                *
003600200604      *  MD046248 - Finastra Rebranding                               *
003700200604      *  CLE025 - Credit Lines                                        *
003800200604      *  CGL029 - Increase Account Code to 10 digits                  *
003900200604      *  CRE009 - Projected Account Movements for RE accounts         *
004000200604      *                                                               *
004100200604      *****************************************************************
004200200604      ** D-specs
004300200604      ** =======
004400200604
004500200604      ** GL Installation Control Data
004600200604     D SDGELR        E DS                  EXTNAME(SDGELRPD)
004700200604                                                                                              CLE025
004800200604      ** Switchable features                                                                  CLE025
004900200604     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CLE025
005000200604     D SDRETL        E DS                  EXTNAME(SDRETLPD)                                 248270B
005100200604     D SDRETLACCD    E                     EXTFLD(QQACCD)                                    248270B
005200200604     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                 248270B
005300200604
005400200604      ** Short Data Structure for Access Objects
005500200604     D DSFDY         E DS                  EXTNAME(DSFDY)
005600200604
005700200604      ** Data structure for NewCurrVal string
005800200604     D NewCurrVal      DS           200
005900200604     D  DataToVal              1      3  0
006000200604     D  Digit1                 1      1                                                       248270
006100200604     D  Digit2                 2      2                                                       248270
006200200604     D  Digit3                 3      3                                                       248270
006300200604     D  DigitC                 1      3                                                       248270
006400200604
006500200604      ** +--------------------------------------+
006600200604      ** ¦ Declared variables                   ¦
006700200604      ** ¦ ==================                   ¦
006800200604      ** +--------------------------------------+
006900200604
007000200604      ** Error message id in GBSDUSRMSG
007100200604     D ErrMsgId        S              7
007200200604
007300200604      ** System value to be processed
007400200604     D SystemValue     S             20
007500200604
007600200604      ** Processing mode
007700200604     D ProcMode        S            190
007800200604
007900200604      ** General error indicator
008000200604     D GenError        S              1
008100200604
008200200604      ** Index for arrays of of error message ids etc
008300200604     D Idx             S              2P 0
008400200604
008500200604      ** Array of error message IDs
008600200604     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)
008700200604                                                                                              CLE025
008800200604     D CLE025          S              1                                                       CLE025
008900200604     D PRTCD           S              7                                                       CLE025
009000200604     D POPTN           S              7                                                       CLE025
009100200604     D PSARD           S              6                                                       CLE025
009200200604      *                                                                                       CGL029
009300200604     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
009400200604      *                                                                                       CGL029
009500200604     D DIGITS          C                   CONST('1234567890 ')                               248270
009600200604
009700200604      /EJECT
009800200604      ** +--- Start of Main processing -----------------------------------+
009900200604      ** ¦                                                                ¦
010000200604      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
010100200604      ** ¦ executed at program activation.                                ¦
010200200604      ** ¦                                                                ¦
010300200604      ** +----------------------------------------------------------------+
010400200604      *                                                                                       248270
010500200604      ** Check Current Settings entry from defined DIGITS if valid                            248270
010600200604      ** otherwise issue error message USR9885, USR9886 & USR9887.                    248270 248270A
010700200604      ***otherwise*issue*error*message*USR4039.************************               248270 248270A
010800200604      *                                                                                       248270
010900200604     C                   If        %CHECK(DIGITS : NewCurrVal) = 0                            248270
011000200604      *                                                                                       248270
011100200604      ** Issue error message if Digit2 entry is blank while Digit1 and                        248270
011200200604      ** Digit3 are not blanks.                                                               248270
011300200604      *                                                                                       248270
011400200604     C                   If        (Digit1 <> ' ' and Digit2 = ' '  and                       248270
011500200604     C                             Digit3 <> ' ')                                             248270
011600200604     C                   Eval      GenError = 'Y'                                             248270
011700200604     C                   Add       1             Idx                                          248270
011800200604     C**********         Movel     'USR4039'     MsgIDXArr(Idx)                       248270 248270A
011900200604     C                   Movel     'USR9885'     MsgIDXArr(Idx)                              248270A
012000200604     C                   Add       1             Idx                                         248270A
012100200604     C                   Movel     'USR9886'     MsgIDXArr(Idx)                              248270A
012200200604     C                   Add       1             Idx                                         248270A
012300200604     C                   Movel     'USR9887'     MsgIDXArr(Idx)                              248270A
012400200604     C                   Else                                                                 248270
012500200604      *                                                                                       248270
012600200604      ** Validate Current Settings entry. Convert entry to numeric                            248270
012700200604      ** since digits 1 to 9 and blanks are allowed.                                          248270
012800200604      *                                                                                       248270
012900200604     C                   IF        (Digit1 <> ' ' and Digit2 = ' '  and                       248270
013000200604     C                             Digit3 = ' ')                                              248270
013100200604     C     ' ':'0'       XLATE     DigitC        DigitC                                       248270
013200200604     C     DataToVal     DIV       100           DataToVal                                    248270
013300200604     C                   Else                                                                 248270
013400200604     C                   IF        (Digit1 <> ' ' and Digit2 <> ' '  and                      248270
013500200604     C                             Digit3 = ' ') OR                                           248270
013600200604     C                             (Digit1 = ' ' and Digit2 <> ' '  and                       248270
013700200604     C                             Digit3 = ' ')                                              248270
013800200604     C     ' ':'0'       XLATE     DigitC        DigitC                                       248270
013900200604     C     DataToVal     DIV       10            DataToVal                                    248270
014000200604     C                   Else                                                                 248270
014100200604     C     ' ':'0'       XLATE     DigitC        DigitC                                       248270
014200200604     C                   EndIf                                                                248270
014300200604     C                   EndIf                                                                248270
014400200604     C                   EndIf                                                                248270
014500200604      *                                                                                       248270
014600200604      ** Not found values from DIGITS.                                                        248270
014700200604      *                                                                                       248270
014800200604     C                   Else                                                                 248270
014900200604     C                   Eval      GenError = 'Y'                                             248270
015000200604     C                   Add       1             Idx                                          248270
015100200604     C**********         Movel     'USR4039'     MsgIDXArr(Idx)                       248270 248270A
015200200604     C                   Movel     'USR9885'     MsgIDXArr(Idx)                              248270A
015300200604     C                   Add       1             Idx                                         248270A
015400200604     C                   Movel     'USR9886'     MsgIDXArr(Idx)                              248270A
015500200604     C                   Add       1             Idx                                         248270A
015600200604     C                   Movel     'USR9887'     MsgIDXArr(Idx)                              248270A
015700200604     C                   Endif                                                                248270
015800200604
015900200604      ** If value entered by user is not in the range 0 to 999 incl
016000200604      ** then return an error
016100200604
016200200604     C     DataToVal     IFLT      001
016300200604     C     DataToVal     ORGT      999
016400200604     C                   EVAL      GenError = 'Y'
016500200604     C                   ADD       1             Idx
016600200604     C**********         MOVEL     'USR9516'     MsgIDXArr(Idx)                               248270
016700200604     C**********         Movel     'USR4039'     MsgIDXArr(Idx)                       248270 248270A
016800200604     C                   Movel     'USR9885'     MsgIDXArr(Idx)                              248270A
016900200604     C                   Add       1             Idx                                         248270A
017000200604     C                   Movel     'USR9886'     MsgIDXArr(Idx)                              248270A
017100200604     C                   Add       1             Idx                                         248270A
017200200604     C                   Movel     'USR9887'     MsgIDXArr(Idx)                              248270A
017300200604     C                   ENDIF
017400200604
017500200604      ** If value entered by user is not less than or equal to the
017600200604      ** 'No of Days Forward' value on GL ICD then return an error
017700200604
017800200604     C**********         CALL      'AOGELRR0'                                                 CGL029
017900200604     C                   CALL      'AOGELRR1'                                                 CGL029
018000200604     C                   PARM      *BLANKS       @RTCD             7
018100200604     C                   PARM      '*FIRST '     @OPTN             7
018200200604     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
018300200604     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
018400200604
018500200604     C                   IF        @RTCD <> *BLANKS
018600200604     C                   EXSR      *PSSR
018700200604     C                   ENDIF
018800200604      *                                                                                      248270B
018900200604     C                   CALL      'AOMMODR0'                                                248270B
019000200604     C                   PARM      *BLANKS       @RTCD             7                         248270B
019100200604     C                   PARM      '*FIRST '     @OPTN             7                         248270B
019200200604     C     SDMMOD        PARM      SDMMOD        DSSDY                                       248270B
019300200604      *                                                                                      248270B
019400200604     C                   IF        @RTCD <> *BLANKS                                          248270B
019500200604     C                   EXSR      *PSSR                                                     248270B
019600200604     C                   ENDIF                                                               248270B
019700200604      *                                                                                      248270B
019800200604     C     BGRTBN        IFEQ      'Y'                                                       248270B
019900200604     C                   CALL      'AORETLR0'                                                248270B
020000200604     C                   PARM      *BLANKS       @RTCD             7                         248270B
020100200604     C                   PARM      '*FIRST '     @OPTN             7                         248270B
020200200604     C     SDRETL        PARM      SDRETL        DSSDY                                       248270B
020300200604      *                                                                                      248270B
020400200604     C                   IF        @RTCD <> *BLANKS                                          248270B
020500200604     C                   EXSR      *PSSR                                                     248270B
020600200604     C                   ENDIF                                                               248270B
020700200604     C                   ENDIF                                                               248270B
020800200604      *                                                                                       CLE025
020900200604     C     CLE025        IFEQ      'Y'                                                        CLE025
021000200604                                                                                              CLE025
021100200604      ** If number of days forward is less than 9, value entered                              CLE025
021200200604      ** by user must be equal to 9                                                           CLE025
021300200604                                                                                              CLE025
021400200604     C     BKNDFV        IFLT      9                                                          CLE025
021500200604     C     DataToVal     IFNE      9                                                          CLE025
021600200604     C                   EVAL      GenError = 'Y'                                             CLE025
021700200604     C                   ADD       1             Idx                                          CLE025
021800200604     C**********         MOVEL     'USR4039'     MsgIDXArr(Idx)                       CLE025 248270A
021900200604     C                   Movel     'USR9885'     MsgIDXArr(Idx)                              248270A
022000200604     C                   Add       1             Idx                                         248270A
022100200604     C                   Movel     'USR9886'     MsgIDXArr(Idx)                              248270A
022200200604     C                   Add       1             Idx                                         248270A
022300200604     C                   Movel     'USR9887'     MsgIDXArr(Idx)                              248270A
022400200604     C                   ENDIF                                                                CLE025
022500200604                                                                                              CLE025
022600200604      ** If number of days forward is greater than or equal to 9,                             CLE025
022700200604      ** value entered by user must be between 9 and number of days                           CLE025
022800200604      ** forward (inclusive)                                                                  CLE025
022900200604                                                                                              CLE025
023000200604     C                   ELSE                                                                 CLE025
023100200604     C     DataToVal     IFLT      9                                                          CLE025
023200200604     C     DataToVal     ORGT      BKNDFV                                                     CLE025
023300200604     C                   EVAL      GenError = 'Y'                                             CLE025
023400200604     C                   ADD       1             Idx                                          CLE025
023500200604     C**********         MOVEL     'USR4039'     MsgIDXArr(Idx)                       CLE025 248270A
023600200604     C                   Movel     'USR9885'     MsgIDXArr(Idx)                              248270A
023700200604     C                   Add       1             Idx                                         248270A
023800200604     C                   Movel     'USR9886'     MsgIDXArr(Idx)                              248270A
023900200604     C                   Add       1             Idx                                         248270A
024000200604     C                   Movel     'USR9887'     MsgIDXArr(Idx)                              248270A
024100200604     C                   ENDIF                                                                CLE025
024200200604     C                   ENDIF                                                                CLE025
024300200604                                                                                              CLE025
024400200604      ** CLE025 off                                                                           CLE025
024500200604                                                                                              CLE025
024600200604     C                   ELSE                                                                 CLE025
024700200604
024800200604     C     BGRTBN        IFEQ      'Y'                                                       258270B
024900200604     C     DataToVal     IFGT      BMNDFV                                                    248270B
025000200604     C*****DataToVal     IFGT      BKNDFV                                                    248270B
025100200604     C                   EVAL      GenError = 'Y'
025200200604     C                   ADD       1             Idx
025300200604     C**********         MOVEL     'USR9517'     MsgIDXArr(Idx)                               248270
025400200604     C**********         Movel     'USR4039'     MsgIDXArr(Idx)                       248270 248270A
025500200604     C                   Movel     'USR9885'     MsgIDXArr(Idx)                              248270A
025600200604     C                   Add       1             Idx                                         248270A
025700200604     C                   Movel     'USR9886'     MsgIDXArr(Idx)                              248270A
025800200604     C                   Add       1             Idx                                         248270A
025900200604     C                   Movel     'USR9887'     MsgIDXArr(Idx)                              248270A
026000200604     C                   ENDIF
026100200604     C                   ENDIF                                                               248270B
026200200604                                                                                              CLE025
026300200604     C                   ENDIF                                                                CLE025
026400200604
026500200604     C                   EVAL       *INLR = *ON
026600200604
026700200604     C                   RETURN
026800200604
026900200604      ** Catchall for unprocessed errors
027000200604
027100200604     C                   IF        @RTCD <> *BLANKS
027200200604     C                   EXSR      *PSSR
027300200604     C                   ENDIF
027400200604
027500200604      ** Normal end processing
027600200604
027700200604     C                   EVAL      GenError = ' '
027800200604     C                   EVAL      *INLR = *ON
027900200604
028000200604     C                   RETURN
028100200604      /EJECT
028200200604      *****************************************************************
028300200604      *  *INZSR - Program Initialisation routine                      *
028400200604      *****************************************************************
028500200604     C     *INZSR        BEGSR
028600200604
028700200604     C     *ENTRY        PLIST
028800200604
028900200604      ** System value to be processed
029000200604     C                   PARM                    SystemValue
029100200604      ** Value entered by user
029200200604     C                   PARM                    NewCurrVal
029300200604      ** Processing Mode
029400200604     C                   PARM                    ProcMode
029500200604      ** General Error Indicator
029600200604     C                   PARM                    GenError
029700200604      ** Error message ID (number of entries)
029800200604     C                   PARM                    Idx
029900200604      ** Error message ID (array)
030000200604     C                   PARM                    MsgIDXArr
030100200604                                                                                              CLE025
030200200604      ** Check if enhancement CLE025 (Credit Lines) is on                                     CLE025
030300200604                                                                                              CLE025
030400200604     C                   CALL      'AOSARDR0'                                                 CLE025
030500200604     C                   PARM      *BLANKS       PRTCD                                        CLE025
030600200604     C                   PARM      '*VERIFY'     POPTN                                        CLE025
030700200604     C                   PARM      'CLE025'      PSARD                                        CLE025
030800200604     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE025
030900200604      *                                                                                       CLE025
031000200604     C                   IF        PRTCD = *BLANKS                                            CLE025
031100200604     C                   EVAL      CLE025 = 'Y'                                               CLE025
031200200604     C                   ELSE                                                                 CLE025
031300200604     C                   EVAL      CLE025 = 'N'                                               CLE025
031400200604     C                   ENDIF                                                                CLE025
031500200604
031600200604     C                   ENDSR
031700200604      /EJECT
031800200604      *****************************************************************
031900200604      *                                                               *
032000200604      * *PSSR  - Program exception error routine                      *
032100200604      *          Called automatically if a program error occurs,      *
032200200604      *          or directly by the program code using EXSR.          *
032300200604      *          This subroutine DUMPs the program just once.         *
032400200604      *                                                               *
032500200604      *****************************************************************
032600200604     C     *PSSR         BEGSR
032700200604
032800200604     C                   DUMP
032900200604
033000200604     C                   EVAL      GenError = 'Y'
033100200604     C                   EVAL      *INU7 = *ON
033200200604     C                   EVAL      *INU8 = *ON
033300200604     C                   EVAL      *INLR = *ON
033400200604
033500200604     C                   RETURN
033600200604
033700200604     C                   ENDSR
