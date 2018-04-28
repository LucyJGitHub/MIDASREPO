     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/***D ***RPG***********************************************************   CAP002
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Access Midas Modules        *RDR')
      *****************************************************************
      *                                                               *
      *  Midas  ACCESS OBJECTS                                        *
      *                                                               *
      *     AOMMODR0 - READ ACCESS TO MIDAS MODULE FLAG FILE          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *     Last Amend No. CAP084             Date 04Mar04            *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *     Prev Amend No. CAP002             Date 01May98            *
      *                     087931            DATE 22MAY95            *
      *                     LN0104            DATE 01JUN90            *
      *                     S01230            DATE 25/OCT/89          *
      *                     E01168            DATE 21/MAR/89          *
      *                                                               *
      *****************************************************************
      *  CAP084 - API wrapper project - set *LOVAL in case this       *
      *           file has been opened elsewhere and a RCLRSC has     *
      *           been performed (this resets *IN01)                  *
      *  CAP002 - Member converted from an OPM program to an ILE      *
      *           module and an ILE *PGM member of the same name has  *
      *           been created (in AOPGMSRC).                         *
      *           ILE modules can make a bound call to the module.    *
      *           OPM programs can make a dynamic call to the *PGM.   *
      *     087931 - Error in call to program with OPTN(*FREE)        *
      *                                                               *
      *     LN0104 - REMOVE SET ON OF LR IF RECORD FOUND -            *
      *              TO ALLOW PROGRAM TO REMAIN IN PAG WHEN OPENED    *
      *              IN SD1600                                        *
      *     S01230 - STANDARDISE ACCESS PROGRAMS                      *
      *****************************************************************
      *
      * ID F  C  H  L  FUNCTION OF INDICATORS
      *
      *       01       OFF ON THE FIRST RUN
      *       90       FILE ERROR
      *       91       OPEN ERROR
      *       92       CLOSE ERROR
      *       93       EMPTY FILE
      *       96       OPTION ERROR
      *
      /EJECT
      *FSTART
      ************************************************************
     FSDMMODL1  IF   E           K DISK    USROPN
      * IN  - MMODFF MIDAS MODULE FLAG DETAILS
      ************************************************************
      /EJECT
     D*ESTART
      ************************************************************
      ************************************************************
      /EJECT
     D*ISTART
      ************************************************************
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
     D*P@FMT     E DSSDMMODPD                                             S01230
     D D@FMT         E DS                  EXTNAME(SDMMODPD)                    S01230
      * @BTREE4 - MIDAS MODULE FLAG RECORD FORMAT DATA STRUCTURE
      *
     D*P@FMT       DS                            128                      S01230
      * Internal data structure.                                          S01230
      *                                                                   S01230
     D P@FMT         E DS                  EXTNAME(DSFDY)                       S01230
     I* External Data structure to hold the outgoing record format        S01230
     I* of the file.                                                      S01230
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    P@FMT
      *****************************************************
      *MAIN
     C     P@OPTN        IFEQ      '*SAME  '                                                   S0123
     C     *IN01         COMP      '0'                                    91                   S0123
     C                   GOTO      T@SKIP                                                      S0123
     C                   END                                                                   S0123
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       9396       ¦ error
     C     P@OPTN        IFEQ      '*KEY'
     C     P@OPTN        OREQ      '*FIRST'
     C     P@OPTN        OREQ      '*LAST'
     C     P@OPTN        OREQ      '*NEXT'
     C     P@OPTN        OREQ      '*PREV'
     C*******    P@OPTN    OREQ '*FREE'                                   087931
     C     P@OPTN        OREQ      '*SAME'
     C     P@OPTN        OREQ      '*VERIFY'
     C     *IN01         IFEQ      '0'                                            IF2 1'st time
     C                   SETON                                        01
     C                   OPEN      SDMMODL1                             91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C     *LOVAL        SETLL     @BGREC8                                                    CAP084
     C                   READ      @BGREC8                                93
     C                   CLOSE     SDMMODL1                             92        Close file
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C***********          SETON                     LR      Set ind.     LN0104
     C                   END                                                      FI2
     C                   ELSE
      *                                                                   087931
     C     P@OPTN        IFEQ      '*FREE  '                                                   08793
     C                   SETON                                        LR                       08793
     C                   RETURN                                                                08793
     C                   ELSE                                                                  08793
      *                                                                   087931
     C                   SETON                                        96          Parm error
     C                   END
     C                   END                                                                   08793
      *
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
     C   96              MOVE      '*OPTION'     P@RTCD                         No selection
      *
      * Caller requests message sent to program queue :
      *
     C     W@RTCD        IFEQ      '*MSG   '                                    IF 9 SND MSG
     C     P@RTCD        ANDNE     *BLANK                                        AND ERROR
     C   90              MOVE      'ACO1001'     P@MGID                           File error
     C   91              MOVE      'ACO1002'     P@MGID                           Open error
     C   92              MOVE      'ACO1003'     P@MGID                           Close error
     C   93              MOVE      'ACO1004'     P@MGID                           Empty file
     C   96              MOVE      'ACO1007'     P@MGID
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
      *  CALLER REQUESTS DB ERROR HANDLING
      *
     C     W@RTCD        IFEQ      '*DBERR'
     C     P@RTCD        ANDNE     *BLANK
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   END
      *                                                                   S01230
     C     P@OPTN        IFNE      '*VERIFY'                                                   S0123
     C     P@OPTN        ANDNE     '*FREE'                                                     S0123
     C     P@RTCD        ANDNE     '*OPTION'                                                   S0123
     C                   MOVEL     D@FMT         P@FMT                                         S0123
     C                   END                                                                   S0123
      *
      *
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
SDMMODPD  AOMMODR0  Midas Module Flags
