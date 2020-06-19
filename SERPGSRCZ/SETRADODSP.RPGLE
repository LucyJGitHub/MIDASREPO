000100200529     H DEBUG
000200200529     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200529      *****************************************************************
000400200529/*STD *  RPGBASEMOD                                                   *
000500200529/*EXI *  TEXT('Midas SE Trade display - other details screen')        *
000600200529      *****************************************************************
000700200529      *                                                               *
000800200529      *  Midas - Money Market Trading Module                          *
000900200529      *                                                               *
001000200529      *  SETRADODSP - SECURITIES TRADES DISPLAY - Other Detail Screen *
001100200529      *                                                               *
001200200529      *  Function:  This module displays the Other details screen of  *
001300200529      *             the Securites input function, i.e.                *
001400200529      *             - Exchange Rates                                  *
001500200529      *             - Settlements                                     *
001600200529      *             - Charges & Commissions                           *
001700200529      *                                                               *
001800200529      *  (c) Finastra International Limited 2001                      *
001900200529      *                                                               *
002000200604      *  Last Amend No. AR706554           Date 22May20               *
002100200529      *  Prev Amend No. CSD102             Date 08Jan19               *
002200200529      *                 MD046248           Date 27Oct17               *
002300200529      *                 CSF011A            Date 28Nov11               *
002400200529      * Bank Fusion Midas 1.4 Base -----------------------------------*
002500200529      * Midas Plus 1.4 Base 04 ---------------------------------------*
002600200529      * Midas Plus 1.4 Base ------------------------------------------*
002700200529      * Midas Plus 1.3 ----------- Base ------------------------------*
002800200529      *                 CSD027             Date 09Dec05               *
002900200529      *                 CGL031             Date 05Jul04               *
003000200529      *                 CGL029             Date 01Sep03               *
003100200529      *                 CSE039             Date 04Apr03               *
003200200529      * Midas Release 4.01 -------------------------------------------*
003300200529      *                 CAP067             Date 24Sep01               *
003400200529      * Midas Release 4 --------------- Base -------------------------*
003500200529      *                 CSE016             Date 10Jan01               *
003600200529      * Midas DBA 3.05 -----------------------------------------------*
003700200529      *                 178695             Date 07Jul00               *
003800200529      * Midas DBA 3.04 -----------------------------------------------*
003900200529      *                 CSE023             Date 12Jul00               *
004000200529      * Midas DBA 3.03 -----------------------------------------------*
004100200529      * Midas DBA 3.02 -----------------------------------------------*
004200200529      *                 CAP033             Date 26Apr99               *
004300200529      *                 CPB001             Date 10Sep99               *
004400200529      * Midas DBA 3.00 ---------------- Base -------------------------*
004500200529      *                 CAP003  *CREATE    Date 22Apr98               *
004600200529      *                                                               *
004700200529      *---------------------------------------------------------------*
004800200529      *                                                               *
004900200529      *  AR706553 - Trades Input Repair, Pay To/From fields are not   *
005000200529      *             amendable. (Child: AR706554)                      *
005100200529      *  CSD102 - Password Length Extension (Recompile)               *
005200200529      *  MD046248 - Finastra Rebranding                               *
005300200529      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
005400200529      *            (Recompile)                                        *
005500200529      *  CSD027 - Conversion Of Customer Number to Alpha              *
005600200529      *  CGL031 - Taxation of Savings Income                          *
005700200529      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
005800200529      *  CSE039 - Auto-settlement of trades                           *
005900200529      *         - Recompiled due to change in SETRSEPD                *
006000200529      *  CAP067 - Repurchase Agreements API.                          *
006100200529      *  CSE016 - Extended Security Descriptions                      *
006200200529      *  178695 - Protect Amend of Portfolio Reference                *
006300200529      *  CSE023 - Treaty Withholding Tax.                             *
006400200529      *  CAP033 - Conversion of PM inputs into modular structure to   *
006500200529      *           use as APIs. Recompiled over changes to /COPY       *
006600200529      *           MSGHNDDCL.                                          *
006700200529      *  CPB001 - 'Private Banking' Module                            *
006800200529      *  CAP003 - Conversion of SE inputs into modular structure to   *
006900200529      *           use as APIs.                                        *
007000200529      *                                                               *
007100200529      *****************************************************************
007200200529      ** +--------------------------------------+
007300200529      ** ¦ F-specs                              ¦
007400200529      ** ¦ =======                              ¦
007500200529      ** +--------------------------------------+
007600200529
007700200529     FSETRADODF CF   E             WORKSTN
007800200529
007900200529      ** Table of field numbers and names
008000200529     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
008100200529                                                                                178695
008200200529      ** SE Trades Authorisation                                                178695
008300200529     FTRAUT     IF   E           K DISK    Infsr(*pssr)                         178695
008400200529
008500200529      *****************************************************************
008600200529      *                                                               *
008700200529      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
008800200529      *                                                               *
008900200529      *     10-59 Field Error - highlight screen fields               *
009000200529      *                                                               *
009100200529      *       70  Protect trade detail fields                         *
009200200529      *                                                               *
009300200529      *       61  Protect pay from branch                             *
009400200529      *       62  Protect pay to branch                               *
009500200529      *       63  Protect portfolio reference                         *
009600200529      *       64  Protect FX margin                                   *
009700200529      *       65  Protect Settlement Instructions                     *
009800200529      *       66  Protect Delivery Instructions                       *
009900200529      *       67  Protect Charges & Commissions details               *
010000200529      *       68  Protect 'In' Currency in Field 72                   *
010100200529      *       69  Protect Exchange rate and M/D ind                   *
010200200529      *                                                               *
010300200529      *       80  Not multibranching                                  *
010400200529      *       81  Originating branch not used                         *
010500200529      *       82  Profit centre not used                              *
010600200529      *       83  Bulk input option not used                          *
010700200529      *       84  Autocharge option not used                          *
010800200529      *       85  Portfolio management not used                       *
010900200529      *       86  EMU SE Settlement Ccy Conv. not installed.          *
011000200529      *                                                               *
011100200529      *       96  Subfile control                                     *
011200200529      *       97  Subfile end                                         *
011300200529      ********************************************************************
011400200529      /EJECT
011500200529      *****************************************************************
011600200529      ** +--------------------------------------+
011700200529      ** ¦ Automatically included D-specs       ¦
011800200529      ** ¦ ==============================       ¦
011900200529      ** +--------------------------------------+
012000200529      **
012100200529      **--------------------------------------------------------------------------------------------
012200200529      ** The following /COPY line includes (among others) the LDA layout
012300200529      ** and the copyright array definition:
012400200529     D/COPY ZACPYSRC,STD_D_SPEC
012500200529      **--------------------------------------------------------------------------------------------
012600200529
012700200529      **--------------------------------------------------------------------------------------------
012800200529      ** The following /COPY includes the MM standard declares:
012900200529     D/COPY ZACPYSRC,STDDECLARE
013000200529      **--------------------------------------------------------------------------------------------
013100200529
013200200529      **--------------------------------------------------------------------------------------------
013300200529      ** The following /COPY line includes all the defined fields in the
013400200529      ** Program Status Data Structures.  They have meaningful
013500200529      ** names, prefixed by 'PS'.
013600200529     D/COPY ZACPYSRC,PSDS
013700200529      **--------------------------------------------------------------------------------------------
013800200529
013900200529      **--------------------------------------------------------------------------------------------
014000200529      ** The following /COPY line includes the definitions for error and
014100200529      ** warning message arrays.
014200200529     D/COPY ZACPYSRC,ERR_ARRAYS
014300200529      **--------------------------------------------------------------------------------------------
014400200529
014500200529      **--------------------------------------------------------------------------------------------
014600200529      ** The following /COPY line includes all the definitions of the error
014700200529      ** arrays, including the named constant giving the size of
014800200529      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
014900200529      ** STD_D_SPEC.
015000200529     D/COPY ZACPYSRC,FVAL_ARRAY
015100200529      **--------------------------------------------------------------------------------------------
015200200529
015300200529      **--------------------------------------------------------------------------------------------
015400200529      ** The following /COPY line includes the definitions for error and
015500200529      ** warning message arrays.
015600200529     D/COPY ZACPYSRC,APICTLARR
015700200529      **--------------------------------------------------------------------------------------------
015800200529
015900200529      **--------------------------------------------------------------------------------------------
016000200529      ** The following /COPY line includes the definitions for fields
016100200529      ** required by the message handler.
016200200529     D/COPY ZACPYSRC,MSGHNDDCL
016300200529      **--------------------------------------------------------------------------------------------
016400200529
016500200529
016600200529      ** +--------------------------------------+
016700200529      ** ¦ End of automatically included D-specs¦
016800200529      ** ¦ =====================================¦
016900200529      ** +--------------------------------------+
017000200529
017100200529      *****************************************************************
017200200529      /EJECT
017300200529      *****************************************************************
017400200529
017500200529      ** +--------------------------------------+
017600200529      ** ¦ Manually included D-specs            ¦
017700200529      ** ¦ =========================            ¦
017800200529      ** +--------------------------------------+
017900200529
018000200529      ** +--------------------------------------+
018100200529      ** ¦ Named constants                      ¦
018200200529      ** ¦ ===============                      ¦
018300200529      ** +--------------------------------------+
018400200529
018500200529      ** +--------------------------------------+
018600200529      ** ¦ Arrays and Data Structures           ¦
018700200529      ** ¦ ==========================           ¦
018800200529      ** +--------------------------------------+
018900200529
019000200529     D @Z0             S              1    DIM(60) CTDATA PERRCD(60)
019100200529
019200200529     D @EIX            DS
019300200529     D  @EI                    1     60
019400200529     D                                     DIM(60)
019500200529
019600200529
019700200529     D SDBANK        E DS                  EXTNAME(SDBANKPD)
019800200529      ** EXTERNAL DS FOR BANK DETAILS
019900200529
020000200529     D SDGELR        E DS                  EXTNAME(SDGELRPD)
020100200529      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
020200200529
020300200529     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
020400200529      ** EXTERNAL DS FOR MIDAS MODULE DETAILS
020500200529
020600200529      ** Securities Trading ICD
020700200529     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
020800200529
020900200529      ** EXTERNAL DS FOR Portfolio Management DETAILS
021000200529     D SDPORT        E DS                  EXTNAME(SDPORTPD)
021100200529
021200200529     D DSFDY         E DS                  EXTNAME(DSFDY)
021300200529      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
021400200529
021500200529      **  Long DS for access programs
021600200529     D DSSDY         E DS                  EXTNAME(DSSDY)
021700200529
021800200529     D TrPrim        E DS                  EXTNAME(SETRPRPD)
021900200529     D @T1_CLTY      E                     EXTFLD(DDCLTY)
022000200529     D TrSeco        E DS                  EXTNAME(SETRSEPD)
022100200529     D TrExch        E DS                  EXTNAME(SETREXPD)
022200200529     D TrSett        E DS                  EXTNAME(SETRSTPD)
022300200529     D TrChCm        E DS                  EXTNAME(SETRCCPD)
022400200529
022500200529     D OKTrExch      E DS                  EXTNAME(SEETREXPD)
022600200529     D OKTrSett      E DS                  EXTNAME(SEETRSTPD)
022700200529     D OKTrChCm      E DS                  EXTNAME(SEETRCCPD)
022800200529
022900200529      ** +--------------------------------------+
023000200529      ** ¦ Declared variables                   ¦
023100200529      ** ¦ ==================                   ¦
023200200529      ** +--------------------------------------+
023300200529                                                                                              CGL031
023400200529     D CGL031          S              1                                                       CGL031
023500200529
023600200529      ** +--------------------------------------+
023700200529      ** ¦ End of D-specs                       ¦
023800200529      ** ¦ ==============                       ¦
023900200529      ** +--------------------------------------+
024000200529      *****************************************************************
024100200529      /EJECT
024200200529      *****************************************************************
024300200529      ** +--- Start of Main processing -----------------------------------+
024400200529      ** ¦                                                                ¦
024500200529      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
024600200529      ** ¦ executed at program activation.                                ¦
024700200529      ** ¦                                                                ¦
024800200529      ** +----------------------------------------------------------------+
024900200529      *
025000200529      * Main processing
025100200529      *
025200200529     C                   EXSR      MAIN
025300200529      *
025400200529      * Return
025500200529      *
025600200529     C     @INKC         IFEQ      '1'
025700200529     C                   SETON                                        LR
025800200529     C                   END
025900200529     C                   RETURN
026000200529      *
026100200529      *****************************************************************
026200200529      /EJECT
026300200529      *****************************************************************
026400200529      * MAIN - MAIN processing
026500200529      *****************************************************************
026600200529     C     MAIN          BEGSR
026700200529      *
026800200529      * MOVE 'OK' FLAGS INTO ARRAY (FOR CHECKING)
026900200529      *
027000200529     C                   EVAL      @EIX = (OKTrExch+ OKTrSett+ OKTrChCm)
027100200529      *
027200200529      * SET SCREEN ERROR INDICATORS ACCORDING TO STATUS OF 'OK' FLAGS
027300200529      *
027400200529     C                   Z-ADD     1             C                 2 0
027500200529     C                   Z-ADD     10            E                 2 0
027600200529      *
027700200529     C     C             DOUGT     60
027800200529     C     @EI(C)        IFEQ      'N'
027900200529     C     @EI(C)        OREQ      'W'
028000200529     C                   MOVEL     '1'           *IN(E)
028100200529     C                   END
028200200529     C                   ADD       1             C
028300200529     C                   ADD       1             E
028400200529     C                   END
028500200529
028600200529      ** Set up the transaction reference to be used by the message handler
028700200529     C                   EVAL      TranRef = DDTDRF
028800200529     C                   EVAL      ActionCode = DDACTN
028900200529
029000200529      **--------------------------------------------------------------------------------------------
029100200529      ** The following /COPY line includes processing for the error and
029200200529      ** warning messages.
029300200529     D/COPY ZACPYSRC,MSGHNDDSP1
029400200529      **--------------------------------------------------------------------------------------------
029500200529
029600200529
029700200529
029800200529      ** If single branch or if purchase protect "Pay to" Branch
029900200529      ** If single branch or if sale protect "Pay from" Branch
030000200529      *
030100200529     C                   MOVE      '0'           *IN61
030200200529     C                   MOVE      '0'           *IN62
030300200529     C     BJSBRC        IFEQ      *BLANK
030400200529     C*****DDTDTP        IFEQ      'TS'                                                     AR706553
030500200529     C**********         MOVE      '1'           *IN61                                      AR706553
030600200529     C**********         ELSE                                                               AR706553
030700200529     C**********         MOVE      '1'           *IN62                                      AR706553
030800200529     C**********         END                                                                AR706553
030900200529     C                   ELSE
031000200529     C                   MOVE      '1'           *IN61
031100200529     C                   MOVE      '1'           *IN62
031200200529     C                   END
031300200529      *
031400200529      *  If date made complete is prior to run date
031500200529      *  or if not portfolio customer
031600200529      *  or bank portfolios
031700200529      *  Protect portfolio reference
031800200529      *
031900200529     C*****              MOVE      '0'           *IN63                          178695
032000200529     C*****DDACTN        IFEQ      'A'                                          178695
032100200529     C*****DDACTN        OREQ      'C'                                          178695
032200200529     C*****BJRDNB        IFGT      CurTDMC                                      178695
032300200529     C*****CurTINC       ANDEQ     'C'                                          178695
032400200529     C*****              MOVE      '1'           *IN63                          178695
032500200529     C*****              END                                                    178695
032600200529     C*****              END                                                    178695
032700200529      *                                                                         178695
032800200529      *  Authorisation level equal to 00                                        178695
032900200529      *  Protect Portfolio Reference if Action code 'A' or 'C' and Trad Comp.   178695
033000200529     C     BVAUTH        Ifeq      '00'                                         178695
033100200529     C     DDACTN        Ifeq      'A'                                          178695
033200200529     C     CurTINC       Andeq     'C'                                          178695
033300200529     C     DDACTN        Oreq      'C'                                          178695
033400200529     C     CurTINC       Andeq     'C'                                          178695
033500200529     C                   Move      True          *IN63                          178695
033600200529     C                   Endif                                                  178695
033700200529     C                   Endif                                                  178695
033800200529      *                                                                         178695
033900200529      *  Authorisation level not equal to 00                                    178695
034000200529      *  Check if Trade has been authorised to protect Portfolio Reference      178695
034100200529     C     BVAUTH        Ifne      '00'                                         178695
034200200529     C     DDACTN        Andeq     'A'                                          178695
034300200529     C     BVAUTH        orne      '00'                                         178695
034400200529     C     DDACTN        Andeq     'C'                                          178695
034500200529     C     DDTDRF        Setll     TRAUT                                        178695
034600200529     C     DDTDRF        Reade     TRAUT                                  89    178695
034700200529     C                   Move      'N'           W_Found           1            178695
034800200529                                                                                178695
034900200529     C     *in89         Doweq     False                                        178695
035000200529     C     W_found       Andeq     'N'                                          178695
035100200529     C     TATYP         Ifeq      'AU'                                         178695
035200200529     C                   Move      True          *in63                          178695
035300200529     C                   Move      'Y'           W_Found                        178695
035400200529     C                   Endif                                                  178695
035500200529     C     DDTDRF        Reade     TRAUT                                  89    178695
035600200529     C                   Enddo                                                  178695
035700200529     C                   Endif                                                  178695
035800200529                                                                                178695
035900200529     C     CustPM        IFNE      'Y'
036000200529     C     CustPB        ANDNE     'Y'                                          CPB001
036100200529     C     FCPORS        OREQ      'B'
036200200529     C     CustPB        ANDNE     'Y'                                          CPB001
036300200529     C                   MOVE      '1'           *IN63
036400200529     C                   END
036500200529      *
036600200529      * If settlement currency = nominal currency
036700200529      * Protect FX Margin Points
036800200529      *
036900200529     C                   MOVE      '0'           *IN64
037000200529     C     DDSETC        IFEQ      NMCY
037100200529     C                   MOVE      '1'           *IN64
037200200529     C                   END
037300200529      *
037400200529      * Protect Settlement Instructions and Delivery Instructions
037500200529      *
037600200529     C                   MOVE      '0'           *IN65
037700200529     C                   MOVE      '0'           *IN66
037800200529     C     CustClass     IFEQ      'I'
037900200529     C                   MOVE      '1'           *IN65
038000200529     C                   MOVE      '1'           *IN66
038100200529     C                   END
038200200529      *
038300200529      * If date made complete is prior to run date
038400200529      * Protect Delivery Instructions
038500200529      *
038600200529     C     DDACTN        IFEQ      'A'
038700200529     C     BJRDNB        ANDGT     CurTDMC
038800200529     C     CurTINC       ANDEQ     'C'
038900200529     C                   MOVE      '1'           *IN66
039000200529     C                   END
039100200529      *
039200200529      * Protect Charges & Commissions details
039300200529      *
039400200529     C                   MOVE      '0'           *IN67
039500200529     C     DDACTN        IFNE      'I'
039600200529     C     DDACTN        ANDNE     'C'
039700200529     C                   MOVE      '1'           *IN67
039800200529     C                   END
039900200529      *
040000200529      * CEU005 installed.
040100200529      * Protect 'In' Currency in Field 72
040200200529      *
040300200529     C                   MOVE      '0'           *IN68
040400200529     C     CEU005        IFEQ      'Y'
040500200529     C     DDTDTP        IFEQ      'TS'
040600200529     C     DDSETC        ORNE      BKEURO
040700200529     C                   MOVE      '1'           *IN68
040800200529     C                   END
040900200529     C                   END
041000200529      *
041100200529      * CEU005 installed.
041200200529      * Protect Exchange rate and M/D ind
041300200529      *
041400200529     C                   MOVE      '0'           *IN69
041500200529     C     CEU005        IFEQ      'Y'
041600200529     C     DDSETC        IFEQ      BKEURO
041700200529     C     NMCY          OREQ      BKEURO
041800200529     C                   MOVE      '1'           *IN69
041900200529     C                   END
042000200529     C                   END
042100200529      *
042200200529      * Protect all fields
042300200529      *
042400200529     C                   MOVE      *OFF          *IN70
042500200529     C                   SELECT
042600200529     C     DDACTN        WHENEQ    'I'
042700200529     C     DDACTN        WHENEQ    'C'
042800200529     C     DDACTN        WHENEQ    'A'
042900200529     C                   OTHER
043000200529     C                   MOVE      *ON           *IN70
043100200529     C                   ENDSL
043200200529      *
043300200529      * WRITE MESSAGE SUBFILE, DETAILS AND FOOTER SCREEN
043400200529      *
043500200529     C                   TIME                    DDTIME
043600200529     C                   WRITE     SETRADOS0
043700200529     C                   WRITE     SETRADOD1
043800200529     C                   WRITE     SETRADOF1
043900200529      *
044000200529      * READ DETAILS SCREEN,
044100200529      *
044200200529      * If not write only
044300200529      *
044400200529     C     WriteOnly     IFNE      'Y'
044500200529     C                   READ      SETRADOD1                              99    *
044600200529     C                   ENDIF
044700200529      *
044800200529      * Clear message subfile
044900200529      *
045000200529     C**** martin        CALL      'ZA0250'
045100200529      *
045200200529      * SET SCREEN ERROR INDICATORS OFF
045300200529      *
045400200529     C                   MOVEA     @Z0           *IN(10)
045500200529      *
045600200529      * SET RETURN KEYS
045700200529      *
045800200529     C                   MOVE      *INKC         @INKC
045900200529     C                   MOVE      *INKE         @INKE
046000200529     C                   MOVE      *INKL         @INKL
046100200529      *
046200200529      * Set clearance type on first screen
046300200529      *
046400200529     C                   MOVE      DDCLTY        @T1_CLTY
046500200529      *
046600200529     C                   ENDSR
046700200529
046800200529      **--------------------------------------------------------------------------------------------
046900200529      ** The following /COPY line includes the ProcMsgs subroutine
047000200529      ** to process error and warning messages.
047100200529     D/COPY ZACPYSRC,MSGHNDDSP2
047200200529      **--------------------------------------------------------------------------------------------
047300200529
047400200529      ********************************************************************
047500200529      /EJECT
047600200529      *****************************************************************
047700200529      * *INZSR - INITIAL PROCESSING
047800200529      *****************************************************************
047900200529     C     *INZSR        BEGSR
048000200529      *
048100200529      ** Parameters
048200200529      *
048300200529     C     *ENTRY        PLIST
048400200529      *
048500200529      * INPUT PARAMETERS
048600200529      * RETURN CODE
048700200529     C                   PARM                    RetCodeIn
048800200529      * TRADE (IN SCREEN FORMAT)
048900200529     C                   PARM                    TrPrim
049000200529     C                   PARM                    TrSeco
049100200529     C                   PARM                    TrExch
049200200529     C                   PARM                    TrSett
049300200529     C                   PARM                    TrChCm
049400200529      *
049500200529      * Current trade incomplete ind and date made complete
049600200529     C                   PARM                    CurTINC           1
049700200529     C                   PARM                    CurTDMC           5 0
049800200529      *
049900200529      * Customer classification, Customer PM (Y/N) and nominal currency
050000200529      * And Private Banking Customer (Y/N)                                      CPB001
050100200529     C                   PARM                    CustClass         1
050200200529     C                   PARM                    CustPM            1
050300200529     C                   PARM                    NMCY              3
050400200529     C                   PARM                    CustPB            1            CPB001
050500200529      *                                                                         CSE023
050600200529      ** Withholding tax                                                        CSE023
050700200529      *                                                                         CSE023
050800200529     C                   PARM                    DDWTAX           15            CSE023
050900200529      * FIELDS IN ERROR
051000200529     C                   PARM                    OKTrExch
051100200529     C                   PARM                    OKTrSett
051200200529     C                   PARM                    OKTrChCm
051300200529      * Security report name
051400200529      * Countervalue
051500200529      ** FX Margin Amount
051600200529      ** Portfolio exchange rate & M/D ind screen format
051700200529     C**********         PARM                    DDSRPN           20                          CSE016
051800200529     C                   PARM                    DDSRNME          41                          CSE016
051900200529     C                   PARM                    DDTCTR           21
052000200529     C                   PARM                    DDMAMT           18
052100200529     C                   PARM                    DDSPXR           14
052200200529     C                   PARM                    DDSPMD            1
052300200529      * ERRORS
052400200529     C                   PARM                    FldNameArr
052500200529     C                   PARM                    MsgIdArr
052600200529     C                   PARM                    MsgDtaArr
052700200529      * WARNINGS
052800200529     C                   PARM                    WFldNamArr
052900200529     C                   PARM                    WMsgIdArr
053000200529     C                   PARM                    WMsgDtaArr
053100200529      *                                                                                       CGL031
053200200529      ** CGL031 Switchable Feature                                                            CGL031
053300200529      *                                                                                       CGL031
053400200529     C                   PARM                    CGL031                                       CGL031
053500200529      *                                                                                       CAP067
053600200529      ** Buy-sell back                                                                        CAP067
053700200529     C                   PARM                    PBYSL             1                          CAP067
053800200529      *
053900200529      * OUTPUT PARAMETERS :
054000200529      * FUNCTION KEYS
054100200529     C                   PARM                    @INKC             1
054200200529     C                   PARM                    @INKE             1
054300200529     C                   PARM                    @INKL             1
054400200529      *
054500200529      * Write screen with no read indicator
054600200529     C                   PARM                    WriteOnly         1
054700200529      *
054800200529      ** Initialize program name
054900200529      *
055000200529     C                   MOVEL     'SETRADODSP'  DBPGM
055100200529      *
055200200529      ** Move workstation ID to screen field.
055300200529      *
055400200529     C                   MOVEL     PsJobName     DDWID
055500200529     C                   MOVEL     PsUser        DDUSER
055600200529      *
055700200529      ** ACCESS BANK DETAILS
055800200529      *
055900200529     C                   CALLB     'AOBANKR0'
056000200529     C                   PARM      '*DBERR '     @RTCD             7
056100200529     C                   PARM      '*FIRST '     @OPTN             7
056200200529     C     SDBANK        PARM      SDBANK        DSFDY
056300200529      *
056400200529      * DATABASE ERROR
056500200529      *
056600200529     C     @RTCD         IFNE      *BLANKS
056700200529     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
056800200529     C                   MOVEL     '901'         DBASE                          * DBERR 901*
056900200529     C                   MOVEL     @OPTN         DBKEY                          ************
057000200529     C                   EXSR      *PSSR
057100200529     C                   END
057200200529      *
057300200529      ** ACCESS GENERAL LEDGER DETAILS
057400200529      *
057500200529     C**********         CALLB     'AOGELRR0'                                                 CGL029
057600200529     C                   CALLB     'AOGELRR1'                                                 CGL029
057700200529     C                   PARM      '*DBERR '     @RTCD             7
057800200529     C                   PARM      '*FIRST '     @OPTN             7
057900200529     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
058000200529     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
058100200529      *
058200200529      * DATABASE ERROR
058300200529      *
058400200529     C     @RTCD         IFNE      *BLANKS
058500200529     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
058600200529     C                   MOVEL     '902'         DBASE                          * DBERR 902*
058700200529     C                   MOVEL     @OPTN         DBKEY                          ************
058800200529     C                   EXSR      *PSSR
058900200529     C                   END
059000200529      *
059100200529      ** ACCESS MIDAS MODULE DETAILS
059200200529      *
059300200529     C                   CALLB     'AOMMODR0'
059400200529     C                   PARM      '*DBERR '     @RTCD             7
059500200529     C                   PARM      '*FIRST '     @OPTN             7
059600200529     C     SDMMOD        PARM      SDMMOD        DSFDY
059700200529      *
059800200529      * DATABASE ERROR
059900200529      *
060000200529     C     @RTCD         IFNE      *BLANKS
060100200529     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
060200200529     C                   MOVEL     '903'         DBASE                          * DBERR 903*
060300200529     C                   MOVEL     @OPTN         DBKEY                          ************
060400200529     C                   EXSR      *PSSR
060500200529     C                   END
060600200529      *
060700200529      ** ACCESS SECURITIES TRADING DETAILS
060800200529      *
060900200529     C                   CALL      'AOSTRDR0'
061000200529     C                   PARM      '*DBERR '     @RTCD
061100200529     C                   PARM      '*FIRST '     @OPTN
061200200529     C     SDSTRD        PARM      SDSTRD        DSSDY
061300200529      *
061400200529      ** DATABASE ERROR
061500200529      *
061600200529     C     @RTCD         IFNE      *BLANKS
061700200529     C                   MOVEL     '*FIRST '     DBKEY
061800200529     C                   MOVEL     'SDSTRDPD'    DBFILE                         ************
061900200529     C                   MOVEL     '904'         DBASE                          * DBERR 907*
062000200529     C                   EXSR      *PSSR                                        ************
062100200529     C                   END
062200200529      *
062300200529      ** ACCESS PORTFOLIO MANAGEMNT DETAILS
062400200529      *
062500200529     C     BGPFMG        IFEQ      'Y'
062600200529     C                   CALL      'AOPORTR0'
062700200529     C                   PARM      *BLANKS       @RTCD             7
062800200529     C                   PARM      '*FIRST'      @OPTN             7
062900200529     C     SDPORT        PARM      SDPORT        DSFDY
063000200529      *
063100200529      * DATABASE ERROR
063200200529      *
063300200529     C     @RTCD         IFNE      *BLANK
063400200529     C                   MOVEL     @OPTN         DBKEY
063500200529     C                   MOVEL     'SDPORTPD'    DBFILE
063600200529     C                   MOVEL     '905'         DBASE
063700200529     C                   EXSR      *PSSR
063800200529     C                   END
063900200529     C                   END
064000200529      *
064100200529      ** Check if (CEU005) EMU SE Settlement Currency Conversion is on.
064200200529      *
064300200529     C                   CALLB     'AOSARDR0'
064400200529     C                   PARM      *BLANKS       @RTCD
064500200529     C                   PARM      '*VERIFY'     @OPTN
064600200529     C                   PARM      'CEU005'      @SARD             6
064700200529     C                   PARM                    DSFDY
064800200529      *
064900200529      * DATABASE ERROR
065000200529      *
065100200529     C     @RTCD         IFNE      *BLANK
065200200529     C     @RTCD         ANDNE     '*NRF'
065300200529     C                   MOVEL     @OPTN         DBKEY                          ************
065400200529     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
065500200529     C                   MOVEL     '906'         DBASE                          * DBERR 902*
065600200529     C                   EXSR      *PSSR
065700200529     C                   END
065800200529     C     @RTCD         IFEQ      *BLANK
065900200529     C                   MOVEL     'Y'           CEU005            1
066000200529     C                   ELSE
066100200529     C                   MOVE      'N'           CEU005
066200200529     C                   END
066300200529      *                                                                         CSE023
066400200529      ** Check if (CSE023) Treaty withholding tax is on.                        CSE023
066500200529      *                                                                         CSE023
066600200529     C                   CALLB     'AOSARDR0'                                   CSE023
066700200529     C                   PARM      *BLANKS       @RTCD                          CSE023
066800200529     C                   PARM      '*VERIFY'     @OPTN                          CSE023
066900200529     C                   PARM      'CSE023'      @SARD                          CSE023
067000200529     C                   PARM                    DSFDY                          CSE023
067100200529      *                                                                         CSE023
067200200529      ** DATABASE ERROR                                                         CSE023
067300200529      *                                                                         CSE023
067400200529     C     @RTCD         IFNE      *BLANKS                                      CSE023
067500200529     C     @RTCD         ANDNE     '*NRF   '                                    CSE023
067600200529     C                   MOVEL     'CSE023'      DBKEY                          CSE023
067700200529     C                   MOVEL     'SCSARDPD'    DBFILE                         CSE023
067800200529     C                   MOVEL     '907'         DBASE                          CSE023
067900200529     C                   EXSR      *PSSR                                        CSE023
068000200529     C                   ENDIF                                                  CSE023
068100200529     C     @RTCD         IFEQ      *BLANK                                       CSE023
068200200529     C                   MOVEL     'Y'           CSE023            1            CSE023
068300200529     C                   ELSE                                                   CSE023
068400200529     C                   MOVE      'N'           CSE023                         CSE023
068500200529     C                   ENDIF                                                  CSE023
068600200529      *
068700200529      * Message subfile control
068800200529      *
068900200529     C                   MOVE      '1'           *IN97
069000200529     C                   MOVEL     '*'           DDPGMQ
069100200529      *
069200200529      * SET SCREEN PROTECT/NON-DISPLAY INDICATORS
069300200529      * =========================================
069400200529      *
069500200529      * Single-branching (protect booking branch)
069600200529      *
069700200529     C     BJSBRC        IFNE      *BLANK
069800200529     C                   MOVE      '1'           *IN80
069900200529     C                   END
070000200529      *
070100200529      * Originating Branches not used
070200200529      *
070300200529     C     BKOBRU        IFNE      'Y'
070400200529     C     BJSBRC        ORNE      *BLANK
070500200529     C                   MOVE      '1'           *IN81
070600200529     C                   END
070700200529      *
070800200529      * Profit Centres not used (protect profit centre)
070900200529      *
071000200529     C     BGN0ST        IFEQ      'Y'
071100200529     C     BKPRCU        ORNE      'Y'
071200200529     C                   MOVE      '1'           *IN82
071300200529     C                   END
071400200529      *
071500200529      ** Bulk input option not used (non display bulk ref)
071600200529      *
071700200529     C     BVBIOP        IFNE      'Y'
071800200529     C                   MOVE      '1'           *IN83
071900200529     C                   END
072000200529      *
072100200529      ** Autocharge option not used (protect charges 6,7)
072200200529      *
072300200529     C     BVACOP        IFNE      'Y'
072400200529     C                   MOVE      '1'           *IN84
072500200529     C                   END
072600200529      *
072700200529      ** Portfolio Management not installed
072800200529      ** Private Banking not installed                                          CPB001
072900200529      **   protect and non display portfolio
073000200529      *
073100200529     C     BGPFMG        IFNE      'Y'
073200200529     C     BGN4ST        ANDNE     'Y'                                          CPB001
073300200529     C                   MOVE      '1'           *IN85
073400200529     C                   ELSE                                                   CPB001
073500200529     C                   MOVE      '0'           *IN85                          CPB001
073600200529     C                   END
073700200529      *
073800200529      ** EMU SE Settlement Currency Conversion not installed.
073900200529      *
074000200529     C     CEU005        IFNE      'Y'
074100200529     C                   MOVE      '1'           *IN86
074200200529     C                   END
074300200529      *                                                                         CSE023
074400200529      ** Treaty withholding tax is not installed.                               CSE023
074500200529      *                                                                         CSE023
074600200529     C     CSE023        IFNE      'Y'                                          CSE023
074700200529     C                   MOVE      '1'           *IN87                          CSE023
074800200529     C                   ENDIF                                                  CSE023
074900200529
075000200529      *                                                                                       CAP067
075100200529      ** If Buy-sell back processing, write appropriate screen header                         CAP067
075200200529     C                   IF        PBYSL = 'Y'                                                CAP067
075300200529     C                   EVAL      *IN86 = *ON                                                CAP067
075400200529     C                   ELSE                                                                 CAP067
075500200529     C                   EVAL      *IN86 = *OFF                                               CAP067
075600200529     C                   ENDIF                                                                CAP067
075700200529      *                                                                                       CGL031
075800200529      ** CGL031 feature is installed.                                                         CGL031
075900200529      *                                                                                       CGL031
076000200529     C                   MOVE      *OFF          *IN77                                        CGL031
076100200529     C     CGL031        IFEQ      'Y'                                                        CGL031
076200200529     C                   MOVE      *ON           *IN77                                        CGL031
076300200529     C                   ENDIF                                                                CGL031
076400200529
076500200529      **--------------------------------------------------------------------------------------------
076600200529      ** The following /COPY line sets up the fixed data for SE *DSP
076700200529      ** functions for the message handler, ZAMSGHNDLE.
076800200529     D/COPY SECPYSRC,MSGHNDDATA
076900200529      **--------------------------------------------------------------------------------------------
077000200529
077100200529     C                   ENDSR
077200200529
077300200529      *****************************************************************
077400200529      /EJECT
077500200529      *****************************************************************
077600200529      ** Program, module and procedure names for database error processing.
077700200529      ** =================================================================
077800200529      ** The following /COPY sets these values, and also defines LDA as
077900200529      ** an external data area
078000200529      ********************************************************************
078100200529     C/COPY ZACPYSRC,PSSR_ILE
078200200529      ********************************************************************
078300200529**  CPY@
078400200529(c) Finastra International Limited 2001
078500200529** @Z0
078600200529000000000000000000000000000000000000000000000000000000000000
