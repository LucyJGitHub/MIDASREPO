000100200604     H DEBUG
000200200604     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200604      *****************************************************************
000400200604/*STD *  RPGBASEMOD                                                   *
000500200604/*EXI *  TEXT('Midas SE Validate Next Coupon Date')                   *
000600200604      *****************************************************************
000700200604      *                                                               *
000800200604      *  Midas - Securities Trading Module                            *
000900200604      *                                                               *
001000200604      *  SEVSLNXCD - Validate Next Coupon Date.                       *
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
002900200604      *                 256564             Date 17Sep08               *
003000200604      *                 248763             Date 24Jul07               *
003100200604      * Midas Plus 1.4 Base ------------------------------------------*
003200200604      * Midas Plus 1.3 ----------- Base ------------------------------*
003300200604      *                 CSD027             Date 09Dec05               *
003400200604      *                 BUG10847R          Date 24Mar06               *
003500200604      *                 CSE075             Date 17Nov05               *
003600200604      *                 CSE074             Date 30Aug05               *
003700200604      *                 CSE071             Date 19Jul05               *
003800200604      *                 CAS006             Date 21Jan03               *
003900200604      * Midas Release 4.01 -------------------------------------------*
004000200604      *                 CSE031 *Create     Date 04Dec01               *
004100200604      *                                                               *
004200200604      *---------------------------------------------------------------*
004300200604      *                                                               *
004400200604      *  261824 - Error messages appear which should not be as field  *
004500200604      *           being validate is valid when compare to the input - *
004600200604      *           Maturity Date. Fix is to make sure that field will  *
004700200604      *           be validated only if Maturity Date is non-zero.     *
004800200604      *  MD046248 - Finastra Rebranding                               *
004900200604      *  CRE073 - Interest Rate Rounding (Recompile)                  *
005000200604      *  256564 - Recompile due to PF changes done by fix 256330      *
005100200604      *  248763 - Passing blank fields to ZNCD in insert mode.        *
005200200604      *  CSD027 - Conversion Of Customer Number to Alpha              *
005300200604      *  BUG10847R- Incorrect Last and Next Coupon Dates              *
005400200604      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
005500200604      *           (Recompile)                                         *
005600200604      *  CSE074 - Const. Yld Amort. Upgrade to MidasPlus (Recompile)  *
005700200604      *  CSE071 - Multiple Holidays Re Securities                     *
005800200604      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
005900200604      *  CSE031 - Coupon Fixing for Floating Rate Notes               *
006000200604      *                                                               *
006100200604      *****************************************************************
006200200604      *
006300200604      ** +--------------------------------------+
006400200604      ** ¦ F-specs                              ¦
006500200604      ** ¦ =======                              ¦
006600200604      ** +--------------------------------------+
006700200604      *
006800200604      *****************************************************************
006900200604      /EJECT
007000200604      *****************************************************************
007100200604      *
007200200604      ** +--------------------------------------+
007300200604      ** ¦ Automatically included D-specs       ¦
007400200604      ** ¦ ==============================       ¦
007500200604      ** +--------------------------------------+
007600200604      *
007700200604      ** Standard D-specs
007800200604      ** ================
007900200604      **
008000200604      ** The following /COPY line includes the LDA layout,
008100200604      ** the copyright array definition,
008200200604      ** and the following named constants:
008300200604      **    True       logical = *On (for indicator processing)
008400200604      **    False      logical = *Off (for indicator processing)
008500200604      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
008600200604      **                                    handler)
008700200604      ** and the following variables:
008800200604      **    RunBefore  1A (for the PSSR)
008900200604      *
009000200604      /COPY ZACPYSRC,STD_D_SPEC
009100200604      *
009200200604      ** Program Status Data Structure
009300200604      ** =============================
009400200604      ** The following /COPY line includes all the defined fields in the
009500200604      ** PSDS.  They have meaningful names, prefixed by 'PS'.
009600200604      *
009700200604      /COPY ZACPYSRC,PSDS
009800200604      *
009900200604      ** The following /COPY line includes all the definitions of the
010000200604      ** appended error arrays, including the named constant giving the size
010100200604      ** of the arrays.
010200200604      *
010300200604      /COPY ZACPYSRC,ERR_XARRYS
010400200604      *
010500200604      ** +--------------------------------------+
010600200604      ** ¦ End of automatically included D-specs¦
010700200604      ** ¦ =====================================¦
010800200604      ** +--------------------------------------+
010900200604      *
011000200604      *****************************************************************
011100200604      /EJECT
011200200604      *****************************************************************
011300200604      *
011400200604      ** +--------------------------------------+
011500200604      ** ¦ Manually included D-specs            ¦
011600200604      ** ¦ =========================            ¦
011700200604      ** +--------------------------------------+
011800200604      *
011900200604      ** +--------------------------------------+
012000200604      ** ¦ Named constants                      ¦
012100200604      ** ¦ ===============                      ¦
012200200604      ** +--------------------------------------+
012300200604      *
012400200604      ** +--------------------------------------+
012500200604      ** ¦ Arrays and Data Structures           ¦
012600200604      ** ¦ ==========================           ¦
012700200604      ** +--------------------------------------+
012800200604      *
012900200604      ** Securities screen 2 details from incoming transaction
013000200604      ** - screen format
013100200604     D NwSE2ScnFmt   E DS                  EXTNAME(SESEC2PD)
013200200604      *                                                                                       CSE071
013300200604      ** Securities screen 6 details from incoming transaction                                CSE071
013400200604      ** - screen format                                                                      CSE071
013500200604     D NwSE6ScnFmt   E DS                  EXTNAME(SESEC6PD)                                  CSE071
013600200604      *
013700200604      ** Securities for file update - file format
013800200604     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
013900200604      *
014000200604      ** Securities screen 2 error indicators
014100200604     D SEESEC2       E DS                  EXTNAME(SEESEC2PD)
014200200604      *
014300200604      ** Securities retrieved from file - file format
014400200604     D CrSEFilFmt    E DS                  EXTNAME(SECTYD)
014500200604      *
014600200604      ** Coupon/Rate days
014700200604     D  CDArr                183    230
014800200604      ** Coupon/Rate inds
014900200604     D  CRArr                231    242
015000200604      *
015100200604      ** +--------------------------------------+
015200200604      ** ¦ Declared variables                   ¦
015300200604      ** ¦ ==================                   ¦
015400200604      ** +--------------------------------------+
015500200604     D BJRDNB          S              5P 0
015600200604     D BJDFIN          S              1
015700200604     D PNCD            S              5P 0
015800200604      *
015900200604      ** Parameter list for ZDATE2
016000200604     D PDateIn         S              5P 0
016100200604     D PDateOut        S              6P 0
016200200604     D PADateOut       S              7A
016300200604      *
016400200604      ** Index for arrays of error message ids, etc.
016500200604     D IDx             S              3P 0
016600200604      *
016700200604      ** +--------------------------------------+
016800200604      ** ¦ End of D-specs                       ¦
016900200604      ** ¦ ==============                       ¦
017000200604      ** +--------------------------------------+
017100200604      *
017200200604      *****************************************************************
017300200604      /EJECT
017400200604      *****************************************************************
017500200604      *
017600200604      ** +--- Start of Main processing -------------------------------+
017700200604      ** ¦                                                            ¦
017800200604      ** ¦ *INZSR is executed at program activation.                  ¦
017900200604      ** ¦                                                            ¦
018000200604      ** +------------------------------------------------------------+
018100200604      *
018200200604      ** Initialise work variables.
018300200604     C                   EVAL      IDx = 0
018400200604      *
018500200604      ** Validate Next Coupon Date
018600200604      *
018700200604     C                   EXSR      SRValNextCD
018800200604      *
018900200604      ** If an error has been found, set return code appropriately.
019000200604      ** Otherwise, update valid file fields.
019100200604      *
019200200604     C                   IF        OKNCD = 'N'
019300200604     C                   EVAL      RetCodeIn = 'ERROR'
019400200604     C                   ENDIF
019500200604
019600200604     C                   IF        OKNCD <> 'N'
019700200604     C                   EVAL      S1NCD = ZDAYNO
019800200604     C                   ENDIF
019900200604
020000200604     C                   RETURN
020100200604      *
020200200604      *****************************************************************
020300200604      /EJECT
020400200604      *****************************************************************
020500200604      *                                                               *
020600200604      *  SRValNextCD - Validation for Next Coupon Date.               *
020700200604      *                                                               *
020800200604      *****************************************************************
020900200604     C     SRValNextCD   BEGSR
021000200604      *
021100200604      ** Recalculate the Next Coupon Date if the Business Day
021200200604      *  Convention has been changed.
021300200604      *
021400200604     C     DDBCNV        IFNE      BCNV
021500200604      *                                                                                    BUG10847R
021600200604      ** Since action variable is not passed as parameter, BCNV being *BLANKS is           BUG10847R
021700200604      *  the same as that current action being done is in INSERT mode                      BUG10847R
021800200604      *                                                                                    BUG10847R
021900200604     C     BCNV          ANDNE     *BLANKS                                                 BUG10847R
022000200604     C                   MOVE      *BLANKS       DDNCD
022100200604     C                   ENDIF
022200200604      *
022300200604      ** Recalculate the Next Coupon Date if it has been blanked out.
022400200604      *
022500200604     C     DDNCD         IFNE      *BLANKS
022600200604      *
022700200604      ** Next Coupon Date: Must be in a valid date format (DDMMYY or MMDDYY)
022800200604      *  and be later than the system run date and less than Maturity Date.
022900200604      *
023000200604     C                   MOVE      *BLANKS       ZFIELD
023100200604     C                   MOVEL     DDNCD         ZFIELD
023200200604     C                   CALLB     'ZALIGN'
023300200604     C                   PARM                    ZALIGNok          1
023400200604     C                   PARM                    ZFIELD           16
023500200604     C                   PARM      0             ZADEC             1 0
023600200604     C                   PARM      6             ZADIG             2 0
023700200604
023800200604     C     ZALIGNok      IFEQ      'Y'
023900200604     C                   MOVE      ZFIELD        ZDATEI
024000200604     C                   CALLB     'ZDATE1'
024100200604     C                   PARM                    ZDATEI            6
024200200604     C                   PARM      *ZEROS        ZDAYNO            5 0
024300200604     C                   PARM                    BJDFIN
024400200604     C                   PARM                    ErrorFlag         1
024500200604     C                   END
024600200604      *
024700200604      * If either ZALIGN and ZDATE1 errors
024800200604      *
024900200604     C     ZALIGNok      IFEQ      'N'
025000200604     C     ErrorFlag     OREQ      'Y'
025100200604     C                   MOVE      'N'           OKNCD
025200200604     C                   ADD       1             IDx
025300200604     C                   MOVEL     'DDNCD'       FldNamXAr(IDx)
025400200604     C                   MOVEL     'SEA0514'     MsgIdXAr(IDx)
025500200604     C                   ELSE
025600200604      *
025700200604     C                   IF        ZDAYNO < BJRDNB OR
025800200604     C                             ZDAYNO > S1MATY
025900200604     C                             and S1MATY <> *ZEROS                                       261824
026000200604     C                   MOVE      'N'           OKNCD
026100200604     C                   ADD       1             IDx
026200200604     C                   MOVEL     'DDNCD'       FldNamXAr(IDx)
026300200604     C                   MOVEL     'SEA0515'     MsgIdXAr(IDx)
026400200604     C                   ENDIF
026500200604      *
026600200604     C                   ENDIF
026700200604      *
026800200604     C                   ELSE
026900200604      *
027000200604     C                   Z-ADD     *ZEROS        PNCD
027100200604      *
027200200604     C                   CALLB     'ZNCD'
027300200604     C**********         PARM                    ITLD                                         248763
027400200604     C                   PARM                    S1ITLD                                       248763
027500200604     C                   PARM                    FCPN
027600200604     C**********         PARM                    MATY                                         248763
027700200604     C                   PARM                    S1MATY                                       248763
027800200604     C                   PARM                    CDArr
027900200604     C                   PARM                    CRArr
028000200604     C                   PARM                    BJRDNB
028100200604     C                   PARM                    BJDFIN
028200200604     C**********         PARM                    NMCY                                         248763
028300200604     C**********         PARM                    SITP                                         248763
028400200604     C                   PARM                    S1NMCY                                       248763
028500200604     C                   PARM                    S1SITP                                       248763
028600200604     C                   PARM                    DDBCNV
028700200604     C                   PARM                    LCPN
028800200604     C                   PARM                    DDHCY1                                       CSE071
028900200604     C                   PARM                    DDHCY2                                       CSE071
029000200604     C                   PARM                    DDHCY3                                       CSE071
029100200604     C                   PARM                    DDHCY4                                       CSE071
029200200604     C                   PARM                    DDHCY5                                       CSE071
029300200604     C                   PARM                    DDHCY6                                       CSE071
029400200604     C                   PARM                    DDHCY7                                       CSE071
029500200604     C                   PARM                    DDHCY8                                       CSE071
029600200604     C                   PARM                    DDHCY9                                       CSE071
029700200604     C                   PARM                    PNCD
029800200604      *
029900200604     C                   IF        PNCD <> *ZEROS
030000200604     C                   Z-ADD     PNCD          ZDAYNO
030100200604      *
030200200604      ** Repopulate the screen field with the new calculated
030300200604      *  Next Coupon date.
030400200604      *
030500200604     C                   Z-ADD     PNCD          PDateIn
030600200604      *
030700200604     C                   CALLB     'ZDATE2'
030800200604     C                   PARM                    PDateIn
030900200604     C                   PARM                    BJDFIN
031000200604     C                   PARM      *ZERO         PDateOut
031100200604     C                   PARM      *BLANKS       PADateOut
031200200604
031300200604     C                   MOVEL     PDateOut      DDNCD
031400200604      *
031500200604     C                   ELSE
031600200604     C                   Z-ADD     *ZEROS        ZDAYNO
031700200604     C                   ENDIF
031800200604      *
031900200604     C                   ENDIF
032000200604      *
032100200604     C                   ENDSR
032200200604      *
032300200604      *****************************************************************
032400200604      /EJECT
032500200604      *****************************************************************
032600200604      *                                                               *
032700200604      *  *INZSR - Program Initialisation                              *
032800200604      *         - This subroutine runs automatically for program      *
032900200604      *           initialisation.                                     *
033000200604      *                                                               *
033100200604      *****************************************************************
033200200604      *
033300200604     C     *INZSR        BEGSR
033400200604      *
033500200604     C     *ENTRY        PLIST
033600200604      *
033700200604      ** INPUT
033800200604      ** =====
033900200604      *
034000200604      ** Return Code
034100200604     C                   PARM                    RetCodeIn
034200200604      *
034300200604      ** Securities screen 2 details from incoming transaction
034400200604      ** - screen format
034500200604     C                   PARM                    NwSE2ScnFmt
034600200604      *                                                                                       CSE071
034700200604      ** Securities screen 6 details from incoming transaction                                CSE071
034800200604      ** - screen format                                                                      CSE071
034900200604     C                   PARM                    NwSE6ScnFmt                                  CSE071
035000200604      *
035100200604      ** Securities retrieved from file - file format
035200200604     C                   PARM                    CrSEFilFmt
035300200604      *
035400200604      ** STANDING DATA
035500200604      ** =============
035600200604      *
035700200604      ** SDBANK - Runday number
035800200604     C                   PARM                    BJRDNB
035900200604      *
036000200604      ** SDBANK - Date format indicator
036100200604     C                   PARM                    BJDFIN
036200200604      *
036300200604      ** OUTPUT
036400200604      ** ======
036500200604      *
036600200604      ** Error fields/message IDs/message data (arrays) from/to caller
036700200604     C                   PARM                    FldNamXAr
036800200604     C                   PARM                    MsgIDXAr
036900200604     C                   PARM                    MsgDtaXAr
037000200604      *
037100200604      ** Securities screen 2 error indicators
037200200604     C                   PARM                    SEESEC2
037300200604      *
037400200604      ** Securities for file update - file format
037500200604     C                   PARM                    NwSEFilFmt
037600200604      *
037700200604      *
037800200604      ** Program, module and procedure names for dbase error processing
037900200604      ** ==============================================================
038000200604      ** The following /COPY sets these values.
038100200604      *
038200200604      /COPY ZACPYSRC,DBFIELDS
038300200604      *
038400200604     C                   ENDSR
038500200604      *
038600200604      *****************************************************************
038700200604      /EJECT
038800200604      *****************************************************************
038900200604      *
039000200604      ** The following /COPY contains the standard program status
039100200604      ** subroutine, including a bound call to the DBERRCTL module.
039200200604      *
039300200604      /COPY ZACPYSRC,PSSR_ILE
039400200604      *
039500200604      *****************************************************************
039600200604      /EJECT
039700200604      *****************************************************************
039800200604      *
039900200604**  CPY@
040000200604(c) Finastra International Limited 2001
