     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058085
/*STD *  RPGSQLBND                                                    *                     MD058085
/*EXI *  TEXT('Midas AO CI Jobs access object')
     F*****************************************************************
     F*                                                               *
     F*  Midas - ACCESS OBJECTS                                       *
     F*                                                               *
     F*  AOBAIJR0 - Read Access Object to Jobs File                   *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD058085           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CRT003  *CREATE    Date 22Jul96               *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  MD058085 - Deliverable Data Split for Standing Data          *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
     F*  CRT003 - Cashier Interface                                   *
     F*                                                               *
     F*****************************************************************
     F* ID F  C  H  L    FUNCTION OF INDICATORS
     F*
     F*       01      OFF 1ST TIME ROUND
     F*       90      FILE ERROR
     F*       91      FILE OPEN ERROR
     F*       92      ERROR ON FILE CLOSE
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
     F*SDBAIJL1* IF   E           K DISK    USROPN                                          MD058085
      * IN  - @BAIJL1
      ************************************************************
      /EJECT
     D*ESTART
      ************************************************************
      ************************************************************
      * Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D********************************************************************
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
     D*D@FMT****     E DS                  EXTNAME(SDBAIJPD)                                MD058085
     D D@FMT         E DS                  EXTNAME(SDBAJJW0)                                MD058085
     D X@PGMP          S             10A                                                    MD058085
      * @BAIJL1 -
      *
     D P@FMT         E DS                  EXTNAME(DSFDY)
     D* External Data structure to hold the outgoing record format
     D* of the file.
      *
     D P@BPGM          DS
      * Key slicing data structure (for Record Selection)
     D  W@SL01                 1      1
     D  W@SL02                 2      2
     D  W@SL03                 3     10
      ************************************************************
     D*
      * Description     : Copyright notice for inclusion in all programs
     D*
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    P@BPGM                         I:Key field
     C                   PARM                    P@FMT                          O:Format
      *****************************************************
      *MAIN
      *
      * Access Option *SAME input
      *
     C                   eval      X@PGMP = P@BPGM                                          MD058085
     C     P@OPTN        IFEQ      '*SAME  '
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
     C**********         OPEN      SDBAIJL1                             91        Open file MD058085
     C******IN91         CABEQ     '1'           T@SKIP                   LR      Open errorMD058085
     C                   END                                                    FI 1
      *
      * Last call - close file and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 2 FREE PGM
     C**********         CLOSE     SDBAIJL1                             92        Close fileMD058085
     C******IN92         CABEQ     '1'           T@SKIP                   LR      Close erroMD058085
     C**********         SETON                                        LR          Set ind.  MD058085
     C                   END                                                    FI 2
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 FIRST REC
     C******LOVAL        SETLL     @BAIJL1                            9390        Set file  MD058085
     C******IN93         CABEQ     '1'           T@SKIP                           Empty fileMD058085
     C******IN90         CABEQ     '1'           T@SKIP                   LR      File errorMD058085
     C**********         MOVE      '*NEXT  '     P@OPTN                           Force *NexMD058085
     C                   END                                                    FI 3
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 NEXT REC
     C**********         READ      @BAIJL1                              9094      Read recorMD058085
     C******IN94         CABEQ     '1'           T@SKIP                           End of filMD058085
     C******IN90         CABEQ     '1'           T@SKIP                   LR      File errorMD058085
     C                   END                                                    FI 4
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 LAST REC
     C******HIVAL        SETGT     @BAIJL1                              90        Set file  MD058085
     C******IN90         CABEQ     '1'           T@SKIP                   LR      File errorMD058085
     C**********         MOVE      '*PREV  '     P@OPTN                           Force *PreMD058085
     C                   END                                                    FI 5
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 PREV.REC
     C**********         READP     @BAIJL1                              9094      Read recorMD058085
     C******IN94         CABEQ     '1'           T@SKIP                           End of filMD058085
     C******IN90         CABEQ     '1'           T@SKIP                   LR      File errorMD058085
     C                   END                                                    FI 6
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 KEYED ACC
     C     P@OPTN        OREQ      '*VERIFY'                                      OR
     C*****P@BPGM        CHAIN     @BAIJL1                            9590        Get recordMD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :D@FMT                                                                         MD058085
     C+ from SDBAJJW0                                                                       MD058085
     C+ where F0BPGM = :X@PGMP                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       9095                  MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   SETON                                        95                    MD058085
     C                   ENDIF                                                              MD058085
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058085
     C                   SETON                                        90                    MD058085
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
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
     C                   CALL      'ZASNMG'                                       <SEND MSG>
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
     C                   CALL      'DBERRCTL'
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
      *****************************************************
      *ENDMAIN
**CTDATA @MG
SDBAIJPD  AOBAIJR0  BAI Program Name
**CTDATA CPY@
(c) Finastra International Limited 2001
