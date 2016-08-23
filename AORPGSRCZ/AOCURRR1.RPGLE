     H DEBUG
      *****************************************************************
/***D ***RPG***********************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Currency codes access object')                *
      *****************************************************************
      *                                                               *
      *  Midas  ACCESS OBJECTS                                        *
      *                                                               *
      *     AOCURRR1 - CURRENCY CODES                                 *
      *                                                               *
      *  Function:  This module will read or access customer additio  *
      *             nal details from extended file PF/SDCUSTPD which  *
      *             the original AOCUSTR0 cannot hold. This program   *
      *             uses an external data structure DSLDY defined as  *
      *             2000 in length much greater compared to DSSDY w/c *
      *             is only 800 long.                                 *
      *                                                               *
      *             *Note : Newly developed or amended programs       *
      *                     accessing customer details file should    *
      *                     use of this module as replacement for the *
      *                     old access object.                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2015            *
      *                                                               *
      *  Last Amend No. CGL165  *Create    Date 23Feb15               *
      *  Prev Amend No.                    Date DDMMMYY               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CGL165 - Dual Withholding Tax                                *
     F*                                                                  *
     F********************************************************************
     F*                                                                  *
     F*        D F C H L   FUNCTION INDICATOR                            *
     F*                                                                  *
     F*        01     INITIALISATION                                     *
     F*        90     FILE ERROR                                         *
     F*        91     FILE OPEN ERROR                                    *
     F*        92     FILE CLOSE ERROR                                   *
     F*        93     FILE EMPTY                                         *
     F*        94     END OF FILE                                        *
     F*        95     NO RECORD FOUND                                    *
     F*        96     OPTION ERROR                                       *
     F*        97     NO SELECTION                                       *
     F*        98     ERROR ON CALL OF SELECTION PROGRAM(SD0020S)        *
     F*                                                                  *
     F********************************************************************
      /EJECT
     F*FSTART
      ************************************************************
     F*SDCURRL0IF  E           K        DISK                           UC LN0662
     FSDCURRL1  IF   E           K DISK    USROPN                               LN0662
      * IN  - @A6REA3 Currencies       (CYCD)
      ************************************************************
      /EJECT
     D*ESTART
      ****************************************************************
     D*                                                                   S01230
     D* Description     : Copyright notice for inclusion in all programs  S01230
     D********************************************************************S01230
      ****************************************************************
      /EJECT
     D*ISTART
      ************************************************************
     D* Description     : Copyright notice for inclusion in all programs  S01230
     D*                                                                   S01230
     D A@CPY           DS                                                       S01230
      * Copyright array                                                   S01230
     D  CPY@                   1     80                                         S01230
     D                                     DIM(1) CTDATA PERRCD(1)
     D*                                                                   S01230
     D PGMDS          SDS
      * Program Status data structure
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0
      *
     D P@MGDA          DS
     D  @MG                    1     50
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     D***********D@FMT     E DSSDCURRD0
     D D@FMT         E DS                  EXTNAME(SDCURRPD)
      * @A6REA3 - Currency record format data structure
      *
     D P@FMT         E DS                  EXTNAME(DSLDY)
     D* External Data structure to hold the outgoing record format
     D* of the file.
      *
      *
     D P@K101          DS
      * Key slicing data structure (for Record Selection)
     D  W@SL01                 1      1
     D  W@SL02                 2      2
     D  W@SL03                 3      3
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    P@K101                         I:Key field
     C                   PARM                    P@FMT                          O:Format
      *****************************************************
      *MAIN
     C     P@OPTN        IFEQ      '*SAME   '
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
     C                   OPEN      SDCURRL1                             91        Open file    LN066
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   END                                                    FI 1
      *
      * Last call - close file and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 2 FREE PGM
     C                   CLOSE     SDCURRL1                             92        Close file   LN066
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   SETON                                        LR          Set ind.
     C                   END                                                    FI 2
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 FIRST REC
     C     *LOVAL        SETLL     @A6REA3                            9390        Set file
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   END                                                    FI 3
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 NEXT REC
     C                   READ      @A6REA3                              9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 4
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 LAST REC
     C     *HIVAL        SETGT     @A6REA3                              90        Set file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   END                                                    FI 5
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 PREV.REC
     C                   READP     @A6REA3                              9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 6
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 KEY ACCESS
     C     P@OPTN        OREQ      '*VERIFY'                                     OR         ESS
     C     W@SL01        IFEQ      '?'                                          IF 8 SELECT
     C     W@SL02        OREQ      '?'                                           OR
     C     W@SL03        OREQ      '?'                                           OR
     C                   CALL      'SD0020S'                            98        <SELECT>     S0122
     C                   PARM      *BLANK        P@RTC2            7              B:Return code
     C                   PARM      *BLANK        P@K101                           B:Key
     C     P@RTC2        COMP      *BLANK                             97          No selection
     C     *IN97         CABEQ     '1'           T@SKIP                           No selection
     C     *IN98         CABEQ     '1'           T@SKIP                           Program error
     C                   END                                                    FI 8
     C     P@K101        CHAIN     @A6REA3                            9590        Get record
     C     *IN95         CABEQ     '1'           T@SKIP                           No rec found
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 7
      *
     C     P@OPTN        IFNE      '*KEY   '                                    IF 8 NOT KEYED
     C     P@OPTN        ANDNE     '*NEXT  '                                     AND NOT SEQ.
     C     P@OPTN        ANDNE     '*PREV  '                                     AND
     C     P@OPTN        ANDNE     '*VERIFY'                                     AND
     C     P@OPTN        ANDNE     '*SAME  '                                     AND
     C     P@OPTN        ANDNE     '*FREE  '                                     AND
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
     C   95              MOVE      '*NRF   '     P@RTCD                         No rec found
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
     C   95              MOVE      'ACO1006'     P@MGID                           No rec found
     C   96              MOVE      'ACO1007'     P@MGID                           Option error
     C   97              MOVE      'ACO1009'     P@MGID                           No selection
     C   98              MOVE      'ACO1010'     P@MGID                           Call error
     C                   CALLB     'ZASNMG'                                       <SEND MSG>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Pgm name
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Message ID
     C                   PARM      *BLANK        P@MSGF           10              I:Msg file
     C                   PARM      *BLANK        P@MGKY            4              O:Message key
     C                   PARM                    P@MGDA           50              I:Msg data
     C                   PARM      '*DIAG'       P@MGTP            7              I:Msg type
     C                   END                                                    FI 9
      *
     C     W@RTCD        IFEQ      '*DBERR'
     C     P@RTCD        ANDNE     *BLANK
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   END
      *
      *
      *
     C     P@OPTN        IFNE      '*VERIFY'
     C     P@OPTN        ANDNE     '*FREE'
     C     P@RTCD        ANDNE     '*OPTION'
     C                   MOVEL     D@FMT         P@FMT
     C                   END
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
SDCURRPD  AOCURRR0  Currency Codes
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2015
