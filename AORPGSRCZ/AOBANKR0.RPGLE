     H DEBUG
      *****************************************************************
/***D ***RPG***********************************************************   CAP002
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Bank ICD access object')
     F*****************************************************************
     F*                                                               *
     F*  Midas  ACCESS OBJECTS                                        *
     F*                                                               *
     F*     AOBANKR0 - READ ACCESS TO BANK DETAILS                    *
     F*                I.C.D ACCESS OBJECT                            *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *  Prev Amend No. CAP002             Date 01May98               *
      *                 099942             Date 23Feb96               *
     F*                    078049             DATE 27OCT94            *
     F*                    S01314             DATE 06DEC90            *
     F*                    LN0104             DATE 01JUN90            *
     F*                    S01230             DATE 23/11/89           *   S01230
     F*                    S01230             DATE 06/11/89           *
     F*                    E01168             DATE 21/03/89           *
     F*                    E01168             DATE 22/02/89           *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP002 - Member converted from an OPM program to an ILE      *
      *           module and an ILE *PGM member of the same name has  *
      *           been created (in AOPGMSRC).                         *
      *           ILE modules can make a bound call to the module.    *
      *           OPM programs can make a dynamic call to the *PGM.   *
     F*     099942 - RECOMPILE TO INCLUDE MODULUS 10 FIELD.           *
     F*     078049 - ADD *FREE PROCESSING                             *
     F*     S01314 - CHANGES MADE DURING PTF INCORPORATION OF R10     *
     F*     LN0104 - REMOVE SET ON OF LR IF RECORD FOUND -            *
     F*              TO ALLOW PROGRAM TO REMAIN IN PAG WHEN OPENED    *
     F*              IN SD1600                                        *
     F*     S01230 - STANDARDISE ACCESS PROGRAMS                      *   S01230
     F*                                                               *
     F*****************************************************************   S01230
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
     FSDBANKL1  IF   E           K DISK    USROPN
      * IN  - @BJREEF BANK DETAILS (BYCD)
      ************************************************************
      /EJECT
     D*ESTART
     D************************************************************
     D************************************************************
      * Description     : Copyright notice for inclusion in all programs
     D*                                                                   S01230
     D********************************************************************S01230
     D********************************************************************S01230
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
     D**********D@FMT     E DSSDBANKD0                                    S01230
     D D@FMT         E DS                  EXTNAME(SDBANKPD)                    S01230
      * @BTREE4 - BANK RECORD FORMAT DATA STRUCTURE
      *
     D P@FMT         E DS                  EXTNAME(DSFDY)                       S01230
     D* External Data structure to hold the outgoing record format of     S01230
     D* the file                                                          S01230
     D**********P@FMT       DS                                            S01230
     D**********                              1 111 BJCOPY                E01168
     D**********                              1 114 BJCOPY                E01168
     D**********                              1 117 BJCOPY                E01168
     D**********                              1 123 BJCOPY                E01168
      *
      ************************************************************
     D*                                                                   S01230
      * Description     : Copyright notice for inclusion in all programs
     D*                                                                   S01230
     D A@CPY           DS                                                       S01230
      * Copyright array
     D  CPY@                   1     80                                         S01230
     D                                     DIM(1) CTDATA PERRCD(1)
      ************************************************************        S01230
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C*********************PARM           P@KEY  10        I:KEY          S01314
     C*********************PARM           P@FMT                           S01314
     C                   PARM      D@FMT         P@FMT                          O:Format
      *****************************************************
      *MAIN
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       9396       ¦ error
     C     P@OPTN        IFEQ      '*KEY   '
     C     P@OPTN        OREQ      '*FIRST '
     C     P@OPTN        OREQ      '*LAST  '
     C     P@OPTN        OREQ      '*NEXT  '
     C     P@OPTN        OREQ      '*PREV  '
     C***********P@OPTN    OREQ '*FREE  '                                 078049
     C     P@OPTN        OREQ      '*SAME  '
     C     P@OPTN        OREQ      '*VERIFY'
     C     *IN01         IFEQ      '0'                                            IF2 1'st time
     C                   SETON                                        01
     C                   OPEN      SDBANKL1                             91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C     *LOVAL        SETLL     @BJREEF                            9390        Set file
     C  N93              READ      @BJREEF                                93
     C                   CLOSE     SDBANKL1                             92        Close file
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C***********          SETON                     LR      Set ind.     LN0104
     C                   END                                                      FI2
     C                   ELSE
      *                                                                   078049
     C     P@OPTN        IFEQ      '*FREE  '                                                  078049
     C                   SETON                                        LR                      078049
     C                   RETURN                                                               078049
     C                   ELSE                                                                 078049
      *                                                                   078049
     C                   SETON                                        96          Parm error
     C                   END
     C                   END                                                                  078049
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
      *      CALLER REQUESTS DB HANDLING
      *
     C     W@RTCD        IFEQ      '*DBERR'                                     IF DB ERROR
     C     P@RTCD        ANDNE     *BLANK                                       AND
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
SDBANKPD  AOBANKR0  Bank Details
**CTDATA CPY@
(c) Finastra International Limited 2001
