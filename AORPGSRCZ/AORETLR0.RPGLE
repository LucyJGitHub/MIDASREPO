     H DEBUG
      *****************************************************************
/***D ***RPG***********************************************************   CAP002
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Retail Details              *RDR')
     F********************************************************************
     F*                                                                  *
     F*  Midas  ACCESS OBJECTS
     F*                                                                  *
     F*     AORETLR0 - READ ACCESS TO RETAIL DETAILS FILE                *
     F*                I.C.D. RECORD - ONLY ONE RECORD IN FILE
     F*                                                                  *
      *  (c) Finastra International Limited 2001                         *
     F*                                                                  *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002             Date 01May98               *
      *                 S01230             Date 23/11/89              *
     F*                    S01230             DATE 06/11/89              *S01230
     F*                                                                  *
     F********************************************************************
      *  MD046248 - Finastra Rebranding                               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP002 - Member converted from an OPM program to an ILE      *
      *           module and an ILE *PGM member of the same name has  *
      *           been created (in AOPGMSRC).                         *
      *           ILE modules can make a bound call to the module.    *
      *           OPM programs can make a dynamic call to the *PGM.   *
     F*     S01230 - STANDARDISE ACCESS PROGRAMS                         *S01230
     F********************************************************************S01230
     F*
     F* ID F  C  H  L     FUNCTION OF INDICATORS
     F*
     F*       01       OPEN FILE - SDRETL
     F*       90       FILE ERROR
     F*       91       OPEN ERROR
     F*       92       CLOSE ERROR
     F*       93       EMPTY FILE
     F*       96       OPTION ERROR
     F*
     F********************************************************************
      /EJECT
     F*FSTART
      ************************************************************
     FSDRETLL1  IF   E           K DISK    USROPN
      * IN  - @BMREEL Retail Details  (HOCY)
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
     D*********D@FMT     E DSSDRETLD0                                     S01230
     D D@FMT         E DS                  EXTNAME(SDRETLPD)                    S01230
      * @BMREEL - Retail Details Data Record Format Data Structure
      *
     D P@FMT         E DS                  EXTNAME(DSFDY)                       S01230
     D* EXTERNAL DATA STRUCTURE TO HOLD THE OUTGOING RECORD FORMAT        S01230
     D* OF THE FILE.                                                      S01230
      *                                                                   S01230
     D*******P@FMT       DS                             15                S01230
     D*******                                 1  15 BSCOPY                S01230
      * Copy of Record Format Data Structure to be Passed Back
      * to the Calling Program After 1st Call.
      *
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
     C                   PARM      D@FMT         P@FMT                          O:Format
      *****************************************************
      *MAIN
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       9396       ¦ error flags
      *
      * First call - open file - read record - close file
      *
      * Subsequent calls will return the format name.
      *
     C     P@OPTN        IFEQ      '*FIRST  '                                   IF 1  VALID
     C     P@OPTN        OREQ      '*NEXT   '                                         OPTION
     C     P@OPTN        OREQ      '*PREV   '                                         HAS
     C     P@OPTN        OREQ      '*LAST   '                                         BEEN
     C     P@OPTN        OREQ      '*KEY    '                                         ENTERED
     C     P@OPTN        OREQ      '*FREE   '
     C     P@OPTN        OREQ      '*VERIFY '
     C     P@OPTN        OREQ      '*SAME   '
     C     *IN01         IFEQ      '0'                                          IF 2 FIRST TIME
     C                   SETON                                        01          Set ind.
     C                   OPEN      SDRETLL1                             91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   READ      @BMREEL                              9093      Read record
     C                   CLOSE     SDRETLL1                             92        Close file
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C     *IN93         CABEQ     '1'           T@SKIP                   LR      Empty error
     C                   SETON                                        LR          Set ind.
     C                   END                                                    FI 2
     C                   ELSE
     C                   SETON                                        96
     C                   END                                                    FI 1
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
     C   96              MOVE      '*OPTION'     P@RTCD                         Option Inval
      *
      * Caller requests message sent to program queue :
      *
     C     W@RTCD        IFEQ      '*MSG   '                                    IF 9 SEND MSG
     C     P@RTCD        ANDNE     *BLANK                                        AND ERROR
     C   90              MOVE      'ACO1001'     P@MGID                           File error
     C   91              MOVE      'ACO1002'     P@MGID                           Open error
     C   92              MOVE      'ACO1003'     P@MGID                           Close error
     C   93              MOVE      'ACO1004'     P@MGID                           Empty file
     C   96              MOVE      'ACO1007'     P@MGID                           OPTION INVAL
     C                   CALLB     'ZASNMG'                                       <SEND MSG>
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
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
AORETLPD  RETLSTR0  Retail Details
**CTDATA CPY@
(c) Finastra International Limited 2001
