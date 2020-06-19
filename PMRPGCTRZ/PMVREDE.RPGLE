000100200529     H DEBUG
000200200529     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200529      *****************************************************************
000400200529/*STD *  RPGBASEMOD                                                   *
000500200529/*EXI *  TEXT('Midas PM Validate Portfolio Performnce Rpt Details')   *
000600200529      *****************************************************************
000700200529      *                                                               *
000800200529      *  Midas - Portfolio Management Module                          *
000900200529      *                                                               *
001000200529      *  PMVREDE    - Validate Portfolio Performance Report           *
001100200529      *               Requirements:                                   *
001200200529      *               - Report Past Year Performance ?                *
001300200529      *               - Tax Year Start Month                          *
001400200529      *               - Additional Performance Period                 *
001500200529      *               - Performance Start Date                        *
001600200529      *               - Performance Net/Gross of Tax                  *
001700200529      *                                                               *
001800200529      *  (c) Finastra International Limited 2001                      *
001900200529      *                                                               *
002000200529      *    This source is centrally supported and must ONLY be        *
002100200529      *    amended by Core Development Personnel.                     *
002200200529      *                                                               *
002300200529      *    /COPY, Client or Country amendments must not be            *
002400200529      *    applied to this source.                                    *
002500200529      *                                                               *
002600200604      *  Last Amend No. 250228             Date 22May20               *
002700200529      *  Prev Amend No. MD046248           Date 27Oct17               *
002800200529      *                 CLE148             Date 23Jul12               *
002900200529      * Bank Fusion Midas 1.4 Base -----------------------------------*
003000200529      * Midas Plus 1.4 Base 04 ---------------------------------------*
003100200529      * Midas Plus 1.4 Base ------------------------------------------*
003200200529      * Midas Plus 1.3 ----------- Base ------------------------------*
003300200529      *                 CSD027             Date 09Dec05               *
003400200529      * Midas Release 4 --------------- Base -------------------------*
003500200529      * Midas DBA 3.02 -----------------------------------------------*
003600200529      *                 CAP033  *CREATE    Date 26Apr99               *
003700200529      *                                                               *
003800200529      *---------------------------------------------------------------*
003900200529      *                                                               *
004000200529      *  250228 - Recompile due to field change in PMPSTMQ0.          *
004100200529      *  MD046248 - Finastra Rebranding                               *
004200200529      *  CLE148 - Alpha Loan Reference (Recompile)                    *
004300200529      *  CSD027 - Conversion Of Customer Number to Alpha              *
004400200529      *  CAP033 - Conversion of PM inputs into modular structure to   *
004500200529      *           use as APIs.                                        *
004600200529      *                                                               *
004700200529      *****************************************************************
004800200529      *
004900200529      ** +--------------------------------------+
005000200529      ** ¦ F-specs                              ¦
005100200529      ** ¦ =======                              ¦
005200200529      ** +--------------------------------------+
005300200529      *
005400200529     FPMPSTMQ0  IF   E           K DISK    INFSR(*PSSR)
005500200529      *
005600200529      *****************************************************************
005700200529      /EJECT
005800200529      *****************************************************************
005900200529      *
006000200529      ** +--------------------------------------+
006100200529      ** ¦ Automatically included D-specs       ¦
006200200529      ** ¦ ==============================       ¦
006300200529      ** +--------------------------------------+
006400200529      *
006500200529      ** Standard D-specs
006600200529      ** ================
006700200529      **
006800200529      ** The following /COPY line includes the LDA layout,
006900200529      ** the copyright array definition,
007000200529      ** and the following named constants:
007100200529      **    True       logical = *on (for indcator processing)
007200200529      **    False      logical = *off (for indicator processing)
007300200529      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
007400200529      **                                    handler)
007500200529      ** and the following variables:
007600200529      **    RunBefore  1A (for the PSSR)
007700200529      *
007800200529      /COPY ZACPYSRC,STD_D_SPEC
007900200529      *
008000200529      ** Program Status Data Structure
008100200529      ** =============================
008200200529      ** The following /COPY line includes all the defined fields in the
008300200529      ** PSDS.  They have meaningful names, prefixed by 'PS'.
008400200529      *
008500200529      /COPY ZACPYSRC,PSDS
008600200529      *
008700200529      ** The following /COPY line includes all the definitions of the
008800200529      ** appended error arrays, including the named constant giving the size
008900200529      ** of the arrays.
009000200529      *
009100200529      /COPY ZACPYSRC,ERR_XARRYS
009200200529      *
009300200529      ** +--------------------------------------+
009400200529      ** ¦ End of automatically included D-specs¦
009500200529      ** ¦ =====================================¦
009600200529      ** +--------------------------------------+
009700200529      *
009800200529      *****************************************************************
009900200529      /EJECT
010000200529      *****************************************************************
010100200529      *
010200200529      ** +--------------------------------------+
010300200529      ** ¦ Manually included D-specs            ¦
010400200529      ** ¦ =========================            ¦
010500200529      ** +--------------------------------------+
010600200529      *
010700200529      ** +--------------------------------------+
010800200529      ** ¦ Named constants                      ¦
010900200529      ** ¦ ===============                      ¦
011000200529      ** +--------------------------------------+
011100200529      *
011200200529      ** +--------------------------------------+
011300200529      ** ¦ Arrays and Data Structures           ¦
011400200529      ** ¦ ==========================           ¦
011500200529      ** +--------------------------------------+
011600200529      *
011700200529      ** DDMMYY Date format
011800200529     D WDDMMYY         DS             6
011900200529     D   WDDMMDAY              1      2  0
012000200529     D   WDDMMMTH              3      4  0
012100200529     D   WDDMMYR               5      6  0
012200200529      *
012300200529      ** MMDDYY Date format
012400200529     D WMMDDYY         DS             6
012500200529     D   WMMDDMTH              1      2  0
012600200529     D   WMMDDDAY              3      4  0
012700200529     D   WMMDDYR               5      6  0
012800200529      *
012900200529      ** +--------------------------------------+
013000200529      ** ¦ Declared variables                   ¦
013100200529      ** ¦ ==================                   ¦
013200200529      ** +--------------------------------------+
013300200529      *
013400200529      ** Index for arrays of error message ids etc
013500200529     D IDX             S              3P 0
013600200529      *
013700200529      ** Tax Year Start Month
013800200529     D P1PNTYSM        S              2S 0
013900200529      *
014000200529      ** Date work variable
014100200529     D WWDATE          S              6S 0
014200200529      *
014300200529      ** +--------------------------------------+
014400200529      ** ¦ End of D-specs                       ¦
014500200529      ** ¦ ==============                       ¦
014600200529      ** +--------------------------------------+
014700200529      *
014800200529      *****************************************************************
014900200529      /EJECT
015000200529      *****************************************************************
015100200529      *
015200200529      ** +--- Start of Main processing -------------------------------+
015300200529      ** ¦                                                            ¦
015400200529      ** ¦ *INZSR is executed at program activation.                  ¦
015500200529      ** ¦                                                            ¦
015600200529      ** +------------------------------------------------------------+
015700200529      *
015800200529     C                   MOVE      *BLANK        RETCODEIN
015900200529      *
016000200529     C                   MOVE      *BLANK        FLDNAMXAR
016100200529     C                   MOVE      *BLANK        MSGIDXAR
016200200529     C                   MOVE      *BLANK        MSGDTAXAR
016300200529     C                   Z-ADD     0             IDX
016400200529      *
016500200529     C                   Z-ADD     0             WTYSM             2 0
016600200529     C                   Z-ADD     0             WPSDT             5 0
016700200529     C                   MOVE      *BLANK        W_TYSMZ           1
016800200529      *
016900200529      ** Validate Performance Report Requirements.
017000200529      *
017100200529     C                   EXSR      SRPERFORM
017200200529      *
017300200529     C     OKRPYP        IFEQ      'N'
017400200529     C     OKTYSM        OREQ      'N'
017500200529     C     OKADPP        OREQ      'N'
017600200529     C     OKPSDT        OREQ      'N'
017700200529     C     OKPMNG        OREQ      'N'
017800200529     C                   EVAL      RETCODEIN = 'ERROR'
017900200529     C                   ENDIF
018000200529      *
018100200529     C     OKRPYP        IFNE      'N'
018200200529     C                   EVAL      P1PNRPYP = DDRPYP
018300200529     C                   ENDIF
018400200529      *
018500200529     C     OKTYSM        IFNE      'N'
018600200529     C                   MOVE      WTYSM         P1PNTYSM
018700200529     C                   ENDIF
018800200529      *
018900200529     C     OKADPP        IFNE      'N'
019000200529     C                   EVAL      P1PNADPP = DDADPP
019100200529     C                   ENDIF
019200200529      *
019300200529     C     OKPSDT        IFNE      'N'
019400200529     C                   EVAL      P1PNPSDT = WPSDT
019500200529     C                   ENDIF
019600200529      *
019700200529     C     OKPMNG        IFNE      'N'
019800200529     C                   EVAL      P1PNPMNG = DDPMNG
019900200529     C                   ENDIF
020000200529      *
020100200529     C                   RETURN
020200200529      *
020300200529      *****************************************************************
020400200529      /EJECT
020500200529      *****************************************************************
020600200529      *                                                               *
020700200529      *  SRPERFORM - Validate Portfolio Performance Report            *
020800200529      *              Requirements                                     *
020900200529      *                                                               *
021000200529      *****************************************************************
021100200529      *
021200200529     C     SRPERFORM     BEGSR
021300200529      *
021400200529      ** Validate Report Past Year Performance.
021500200529      *
021600200529     C                   EXSR      SRRPYP
021700200529      *
021800200529      ** Validate Tax Year Start Month.
021900200529      *
022000200529     C                   EXSR      SRTYSM
022100200529      *
022200200529      ** Validate Additional Performance Period.
022300200529      *
022400200529     C                   EXSR      SRADPP
022500200529      *
022600200529      ** If no errors in the validation of Performance Periods,
022700200529      ** validate Performance Start Date.
022800200529      *
022900200529     C     OKRPYP        IFNE      'N'
023000200529     C     OKTYSM        ANDNE     'N'
023100200529     C     OKADPP        ANDNE     'N'
023200200529      *
023300200529     C                   EXSR      SRPSDT
023400200529     C                   ENDIF
023500200529      *
023600200529      ** Validate Performance Net/Gross of Tax.
023700200529      *
023800200529     C                   EXSR      SRPMNG
023900200529      *
024000200529     C                   ENDSR
024100200529      *
024200200529      *****************************************************************
024300200529      /EJECT
024400200529      *****************************************************************
024500200529      *                                                               *
024600200529      *  SRRPYP - Validate Portfolio Report Past Year Performance     *
024700200529      *                                                               *
024800200529      *****************************************************************
024900200529      *
025000200529     C     SRRPYP        BEGSR
025100200529      *
025200200529     C     DDRPYP        IFNE      'Y'
025300200529     C     DDRPYP        ANDNE     'N'
025400200529     C                   MOVE      'N'           OKRPYP
025500200529     C                   ADD       1             IDX
025600200529     C                   MOVEL     'DDRPYP'      FLDNAMXAR(IDX)
025700200529     C                   MOVEL     'PM11271'     MSGIDXAR(IDX)
025800200529     C                   ENDIF
025900200529      *
026000200529     C                   ENDSR
026100200529      *
026200200529      *****************************************************************
026300200529      /EJECT
026400200529      *****************************************************************
026500200529      *                                                               *
026600200529      *  SRTYSM - Validate Portfolio Tax Year Start Month             *
026700200529      *                                                               *
026800200529      *****************************************************************
026900200529      *
027000200529     C     SRTYSM        BEGSR
027100200529      *
027200200529     C     DDTYSM        IFNE      *BLANKS
027300200529      *
027400200529      ** Tax Year Start Month must be in the range 01 - 12.
027500200529      *
027600200529     C                   TESTN                   DDTYSM               0102
027700200529     C                   MOVE      DDTYSM        W_TYSMZ
027800200529     C                   TESTZ                   W_TYSMZ                  03
027900200529      *
028000200529     C     *IN01         IFEQ      '1'
028100200529     C     *IN03         ANDEQ     '1'
028200200529     C     *IN02         OREQ      '1'
028300200529     C     *IN03         ANDEQ     '1'
028400200529      *
028500200529     C                   MOVE      DDTYSM        WTYSM
028600200529      *
028700200529     C     WTYSM         IFLT      01
028800200529     C     WTYSM         ORGT      12
028900200529     C                   MOVE      'N'           OKTYSM
029000200529     C                   ADD       1             IDX
029100200529     C                   MOVEL     'DDTYSM'      FLDNAMXAR(IDX)
029200200529     C                   MOVEL     'PM11254'     MSGIDXAR(IDX)
029300200529     C                   ENDIF
029400200529      *
029500200529     C                   ELSE
029600200529      *
029700200529     C                   MOVE      'N'           OKTYSM
029800200529     C                   ADD       1             IDX
029900200529     C                   MOVEL     'DDTYSM'      FLDNAMXAR(IDX)
030000200529     C                   MOVEL     'PM11254'     MSGIDXAR(IDX)
030100200529     C                   ENDIF
030200200529      *
030300200529     C                   ENDIF
030400200529      *
030500200529     C                   ENDSR
030600200529      *
030700200529      *****************************************************************
030800200529      /EJECT
030900200529      *****************************************************************
031000200529      *                                                               *
031100200529      *  SRADPP - Validate Portfolio Additional Performance Period    *
031200200529      *                                                               *
031300200529      *****************************************************************
031400200529      *
031500200529     C     SRADPP        BEGSR
031600200529      *
031700200529     C     DDADPP        IFNE      *BLANKS
031800200529      *
031900200529      ** If Additional Performance Period is entered, entry must
032000200529      ** 'H' or 'Q'.
032100200529      *
032200200529     C     DDADPP        IFNE      'H'
032300200529     C     DDADPP        ANDNE     'Q'
032400200529     C                   MOVE      'N'           OKADPP
032500200529     C                   ADD       1             IDX
032600200529     C                   MOVEL     'DDADPP'      FLDNAMXAR(IDX)
032700200529     C                   MOVEL     'PM11255'     MSGIDXAR(IDX)
032800200529     C                   ENDIF
032900200529      *
033000200529     C                   ENDIF
033100200529      *
033200200529     C                   ENDSR
033300200529      *
033400200529      *****************************************************************
033500200529      /EJECT
033600200529      *****************************************************************
033700200529      *                                                               *
033800200529      *  SRPSDT - Validate Portfolio Performance Start Date           *
033900200529      *                                                               *
034000200529      *****************************************************************
034100200529      *
034200200529     C     SRPSDT        BEGSR
034300200529      *
034400200529      ** If a Performance Period has been selected, entry is
034500200529      ** mandatory.
034600200529      *
034700200529     C     DDRPYP        IFEQ      'Y'
034800200529     C     DDTYSM        ORNE      *BLANKS
034900200529     C     DDADPP        OREQ      'Q'
035000200529     C     DDADPP        OREQ      'H'
035100200529      *
035200200529     C     DDPSDT        IFEQ      *BLANKS
035300200529     C                   MOVE      'N'           OKPSDT
035400200529     C                   ADD       1             IDX
035500200529     C                   MOVEL     'DDPSDT'      FLDNAMXAR(IDX)
035600200529     C                   MOVEL     'PM11256'     MSGIDXAR(IDX)
035700200529      *
035800200529      ** No further validation is necessary if field is in error.
035900200529      *
036000200529     C                   goto      ESRPSDT
036100200529     C                   ENDIF
036200200529     C                   ENDIF
036300200529      *
036400200529      ** If no Performance Period has been selected, Performance
036500200529      ** Start Date must be blank.
036600200529      *
036700200529     C     DDRPYP        IFEQ      'N'
036800200529     C     DDTYSM        ANDEQ     *BLANKS
036900200529     C     DDADPP        ANDEQ     *BLANKS
037000200529      *
037100200529     C     DDPSDT        IFNE      *BLANKS
037200200529     C                   MOVE      'N'           OKPSDT
037300200529     C                   ADD       1             IDX
037400200529     C                   MOVEL     'DDPSDT'      FLDNAMXAR(IDX)
037500200529     C                   MOVEL     'PM11272'     MSGIDXAR(IDX)
037600200529      *
037700200529      ** No further validation is necessary if field is in error.
037800200529      *
037900200529     C                   goto      ESRPSDT
038000200529     C                   ENDIF
038100200529      *
038200200529      ** If no entry, default Performance Start Date to 99999
038300200529      ** and bypass remaining validation for this field.
038400200529      *
038500200529     C                   Z-ADD     99999         WPSDT
038600200529     C                   goto      ESRPSDT
038700200529     C                   ENDIF
038800200529      *
038900200529      ** If entry is mandatory and has been supplied, it must
039000200529      ** be a valid date.
039100200529      *
039200200529     C                   Z-ADD     0             PDAYNO
039300200529      *
039400200529     C                   CALLB     'ZAVDATE'
039500200529     C                   PARM      *BLANK        RETCODEOUT
039600200529     C                   PARM      DDPSDT        PDATE             6
039700200529     C                   PARM                    BJDFIN
039800200529     C                   PARM                    PDAYNO            5 0
039900200529      *
040000200529     C     RETCODEOUT    IFEQ      'Error'
040100200529     C                   MOVE      'N'           OKPSDT
040200200529     C                   ADD       1             IDX
040300200529     C                   MOVEL     'DDPSDT'      FLDNAMXAR(IDX)
040400200529     C                   MOVEL     'PM11257'     MSGIDXAR(IDX)
040500200529      *
040600200529      ** No further validation is necessary if field is in error.
040700200529      *
040800200529     C                   goto      ESRPSDT
040900200529     C                   ENDIF
041000200529      *
041100200529     C                   Z-ADD     PDAYNO        WPSDT
041200200529      *
041300200529      ** For insert, entry must be greater than or equal to
041400200529      ** rundate (or Date Opened).
041500200529      *
041600200529     C     DDACTN        IFEQ      'I'
041700200529      *
041800200529     C     WPSDT         IFLT      BJRDNB
041900200529     C                   MOVE      'N'           OKPSDT
042000200529     C                   ADD       1             IDX
042100200529     C                   MOVEL     'DDPSDT'      FLDNAMXAR(IDX)
042200200529     C                   MOVEL     'PM11267'     MSGIDXAR(IDX)
042300200529     C                   ENDIF
042400200529      *
042500200529      ** No further validation is necessary.
042600200529      *
042700200529     C                   goto      ESRPSDT
042800200529     C                   ENDIF
042900200529      *
043000200529      ** For Amend, validate Performance Start Date if it has
043100200529      ** been changed.
043200200529      *
043300200529     C     DDACTN        IFEQ      'A'
043400200529     C     WPSDT         ANDNE     OP1PNPSDT
043500200529      *
043600200529      ** Entry must not be less than rundate.
043700200529      *
043800200529     C     WPSDT         IFLT      BJRDNB
043900200529     C                   MOVE      'N'           OKPSDT
044000200529     C                   ADD       1             IDX
044100200529     C                   MOVEL     'DDPSDT'      FLDNAMXAR(IDX)
044200200529     C                   MOVEL     'PM11260'     MSGIDXAR(IDX)
044300200529      *
044400200529      ** No further validation is necessary.
044500200529      *
044600200529     C                   goto      ESRPSDT
044700200529     C                   ENDIF
044800200529      *
044900200529      ** Entry can be during current month if Performance is not
045000200529      ** yet active during this month.
045100200529      *
045200200529     C     WPSDT         IFLE      WENDMTH
045300200529      *
045400200529     C                   MOVEL     DDPSDT        WAPSDT            4
045500200529     C                   MOVEL     DDCSNM        KCNUM
045600200529     C                   MOVE      DDPREF        KPTFR
045700200529      *
045800200529     C     BJDFIN        IFEQ      'M'
045900200529     C                   MOVEL     WAPSDT        KMTH
046000200529     C                   ELSE
046100200529     C                   MOVE      WAPSDT        KMTH
046200200529     C                   ENDIF
046300200529      *
046400200529     C     WKEY          CHAIN     PMPSTMQ0                           01
046500200529      *
046600200529     C     *IN01         IFEQ      '0'
046700200529     C                   MOVE      'N'           OKPSDT
046800200529     C                   ADD       1             IDX
046900200529     C                   MOVEL     'DDPSDT'      FLDNAMXAR(IDX)
047000200529     C                   MOVEL     'PM11260'     MSGIDXAR(IDX)
047100200529     C                   ENDIF
047200200529      *
047300200529     C                   ENDIF
047400200529      *
047500200529     C                   ENDIF
047600200529      *
047700200529     C     ESRPSDT       ENDSR
047800200529      *
047900200529      *****************************************************************
048000200529      /EJECT
048100200529      *****************************************************************
048200200529      *                                                               *
048300200529      *  SRPMNG - Validate Portfolio Performance Net/Gross of Tax     *
048400200529      *                                                               *
048500200529      *****************************************************************
048600200529      *
048700200529     C     SRPMNG        BEGSR
048800200529      *
048900200529      ** If Performance Net/Gross of Tax is entered, it must be
049000200529      ** 'N' or 'G'.
049100200529      *
049200200529     C     DDPMNG        IFNE      *BLANKS
049300200529      *
049400200529     C     DDPMNG        IFNE      'N'
049500200529     C     DDPMNG        ANDNE     'G'
049600200529     C                   MOVE      'N'           OKPMNG
049700200529     C                   ADD       1             IDX
049800200529     C                   MOVEL     'DDPMNG'      FLDNAMXAR(IDX)
049900200529     C                   MOVEL     'PM11258'     MSGIDXAR(IDX)
050000200529     C                   ENDIF
050100200529      *
050200200529     C                   ELSE
050300200529      *
050400200529      ** Entry is mandatory if one of the Performance Periods
050500200529      ** has been defined.
050600200529      *
050700200529     C     DDRPYP        IFEQ      'Y'
050800200529     C     DDTYSM        ORNE      *BLANKS
050900200529     C     DDADPP        OREQ      'H'
051000200529     C     DDADPP        OREQ      'Q'
051100200529      *
051200200529     C                   MOVE      'N'           OKPMNG
051300200529     C                   ADD       1             IDX
051400200529     C                   MOVEL     'DDPMNG'      FLDNAMXAR(IDX)
051500200529     C                   MOVEL     'PM11269'     MSGIDXAR(IDX)
051600200529     C                   ENDIF
051700200529      *
051800200529     C                   ENDIF
051900200529      *
052000200529     C                   ENDSR
052100200529      *
052200200529      *****************************************************************
052300200529      /EJECT
052400200529      *****************************************************************
052500200529      *                                                               *
052600200529      *  *INZSR - Program Initialisation                              *
052700200529      *         - This subroutine runs automatically for program      *
052800200529      *           initialisation.                                     *
052900200529      *                                                               *
053000200529      *****************************************************************
053100200529      *
053200200529     C     *INZSR        BEGSR
053300200529      *
053400200529     C     *ENTRY        PLIST
053500200529      *
053600200529      ** INPUT
053700200529      ** =====
053800200529      *
053900200529      ** Return Code
054000200529     C                   PARM                    RETCODEIN
054100200529      *
054200200529      ** Portfolio Report Past Year Performance - incoming
054300200529     C                   PARM                    DDRPYP            1
054400200529      *
054500200529      ** Portfolio Tax Year Start Month - incoming
054600200529     C                   PARM                    DDTYSM            2
054700200529      *
054800200529      ** Portfolio Additional Performance Period - incoming
054900200529     C                   PARM                    DDADPP            1
055000200529      *
055100200529      ** Portfolio Performance Start Date - incoming
055200200529     C                   PARM                    DDPSDT            6
055300200529      *
055400200529      ** Portfolio Performance Net/Gross of Tax - incoming
055500200529     C                   PARM                    DDPMNG            1
055600200529      *
055700200529      ** Action Code - incoming
055800200529     C                   PARM                    DDACTN            1
055900200529      *
056000200529      ** Customer - incoming
056100200529     C                   PARM                    DDCSNM           10
056200200529      *
056300200529      ** Portfolio Reference - incoming
056400200529     C                   PARM                    DDPREF            4
056500200529      *
056600200529      ** Original Performance Start Date
056700200529     C                   PARM                    OP1PNPSDT         5 0
056800200529      *
056900200529      ** STANDING DATA
057000200529      ** =============
057100200529      *
057200200529      ** SDBANK - System Rundate
057300200529     C                   PARM                    BJRDNB            5 0
057400200529      *
057500200529      ** SDBANK - Date Format
057600200529     C                   PARM                    BJDFIN            1
057700200529      *
057800200529      ** OUTPUT
057900200529      ** ======
058000200529      *
058100200529      ** Error fields/message IDs/message data (arrays) from/to caller
058200200529     C                   PARM                    FLDNAMXAR
058300200529     C                   PARM                    MSGIDXAR
058400200529     C                   PARM                    MSGDTAXAR
058500200529      *
058600200529      ** Portfolio Report Past Year Performance - OK indicator
058700200529     C                   PARM                    OKRPYP            1
058800200529      *
058900200529      ** Portfolio Tax Year Start Month - OK indicator
059000200529     C                   PARM                    OKTYSM            1
059100200529      *
059200200529      ** Portfolio Additional Performance Period - OK indicator
059300200529     C                   PARM                    OKADPP            1
059400200529      *
059500200529      ** Portfolio Performance Start Date - OK indicator
059600200529     C                   PARM                    OKPSDT            1
059700200529      *
059800200529      ** Portfolio Performance Net/Gross of Tax - OK indicator
059900200529     C                   PARM                    OKPMNG            1
060000200529      *
060100200529      ** Portfolio Report Past Year Performance - for file update
060200200529     C                   PARM                    P1PNRPYP          1
060300200529      *
060400200529      ** Portfolio Tax Year Start Month - for file update
060500200529     C                   PARM                    P1PNTYSM
060600200529      *
060700200529      ** Portfolio Additional Performance Period - for file update
060800200529     C                   PARM                    P1PNADPP          1
060900200529      *
061000200529      ** Portfolio Performance Start Date - for file update
061100200529     C                   PARM                    P1PNPSDT          5 0
061200200529      *
061300200529      ** Portfolio Performance Net/Gross of Tax - for file update
061400200529     C                   PARM                    P1PNPMNG          1
061500200529      *
061600200529      ** Calculate end of the current month.
061700200529      *
061800200529     C                   MOVE      BJRDNB        ZDAYNO
061900200529     C                   Z-ADD     0             ZDATE
062000200529      *
062100200529     C                   CALLB     'ZDATE2'
062200200529     C                   PARM                    ZDAYNO            5 0
062300200529     C                   PARM      BJDFIN        PFMT              1
062400200529     C                   PARM                    ZDATE             6 0
062500200529     C                   PARM      *BLANKS       ZADATE            7
062600200529      *
062700200529     C     BJDFIN        IFEQ      'M'
062800200529     C                   MOVE      ZDATE         WMMDDYY
062900200529     C                   Z-ADD     WMMDDMTH      WMONTH            2 0
063000200529     C                   Z-ADD     WMMDDYR       WYEAR             2 0
063100200529     C                   ELSE
063200200529     C                   MOVE      ZDATE         WDDMMYY
063300200529     C                   Z-ADD     WDDMMMTH      WMONTH
063400200529     C                   Z-ADD     WDDMMYR       WYEAR
063500200529     C                   ENDIF
063600200529      *
063700200529      ** Set date to first day of next month.
063800200529      *
063900200529     C                   Z-ADD     1             WDAY              2 0
064000200529     C                   ADD       1             WMONTH
064100200529      *
064200200529     C     WMONTH        IFEQ      13
064300200529     C                   Z-ADD     1             WMONTH
064400200529     C                   ADD       1             WYEAR
064500200529     C                   ENDIF
064600200529      *
064700200529      ** Move new values to correct date format.
064800200529      *
064900200529     C                   MOVE      *BLANKS       WWRK4             4 0
065000200529     C     BJDFIN        IFEQ      'M'
065100200529     C                   MOVE      WDAY          WWRK4
065200200529     C                   MOVEL     WMONTH        WWRK4
065300200529     C                   ELSE
065400200529     C                   MOVEL     WDAY          WWRK4
065500200529     C                   MOVE      WMONTH        WWRK4
065600200529     C                   ENDIF
065700200529      *
065800200529     C                   MOVEL     WWRK4         WDATE             6 0
065900200529     C                   MOVE      WYEAR         WDATE
066000200529      *
066100200529      ** Convert first day of next month to Midas day no.
066200200529      *
066300200529     C                   Z-ADD     0             PDAYNO
066400200529     C                   Z-ADD     WDATE         WWDATE
066500200529     C                   MOVE      WWDATE        PDATE
066600200529      *
066700200529     C                   CALLB     'ZAVDATE'
066800200529     C                   PARM      *BLANK        RETCODEOUT
066900200529     C                   PARM                    PDATE
067000200529     C                   PARM                    BJDFIN
067100200529     C                   PARM                    PDAYNO
067200200529      *
067300200529      ** Subtract 1 day to converted date to get end of current
067400200529      ** month.
067500200529      *
067600200529     C     PDAYNO        SUB       1             WENDMTH           5 0
067700200529      *
067800200529     C     WKEY          KLIST
067900200529     C**********         KFLD                    KCNUM             6 0                        CSD027
068000200529     C                   KFLD                    KCNUM             6                          CSD027
068100200529     C                   KFLD                    KPTFR             4
068200200529     C                   KFLD                    KMTH              2
068300200529      *
068400200529      ** Program, module and procedure names for database error processing
068500200529      ** =================================================================
068600200529      ** The following /COPY sets these values.
068700200529      *
068800200529      /COPY ZACPYSRC,DBFIELDS
068900200529      *
069000200529     C                   ENDSR
069100200529      *
069200200529      *****************************************************************
069300200529      /EJECT
069400200529      *****************************************************************
069500200529      *
069600200529      ** The following /COPY contains the standard program status
069700200529      ** subroutine, including a bound call to the DBERRCTL module.
069800200529      *
069900200529      /COPY ZACPYSRC,PSSR_ILE
070000200529      *
070100200529      *****************************************************************
070200200529      /EJECT
070300200529      *****************************************************************
070400200529      *
070500200529**  CPY@
070600200529(c) Finastra International Limited 2001
