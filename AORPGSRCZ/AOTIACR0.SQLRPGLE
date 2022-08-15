     H DEBUG
     F********************************************************************
/**** *  RPGBASE                                                      *                     MD058085
/*STD *  RPGSQLBND                                                    *                     MD058085
/*EXI *  TEXT('Midas AO TI account types')
      *****************************************************************
     F*                                                                  *
     F*  Midas  ACCESS OBJECTS                                           *
     F*                                                                  *
     F*     AOTIACR0 - READ ACCESS TO ACCOUNT TYPES FILE                 *
     F*                                                                  *
     F*  (c) Finastra International Limited 2001                         *
     F*                                                                  *
      *  Last Amend No. MD058085           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CTI001  *CREATE    Date 20Jul97               *
     F*                                                                  *
     F********************************************************************
     F*                                                                  *
      *  MD058085 - Deliverable Data Split for Standing Data          *
     F*  MD046248 - Finastra Rebranding                                  *
     F*  CTI001 - MIDAS/TRADE INNOVATION INTERFACE - PHASE I             *
     F*                                                                  *
     F********************************************************************
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
     F*       99       CALL ERROR (ZASNMG)
     F*
      /EJECT
     F*FSTART
      ************************************************************
     F*SDTIACL1* IF   E           K DISK    USROPN                                          MD058085
      * IN  - @TIACL1 ACCOUNT TYPES   (C5AT)
      ************************************************************
      /EJECT
     D*ESTART
      ************************************************************
     D*
      * Description     : Copyright notice for inclusion in all programs
     D********************************************************************
      ************************************************************
      /EJECT
     D*ISTART
      ************************************************************
      * Description     : Copyright notice for inclusion in all programs
     D*
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright
     D*
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
     D*D@FMT****     E DS                  EXTNAME(SDTIACPD)                                MD058085
     D D@FMT         E DS                  EXTNAME(SDTIAJW0)                                MD058085
     D X@C5AT          S              2A                                                    MD058085
      * @TIACL1 - ACCOUNT TYPES RECORD FORMAT DATA STRUCTURE
      *
     D P@FMT         E DS                  EXTNAME(DSFDY)
      * Internal book code data structure.
      *
     D P@C5AT          DS
      * Key slicing data structure (for Record Selection)
     D  W@SL01                 1      1
     D  W@SL02                 2      2
      *
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    P@C5AT            2            I:Key field
     C                   PARM                    P@FMT                          O:Format
      *****************************************************
     C                   eval      X@C5AT = P@C5AT                                          MD058085
      *MAIN
     C     P@OPTN        IFEQ      '*SAME  '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      T@SKIP
     C                   END
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       939495     ¦ error
     C                   SETOFF                                       969798     ¦ indicators
      *
      * First call - open file :
      *
     C     *IN01         IFEQ      '0'                                          IF 1 1'st time
     C                   SETON                                        01          Set ind.
     C**********         OPEN      SDTIACL1                             91        Open file MD058085
     C******IN91         CABEQ     '1'           T@SKIP                   LR      Open errorMD058085
     C                   END                                                    FI 1
      *
      * Last call - close file and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 2 Free
     C**********         CLOSE     SDTIACL1                             92        Close fileMD058085
     C******IN92         CABEQ     '1'           T@SKIP                   LR      Close erroMD058085
     C**********         SETON                                        LR          Set ind.  MD058085
     C                   END                                                    FI 2
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 First rec
     C******LOVAL        SETLL     @TIACL1                            9390        Set file  MD058085
     C******IN93         CABEQ     '1'           T@SKIP                           Empty fileMD058085
     C******IN90         CABEQ     '1'           T@SKIP                   LR      File errorMD058085
     C**********         MOVE      '*NEXT  '     P@OPTN                           Force *NexMD058085
     C                   END                                                    FI 3
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 Next rec
     C**********         READ      @TIACL1                              9094      Read recorMD058085
     C******IN94         CABEQ     '1'           T@SKIP                           End of filMD058085
     C******IN90         CABEQ     '1'           T@SKIP                   LR      File errorMD058085
     C                   END                                                    FI 4
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 Last rec
     C******HIVAL        SETGT     @TIACL1                              90        Set file  MD058085
     C******IN90         CABEQ     '1'           T@SKIP                   LR      File errorMD058085
     C**********         MOVE      '*PREV  '     P@OPTN                           Force *PreMD058085
     C                   END                                                    FI 5
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 Prev rec
     C**********         READP     @TIACL1                              9094      Read recorMD058085
     C******IN94         CABEQ     '1'           T@SKIP                           End of filMD058085
     C******IN90         CABEQ     '1'           T@SKIP                   LR      File errorMD058085
     C                   END                                                    FI 6
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 Keyed
     C     P@OPTN        OREQ      '*VERIFY'                                     OR
     C     W@SL01        IFEQ      '?'                                          IF 8 selection
     C     W@SL02        OREQ      '?'                                           OR
     C**********         CALL      'SD0310S'                            98        <SELECT>  MD058085
     C                   CALL      'SD0035S'                            98        <SELECT>  MD058985
     C                   PARM      *BLANK        P@RTC2            7              B:Return code
     C                   PARM      *BLANK        P@C5AT                           B:Key
     C     P@RTC2        COMP      *BLANK                             97          No selection
     C     *IN97         CABEQ     '1'           T@SKIP                           No selection
     C     *IN98         CABEQ     '1'           T@SKIP                           Program error
     C                   eval      X@C5AT = P@C5AT                                          MD058085
     C                   END                                                    FI 8
     C*****P@C5AT        CHAIN     @TIACL1                            9590        Get recordMD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :D@FMT                                                                         MD058085
     C+ from SDTIAJW0                                                                       MD058085
     C+ where GDC5AT = :X@C5AT                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       9095                  MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   SETON                                        95                    MD058085
     C                   ENDIF                                                              MD058085
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058085
     C                   SETON                                        90                    MD058085
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
     C     *IN95         CABEQ     '1'           T@SKIP                           No rec found
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 7
      *
     C     P@OPTN        IFNE      '*KEY   '                                    IF 8 invalid
     C     P@OPTN        ANDNE     '*NEXT  '                                     parameter
     C     P@OPTN        ANDNE     '*PREV  '
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
     C                   PARM                    P@MGDA           50              I:Msg data
     C                   PARM      '*DIAG'       P@MGTP            7              I:Msg type
     C                   END                                                    FI 9
      *
      * Caller Requests DB Error Handling
      *
     C     W@RTCD        IFEQ      '*DBERR'                                     IF
     C     P@RTCD        ANDNE     *BLANK                                         AND
     C                   DUMP
     C                   CALL      'DBERRCTL'
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
SDTIACPD  AOTIACR0  Account Types
**CTDATA CPY@
(c) Finastra International Limited 2001
