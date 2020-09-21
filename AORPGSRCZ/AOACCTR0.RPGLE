     H DEBUG
      *****************************************************************   CAP002
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Account details')                             *
/*E*I****FIXNBR(*ZONED)************************************************                       174621
      *****************************************************************
      *                                                               *
      *   Creation Parameter To Be Noted ......                       *
      *                                                               *
      * This Program Has Been Created With The Ignore Decimal Data    *
      * Error Parameter As *YES Due To a Decimal Data Error In File   *
      *                    ~~~~~                                      *
      * : ACCNTL0                                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Midas   ACCESS OBJECTS
      *                                                               *
      *     AOACCTR0 - READ ACCESS TO ACCOUNT DETAILS FILE            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23995           Date 19May09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 174621             Date 03Feb00               *
      *                 CFT004             Date 19Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                    139277             Date 21Jul98            *   139277
      *                    CEU013             Date 01Jun98            *
      *                    CAP002             Date 01May98            *
      *                    S01117             DATE 15FEB90            *   S01117
      *                    S01230             DATE 06/11/89           *   S01230
      *                    S01230             DATE 23/10/89           *   S01230
      *                    S01168             DATE 18/04/89           *   S01168
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23995 - Authority Holder/Retail account Link missing      *
      *             (Recompile)                                       *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  174621 - FIXNBR(*ZONED) now incorporated into RPGBASEMOD     *
      *           creation parameter                                  *
      *  CFT004 - Straight Through Processing Phase 2  - Recompiled   *
      *           International Bank Account Numbers (IBAN)           *
      *  139277 - Creation parameters changed to rectify decimal data *
      *           error problem.                                      *
      *  CEU013 - A/C Posting Narrative (Recompile)                   *
      *  CAP002 - Member converted from an OPM program to an ILE      *
      *           module and an ILE *PGM member of the same name has  *
      *           been created (in AOPGMSRC).                         *
      *           ILE modules can make a bound call to the module.    *
      *           OPM programs can make a dynamic call to the *PGM.   *
      *     S01117 - RELEASE 10 CHANGES                                  *S01117
      *     S01230 - STANDARDISE ACCESS PROGRAM & COPYRIGHT ADDED        *S01230
     F*****************************************************************
     F*
     F* ID F  C  H  L     FUNCTION OF INDICATORS
     F*
     F*       01       OPEN FILE
     F*       90       FILE ERROR
     F*       91       OPEN ERROR
     F*       92       CLOSE ERROR
     F*       93       EMPTY FILE
     F*       94       END OF FILE
     F*       95       NO RECORD FOUND
     F*       96       OPTION ERROR
     F*       97       NO SELECTION
     F*       98       CALL ERROR
     F*       99       SEND MESSAGE ERROR
     F*
     F********************************************************************
      /EJECT
     F*FSTART
      ************************************************************
     FACCNTL0   IF   E           K DISK    USROPN
     F                                     RENAME(ACCNTABF:@ACCL0)
      **IN**-*ACCNTABF*Account*details*(CNUM¦CCY¦ACOD¦ACSQ)************   S01168
      * IN  - ACCNTABF Account details (CNUM¦CCY¦ACOD¦ACSQ¦BRCA)          S01168
      *...........................................................
     FACCNTL1   IF   E           K DISK    USROPN
     F                                     RENAME(ACCNTABF:@ACCL1)
      * IN  - ACCNTABF Account details (ACNO)
      ************************************************************
      /EJECT
     D*ESTART
      ****************************************************************
     D*
      * Description     : Copyright notice for inclusion in all programs
     D********************************************************************
      /EJECT
     D*ISTART
      ************************************************************
      * Description     : Copyright notice for inclusion in all programs
     D*
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D*
     D PGMDS          SDS
      * Program Status data structure
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0
      *
     D D@FMT         E DS                  EXTNAME(ACCNTAB)
      * ACCNTABF - Account details record format data structure
      *
     D P@RETL          DS
      * Retail key character->numeric conversion data structure
     D  W@RETL                 1     10  0
      *
     D P@CNUM          DS
      * Customer number key character->numeric conversion data structure
     D**W@CNUM**               1      6  0                                                    CSD027
     D  W@CNUM                 1      6A                                                      CSD027
      *
     D P@ACCD          DS
      * Account code key character->numeric conversion data structure
     D***W@ACCD*                1      4  0                                                   CGL029
     D  W@ACCD                 1     10  0                                                    CGL029
      *
     D P@ACSQ          DS
      * Account sequence key character->numeric conversion data structure
     D  W@ACSQ                 1      2  0
      *
     D P@BRCA          DS                                                       S01168
      * Branch code key definition                                        S01168
     D  W@BRCA                 1      3                                         S01168
      *                                                                   S01168
     D P@MGDA          DS
     D  @MG                    1     50
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     D P@FMT         E DS                  EXTNAME(DSSDY)                       S01230
     I*                                                                   S01230
     I* EXTERNAL DATA STRUCTURE TO HOLD THE OUTGOING RECORD FORMAT OF     S01230
     I* THE FILE                                                          S01230
     I***********P@FMT       DS                            400            S01230
     I***********                             1   1 P@DMMY                S01230
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    P@RETL           10            I:Retail key
     C                   PARM                    P@CNUM            6            I:Key field 1
     C                   PARM                    P@CUCD            3            I:Key field 2
     C**********         PARM                    P@ACCD            4            I:Key field 3 CGL029
     C                   PARM                    P@ACCD           10            I:Key field 3 CGL029
     C                   PARM                    P@ACSQ            2            I:Key field 4
     C                   PARM                    P@BRCA            3            I:Key field 5  S0111
     C                   PARM                    P@FMT                          O:OUTPUT
      *****************************************************
      *MAIN
     C     K@L0          KLIST
     C                   KFLD                    W@CNUM
     C                   KFLD                    P@CUCD
     C                   KFLD                    W@ACCD
     C                   KFLD                    W@ACSQ
     C                   KFLD                    W@BRCA                                        S0111
      *
     C     P@OPTN        IFEQ      '*SAME   '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      T@SKIP
     C                   END
      *
      *MAIN
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       939495     ¦ error
     C                   SETOFF                                       969798     ¦ indicators
     C                   SETOFF                                       50         Key indicators
      *
      * Check key to determine file to use :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF KEYED ACCESS
     C     P@OPTN        OREQ      '*VERIFY'                                    IF KEYED ACCESS
      *                    ¦
     C     P@RETL        IFNE      *BLANK                                       IF RETAIL KEY
     C                   SETON                                        50          Retail ind.
     C                   END                                                    FI
      *                    ¦
     C     P@CNUM        IFNE      *BLANK                                       IF FULL ACCOUNT
     C     P@CUCD        ANDNE     *BLANK                                        AND
     C     P@ACCD        ANDNE     *BLANK                                        AND
     C     P@ACSQ        ANDNE     *BLANK                                        AND
     C     P@BRCA        ANDNE     *BLANK                                        AND           S0111
     C                   SETOFF                                       50          Full a/c ind.
     C                   ELSE                                                   EL
     C     *IN50         CABEQ     '0'           T@SKIP                   97      No keys given
     C                   END                                                    FI
      *                    ¦
     C                   ELSE                                                   EL NOT KEYED
     C                   SETOFF                                       50          Full a/c seq.
     C                   END                                                    FI
      *
      * First call - open files :
      *
     C     *IN50         IFEQ      '0'                                          IF FULL ACCOUNT
     C     *IN01         ANDEQ     '0'                                          AND FIRST TIME
     C                   SETON                                        01          Set ind.
     C                   OPEN      ACCNTL0                              91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   END                                                    FI
      *
     C     *IN50         IFEQ      '1'                                          IF RETAIL
     C     *IN02         ANDEQ     '0'                                          AND FIRST TIME
     C                   SETON                                        02          Set ind.
     C                   OPEN      ACCNTL1                              91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   END                                                    FI
      *
      * Last call - close files and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 6 FREE PROGRAM
     C   01              CLOSE     ACCNTL0                              92        Close file
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C   02              CLOSE     ACCNTL1                              92        Close file
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   SETON                                        LR          Set ind.
     C                   END                                                    FI 6
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 FIRST RECORD
     C     *LOVAL        SETLL     @ACCL0                             9390        Set file
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   END                                                    FI 3
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 NEXT RECORD
     C                   READ      @ACCL0                               9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 4
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 LAST RECORD
     C     *HIVAL        SETGT     @ACCL0                               90        Set file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   END                                                    FI 5
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 PREV.RECORD
     C                   READP     @ACCL0                               9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 6
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 KEYED ACCESS
     C     P@OPTN        OREQ      '*VERIFY'                                     OR            S0123
     C  N50K@L0          CHAIN     @ACCL0                             9590        Get record
     C   50W@RETL        CHAIN     @ACCL1                             9590        Get record
     C     *IN95         CABEQ     '1'           T@SKIP                           No record found
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 7
      *
     C     P@OPTN        IFNE      '*KEY   '                                    IF 8 NOT KEYED
     C     P@OPTN        ANDNE     '*NEXT  '                                     AND NOT SEQ.
     C     P@OPTN        ANDNE     '*PREV  '                                     AND
     C     P@OPTN        ANDNE     '*VERIFY'                                     AND
     C     P@OPTN        ANDNE     '*FREE  '                                     AND
     C                   SETON                                          96        Parameter error
     C                   END                                                    FI 8
      *
      * No record found or End of file - return error code :
      *          _____________
     C     T@SKIP        TAG                                                    +++ SKIP +++
      *          ~~~~~~~~~~~~~
     C                   MOVE      *BLANK        P@RTCD                         No Errors
     C   90              MOVE      '*ERROR '     P@RTCD                         File error
     C   91              MOVE      '*OPEN  '     P@RTCD                         Open error
     C   92              MOVE      '*CLOSE '     P@RTCD                         Close error
     C   93              MOVE      '*EMPTY '     P@RTCD                         Empty file
     C   94              MOVE      '*EOF   '     P@RTCD                         End of file
     C   95              MOVE      '*NRF   '     P@RTCD                         No record found
     C   96              MOVE      '*OPTION'     P@RTCD                         Option error
     C   97              MOVE      '*KEY   '     P@RTCD                         Invalid key
      *
      * Caller requests message sent to program queue :
      *
     C     W@RTCD        IFEQ      '*MSG   '                                    IF 9 SEND MESSAGE
     C     P@RTCD        ANDNE     *BLANK                                        AND ERROR
     C   90              MOVE      'ACO1001'     P@MGID                           File error
     C   91              MOVE      'ACO1002'     P@MGID                           Open error
     C   92              MOVE      'ACO1003'     P@MGID                           Close error
     C   93              MOVE      'ACO1004'     P@MGID                           Empty file
     C   94              MOVE      'ACO1005'     P@MGID                           End of file
     C   95              MOVE      'ACO1006'     P@MGID                           No record found
     C   96              MOVE      'ACO1007'     P@MGID                           Option error
     C   97              MOVE      'ACO1008'     P@MGID                           Invalid key
     C/COPY WNCPYSRC,AOACCTR0C1
     C                   CALLB     'ZASNMG'                                       <SEND MESSAGE>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Program name
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Message ID
     C                   PARM      *BLANK        P@MSGF           10              I:Message file
     C                   PARM      *BLANK        P@MGKY            4              O:Message key
     C                   PARM                    P@MGDA           50              I:Message data
     C                   PARM      '*DIAG'       P@MGTP            7              I:Message type
     C/COPY WNCPYSRC,AOACCTR0C2
     C                   END                                                    FI 9
      * Caller Requests DB Error Handling                                S01230
      *                                                                  S01230
     C     W@RTCD        IFEQ      'DBERR'
     C     P@RTCD        ANDNE     *BLANK
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   END
      *
      *
      *
     C     P@OPTN        IFNE      '*VERIFY'
     C***********P@OPTN****ANDNE'*FREE'                                   S01168
     C     P@OPTN        ANDNE     '*FREE  '                                                   S0116
     C     P@RTCD        ANDNE     '*OPTION'
     C                   MOVEL     D@FMT         P@FMT
     C                   END
      *
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
ACCNTAB   AOACCTR0  GENERAL LEDGER ACCOUNT DETAILS
**CTDATA CPY@
(c) Finastra International Limited 2001
