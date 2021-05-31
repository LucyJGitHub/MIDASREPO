     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055265
/*STD *  RPGSQLBND                                                    *                     MD055265
/*EXI *  TEXT('Midas AO Report Details               *RDR')
     F********************************************************************
     F*                                                                  *
     F*  Midas  ACCESS OBJECTS
     F*                                                                  *
     F*     AOREPTR0 - READ ACCESS TO REPORT DESCRIPTIONS FILE           *
     F*                                                                  *
      *  (c) Finastra International Limited 2001                      *
     F*                                                                  *
      *  Last Amend No. MD055265           Date 10Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 S01486             Date 22Sep94               *
      *                 S01230             Date 07/01/90              *
     F*                    E01168             DATE 14/02/89           *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD046248 - Finastra Rebranding                               *
     F*  S01486 - Recompiled due to changed FCREPTPD                  *
     F*                                                                  *
     F*****************************************************************   S01230
     F*
     F* ID F  C  H  L  FUNCTION OF INDICATORS
     F*
     F*       01       OFF ON THE FIRST RUN
     F*       90       FILE ERROR
     F*       91       OPEN ERROR
     F*       92       CLOSE ERROR
     F*       93       EMPTY FILE
     F*       94       END OF FILE
     F*       95       NO RECORD FOUND
     F*       96       OPTION ERROR
     F*       97       NO SELECTION
     F*       98       CALL ERROR (SDMDSRR)
     F*
      /EJECT
     F*FSTART
      ************************************************************
     F*FCREPTL1* IF   E           K DISK    USROPN                                          MD055265
      * IN  - @DXREIK REPORT DETAILS CODES    (RNAM)
      ************************************************************
      /EJECT
     D*ESTART
      ************************************************************
     D************************************************************        S01230
     D* Description     : Copyright notice for inclusion in all progra    S01230
     D*                                                                   S01230
     D********************************************************************S01230
      ************************************************************
      /EJECT
     D*ISTART
     D A@CPY           DS                                                       S01230
     D* Copyright array                                                   S01230
     D  CPY@                   1     80                                         S01230
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright     arrS01
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
     D**********D@FMT     E DSSDREPTD0                                    S01230
     D*D@FMT****     E DS                  EXTNAME(FCREPTPD)                    S01230      MD055265
     D D@FMT         E DS                  EXTNAME(FCREPCTD)                                MD055265
     D                                     PREFIX(X)                                        MD055265
      * @DXREIK - REPORT DETAILS CODE RECORD FORMAT DATA STRUCTURE
      *
     D***********P@FMT       DS                                           S01230
     D****************************************1  85 P@DMMY                S01230
     D P@FMT         E DS                  EXTNAME(DSFDY)                       S01230
      *
     D P@RNAM          DS
      * Key slicing data structure (for Record Selection)
     D  W@SL01                 1      1
     D  W@SL02                 2      2
     D  W@SL03                 3      3
     D  W@SL04                 4      4
     D  W@SL05                 5      5
     D  W@SL06                 6      6
     D  W@SL07                 7      7
     D  W@SL08                 8      8
     D  W@SL09                 9      9
     D  W@SL10                10     10
      *
     D X@RNAM          S             10                                                     MD055265
     D FCREPT        E DS                  EXTNAME(FCREPJW0)                                MD055265
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    P@RNAM                         I:Report Name
     C                   PARM                    P@FMT                          O:Format
      *****************************************************
      *MAIN
      *
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
     C     *IN01         IFEQ      '0'                                          IF 1 1'st time
     C                   SETON                                        01          Set ind.
     C**********         OPEN      FCREPTL1                             91        Open file MD055265
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   END                                                    FI 1
      *
      * Last call - close file and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 2 Free
     C**********         CLOSE     FCREPTL1                             92        Close fileMD055265
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   SETON                                        LR          Set ind.
     C                   END                                                    FI 2
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 First rec
     C******LOVAL        SETLL     @DXREIK                            9390        Set file  MD055265
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   END                                                    FI 3
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 Next rec
     C**********         READ      @DXREIK                              9094      Read recorMD055265
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 4
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 Last rec
     C******HIVAL        SETGT     @DXREIK                              90        Set file  MD055265
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   END                                                    FI 5
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 Prev rec
     C**********         READP     @DXREIK                              9094      Read recorMD055265
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 6
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 Keyed
     C     P@OPTN        OREQ      '*VERIFY'                                     OR
     C     W@SL01        IFEQ      '?'                                          IF 8 Selection
     C     W@SL02        OREQ      '?'                                           OR
     C     W@SL03        OREQ      '?'                                           OR
     C     W@SL04        OREQ      '?'                                           OR
     C     W@SL05        OREQ      '?'                                           OR
     C     W@SL06        OREQ      '?'                                           OR
     C     W@SL07        OREQ      '?'                                           OR
     C     W@SL08        OREQ      '?'                                           OR
     C     W@SL09        OREQ      '?'                                           OR
     C     W@SL10        OREQ      '?'                                           OR
     C                   CALL      'FC?????'                            98        <SELECT>
     C                   PARM      *BLANK        P@RTC2            7              B:Return code
     C                   PARM      *BLANK        P@RNAM                           B:Key
     C     P@RTC2        COMP      *BLANK                             97          No selection
     C     *IN97         CABEQ     '1'           T@SKIP                           No selection
     C     *IN98         CABEQ     '1'           T@SKIP                           Program error
     C                   END                                                    FI 8
     C                   eval      X@RNAM = P@RNAM                              FI 8        MD055265
     C*****P@RNAM        CHAIN     @DXREIK                            9590        Get recordMD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCREPT                                                                        MD055265
     C+ from FCREPJW0                                                                       MD055265
     C+ where DXRNAM = :X@RNAM                                                              MD055265
     C/END-EXEC                                                                             MD055265
     C                   SETOFF                                       9095                  MD055265
     C                   IF        SQLCODE = 100                                            MD055265
     C                   SETON                                          95                  MD055265
     C                   ENDIF                                                              MD055265
     C                   IF        SQLCODE <> 100 and SQLCODE <> 0                          MD055265
     C                   SETON                                          90                  MD055265
     C                   ENDIF                                                              MD055265
                                                                                            MD055265
     C     *IN95         CABEQ     '1'           T@SKIP                           No rec found
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 7
      *
     C     P@OPTN        IFNE      '*KEY   '                                    IF 8 invalid
     C     P@OPTN        ANDNE     '*NEXT  '                                     parameterEQ.
     C     P@OPTN        ANDNE     '*PREV  '
     C     P@OPTN        ANDNE     '*VERIFY'
     C     P@OPTN        ANDNE     '*SAME  '
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
     C                   CALL      'ZASNMG'                                       <SND MSG>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Prog name
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Msg ID
     C                   PARM      *BLANK        P@MSGF           10              I:Msg file
     C                   PARM      *BLANK        P@MGKY            4              O:Msg key
     C                   PARM                    P@MGDA                           I:Msg data
     C                   PARM      '*DIAG'       P@MGTP            7              I:Msg type
     C                   END                                                    FI 9
      *
      * Caller requests DB error handling
      *
     C     W@RTCD        IFEQ      '*DBERR '                                    IF 10
     C     P@RTCD        ANDNE     *BLANK                                        AND
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   END                                                    FI 10
      *
     C     P@OPTN        IFNE      '*VERIFY'                                    IF 11
     C     P@OPTN        ANDNE     '*FREE  '                                     AND
     C*          P@OPTN    ANDNE'*OPTION'                   AND           E01168
     C     P@RTCD        ANDNE     '*OPTION'                                     AND           E0116
     C                   eval      D@FMT = FCREPT                                           MD055265
     C                   MOVEL     D@FMT         P@FMT
     C                   END                                                    FI 11
      *
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
FCREPTL1  AOREPTR0  REPORT DETAILS codes
**CTDATA CPY@
(c) Finastra International Limited 2001
