     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas AO Weighting code description')
      *****************************************************************
      *                                                               *
      ***Midas**ACCESS*OBJECTS*****************************************                       CGP001
      *  Midas - Global Access Objects                                *                       CGP001
      *                                                               *
      ***AOWEIGR0*-*Read*Access*to*Weighting*Code*Description**********                       CGP001
      *  GPAOWEIGR0 - Read Access to Weighting Code Description       *                       CGP001
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 247772             Date 12Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGP001  *RENAMED   Date 12Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001  *CREATE    Date 12Oct99               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  247772 - Change LF/GPWEIGL1 by new LF/GPWEIGL2               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGP001 -  Renamed from AOWEIGR0 to GPAOWEIGR0.               *
      *         -  Moved to global layer.                             *
      *         -  Converted to ILE.                                  *
      *  CPB001 -  'Private Banking' Module                           *
      *                                                               *
      *****************************************************************
      *
      * Function of indicators
      *
      *       01       OFF ON THE FIRST RUN
      *       90       FILE ERROR
      *       91       OPEN ERROR
      *       92       CLOSE ERROR
      *       93       EMPTY FILE
      *       94       END OF FILE
      *       95       NO RECORD FOUND
      *       96       OPTION ERROR
      *       97       NO SELECTION
      *       98       CALL ERROR (SDMDSRR)
      *       99       CALL ERROR (ZASNMG)
      *
      /EJECT
      ************************************************************
     F*SDWEIGL1IF*E****       K        DISK                           UC                      CGP001
     F***GPWEIGL1  IF   E           K DISK    USROPN                                          247772
     FGPWEIGL2  IF   E           K DISK    USROPN                                             247772
      * IN  - SDWEIGD0 Weighting Code desc Details
      ************************************************************
      /EJECT
      ************************************************************
      *
     D P@MGDA          DS
     D  @MG                    1     50
     D                                     DIM(1) CTDATA PERRCD(1)
     D PGMDS          SDS
      * Program Status data structure
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0
      *
     D*D@FMT****E*DSSDWEIGPD****                                                              CGP001
     D D@FMT         E DS                  EXTNAME(GPWEIGPD)
      * SDWEIGD0 - Weighting Code record format data structure
      *
     D P@FMT         E DS                  EXTNAME(DSFDY)
      * Internal MESG TYPE  code data structure.
      *
     D P@WEIG          DS             2
      * Key slicing data structure (for Record Selection)
     D  W@SL01                 1      1
      *
      ************************************************************
      /EJECT
      ************************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    P@WEIG            2            I:Key field
     C                   PARM                    P@FMT                          O:Format
      ************************************************************
      *MAIN
     C     P@OPTN        IFEQ      '*SAME  '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      T@SKIP
     C                   END
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       939495     ¦ error
     C                   SETOFF                                       969798     ¦ indicators
      *
      * First call - open file :
      *
     C     *IN01         IFEQ      '0'                                          IF 1 1'st time
     C                   SETON                                        01          Set ind.
     C**********           OPEN SDWEIGL1               91    Open file                        CGP001
     C**********         OPEN      GPWEIGL1                             91        Open file   247772
     C                   OPEN      GPWEIGL2                             91        Open file   247772
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   ENDIF                                                  FI 1
      *
      * Last call - close file and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 2 Free
     C**********           CLOSESDWEIGL1               92    Close file                       CGP001
     C**********         CLOSE     GPWEIGL1                             92        Close file  247772
     C                   CLOSE     GPWEIGL2                             92        Close file  247772
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   SETON                                        LR          Set ind.
     C                   ENDIF                                                  FI 2
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 First rec
     C     *LOVAL        SETLL     SDWEIGD0                           9390        Set file
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   ENDIF                                                  FI 3
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 Next rec
     C                   READ      SDWEIGD0                             9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   ENDIF                                                  FI 4
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 Last rec
     C     *HIVAL        SETGT     SDWEIGD0                             90        Set file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   ENDIF                                                  FI 5
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 Prev rec
     C                   READP     SDWEIGD0                             9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   ENDIF                                                  FI 6
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 Keyed
     C     P@OPTN        OREQ      '*VERIFY'                                     OR
     C     W@SL01        IFEQ      '?'                                          IF 8 selection
     C**********           CALL 'SD4420S'              98    <SELECT>                         CGP001
     C                   CALL      'GP4420S'                            98        <SELECT>
     C                   PARM      *BLANK        P@RTC2            7              B:Return code
     C                   PARM      *BLANK        P@WEIG                           B:Key
     C     P@RTC2        COMP      *BLANK                             97          No selection
     C     *IN97         CABEQ     '1'           T@SKIP                           No selection
     C     *IN98         CABEQ     '1'           T@SKIP                           Program error
     C                   ENDIF                                                  FI 8
     C                   MOVE      P@WEIG        WWEIG             2 0
     C     WWEIG         CHAIN     SDWEIGD0                           9590        Get record
     C     *IN95         CABEQ     '1'           T@SKIP                           No rec found
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   ENDIF                                                  FI 7
      *
     C     P@OPTN        IFNE      '*KEY   '                                    IF 8 invalid
     C     P@OPTN        ANDNE     '*NEXT  '                                     parameter
     C     P@OPTN        ANDNE     '*PREV  '
     C     P@OPTN        ANDNE     '*VERIFY'                                     AND
     C     P@OPTN        ANDNE     '*FREE  '                                     AND
     C                   SETON                                          96        Parm error
     C                   ENDIF                                                  FI 8
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
     C                   CALL      'ZASNMG'                                       <SND MSG>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Prog name
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Msg ID
     C                   PARM      *BLANK        P@MSGF           10              I:Msg file
     C                   PARM      *BLANK        P@MGKY            4              O:Msg key
     C                   PARM                    P@MGDA           50              I:Msg data
     C                   PARM      '*DIAG'       P@MGTP            7              I:Msg type
     C                   ENDIF                                                  FI 9
      *
      * Caller Requests DB Error Handling
      *
     C     W@RTCD        IFEQ      '*DBERR'                                     IF
     C     P@RTCD        ANDNE     *BLANK                                         AND
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF                                                  FI
      *
     C     P@OPTN        IFNE      '*VERIFY'
     C     P@OPTN        ANDNE     '*FREE'
     C     P@RTCD        ANDNE     '*OPTION'
     C                   MOVEL     D@FMT         P@FMT
     C                   ENDIF
      *
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
GPWEIGPD  GPAOWEIGR0  Weighting Code
