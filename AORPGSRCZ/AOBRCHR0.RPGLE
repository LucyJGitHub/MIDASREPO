     H DEBUG
      *****************************************************************
/***D ***RPG***********************************************************   CAP002
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Branch details access object')
     F*****************************************************************
     F*                                                               *
     F*  Midas  ACCESS OBJECTS                                        *
     F*                                                               *
     F*     AOBRCHR0 - READ ACCESS TO BRANCH CODES FILE               *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL013             Date 20Feb02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008             Date 02May00               *
      *                    CRT004             DATE 04MAY00            *
      * Midas DBA 3.02 -----------------------------------------------*
      *                    CFT004             Date 19Jul99            *
      * Midas DBA 3.01 -----------------------------------------------*
      *                    CPK010             Date 26Oct99            *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                    CAP002             Date 01May98            *
     F*                    CLE004             DATE 02APR97            *
     F*                    CRT003             DATE 22JUL96            *
     F*                    S01486             DATE 18JUL94            *
     F*                    S01449             DATE 27OCT93            *
     F*                    S01392             DATE 20JUL92            *
     F*                    S01383             DATE 04JUN93            *
     F*                    LN0665             DATE 23AUG90            *
     F*                    S01229             DATE 05/01/90           *   S01229
     F*                    S01230             DATE 23/11/89           *   S01230
     F*                    S01230             DATE 06/11/89           *   S01230
     F*                    E01168             DATE 22/02/89           *
     F*                                                               *
     F*****************************************************************
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL013 - MT94x Message Generation.                           *
      *           (Recompiled over changed SDBRCHPD)                  *
      *  CDL008 - Continuous Linked Settlement                        *
      *           (Recompiled over changed SDBRCHPD)                  *
      *  CRT004 - Cashier Midas TCP/IP interface.                     *
      *             Recompiled over SDBRCHPD Changes                  *
      *  CFT004 - Straight Through Processing Phase 2  - Recompiled   *
      *           International Bank Account Numbers (IBAN)           *
      *  CPK010 - Addition of PSSR processing.                        *
      *  CAP002 - Member converted from an OPM program to an ILE      *
      *           module and an ILE *PGM member of the same name has  *
      *           been created (in AOPGMSRC).                         *
      *           ILE modules can make a bound call to the module.    *
      *           OPM programs can make a dynamic call to the *PGM.   *
     F*     CLE004 - Lending Enhancements:                            *
     F*              - Recompiled over changed SDBRCHPD.              *
     F*              - This will require a code change to use the     *
     F*                long return string data structure when the     *
     F*                non-Synon part of this enhancement is added    *
     F*                to the core system.                            *
     F*     CRT003 - Cashier Interface                                *
     F*     S01486 - Private Banking Development:                     *
     F*              - Recompiled over changed SDBRCHPD.              *
     F*     S01449 - RECOMPILE AFTER ADDITION OF PC SUBSYSTEM FIELD   *
     F*              TO BRANCH FILE.                                  *
     F*     S01392 - JAP.SUB-MODULE INCORPORATION (CORE)              *
     F*              PROGRAM RECOMPILED AS NEW FIELD (A8RDFC) ADDED   *
     F*     S01383 - RECOMPILE AFTER ADDITION OF SORT CODE            *
     F*              TO BRANCH FILE.                                  *
     F*     LN0665 - ADDITION OF TID TO BRANCH FILE                   *
     F*     S01229 - FIELD NAME CHANGES                               *   S01229
     F*     S01230 - STANDARDISE ACCESS PROGRAM                       *   S01230
     F*****************************************************************   S01230
     F*                                                               *
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
     FSDBRCHL1  IF   E           K DISK    USROPN
      * IN  - @A8REB0
      ************************************************************
      /EJECT
     D*ESTART
      ************************************************************
      ************************************************************
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
     D*************D@FMT     E DSSDBRCHD0                                 S01230
     D D@FMT         E DS                  EXTNAME(SDBRCHPD)                    S01230
      * @A8REB0 -
      *
     D*P@FMT       DS                             65                      E01168
     D*                                      65  65 P@DMMY                E01168
     D P@FMT         E DS                  EXTNAME(DSFDY)                       S01230
     D* External Data structure to hold the outgoing record format        S01230
     D* of the file.                                                      S01230
      *                                                                   S01230
     D**************P@FMT       DS                             64         S01230
     D********                                       64  64 P@DMMY        S01230
      *
     D*P@DSNB      DS                                                     S01229
     D P@BRCD          DS                                                       S01229
      * Key slicing data structure (for Record Selection)
     D  W@SL01                 1      1
     D  W@SL02                 2      2
     D  W@SL03                 3      3
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
     C*********************PARM           P@DSNB           I:Key field    S01229
     C                   PARM                    P@BRCD                         I:Key field    S0122
     C                   PARM                    P@FMT                          O:Format
      *****************************************************
      *
      * Access Option *SAME input
      *
     C     P@OPTN        IFEQ      '*SAME  '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      T@SKIP
     C                   END
      *
      *MAIN
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       939495     ¦ error
     C                   SETOFF                                       969798     ¦ indicators
      *
      * First call - open file :
      *
     C     *IN01         IFEQ      '0'                                          IF 1 FIRST TIME
     C                   SETON                                        01          Set ind.
     C                   OPEN      SDBRCHL1                             91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   END                                                    FI 1
      *
      * Last call - close file and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 2 FREE PGM
     C                   CLOSE     SDBRCHL1                             92        Close file
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   SETON                                        LR          Set ind.
     C                   END                                                    FI 2
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 FIRST REC
     C     *LOVAL        SETLL     @A8REB0                            9390        Set file
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   END                                                    FI 3
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 NEXT REC
     C                   READ      @A8REB0                              9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 4
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 LAST REC
     C     *HIVAL        SETGT     @A8REB0                              90        Set file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   END                                                    FI 5
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 PREV.REC
     C                   READP     @A8REB0                              9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 6
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 KEYED ACC
     C     P@OPTN        OREQ      '*VERIFY'                                      OR
     C     W@SL01        IFEQ      '?'
     C     W@SL02        OREQ      '?'
     C*********************CALL 'SDF1SRR'              98    <SELECT>     S01230
     C                   CALL      'SD0061S'                            98        <SELECT>     S0123
     C                   PARM      *BLANK        P@RTC2            7              B:Return code
     C*********************PARM *BLANK    P@DSNB             B:Key        S01229
     C                   PARM      *BLANK        P@BRCD                           B:Key        S0122
     C     P@RTC2        COMP      *BLANK                             97          No selection
     C     *IN97         CABEQ     '1'           T@SKIP                           No selection
     C     *IN98         CABEQ     '1'           T@SKIP                           Program error
     C                   END                                                    FI 8
     C***********P@DSNB    CHAIN@A8REB0              9590    Get record   S01229
     C     P@BRCD        CHAIN     @A8REB0                            9590        Get record   S0122
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
     C     W@RTCD        IFEQ      '*MSG   '                                    IF 9 SEND MSGM
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
     C                   CALLB     'ZASNMG'                                       <SEND MSG>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Program nam
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Message ID
     C                   PARM      *BLANK        P@MSGF           10              I:Message fil
     C                   PARM      *BLANK        P@MGKY            4              O:Message key
     C                   PARM                    P@MGDA           50              I:Message dta
     C                   PARM      '*DIAG'       P@MGTP            7              I:Message tpe
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
     C     P@OPTN        IFNE      '*VERIFY'                                    IF 10
     C     P@OPTN        ANDNE     '*FREE  '                                      AND
     C     P@RTCD        ANDNE     '*OPTION'                                      AND
     C                   MOVEL     D@FMT         P@FMT                          FI 10
     C                   END
      *
      *
      * Return to caller :
      *
     C                   RETURN
      *
      *ENDMAIN
      /EJECT                                                                                  CPK010
      *****************************************************************                       CPK010
      *                                                               *                       CPK010
      * *PSSR  - Program exception error routine                      *                       CPK010
      *          Called automatically if a program error occurs,      *                       CPK010
      *          or directly by the program code using EXSR.          *                       CPK010
      *          This subroutine DUMPs the program just once.         *                       CPK010
      *                                                               *                       CPK010
      * Calls: None                                                   *                       CPK010
      *                                                               *                       CPK010
      *****************************************************************                       CPK010
      *                                                                                       CPK010
     C     *PSSR         BEGSR                                                                CPK010
      *                                                                                       CPK010
     C     @RUN          IFEQ      *BLANK                                                     CPK010
     C                   MOVE      'Y'           @RUN              1                          CPK010
     C                   DUMP                                                                 CPK010
     C                   END                                                                  CPK010
      *                                                                                       CPK010
     C                   MOVE      '*ERROR '     P@RTCD                         File error    CPK010
      *                                                                                       CPK010
     C                   SETON                                        U7U8LR                  CPK010
     C                   RETURN                                                               CPK010
      *                                                                                       CPK010
     C                   ENDSR                                                                CPK010
      *                                                                                       CPK010
      ********************************************************************                    CPK010
**CTDATA @MG
AOBRCHPD  AOBRCHR0  Branch Code
**CTDATA CPY@
(c) Finastra International Limited 2001
