000100200604     H DEBUG
000200200604     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200604      *****************************************************************
000400200604/*STD *  RPGBASEMOD                                                   *
000500200604/*EXI *  TEXT('Midas SE Validate Applicable Date on Screen 4')        *
000600200604      *****************************************************************
000700200604      *                                                               *
000800200604      *  Midas - Securities Trading Module                            *
000900200604      *                                                               *
001000200604      *  SEVSAPPDT - Validate Applicable Date.                        *
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
002600200604      *                 AR875871           Date 06Dec11               *
002700200604      *                 CRE073             Date 06Dec10               *
002800200604      * Bank Fusion Midas 1.4 Base -----------------------------------*
002900200604      * Midas Plus 1.4 Base 04 ---------------------------------------*
003000200604      * Midas Plus 1.4 Base ------------------------------------------*
003100200604      * Midas Plus 1.3 ----------- Base ------------------------------*
003200200604      *                 CSD027             Date 09Dec05               *
003300200604      *                 CSE071             Date 19Jul05               *
003400200604      *                 CAS006             Date 21Jan03               *
003500200604      * Midas Release 4.01 -------------------------------------------*
003600200604      *                 CSE031  *CREATE    Date 15Nov01               *
003700200604      *                                                               *
003800200604      *---------------------------------------------------------------*
003900200604      *                                                               *
004000200604      *  261824 - Error messages appear which should not be as field  *
004100200604      *           being validate is valid when compare to the input - *
004200200604      *           Maturity Date. Fix is to make sure that field will  *
004300200604      *           be validated only if Maturity Date is non-zero.     *
004400200604      *  MD046248 - Finastra Rebranding                               *
004500200604      *  AR875871 - Cannot insert in FRN info tab when base rate is   *
004600200604      *             blank and contractual spread is non-blank         *
004700200604      *  CRE073 - Interest Rate Rounding (Recompile)                  *
004800200604      *  CSD027 - Conversion Of Customer Number to Alpha              *
004900200604      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
005000200604      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
005100200604      *  CSE031 - Coupon Fixing for Floating Rate Notes               *
005200200604      *                                                               *
005300200604      *****************************************************************
005400200604      *
005500200604      ** +--------------------------------------+
005600200604      ** ¦ F-specs                              ¦
005700200604      ** ¦ =======                              ¦
005800200604      ** +--------------------------------------+
005900200604      *
006000200604      *****************************************************************
006100200604      /EJECT
006200200604      *****************************************************************
006300200604      *
006400200604      ** +--------------------------------------+
006500200604      ** ¦ Automatically included D-specs       ¦
006600200604      ** ¦ ==============================       ¦
006700200604      ** +--------------------------------------+
006800200604      *
006900200604      ** Standard D-specs
007000200604      ** ================
007100200604      **
007200200604      ** The following /COPY line includes the LDA layout,
007300200604      ** the copyright array definition,
007400200604      ** and the following named constants:
007500200604      **    True       logical = *On (for indicator processing)
007600200604      **    False      logical = *Off (for indicator processing)
007700200604      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
007800200604      **                                    handler)
007900200604      ** and the following variables:
008000200604      **    RunBefore  1A (for the PSSR)
008100200604      *
008200200604      /COPY ZACPYSRC,STD_D_SPEC
008300200604      *
008400200604      ** Program Status Data Structure
008500200604      ** =============================
008600200604      ** The following /COPY line includes all the defined fields in the
008700200604      ** PSDS.  They have meaningful names, prefixed by 'PS'.
008800200604      *
008900200604      /COPY ZACPYSRC,PSDS
009000200604      *
009100200604      ** The following /COPY line includes all the definitions of the
009200200604      ** appended error arrays, including the named constant giving the size
009300200604      ** of the arrays.
009400200604      *
009500200604      /COPY ZACPYSRC,ERR_XARRYS
009600200604      *
009700200604      ** +--------------------------------------+
009800200604      ** ¦ End of automatically included D-specs¦
009900200604      ** ¦ =====================================¦
010000200604      ** +--------------------------------------+
010100200604      *
010200200604      *****************************************************************
010300200604      /EJECT
010400200604      *****************************************************************
010500200604      *
010600200604      ** +--------------------------------------+
010700200604      ** ¦ Manually included D-specs            ¦
010800200604      ** ¦ =========================            ¦
010900200604      ** +--------------------------------------+
011000200604      *
011100200604      ** +--------------------------------------+
011200200604      ** ¦ Named constants                      ¦
011300200604      ** ¦ ===============                      ¦
011400200604      ** +--------------------------------------+
011500200604      *
011600200604      ** +--------------------------------------+
011700200604      ** ¦ Arrays and Data Structures           ¦
011800200604      ** ¦ ==========================           ¦
011900200604      ** +--------------------------------------+
012000200604      *
012100200604      ** Securities screen 4 details from incoming transaction
012200200604      ** - screen format
012300200604     D NwSE4ScnFmt   E DS                  EXTNAME(SESEC4PD)
012400200604      *
012500200604      ** Securities for file update - file format
012600200604     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
012700200604      *
012800200604      ** Securities screen 4 error indicators
012900200604     D SEESEC4       E DS                  EXTNAME(SEESEC4PD)
013000200604      *
013100200604      ** DS for the Applicable Date
013200200604     D WSAPDT          S              6A   DIM(10)
013300200604      *
013400200604      ** DS for the Base Rate Code
013500200604     D WSBRCD          S              2A   DIM(10)
013600200604      *
013700200604      ** DS for the Spread Rate
013800200604     D WSSPRT          S             12A   DIM(10)
013900200604      *                                                                                     AR875871
014000200604      ** DS for the Contractual Spread Rate                                                 AR875871
014100200604     D WSCNSP          S             12A   DIM(10)                                          AR875871
014200200604      *
014300200604      *
014400200604      ** +--------------------------------------+
014500200604      ** ¦ Declared variables                   ¦
014600200604      ** ¦ ==================                   ¦
014700200604      ** +--------------------------------------+
014800200604      *
014900200604      ** Index for arrays of error message ids, etc.
015000200604     D IDx             S              3P 0
015100200604      *
015200200604      ** Index for arrays of Warning error message ids, etc.
015300200604     D WIx             S              3P 0
015400200604      *
015500200604      ** Index for Applicable Date Array
015600200604     D Wx              S              2P 0
015700200604      *
015800200604      *
015900200604     D BJDFIN          S              1A
016000200604     D CRE073          S              1A                                                    AR875871
016100200604      *
016200200604      ** +--------------------------------------+
016300200604      ** ¦ End of D-specs                       ¦
016400200604      ** ¦ ==============                       ¦
016500200604      ** +--------------------------------------+
016600200604      *
016700200604      *****************************************************************
016800200604      /EJECT
016900200604      *****************************************************************
017000200604      *
017100200604      ** +--- Start of Main processing -------------------------------+
017200200604      ** ¦                                                            ¦
017300200604      ** ¦ *INZSR is executed at program activation.                  ¦
017400200604      ** ¦                                                            ¦
017500200604      ** +------------------------------------------------------------+
017600200604      *
017700200604      ** Initialise work variables.
017800200604     C                   EVAL      IDx = 0
017900200604     C                   EVAL      Wx = 1
018000200604     C                   Z-ADD     *ZEROS        WLDAT             5 0          Last Date.
018100200604      *
018200200604      ** Load Applicable Date array.
018300200604      *
018400200604     C                   MOVE      DDAD01        WSAPDT(1)
018500200604     C                   MOVE      DDAD02        WSAPDT(2)
018600200604     C                   MOVE      DDAD03        WSAPDT(3)
018700200604     C                   MOVE      DDAD04        WSAPDT(4)
018800200604     C                   MOVE      DDAD05        WSAPDT(5)
018900200604     C                   MOVE      DDAD06        WSAPDT(6)
019000200604     C                   MOVE      DDAD07        WSAPDT(7)
019100200604     C                   MOVE      DDAD08        WSAPDT(8)
019200200604     C                   MOVE      DDAD09        WSAPDT(9)
019300200604     C                   MOVE      DDAD10        WSAPDT(10)
019400200604      *
019500200604      ** Load Base Rate Code array
019600200604      *
019700200604     C                   MOVE      DDBR01        WSBRCD(1)
019800200604     C                   MOVE      DDBR02        WSBRCD(2)
019900200604     C                   MOVE      DDBR03        WSBRCD(3)
020000200604     C                   MOVE      DDBR04        WSBRCD(4)
020100200604     C                   MOVE      DDBR05        WSBRCD(5)
020200200604     C                   MOVE      DDBR06        WSBRCD(6)
020300200604     C                   MOVE      DDBR07        WSBRCD(7)
020400200604     C                   MOVE      DDBR08        WSBRCD(8)
020500200604     C                   MOVE      DDBR09        WSBRCD(9)
020600200604     C                   MOVE      DDBR10        WSBRCD(10)
020700200604      *
020800200604      ** Load Spread Indicator array
020900200604      *
021000200604     C                   MOVE      DDBS01        WSSPRT(1)
021100200604     C                   MOVE      DDBS02        WSSPRT(2)
021200200604     C                   MOVE      DDBS03        WSSPRT(3)
021300200604     C                   MOVE      DDBS04        WSSPRT(4)
021400200604     C                   MOVE      DDBS05        WSSPRT(5)
021500200604     C                   MOVE      DDBS06        WSSPRT(6)
021600200604     C                   MOVE      DDBS07        WSSPRT(7)
021700200604     C                   MOVE      DDBS08        WSSPRT(8)
021800200604     C                   MOVE      DDBS09        WSSPRT(9)
021900200604     C                   MOVE      DDBS10        WSSPRT(10)
022000200604      *                                                                                     AR875871
022100200604      ** Load Contractual Spread array                                                      AR875871
022200200604      *                                                                                     AR875871
022300200604     C                   IF        CRE073 = 'Y'                                             AR875871
022400200604     C                   MOVE      DDCNP01       WSCNSP(1)                                  AR875871
022500200604     C                   MOVE      DDCNP02       WSCNSP(2)                                  AR875871
022600200604     C                   MOVE      DDCNP03       WSCNSP(3)                                  AR875871
022700200604     C                   MOVE      DDCNP04       WSCNSP(4)                                  AR875871
022800200604     C                   MOVE      DDCNP05       WSCNSP(5)                                  AR875871
022900200604     C                   MOVE      DDCNP06       WSCNSP(6)                                  AR875871
023000200604     C                   MOVE      DDCNP07       WSCNSP(7)                                  AR875871
023100200604     C                   MOVE      DDCNP08       WSCNSP(8)                                  AR875871
023200200604     C                   MOVE      DDCNP09       WSCNSP(9)                                  AR875871
023300200604     C                   MOVE      DDCNP10       WSCNSP(10)                                 AR875871
023400200604     C                   ENDIF                                                              AR875871
023500200604      *
023600200604      ** Validate Applicable Dates.
023700200604      *
023800200604     C                   EXSR      SRValAppcDt
023900200604      *
024000200604      *
024100200604      ** If an error has been found, set return code appropriately.
024200200604      ** Otherwise, update valid file fields.
024300200604      *
024400200604     C                   IF        OKAD01 <> 'Y' OR OKAD02 <> 'Y' OR
024500200604     C                             OKAD03 <> 'Y' OR OKAD04 <> 'Y' OR
024600200604     C                             OKAD05 <> 'Y' OR OKAD06 <> 'Y' OR
024700200604     C                             OKAD07 <> 'Y' OR OKAD08 <> 'Y' OR
024800200604     C                             OKAD09 <> 'Y' OR OKAD10 <> 'Y'
024900200604
025000200604     C                   EVAL      RetCodeIn = 'ERROR'
025100200604
025200200604     C                   ENDIF
025300200604
025400200604     C                   IF        OKAD01 <> 'N' AND  OKAD02 <> 'N' AND
025500200604     C                             OKAD03 <> 'N' AND  OKAD04 <> 'N' AND
025600200604     C                             OKAD05 <> 'N' AND  OKAD06 <> 'N' AND
025700200604     C                             OKAD07 <> 'N' AND  OKAD08 <> 'N' AND
025800200604     C                             OKAD09 <> 'N' AND  OKAD10 <> 'N'
025900200604
026000200604     C                   MOVE      DDAD01        S1AD01
026100200604     C                   MOVE      DDAD02        S1AD02
026200200604     C                   MOVE      DDAD03        S1AD03
026300200604     C                   MOVE      DDAD04        S1AD04
026400200604     C                   MOVE      DDAD05        S1AD05
026500200604     C                   MOVE      DDAD06        S1AD06
026600200604     C                   MOVE      DDAD07        S1AD07
026700200604     C                   MOVE      DDAD08        S1AD08
026800200604     C                   MOVE      DDAD09        S1AD09
026900200604     C                   MOVE      DDAD10        S1AD10
027000200604
027100200604     C                   ENDIF
027200200604
027300200604     C                   RETURN
027400200604
027500200604      *****************************************************************
027600200604      /EJECT
027700200604      *****************************************************************
027800200604      *                                                               *
027900200604      *  SRVALAPPCDT - Validation Applicable Date                     *
028000200604      *                                                               *
028100200604      *****************************************************************
028200200604
028300200604     C     SRValAppcDt   BEGSR
028400200604      *
028500200604     C                   DOW       Wx <= 10
028600200604      *
028700200604     C                   IF        WSAPDT(Wx) <> *BLANKS
028800200604      *
028900200604      ** An entry has been made, but the previous field is blank.
029000200604      *
029100200604     C                   IF        Wx > 1
029200200604     C                   SUB       1             Wx
029300200604     C                   IF        WSAPDT(Wx) = *BLANKS
029400200604     C                   ADD       1             IDx
029500200604     C                   EXSR      SRApplcdErr
029600200604     C                   MOVE      'SEA0504'     MsgIDXAr(IDx)
029700200604     C                   ENDIF
029800200604     C                   ADD       1             Wx
029900200604     C                   ENDIF
030000200604      *
030100200604      *
030200200604      ** The entered Applicable Date must be in a valid date format
030300200604      *  (DDMMYY or MMDDYY).
030400200604      *
030500200604     C                   MOVE      *BLANKS       ZFIELD
030600200604     C                   MOVEL     WSAPDT(Wx)    ZFIELD
030700200604     C                   CALLB     'ZALIGN'
030800200604     C                   PARM                    ZALIGNok          1
030900200604     C                   PARM                    ZFIELD           16
031000200604     C                   PARM      0             ZADEC             1 0
031100200604     C                   PARM      6             ZADIG             2 0
031200200604
031300200604     C     ZALIGNok      IFEQ      'Y'
031400200604     C                   MOVE      ZFIELD        ZDATEI
031500200604     C                   CALLB     'ZDATE1'
031600200604     C                   PARM                    ZDATEI            6
031700200604     C                   PARM      *ZEROS        ZDAYNO            5 0
031800200604     C                   PARM                    BJDFIN
031900200604     C                   PARM                    ErrorFlag         1
032000200604     C                   END
032100200604      *
032200200604      ** If either ZALIGN and ZDATE1 errors
032300200604      *
032400200604     C     ZALIGNok      IFEQ      'N'
032500200604     C     ErrorFlag     OREQ      'Y'
032600200604     C                   ADD       1             IDx
032700200604     C                   EXSR      SRApplcdErr
032800200604     C                   MOVE      'SEA0505'     MsgIDXAr(IDx)
032900200604     C                   ELSE
033000200604      *
033100200604      ** The entered Applicable Date must be after Initial Date and
033200200604      *  before Maturity Date.
033300200604      *
033400200604     C                   IF        ZDAYNO <= S1ITLD OR
033500200604     C                             ZDAYNO > S1MATY
033600200604     C                             and S1MATY <> *ZEROS                                       261824
033700200604     C                   ADD       1             IDx
033800200604     C                   EXSR      SRApplcdErr
033900200604     C                   MOVE      'SEA0506'     MsgIDXAr(IDx)
034000200604     C                   ENDIF
034100200604      *
034200200604      ** The date entered must not be later than the previous date.
034300200604      *
034400200604     C                   IF        ZDAYNO <= WLDAT
034500200604     C                   ADD       1             IDx
034600200604     C                   EXSR      SRApplcdErr
034700200604     C                   MOVE      'SEA0507'     MsgIDXAr(IDx)
034800200604     C                   ENDIF
034900200604      *
035000200604     C                   Z-ADD     ZDAYNO        WLDAT
035100200604      *
035200200604     C                   ENDIF
035300200604      *
035400200604      *
035500200604      ** If a date has been entered, then at least either the corresponding
035600200604      *  Base Rate or Spread Rate must be entered.
035700200604      *
035800200604     C                   IF        CRE073 = 'Y'                                             AR875871
035900200604     C                   IF        WSBRCD(Wx) = *BLANKS AND                                 AR875871
036000200604     C                             WSCNSP(Wx) = *BLANKS                                     AR875871
036100200604     C                   ADD       1             IDx                                        AR875871
036200200604     C                   EXSR      SRApplcdErr                                              AR875871
036300200604     C                   MOVE      'SEA0933'     MsgIDXAr(IDx)                              AR875871
036400200604     C                   ENDIF                                                              AR875871
036500200604     C                   ELSE                                                               AR875871
036600200604     C                   IF        WSBRCD(Wx) = *BLANKS AND
036700200604     C                             WSSPRT(Wx) = *BLANKS
036800200604     C                   ADD       1             IDx
036900200604     C                   EXSR      SRApplcdErr
037000200604     C                   MOVE      'SEA0508'     MsgIDXAr(IDx)
037100200604     C                   ENDIF
037200200604     C                   ENDIF                                                              AR875871
037300200604      *
037400200604     C                   ENDIF
037500200604      *
037600200604      ** Applicable Date must be entered if either the Base Rate Code
037700200604      *  or the Spread Rate is entered.
037800200604      *
037900200604     C                   IF        CRE073 = 'Y'                                             AR875871
038000200604     C                   IF        WSAPDT(Wx) = *BLANKS AND                                 AR875871
038100200604     C                             WSBRCD(Wx) <> *BLANKS OR                                 AR875871
038200200604     C                             WSAPDT(Wx) = *BLANKS AND                                 AR875871
038300200604     C                             WSCNSP(Wx) <> *BLANKS                                    AR875871
038400200604     C                   ADD       1             IDx                                        AR875871
038500200604     C                   EXSR      SRApplcdErr                                              AR875871
038600200604     C                   MOVE      'SEA0509'     MsgIDXAr(IDx)                              AR875871
038700200604     C                   ENDIF                                                              AR875871
038800200604     C                   ELSE                                                               AR875871
038900200604     C                   IF        WSAPDT(Wx) = *BLANKS AND
039000200604     C                             WSBRCD(Wx) <> *BLANKS OR
039100200604     C                             WSAPDT(Wx) = *BLANKS AND
039200200604     C                             WSSPRT(Wx) <> *BLANKS
039300200604     C                   ADD       1             IDx
039400200604     C                   EXSR      SRApplcdErr
039500200604     C                   MOVE      'SEA0509'     MsgIDXAr(IDx)
039600200604     C                   ENDIF
039700200604     C                   ENDIF                                                              AR875871
039800200604      *
039900200604      *
040000200604     C                   ADD       1             Wx
040100200604      *
040200200604     C                   ENDDO
040300200604      *
040400200604     C                   ENDSR
040500200604      *
040600200604      *****************************************************************
040700200604      /EJECT
040800200604      *****************************************************************
040900200604      *                                                               *
041000200604      *  SRAPPLCDERR - Applicable Date Field in Error.                *
041100200604      *                                                               *
041200200604      *****************************************************************
041300200604     C     SRApplcdErr   BEGSR
041400200604      *
041500200604     C                   SELECT
041600200604      *
041700200604     C                   WHEN      Wx = 1
041800200604     C                   MOVE      'N'           OKAD01
041900200604     C                   MOVEL     'DDAD01'      FldNamXAr(IDx)
042000200604      *
042100200604     C                   WHEN      Wx = 2
042200200604     C                   MOVE      'N'           OKAD02
042300200604     C                   MOVEL     'DDAD02'      FldNamXAr(IDx)
042400200604      *
042500200604     C                   WHEN      Wx = 3
042600200604     C                   MOVE      'N'           OKAD03
042700200604     C                   MOVEL     'DDAD03'      FldNamXAr(IDx)
042800200604      *
042900200604     C                   WHEN      Wx = 4
043000200604     C                   MOVE      'N'           OKAD04
043100200604     C                   MOVEL     'DDAD04'      FldNamXAr(IDx)
043200200604      *
043300200604     C                   WHEN      Wx = 5
043400200604     C                   MOVE      'N'           OKAD05
043500200604     C                   MOVEL     'DDAD05'      FldNamXAr(IDx)
043600200604      *
043700200604     C                   WHEN      Wx = 6
043800200604     C                   MOVE      'N'           OKAD06
043900200604     C                   MOVEL     'DDAD06'      FldNamXAr(IDx)
044000200604      *
044100200604     C                   WHEN      Wx = 7
044200200604     C                   MOVE      'N'           OKAD07
044300200604     C                   MOVEL     'DDAD07'      FldNamXAr(IDx)
044400200604      *
044500200604     C                   WHEN      Wx = 8
044600200604     C                   MOVE      'N'           OKAD08
044700200604     C                   MOVEL     'DDAD08'      FldNamXAr(IDx)
044800200604      *
044900200604     C                   WHEN      Wx = 9
045000200604     C                   MOVE      'N'           OKAD09
045100200604     C                   MOVEL     'DDAD09'      FldNamXAr(IDx)
045200200604      *
045300200604     C                   WHEN      Wx = 10
045400200604     C                   MOVE      'N'           OKAD10
045500200604     C                   MOVEL     'DDAD10'      FldNamXAr(IDx)
045600200604      *
045700200604     C                   ENDSL
045800200604      *
045900200604     C                   ENDSR
046000200604      *
046100200604      *****************************************************************
046200200604      /EJECT
046300200604      *****************************************************************
046400200604      *                                                               *
046500200604      *  *INZSR - Program Initialisation                              *
046600200604      *         - This subroutine runs automatically for program      *
046700200604      *           initialisation.                                     *
046800200604      *                                                               *
046900200604      *****************************************************************
047000200604      *
047100200604     C     *INZSR        BEGSR
047200200604      *
047300200604     C     *ENTRY        PLIST
047400200604      *
047500200604      ** INPUT
047600200604      ** =====
047700200604      *
047800200604      ** Return code
047900200604     C                   PARM                    RetCodeIn
048000200604      *
048100200604      ** Securities screen 4 details from incoming transaction
048200200604      ** - screen format
048300200604     C                   PARM                    NwSE4ScnFmt
048400200604      *
048500200604      ** STANDING DATA
048600200604      ** =============
048700200604      *
048800200604      ** Date format indicator
048900200604     C                   PARM                    BJDFIN
049000200604      *
049100200604      ** OUTPUT
049200200604      ** ======
049300200604      *
049400200604      ** Error fields/message IDs/message data (arrays) from/to caller
049500200604     C                   PARM                    FldNamXAr
049600200604     C                   PARM                    MsgIDXAr
049700200604     C                   PARM                    MsgDtaXAr
049800200604      *
049900200604      ** Securities screen 4 error indicators
050000200604     C                   PARM                    SEESEC4
050100200604      *
050200200604      ** Securities for file update - file format
050300200604     C                   PARM                    NwSEFilFmt
050400200604      *                                                                                     AR875871
050500200604      ** Interest Rate Rounding enhancement                                                 AR875871
050600200604     C                   PARM                    CRE073                                     AR875871
050700200604      *
050800200604      *
050900200604      ** Program, module and procedure names for dbase error processing
051000200604      ** ==============================================================
051100200604      ** The following /COPY sets these values.
051200200604      *
051300200604      /COPY ZACPYSRC,DBFIELDS
051400200604      *
051500200604     C                   ENDSR
051600200604      *
051700200604      *****************************************************************
051800200604      /EJECT
051900200604      *****************************************************************
052000200604      *
052100200604      ** The following /COPY contains the standard program status
052200200604      ** subroutine, including a bound call to the DBERRCTL module.
052300200604      *
052400200604      /COPY ZACPYSRC,PSSR_ILE
052500200604      *
052600200604      *****************************************************************
052700200604      /EJECT
052800200604      *****************************************************************
052900200604      *
053000200604**  CPY@
053100200604(c) Finastra International Limited 2001
