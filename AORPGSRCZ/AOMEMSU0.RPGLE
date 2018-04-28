     H DEBUG
      *****************************************************************
/***D ***RPG***********************************************************   CAP002
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Update Memos file')                           *
     F********************************************************************
     F*                                                                  *
     F*  Midas - Access Objects Module
     F*                                                                  *
     F*     AOMEMSU0 - Update Memos file                                 *
     F*                                                                  *
      *  (c) Misys International Banking Systems Ltd. 2001            *
     F*                                                                  *
      *  Last Amend No. AR868380           Date 10Jun13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 157989             Date 25Apr05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 189280             Date 15Mar01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002             Date 01May98               *
     F*                  CCB002             DATE  10JUL96                *
     F*                  041693             DATE  05JAN93                *
     F*                  045014             DATE  01DEC92                *
     F*                  031876             DATE  03NOV92                *
     F*                                                                  *
     F*------------------------------------------------------------------*
     F*                                                                  *
      *  AR868380 - APISERVER on LCKW status. Return *RECLCK to       *
      *             calling program if file locking occurred on       *
      *             online position files. (Child: AR868381)          *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  157989 - EOC fails in FFC1080 (ENDCMTCTL while changes +     *
      *         - pending). This fix was applied by CER001.           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  189280 - Reset file pointer before CHAIN to MEMOS else second   *
      *           and subsequent CHAIN operations may return *NRF even   *
      *           where account exists on MEMOS.                         *
      *         - Monitor return code added when program dumps           *
      *  CAP002 - Member converted from an OPM program to an ILE         *
      *           module and an ILE *PGM member of the same name has     *
      *           been created (in AOPGMSRC).                            *
      *           ILE modules can make a bound call to the module.       *
      *           OPM programs can make a dynamic call to the *PGM.      *
     F*     CCB002 - COB Performance Enhancements                        *
     F*              Access now via access object                        *
     F*              MEMOS is now accessed via GL/RE key rather than old *
     F*              relative record number.                             *
     F*                                                                  *
     F*     041693 - Delivered as part of fix.                           *
     F*                                                                  *
     F*     045014 - Add call to AOCNTLR0 for access control             *
     F*                                                                  *
     F*     031876 - New program to update MEMOS file for shadow         *
     F*              post.                                               *
     F*                                                                  *
     F*****************************************************************
     F****MEMOS   UF  E                    DISK         KCOMIT          UCCCB002
     F****                                              KINFSR SRFILE     CCB002
      *****                                                               CCB002
      ***** Define MEMOS file                                             CCB002
      *****                                                               CCB002
     FMEMOSL1   UF   E           K DISK    COMMIT                               CCB002
     F                                     USROPN
     F                                     INFSR(SRFILE)                        CCB002
     F                                     INFDS(@MEMO1)                                    AR868380
      *                                                                   CCB002
      * Define Shadow balances by G/L Account Number                      CCB002
      *                                                                   CCB002
     FMEMOSL2   UF   E           K DISK    COMMIT                               CCB002
     F                                     USROPN
     F                                     INFSR(SRFILE)                        CCB002
     F                                     RENAME(MEMOSMDF:@MEMOSXX)            CCB002
     F                                     INFDS(@MEMO2)                                    AR868380
      *                                                                   CCB002
      * Define Shadow balances by Retail Account Number                   CCB002
      *                                                                   CCB002
     FSDBANKL1  IF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
     F                                     RENAME(@BJREEF:@BANKL1)
      *
      * Define SDBANKL1 for working day & next working day
      *
     F/EJECT
      *
      *  Copyright table
      *
      *
      *  List of valid calling programs
      *
     D PGM@            S             10    DIM(3) CTDATA PERRCD(1)
      *
      *  Error texts
      *
     D**********          ERR@    1   4 80                                045014
     D ERR@            S             80    DIM(5) CTDATA PERRCD(1)                               045
      *
      *  Array of QCMDEXC commands
      *
     D CMD@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      *  Array of QCMDEXC command to edit
      *
     D EDT             S              1    DIM(80)
      *
      *  Subroutine stack
      *
     D @STK            S             10    DIM(20)
     D/EJECT
      *
      *  Data structure for compilation  - Copyright insertion
      *
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
     D @MEMO1        E DS                  EXTNAME(Y2IUDSP)                                 AR868380
     D @MEMO2        E DS                  EXTNAME(Y2IUDSP)                                 AR868380
     D                                     PREFIX(@)                                        AR868380
      *
      *  Program data structure
      *
     D DSPGM         ESDS                  EXTNAME(Y2PGDSP)
      *
      *  Send message data structure
      *
     D DBDTA           DS
     D  DBPGM                  1     10
     D  DBFILE                11     20
     D  DBKEY                 21     50
     D  DBERNB                51     55  0
     D  DBNARR                56    135
     D  DBSTK                136    145
     D  DBPREF               146    175                                         045014
      ** G/L key in case of database error.                               CCB002
      *                                                                   CCB002
     D UGLERR          DS                                                       CCB002
     D**U0CNUM**               1      6  0                                             CCB002 CSD027
     D  U0CNUM                 1      6                                                       CSD027
     D  U0CUCD                 7      9                                         CCB002
     D***U0ACCD*               10     13  0                                            CCB002 CGL029
     D***U0ACSQ*               14     15  0                                            CCB002 CGL029
     D***U0BRCA*               16     18                                               CCB002 CGL029
     D  U0ACCD                10     19  0                                                    CGL029
     D  U0ACSQ                20     21  0                                                    CGL029
     D  U0BRCA                22     24                                                       CGL029
      *                                                                   045014
      *  Input parameters data structure for AOCNTLR0                     045014
      *                                                                   045014
     D P#CNTL          DS           256                                         045014
      *                                       Access Check                045014
     D  P#ACCK                 1      1                                         045014
     I/EJECT
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      *
      * Initialise program
      *
     C     *IN50         IFEQ      '0'
     C                   EXSR      SRINIT
     C                   END
      *
      * Update Memos file with passed data
      *
     C                   EXSR      SRMEMS
      *
      *  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      * Return to calling program
      *
     C                   RETURN
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRMEMS   : Update Memos file                                 *
      *                                                               *
      *  CALLED BY: Main Processing                                   *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *****************************************************************
     CSR   SRMEMS        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRMEMS'      @STK(Q)
      *
      *  Define entry parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN             7            O:Return code
     C***********          PARM           W0RRN   70       I:MEMOS Rel. ReCCB002
     C                   PARM                    W0RETL           10 0          I:Retail A/C NuCCB00
     C**********         PARM                    W0CNUM            6 0   I:Customer NumbCCB00 CSD027
     C                   PARM                    W0CNUM            6            I:Customer Nu CSD027
     C                   PARM                    W0CUCD            3            I:Currency     CCB00
     C**********         PARM                    W0ACCD            4 0   I:Accout Code  CCB00 CGL029
     C                   PARM                    W0ACCD           10 0                        CGL029
     C                   PARM                    W0ACSQ            2 0          I:Account SequeCCB00
     C                   PARM                    W0BRCA            3            I:Branch       CCB00
     C                   PARM                    W0PSTD            5 0          I:Posting date
     C                   PARM                    W0VDAT            5 0          I:Value date
     C                   PARM                    W0AMT            15 0          I:Movement amount
     C                   PARM                    W0FTOV            1            I:FT override LDBL U
      *                                                                   CCB002
      ** Ascertain whether General Ledger or Retail.                      CCB002
      *
     C     W0RETL        IFEQ      *ZEROS                                                      CCB00
     C                   MOVE      'G'           UACTYP            1                           CCB00
     C                   ELSE                                                                  CCB00
     C                   MOVE      'R'           UACTYP                                        CCB00
     C                   ENDIF                                                                 CCB00
      *                                                                   CCB002
      ** GL key                                                           CCB002
     C     GLKEY         KLIST                                                                 CCB00
     C                   KFLD                    W0CNUM                         Customer NumberCCB00
     C                   KFLD                    W0CUCD                         Currency code  CCB00
     C                   KFLD                    W0ACCD                         Account code   CCB00
     C                   KFLD                    W0ACSQ                         Account sequencCCB00
     C                   KFLD                    W0BRCA                         Branch         CCB00
      *  Read Memos record for update                                     CCB002
      *                                                                   CCB002
     C                   OPEN      MEMOSL1                                                    157989
     C                   OPEN      MEMOSL2                                                    157989
     C***********W0RRN     CHAINMEMOSMDF             90                   CCB002
     C     UACTYP        IFEQ      'G'                                                         CCB00
     C     *LOVAL        SETLL     MEMOSL1                                                    189280
     C*****GLKEY         CHAIN     MEMOSL1                            90              CCB00 AR868380
     C     GLKEY         CHAIN     MEMOSL1                            9091                  AR868380
     C     *IN91         IFEQ      '1'                                                      AR868380
     C                   EXSR      SRFILE                                                   AR868380
     C                   ENDIF                                                              AR868380
     C                   ELSE                                                                  CCB00
     C     *LOVAL        SETLL     MEMOSL2                                                    189280
     C*****W0RETL        CHAIN     MEMOSL2                            90              CCB00 AR868380
     C     W0RETL        CHAIN     MEMOSL2                            9091                  AR868380
     C     *IN91         IFEQ      '1'                                                      AR868380
     C                   EXSR      SRFILE                                                   AR868380
     C                   ENDIF                                                              AR868380
     C                   ENDIF                                                                 CCB00
      *                                                                   CCB002
      ** If CHAIN failure ascertain correct key.                          CCB002
     C     *IN90         IFEQ      '1'                                                         CCB00
     C     RECI          ORNE      'D'                                                         CCB00
     C     UACTYP        IFEQ      'G'                                                         CCB00
     C**********         Z-ADD     W0CNUM        U0CNUM                                 CCB00 CSD027
     C                   EVAL      U0CNUM = W0CNUM                                            CSD027
     C                   MOVEL     W0CUCD        U0CUCD                                        CCB00
     C                   Z-ADD     W0ACCD        U0ACCD                                        CCB00
     C                   Z-ADD     W0ACSQ        U0ACSQ                                        CCB00
     C                   MOVEL     W0BRCA        U0BRCA                                        CCB00
     C                   MOVEL     UGLERR        W0KEY                                         CCB00
     C                   MOVEL     'MEMOSL1 '    W0FILE                                        CCB00
     C                   Z-ADD     3             W0ERNB                                        CCB00
     C                   EXSR      SRERR                                                       CCB00
     C                   ELSE                                                                  CCB00
     C                   MOVEL     W0RETL        W0KEY                                         CCB00
     C                   MOVEL     'MEMOSL2 '    W0FILE                                        CCB00
     C                   Z-ADD     3             W0ERNB                                        CCB00
     C                   EXSR      SRERR                                                       CCB00
     C                   ENDIF                                                                 CCB00
     C                   ENDIF                                                                 CCB00
      *                                                                   CCB002
     C     *IN90         IFEQ      '1'
     C     RECI          ORNE      'D'
     C***********          MOVEL'MEMOS   'W0FILE                          CCB002
     C***********          MOVELW0RRN     W0KEY                           CCB002
     C                   Z-ADD     5             W0ERNB
     C                   MOVEL     ERR@(3)       W0NARR
     C                   EXSR      SRERR
     C                   END
      *
      *  Change values on Memos record
      *
      *  If value date is today or less then alter both balances
      *
     C     W0VDAT        IFLE      BJRDNB
     C                   ADD       W0AMT         LDBLN
     C                   ADD       W0AMT         CLBLN
     C                   ELSE
      *
      *  If posting date is today or less then alter ledger balance
      *  or if FT override is in effect
      *
     C     W0PSTD        IFLE      BJRDNB
     C     W0FTOV        OREQ      'Y'
     C                   ADD       W0AMT         LDBLN
     C                   END
     C                   END
      *
      *  Update Memos fields
      *
     C     UACTYP        IFEQ      'G'                                                         CCB00
     C                   EXCEPT    UPDMMS
     C                   ELSE                                                                  CCB00
     C                   EXCEPT    UPDMM1                                                      CCB00
     C                   ENDIF                                                                 CCB00
     C/COPY WNCPYSRC,AOMEMSU0C1
      *
     C                   CLOSE     MEMOSL1                                                    157989
     C                   CLOSE     MEMOSL2                                                    157989
      *  Unwind subroutine stack name
      *
     C     EXMEMS        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRACCS   : Check for valid access                            *
      *                                                               *
      *  CALLED BY: SRINIT  - Initialise and define fields            *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *****************************************************************
     CSR   SRACCS        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRACCS'      @STK(Q)
      *                                                                   045014
      *  Call AOCNTLR0 to see if access should be checked                 045014
      *                                                                   045014
     C                   CALLB     'AOCNTLR0'                           9090                   04501
     C     R#RTN         PARM      *BLANKS       O#RTN             7                           04501
     C                   PARM                    P#CNTL                                        04501
      *                                                                   045014
     C     *IN90         IFEQ      '1'                                                         04501
     C     R#RTN         ORNE      *BLANKS                                                     04501
     C                   MOVEL     'AOCNTLR0'    W0FILE                                        04501
     C                   MOVEL     '*CALL'       W0KEY                                         04501
     C                   Z-ADD     1             W0ERNB                                        04501
     C                   MOVEL     ERR@(5)       DBNARR                                        04501
     C                   EXSR      SRERR                                                       04501
     C                   MOVEL     *BLANKS       R#RTN             7                           04501
     C                   END                                                                   04501
      *                                                                   045014
      * No access validation required                                     045014
      *                                                                   045014
     C     P#ACCK        CABEQ     'N'           EXACCS                                        04501
      *
      *  Check for valid access
      *
     C                   MOVEL     *BLANKS       @PGMF            10
     C                   MOVEL     *BLANKS       @PGMFA           10
      *
      *  If already found only test for change
      *
     C     @T            IFGE      1
     C                   CALLB     'AOCREPT'                            9090
     C                   PARM      'CPF9898'     #MSGID            7
     C                   PARM      'QCPFMSG'     #MSGF            10
     C                   PARM      *BLANKS       #MSGFL           10
     C                   PARM      'Check'       #MSGDT          256
     C                   PARM      '*PRV'        #MSGR             5
     C                   PARM      PGM@(@T)      #PRGM            10
     C                   PARM      *BLANKS       #MSGQ            10
     C                   PARM      '*INFO  '     #MSGT             7
      *
      *  If found set flag to stop checking of all valid programs
      *
     C     *IN90         IFEQ      '0'
     C     PGM@(1)       ANDNE     PGM@(X)
     C                   MOVEL     'PG_FND'      @PGMF
     C                   ELSE
     C                   Z-ADD     0             @T                5 0
     C                   END
     C                   END
      *
     C                   DO        3             X                 5 0
      *
      *  Check for program in stack
      *
     C                   CALLB     'AOCREPT'                            9090
     C                   PARM      'CPF9898'     #MSGID
     C                   PARM      'QCPFMSG'     #MSGF
     C                   PARM      *BLANKS       #MSGFL
     C                   PARM      'Check'       #MSGDT
     C                   PARM      '*PRV'        #MSGR
     C                   PARM      PGM@(X)       #PRGM
     C                   PARM      *BLANKS       #MSGQ
     C                   PARM      '*INFO  '     #MSGT
      *
      *  Set flag if program found
      *
     C     *IN90         IFEQ      '0'
     C     PGM@(1)       ANDNE     PGM@(X)
     C                   MOVEL     'PG_FND'      @PGMF
     C                   Z-ADD     X             @T                5 0
     C     @PGMFA        IFEQ      'PG_FND'
     C                   GOTO      ENDLOP
     C                   END
     C                   END
     C     *IN90         IFEQ      '0'
     C     PGM@(1)       ANDEQ     PGM@(X)
     C                   MOVEL     'PG_FND'      @PGMFA
     C     @PGMF         IFEQ      'PG_FND'
     C                   GOTO      ENDLOP
     C                   END
     C                   END
     C                   END
     C     ENDLOP        TAG
      *
      *  Set flag if program found
      *
     C     @PGMF         IFNE      'PG_FND'
     C     @PGMFA        ORNE      'PG_FND'
     C                   MOVEL     '*PROGRAM'    W0FILE
     C                   MOVEL     '*ONLY'       W0KEY
     C                   Z-ADD     4             W0ERNB
     C                   MOVEL     ERR@(2)       W0NARR
     C                   EXSR      SRERR
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C     EXACCS        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRERR    : Report error and close down program               *
      *                                                               *
      *  CALLED BY: SRACCS - Valid access                             *
      *             SRINIT - Initialise and define fields             *
      *                                                               *
      *  CALLS    : *NONE                                             *
      *                                                               *
      *****************************************************************
     CSR   SRERR         BEGSR
      *
      *  Dump program
      *
     C                   MOVEL     '*ERROR*'     w0rtn                                        189280
     C                   DUMP
      *
      *  Send message to MOPERQ
      *
     C                   MOVEL     *BLANKS       DBDTA
     C                   MOVEL     'AOMEMSU0'    DBPGM
     C                   MOVEL     @STK(Q)       DBSTK
     C                   MOVEL     W0KEY         DBKEY
     C                   MOVEL     W0ERNB        DBERNB
     C                   MOVEL     W0FILE        DBFILE
     C     W0NARR        IFEQ      *BLANKS
     C                   MOVEL     ERR@(1)       DBNARR
     C                   ELSE
     C                   MOVEL     W0NARR        DBNARR
     C                   END
      *
     C                   CALLB     'AOCREPT'                            9090
     C                   PARM      'MEM5000'     #MSGID
     C                   PARM      'MIDAS  '     #MSGF
     C                   PARM      *BLANKS       #MSGFL
     C                   PARM      DBDTA         #MSGDT
     C                   PARM      '*PRV'        #MSGR
     C                   PARM      '*'           #PRGM
     C                   PARM      'MOPERQ '     #MSGQ
     C                   PARM      '*INFO  '     #MSGT
      *
      *  Close down program
      *
     C                   SETON                                        LR
     C                   MOVEL     '*ERROR*'     W0RTN
     C                   RETURN
      *
     CSR   EXERR         ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRFILE   : *PSSR routine for all files                       *
      *                                                               *
      *  CALLED BY: IBM controlled - invalid access to file           *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *****************************************************************
     CSR   SRFILE        BEGSR
      *
      *  Dump program
      *
     C     @UMSID        IFEQ      'CPF4128'                                                AR868380
     C     @@UMSID       OREQ      'CPF4128'                                                AR868380
     C     *IN91         OREQ      '1'                                                      AR868380
     C                   SETON                                        LR                    AR868380
     C                   MOVEL     '*RECLCK'     W0RTN                                      AR868380
     C                   ELSE                                                               AR868380
     C                   MOVEL     '*SRFILE'     w0rtn                                        189280
     C                   DUMP
      *
      *  If called again seton LR and return
      *
     C     @@FILE        IFNE      *BLANKS
     C                   MOVEL     '1'           *INLR
     C                   RETURN
     C                   END
     C                   MOVEL     'Y'           @@FILE            1
      *
      *  Send message to MOPERQ
      *
     C                   MOVEL     *BLANKS       DBDTA
     C                   MOVEL     'AOMEMSU0'    DBPGM
     C                   MOVEL     @STK(Q)       DBSTK
     C                   MOVEL     ##ERST        DBKEY
     C                   Z-ADD     1             DBERNB
     C                   MOVEL     ##ERFL        DBFILE
     C                   MOVEL     ERR@(4)       DBNARR
      *
     C                   CALLB     'AOCREPT'                            9090
     C                   PARM      'MEM5000'     #MSGID
     C                   PARM      'MIDAS  '     #MSGF
     C                   PARM      *BLANKS       #MSGFL
     C                   PARM      DBDTA         #MSGDT
     C                   PARM      '*PRV'        #MSGR
     C                   PARM      '*'           #PRGM
     C                   PARM      'MOPERQ '     #MSGQ
     C                   PARM      '*INFO  '     #MSGT
      *
      *  Close down program
      *
     C                   SETON                                        LR
     C                   MOVEL     '*ERROR*'     W0RTN
                                                                                            AR868380
     C                   ENDIF                                                              AR868380
                                                                                            AR868380
     C                   RETURN
      *
     CSR   EXFILE        ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT   : Initialise and define fields                      *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *  CALLS    : SRACCS - valid access                             *
      *                                                               *
      *****************************************************************
     CSR   SRINIT        BEGSR
      *
      *  Set up copyright statement
      *
     C                   MOVEA     CPY@          BIS@             80
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      *  Define W0 database error variables
      *
     C     *LIKE         DEFINE    DBFILE        W0FILE
     C     *LIKE         DEFINE    DBKEY         W0KEY
     C     *LIKE         DEFINE    DBERNB        W0ERNB
     C     *LIKE         DEFINE    DBNARR        W0NARR
     C     *LIKE         DEFINE    DBPREF        W0PREF
      *
      *  Check for programs in stack if none found error
      *
     C                   EXSR      SRACCS
      *
      ***Override*file*MEMOS*to*share(*NO)                                CCB002
      *  Override file MEMOSL1 to share(*NO)                              CCB002
      *
     C                   MOVEA     CMD@(1)       EDT
     C***********          MOVEL'MEMOS'   U#FILE 10                       CCB002
     C                   MOVEL     'MEMOSL1'     U#FILE           10                           CCB00
     C                   MOVEA     U#FILE        EDT(17)
     C                   MOVEA     EDT           OVRDBF           80
     C                   Z-ADD     80            CMDLEN           15 5
     C                   CALL      'QCMDEXC'                              90    90
     C                   PARM                    OVRDBF
     C                   PARM                    CMDLEN
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     '*CALL  '     W0FILE
     C                   MOVEL     'QCMDEXC'     W0KEY
     C                   Z-ADD     1             W0ERNB
     C                   EXSR      SRERR
     C                   END
      *                                                                   CCB002
      *  Override file MEMOSL2 to share(*NO)                              CCB002
      *                                                                   CCB002
     C                   MOVEA     CMD@(1)       EDT                                           CCB00
     C                   MOVEL     'MEMOSL2'     U#FILE           10                           CCB00
     C                   MOVEA     U#FILE        EDT(17)                                       CCB00
     C                   MOVEA     EDT           OVRDBF           80                           CCB00
     C                   Z-ADD     80            CMDLEN           15 5                         CCB00
     C                   CALL      'QCMDEXC'                              90    90             CCB00
     C                   PARM                    OVRDBF                                        CCB00
     C                   PARM                    CMDLEN                                        CCB00
      *                                                                   CCB002
     C     *IN90         IFEQ      '1'                                                         CCB00
     C                   MOVEL     '*CALL  '     W0FILE                                        CCB00
     C                   MOVEL     'QCMDEXC'     W0KEY                                         CCB00
     C                   Z-ADD     2             W0ERNB                                        CCB00
     C                   EXSR      SRERR                                                       CCB00
     C                   END                                                                   CCB00
      *
      *  Open Memos file for update
      *
     C***********          OPEN MEMOS                                     CCB002
     C**********         OPEN      MEMOSL1                                              CCB00 157989
     C**********         OPEN      MEMOSL2                                              CCB00 157989
      *
      *  Open SDBANKL1 file for working day
      *
     C                   OPEN      SDBANKL1
      *
     C                   MOVEL     'BANK'        BJBANK
     C     BJBANK        CHAIN     @BANKL1                            90
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'SDBANKL1'    W0FILE
     C                   MOVEL     '*ONLY'       W0KEY
     C                   Z-ADD     2             W0ERNB
     C                   EXSR      SRERR
     C                   END
     C                   CLOSE     SDBANKL1
      *
      *  Indicate that set up is complete
      *
     C                   SETON                                        50
      *
      *  Unwind subroutine stack name
      *
     C     EXINIT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
     OMEMOSMDF  E            UPDMMS
     O                       LDBLN
     O                       CLBLN
     O@MEMOSXX  E            UPDMM1                                             CCB002
     O                       LDBLN                                              CCB002
     O                       CLBLN                                              CCB002
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2001
**CTDATA PGM@
AOMEMSU0      Memos Update
AOSPOSU0      Control Update of On-line positions
QCL           Command Entry
**CTDATA ERR@
See dump for further information
Invalid Access to update object
Record not found or marked as deleted
File access error occurred - see dump for full details - see key for opcode
Error occurred on call to program - see dumps for further details
**CTDATA CMD@
OVRDBF     FILE(XXXXXXXXXX) SHARE(*NO) SECURE(*YES)
