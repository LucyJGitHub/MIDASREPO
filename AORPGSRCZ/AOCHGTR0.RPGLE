     H DEBUG
      *****************************************************************
/***D ***RPG***********************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Securities trad charge types')
     F********************************************************************
     F*                                                                  *
     F*  Midas  ACCESS OBJECTS
     F*                                                                  *
     F*     AOCHGTR0 - CHARGE TYPES                                      *
     F*                                                                  *
      *  (c) Finastra International Limited 2001                      *
     F*                                                                  *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      *  Prev Amend No. CSE029             Date 26Jul01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003             Date 06Aug98               *
     F*                 CAC002             Date 15Sep96               *
     F*                 S01446             Date 08/10/93              *
     F*                 S01230             Date 08/01/90              *
     F*          AMEND NO.S01230              DATE 23/11/89              *S01230
     F*          AMEND NO.S01230              DATE 06/11/89              *S01230
     F*                                                                  *
     F********************************************************************
     F*     MD046248 - Finastra Rebranding                               *
     F*     CSE029 - ISO15022 message generation                         *
     F*              Recompiled due to changes in SECGTD.                *
     F*     CAP003 - Member converted from an OPM program to an ILE      *
     F*              module and an ILE *PGM member of the same name has  *
     F*              been created (in AOPGMSRC).                         *
     F*              ILE modules can make a bound call to the module.    *
     F*              OPM programs can make a dynamic call to the *PGM.   *
     F*  CAC002 - Profit Centre Accounting Development - Phase 2      *
     F*           Recompiled due to changes in PF/SECGTD.             *
     F*     S01446 - CUSTOMER COMMISSIONS (COURTAGE) ENHANCEMENTS     *
     F*              Recompiled for changes to PF/SECGTD.             *
     F*     S01230 - STANDARDISE ACCESS PROGRAMS                      *   S01230
     F********************************************************************S01230
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
     F*        98     ERROR ON CALL OF SELECTION PROGRAM(SDCZSRR)        *
     F*        99     ERROR ON CALL ZASNMG                               *
     F*                                                                  *
     F********************************************************************
      /EJECT
     F*FSTART
      ************************************************************
     FSECGT     IF   E           K DISK    USROPN
      * IN  - SECGTDF CHARGE TYPES     (CCY, CCOM)
      ************************************************************
      /EJECT
     D*ESTART
      ************************************************************
      ************************************************************
     D* Description     : Copyright notice for inclusion in all progra    S01230
     D*                                                                   S01230
     D********************************************************************S01230
      ****************************************************************    S01230
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
     D*D@FMT     E DSSECGTDD0                                             S01230
     D D@FMT         E DS                  EXTNAME(SECGTD)                      S01230
      * SECGTDF - Charge Types record format data structure
      *
     D P@FMT         E DS                  EXTNAME(DSSDY)                       S01230
     D*                                                                   S01230
     D* EXTERNAL DATA STRUCTURE TO HOLD THE OUTGOING RECORD FORMAT OF     S01230
     D* THE FILE                                                          S01230
     D******P@FMT       DS                            245                 S01230
      * INTERNAL- Charge Types record format data structure
      *
     D******                                  1   1 P@DMMY                S01230
     D*P@KEY1      DS                                                     S01230
     D P@CCY           DS                                                       S01230
      * Key slicing data structure (for Record Selection)
     D  W@SL01                 1      1
     D  W@SL02                 2      2
     D  W@SL03                 3      3
     D*P@KEY2      DS                                                     S01230
     D P@CCOM          DS                                                       S01230
      * Key slicing data structure (for Record Selection)
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
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C*********************PARM           P@KEY1           I:Key field    S01230
     C                   PARM                    P@CCY                          I:Key field    S0123
     C*********************PARM           P@KEY2           I:Key field    S01230
     C                   PARM                    P@CCOM                         I:Key field    S0123
     C                   PARM                    P@FMT                          O:Format       S0123
      *****************************************************
      *MAIN
     C     P@OPTN        IFEQ      '*SAME '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      T@SKIP
     C                   END
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       939495     ¦ error
     C                   SETOFF                                       969798     ¦ indicators
     C                   SETOFF                                       505152     ¦ error
     C*
     C* KEY FIELD LIST
     C*
     C     K@KEY         KLIST
     C*********************KFLD           P@KEY1                          S01230
     C                   KFLD                    P@CCY                                         S0123
     C*********************KFLD           P@KEY2                          S01230
     C                   KFLD                    P@CCOM                                        S0123
      *
      * First call - open file :
      *
     C     *IN01         IFEQ      '0'                                          IF 1 FIRST TIME
     C                   SETON                                        01          Set ind.
     C                   OPEN      SECGT                                91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   END                                                    FI 1
      *
      * Last call - close file and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 2 FREE PGM
     C                   CLOSE     SECGT                                92        Close file
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   SETON                                        LR          Set ind.
     C                   END                                                    FI 2
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 FIRST REC
     C     *LOVAL        SETLL     SECGTDF                            9390        Set file
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   END                                                    FI 3
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 NEXT REC
     C                   READ      SECGTDF                              9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 4
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 LAST REC
     C     *HIVAL        SETGT     SECGTDF                              90        Set file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   END                                                    FI 5
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 PREV.REC
     C                   READP     SECGTDF                              9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 6
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 KEY ACCESS
     C     P@OPTN        OREQ      '*VERIFY'                                     OR
     C     K@KEY         CHAIN     SECGTDF                            9590        Get record
     C     *IN95         CABEQ     '1'           T@SKIP                           No rec found
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 7
      *
     C     P@OPTN        IFNE      '*KEY   '                                    IF 8 NOT KEYED
     C     P@OPTN        ANDNE     '*NEXT  '                                     AND NOT SEQ.
     C     P@OPTN        ANDNE     '*PREV  '                                     AND
     C     P@OPTN        ANDNE     '*VERIFY'                                     AND
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
     C   95              MOVE      '*NRF   '     P@RTCD                         No record found
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
      * Caller Requests DB Error Handling
      *
     C     W@RTCD        IFEQ      '*DBERR'                                     IF
     C     P@RTCD        ANDNE     *BLANK                                         AND
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   END                                                    FI
      *
     C     P@OPTN        IFNE      '*VERIFY'
     C     P@OPTN        ANDNE     '*FREE'
     C     P@RTCD        ANDNE     '*OPTION'
     C                   MOVEL     D@FMT         P@FMT
     C                   END
      *
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
SECGTDD0  AOCHGTR0  Charge Types
**CTDATA CPY@
(c) Finastra International Limited 2001
