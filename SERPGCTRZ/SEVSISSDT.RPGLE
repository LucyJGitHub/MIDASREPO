000100200604     H DEBUG
000200200604     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200604      *****************************************************************
000400200604/*STD *  RPGBASEMOD                                                   *
000500200604/*EXI *  TEXT('Midas SE Validate issue date')                         *
000600200604      *****************************************************************
000700200604      *                                                               *
000800200604      *  Midas - Securities Trading Module                            *
000900200604      *                                                               *
001000200604      *  SEVSISSDT - Validate Issue Date                              *
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
003200200604      *                 234675             Date 05Jul05               *
003300200604      *                 233351             Date 09May05               *
003400200604      *                 232543             Date 22Mar05               *
003500200604      *                 CGL031             Date 05Jul04               *
003600200604      *                 CSE071             Date 19Jul05               *
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
005400200604      *  234675 - Change control for processing type 4 and Dividend   *
005500200604      *           EU tax calculation (Recompile).                     *
005600200604      *  233351 - Initial Date can be less than Issue Date            *
005700200604      *  232543 - Fix to CGL031                                       *
005800200604      *  CGL031 - Taxation of Savings Income                          *
005900200604      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
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
013400200604      ** Securities Screen 3 details from incoming transaction
013500200604      ** - screen format
013600200604     D NwSE3ScnFmt   E DS                  EXTNAME(SESEC3PD)
013700200604      *
013800200604      ** Securities Screen 2 details from incoming transaction
013900200604      ** - screen format
014000200604     D NwSE2ScnFmt   E DS                  EXTNAME(SESEC2PD)
014100200604      *
014200200604      ** Securities for file update - file format
014300200604     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
014400200604      *
014500200604      ** Securities Screen 3 error indicators
014600200604     D SEESEC3       E DS                  EXTNAME(SEESEC3PD)
014700200604      *
014800200604      ** +--------------------------------------+
014900200604      ** ¦ Declared variables                   ¦
015000200604      ** ¦ ==================                   ¦
015100200604      ** +--------------------------------------+
015200200604      *
015300200604      ** Index for arrays of error message ids, etc.
015400200604     D IDx             S              3P 0
015500200604      *
015600200604      ** Parameters for module ZAVDATE
015700200604     D PDateIn         S              6A
015800200604     D PDayNo          S              5P 0
015900200604     D PDFmt           S              1A
016000200604      *
016100200604      ** SDMMOD - Date Format Indicator
016200200604     D BJDFIN          S              1A
016300200604      *
016400200604      ** Work variable for Issue Date
016500200604     D WIssDt          S              5P 0
016600200604                                                                                              CGL031
016700200604      ** Taxation on Savings Income                                                           CGL031
016800200604     D CGL031          S              1A                                                      CGL031
016900200604                                                                                              CGL031
017000200604      ** Processing type                                                                      CGL031
017100200604     D PPROT           S              1A                                                      CGL031
017200200604                                                                                              232543
017300200604      ** Subject to European Tax                                                              232543
017400200604     D DDSETX          S              1A                                                      232543
017500200604      *
017600200604      ** +--------------------------------------+
017700200604      ** ¦ End of D-specs                       ¦
017800200604      ** ¦ ==============                       ¦
017900200604      ** +--------------------------------------+
018000200604      *
018100200604      *****************************************************************
018200200604      /EJECT
018300200604      *****************************************************************
018400200604      *
018500200604      ** +--- Start of Main processing -------------------------------+
018600200604      ** ¦                                                            ¦
018700200604      ** ¦ *INZSR is executed at program activation.                  ¦
018800200604      ** ¦                                                            ¦
018900200604      ** +------------------------------------------------------------+
019000200604      *
019100200604      ** Initialise work variables.
019200200604      *
019300200604     C                   EVAL      Idx = 0
019400200604     C                   Z-ADD     *ZEROS        WIssDt
019500200604      *
019600200604      ** Validate issue date.
019700200604      *
019800200604     C                   EXSR      SRValIssDt
019900200604      *
020000200604      ** If an error has been found, set return code appropriately.
020100200604      ** Otherwise, update valid file fields.
020200200604      *
020300200604     C                   IF        OKISSD = 'N'
020400200604     C                   EVAL      RetCodeIn = 'ERROR'
020500200604     C                   ENDIF
020600200604      *
020700200604     C                   IF        OKISSD <> 'N'
020800200604     C                   Z-ADD     WIssDt        S1ISSD
020900200604     C                   ENDIF
021000200604      *
021100200604     C                   RETURN
021200200604      *
021300200604      *****************************************************************
021400200604      /EJECT
021500200604      *****************************************************************
021600200604      *                                                               *
021700200604      *  SRValIssDt - Validation for Issue Date                       *
021800200604      *                                                               *
021900200604      *****************************************************************
022000200604
022100200604     C     SRValIssDt    BEGSR
022200200604
022300200604     C                   IF        CGL031 = 'Y' AND                                           CGL031
022400200604     C                             DDISSD = *BLANKS                                           CGL031
022500200604     C                   IF        PPROT <> '2' AND                                           CGL031
022600200604     C                             PPROT <> '4' AND                                           CGL031
022700200604     C**********                   PPROT <> '7'                                        CGL031 232543
022800200604     C                             PPROT <> '7' AND                                           232543
022900200604     C                             DDSETX = 'Y'                                               232543
023000200604     C                   MOVE      'N'           OKISSD                                       CGL031
023100200604     C                   ADD       1             Idx                                          CGL031
023200200604     C                   MOVEL     'DDISSD'      FldNamXAr(Idx)                               CGL031
023300200604     C                   MOVEL     'SEA0903'     MsgIdXAr(Idx)                                CGL031
023400200604     C                   GOTO      EValIssDt                                                  CGL031
023500200604     C                   ENDIF                                                                CGL031
023600200604     C                   ENDIF                                                                CGL031
023700200604                                                                                              CGL031
023800200604     C                   IF        DDISSD <> *BLANKS
023900200604
024000200604     C                   Z-ADD     *ZERO         PDayNo
024100200604
024200200604     C                   CALLB     'ZAVDATE'
024300200604     C                   PARM      *BLANK        RetCodeOut
024400200604     C                   PARM      DDISSD        PDateIn
024500200604     C                   PARM      BJDFIN        PDFmt
024600200604     C                   PARM                    PDayNo
024700200604
024800200604     C                   IF        RetCodeOut = 'Error'
024900200604     C                   MOVE      'N'           OKISSD
025000200604     C                   ADD       1             Idx
025100200604     C                   MOVEL     'DDISSD'      FldNamXAr(Idx)
025200200604     C                   MOVEL     'SEA0100'     MsgIdXAr(Idx)
025300200604     C                   GOTO      EValIssDt
025400200604     C                   ENDIF
025500200604      *
025600200604      ** Must not be after initial date, unless trade basis = 'D'
025700200604      ** (i.e. there is no initial date).
025800200604      *
025900200604     C**********         IF        S1STBS <> 'D' and                                          233351
026000200604     C**********                   S1ITLD <> *ZEROS   and                                     233351
026100200604     C**********                   PDayNo > S1ITLD                                            233351
026200200604     C**********         MOVE      'N'           OKISSD                                       233351
026300200604     C**********         ADD       1             Idx                                          233351
026400200604     C**********         MOVEL     'DDISSD'      FldNamXAr(Idx)                               233351
026500200604     C**********         MOVEL     'SEA0101'     MsgIdXAr(Idx)                                233351
026600200604     C**********         GOTO      EValIssDt                                                  233351
026700200604     C**********         ENDIF                                                                233351
026800200604      *
026900200604      ** Must not be after maturity date.
027000200604      *
027100200604     C                   IF        DDMATY1 <> *Blanks or
027200200604     C                             DDMATY2 <> *Blanks
027300200604
027400200604     C**********         IF        PDayNo > S1MATY                                            261824
027500200604     C                   IF        PDayNo > S1MATY and S1MATY <> *ZEROS                       261824
027600200604     C                   MOVE      'N'           OKISSD
027700200604     C                   ADD       1             Idx
027800200604     C                   MOVEL     'DDISSD'      FldNamXAr(Idx)
027900200604     C                   MOVEL     'SEA0101'     MsgIdXAr(Idx)
028000200604     C                   GOTO      EValIssDt
028100200604     C                   ENDIF
028200200604
028300200604     C                   ENDIF
028400200604
028500200604     C                   Z-ADD     PDayNo        WIssDt
028600200604
028700200604     C                   ENDIF
028800200604
028900200604     C     EValIssDt     ENDSR
029000200604
029100200604      *****************************************************************
029200200604      /EJECT
029300200604      *****************************************************************
029400200604      *                                                               *
029500200604      *  *INZSR - Program Initialisation                              *
029600200604      *         - This subroutine runs automatically for program      *
029700200604      *           initialisation.                                     *
029800200604      *                                                               *
029900200604      *****************************************************************
030000200604      *
030100200604     C     *INZSR        BEGSR
030200200604
030300200604     C     *ENTRY        PLIST
030400200604      *
030500200604      ** INPUT
030600200604      ** =====
030700200604      *
030800200604      ** Return code
030900200604     C                   PARM                    RetCodeIn
031000200604      *                                                                                       232543
031100200604      ** Subject to EU Tax                                                                    232543
031200200604     C                   PARM                    DDSETX                                       232543
031300200604      *
031400200604      ** Securities Screen 2 details from incoming transaction
031500200604      ** - screen format
031600200604     C                   PARM                    NwSE2ScnFmt
031700200604      *
031800200604      ** Securities Screen 3 details from incoming transaction
031900200604      ** - screen format
032000200604     C                   PARM                    NwSE3ScnFmt
032100200604      *
032200200604      ** STANDING DATA
032300200604      ** =============
032400200604      *
032500200604      ** SDMMOD - Date Format Indicator
032600200604     C                   PARM                    BJDFIN
032700200604                                                                                              CGL031
032800200604      ** SWITCHABLE FEATURES                                                                  CGL031
032900200604      ** ===================                                                                  CGL031
033000200604                                                                                              CGL031
033100200604     C                   PARM                    CGL031                                       CGL031
033200200604                                                                                              CGL031
033300200604      ** Processing type, from PF/INVTPD                                                      CGL031
033400200604     C                   PARM                    PPROT                                        CGL031
033500200604      *
033600200604      ** OUTPUT
033700200604      ** ======
033800200604      *
033900200604      ** Error fields/message IDs/message data (arrays) from/to caller
034000200604     C                   PARM                    FldNamXAr
034100200604     C                   PARM                    MsgIDXAr
034200200604     C                   PARM                    MsgDtaXAr
034300200604      *
034400200604      ** Securities Screen 3 error indicators
034500200604     C                   PARM                    SEESEC3
034600200604      *
034700200604      ** Securities for file update - file format
034800200604     C                   PARM                    NwSEFilFmt
034900200604      *
035000200604      ** Program, module and procedure names for dbase error processing
035100200604      ** ==============================================================
035200200604      ** The following /COPY sets these values.
035300200604      *
035400200604      /COPY ZACPYSRC,DBFIELDS
035500200604
035600200604     C                   ENDSR
035700200604
035800200604      *****************************************************************
035900200604      /EJECT
036000200604      *****************************************************************
036100200604      *
036200200604      ** The following /COPY contains the standard program status
036300200604      ** subroutine, including a bound call to the DBERRCTL module.
036400200604      *
036500200604      /COPY ZACPYSRC,PSSR_ILE
036600200604
036700200604      *****************************************************************
036800200604      /EJECT
036900200604      *****************************************************************
037000200604      *
037100200604**  CPY@
037200200604(c) Finastra International Limited 2001
