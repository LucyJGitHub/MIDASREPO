     H DEBUG
      *****************************************************************
/***D ***RPG***********************************************************   CAP002
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Portfolio Management ICD        *RDR')
     F*****************************************************************
     F*                                                               *
     F*  Midas - Portfolio Management Module                      *
     F*                                                               *
     F*  AOPORTR0 - PORTFOLIO MANAGEMENT ICD                          *
     F*                                                               *
     F*  Function: Access record from SDPORTL0.                       *
     F*  Called by:                                                   *
     F*                                                               *
     F*  Calls:                                                       *
     F*                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
     F*                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Last Amend No. CAP002             Date 01May98               *
     F*  Prev Amend No. CPM005             Date 29Jul96               *
     F*                 CPM004             Date 07Feb96               *
     F*                 S01486             Date 11Aug94               *
     F*                 PM0027             DATE 16AUG94               *
     F*                 PM0022             DATE 03AUG94               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  CAP002 - Member converted from an OPM program to an ILE      *
      *           module and an ILE *PGM member of the same name has  *
      *           been created (in AOPGMSRC).                         *
      *           ILE modules can make a bound call to the module.    *
      *           OPM programs can make a dynamic call to the *PGM.   *
     F*  CPM005 - Private Banking Phase II                            *
     F*           Focus Group Changes Upgraded to DBA                 *
     F*           Just Recompiled because of PM File(s) changes       *
     F*  CPM004 - Bank Portfolios  (RECOMPILED)                       *
     F*  S01486 - Portfolio Management Upgrade to R10.                *
     F*  PM0027 - Should ignore deleted records                       *
     F*  PM0022 - Change record format name due to Synon changes      *
     F*****************************************************************
     F*                                                               *
     F*        D F C H L   FUNCTION INDICATOR                         *
     F*                                                               *
     F*        01     INITIALISATION                                  *
     F*        90     FILE ERROR                                      *
     F*        91     FILE OPEN ERROR                                 *
     F*        92     FILE CLOSE ERROR                                *
     F*        93     FILE EMPTY                                      *
     F*        94     END OF FILE                                     *
     F*        95     NO RECORD FOUND                                 *
     F*        96     OPTION ERROR                                    *
     F*        97     NO SELECTION                                    *
     F*                                                               *
     F*****************************************************************
     F*
     F/EJECT
     FSDPORTL0  IF   E           K DISK    USROPN
     F**IN**-*SDPORTD0*Installation*Control*Details***********************PM0022
     F* IN  - @PORTD0 Installation Control Details                        PM0022
     D/EJECT
     D*
     D*
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
     D*
     D/EJECT
     D*
      * Description     : Copyright notice for inclusion in all programs
     D*
     D P@MGDA          DS
     D  @MG                    1     50
     D                                     DIM(1) CTDATA PERRCD(1)
     D*
     D PGMDS          SDS
     D* Program Status data structure
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0
     D*
     D D@FMT         E DS                  EXTNAME(SDPORTPD)
     D* SDPORTD0 - Installation Control Details
     D*
     D P@FMT         E DS                  EXTNAME(DSFDY)
     I* External Data structure to hold the outgoing record format
     I* of the file.
     I*
     I*****************************************************************
     C/EJECT
     C*
     C*  Object Copyright code
     C*
     C                   MOVEA     CPY@          CPY2@            80
     C*
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    P@FMT                          O:Format
     C*
     C** Execute Subroutine 'MAIN'.
     C*
     C                   EXSR      MAIN
     C*
     C** Return to caller :
     C*
     C                   RETURN
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  INDEX OF SUBROUTINES                                         *
     C*                                                               *
     C*  MAIN - Main Process                                          *
     C*                                                               *
     C*  *PSSR  - File Error Handling                                 *
     C*                                                               *
     C*****************************************************************
     C*
     C*****************************************************************
     C*                                                               *
     C*  MAIN - Main Process                                          *
     C*                                                               *
     C*****************************************************************
     C*
     C     MAIN          BEGSR
     C*
     C     P@OPTN        IFEQ      '*SAME  '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      T@SKIP
     C                   END
     C*
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       939495     ¦ error
     C                   SETOFF                                       969798     ¦ indicators
     C*
     C* First call - open file :
     C*
     C     *IN01         IFEQ      '0'                                          IF 1 FIRST TIME
     C                   SETON                                        01          Set ind.
     C                   OPEN      SDPORTL0                             91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   END                                                    FI 1
     C*
     C* Last call - close file and terminate program :
     C*
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 2 FREE PGM
     C                   CLOSE     SDPORTL0                             92        Close file
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   SETON                                        LR          Set ind.
     C                   END                                                    FI 2
     C*
     C* Caller requests first record :
     C*
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 FIRST REC
     C************LOVAL    SETLLSDPORTD0             9390    Set file     PM0022
     C     *LOVAL        SETLL     @PORTL0                            9390        Set file     PM002
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   END                                                    FI 3
     C*
     C* Caller requests next record :
     C*
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 NEXT REC
     C***********          READ SDPORTD0               9094  Read record  PM0022
     C     FCTYLC        DOUNE     '*'                                                         PM002
     C     *IN94         OREQ      '1'                                                         PM002
     C                   READ      @PORTL0                              9094      Read record  PM002
     C                   END                                                                   PM002
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 4
     C*
     C* Caller requests last record :
     C*
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 LAST REC
     C************HIVAL    SETGTSDPORTD0               90    Set file     PM0022
     C     *HIVAL        SETGT     @PORTL0                              90        Set file     PM002
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   END                                                    FI 5
     C*
     C* Caller requests previous record :
     C*
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 PREV.REC
     C***********          READPSDPORTD0               9094  Read record  PM0022
     C     FCTYLC        DOUNE     '*'                                                         PM002
     C     *IN94         OREQ      '1'                                                         PM002
     C                   READP     @PORTL0                              9094      Read record  PM002
     C                   END                                                                   PM002
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 6
     C*
     C     P@OPTN        IFNE      '*NEXT  '                                     IF NOT SEQ.
     C     P@OPTN        ANDNE     '*PREV  '                                     AND
     C     P@OPTN        ANDNE     '*VERIFY'                                     AND
     C     P@OPTN        ANDNE     '*FREE  '                                     AND
     C                   SETON                                          96        Parm error
     C                   END                                                    FI 8
     C*
     C* No record found or End of file - return error code :
     C*          _____________
     C     T@SKIP        TAG                                                    +++ SKIP +++
     C*          ~~~~~~~~~~~~~
     C                   MOVE      *BLANK        P@RTCD                         No Errors
     C   90              MOVE      '*ERROR '     P@RTCD                         File error
     C   91              MOVE      '*OPEN  '     P@RTCD                         Open error
     C   92              MOVE      '*CLOSE '     P@RTCD                         Close error
     C   93              MOVE      '*EMPTY '     P@RTCD                         Empty file
     C   94              MOVE      '*EOF   '     P@RTCD                         End of file
     C   95              MOVE      '*NRF   '     P@RTCD                         No rec found
     C   96              MOVE      '*OPTION'     P@RTCD                         Option error
     C   97              MOVE      '*NOSEL '     P@RTCD                         No selection
     C*
     C* Caller requests~message sent to program queue :
     C*
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
     C                   CALLB     'ZASNMG'                                       <SEND MSG>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Pgm name
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Message ID
     C                   PARM      *BLANK        P@MSGF           10              I:Msg file
     C                   PARM      *BLANK        P@MGKY            4              O:Message key
     C                   PARM                    P@MGDA                           I:Msg data
     C                   PARM      '*DIAG'       P@MGTP            7              I:Msg type
     C                   END                                                    FI 9
     C*
     C* Caller requests DB error handling
     C*
     C     W@RTCD        IFEQ      '*DBERR '                                    IF 10
     C     P@RTCD        ANDNE     *BLANK                                        AND
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   END                                                    FI 10
     C*
     C     P@OPTN        IFNE      '*VERIFY'                                    IF 11
     C     P@OPTN        ANDNE     '*FREE  '                                     AND
     C     P@OPTN        ANDNE     '*OPTION'                                     AND
     C                   MOVEL     D@FMT         P@FMT
     C                   END                                                    FI 11
     C*
     C                   ENDSR
     C*
**CTDATA @MG
SDPORTL0  AOPORTR0  Portfolio Management Installation Control Details
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2001
