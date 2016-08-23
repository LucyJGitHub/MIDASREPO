     H DEBUG
      *****************************************************************
/***D ***RPG***********************************************************   CAP002
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Broker codes')
     F********************************************************************
     F*                                                                  *
     F*  Midas  ACCESS OBJECTS                                            LN0359
     F*                                                                  *
     F*     AOBROKR0 - READ ACCESS TO BROKER CODES FILE                  *
     F*                                                                  *
      *  (c) Misys International Banking Systems Ltd. 2001            *
     F*                                                                  *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *     Last Amend No. 125375             Date 17Jun98            *
      *     Prev Amend No. CAP002             Date 01May98            *
     F*                    S01461             DATE 11FEB94               *
     F*                    LN0359             DATE 12JUN90               *LN0212
     F*                    LN0213             DATE 22/05/90              *LN0212
     F*                    S01230             DATE 08/01/90              *S01230
     F*                    S01230             DATE 23/11/89              *S01230
     F*                    S01230             DATE 06/11/89              *S01230
     F*                                                                  *
     F********************************************************************
     F*                                                                  *LN0212
     F*  125375 - If the broker only uses electronic dealing then     *
     F*           specify ELEC in field 24D and do not specify broker *
     F*           details in field 88. (Recompile only).              *
      *  CAP002 - Member converted from an OPM program to an ILE      *
      *           module and an ILE *PGM member of the same name has  *
      *           been created (in AOPGMSRC).                         *
      *           ILE modules can make a bound call to the module.    *
      *           OPM programs can make a dynamic call to the *PGM.   *
     F*     S01461 - RECOMPILED OVER CHANGED SDBROKPD.                   *
     F*     LN0359 - SHOULD CALL SD0070S AND NOT SD0570S
     F*     LN0212 - FORMAT NAME ON FILE HAS CHANGED                     *LN0212
     F*     S01230 - STANDARDISE ACCESS PROGRAMS                         *S01230
     F********************************************************************S01230
     F* ID F  C  H  L    FUNCTION OF INDICATORS                          *
     F*                                                                  *
     F*       01      OFF 1ST TIME ROUND
     F*       90      FILE ERROR
     F*       91      FILE OPEN ERROR                                    *
     F*       92      ERROR ON FILE CLOSE                                *
     F*       93      FILE EMPTY
     F*       94      EOF
     F*       95      NO RECORD FOUND
     F*       96      PARAMETER ERROR
     F*       97      IF NO SELECTION
     F*       98      ERROR ON PROGRAM CALL (SDFPSRB)
     F*       LR      LAST RECORD
     F*
     F********************************************************************
      /EJECT
     F*FSTART
      ************************************************************
     FSDBROKL1  IF   E           K DISK    USROPN
      * IN  - @A9REBC REGION codes    (BROK)                              S01230
      ************************************************************
      /EJECT
     D*ESTART
      ************************************************************
      ************************************************************
      * Description     : Copyright notice for inclusion in all programs
     D*                                                                   S01230
     D********************************************************************S01230
      ************************************************************        S01230
      /EJECT
     D*ISTART
      ************************************************************
     D P@MGDA          DS
     D  @MG                    1     50
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     D PGMDS          SDS
      * Program Status data structure
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0
      *
     D**********D@FMT     E DSSDBROKD0                                    S01230
     D D@FMT         E DS                  EXTNAME(SDBROKPD)                    S01230
      * @A9REBC - Region code record format data structure                S01230
      *
     D P@FMT         E DS                  EXTNAME(DSFDY)                       S01230
     D* External Data structure to hold the outgoing record format        S01230
     D* the file.                                                         S01230
      *                                                                   S01230
     D*********P@FMT       DS                             51              S01230
     D*********                              51  51 P@DMMY                S01230
      *
     D*P@BQTX      DS                                                     S01230
     D P@BROK          DS                                                       S01230
      * Key slicing data structure (for Record Selection)
     D  W@SL01                 1      1
     D  W@SL02                 2      2
     D  W@SL03                 3      3
     D  W@SL04                 4      4
      *
     D*                                                                   S01230
      * Description     : Copyright notice for inclusion in all programs
     D*                                                                   S01230
     D A@CPY           DS                                                       S01230
      * Copyright array
     D  CPY@                   1     80                                         S01230
     D                                     DIM(1) CTDATA PERRCD(1)
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C*********************PARM           P@BQTX  4        I:Key field    S01230
     C                   PARM                    P@BROK            4            I:Key field    S0123
     C                   PARM                    P@FMT                          O:Format
      *****************************************************
      *MAIN
      *
      * Access Option *SAME input
      *
     C     P@OPTN        IFEQ      '*SAME  '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      T@SKIP
     C                   END
      *
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       939495     ¦ error
     C                   SETOFF                                       969798     ¦ indicators
      *
      * First call - open file :
      *
     C     *IN01         IFEQ      '0'                                          IF 1 FIRST TIME
     C                   SETON                                        01          Set ind.
     C                   OPEN      SDBROKL1                             91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   END                                                    FI 1
      *
      * Last call - close file and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 2 FREE PROG
     C                   CLOSE     SDBROKL1                             92        Close file
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   SETON                                        LR          Set ind.
     C                   END                                                    FI 2
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 FIRST REC
     C************LOVAL    SETLL@A9REBC              9390    Set file     S01230
     C************LOVAL    SETLL@BROKH3              9390    Set file     LN0212
     C     *LOVAL        SETLL     @A9REBC                            9390        Set file     LN021
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   END                                                    FI 3
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 NEXT REC
     C*********************READ @A9REBC                9094  Read record  S01230
     C*********************READ @BROKH3                9094  Read record  LN0212
     C                   READ      @A9REBC                              9094      Read record  LN021
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 4
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 LAST REC
     C************HIVAL    SETGT@A9REBC                90    Set file     S01230
     C************HIVAL    SETGT@BROKH3                90    Set file     LN0212
     C     *HIVAL        SETGT     @A9REBC                              90        Set file     LN021
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   END                                                    FI 5
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 PREV.REC
     C*********************READP@A9REBC                9094  Read record  S01230
     C*********************READP@BROKH3                9094  Read record  LN0212
     C                   READP     @A9REBC                              9094      Read record  LN021
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 6
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 KEYED ACC
     C     P@OPTN        OREQ      '*VERIFY'                                     OR
     C     W@SL01        IFEQ      '?'
     C     W@SL02        OREQ      '?'
     C     W@SL03        OREQ      '?'
     C     W@SL04        OREQ      '?'
     C*********************CALL 'SDA7SRR'              98    <SELECT>     S01230
     C*********************CALL 'SD0570S'              98    <SELECS01230 LN0359
     C                   CALL      'SD0070S'                            98        <SELECT>     LN035
     C                   PARM      *BLANK        P@RTC2            7              B:Return code
     C*********************PARM *BLANK    P@BQTX             B:Key        S01230
     C                   PARM      *BLANK        P@BROK                           B:Key        S0123
     C     P@RTC2        COMP      *BLANK                             97          No selection
     C     *IN97         CABEQ     '1'           T@SKIP                           No selection
     C     *IN98         CABEQ     '1'           T@SKIP                           Program error
     C                   END                                                    FI 8
     C***********P@BQTX    CHAIN@A9REBC              9590    Get record   S01230
     C***********P@BROK    CHAIN@BROKH3              9590    Get record   LN0212
     C     P@BROK        CHAIN     @A9REBC                            9590        Get record   LN021
     C     *IN95         CABEQ     '1'           T@SKIP                           No record fnd
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 7
      *
     C     P@OPTN        IFNE      '*KEY   '                                    IF 8 NOT KEYED
     C     P@OPTN        ANDNE     '*NEXT  '                                     AND NOT SEQ.
     C     P@OPTN        ANDNE     '*PREV  '                                     AND
     C     P@OPTN        ANDNE     '*VERIFY'                                     AND
     C     P@OPTN        ANDNE     '*FREE  '                                     AND
     C                   SETON                                          96        Parameter err
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
     C   97              MOVE      '*NOSEL '     P@RTCD                         No selection
     C   98              MOVE      '*CALL  '     P@RTCD                         Called Pgm.err.
      *
      * Caller requests message sent to program queue :
      *
     C     W@RTCD        IFEQ      '*MSG   '                                    IF 9 SEND MSG
     C     P@RTCD        ANDNE     *BLANK                                        AND ERROR
     C   90              MOVE      'ACO1001'     P@MGID                           File error
     C   91              MOVE      'ACO1002'     P@MGID                           Open error
     C   92              MOVE      'ACO1003'     P@MGID                           Close error
     C   93              MOVE      'ACO1004'     P@MGID                           Empty file
     C   94              MOVE      'ACO1005'     P@MGID                           End of file
     C   95              MOVE      'ACO1006'     P@MGID                           No record fnd
     C   96              MOVE      'ACO1007'     P@MGID                           Option error
     C   97              MOVE      'ACO1009'     P@MGID                           No selection
     C   98              MOVE      'ACO1010'     P@MGID                           Call error
     C                   CALLB     'ZASNMG'                                       <SND MESSAGE>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Program nme
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Message ID
     C                   PARM      *BLANK        P@MSGF           10              I:Message fl
     C                   PARM      *BLANK        P@MGKY            4              O:Message key
     C                   PARM                    P@MGDA           50              I:Message dta
     C                   PARM      '*DIAG'       P@MGTP            7              I:Message typ
     C                   END                                                    FI 9
      *
      * Caller Requests DB Error Handling
      *
     C     W@RTCD        IFEQ      '*DBERR '                                    IF
     C     P@RTCD        ANDNE     *BLANK                                         AND
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   END                                                    FI
      *
     C     P@OPTN        IFNE      '*VERIFY'                                    IF 13
     C     P@OPTN        ANDNE     '*FREE  '                                      AND
     C     P@RTCD        ANDNE     '*OPTION'                                      AND
     C                   MOVEL     D@FMT         P@FMT                          FI 13
     C                   END
      *
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
SDBROKPD  AOBROKR0  Broker Codes
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2001
