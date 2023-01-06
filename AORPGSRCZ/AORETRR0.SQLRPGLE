     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058755
/*STD *  RPGSQLBND                                                    *                     MD058755
/*EXI *  TEXT('Midas AO Retail transactions')
     F*****************************************************************
     F*                                                               *
     F*  Midas ACCESS OBJECTS                                     *
     F*                                                               *
     F*     AORETRR0 - RETAIL TRANSACTION TYPES                       *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD058755           Date 01Sep21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL154             Date 13Oct14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CRT001             Date 28Feb95               *
     F*                    S01486             DATE 18JUL94            *
     F*                    S01413             DATE 13APR93            *   S01117
     F*                    S01117             DATE 27/04/90           *   S01117
     F*                    S01230             DATE 23/11/89           *   S01230
     F*                    S01230             DATE 06/11/89           *   S01230
     F*                                                               *
     F*****************************************************************
      *  MD058755 - Deliverable Data Split for SDRETRPD and TABLETZ   *
      *  MD046248 - Finastra Rebranding                               *
     F*  CGL154 - FATCA Reporting (Recompile)                         *
     F*  CRT001 - Retail Teller System. Recompile due to new SDRETRPD.*   S01230
     F*     S01486 - Private Banking Development:                     *
     F*              - Recompiled over changed SDRETRPD.              *
     F*     S01413 - Recompiled for Release 3 Incorporation due       *
     F*              to file changes in PF/SDRETRPD.                  *
     F*     S01117 - RELEASE 10 CHANGES                               *   S01117
     F*     S01230 - STANDARDISE ACCESS PROGRAMS                      *   S01230
     F*****************************************************************   S01230
     F* ID F  C  H  L  FUNCTION OF INDICATORS
     F*
     F*       01       OFF ON THE FIRST RUN
     F*       90       FILE ERROR
     F*       91       OPEN ERROR
     F*       92       CLOSE ERROR
     F*       93       EMPTY ERROR
     F*       94       END OF FILE
     F*       95       NO RECORD FOUND
     F*       96       OPTION ERROR
     F*       97       NO SELECTION
     F*       98       CALL ERROR (SDM8SRR)
     F*       99       CALL ERROR (ZASNMG)
     F*
      ********************************************************************
      /EJECT
     F*FSTART
      ************************************************************
     F*SDRETRL0* IF   E           K DISK    USROPN                                          MD058755
      * IN  - @A1RECW Account codes    (CQNB)
      ************************************************************
      /EJECT
     D*ESTART
      ************************************************************
      ************************************************************
     D* Description     : Copyright notice for inclusion in all progra    S01230
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
     D**********D@FMT     E DSSDRETRD0                                    S01230
     D*D@FMT****     E DS                  EXTNAME(SDRETRPD)                    S01230      MD058755
     D D@FMT         E DS                  EXTNAME(SDRTRJW0)                                MD058755
     D X@RTTY          S              5A                                                    MD058755
      * @A1RECW - Retail transactions record format data structure
      *
     D P@FMT         E DS                  EXTNAME(DSFDY)                       S01230
     D* EXTERNAL DATA STRUCTURE TO HOLD THE OUTGOING RECORD FORMAT        S01230
     D* OF THE FILE.                                                      S01230
      *                                                                   S01230
     D********P@FMT       DS                             43               S01230
     D********                                1  43 P@DMMY                S01230
      *
     D P@RTTY          DS
      * Key slicing data structure (for Record Selection)
     D  W@SL01                 1      1
     D  W@SL02                 2      2
     D  W@SL03                 3      3
     D  W@SL04                 4      4
     D  W@SL05                 5      5
     D*                                                                   S01230
     D* Description     : Copyright notice for inclusion in all programs  S01230
     D*                                                                   S01230
     D A@CPY           DS                                                       S01230
     D* Copyright array                                                   S01230
     D  CPY@                   1     80                                         S01230
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright     arrS01
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    P@RTTY            5            I:Key field
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
     C*********************SETOF                     96     ¦ indicators  S01117
     C                   SETOFF                                       969798     ¦ indicators  S0111
      *
      * First call - open file :
      *
     C     *IN01         IFEQ      '0'                                          IF 1 FIRST TIME
     C                   SETON                                        01          Set ind.
     C**********         OPEN      SDRETRL0                             91        Open file MD058755
     C******IN91         CABEQ     '1'           T@SKIP                   LR      Open errorMD058755
     C                   END                                                    FI 1
      *
      * Last call - close file and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 2 FREE PROG
     C**********         CLOSE     SDRETRL0                             92        Close fileMD058755
     C******IN92         CABEQ     '1'           T@SKIP                   LR      Close erroMD058755
     C                   SETON                                        LR          Set ind.
     C                   END                                                    FI 2
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 FIRST REC
     C******LOVAL        SETLL     @A1RECW                            9390        Set file  MD058755
     C******IN93         CABEQ     '1'           T@SKIP                           Empty fileMD058755
     C******IN90         CABEQ     '1'           T@SKIP                   LR      File errorMD058755
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   END                                                    FI 3
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 NEXT REC
     C**********         READ      @A1RECW                              9094      Read recorMD058755
     C******IN94         CABEQ     '1'           T@SKIP                           End of filMD058755
     C******IN90         CABEQ     '1'           T@SKIP                   LR      File errorMD058755
     C                   END                                                    FI 4
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 LAST REC
     C******HIVAL        SETGT     @A1RECW                              90        Set file  MD058755
     C******IN90         CABEQ     '1'           T@SKIP                   LR      File errorMD058755
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   END                                                    FI 5
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 PREV.REC
     C**********         READP     @A1RECW                              9094      Read recorMD058755
     C******IN94         CABEQ     '1'           T@SKIP                           End of filMD058755
     C******IN90         CABEQ     '1'           T@SKIP                   LR      File errorMD058755
     C                   END                                                    FI 6
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 KEYED
     C     P@OPTN        OREQ      '*VERIFY'                                      OR
     C     W@SL01        IFEQ      '?'                                          IF 8
     C     W@SL02        OREQ      '?'
     C     W@SL03        OREQ      '?'
     C     W@SL04        OREQ      '?'
     C     W@SL05        OREQ      '?'
     C*********************CALL 'SDM8SRR'              98    <SELECT>     S01230
     C                   CALL      'SD0130S'                            98        <SELECT>     S0123
     C                   PARM      *BLANK        P@RTC2            7              B:Return code
     C                   PARM      *BLANK        P@RTTY                           B:Key
     C     P@RTC2        COMP      *BLANK                             97          No select 1
     C     *IN97         CABEQ     '1'           T@SKIP                           No selection
     C     *IN98         CABEQ     '1'           T@SKIP                           Program error
     C                   END
     C*****P@RTTY        CHAIN     @A1RECW                            9590        Get record
     C                   eval      X@RTTY = P@RTTY                                          MD058755
     C/EXEC SQL                                                                             MD058755
     C+ SELECT *                                                                            MD058755
     C+ into :D@FMT                                                                         MD058755
     C+ from SDRTRJW0                                                                       MD058755
     C+ where A1RTTY = :X@RTTY                                                              MD058755
     C/END-EXEC                                                                             MD058755
     C                   Setoff                                       9095                  MD058755
     C                   If        SQLCODE = 100                                            MD058755
     C                   SETON                                        95                    MD058755
     C                   ENDIF                                                              MD058755
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058755
     C                   SETON                                        90                    MD058755
     C                   ENDIF                                                              MD058755
                                                                                            MD058755
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
     C***97****************MOVE '*NOSEL'  P@RTCD           No selection   S01117
     C***98****************MOVE '*CALL'   P@RTCD           Called Pgm. errS01117
     C   97              MOVE      '*NOSEL '     P@RTCD                         No selection   S0111
     C   98              MOVE      '*CALL  '     P@RTCD                         Called Pgm. errS0111
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
     C                   CALL      'ZASNMG'
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
     C                   CALL      'DBERRCTL'
     C                   END                                                    FI
      *
     C     P@OPTN        IFNE      '*VERIFY'                                    IF 13
     C     P@OPTN        ANDNE     '*FREE  '                                      AND
     C*          P@OPTN    ANDNE'*OPTION'                    AND          E01168
     C     P@RTCD        ANDNE     '*OPTION'                                      AND          E0116
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
AORETRPD  AORETRR0  Retail Transactions
**CTDATA CPY@
(c) Finastra International Limited 2001
