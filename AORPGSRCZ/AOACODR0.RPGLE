     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/***D ***RPG***********************************************************   CAP035
/*STD *  RPGBASEMOD                                                   *   CAP035
/*EXI *  TEXT('Midas AO Account codes access object')
     F*****************************************************************
     F*                                                               *
     F*     Midas  ACCESS OBJECTS                                 *
     F*                                                               *
     F*     AOACODR0 - ACCOUNT CODES                                  *
     F*                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
     F*                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CPB004             Date 11Jul02               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP035             Date 07Jun99               *
      *                 CGL010             Date 08Nov99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSD005             Date 01Mar99               *
      *                 CTI002             Date 23Dec98               *
     F*                    S01505             DATE 18JUL94            *
     F*                    S01486             DATE 18JUL94            *
     F*                    S01461             DATE 11FEB94            *
     F*                    LN0947             DATE 29JAN91            *
     F*                    S01314             DATE 20FEB91            *
     F*                    S01230             DATE 03/01/90           *   S01230
     F*                    S01230             DATE 23/11/89           *   S01230
     F*                    S01230             DATE 06/11/89           *   S01230
     F*                    E01168             DATE 21/02/89           *
     F*                                                               *
     F*****************************************************************
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CPB004 - Account closing. Recompiled over changed SDACODPD.  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP035 - Member converted from an OPM program to an ILE      *
      *           module and an ILE *PGM member of the same name has  *
      *           been created (in AOPGMSRC).                         *
      *           ILE modules can make a bound call to the module.    *
      *           OPM programs can make a dynamic call to the *PGM.   *
      *  CGL010 - Future Value Dated Journal Entries for Non-Retail   *
      *           Accounts.                                           *
      *     CSD005 - Standing Data Account Narrative.  Add new field
      *              to SDACODPD.  Recompilation of programs.
      *     CTI002 - Recompiled : File SDACODPD changed               *
     F*     S01505 - Profit Centre Accounting Development:            *
     F*              - Recompiled over changed SDACODPD.              *
     F*     S01486 - Private Banking Development:                     *
     F*              - Recompiled over changed SDACODPD.              *
     F*     S01461 - RECOMPILED OVER CHANGED SDACODPD.                *
     F*     LN0947 - CHANGES TO SDACODPD                              *
     F*     S01314 - CHANGES MADE DURING R10 PTF INCORPORATION        *   S01230
     F*     S01230 - STANDARDISE ACCESS PROGRAM                       *   S01230
     F*****************************************************************   S01230
      /EJECT
     F*FSTART
      ************************************************************
     F*SDACODL0IF  E           K        DISK                           UC LN0947
     FSDACODL1  IF   E           K DISK    USROPN                               LN0947
      * IN  - @A5REA6 Account codes    (AFNB)                             S01230
      * IN  - @A5REA6 Account codes    (ACCD)                             S01230
      ************************************************************
      /EJECT                                                              S01230
     D*ESTART                                                             S01230
      ************************************************************        S01230
      ************************************************************        S01230
      /EJECT
     D*ISTART
      ************************************************************
     D P@MGDA          DS                                                       S01230
     D  @MG                    1     50                                         S01230
     D                                     DIM(1) CTDATA PERRCD(1)                               S01
     D PGMDS          SDS
      * Program Status data structure
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0
      *
     D***********************P@A5RF    E DSSDACODPD                       S01230
     D D@FMT         E DS                  EXTNAME(SDACODPD)                    S01230
      * @A5REA6 - Account code record format data structure
      *                                                                   S01230
     D***********************P@FMT       DS     148                       S01230
     D*P@FMT       DS                            148                      S01230
      **Internal*book*code*data*structure.                                S01230
      *
     D***P@FMT**   E DSDSFDY                                             S01230 CGL010
     D P@FMT         E DS                  EXTNAME(DSSDY)                       CGL010
     D* External Data structure to hold the outgoing record format        S01230
     D* of the file.                                                      S01230
      *
     D***********************P@AFNB      DS                               S01230
     D P@ACCD          DS                                                       S01230
      * Key field data structure
     D  W@SL01                 1      1
     D  W@SL02                 2      2
     D  W@SL03                 3      3
     D  W@SL04                 4      4
     D  W@SL05                 5      5                                                       CGL029
     D  W@SL06                 6      6                                                       CGL029
     D  W@SL07                 7      7                                                       CGL029
     D  W@SL08                 8      8                                                       CGL029
     D  W@SL09                 9      9                                                       CGL029
     D  W@SL10                10     10                                                       CGL029
      *
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C*********************PARM           P@AFNB  4        I:Key field    S01230
     C*********************PARM           P@A5RF           O:Format       S01230
     C**********         PARM                    P@ACCD            4      I:Key field   S0123 CGL029
     C                   PARM                    P@ACCD           10                          CGL029
     C                   PARM                    P@FMT                          O:FORMAT       S0123
      *****************************************************
      *MAIN
     C     P@OPTN        IFEQ      '*SAME  '                                                   S0123
     C     *IN01         COMP      '0'                                    91                   S0123
     C                   GOTO      T@SKIP                                                      S0123
     C                   END                                                                   S0123
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       939495     ¦ error
     C                   SETOFF                                       969798     ¦ indicators
      *
      * First call - open file :
      *
     C     *IN01         IFEQ      '0'                                          IF 1 FIRST TIME
     C*********************OPEN SDACODL0               91    Open file    LN0947
     C                   OPEN      SDACODL1                             91        Open file    LN094
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   SETON                                        01          Set ind.
     C     P@RTCD        CABEQ     '*OPEN  '     T@SKIP                           Open only
     C                   END                                                    FI 1
      *
      * Last call - close file and terminate program :
      *
     C***********P@RTCD    IFEQ '*FREE  '                  IF 2 FREE PROGRS01230
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 2 FREE PROGRS0123
     C*********************CLOSESDACODL0               92    Close file   LN0947
     C                   CLOSE     SDACODL1                             92        Close file   LN094
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   SETON                                        LR          Set ind.
     C                   GOTO      T@SKIP                                         Return
     C                   END                                                    FI 2
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 FIRST RECORD
     C     *LOVAL        SETLL     @A5REA6                            9390        Set file
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   END                                                    FI 3
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 NEXT RECORD
     C                   READ      @A5REA6                              9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 4
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 LAST RECORD
     C     *HIVAL        SETGT     @A5REA6                              90        Set file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   END                                                    FI 5
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 PREV.RECORD
     C                   READP     @A5REA6                              9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 6
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 KEYED ACCESS
     C     P@OPTN        OREQ      '*VERIFY'                                     OR
     C     W@SL01        IFEQ      '?'                                          IF 8 SELECT
     C     W@SL02        OREQ      '?'                                           OR
     C     W@SL03        OREQ      '?'                                           OR
     C     W@SL04        OREQ      '?'                                           OR
     C     W@SL05        OREQ      '?'                                                        CGL029
     C     W@SL06        OREQ      '?'                                                        CGL029
     C     W@SL07        OREQ      '?'                                                        CGL029
     C     W@SL08        OREQ      '?'                                                        CGL029
     C     W@SL09        OREQ      '?'                                                        CGL029
     C     W@SL10        OREQ      '?'                                                        CGL029
     C*********************CALL 'SDDJSRR'              98    <SELECT>     S01230
     C                   CALL      'SD0031S'                            98        <SELECT>     S0123
     C                   PARM      *BLANK        P@RTC2            7              B:Return code
     C*********************PARM *BLANK    P@AFNB             B:Key        S01230
     C                   PARM      *BLANK        P@ACCD                           B:Key        S0123
     C     *IN98         CABEQ     '1'           T@SKIP                           Program error
     C     P@RTC2        CABNE     *BLANK        T@SKIP               9797        No selection
     C                   END                                                    FI 8
     C***********P@AFNB    CHAIN@A5REA6              9590    Get record   S01230
     C     P@ACCD        CHAIN     @A5REA6                            9590        Get record   S0123
     C     *IN95         CABEQ     '1'           T@SKIP                           No record found
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 7
      *
     C     P@OPTN        IFNE      '*KEY   '                                    IF 9 NOT KEYED
     C     P@OPTN        ANDNE     '*NEXT  '                                     AND NOT SEQ.
     C     P@OPTN        ANDNE     '*PREV  '                                     AND
     C     P@OPTN        ANDNE     '*VERIFY'                                     AND           S0123
     C     P@OPTN        ANDNE     '*FREE  '                                     AND           S0123
     C                   SETON                                          96        Parameter error
     C                   END                                                    FI 9
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
     C   97              MOVE      '*NOSEL '     P@RTCD                         No selection
     C   98              MOVE      '*CALL  '     P@RTCD                         Call error
      *
      * Caller requests message sent to program queue :
      *
     C     W@RTCD        IFEQ      '*MSG   '                                    IF 10 SEND MSG
     C     P@RTCD        ANDNE     *BLANK                                        AND ERROR
     C***90                MOVE 'ACO0001' P@MGID             File error   S01314
     C***91                MOVE 'ACO0002' P@MGID             Open error   S01314
     C***92                MOVE 'ACO0003' P@MGID             Close error  S01314
     C***93                MOVE 'ACO0004' P@MGID             Empty file   S01314
     C***94                MOVE 'ACO0005' P@MGID             End of file  S01314
     C***95                MOVE 'ACO0006' P@MGID             No rcd found S01314
     C***96                MOVE 'ACO0007' P@MGID             Option error S01314
     C***97                MOVE 'ACO0009' P@MGID             No selection S01314
     C***98                MOVE 'ACO0010' P@MGID             Call error   S01314
     C   90              MOVE      'ACO1001'     P@MGID                           File error   S0131
     C   91              MOVE      'ACO1002'     P@MGID                           Open error   S0131
     C   92              MOVE      'ACO1003'     P@MGID                           Close error  S0131
     C   93              MOVE      'ACO1004'     P@MGID                           Empty file   S0131
     C   94              MOVE      'ACO1005'     P@MGID                           End of file  S0131
     C   95              MOVE      'ACO1006'     P@MGID                           No rcd found S0131
     C   96              MOVE      'ACO1007'     P@MGID                           Option error S0131
     C   97              MOVE      'ACO1009'     P@MGID                           No selection S0131
     C   98              MOVE      'ACO1010'     P@MGID                           Call error   S0131
     C                   CALL      'ZASNMG'                             99        <SEND MESSAGE>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Program name
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Message ID
     C                   PARM      *BLANK        P@MSGF           10              I:Message file
     C                   PARM      *BLANK        P@MGKY            4              O:Message key
     C                   PARM      *BLANK        P@MGDA           50              I:Message data
     C                   PARM      '*DIAG'       P@MGTP            7              I:Message type
     C                   END                                                    FI 10
      *                                                                   S01230
      * Caller Requests DB Error Handling                                 S01230
      *                                                                   S01230
     C     W@RTCD        IFEQ      '*DBERR'                                     IF             S0123
     C     P@RTCD        ANDNE     *BLANK                                         AND          S0123
     C                   DUMP                                                                  S0123
     C                   CALL      'DBERRCTL'                                                  S0123
     C                   END                                                    FI             S0123
      *                                                                   S01230
     C     P@OPTN        IFNE      '*VERIFY'                                                   S0123
     C     P@OPTN        ANDNE     '*FREE'                                                     S0123
     C     P@RTCD        ANDNE     '*OPTION'                                                   S0123
     C                   MOVEL     D@FMT         P@FMT                                         S0123
     C                   END                                                                   S0123
      *
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
SDACODPD  AOACODR0  ACCOUNT CODES                                         S01230
