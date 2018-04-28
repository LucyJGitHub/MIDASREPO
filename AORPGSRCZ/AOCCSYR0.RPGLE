     H DEBUG
      *****************************************************************
/***D ***RPG***********************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Currency Clearing System')
     F********************************************************************
     F*                                                                  *
     F*  Midas   ACCESS OBJECTS
     F*                                                                  *
     F*     AOCCSYR0 - READ ACCESS TO CURRENCY CLEARING SYTEM FILE       *
     F*                                                                  *
      *  (c) Misys International Banking Systems Ltd. 2001            *
     F*                                                                  *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
     F*     Last Amend No. CAP003             DATE 06AUG98               *S01230
     F*     Prev Amend No. CSW098             DATE 24MAR98               *S01230
     F*                    CSW096             DATE 07JUN96               *S01230
     F*                    LN0115             DATE 21MAY90               *S01230
     F*                    S01230             DATE 08/01/90              *S01230
     F*                    S01230             DATE 23/11/89              *S01230
     F*                    S01230             DATE 06/11/89              *S01230
     F*                    E01168             DATE 22/02/89              *S01230
     F*                                                                  *
     F********************************************************************
     F*     CAP003 - Member converted from an OPM program to an ILE      *
     F*              module and an ILE *PGM member of the same name has  *
     F*              been created (in AOPGMSRC).                         *
     F*              ILE modules can make a bound call to the module.    *
     F*              OPM programs can make a dynamic call to the *PGM.   *
     F*     CSW098 - SWIFT 1998 Changes (Recompiled)
     F*     CSW096 - SWIFT 96 Novemebr Changes (RECOMPILE)
     F*     LN0115 - RECORD FORMAT FOR SDCCSYL1 CHANGED.
     F*     S01230 - STANDARDISE ACCESS PROGRAMS                         *S01230
     F********************************************************************S01230
     F*
     F* ID F  C  H  L     FUNCTION OF INDICATORS
     F*
     F*       01       OPEN FILE
     F*       50       CHECK FOR 1ST KEY CONTAINING A ?  LEN: 3 CHARS
     F*       51       CHECK FOR 2ND KEY CONTAINING A ?  LEN: 2 CHAR
     F*       90       FILE ERROR
     F*       91       OPEN ERROR
     F*       92       CLOSE ERROR
     F*       93       EMPTY FILE
     F*       94       END OF FILE
     F*       95       NO RECORD FOUND
     F*       96       OPTION ERROR
     F*       97       NO SELECTION
     F*       98       CALL ERROR
     F*
     F********************************************************************
      /EJECT
     F*FSTART
      ************************************************************
     FSDCCSYL1  IF   E           K DISK    USROPN
      **IN**-*@DMREGW*CURRENCY*CLEARING*(CYCD CLSY)*                      LN0115
      * IN  - @DPREG4 CURRENCY CLEARING (CYCD CLSY)                       LN0115
      ************************************************************
      /EJECT
     D*ISTART
      *****************************************
      *****************************************                           S01230
     D* Description     : Copyright notice for inclusion in all progra    S01230
     D*                                                                   S01230
     D********************************************************************S01230
      *****************************************                           S01230
      /EJECT
     D*ISTART
      ************************************************************
     D P@MGDA          DS            50
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
     D***********D@FMT     E DSSDCCSYD0                                   S01230
     D D@FMT         E DS                  EXTNAME(SDCCSYPD)                    S01230
      **@DMREGW*-*CCY*CLEARING*SYSTEM*RECORD*FORMAT*DATA*STRUCTURE*       LN0115
      * @DPREG4 - CCY CLEARING SYSTEM RECORD FORMAT DATA STRUCTURE        LN0115
      *
     D*P@FMT       DS                              5                      E01168
     D*                                       5   5 W@DMMY                E01168
     D P@FMT         E DS                  EXTNAME(DSFDY)                       S01230
     D* External Data structure to hold the outgoing record format        S01230
     D* of the file.                                                      S01230
      *                                                                   S01230
     D***********P@FMT       DS                              9            S01230
     D***********                             9   9 W@DMMY                S01230
      *
     D***P@KEY1      DS                              3                    S01230
     D P@CYCD          DS             3                                         S01230
     D  W@SL01                 1      1
     D  W@SL02                 2      2
     D  W@SL03                 3      3
      *
     D***P@KEY2      DS                              2                    S01230
     D P@CLSY          DS             2                                         S01230
     D  W@SL04                 1      1
     D  W@SL05                 2      2
      *
     D*                                                                   S01230
     D* Description     : Copyright notice for inclusion in all programs  S01230
     D*                                                                   S01230
     D A@CPY           DS                                                       S01230
     D* Copyright array                                                   S01230
     D  CPY@                   1     80                                         S01230
     D                                     DIM(1) CTDATA PERRCD(1)
      *
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C*********************PARM           P@KEY1           I:Key field    S01230
     C                   PARM                    P@CYCD                         I:Key field    S0123
     C*********************PARM           P@KEY2           I:Key field    S01230
     C                   PARM                    P@CLSY                         I:Key field    S0123
     C                   PARM                    P@FMT                          O:Format
      *****************************************************
      *MAIN
      *
     C     P@OPTN        IFEQ      '*SAME  '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      T@SKIP
     C                   END
      *
     C                   SETOFF                                       5051       ¦Key Indicator
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       939495     ¦ error
     C                   SETOFF                                       969798     ¦ indicators
      *
      * DEFINE KEY LIST
      *
     C     K@KEY         KLIST
     C*********************KFLD           P@KEY1                          S01230
     C                   KFLD                    P@CYCD                                        S0123
     C*********************KFLD           P@KEY2                          S01230
     C                   KFLD                    P@CLSY                                        S0123
      *
      * First call - open file :
      *
     C     *IN01         IFEQ      '0'                                          IF 1 FIRST TIME
     C                   SETON                                        01          Set ind.
     C                   OPEN      SDCCSYL1                             91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   END                                                    FI 1
      *
      *
      * Last call - close file and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 2 FREE PROG
     C                   CLOSE     SDCCSYL1                             92        Close file
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   SETON                                        LR          Set ind.
     C                   END                                                    FI 2
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 FIRST REC
     C********** *LOVAL    SETLL@DMREGW              9390    Set file     LN0115
     C     *LOVAL        SETLL     @DPREG4                            9390        Set file     LN011
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   END                                                    FI 3
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 NEXT REC
     C*********************READ @DMREGW                9094  Read record  LN0115
     C                   READ      @DPREG4                              9094      Read record  LN011
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 4
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 LAST REC
     C********** *HIVAL    SETGT@DMREGW                90    Set file     LN0115
     C     *HIVAL        SETGT     @DPREG4                              90        Set file     LN011
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   END                                                    FI 5
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 PREV.REC
     C*********************READP@DMREGW                9094  Read record  LN0115
     C                   READP     @DPREG4                              9094      Read record  LN011
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 6
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 KEY ACC
     C     P@OPTN        OREQ      '*VERIFY'                                     OR
     C     W@SL01        IFEQ      '?'                                          IF 8 CHK KEY 1
     C     W@SL02        OREQ      '?'                                           OR
     C     W@SL03        OREQ      '?'                                           OR
     C                   SETON                                        50        KEY 1 = ?
     C*********************MOVE *BLANK    K@KEY1  3        INIT KEY NO.1  S01230
     C                   MOVE      *BLANK        K@CYCD            3            INIT KEY NO.1  S0123
     C                   ELSE                                                   OTHERWISE
     C*********************MOVE P@KEY1    K@KEY1           SET TO INPUT   S01230
     C                   MOVE      P@CYCD        K@CYCD                         SET TO INPUT   S0123
     C                   END                                                    FI 8
     C     W@SL04        IFEQ      '?'                                          IF 9 SELECT
     C     W@SL05        OREQ      '?'                                          OR
     C                   SETON                                        51        KEY 2 = ?
     C*********************MOVE *BLANK    K@KEY2  2        INIT KEY NO.2  S01230
     C                   MOVE      *BLANK        K@CLSY            2            INIT KEY NO.2  S0123
     C                   ELSE                                                   OTHERWISE
     C*********************MOVE P@KEY2    K@KEY2           SET TO INPUT   S01230
     C                   MOVE      P@CLSY        K@CLSY                         SET TO INPUT   S0123
     C                   END                                                    FI 9
     C     *IN50         IFEQ      '1'                                          IF 10
     C     *IN51         OREQ      '1'                                          OR
     C*********************CALL 'SDPVSRR'              98    <SELECT>     S01230
     C                   CALL      'SD0380S'                            98        <SELECT>     S0123
     C                   PARM      *BLANK        P@RTC2            7              B:Return code
     C*********************PARM K@KEY1    P@KEY1             B:Key NO 1   S01230
     C                   PARM      K@CYCD        P@CYCD                           B:Key NO 1   S0123
     C*********************PARM K@KEY2    P@KEY2             B:Key NO 2   S01230
     C                   PARM      K@CLSY        P@CLSY                           B:Key NO 2   S0123
     C     P@RTC2        COMP      *BLANK                             97          No selection
     C     *IN97         CABEQ     '1'           T@SKIP                           No selection
     C     *IN98         CABEQ     '1'           T@SKIP                           Program error
     C                   END                                                    FI 10
     C********** K@KEY     CHAIN@DMREGW              9590    Get record   LN0115
     C     K@KEY         CHAIN     @DPREG4                            9590        Get record   LN011
     C     *IN95         CABEQ     '1'           T@SKIP                           No rec found
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 7
      *
     C     P@OPTN        IFNE      '*KEY   '                                    IF 11 NOT KEYED
     C     P@OPTN        ANDNE     '*NEXT  '                                     AND NOT SEQ.
     C     P@OPTN        ANDNE     '*PREV  '                                     AND
     C     P@OPTN        ANDNE     '*VERIFY'                                     AND
     C     P@OPTN        ANDNE     '*FREE  '                                     AND
     C                   SETON                                          96        Parameter err
     C                   END                                                    FI 11
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
     C   95              MOVE      '*NRF   '     P@RTCD                         No rec found
     C   96              MOVE      '*OPTION'     P@RTCD                         Option error
     C   97              MOVE      '*NOSEL '     P@RTCD                         No selection
     C   98              MOVE      '*CALL  '     P@RTCD                         Called Pgm.err.
      *
      * Caller requests message sent to program queue :
      *
     C     W@RTCD        IFEQ      '*MSG   '                                    IF 12 SEND MSG
     C     P@RTCD        ANDNE     *BLANK                                        AND ERROR
     C   90              MOVE      'ACO1001'     P@MGID                           File error
     C   91              MOVE      'ACO1002'     P@MGID                           Open error
     C   92              MOVE      'ACO1003'     P@MGID                           Close error
     C   93              MOVE      'ACO1004'     P@MGID                           Empty file
     C   94              MOVE      'ACO1005'     P@MGID                           End of file
     C   95              MOVE      'ACO1006'     P@MGID                           No rec found
     C   96              MOVE      'ACO1007'     P@MGID                           Option error
     C   97              MOVE      'ACO1009'     P@MGID                           No selection
     C   98              MOVE      'ACO1010'     P@MGID                           Call error
     C                   CALLB     'ZASNMG'                                       <SEND MSG>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Prog name
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Msg ID
     C                   PARM      *BLANK        P@MSGF           10              I:Msg file
     C                   PARM      *BLANK        P@MGKY            4              O:Msg key
     C                   PARM                    P@MGDA           50              I:Msg data
     C                   PARM      '*DIAG'       P@MGTP            7              I:Msg type
     C                   END                                                    FI 12
      *
      *      CALLER REQUESTS DB HANDLING
      *
     C     W@RTCD        IFEQ      '*DBERR'                                     IF DB ERROR
     C     P@RTCD        ANDNE     *BLANK                                       AND
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   END                                                    FI
      *
     C     P@OPTN        IFNE      '*VERIFY'                                    IF 13
     C     P@OPTN        ANDNE     '*FREE  '                                      AND
     C     P@RTCD        ANDNE     '*OPTION'                                      AND
     C                   MOVEL     D@FMT         P@FMT
     C                   END                                                    FI 13
      *
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
SDCCSYPD  AOCCSYR0  Currency Clearing System
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2001
