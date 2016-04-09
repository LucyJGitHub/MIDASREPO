     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/***D ***RPG***********************************************************   CAP002
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO General ledger details')
     F********************************************************************
     F*                                                                  *
     F*  Midas  ACCESS OBJECTS
     F*                                                                  *
     F*     AOGELRR0 - READ ACCESS TO GENERAL LEDGER DETAILS             *
     F*                                                                  *
      *  (c) Misys International Banking Systems Ltd. 2001            *
     F*                                                                  *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG10386           Date 05Feb06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *  Prev Amend No. CSD009             Date 10Oct00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CGL010             Date 08Nov99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002             Date 01May98               *
      *                 CEU008             Date 13Nov97               *
     F*                    S01470             Date 31Mar94               *
     F*                    LN0104             DATE 01JUN90               *
     F*                    S01230             DATE 25/10/89              *S01230
     F*                    E01168             DATE 21/02/89              *
     F*                                                                  *
     F********************************************************************
     F*                                                               *  *
      *  BUG10386 - Database error in IL0410 (Recompile).             *
      *  CSD009 - Profit Centre Accounting Default Matrix Enhancement *
      *           Recompiled due to changes on PF/SDGELRPD            *
      *  CGL010 - Future Value Dated Journal Entries for Non-Retail   *
      *           Accounts. (Recompiled over change in SDGELRL1)      *
      *  CAP002 - Member converted from an OPM program to an ILE      *
      *           module and an ILE *PGM member of the same name has  *
      *           been created (in AOPGMSRC).                         *
      *           ILE modules can make a bound call to the module.    *
      *           OPM programs can make a dynamic call to the *PGM.   *
     F*     CEU008 - Recompiled over changed SDGELRPD                    *
     F*     S01470 - RECOMPILED OVER SDGELRPD                         *  *
     F*     LN0104 - REMOVE SET ON OF LR IF RECORD FOUND -            *  *
     F*              TO ALLOW PROGRAM TO REMAIN IN PAG WHEN OPENED    *  *
     F*              IN SD1600                                        *  *
     F*     S01230 - STANDARDISE ACCESS PROGRAMS                         *S01230
     F********************************************************************S01230
     F*
     F* ID F  C  H  L  FUNCTION OF INDICATORS
     F*
     F*       01       OFF ON THE FIRST RUN
     F*       90       FILE ERROR
     F*       91       OPEN ERROR
     F*       92       CLOSE ERROR
     F*       93       EMPTY FILE
     F*       96       OPTION ERROR
     F*
      /EJECT
     F*FSTART
      ************************************************************
     FSDGELRL1  IF   E           K DISK    USROPN
      * IN  - @BKREEC GENERAL LEDGER DETAILS (BZCD)
      ************************************************************
      /EJECT
     D*ESTART
      ************************************************************
      ************************************************************
      /EJECT
     D*ISTART
      ************************************************************
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
     D*D@FMT     E DSSDGELRD0                                             S01230
     D D@FMT         E DS                  EXTNAME(SDGELRPD)                    S01230
      * @BKREEC - GENERAL LEDGER RECORD FORMAT DATA STRUCTURE             S01230
      *                                                                   S01230
     D*P@FMT     E DSSDGELRPD
      **@BKREEC - GENERAL LEDGER RECORD FORMAT DATA STRUCTURE
      *
     D P@FMT         E DS                  EXTNAME(DSFDY)                       S01230
     I* External Data structure to hold the outgoing record format        S01230
     I* of the file.                                                      S01230
      *
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C***                  PARM           P@FMT            O:Format       S01117
     C                   PARM      D@FMT         P@FMT                          O:Format       S0111
      *****************************************************
      *MAIN
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       9396       ¦ error
     C     P@OPTN        IFEQ      '*KEY   '
     C     P@OPTN        OREQ      '*FIRST '
     C     P@OPTN        OREQ      '*LAST  '
     C     P@OPTN        OREQ      '*NEXT  '
     C     P@OPTN        OREQ      '*PREV  '
     C     P@OPTN        OREQ      '*FREE  '
     C     P@OPTN        OREQ      '*VERIFY'
     C     P@OPTN        OREQ      '*SAME  '
     C     *IN01         IFEQ      '0'                                            IF2
     C                   SETON                                        01
     C                   OPEN      SDGELRL1                             91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C     *LOVAL        SETLL     @BKREEC                            9390        Set file
     C  N93              READ      @BKREEC                                93
     C                   CLOSE     SDGELRL1                             92        Close file
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C***********          SETON                     LR      Set ind.     LN0104
     C                   END                                                      FI2
     C                   ELSE
     C                   SETON                                        96          Parm error
     C                   END
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
      * Caller requests DB error handling :
      *
     C     W@RTCD        IFEQ      '*DBERR '                                    IF 10
     C     P@RTCD        ANDNE     *BLANK                                         AND
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   END                                                    FI 10
      *
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
SDGELRPD  AOGELRR0  General Ledger Details                                E01168
