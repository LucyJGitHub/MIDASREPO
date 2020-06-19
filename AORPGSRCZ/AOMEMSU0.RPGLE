000100200528     H DEBUG
000200200528      *****************************************************************
000300200528/***D ***RPG***********************************************************   CAP002
000400200528/*STD *  RPGBASEMOD                                                   *
000500200528/*EXI *  TEXT('Midas AO Update Memos file')                           *
000600200528     F********************************************************************
000700200528     F*                                                                  *
000800200528     F*  Midas - Access Objects Module
000900200528     F*                                                                  *
001000200528     F*     AOMEMSU0 - Update Memos file                                 *
001100200528     F*                                                                  *
001200200528      *  (c) Finastra International Limited 2001                      *
001300200528     F*                                                               *
001400200604      *  Last Amend No. 251029             Date 22May20               *
001500200528      *  Prev Amend No. MD046248           Date 27Oct17               *
001600200528      *                 AR868380           Date 10Jun13               *
001700200528      * Bank Fusion Midas 1.4 Base -----------------------------------*
001800200528      * Midas Plus 1.4 Base 04 ---------------------------------------*
001900200528      * Midas Plus 1.4 Base ------------------------------------------*
002000200528      * Midas Plus 1.3 ----------- Base ------------------------------*
002100200528      *                 CSD027             Date 09Dec05               *
002200200528      *                 157989             Date 25Apr05               *
002300200528      *                 CGL029             Date 01Sep03               *
002400200528      * Midas Release 4 --------------- Base -------------------------*
002500200528      * Midas DBA 3.05 -----------------------------------------------*
002600200528      *                 189280             Date 15Mar01               *
002700200528      * Midas DBA 3.00 ---------------- Base -------------------------*
002800200528      *                 CAP002             Date 01May98               *
002900200528     F*                  CCB002             DATE  10JUL96                *
003000200528     F*                  041693             DATE  05JAN93                *
003100200528     F*                  045014             DATE  01DEC92                *
003200200528     F*                  031876             DATE  03NOV92                *
003300200528     F*                                                                  *
003400200528     F*------------------------------------------------------------------*
003500200528     F*                                                                  *
003600200528      *  251029 - Applied fix 231306.                                 *
003700200528      *  231306 - Handle file locking properly.                       *
003800200528      *  MD046248 - Finastra Rebranding                               *
003900200528      *  AR868380 - APISERVER on LCKW status. Return *RECLCK to       *
004000200528      *             calling program if file locking occurred on       *
004100200528      *             online position files. (Child: AR868381)          *
004200200528      *  CSD027 - Conversion Of Customer Number to Alpha              *
004300200528      *  157989 - EOC fails in FFC1080 (ENDCMTCTL while changes +     *
004400200528      *         - pending). This fix was applied by CER001.           *
004500200528      *  CGL029 - Increase Account Code to 10 digits                  *
004600200528      *  189280 - Reset file pointer before CHAIN to MEMOS else second   *
004700200528      *           and subsequent CHAIN operations may return *NRF even   *
004800200528      *           where account exists on MEMOS.                         *
004900200528      *         - Monitor return code added when program dumps           *
005000200528      *  CAP002 - Member converted from an OPM program to an ILE         *
005100200528      *           module and an ILE *PGM member of the same name has     *
005200200528      *           been created (in AOPGMSRC).                            *
005300200528      *           ILE modules can make a bound call to the module.       *
005400200528      *           OPM programs can make a dynamic call to the *PGM.      *
005500200528     F*     CCB002 - COB Performance Enhancements                        *
005600200528     F*              Access now via access object                        *
005700200528     F*              MEMOS is now accessed via GL/RE key rather than old *
005800200528     F*              relative record number.                             *
005900200528     F*                                                                  *
006000200528     F*     041693 - Delivered as part of fix.                           *
006100200528     F*                                                                  *
006200200528     F*     045014 - Add call to AOCNTLR0 for access control             *
006300200528     F*                                                                  *
006400200528     F*     031876 - New program to update MEMOS file for shadow         *
006500200528     F*              post.                                               *
006600200528     F*                                                                  *
006700200528     F*****************************************************************
006800200528     F****MEMOS   UF  E                    DISK         KCOMIT          UCCCB002
006900200528     F****                                              KINFSR SRFILE     CCB002
007000200528      *****                                                               CCB002
007100200528      ***** Define MEMOS file                                             CCB002
007200200528      *****                                                               CCB002
007300200528     FMEMOSL1   UF   E           K DISK    COMMIT                               CCB002
007400200528     F                                     USROPN
007500200528     F                                     INFSR(SRFILE)                        CCB002
007600200528     F                                     INFDS(@MEMO1)                                    AR868380
007700200528      *                                                                   CCB002
007800200528      * Define Shadow balances by G/L Account Number                      CCB002
007900200528      *                                                                   CCB002
008000200528     FMEMOSL2   UF   E           K DISK    COMMIT                               CCB002
008100200528     F                                     USROPN
008200200528     F                                     INFSR(SRFILE)                        CCB002
008300200528     F                                     RENAME(MEMOSMDF:@MEMOSXX)            CCB002
008400200528     F                                     INFDS(@MEMO2)                                    AR868380
008500200528      *                                                                   CCB002
008600200528      * Define Shadow balances by Retail Account Number                   CCB002
008700200528      *                                                                   CCB002
008800200528     FSDBANKL1  IF   E           K DISK    USROPN
008900200528     F                                     INFSR(SRFILE)
009000200528     F                                     RENAME(@BJREEF:@BANKL1)
009100200528      *
009200200528      * Define SDBANKL1 for working day & next working day
009300200528      *
009400200528     F/EJECT
009500200528      *
009600200528      *  Copyright table
009700200528      *
009800200528      *
009900200528      *  List of valid calling programs
010000200528      *
010100200528     D PGM@            S             10    DIM(3) CTDATA PERRCD(1)
010200200528      *
010300200528      *  Error texts
010400200528      *
010500200528     D**********          ERR@    1   4 80                                045014
010600200528     D ERR@            S             80    DIM(5) CTDATA PERRCD(1)                               045
010700200528      *
010800200528      *  Array of QCMDEXC commands
010900200528      *
011000200528     D CMD@            S             80    DIM(1) CTDATA PERRCD(1)
011100200528      *
011200200528      *  Array of QCMDEXC command to edit
011300200528      *
011400200528     D EDT             S              1    DIM(80)
011500200528      *
011600200528      *  Subroutine stack
011700200528      *
011800200528     D @STK            S             10    DIM(20)
011900200528     D/EJECT
012000200528      *
012100200528      *  Data structure for compilation  - Copyright insertion
012200200528      *
012300200528     D CPYR@#          DS
012400200528     D  CPY@                   1     80
012500200528     D                                     DIM(1) CTDATA PERRCD(1)
012600200528     D  CPY@##                 1     20
012700200528     D @MEMO1        E DS                  EXTNAME(Y2IUDSP)                                 AR868380
012800200528     D @MEMO2        E DS                  EXTNAME(Y2IUDSP)                                 AR868380
012900200528     D                                     PREFIX(@)                                        AR868380
013000200528      *
013100200528      *  Program data structure
013200200528      *
013300200528     D DSPGM         ESDS                  EXTNAME(Y2PGDSP)
013400200528      *
013500200528      *  Send message data structure
013600200528      *
013700200528     D DBDTA           DS
013800200528     D  DBPGM                  1     10
013900200528     D  DBFILE                11     20
014000200528     D  DBKEY                 21     50
014100200528     D  DBERNB                51     55  0
014200200528     D  DBNARR                56    135
014300200528     D  DBSTK                136    145
014400200528     D  DBPREF               146    175                                         045014
014500200528      ** G/L key in case of database error.                               CCB002
014600200528      *                                                                   CCB002
014700200528     D UGLERR          DS                                                       CCB002
014800200528     D**U0CNUM**               1      6  0                                             CCB002 CSD027
014900200528     D  U0CNUM                 1      6                                                       CSD027
015000200528     D  U0CUCD                 7      9                                         CCB002
015100200528     D***U0ACCD*               10     13  0                                            CCB002 CGL029
015200200528     D***U0ACSQ*               14     15  0                                            CCB002 CGL029
015300200528     D***U0BRCA*               16     18                                               CCB002 CGL029
015400200528     D  U0ACCD                10     19  0                                                    CGL029
015500200528     D  U0ACSQ                20     21  0                                                    CGL029
015600200528     D  U0BRCA                22     24                                                       CGL029
015700200528      *                                                                   045014
015800200528      *  Input parameters data structure for AOCNTLR0                     045014
015900200528      *                                                                   045014
016000200528     D P#CNTL          DS           256                                         045014
016100200528      *                                       Access Check                045014
016200200528     D  P#ACCK                 1      1                                         045014
016300200528     I/EJECT
016400200528      *
016500200528      *  Set up subroutine stack name
016600200528      *
016700200528     C                   ADD       1             Q
016800200528     C                   MOVEL     'MAIN'        @STK(Q)
016900200528      *
017000200528      * Initialise program
017100200528      *
017200200528     C     *IN50         IFEQ      '0'
017300200528     C                   EXSR      SRINIT
017400200528     C                   END
017500200528      *
017600200528      * Update Memos file with passed data
017700200528      *
017800200528     C                   EXSR      SRMEMS
017900200528      *
018000200528      *  Unwind subroutine stack name
018100200528      *
018200200528     C                   MOVEA     *BLANKS       @STK(Q)
018300200528     C                   SUB       1             Q
018400200528      *
018500200528      * Return to calling program
018600200528      *
018700200528     C                   RETURN
018800200528     C/EJECT
018900200528      *****************************************************************
019000200528      *                                                               *
019100200528      *  SRMEMS   : Update Memos file                                 *
019200200528      *                                                               *
019300200528      *  CALLED BY: Main Processing                                   *
019400200528      *                                                               *
019500200528      *  CALLS    : SRERR   - report error and close down program     *
019600200528      *                                                               *
019700200528      *****************************************************************
019800200528     CSR   SRMEMS        BEGSR
019900200528      *
020000200528      *  Set up subroutine stack name
020100200528      *
020200200528     C                   ADD       1             Q
020300200528     C                   MOVEL     'SRMEMS'      @STK(Q)
020400200528      *
020500200528      *  Define entry parameters
020600200528      *
020700200528     C     *ENTRY        PLIST
020800200528     C                   PARM                    W0RTN             7            O:Return code
020900200528     C***********          PARM           W0RRN   70       I:MEMOS Rel. ReCCB002
021000200528     C                   PARM                    W0RETL           10 0          I:Retail A/C NuCCB00
021100200528     C**********         PARM                    W0CNUM            6 0   I:Customer NumbCCB00 CSD027
021200200528     C                   PARM                    W0CNUM            6            I:Customer Nu CSD027
021300200528     C                   PARM                    W0CUCD            3            I:Currency     CCB00
021400200528     C**********         PARM                    W0ACCD            4 0   I:Accout Code  CCB00 CGL029
021500200528     C                   PARM                    W0ACCD           10 0                        CGL029
021600200528     C                   PARM                    W0ACSQ            2 0          I:Account SequeCCB00
021700200528     C                   PARM                    W0BRCA            3            I:Branch       CCB00
021800200528     C                   PARM                    W0PSTD            5 0          I:Posting date
021900200528     C                   PARM                    W0VDAT            5 0          I:Value date
022000200528     C                   PARM                    W0AMT            15 0          I:Movement amount
022100200528     C                   PARM                    W0FTOV            1            I:FT override LDBL U
022200200528      *                                                                   CCB002
022300200528      ** Ascertain whether General Ledger or Retail.                      CCB002
022400200528      *
022500200528     C     W0RETL        IFEQ      *ZEROS                                                      CCB00
022600200528     C                   MOVE      'G'           UACTYP            1                           CCB00
022700200528     C                   ELSE                                                                  CCB00
022800200528     C                   MOVE      'R'           UACTYP                                        CCB00
022900200528     C                   ENDIF                                                                 CCB00
023000200528      *                                                                   CCB002
023100200528      ** GL key                                                           CCB002
023200200528     C     GLKEY         KLIST                                                                 CCB00
023300200528     C                   KFLD                    W0CNUM                         Customer NumberCCB00
023400200528     C                   KFLD                    W0CUCD                         Currency code  CCB00
023500200528     C                   KFLD                    W0ACCD                         Account code   CCB00
023600200528     C                   KFLD                    W0ACSQ                         Account sequencCCB00
023700200528     C                   KFLD                    W0BRCA                         Branch         CCB00
023800200528      *  Read Memos record for update                                     CCB002
023900200528      *                                                                   CCB002
024000200528     C                   OPEN      MEMOSL1                                                    157989
024100200528     C                   OPEN      MEMOSL2                                                    157989
024200200528     C***********W0RRN     CHAINMEMOSMDF             90                   CCB002
024300200528     C     UACTYP        IFEQ      'G'                                                         CCB00
024400200528     C     *LOVAL        SETLL     MEMOSL1                                                    189280
024500200528     C*****GLKEY         CHAIN     MEMOSL1                            90              CCB00 AR868380
024600200528     C     GLKEY         CHAIN     MEMOSL1                            9091                  AR868380
024700200528     C     *IN91         IFEQ      '1'                                                      AR868380
024800200528     C                   EXSR      SRFILE                                                   AR868380
024900200528     C                   ENDIF                                                              AR868380
025000200528     C                   ELSE                                                                  CCB00
025100200528     C     *LOVAL        SETLL     MEMOSL2                                                    189280
025200200528     C*****W0RETL        CHAIN     MEMOSL2                            90              CCB00 AR868380
025300200528     C     W0RETL        CHAIN     MEMOSL2                            9091                  AR868380
025400200528     C     *IN91         IFEQ      '1'                                                      AR868380
025500200528     C                   EXSR      SRFILE                                                   AR868380
025600200528     C                   ENDIF                                                              AR868380
025700200528     C                   ENDIF                                                                 CCB00
025800200528      *                                                                   CCB002
025900200528      ** If CHAIN failure ascertain correct key.                          CCB002
026000200528     C     *IN90         IFEQ      '1'                                                         CCB00
026100200528     C     RECI          ORNE      'D'                                                         CCB00
026200200528     C     UACTYP        IFEQ      'G'                                                         CCB00
026300200528     C**********         Z-ADD     W0CNUM        U0CNUM                                 CCB00 CSD027
026400200528     C                   EVAL      U0CNUM = W0CNUM                                            CSD027
026500200528     C                   MOVEL     W0CUCD        U0CUCD                                        CCB00
026600200528     C                   Z-ADD     W0ACCD        U0ACCD                                        CCB00
026700200528     C                   Z-ADD     W0ACSQ        U0ACSQ                                        CCB00
026800200528     C                   MOVEL     W0BRCA        U0BRCA                                        CCB00
026900200528     C                   MOVEL     UGLERR        W0KEY                                         CCB00
027000200528     C                   MOVEL     'MEMOSL1 '    W0FILE                                        CCB00
027100200528     C                   Z-ADD     3             W0ERNB                                        CCB00
027200200528     C                   EXSR      SRERR                                                       CCB00
027300200528     C                   ELSE                                                                  CCB00
027400200528     C                   MOVEL     W0RETL        W0KEY                                         CCB00
027500200528     C                   MOVEL     'MEMOSL2 '    W0FILE                                        CCB00
027600200528     C                   Z-ADD     3             W0ERNB                                        CCB00
027700200528     C                   EXSR      SRERR                                                       CCB00
027800200528     C                   ENDIF                                                                 CCB00
027900200528     C                   ENDIF                                                                 CCB00
028000200528      *                                                                   CCB002
028100200528     C     *IN90         IFEQ      '1'
028200200528     C     RECI          ORNE      'D'
028300200528     C***********          MOVEL'MEMOS   'W0FILE                          CCB002
028400200528     C***********          MOVELW0RRN     W0KEY                           CCB002
028500200528     C                   Z-ADD     5             W0ERNB
028600200528     C                   MOVEL     ERR@(3)       W0NARR
028700200528     C                   EXSR      SRERR
028800200528     C                   END
028900200528      *
029000200528      *  Change values on Memos record
029100200528      *
029200200528      *  If value date is today or less then alter both balances
029300200528      *
029400200528     C     W0VDAT        IFLE      BJRDNB
029500200528     C                   ADD       W0AMT         LDBLN
029600200528     C                   ADD       W0AMT         CLBLN
029700200528     C                   ELSE
029800200528      *
029900200528      *  If posting date is today or less then alter ledger balance
030000200528      *  or if FT override is in effect
030100200528      *
030200200528     C     W0PSTD        IFLE      BJRDNB
030300200528     C     W0FTOV        OREQ      'Y'
030400200528     C                   ADD       W0AMT         LDBLN
030500200528     C                   END
030600200528     C                   END
030700200528      *
030800200528      *  Update Memos fields
030900200528      *
031000200528     C     UACTYP        IFEQ      'G'                                                         CCB00
031100200528     C                   EXCEPT    UPDMMS
031200200528     C                   ELSE                                                                  CCB00
031300200528     C                   EXCEPT    UPDMM1                                                      CCB00
031400200528     C                   ENDIF                                                                 CCB00
031500200528     C/COPY WNCPYSRC,AOMEMSU0C1
031600200528      *
031700200528     C                   CLOSE     MEMOSL1                                                    157989
031800200528     C                   CLOSE     MEMOSL2                                                    157989
031900200528      *  Unwind subroutine stack name
032000200528      *
032100200528     C     EXMEMS        TAG
032200200528     C                   MOVEA     *BLANKS       @STK(Q)
032300200528     C                   SUB       1             Q
032400200528      *
032500200528     CSR                 ENDSR
032600200528     C/EJECT
032700200528      *****************************************************************
032800200528      *                                                               *
032900200528      *  SRACCS   : Check for valid access                            *
033000200528      *                                                               *
033100200528      *  CALLED BY: SRINIT  - Initialise and define fields            *
033200200528      *                                                               *
033300200528      *  CALLS    : SRERR   - report error and close down program     *
033400200528      *                                                               *
033500200528      *****************************************************************
033600200528     CSR   SRACCS        BEGSR
033700200528      *
033800200528      *  Set up subroutine stack name
033900200528      *
034000200528     C                   ADD       1             Q
034100200528     C                   MOVEL     'SRACCS'      @STK(Q)
034200200528      *                                                                   045014
034300200528      *  Call AOCNTLR0 to see if access should be checked                 045014
034400200528      *                                                                   045014
034500200528     C                   CALLB     'AOCNTLR0'                           9090                   04501
034600200528     C     R#RTN         PARM      *BLANKS       O#RTN             7                           04501
034700200528     C                   PARM                    P#CNTL                                        04501
034800200528      *                                                                   045014
034900200528     C     *IN90         IFEQ      '1'                                                         04501
035000200528     C     R#RTN         ORNE      *BLANKS                                                     04501
035100200528     C                   MOVEL     'AOCNTLR0'    W0FILE                                        04501
035200200528     C                   MOVEL     '*CALL'       W0KEY                                         04501
035300200528     C                   Z-ADD     1             W0ERNB                                        04501
035400200528     C                   MOVEL     ERR@(5)       DBNARR                                        04501
035500200528     C                   EXSR      SRERR                                                       04501
035600200528     C                   MOVEL     *BLANKS       R#RTN             7                           04501
035700200528     C                   END                                                                   04501
035800200528      *                                                                   045014
035900200528      * No access validation required                                     045014
036000200528      *                                                                   045014
036100200528     C     P#ACCK        CABEQ     'N'           EXACCS                                        04501
036200200528      *
036300200528      *  Check for valid access
036400200528      *
036500200528     C                   MOVEL     *BLANKS       @PGMF            10
036600200528     C                   MOVEL     *BLANKS       @PGMFA           10
036700200528      *
036800200528      *  If already found only test for change
036900200528      *
037000200528     C     @T            IFGE      1
037100200528     C                   CALLB     'AOCREPT'                            9090
037200200528     C                   PARM      'CPF9898'     #MSGID            7
037300200528     C                   PARM      'QCPFMSG'     #MSGF            10
037400200528     C                   PARM      *BLANKS       #MSGFL           10
037500200528     C                   PARM      'Check'       #MSGDT          256
037600200528     C                   PARM      '*PRV'        #MSGR             5
037700200528     C                   PARM      PGM@(@T)      #PRGM            10
037800200528     C                   PARM      *BLANKS       #MSGQ            10
037900200528     C                   PARM      '*INFO  '     #MSGT             7
038000200528      *
038100200528      *  If found set flag to stop checking of all valid programs
038200200528      *
038300200528     C     *IN90         IFEQ      '0'
038400200528     C     PGM@(1)       ANDNE     PGM@(X)
038500200528     C                   MOVEL     'PG_FND'      @PGMF
038600200528     C                   ELSE
038700200528     C                   Z-ADD     0             @T                5 0
038800200528     C                   END
038900200528     C                   END
039000200528      *
039100200528     C                   DO        3             X                 5 0
039200200528      *
039300200528      *  Check for program in stack
039400200528      *
039500200528     C                   CALLB     'AOCREPT'                            9090
039600200528     C                   PARM      'CPF9898'     #MSGID
039700200528     C                   PARM      'QCPFMSG'     #MSGF
039800200528     C                   PARM      *BLANKS       #MSGFL
039900200528     C                   PARM      'Check'       #MSGDT
040000200528     C                   PARM      '*PRV'        #MSGR
040100200528     C                   PARM      PGM@(X)       #PRGM
040200200528     C                   PARM      *BLANKS       #MSGQ
040300200528     C                   PARM      '*INFO  '     #MSGT
040400200528      *
040500200528      *  Set flag if program found
040600200528      *
040700200528     C     *IN90         IFEQ      '0'
040800200528     C     PGM@(1)       ANDNE     PGM@(X)
040900200528     C                   MOVEL     'PG_FND'      @PGMF
041000200528     C                   Z-ADD     X             @T                5 0
041100200528     C     @PGMFA        IFEQ      'PG_FND'
041200200528     C                   GOTO      ENDLOP
041300200528     C                   END
041400200528     C                   END
041500200528     C     *IN90         IFEQ      '0'
041600200528     C     PGM@(1)       ANDEQ     PGM@(X)
041700200528     C                   MOVEL     'PG_FND'      @PGMFA
041800200528     C     @PGMF         IFEQ      'PG_FND'
041900200528     C                   GOTO      ENDLOP
042000200528     C                   END
042100200528     C                   END
042200200528     C                   END
042300200528     C     ENDLOP        TAG
042400200528      *
042500200528      *  Set flag if program found
042600200528      *
042700200528     C     @PGMF         IFNE      'PG_FND'
042800200528     C     @PGMFA        ORNE      'PG_FND'
042900200528     C                   MOVEL     '*PROGRAM'    W0FILE
043000200528     C                   MOVEL     '*ONLY'       W0KEY
043100200528     C                   Z-ADD     4             W0ERNB
043200200528     C                   MOVEL     ERR@(2)       W0NARR
043300200528     C                   EXSR      SRERR
043400200528     C                   END
043500200528      *
043600200528      *  Unwind subroutine stack name
043700200528      *
043800200528     C     EXACCS        TAG
043900200528     C                   MOVEA     *BLANKS       @STK(Q)
044000200528     C                   SUB       1             Q
044100200528      *
044200200528     CSR                 ENDSR
044300200528     C/EJECT
044400200528      *****************************************************************
044500200528      *                                                               *
044600200528      *  SRERR    : Report error and close down program               *
044700200528      *                                                               *
044800200528      *  CALLED BY: SRACCS - Valid access                             *
044900200528      *             SRINIT - Initialise and define fields             *
045000200528      *                                                               *
045100200528      *  CALLS    : *NONE                                             *
045200200528      *                                                               *
045300200528      *****************************************************************
045400200528     CSR   SRERR         BEGSR
045500200528      *
045600200528      *  Dump program
045700200528      *
045800200528     C                   MOVEL     '*ERROR*'     w0rtn                                        189280
045900200528     C                   DUMP
046000200528      *
046100200528      *  Send message to MOPERQ
046200200528      *
046300200528     C                   MOVEL     *BLANKS       DBDTA
046400200528     C                   MOVEL     'AOMEMSU0'    DBPGM
046500200528     C                   MOVEL     @STK(Q)       DBSTK
046600200528     C                   MOVEL     W0KEY         DBKEY
046700200528     C                   MOVEL     W0ERNB        DBERNB
046800200528     C                   MOVEL     W0FILE        DBFILE
046900200528     C     W0NARR        IFEQ      *BLANKS
047000200528     C                   MOVEL     ERR@(1)       DBNARR
047100200528     C                   ELSE
047200200528     C                   MOVEL     W0NARR        DBNARR
047300200528     C                   END
047400200528      *
047500200528     C                   CALLB     'AOCREPT'                            9090
047600200528     C                   PARM      'MEM5000'     #MSGID
047700200528     C                   PARM      'MIDAS  '     #MSGF
047800200528     C                   PARM      *BLANKS       #MSGFL
047900200528     C                   PARM      DBDTA         #MSGDT
048000200528     C                   PARM      '*PRV'        #MSGR
048100200528     C                   PARM      '*'           #PRGM
048200200528     C                   PARM      'MOPERQ '     #MSGQ
048300200528     C                   PARM      '*INFO  '     #MSGT
048400200528      *
048500200528      *  Close down program
048600200528      *
048700200528     C                   SETON                                        LR
048800200528     C                   MOVEL     '*ERROR*'     W0RTN
048900200528     C                   RETURN
049000200528      *
049100200528     CSR   EXERR         ENDSR
049200200528     C/EJECT
049300200528      *****************************************************************
049400200528      *                                                               *
049500200528      *  SRFILE   : *PSSR routine for all files                       *
049600200528      *                                                               *
049700200528      *  CALLED BY: IBM controlled - invalid access to file           *
049800200528      *                                                               *
049900200528      *  CALLS    : SRERR   - report error and close down program     *
050000200528      *                                                               *
050100200528      *****************************************************************
050200200528     CSR   SRFILE        BEGSR
050300200528      *
050400200528      *  Dump program
050500200528      *
050600200528     C     @UMSID        IFEQ      'CPF4128'                                                AR868380
050700200528     C     @@UMSID       OREQ      'CPF4128'                                                AR868380
050800200528     C     *IN91         OREQ      '1'                                                      AR868380
050900200528     C                   SETON                                        LR                    AR868380
051000200528     C                   MOVEL     '*RECLCK'     W0RTN                                      AR868380
051100200528     C                   ELSE                                                               AR868380
051200200528     C                   MOVEL     '*SRFILE'     w0rtn                                        189280
051300200528     C                   DUMP
051400200528      *
051500200528      *  If called again seton LR and return
051600200528      *
051700200528     C     @@FILE        IFNE      *BLANKS
051800200528     C                   MOVEL     '1'           *INLR
051900200528     C                   RETURN
052000200528     C                   END
052100200528     C                   MOVEL     'Y'           @@FILE            1
052200200528      *
052300200528      *  Send message to MOPERQ
052400200528      *
052500200528     C                   MOVEL     *BLANKS       DBDTA
052600200528     C                   MOVEL     'AOMEMSU0'    DBPGM
052700200528     C                   MOVEL     @STK(Q)       DBSTK
052800200528     C                   MOVEL     ##ERST        DBKEY
052900200528     C                   Z-ADD     1             DBERNB
053000200528     C                   MOVEL     ##ERFL        DBFILE
053100200528     C                   MOVEL     ERR@(4)       DBNARR
053200200528      *
053300200528     C                   CALLB     'AOCREPT'                            9090
053400200528     C                   PARM      'MEM5000'     #MSGID
053500200528     C                   PARM      'MIDAS  '     #MSGF
053600200528     C                   PARM      *BLANKS       #MSGFL
053700200528     C                   PARM      DBDTA         #MSGDT
053800200528     C                   PARM      '*PRV'        #MSGR
053900200528     C                   PARM      '*'           #PRGM
054000200528     C                   PARM      'MOPERQ '     #MSGQ
054100200528     C                   PARM      '*INFO  '     #MSGT
054200200528      *
054300200528      *  Close down program
054400200528      *
054500200528     C                   SETON                                        LR
054600200528     C                   MOVEL     '*ERROR*'     W0RTN
054700200528                                                                                            AR868380
054800200528     C                   ENDIF                                                              AR868380
054900200528                                                                                            AR868380
055000200528     C                   RETURN
055100200528      *
055200200528     CSR   EXFILE        ENDSR
055300200528     C/EJECT
055400200528      *****************************************************************
055500200528      *                                                               *
055600200528      *  SRINIT   : Initialise and define fields                      *
055700200528      *                                                               *
055800200528      *  CALLED BY: Main processing                                   *
055900200528      *                                                               *
056000200528      *  CALLS    : SRACCS - valid access                             *
056100200528      *                                                               *
056200200528      *****************************************************************
056300200528     CSR   SRINIT        BEGSR
056400200528      *
056500200528      *  Set up copyright statement
056600200528      *
056700200528     C                   MOVEA     CPY@          BIS@             80
056800200528      *
056900200528      *  Set up subroutine stack name
057000200528      *
057100200528     C                   ADD       1             Q                 5 0
057200200528     C                   MOVEL     'SRINIT'      @STK(Q)
057300200528      *
057400200528      *  Define W0 database error variables
057500200528      *
057600200528     C     *LIKE         DEFINE    DBFILE        W0FILE
057700200528     C     *LIKE         DEFINE    DBKEY         W0KEY
057800200528     C     *LIKE         DEFINE    DBERNB        W0ERNB
057900200528     C     *LIKE         DEFINE    DBNARR        W0NARR
058000200528     C     *LIKE         DEFINE    DBPREF        W0PREF
058100200528      *
058200200528      *  Check for programs in stack if none found error
058300200528      *
058400200528     C                   EXSR      SRACCS
058500200528      *
058600200528      ***Override*file*MEMOS*to*share(*NO)                                CCB002
058700200528      *  Override file MEMOSL1 to share(*NO)                              CCB002
058800200528      *
058900200528     C                   MOVEA     CMD@(1)       EDT
059000200528     C***********          MOVEL'MEMOS'   U#FILE 10                       CCB002
059100200528     C                   MOVEL     'MEMOSL1'     U#FILE           10                           CCB00
059200200528     C                   MOVEA     U#FILE        EDT(17)
059300200528     C                   MOVEA     EDT           OVRDBF           80
059400200528     C                   Z-ADD     80            CMDLEN           15 5
059500200528     C                   CALL      'QCMDEXC'                              90    90
059600200528     C                   PARM                    OVRDBF
059700200528     C                   PARM                    CMDLEN
059800200528      *
059900200528     C     *IN90         IFEQ      '1'
060000200528     C                   MOVEL     '*CALL  '     W0FILE
060100200528     C                   MOVEL     'QCMDEXC'     W0KEY
060200200528     C                   Z-ADD     1             W0ERNB
060300200528     C                   EXSR      SRERR
060400200528     C                   END
060500200528      *                                                                   CCB002
060600200528      *  Override file MEMOSL2 to share(*NO)                              CCB002
060700200528      *                                                                   CCB002
060800200528     C                   MOVEA     CMD@(1)       EDT                                           CCB00
060900200528     C                   MOVEL     'MEMOSL2'     U#FILE           10                           CCB00
061000200528     C                   MOVEA     U#FILE        EDT(17)                                       CCB00
061100200528     C                   MOVEA     EDT           OVRDBF           80                           CCB00
061200200528     C                   Z-ADD     80            CMDLEN           15 5                         CCB00
061300200528     C                   CALL      'QCMDEXC'                              90    90             CCB00
061400200528     C                   PARM                    OVRDBF                                        CCB00
061500200528     C                   PARM                    CMDLEN                                        CCB00
061600200528      *                                                                   CCB002
061700200528     C     *IN90         IFEQ      '1'                                                         CCB00
061800200528     C                   MOVEL     '*CALL  '     W0FILE                                        CCB00
061900200528     C                   MOVEL     'QCMDEXC'     W0KEY                                         CCB00
062000200528     C                   Z-ADD     2             W0ERNB                                        CCB00
062100200528     C                   EXSR      SRERR                                                       CCB00
062200200528     C                   END                                                                   CCB00
062300200528      *
062400200528      *  Open Memos file for update
062500200528      *
062600200528     C***********          OPEN MEMOS                                     CCB002
062700200528     C**********         OPEN      MEMOSL1                                              CCB00 157989
062800200528     C**********         OPEN      MEMOSL2                                              CCB00 157989
062900200528      *
063000200528      *  Open SDBANKL1 file for working day
063100200528      *
063200200528     C                   OPEN      SDBANKL1
063300200528      *
063400200528     C                   MOVEL     'BANK'        BJBANK
063500200528     C     BJBANK        CHAIN     @BANKL1                            90
063600200528     C     *IN90         IFEQ      '1'
063700200528     C                   MOVEL     'SDBANKL1'    W0FILE
063800200528     C                   MOVEL     '*ONLY'       W0KEY
063900200528     C                   Z-ADD     2             W0ERNB
064000200528     C                   EXSR      SRERR
064100200528     C                   END
064200200528     C                   CLOSE     SDBANKL1
064300200528      *
064400200528      *  Indicate that set up is complete
064500200528      *
064600200528     C                   SETON                                        50
064700200528      *
064800200528      *  Unwind subroutine stack name
064900200528      *
065000200528     C     EXINIT        TAG
065100200528     C                   MOVEA     *BLANKS       @STK(Q)
065200200528     C                   SUB       1             Q
065300200528      *
065400200528     CSR                 ENDSR
065500200528     C/EJECT
065600200528     OMEMOSMDF  E            UPDMMS
065700200528     O                       LDBLN
065800200528     O                       CLBLN
065900200528     O@MEMOSXX  E            UPDMM1                                             CCB002
066000200528     O                       LDBLN                                              CCB002
066100200528     O                       CLBLN                                              CCB002
066200200528**CTDATA CPY@
066300200528(c) Finastra International Limited 2001
066400200528**CTDATA PGM@
066500200528AOMEMSU0      Memos Update
066600200528AOSPOSU0      Control Update of On-line positions
066700200528QCL           Command Entry
066800200528**CTDATA ERR@
066900200528See dump for further information
067000200528Invalid Access to update object
067100200528Record not found or marked as deleted
067200200528File access error occurred - see dump for full details - see key for opcode
067300200528Error occurred on call to program - see dumps for further details
067400200528**CTDATA CMD@
067500200528OVRDBF     FILE(XXXXXXXXXX) SHARE(*NO) SECURE(*YES)
