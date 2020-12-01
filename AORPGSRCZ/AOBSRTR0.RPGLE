     H DEBUG
      *****************************************************************
/***D ***RPG***********************************************************   CAP002
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Base rate codes')                             *
     F*****************************************************************
     F*                                                               *
     F*  Midas  ACCESS OBJECTS                                        LN0357
     F*                                                               *
     F*     AOBSRTR0 - READ ACCESS TO BASE RATE CODES                 *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 17May01               *
      *                 CAP038             Date 17Mar00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                    CSW097             Date 20May99            *
     F*                    CAP002             Date 01May98            *
     F*                    CSW005             DATE 05DEC96            *
     F*                    S01461             DATE 11FEB94            *   LN0357
     F*                    LN0357             DATE 12JUN90            *   LN0357
     F*                    LN0212             DATE 22/05/90           *   LN0212
     F*                    S01230             DATE 07/01/90           *   LN0212
     F*                    S01230             DATE 23/11/00           *   S01230
     F*                    S01230             DATE 06/11/00           *   S01230
     F*                                                               *
     F*****************************************************************   S01230
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD006 - Use long DS with SDBSRTPD.                          *
      *  CAP038 - Conversion of SD inputs into modular structure      *
      *           to use as APIs.                                     *
      *           Recompiled over changed SDBSRTPD.                   *
      *  CSW097 - SWIFT 1997 Changes for FRAIRS MT34* and MT36*.      *
      *           Recompiled over changed SDBSRTR0.                   *
      *  CAP002 - Member converted from an OPM program to an ILE      *
      *           module and an ILE *PGM member of the same name has  *
      *           been created (in AOPGMSRC).                         *
      *           ILE modules can make a bound call to the module.    *
      *           OPM programs can make a dynamic call to the *PGM.   *
     F*     CSW005 - RECOMPILED OVER CHANGED SDBSRTPD.                *
     F*     S01461 - RECOMPILED OVER CHANGED SDBSRTPD.                *
     F*     LN0357 - CHANGE SD0560S TO SD0170S                        *   LN0357
     F*     LN0212 - FORMAT OF LOGICAL FILE SDBSRTL1 HAS CHANGED      *   LN0212
     F*     S01230 - STANDARDISE ACCES PROGRAMS                       *   S01230
     F*
     F* ID F  C  H  L  FUNCTION OF INDICATORS
     F*
     F*       01       OFF ON THE FIRST RUN
     F*       90       FILE ERROR
     F*       91       OPEN ERROR
     F*       92       CLOSE ERROR
     F*       93       EMPTY FILE
     F*       94       END OF FILE
     F*       95       NO RECORD FOUND
     F*       96       OPTION ERROR
     F*       97       NO SELECTION
     F*       98       CALL ERROR (SDMDSRR)
     F*
      /EJECT
     F*FSTART
      ************************************************************
     FSDBSRTL1  IF   E           K DISK    USROPN
      * IN  - @BAREDH BASE RATE CODES    (K@KEY)
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
     D***********D@FMT     E DSSDBSRTD0                                   S01230
     D D@FMT         E DS                  EXTNAME(SDBSRTPD)                    S01230
      * @BAREDH - BASE RATE RECORD FORMAT DATA STRUCTURE
      *
     D*P@FMT*********E*DS******************EXTNAME(DSFDY)                 S01230CSD006
     D P@FMT         E DS                  EXTNAME(DSSDY)                       CSD006
     D* External Data structure to hold the outgoing record format        S01230
     D* of the file.                                                      S01230
      *                                                                   S01230
     D*********P@FMT       DS                             70              S01230
     D*********                               70  70 P@DMMY               S01230
      *
     D*P@KEY1      DS                                                     S01230
     D P@CYCD          DS                                                       S01230
      * Key slicing data structure (for Record Selection)
     D  W@SL01                 1      1
     D  W@SL02                 2      2
     D  W@SL03                 3      3
     D*P@KEY2      DS                                                     S01230
     D P@BSRC          DS                                                       S01230
     D  W@SL04                 1      1
     D  W@SL05                 2      2
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
     C*********************PARM           P@KEY1           I:Key field    S01230
     C                   PARM                    P@CYCD                         I:Key field    S0123
     C*********************PARM           P@KEY2           I:Key field
     C                   PARM                    P@BSRC                         I:Key field
     C                   PARM                    P@FMT                          O:Format
      *****************************************************
      *MAIN
      *
      * Access Option *SAME input
      *
     C     P@OPTN        IFEQ      '*SAME '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      T@SKIP
     C                   END
      *
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       939495     ¦ error
     C                   SETOFF                                       969798     ¦ indicators
      *
      * SET UP THE KEY FIELD
      *
     C     K@KEY         KLIST
     C*********************KFLD           P@KEY1                          S01230
     C                   KFLD                    P@CYCD                                        S0123
     C*********************KFLD           P@KEY2                          S01230
     C                   KFLD                    P@BSRC                                        S0123
      *
      * First call - open file :
      *
     C     *IN01         IFEQ      '0'                                          IF 1 1'st time
     C                   SETON                                        01          Set ind.
     C                   OPEN      SDBSRTL1                             91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   END                                                    FI 1
      *
      * Last call - close file and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 2 Free
     C                   CLOSE     SDBSRTL1                             92        Close file
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   SETON                                        LR          Set ind.
     C                   END                                                    FI 2
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 First rec
     C************LOVAL    SETLL@BAREDH              9390    Set file     S01230
     C************LOVAL    SETLL@BSRTH5              9390    Set file     LN0212
     C     *LOVAL        SETLL     @BAREDH                            9390        Set file     LN021
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   END                                                    FI 3
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 Next rec
     C*********************READ @BAREDH                9094  Read record  S01230
     C*********************READ @BSRTH5                9094  Read record  LN0212
     C                   READ      @BAREDH                              9094      Read record  LN021
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 4
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 Last rec
     C************HIVAL    SETGT@BAREDH                90    Set file     S01230
     C************HIVAL    SETGT@BSRTH5                90    Set file     LN0212
     C     *HIVAL        SETGT     @BAREDH                              90        Set file     LN021
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   END                                                    FI 5
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 Prev rec
     C*********************READP@BAREDH                9094  Read record  S01230
     C*********************READP@BSRTH5                9094  Read record  LN0212
     C                   READP     @BAREDH                              9094      Read record  LN021
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 6
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 Key access
     C     P@OPTN        OREQ      '*VERIFY'                                    OR
     C     W@SL01        IFEQ      '?'                                          IF 8 Select
     C     W@SL02        OREQ      '?'                                           OR
     C     W@SL03        OREQ      '?'                                           OR
     C     W@SL04        OREQ      '?'                                           OR
     C     W@SL05        OREQ      '?'                                           OR
     C     W@SL01        IFEQ      '?'                                          IF 10
     C     W@SL02        OREQ      '?'
     C     W@SL03        OREQ      '?'
     C                   MOVE      *BLANK        TKEY1             3
     C                   ELSE
     C*********************MOVE P@KEY1    TKEY1                           S01230
     C                   MOVE      P@CYCD        TKEY1                                         S0123
     C                   END                                                    FI 10
     C     W@SL04        IFEQ      '?'                                          IF 11
     C     W@SL05        OREQ      '?'
     C                   MOVE      *BLANK        TKEY2             2
     C                   ELSE
     C*********************MOVE P@KEY2    TKEY2                           S01230
     C                   MOVE      P@BSRC        TKEY2                                         S0123
     C                   END                                                    FI 11
     C*********************CALL 'SDMKSRR'              98    <SELECT>     S01230
     C*********************CALL 'SD0560S'              98    <SELECS01230 LN0357
     C                   CALL      'SD0170S'                            98        <SELECT>     LN035
     C                   PARM      *BLANK        P@RTC2            7              B:Return code
     C*********************PARM TKEY1     P@KEY1                          S01230
     C                   PARM      TKEY1         P@CYCD                                        S0123
     C*********************PARM TKEY2     P@KEY2                          S01230
     C                   PARM      TKEY2         P@BSRC                                        S0123
     C     P@RTC2        COMP      *BLANK                             97          No selection
     C     *IN97         CABEQ     '1'           T@SKIP                           No selection
     C     *IN98         CABEQ     '1'           T@SKIP                           Program error
     C                   END                                                    FI 8
     C***********K@KEY     CHAIN@BAREDH              9590    Get record   S01230
     C***********K@KEY     CHAIN@BSRTH5              9590    Get record   LN0212
     C     K@KEY         CHAIN     @BAREDH                            9590        Get record   LN021
     C     *IN95         CABEQ     '1'           T@SKIP                           No rec found
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 7
      *
     C     P@OPTN        IFNE      '*KEY   '                                    IF 8 invalid
     C     P@OPTN        ANDNE     '*NEXT  '                                        parameter
     C     P@OPTN        ANDNE     '*PREV  '
     C     P@OPTN        ANDNE     '*VERIFY'
     C     P@OPTN        ANDNE     '*FREE  '
     C                   SETON                                          96        Parm error
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
     C     W@RTCD        IFEQ      '*MSG   '                                    IF 9 SND MSG
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
     C                   CALLB     'ZASNMG'                                       <SND MSG>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Prog name
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Msg ID
     C                   PARM      *BLANK        P@MSGF           10              I:Msg file
     C                   PARM      *BLANK        P@MGKY            4              O:Msg key
     C                   PARM                    P@MGDA           50              I:Msg data
     C                   PARM      '*DIAG'       P@MGTP            7              I:Msg type
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
     C     P@OPTN        ANDNE     '*OPTION'                                      AND
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
SDBSRTPD  AOBSRTR0  Base Rate Codes
**CTDATA CPY@
(c) Finastra International Limited 2001
