000100200604     H DEBUG
000200200604     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200604      *****************************************************************
000400200604/*STD *  RPGBASEMOD                                                   *
000500200604/*EXI *  TEXT('Midas SE Validate initial date')                       *
000600200604      *****************************************************************
000700200604      *                                                               *
000800200604      *  Midas - Securities Trading Module                            *
000900200604      *                                                               *
001000200604      *  SEVSINDAT - Validate Initial Date                            *
001100200604      *                                                               *
001200200604      *  Component of: SESECSSIN                                      *
001300200604      *                SESECSCTL                                      *
001400200604      *                SESECSRPR                                      *
001500200604      *                                                               *
001600200604      *  (c) Finastra International Limited 2001                      *
001700200604      *                                                               *
001800200604      *    This source is centrally supported and must ONLY be        *
001900200604      *    amended by Core Development Personnel.                     *
002000200604      *                                                               *
002100200604      *    /COPY, Client or Country amendments must not be            *
002200200604      *    applied to this source.                                    *
002300200604      *                                                               *
002400200604      *  Last Amend No. 261824             Date 22May20               *
002500200604      *  Prev Amend No. MD046248           Date 27Oct17               *
002600200604      *                 CRE073             Date 06Dec10               *
002700200604      * Bank Fusion Midas 1.4 Base -----------------------------------*
002800200604      * Midas Plus 1.4 Base 04 ---------------------------------------*
002900200604      * Midas Plus 1.4 Base ------------------------------------------*
003000200604      * Midas Plus 1.3 ----------- Base ------------------------------*
003100200604      *                 CSD027             Date 09Dec05               *
003200200604      *                 CSE075             Date 17Nov05               *
003300200604      *                 CSE074             Date 30Aug05               *
003400200604      *                 CSE071             Date 19Jul05               *
003500200604      *                 CGL014             Date 20Oct03               *
003600200604      *                 225455             Date 05Mar04               *
003700200604      *                 CAS006             Date 21Jan03               *
003800200604      * Midas Release 4 --------------- Base -------------------------*
003900200604      * Midas DBA 3.05 -----------------------------------------------*
004000200604      *                 CSD006             Date 14May01               *
004100200604      *                 CAP060             Date 14May01               *
004200200604      * Midas DBA 3.03 -----------------------------------------------*
004300200604      *                 CAP137  *CREATE    Date 07Feb00               *
004400200604      *                                                               *
004500200604      *---------------------------------------------------------------*
004600200604      *                                                               *
004700200604      *  261824 - Error messages appear which should not be as field  *
004800200604      *           being validate is valid when compare to the input - *
004900200604      *           Maturity Date. Fix is to make sure that field will  *
005000200604      *           be validated only if Maturity Date is non-zero.     *
005100200604      *  MD046248 - Finastra Rebranding                               *
005200200604      *  CRE073 - Interest Rate Rounding (Recompile)                  *
005300200604      *  CSD027 - Conversion Of Customer Number to Alpha              *
005400200604      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
005500200604      *           (Recompile)                                         *
005600200604      *  CSE074 - Const. Yld Amort. Upgrade to MidasPlus (Recompile)  *
005700200604      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
005800200604      *  CGL014 - Collaterals Processing (Recompile)                  *
005900200604      *  225455 - Remove validation of initial date againts issue date*
006000200604      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
006100200604      *  CSD006 - Market Data Feeds (recompile)                       *
006200200604      *  CAP060 - Midas APIs, Security Prices Full API (recompile)    *
006300200604      *  CAP137 - Conversion of SE Security inputs into modular       *
006400200604      *           structure to use as APIs.                           *
006500200604      *                                                               *
006600200604      *****************************************************************
006700200604      *
006800200604      ** +--------------------------------------+
006900200604      ** ¦ F-specs                              ¦
007000200604      ** ¦ =======                              ¦
007100200604      ** +--------------------------------------+
007200200604      *
007300200604      *****************************************************************
007400200604      /EJECT
007500200604      *****************************************************************
007600200604      *
007700200604      ** +--------------------------------------+
007800200604      ** ¦ Automatically included D-specs       ¦
007900200604      ** ¦ ==============================       ¦
008000200604      ** +--------------------------------------+
008100200604      *
008200200604      ** Standard D-specs
008300200604      ** ================
008400200604      **
008500200604      ** The following /COPY line includes the LDA layout,
008600200604      ** the copyright array definition,
008700200604      ** and the following named constants:
008800200604      **    True       logical = *On (for indicator processing)
008900200604      **    False      logical = *Off (for indicator processing)
009000200604      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
009100200604      **                                    handler)
009200200604      ** and the following variables:
009300200604      **    RunBefore  1A (for the PSSR)
009400200604      *
009500200604      /COPY ZACPYSRC,STD_D_SPEC
009600200604      *
009700200604      ** Program Status Data Structure
009800200604      ** =============================
009900200604      ** The following /COPY line includes all the defined fields in the
010000200604      ** PSDS.  They have meaningful names, prefixed by 'PS'.
010100200604      *
010200200604      /COPY ZACPYSRC,PSDS
010300200604      *
010400200604      ** The following /COPY line includes all the definitions of the
010500200604      ** appended error arrays, including the named constant giving the size
010600200604      ** of the arrays.
010700200604      *
010800200604      /COPY ZACPYSRC,ERR_XARRYS
010900200604      *
011000200604      ** +--------------------------------------+
011100200604      ** ¦ End of automatically included D-specs¦
011200200604      ** ¦ =====================================¦
011300200604      ** +--------------------------------------+
011400200604      *
011500200604      *****************************************************************
011600200604      /EJECT
011700200604      *****************************************************************
011800200604      *
011900200604      ** +--------------------------------------+
012000200604      ** ¦ Manually included D-specs            ¦
012100200604      ** ¦ =========================            ¦
012200200604      ** +--------------------------------------+
012300200604      *
012400200604      ** +--------------------------------------+
012500200604      ** ¦ Named constants                      ¦
012600200604      ** ¦ ===============                      ¦
012700200604      ** +--------------------------------------+
012800200604      *
012900200604      ** +--------------------------------------+
013000200604      ** ¦ Arrays and Data Structures           ¦
013100200604      ** ¦ ==========================           ¦
013200200604      ** +--------------------------------------+
013300200604      *
013400200604      ** Securities screen 1 details from incoming transaction
013500200604      ** - screen format
013600200604     D NwSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
013700200604      *
013800200604      ** Securities screen 2 details from incoming transaction
013900200604      ** - screen format
014000200604     D NwSE2ScnFmt   E DS                  EXTNAME(SESEC2PD)
014100200604      *
014200200604      ** Securities for file update - file format
014300200604     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
014400200604      *
014500200604      ** Securities retrieved from file - file format
014600200604     D CrSEFilFmt    E DS                  EXTNAME(SECTYD)
014700200604      *
014800200604      ** Securities screen 2 error indicators
014900200604     D SEESEC2       E DS                  EXTNAME(SEESEC2PD)
015000200604      *
015100200604      ** +--------------------------------------+
015200200604      ** ¦ Declared variables                   ¦
015300200604      ** ¦ ==================                   ¦
015400200604      ** +--------------------------------------+
015500200604      *
015600200604      ** Index for arrays of error message ids, etc.
015700200604     D IDx             S              3P 0
015800200604      *
015900200604      ** Parameters for ZDATE1
016000200604     D PDateIn         S              6A
016100200604     D PDaynoOut       S              5P 0
016200200604     D BJDFIN          S              1A
016300200604     D PErrorFlag      S              1A
016400200604      *
016500200604      ** Working variables
016600200604     D WItlDtNo        S              5P 0
016700200604
016800200604     D PCpnRt          S             15P 0
016900200604      *
017000200604      ** +--------------------------------------+
017100200604      ** ¦ End of D-specs                       ¦
017200200604      ** ¦ ==============                       ¦
017300200604      ** +--------------------------------------+
017400200604      *
017500200604      *****************************************************************
017600200604      /EJECT
017700200604      *****************************************************************
017800200604      *
017900200604      ** +--- Start of Main processing -------------------------------+
018000200604      ** ¦                                                            ¦
018100200604      ** ¦ *INZSR is executed at program activation.                  ¦
018200200604      ** ¦                                                            ¦
018300200604      ** +------------------------------------------------------------+
018400200604      *
018500200604      ** Initialise work variables.
018600200604     C                   EVAL      IDx = 0
018700200604     C                   EVAL      WItlDtNo = 0
018800200604      *
018900200604      ** Validate initial date
019000200604      *
019100200604     C                   EXSR      SRValItlDte
019200200604      *
019300200604      ** If an error has been found, set return code appropriately.
019400200604      ** Otherwise, update valid file fields.
019500200604      *
019600200604     C                   IF        OKITLD = 'N'
019700200604     C                   EVAL      RetCodeIn = 'ERROR'
019800200604     C                   ENDIF
019900200604
020000200604     C                   IF        OKITLD <> 'N'
020100200604     C                   Z-ADD     WItlDtNo      S1ITLD
020200200604     C                   ENDIF
020300200604
020400200604     C                   RETURN
020500200604      *
020600200604      *****************************************************************
020700200604      /EJECT
020800200604      *****************************************************************
020900200604      *                                                               *
021000200604      *  SRVALITLDTE - Validation for Initial Date                    *
021100200604      *                                                               *
021200200604      *****************************************************************
021300200604     C     SRValItlDte   BEGSR
021400200604
021500200604     C                   IF        DDITLD = *BLANKS
021600200604
021700200604     C                   IF        DDINCS = 'C' AND
021800200604     C                             PCpnRt <> *ZEROS
021900200604     C                   MOVE      'N'           OKITLD
022000200604     C                   ADD       1             IDx
022100200604     C                   MOVEL     'DDITLD'      FldNamXAr(IDx)
022200200604     C                   MOVEL     'SEA0177'     MsgIdXAr(IDx)
022300200604     C                   ENDIF
022400200604
022500200604     C                   GOTO      EvalItlDte
022600200604     C                   ENDIF
022700200604      *
022800200604      ** Check valid date
022900200604      *
023000200604     C                   TESTN                   DDITLD               01
023100200604
023200200604     C                   IF        *IN01 = *OFF
023300200604     C                   MOVE      'N'           OKITLD
023400200604     C                   ADD       1             IDx
023500200604     C                   MOVEL     'DDITLD'      FldNamXAr(IDx)
023600200604     C                   MOVEL     'SEA0177'     MsgIdXAr(IDx)
023700200604     C                   GOTO      EvalItlDte
023800200604     C                   ENDIF
023900200604
024000200604     C                   MOVE      *BLANKS       PDateIn
024100200604     C                   MOVE      DDITLD        PDateIn
024200200604     C                   CALLB     'ZDATE1'
024300200604     C                   PARM                    PDateIn
024400200604     C                   PARM      *ZERO         PDaynoOut
024500200604     C                   PARM                    BJDFIN
024600200604     C                   PARM      *BLANK        PErrorFlag
024700200604
024800200604     C                   IF        PErrorFlag = 'Y'
024900200604     C                   MOVE      'N'           OKITLD
025000200604     C                   ADD       1             IDx
025100200604     C                   MOVEL     'DDITLD'      FldNamXAr(IDx)
025200200604     C                   MOVEL     'SEA0177'     MsgIdXAr(IDx)
025300200604     C                   GOTO      EvalItlDte
025400200604     C                   ENDIF
025500200604
025600200604     C                   Z-ADD     PDaynoOut     WItlDtNo
025700200604      *
025800200604      ** Must not be greater than maturity date
025900200604     C**********         IF        PDaynoOut >= S1MATY                                        261824
026000200604     C                   IF        PDaynoOut >= S1MATY and S1MATY <> *ZEROS                   261824
026100200604     C                   MOVE      'N'           OKITLD
026200200604     C                   ADD       1             IDx
026300200604     C                   MOVEL     'DDITLD'      FldNamXAr(IDx)
026400200604     C                   MOVEL     'SEA0178'     MsgIdXAr(IDx)
026500200604     C                   ENDIF
026600200604      *
026700200604      ** Must be greater than issue date (Amend Mode only)
026800200604      *
026900200604     C**********         IF        DDACTN = 'A' AND                                           225455
027000200604     C**********                   DDNISS = 'Y' AND                                           225455
027100200604     C**********                   PDaynoOut < ISSD                                           225455
027200200604     C**********         MOVE      'N'           OKITLD                                       225455
027300200604     C**********         ADD       1             IDx                                          225455
027400200604     C**********         MOVEL     'DDITLD'      FldNamXAr(IDx)                               225455
027500200604     C**********         MOVEL     'SEA0178'     MsgIdXAr(IDx)                                225455
027600200604     C**********         ENDIF                                                                225455
027700200604
027800200604     C     EValItlDte    ENDSR
027900200604      *
028000200604      *****************************************************************
028100200604      /EJECT
028200200604      *****************************************************************
028300200604      *                                                               *
028400200604      *  *INZSR - Program Initialisation                              *
028500200604      *         - This subroutine runs automatically for program      *
028600200604      *           initialisation.                                     *
028700200604      *                                                               *
028800200604      *****************************************************************
028900200604      *
029000200604     C     *INZSR        BEGSR
029100200604      *
029200200604     C     *ENTRY        PLIST
029300200604      *
029400200604      ** INPUT
029500200604      ** =====
029600200604      *
029700200604      ** Return Code
029800200604     C                   PARM                    RetCodeIn
029900200604      *
030000200604      ** Securities screen 1 details from incoming transaction
030100200604      ** - screen format
030200200604     C                   PARM                    NwSE1ScnFmt
030300200604      *
030400200604      ** Securities screen 2 details from incoming transaction
030500200604      ** - screen format
030600200604     C                   PARM                    NwSE2ScnFmt
030700200604      *
030800200604      ** Securities retrieved from file - file format
030900200604     C                   PARM                    CrSEFilFmt
031000200604      *
031100200604      ** Coupon Rate
031200200604     C                   PARM                    PCpnRt
031300200604      *
031400200604      ** STANDING DATA
031500200604      ** =============
031600200604      *
031700200604      ** SDBANK - date format indicator
031800200604     C                   PARM                    BJDFIN
031900200604      *
032000200604      ** OUTPUT
032100200604      ** ======
032200200604      *
032300200604      ** Error fields/message IDs/message data (arrays) from/to caller
032400200604     C                   PARM                    FldNamXAr
032500200604     C                   PARM                    MsgIDXAr
032600200604     C                   PARM                    MsgDtaXAr
032700200604      *
032800200604      ** Securities screen 2 error indicators
032900200604     C                   PARM                    SEESEC2
033000200604      *
033100200604      ** Securities for file update - file format
033200200604     C                   PARM                    NwSEFilFmt
033300200604      *
033400200604      *
033500200604      ** Program, module and procedure names for dbase error processing
033600200604      ** ==============================================================
033700200604      ** The following /COPY sets these values.
033800200604      *
033900200604      /COPY ZACPYSRC,DBFIELDS
034000200604      *
034100200604     C                   ENDSR
034200200604      *
034300200604      *****************************************************************
034400200604      /EJECT
034500200604      *****************************************************************
034600200604      *
034700200604      ** The following /COPY contains the standard program status
034800200604      ** subroutine, including a bound call to the DBERRCTL module.
034900200604      *
035000200604      /COPY ZACPYSRC,PSSR_ILE
035100200604      *
035200200604      *****************************************************************
035300200604      /EJECT
035400200604      *****************************************************************
035500200604      *
035600200604**  CPY@
035700200604(c) Finastra International Limited 2001
