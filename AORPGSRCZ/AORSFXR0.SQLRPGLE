     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055265
/*STD *  RPGSQLBND                                                    *                     MD055265
/*EXI *  TEXT('Midas AO Report Suffixes.             *RDR')
     F********************************************************************
     F*                                                                  *
     F*  Midas  ACCESS OBJECTS
     F*                                                                  *
     F*     AORSFXR0 - REPORT SUFFIXES FILE                              *
     F*                                                                  *
     F*  (c) Finastra International Limited 2001                         *
     F*                                                                  *
      *  Last Amend No. MD055265           Date 10Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
     F*                    S01230             DATE 07JAN90               *
     F*                    E01168             DATE 22FEB89               *
     F*                                                                  *
     F********************************************************************
      *  MD055265 - Deliverable Data Split for Report Control Facility*
     F*                                                                  *
     F********************************************************************
     F*
     F*                                                                  *
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
     F*FCRSFXL1* IF   E           K DISK    USROPN                                          MD055265
      * IN  - @DYREIO
      ************************************************************
      /EJECT
     D*ESTART
      ************************************************************
      ************************************************************
     D* Description     : Copyright notice for inclusion in all progra    S01230
     D*                                                                   S01230
     D********************************************************************S01230
     D********************************************************************S01230
      /EJECT
     D*ISTART
      ************************************************************
     D A@CPY           DS                                                       S01230
     D* Copyright array                                                   S01230
     D  CPY@                   1     80                                         S01230
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright     arrS01
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
     D*D@FMT****     E DS                  EXTNAME(FCRSFXPD)                                MD055265
     D D@FMT         E DS                  EXTNAME(FCRSFCTD)                                MD055265
     D                                     PREFIX(X)                                        MD055265
      * @DYREIO -
      *
     D*P@FMT       DS                             65                      E01168
     D*                                      65  65 P@DMMY                E01168
     D*************P@FMT       DS                             64          E01168
     D***************************************64  64 P@DMMY                E01168
     D P@FMT         E DS                  EXTNAME(DSFDY)                       E01168
      *
     D P@KEY1          DS                                                       S01230
     D  W@SL01                 1      1                                         S01230
     D  W@SL02                 2      2                                         S01230
     D  W@SL03                 3      3                                         S01230
     D  W@SL04                 4      4                                         S01230
     D  W@SL05                 5      5                                         S01230
     D  W@SL06                 6      6                                         S01230
     D  W@SL07                 7      7                                         S01230
     D  W@SL08                 8      8                                         S01230
     D  W@SL09                 9      9                                         S01230
     D  W@SL10                10     10                                         S01230
      *                                                                   S01230
     D P@KEY2          DS                                                       S01230
     D  W@SL11                 1      1                                         S01230
     D  W@SL12                 2      2                                         S01230
     D  W@SL13                 3      3                                         S01230
     D  W@SL14                 4      4                                         S01230
     D  W@SL15                 5      5                                         S01230
     D  W@SL16                 6      6                                         S01230
     D  W@SL17                 7      7                                         S01230
     D  W@SL18                 8      8                                         S01230
     D  W@SL19                 9      9                                         S01230
     D  W@SL20                10     10                                         S01230
     D X@KEY1          S             10                                                     MD055265
     D X@KEY2          S             10                                                     MD055265
     D FCRSFX        E DS                  EXTNAME(FCRSFJW0)                                MD055265
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    P@KEY1           10            I:Report name
     C                   PARM                    P@KEY2           10            I:Print suffix
     C                   PARM                    P@FMT                          O:Format
     C*
     C     P@DSNB        KLIST
     C                   KFLD                    P@KEY1
     C                   KFLD                    P@KEY2
     C*
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
     C**********         OPEN      FCRSFXL1                             91        Open file MD055265
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   END                                                    FI 1
      *
      * Last call - close file and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 2 FREE PGM
     C**********         CLOSE     FCRSFXL1                             92        Close fileMD055265
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   SETON                                        LR          Set ind.
     C                   END                                                    FI 2
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 FIRST REC
     C******LOVAL        SETLL     @DYREIO                            9390        Set file  MD055265
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   END                                                    FI 3
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 NEXT REC
     C**********         READ      @DYREIO                              9094      Read recorMD055265
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 4
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 LAST REC
     C******HIVAL        SETGT     @DYREIO                              90        Set file  MD055265
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   END                                                    FI 5
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 PREV.REC
     C**********         READP     @DYREIO                              9094      Read recorMD055265
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 6
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 KEYED ACC
     C     P@OPTN        OREQ      '*VERIFY'                                      OR
     C     W@SL01        IFEQ      '?'                                          IF ? ENTETED   S0123
     C     W@SL02        OREQ      '?'                                            OR           S0123
     C     W@SL03        OREQ      '?'                                            OR           S0123
     C     W@SL04        OREQ      '?'                                            OR           S0123
     C     W@SL05        OREQ      '?'                                            OR           S0123
     C     W@SL06        OREQ      '?'                                            OR           S0123
     C     W@SL07        OREQ      '?'                                            OR           S0123
     C     W@SL08        OREQ      '?'                                            OR           S0123
     C     W@SL09        OREQ      '?'                                            OR           S0123
     C     W@SL10        OREQ      '?'                                            OR           S0123
     C     W@SL11        OREQ      '?'                                            OR           S0123
     C     W@SL12        OREQ      '?'                                            OR           S0123
     C     W@SL13        OREQ      '?'                                            OR           S0123
     C     W@SL14        OREQ      '?'                                            OR           S0123
     C     W@SL15        OREQ      '?'                                            OR           S0123
     C     W@SL16        OREQ      '?'                                            OR           S0123
     C     W@SL17        OREQ      '?'                                            OR           S0123
     C     W@SL18        OREQ      '?'                                            OR           S0123
     C     W@SL19        OREQ      '?'                                            OR           S0123
     C     W@SL20        OREQ      '?'                                            OR           S0123
     C                   CALL      '???????'                            98        <SELECT>     S0123
     C                   PARM      *BLANK        P@RTC2            7              B:Return codeS0123
     C                   PARM      *BLANK        P@KEY1                           B:Key
     C                   PARM      *BLANK        P@KEY2                           B:Key
     C     P@RTC2        COMP      *BLANK                             97          No selection
     C     *IN97         CABEQ     '1'           T@SKIP                           No selection
     C     *IN98         CABEQ     '1'           T@SKIP                           Program error
     C                   END                                                    FI 8
     C                   eval      X@KEY1 = P@KEY1                                          MD055265
     C                   eval      X@KEY2 = P@KEY2                                          MD055265
     C*****P@DSNB        CHAIN     @DYREIO                            9590        Get recordMD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCRSFX                                                                        MD055265
     C+ from FCRSFJW0                                                                       MD055265
     C+ where DYRNAM = :X@KEY1 and DYRSFX = :X@KEY2                                         MD055265
     C/END-EXEC                                                                             MD055265
     C                   SETOFF                                       9095                  MD055265
     C                   IF        SQLCODE = 100                                            MD055265
     C                   SETON                                          95                  MD055265
     C                   ENDIF                                                              MD055265
     C                   IF        SQLCODE <> 100 and SQLCODE <> 0                          MD055265
     C                   SETON                                          90                  MD055265
     C                   ENDIF                                                              MD055265
                                                                                            MD055265
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
     C                   eval      D@FMT = FCRSFX                                           MD055265
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
AORSFXPD  AORSFXR0  Report Name Print Suffix
**CTDATA CPY@
(c) Finastra International Limited 2001
