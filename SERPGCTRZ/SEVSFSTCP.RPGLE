000100200604     H DEBUG
000200200604     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200604      *****************************************************************
000400200604/*STD *  RPGBASEMOD                                                   *
000500200604/*EXI *  TEXT('Midas SE Validate first coupon date')                  *
000600200604      *****************************************************************
000700200604      *                                                               *
000800200604      *  Midas - Securities Trading Module                            *
000900200604      *                                                               *
001000200604      *  SEVSFSTCP - Validate First Coupon Date                       *
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
003200200604      *                 CSE071             Date 19Jul05               *
003300200604      *                 CAS006             Date 21Jan03               *
003400200604      * Midas Release 4.01 -------------------------------------------*
003500200604      *                 CSE031             Date 05Dec01               *
003600200604      * Midas Release 4 --------------- Base -------------------------*
003700200604      * Midas DBA 3.05 -----------------------------------------------*
003800200604      *                 CSD006             Date 14May01               *
003900200604      *                 CAP060             Date 14May01               *
004000200604      * Midas DBA 3.03 -----------------------------------------------*
004100200604      *                 CAP137  *CREATE    Date 07Feb00               *
004200200604      *                                                               *
004300200604      *---------------------------------------------------------------*
004400200604      *                                                               *
004500200604      *  261824 - Error messages appear which should not be as field  *
004600200604      *           being validate is valid when compare to the input - *
004700200604      *           Maturity Date. Fix is to make sure that field will  *
004800200604      *           be validated only if Maturity Date is non-zero.     *
004900200604      *  MD046248 - Finastra Rebranding                               *
005000200604      *  CRE073 - Interest Rate Rounding (Recompile)                  *
005100200604      *  CSD027 - Conversion Of Customer Number to Alpha              *
005200200604      *  CSE071 - Multiple Holidays Re Securities                     *
005300200604      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
005400200604      *  CSE031 - Coupon Fixing for Floating Rate Notes               *
005500200604      *  CSD006 - Market Data Feeds (recompile)                       *
005600200604      *  CAP060 - Midas APIs, Security Prices Full API (recompile)    *
005700200604      *  CAP137 - Conversion of SE Security inputs into modular       *
005800200604      *           structure to use as APIs.                           *
005900200604      *                                                               *
006000200604      *****************************************************************
006100200604      *
006200200604      ** +--------------------------------------+
006300200604      ** ¦ F-specs                              ¦
006400200604      ** ¦ =======                              ¦
006500200604      ** +--------------------------------------+
006600200604      *
006700200604      *****************************************************************
006800200604      /EJECT
006900200604      *****************************************************************
007000200604      *
007100200604      ** +--------------------------------------+
007200200604      ** ¦ Automatically included D-specs       ¦
007300200604      ** ¦ ==============================       ¦
007400200604      ** +--------------------------------------+
007500200604      *
007600200604      ** Standard D-specs
007700200604      ** ================
007800200604      **
007900200604      ** The following /COPY line includes the LDA layout,
008000200604      ** the copyright array definition,
008100200604      ** and the following named constants:
008200200604      **    True       logical = *On (for indicator processing)
008300200604      **    False      logical = *Off (for indicator processing)
008400200604      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
008500200604      **                                    handler)
008600200604      ** and the following variables:
008700200604      **    RunBefore  1A (for the PSSR)
008800200604      *
008900200604      /COPY ZACPYSRC,STD_D_SPEC
009000200604      *
009100200604      ** Program Status Data Structure
009200200604      ** =============================
009300200604      ** The following /COPY line includes all the defined fields in the
009400200604      ** PSDS.  They have meaningful names, prefixed by 'PS'.
009500200604      *
009600200604      /COPY ZACPYSRC,PSDS
009700200604      *
009800200604      ** The following /COPY line includes all the definitions of the
009900200604      ** appended error arrays, including the named constant giving the size
010000200604      ** of the arrays.
010100200604      *
010200200604      /COPY ZACPYSRC,ERR_XARRYS
010300200604      *
010400200604      ** +--------------------------------------+
010500200604      ** ¦ End of automatically included D-specs¦
010600200604      ** ¦ =====================================¦
010700200604      ** +--------------------------------------+
010800200604      *
010900200604      *****************************************************************
011000200604      /EJECT
011100200604      *****************************************************************
011200200604      *
011300200604      ** +--------------------------------------+
011400200604      ** ¦ Manually included D-specs            ¦
011500200604      ** ¦ =========================            ¦
011600200604      ** +--------------------------------------+
011700200604      *
011800200604      ** +--------------------------------------+
011900200604      ** ¦ Named constants                      ¦
012000200604      ** ¦ ===============                      ¦
012100200604      ** +--------------------------------------+
012200200604      *
012300200604      ** +--------------------------------------+
012400200604      ** ¦ Arrays and Data Structures           ¦
012500200604      ** ¦ ==========================           ¦
012600200604      ** +--------------------------------------+
012700200604      *
012800200604      ** Securities screen 2 details from incoming transaction
012900200604      ** - screen format
013000200604     D NwSE2ScnFmt   E DS                  EXTNAME(SESEC2PD)
013100200604      *                                                                                       CSE071
013200200604      ** Securities screen 6 details from incoming transaction                                CSE071
013300200604      ** - screen format                                                                      CSE071
013400200604     D NwSE6ScnFmt   E DS                  EXTNAME(SESEC6PD)                                  CSE071
013500200604      *
013600200604      ** Securities for file update - file format
013700200604     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
013800200604      *
013900200604      ** Securities screen 2 error indicators
014000200604     D SEESEC2       E DS                  EXTNAME(SEESEC2PD)
014100200604      *
014200200604      ** DS for the coupon/rate days
014300200604     D WSCD            S              4A   DIM(12)
014400200604      *
014500200604      ** DS for the coupon/rate indicators array
014600200604     D WSCR            S              1A   DIM(12)
014700200604      *
014800200604      ** +--------------------------------------+
014900200604      ** ¦ Declared variables                   ¦
015000200604      ** ¦ ==================                   ¦
015100200604      ** +--------------------------------------+
015200200604      *
015300200604      ** Index for arrays of error message ids, etc.
015400200604     D IDx             S              3P 0
015500200604      *
015600200604      ** Index for arrays of Warning error message ids, etc.
015700200604     D WIx             S              3P 0
015800200604      *
015900200604      ** Index for Coupon/Rate Days Array
016000200604     D Wx              S              2P 0
016100200604      *
016200200604      ** Parameters for ZDATE1
016300200604
016400200604     D PDate           S              6A
016500200604     D PDaynoOut       S              5P 0
016600200604     D ErrorFlag       S              1A
016700200604
016800200604      ** Parameters for ZCHKH
016900200604     D PDateIn         S              5P 0
017000200604     D PCurrency       S              3A
017100200604     D PLocation       S              3A
017200200604     D PHolInd         S              1A
017300200604      *
017400200604      ** Parameters for ZFWDT
017500200604     D PDaysFwd        S              2P 0
017600200604      *
017700200604      ** Parameters for ZDATE2
017800200604     D PZDate          S              6P 0
017900200604     D PZaDate         S              7A
018000200604      *
018100200604      ** Parameters for ZNCD
018200200604     D  PFCPN          S              5P 0
018300200604     D  PCDArr         S             48A
018400200604     D  PCRArr         S             12A
018500200604     D  PEvtCd         S              5P 0
018600200604     D  PNxtCd         S              5P 0
018700200604
018800200604     D WFstCpn         S              5P 0
018900200604     D WKFCPN          S              4A
019000200604     D PCpnRt          S             15P 0
019100200604     D PPROT           S              1A
019200200604     D CSE005          S              1A
019300200604     D CSE031          S              1A                                                      CSE031
019400200604     D CSE071          S              1A                                                      CSE071
019500200604     D BJDFIN          S              1A
019600200604     D WLoop           S              1A
019700200604      *
019800200604      ** +--------------------------------------+
019900200604      ** ¦ End of D-specs                       ¦
020000200604      ** ¦ ==============                       ¦
020100200604      ** +--------------------------------------+
020200200604      *
020300200604      *****************************************************************
020400200604      /EJECT
020500200604      *****************************************************************
020600200604      *
020700200604      ** +--- Start of Main processing -------------------------------+
020800200604      ** ¦                                                            ¦
020900200604      ** ¦ *INZSR is executed at program activation.                  ¦
021000200604      ** ¦                                                            ¦
021100200604      ** +------------------------------------------------------------+
021200200604      *
021300200604      ** Initialise work variables.
021400200604     C                   EVAL      IDx = 0
021500200604     C                   EVAL      WIx = 0
021600200604     C                   EVAL      WFstCpn = 0
021700200604      *
021800200604      ** Load array
021900200604      *
022000200604     C                   MOVE      DDCD01        WSCD(1)
022100200604     C                   MOVE      DDCD02        WSCD(2)
022200200604     C                   MOVE      DDCD03        WSCD(3)
022300200604     C                   MOVE      DDCD04        WSCD(4)
022400200604     C                   MOVE      DDCD05        WSCD(5)
022500200604     C                   MOVE      DDCD06        WSCD(6)
022600200604     C                   MOVE      DDCD07        WSCD(7)
022700200604     C                   MOVE      DDCD08        WSCD(8)
022800200604     C                   MOVE      DDCD09        WSCD(9)
022900200604     C                   MOVE      DDCD10        WSCD(10)
023000200604     C                   MOVE      DDCD11        WSCD(11)
023100200604     C                   MOVE      DDCD12        WSCD(12)
023200200604
023300200604     C                   MOVE      DDCR01        WSCR(1)
023400200604     C                   MOVE      DDCR02        WSCR(2)
023500200604     C                   MOVE      DDCR03        WSCR(3)
023600200604     C                   MOVE      DDCR04        WSCR(4)
023700200604     C                   MOVE      DDCR05        WSCR(5)
023800200604     C                   MOVE      DDCR06        WSCR(6)
023900200604     C                   MOVE      DDCR07        WSCR(7)
024000200604     C                   MOVE      DDCR08        WSCR(8)
024100200604     C                   MOVE      DDCR09        WSCR(9)
024200200604     C                   MOVE      DDCR10        WSCR(10)
024300200604     C                   MOVE      DDCR11        WSCR(11)
024400200604     C                   MOVE      DDCR12        WSCR(12)
024500200604      *
024600200604      ** Validate first coupon date
024700200604      *
024800200604     C                   EXSR      SRValFCpnDt
024900200604      *
025000200604      ** If an error has been found, set return code appropriately.
025100200604      ** Otherwise, update valid file fields.
025200200604      *
025300200604     C                   IF        OKFCPN <> 'Y'
025400200604     C                   EVAL      RetCodeIn = 'ERROR'
025500200604     C                   ENDIF
025600200604
025700200604     C                   IF        OKFCPN <> 'N'
025800200604     C                   Z-ADD     WFstCpn       S1FCPN
025900200604     C                   ENDIF
026000200604
026100200604     C                   RETURN
026200200604
026300200604      *****************************************************************
026400200604      /EJECT
026500200604      *****************************************************************
026600200604      *                                                               *
026700200604      *  SRVALFCPNDT - Validation for Fisrt Coupon Date               *
026800200604      *                                                               *
026900200604      *****************************************************************
027000200604
027100200604     C     SRValFCpnDt   BEGSR
027200200604      *
027300200604      ** Validate if not equal to blanks
027400200604      *
027500200604     C                   IF        DDFCPN <> *BLANKS
027600200604      *
027700200604      ** If coupon rate is zero, entry is not allowed
027800200604      *
027900200604     C                   IF        PCpnRt = *ZEROS
028000200604     C                   MOVE      'W'           OKFCPN
028100200604     C                   ADD       1             WIx
028200200604     C                   MOVEL     'DDFCPN'      WFldNmXAr(WIx)
028300200604     C                   MOVEL     'SEA0181'     WMsgIdXAr(WIx)
028400200604     C                   ENDIF
028500200604      *
028600200604      ** Check valid date
028700200604      *
028800200604     C                   TESTN                   DDFCPN               01
028900200604
029000200604     C                   IF        *IN01 = *OFF
029100200604     C                   MOVE      'N'           OKFCPN
029200200604     C                   ADD       1             IDx
029300200604     C                   MOVEL     'DDFCPN'      FldNamXAr(IDx)
029400200604     C                   MOVEL     'SEA0182'     MsgIdXAr(IDx)
029500200604     C                   GOTO      EValFCpnDt
029600200604     C                   ENDIF
029700200604
029800200604     C                   MOVE      *BLANKS       PDate
029900200604     C                   MOVE      DDFCPN        PDate
030000200604     C                   CALLB     'ZDATE1'
030100200604     C                   PARM                    PDate
030200200604     C                   PARM      *ZEROS        PDaynoOut
030300200604     C                   PARM                    BJDFIN
030400200604     C                   PARM      *BLANK        ErrorFlag
030500200604
030600200604     C                   IF        ErrorFlag = 'Y'
030700200604     C                   MOVE      'N'           OKFCPN
030800200604     C                   ADD       1             IDx
030900200604     C                   MOVEL     'DDFCPN'      FldNamXAr(IDx)
031000200604     C                   MOVEL     'SEA0182'     MsgIdXAr(IDx)
031100200604     C                   GOTO      EValFCpnDt
031200200604     C                   ENDIF
031300200604
031400200604     C                   Z-ADD     PDaynoOut     WFstCpn
031500200604      *
031600200604      ** If processing type is 3 and switch CSE005 is on
031700200604      ** then ensure that first coupon is not holiday
031800200604      *  OR                                                                                   CSE031
031900200604      ** If processing type is 8 and switch CSE005 and CSE031 are on                          CSE031
032000200604      ** then ensure that first coupon is not holiday                                         CSE031
032100200604      *  OR                                                                                   CSE071
032200200604      ** If CSE005 and CSE071 are switched on and processing type is                          CSE071
032300200604      ** 1, 3, 5, 6, 8, 9 then count the number of entries in CR array                        CSE071
032400200604      *
032500200604     C********           IF        PPROT = '3' AND                                            CSE031
032600200604     C********                     CSE005 = 'Y'                                               CSE031
032700200604     C                   IF        PPROT = '3' AND CSE005 = 'Y' OR                            CSE031
032800200604     C                             PPROT = '8' AND CSE005 = 'Y' AND                           CSE031
032900200604     C                             CSE031 = 'Y'                                               CSE031
033000200604     C                             OR CSE071 = 'Y' AND CSE005 = 'Y' AND                       CSE071
033100200604     C                             (PPROT = '1' OR PPROT = '3' OR PPROT = '5' OR              CSE071
033200200604     C                             PPROT = '6' OR PPROT = '8' OR PPROT = '9')                 CSE071
033300200604     C                   IF        S1BCNV <> 'N'                                              CSE031
033400200604     C                   EXSR      SRChkHol
033500200604     C                   ENDIF                                                                CSE031
033600200604     C                   ENDIF
033700200604      *
033800200604      ** Must be after initial date and before maturity date
033900200604      *
034000200604     C                   IF        WFstCpn <= S1ITLD OR
034100200604     C                             WFstCpn > S1MATY
034200200604     C                             and S1MATY <> *ZEROS                                       261824
034300200604     C                   MOVE      'N'           OKFCPN
034400200604     C                   ADD       1             IDx
034500200604     C                   MOVEL     'DDFCPN'      FldNamXAr(IDx)
034600200604     C                   MOVEL     'SEA0183'     MsgIdXAr(IDx)
034700200604     C                   ENDIF
034800200604      *
034900200604      ** Day/month must correspond to 1 coupon rate/day entered
035000200604      ** The first coupon date doesn't need to correspond to a
035100200604      ** coupon date from the array, therefore warning message
035200200604      *
035300200604     C                   Z-ADD     1             Wx
035400200604     C                   MOVEL     DDFCPN        WKFCPN
035500200604     C                   MOVEL     'N'           WLoop
035600200604
035700200604     C                   DOW       Wx <= 12 AND WLoop = 'N'
035800200604
035900200604     C                   IF        WKFCPN = WSCD(Wx) AND
036000200604     C                             WSCR(Wx) <> 'R'
036100200604     C                   EVAL      WLoop = 'Y'
036200200604     C                   ENDIF
036300200604
036400200604     C                   ADD       1             Wx
036500200604     C                   ENDDO
036600200604
036700200604     C                   IF        WLoop = 'N'
036800200604     C                   MOVE      'W'           OKFCPN
036900200604     C                   ADD       1             WIx
037000200604     C                   MOVEL     'DDFCPN'      WFldNmXAr(WIx)
037100200604     C                   MOVEL     'SEA0181'     WMsgIdXAr(WIx)
037200200604     C                   ENDIF
037300200604
037400200604     C                   ELSE
037500200604      *
037600200604      ** If first coupon date not entered, get next coupon date after
037700200604      ** the initial date.
037800200604
037900200604     C                   IF        PCpnRt <> *ZEROS AND OKITLD <> 'N' AND
038000200604     C                             OKMATY1 <> 'N' AND OKMATY2 <> 'N' AND
038100200604     C                             OKBCNV <> 'N'  AND
038200200604
038300200604     C                             OKCD01 <> 'N' AND OKCD02 <> 'N' AND
038400200604     C                             OKCD03 <> 'N' AND OKCD04 <> 'N' AND
038500200604     C                             OKCD05 <> 'N' AND OKCD06 <> 'N' AND
038600200604     C                             OKCD07 <> 'N' AND OKCD08 <> 'N' AND
038700200604     C                             OKCD09 <> 'N' AND OKCD10 <> 'N' AND
038800200604     C                             OKCD11 <> 'N' AND OKCD12 <> 'N' AND
038900200604      *
039000200604     C                             OKCR01 <> 'N' AND OKCR02 <> 'N' AND
039100200604     C                             OKCR03 <> 'N' AND OKCR04 <> 'N' AND
039200200604     C                             OKCR05 <> 'N' AND OKCR06 <> 'N' AND
039300200604     C                             OKCR07 <> 'N' AND OKCR08 <> 'N' AND
039400200604     C                             OKCR09 <> 'N' AND OKCR10 <> 'N' AND
039500200604     C                             OKCR11 <> 'N' AND OKCR12 <> 'N'
039600200604
039700200604     C                   EVAL      PEvtCd = S1ITLD + 1
039800200604     C                   MOVEA     WSCD          PCDArr
039900200604     C                   MOVEA     WSCR          PCRArr
040000200604
040100200604     C                   CALLB     'ZNCD'
040200200604     C                   PARM                    S1ITLD
040300200604     C                   PARM      *ZEROS        PFCPN
040400200604     C                   PARM                    S1MATY
040500200604     C                   PARM                    PCDArr
040600200604     C                   PARM                    PCRArr
040700200604     C                   PARM                    PEvtCd
040800200604     C                   PARM                    BJDFIN
040900200604     C                   PARM                    S1NMCY
041000200604     C                   PARM                    S1SITP
041100200604     C                   PARM                    S1BCNV
041200200604     C                   PARM                    LCPN              5 0                        CSE031
041300200604     C                   PARM                    DDHCY1                                       CSE071
041400200604     C                   PARM                    DDHCY2                                       CSE071
041500200604     C                   PARM                    DDHCY3                                       CSE071
041600200604     C                   PARM                    DDHCY4                                       CSE071
041700200604     C                   PARM                    DDHCY5                                       CSE071
041800200604     C                   PARM                    DDHCY6                                       CSE071
041900200604     C                   PARM                    DDHCY7                                       CSE071
042000200604     C                   PARM                    DDHCY8                                       CSE071
042100200604     C                   PARM                    DDHCY9                                       CSE071
042200200604     C                   PARM                    PNxtCd
042300200604
042400200604     C                   Z-ADD     PNxtCd        WFstCpn
042500200604     C                   ENDIF
042600200604
042700200604     C                   ENDIF
042800200604
042900200604     C     EValFCpnDt    ENDSR
043000200604
043100200604      *****************************************************************
043200200604      /EJECT
043300200604      *****************************************************************
043400200604      *                                                               *
043500200604      *  SRChkHol - Check if First Coupon Date is Holiday             *
043600200604      *                                                               *
043700200604      *****************************************************************
043800200604
043900200604     C     SRChkHol      BEGSR
044000200604      *
044100200604      ** If the first coupon date is a holiday in nominal currency
044200200604      ** then update it to be the next working day.
044300200604      *
044400200604     C                   CALLB     'ZCHKH'
044500200604     C                   PARM      WFstCpn       PDateIn
044600200604     c                   PARM      S1NMCY        PCurrency
044700200604     C                   PARM      *BLANKS       PLocation
044800200604     C                   PARM                    PHolInd
044900200604
045000200604     C                   IF        PHolInd = 'H'
045100200604
045200200604     C                   Z-ADD     1             PDaysFwd
045300200604     C                   CALLB     'ZFWDT'
045400200604     C                   PARM                    PDateIn
045500200604     C                   PARM                    PDaysFwd
045600200604     C                   PARM                    PDaynoOut
045700200604     C                   PARM                    PCurrency
045800200604     C                   PARM                    PLocation
045900200604
046000200604     C                   CALLB     'ZDATE2'
046100200604     C                   PARM                    PDaynoOut
046200200604     C                   PARM                    BJDFIN
046300200604     C                   PARM                    PZDate
046400200604     C                   PARM                    PZaDate
046500200604
046600200604     C                   MOVE      PZDate        DDFCPN
046700200604     C                   MOVE      PDaynoOut     WFstCpn
046800200604     C                   ENDIF
046900200604
047000200604     C                   ENDSR
047100200604
047200200604      *****************************************************************
047300200604      /EJECT
047400200604      *****************************************************************
047500200604      *                                                               *
047600200604      *  *INZSR - Program Initialisation                              *
047700200604      *         - This subroutine runs automatically for program      *
047800200604      *           initialisation.                                     *
047900200604      *                                                               *
048000200604      *****************************************************************
048100200604      *
048200200604     C     *INZSR        BEGSR
048300200604      *
048400200604     C     *ENTRY        PLIST
048500200604      *
048600200604      ** INPUT
048700200604      ** =====
048800200604      *
048900200604      ** Return code
049000200604     C                   PARM                    RetCodeIn
049100200604      *
049200200604      ** Securities screen 2 details from incoming transaction
049300200604      ** - screen format
049400200604     C                   PARM                    NwSE2ScnFmt
049500200604      *                                                                                       CSE071
049600200604      ** Securities screen 6 details from incoming transaction                                CSE071
049700200604      ** - screen format                                                                      CSE071
049800200604     C                   PARM                    NwSE6ScnFmt                                  CSE071
049900200604      *
050000200604      ** Processing type, from PF/INVTPD
050100200604     C                   PARM                    PPROT
050200200604      *
050300200604      ** Work variable for coupon rate
050400200604     C                   PARM                    PCpnRt
050500200604      *
050600200604      ** SWITCHABLE FEATURES
050700200604      ** ===================
050800200604      *
050900200604      ** Effect of holidays on FRN coupon date
051000200604     C                   PARM                    CSE005
051100200604      *                                                                                       CSE031
051200200604      ** Coupon Fixing for Floating Rate Notes                                                CSE031
051300200604     C                   PARM                    CSE031                                       CSE031
051400200604      *                                                                                       CSE071
051500200604      ** Multiple Holidays                                                                    CSE071
051600200604     C                   PARM                    CSE071                                       CSE071
051700200604      *
051800200604      ** STANDING DATA
051900200604      ** =============
052000200604      *
052100200604      ** Date format indicator
052200200604     C                   PARM                    BJDFIN
052300200604      *
052400200604      ** OUTPUT
052500200604      ** ======
052600200604      *
052700200604      ** Error fields/message IDs/message data (arrays) from/to caller
052800200604     C                   PARM                    FldNamXAr
052900200604     C                   PARM                    MsgIDXAr
053000200604     C                   PARM                    MsgDtaXAr
053100200604      *
053200200604      ** Warning fields/message IDs/message data (arrays) from/to caller
053300200604     C                   PARM                    WFldNmXAr
053400200604     C                   PARM                    WMsgIDxAr
053500200604     C                   PARM                    WMsgDtXAr
053600200604      *
053700200604      ** Securities screen 2 error indicators
053800200604     C                   PARM                    SEESEC2
053900200604      *
054000200604      ** Securities for file update - file format
054100200604     C                   PARM                    NwSEFilFmt
054200200604      *
054300200604      *
054400200604      ** Program, module and procedure names for dbase error processing
054500200604      ** ==============================================================
054600200604      ** The following /COPY sets these values.
054700200604      *
054800200604      /COPY ZACPYSRC,DBFIELDS
054900200604      *
055000200604     C                   ENDSR
055100200604      *
055200200604      *****************************************************************
055300200604      /EJECT
055400200604      *****************************************************************
055500200604      *
055600200604      ** The following /COPY contains the standard program status
055700200604      ** subroutine, including a bound call to the DBERRCTL module.
055800200604      *
055900200604      /COPY ZACPYSRC,PSSR_ILE
056000200604      *
056100200604      *****************************************************************
056200200604      /EJECT
056300200604      *****************************************************************
056400200604      *
056500200604**  CPY@
056600200604(c) Finastra International Limited 2001
