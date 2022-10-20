     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD060008
/*STD *  RPGSQLBND                                                    *                     MD060008
/*EXI *  TEXT('Midas AO Access program: Message Types')
     F********************************************************************
     F*                                                                  *
     F*  Midas ACCESS OBJECTS
     F*                                                                  *
     F*     AOMTPYR0 - READ ACCESS TO MESSAGE TYPE DETAILS FILE          *
     F*                                                                  *
      *  (c) Finastra International Limited 2001                      *
     F*                                                                  *
      *  Last Amend No. MD060008           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
     F*                                       DATE 00/00/00              *
     F*                                                                  *
     F********************************************************************
      *                                                                  *
      *  MD060008 - Deliverable Data Split for Standing Data 2        *
      *                                                                  *
      ********************************************************************
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
     F*SDMTPYL1* IF   E           K DISK    USROPN                                          MD060008
      * IN  - @EEREJ2 MESSAGE TYPE DETAILS
      ************************************************************
      /EJECT
     D*ESTART
      ************************************************************
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D********************************************************************
      ************************************************************
      /EJECT
     D*ISTART
      ************************************************************
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright     arr
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
     D*D@FMT****     E DS                  EXTNAME(SDMTPYPD)                                MD060008
     D D@FMT         E DS                  EXTNAME(SDMTYJW0)                                MD060008
     D X@MTPY          S              3A                                                    MD060008
      * @EEREJ2 - MESSAGE TYPE RECORD FORMAT DATA STRUCTURE
      *
     D P@FMT         E DS                  EXTNAME(DSFDY)
      * Internal MESG TYPE  code data structure.
      *
     D P@MTPY          DS             3
      * Key slicing data structure (for Record Selection)
     D  W@SL01                 1      1
      *
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    P@MTPY            3            I:Key field
     C                   PARM                    P@FMT                          O:Format
      *****************************************************
     C                   eval      X@MTPY = P@MTPY                                          MD060008
      *MAIN
     C     P@OPTN        IFEQ      '*SAME  '
     C******IN01         COMP      '0'                                    91                MD060008
     C**********         GOTO      T@SKIP                                                   MD060008
     C                   END
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       939495     ¦ error
     C                   SETOFF                                       969798     ¦ indicators
      *
      * First call - open file :
      *
     C     *IN01         IFEQ      '0'                                          IF 1 1'st time
     C                   SETON                                        01          Set ind.
     C**********         OPEN      SDMTPYL1                             91        Open file MD060008
     C******IN91         CABEQ     '1'           T@SKIP                   LR      Open errorMD060008
     C                   END                                                    FI 1
      *
      * Last call - close file and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 2 Free
     C**********         CLOSE     SDMTPYL1                             92        Close fileMD060008
     C******IN92         CABEQ     '1'           T@SKIP                   LR      Close erroMD060008
     C**********         SETON                                        LR          Set ind.  MD060008
     C                   END                                                    FI 2
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 First rec
     C******LOVAL        SETLL     @EEREJ2                            9390        Set file  MD060008
     C******IN93         CABEQ     '1'           T@SKIP                           Empty fileMD060008
     C******IN90         CABEQ     '1'           T@SKIP                   LR      File errorMD060008
     C**********         MOVE      '*NEXT  '     P@OPTN                           Force *NexMD060008
     C                   END                                                    FI 3
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 Next rec
     C**********         READ      @EEREJ2                              9094      Read recorMD060008
     C******IN94         CABEQ     '1'           T@SKIP                           End of filMD060008
     C******IN90         CABEQ     '1'           T@SKIP                   LR      File errorMD060008
     C                   END                                                    FI 4
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 Last rec
     C******HIVAL        SETGT     @EEREJ2                              90        Set file  MD060008
     C******IN90         CABEQ     '1'           T@SKIP                   LR      File errorMD060008
     C**********         MOVE      '*PREV  '     P@OPTN                           Force *PreMD060008
     C                   END                                                    FI 5
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 Prev rec
     C**********         READP     @EEREJ2                              9094      Read recorMD060008
     C******IN94         CABEQ     '1'           T@SKIP                           End of filMD060008
     C******IN90         CABEQ     '1'           T@SKIP                   LR      File errorMD060008
     C                   END                                                    FI 6
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 Keyed
     C     P@OPTN        OREQ      '*VERIFY'                                     OR
     C     W@SL01        IFEQ      '?'                                          IF 8 selection
     C                   CALL      'SD2030S'                            98        <SELECT>
     C                   PARM      *BLANK        P@RTC2            7              B:Return code
     C                   PARM      *BLANK        P@MTPY                           B:Key
     C     P@RTC2        COMP      *BLANK                             97          No selection
     C     *IN97         CABEQ     '1'           T@SKIP                           No selection
     C     *IN98         CABEQ     '1'           T@SKIP                           Program error
     C                   eval      X@MTPY = P@MTPY                                          MD060008
     C                   END                                                    FI 8
     C*****P@MTPY        CHAIN     @EEREJ2                            9590        Get recordMD060008
     C/EXEC SQL                                                                             MD060008
     C+ SELECT *                                                                            MD060008
     C+ into :D@FMT                                                                         MD060008
     C+ from SDMTYJW0                                                                       MD060008
     C+ where EEMTPY = :X@MTPY                                                              MD060008
     C/END-EXEC                                                                             MD060008
     C                   SETOFF                                       9095                  MD060008
     C                   If        SQLCODE = 100                                            MD060008
     C                   SETON                                        95                    MD060008
     C                   ENDIF                                                              MD060008
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD060008
     C                   SETON                                        90                    MD060008
     C                   ENDIF                                                              MD060008
                                                                                            MD060008
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
SDMTPYPD  AOMTPYR0  MSTY DESC
**CTDATA CPY@
(c) Finastra International Limited 2001
