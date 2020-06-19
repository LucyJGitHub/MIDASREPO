000100200603     H DEBUG
000200200603     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200603      *****************************************************************
000400200603/*STD *  RPGBASEMOD                                                   *
000500200603/*EXI *  TEXT('Midas ZA Apply Forward Points to an Exch Rate')        *
000600200603      *****************************************************************
000700200603      *                                                               *
000800200603      *  Midas - Standard subprograms                                 *
000900200603      *                                                               *
001000200603      *  ZA0780 - Apply Forward Points to an Exchange Rate            *
001100200603      *                                                               *
001200200603      *  Component of: ZA_ALL - All ZA modules service program        *
001300200603      *                                                               *
001400200603      *  (c) Finastra International Limited 2001                      *
001500200603      *                                                               *
001600200603      *    This source is centrally supported and must ONLY be        *
001700200603      *    amended by Core Development Personnel                      *
001800200603      *                                                               *
001900200603      *    /COPY, Client or Country amendments must not be            *
002000200603      *    applied to this source.                                    *
002100200603      *                                                               *
002200200604      *  Last Amend No. 248024             Date 22May20               *
002300200603      *  Prev Amend No. MD046248           Date 27Oct17               *
002400200603      *                 CER059             Date 19Jul10               *
002500200603      *                 BUG23050A          Date 20Mar09               *
002600200603      * Bank Fusion Midas 1.4 Base -----------------------------------*
002700200603      * Midas Plus 1.4 Base 04 ---------------------------------------*
002800200603      * Midas Plus 1.4 Base ------------------------------------------*
002900200603      * Midas Plus 1.3 ----------- Base ------------------------------*
003000200603      * Midas Release 4 --------------- Base -------------------------*
003100200603      * Midas DBA 3.00 ---------------- Base -------------------------*
003200200603      *                 CAP006             Date 04Nov98               *
003300200603      *                 143747             Date 28Sep98               *
003400200603      *                 CAP002  *CREATE    Date 01Aug97               *
003500200603      *                                                               *
003600200603      *---------------------------------------------------------------*
003700200603      *                                                               *
003800200603      *  248024 - Apply fix patterned after 242105 for determining    *
003900200603      *           'Normally Quoted Decimal for forward points.        *
004000200603      *           Applied fix 243459.                                 *
004100200603      *  MD046248 - Finastra Rebranding                               *
004200200603      *  CER059 - German Feature Upgrade to Delhi                     *
004300200603      *  BUG23050A -Reciprocal rate indicator not defaulting.         *
004400200603      *             Defaulting of Reciprocal Rate indicator(FGE002).  *
004500200603     F*  CAP006 - Allow exchange rate with five digits (154453)       *
004600200603      *  143747 - Forward points conversion error                     *
004700200603      *  CAP002 - Conversion of Midas inputs to modular API structure *
004800200603      *                                                               *
004900200603      *****************************************************************
005000200603
005100200603      *****************************************************************
005200200603      ** +--------------------------------------+
005300200603      ** ¦ Automatically included D-specs       ¦
005400200603      ** ¦ ==============================       ¦
005500200603      ** +--------------------------------------+
005600200603      **
005700200603      ** Standard D-specs
005800200603      ** ================
005900200603      **
006000200603      ** The following /COPY line includes the LDA layout,
006100200603      ** the copyright array definition,
006200200603      ** and the following named constants:
006300200603      **    True       logical = *on (for indcator processing)
006400200603      **    False      logical = *off (for indcator processing)
006500200603      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
006600200603      **                                    handler)
006700200603      ** and the following variables:
006800200603      **    RunBefore  1A (for the PSSR)
006900200603
007000200603     D/COPY ZACPYSRC,STD_D_SPEC
007100200603
007200200603      ** Include the ZA standard declares
007300200603     D/COPY ZACPYSRC,STDDECLARE
007400200603
007500200603      ** Program Status Data Structure
007600200603      ** =============================
007700200603      ** The following /COPY line includes all the defined fields in the
007800200603      ** PSDS.  They have meaningful names, prefixed by 'PS'.
007900200603
008000200603     D/COPY ZACPYSRC,PSDS
008100200603
008200200603      ** +--------------------------------------+
008300200603      ** ¦ End of automatically included D-specs¦
008400200603      ** ¦ =====================================¦
008500200603      ** +--------------------------------------+
008600200603
008700200603      *****************************************************************
008800200603      /EJECT
008900200603      *****************************************************************
009000200603
009100200603      ** +--------------------------------------+
009200200603      ** ¦ Manually included D-specs            ¦
009300200603      ** ¦ =========================            ¦
009400200603      ** +--------------------------------------+
009500200603
009600200603      ** +--------------------------------------+
009700200603      ** ¦ Declared variables                   ¦
009800200603      ** ¦ ==================                   ¦
009900200603      ** +--------------------------------------+
010000200603
010100200603      **   First scaling exponent
010200200603     D     @@SXP1      S              1S 0
010300200603      **   Second scaling exponent
010400200603     D     @@SXP2      S                   LIKE(@@SXP1)
010500200603
010600200603      ** +--------------------------------------+
010700200603      ** ¦ Arrays and Data Structures           ¦
010800200603      ** ¦ ==========================           ¦
010900200603      ** +--------------------------------------+
011000200603
011100200603     D @@AY            S             10  0 DIM(10) CTDATA PERRCD(1)
011200200603
011300200603      ** +--------------------------------------+
011400200603      ** ¦ End of D-specs                       ¦
011500200603      ** ¦ ==============                       ¦
011600200603      ** +--------------------------------------+
011700200603      *****************************************************************
011800200603      /EJECT
011900200603      *****************************************************************
012000200603     C
012100200603      ** +--- Start of Main processing -----------------------------------+
012200200603      ** ¦                                                                ¦
012300200603      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
012400200603      ** ¦ executed at program activation.                                ¦
012500200603      ** ¦                                                                ¦
012600200603      ** +----------------------------------------------------------------+
012700200603      *
012800200603      * Initialize outputs = scaled & unscaled rate
012900200603      *
013000200603     C                   Z-ADD     0             @@GSRT                         gross scaled rate
013100200603     C                   Z-ADD     0             @@GURT                         gross unscld rate
013200200603      *
013300200603      * ZA0780 - APPLY FORWARD POINTS TO AN EXCHANGE RATE.
013400200603      *
013500200603     C                   EXSR      ZA0780
013600200603      *
013700200603      * RETURN
013800200603      *
013900200603     C                   RETURN
014000200603      ****************************************************************
014100200603      /EJECT
014200200603      ****************************************************************
014300200603      * ZA0780 - APPLY FORWARD POINTS TO AN EXCHANGE RATE            *
014400200603      ****************************************************************
014500200603     C     ZA0780        BEGSR
014600200603      *
014700200603      **  SCALE THE RATE PRIOR TO APPLYING THE FORWARD POINTS.
014800200603      *
014900200603     C     @@SCAL        IFEQ      'Y'
015000200603      *
015100200603      ** CONVERT AN UNSCALED RATE TO A SCALED RATE
015200200603      *
015300200603     C                   CALLB     'ZA1150'
015400200603      *
015500200603      * INPUTS
015600200603     C                   PARM                    @@SXP1                         scaling exponent
015700200603     C                   PARM                    @@SXP2                         scaling exponent
015800200603     C******             PARM      @@IRAT        @@INRT           12 8                        CAP006
015900200603     C                   PARM      @@IRAT        @@INRT           13 8                        CAP006
016000200603     C                   PARM                    @@DMD1            1
016100200603      *
016200200603      * OUTPUTS
016300200603     C******             PARM      *ZEROS        @@SCRT           12 8                        CAP006
016400200603     C******             PARM      *ZEROS        @@ISRT           12 8                        CAP006
016500200603     C                   PARM      *ZEROS        @@SCRT           13 8                        CAP006
016600200603     C                   PARM      *ZEROS        @@ISRT           13 8                        CAP006
016700200603     C                   PARM      *ZEROS        @@ERCD            1 0          errors
016800200603      *
016900200603      **  IF THE ERROR CODE FROM ZA1150 IS 1 OR 3
017000200603      **  THEN A DATABASE ERROR HAS OCCURRED.
017100200603      *
017200200603     C     @@ERCD        IFEQ      1
017300200603     C     @@ERCD        OREQ      3
017400200603     C                   MOVEL     *BLANKS       DBFILE
017500200603     C                   MOVEL     '900'         DBASE
017600200603     C                   MOVEL     '@@SCRT'      DBKEY
017700200603     C                   EXSR      *PSSR
017800200603     C                   END
017900200603      *
018000200603      ** SCALED RATE
018100200603      *
018200200603     C                   Z-ADD     @@SCRT        @@IRAT
018300200603     C                   END
018400200603      *
018500200603      ** IF EITHER CURRENCY IS THE BASE CURRENCY OBTAIN NUMBER OF
018600200603      ** NORMALLY QUOTED DECIMAL PLACES FOR THE OTHER CURRENCY.
018700200603      *
018800200603     C     DDBCCY        IFEQ      BNCYDL
018900200603     C     DDSCCY        OREQ      BNCYDL
019000200603      *
019100200603     C     DDBCCY        IFEQ      BNCYDL
019200200603     C                   MOVE      @@NDP2        @@NDP             1 0
019300200603     C                   ELSE
019400200603     C                   MOVE      @@NDP1        @@NDP
019500200603     C                   END
019600200603      *
019700200603      ** IF NEITHER IS BASE CURRENCY OBTAIN THE NUMBER OF QUOTED
019800200603      ** DECIMAL PLACES USING ZA0790.
019900200603      ** NOTE THAT THE RATE USED IS SCALED.
020000200603      *
020100200603     C                   ELSE
020200200603     C                   EXSR      ZA0790
020300200603     C                   END
020400200603      *
020500200603      ** NOW APPLY FORWARD POINTS TO EXCHANGE RATE.
020600200603      *
020700200603     C                   Z-ADD     @@NDP         @@C               2 0
020800200603     C                   ADD       1             @@C
020900200603     C     @@FPNT        DIV       @@AY(@@C)     @@WF1            15 8
021000200603     C     @@WF1         ADD       @@IRAT        @@GSRT           13 8
021100200603      *
021200200603      * Check whether F/Points has made Outright Rate negative :
021300200603      *
021400200603     C     @@GSRT        IFLT      *ZERO                                           -VE.RATE
021500200603     C                   Z-ADD     *ZERO         @@GSRT
021600200603     C                   END
021700200603      *
021800200603      **  UNSCALE THE RATE FOR OUTPUT.
021900200603      *
022000200603     C     @@DMD1        IFEQ      'M'
022100200603     C                   Z-ADD     @@SXP1        @@SEXP
022200200603     C                   ELSE
022300200603     C                   Z-ADD     @@SXP2        @@SEXP
022400200603     C                   END
022500200603      *
022600200603      ** CONVERT A SCALED RATE TO AN UNSCALED RATE
022700200603      *
022800200603     C                   CALLB     'ZA1160'
022900200603      *
023000200603      * INPUTS
023100200603     C                   PARM                    @@SEXP            1 0          scaling exponent
023200200603     C******             PARM      @@GSRT        @@INRT           12 8          CAP006 rate
023300200603     C                   PARM      @@GSRT        @@INRT           13 8          CAP006 rate
023400200603      *
023500200603      * OUTPUTS
023600200603     C******             PARM      *ZEROS        @@USRT           12 8                        CAP006
023700200603     C                   PARM      *ZEROS        @@USRT           13 8                        CAP006
023800200603      *
023900200603     C                   Z-ADD     @@USRT        @@GURT
024000200603     C*
024100200603     C     ZA0789        ENDSR
024200200603      *****************************************************************
024300200603      /EJECT
024400200603      *****************************************************************
024500200603      * ZA0790 - DETERMINE NUMBER OF NORMALLY QUOTED DECIMAL PLACES   *
024600200603      *****************************************************************
024700200603     C     ZA0790        BEGSR
024800200603      *
024900200603     C     @@NDP1        IFEQ      @@NDP2
025000200603     C     @@NDP1        ANDEQ     5
025100200603     C                   Z-ADD     5             @@NDP             1 0
025200200603     C                   GOTO      ZA0799
025300200603     C                   END
025400200603      *                                                                                       248024
025500200603      ** Compare normally-quoted decimal places of both currencies invovled;                  248024
025600200603      ** If both are the same, use either value as NQD...                                     248024
025700200603      *                                                                                       248024
025800200603     C     @@NDP1        IFEQ      @@NDP2                                                     248024
025900200603     C                   Z-ADD     @@NDP1        @@NDP                                        248024
026000200603     C                   GOTO      ZA0799                                                     248024
026100200603     C                   ENDIF                                                                248024
026200200603      *                                                                                       248024
026300200603      ** If they are not the same, use the lesser value of the two...                         248024
026400200603      *                                                                                       248024
026500200603     C     @@NDP1        IFNE      @@NDP2                                                     248024
026600200603     C     @@NDP1        IFLT      @@NDP2                                                     248024
026700200603     C                   Z-ADD     @@NDP1        @@NDP                                        248024
026800200603     C                   ELSE                                                                 248024
026900200603     C     @@NDP2        IFLT      @@NDP1                                                     248024
027000200603     C                   Z-ADD     @@NDP2        @@NDP                                        248024
027100200603     C                   ENDIF                                                                248024
027200200603     C                   ENDIF                                                                248024
027300200603     C                   GOTO      ZA0799                                                     248024
027400200603     C                   ENDIF                                                                248024
027500200603     C*
027600200603     C     @@IRAT        IFGE      100
027700200603     C                   Z-ADD     2             @@NDP
027800200603     C                   ELSE
027900200603     C     @@IRAT        IFLT      100
028000200603     C     @@IRAT        ANDGE     20
028100200603     C*******************Z-ADD     3             @@NDP                          143747
028200200603     C                   Z-ADD     2             @@NDP                          143747
028300200603     C                   ELSE
028400200603     C     @@IRAT        IFLT      20
028500200603     C     @@IRAT        ANDGE     1
028600200603     C                   Z-ADD     4             @@NDP
028700200603     C                   ELSE
028800200603     C     @@IRAT        IFLT      1
028900200603     C*******************Z-ADD     5             @@NDP                          143747
029000200603     C**********         Z-ADD     4             @@NDP                              143747 BUG23050A
029100200603     C                   Z-ADD     5             @@NDP                                     BUG23050A
029200200603     C                   END
029300200603     C                   END
029400200603     C                   END
029500200603     C                   END
029600200603      *
029700200603     C     ZA0799        ENDSR
029800200603      *****************************************************************
029900200603      /EJECT
030000200603      *****************************************************************
030100200603      * *INZSR - Initial processing                                   *
030200200603      *****************************************************************
030300200603     C     *INZSR        BEGSR
030400200603      *
030500200603      **  Parameters passed into the program
030600200603      *
030700200603     C     *ENTRY        PLIST
030800200603      *
030900200603      * INPUTS
031000200603      *
031100200603     C                   PARM                    DDBCCY            3            buy ccy
031200200603     C                   PARM                    DDSCCY            3            sell ccy
031300200603      *
031400200603      * ICD
031500200603     C                   PARM                    BNCYDL            3            sell ccy
031600200603      *
031700200603     C                   PARM                    @@IRAT           13 8          exchange rate
031800200603     C                   PARM                    @@DMD1            1            1st ccy ml/dv ind
031900200603     C                   PARM                    @@FPNT            7 2          forward points
032000200603      *
032100200603     C                   PARM                    @@SCAL            1            scale rate?
032200200603      *
032300200603     C                   PARM                    @@NDP1            1 0          norm quot decs
032400200603     C                   PARM                    @@SXP1                         scaling exponent
032500200603      *
032600200603     C                   PARM                    @@NDP2            1 0          norm quot decs
032700200603     C                   PARM                    @@SXP2                         scaling exponent
032800200603      *
032900200603      * OUTPUTS
033000200603      *
033100200603     C                   PARM                    @@GSRT           13 8          gross scaled rate
033200200603     C                   PARM                    @@GURT           13 8          gross unscld rate
033300200603      *
033400200603     C                   ENDSR
033500200603     C*****************************************************************
033600200603      /EJECT
033700200603      *****************************************************************
033800200603      ** Program, module and procedure names for database error processing.
033900200603      ** =================================================================
034000200603      ** The following /COPY sets these values, and also defines LDA as
034100200603      ** an external data area
034200200603      ********************************************************************
034300200603     C/COPY ZACPYSRC,PSSR_ILE
034400200603      ********************************************************************
034500200603**  CPY@
034600200603(c) Finastra International Limited 2001
034700200603**   @@AY   - Array of powers of 10.
0348002006030000000001
0349002006030000000010
0350002006030000000100
0351002006030000001000
0352002006030000010000
0353002006030000100000
0354002006030001000000
0355002006030010000000
0356002006030100000000
0357002006031000000000
