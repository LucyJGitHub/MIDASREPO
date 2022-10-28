     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/**** *  RPGBASEMOD                                                   *                     MD058830
/*STD *  RPGSQLMOD                                                    *                     MD058830
/*EXI *  CLOSQLCSR(*ENDACTGRP)                                        *                     MD058830
/*EXI *  TEXT('Midas AO Read Access to Network Description')          *
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  AONWRKR1 - Midas AO Read Access to Network Description       *
      *                                                               *
      *  Component of: SP4AO0002 & AONWRKR1                           *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD058830           Date 01Oct21               *
      *  Prev Amend No. CMG008             Date 20Feb20               *
      *                 MD046248           Date 27Oct17               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL013  *CREATE    Date 18Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058830 - Deliverable Data Split for SDNWRKPD               *
      *  CMG008 - SWIFT Character Translation Table (Recompile)       *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************

     F*SDNWRKL1* IF   E           K DISK    USROPN                                          MD058830
     F**********                           RENAME(@EDREJZ:SDNWRKD1)                         MD058830
      ** Midas Message Network Details
      *
      *****************************************************************
      *                                                               *
      * Use of Indicators                                             *
      *                                                               *
      * 01 - Off on the first run                                     *
      * 90 - File error                                               *
      * 91 - Open error                                               *
      * 92 - Close error                                              *
      * 93 - Empty file                                               *
      * 94 - End of file                                              *
      * 95 - No record found                                          *
      * 96 - Option error                                             *
      * 97 - No selection                                             *
      * 98 - Call error (SDMDSRR)                                     *
      * 99 - Call error (ZASNMG)                                      *
      *                                                               *
      *****************************************************************

      ** Automatically included D-specs
      ** ==============================
      *

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS

      ** Manually included D-specs
      ** =========================
      *

      ** Named constants
      ** ---------------
      *

      ** Arrays and Data Structures
      ** --------------------------
      *
     D P@MGDA          DS
     D  @MG                    1     50    DIM(1) CTDATA PERRCD(1)
      *
     D*D@FMT****     E DS                  EXTNAME(SDNWRKPD)                                MD058830
     D D@FMT         E DS                  EXTNAME(SDNWKJW0)                                MD058830
      ** @EDREJZ - RPG Name SDNWRKD1 - Real record format data structure
      *

     D P@FMT         E DS                  EXTNAME(DSLDY)
      ** Dummy record data structure
      *

     D P@NWR1          S              6                                                     MD058830
     D P@NWRK          DS             6
      ** Key slicing data structure (for Record Selection)
     D  W@SL01                 1      1

      ** Declared variables
      ** ------------------
      *

      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================
      *

      ** Entry parameters
      *
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    P@NWRK                         I:Key field
     C                   PARM                    P@FMT                          O:Format

      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*

     C     P@OPTN        IFEQ      '*SAME  '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      T@SKIP
     C                   ENDIF

     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       939495     ¦ error
     C                   SETOFF                                       969798     ¦ indicators

      ** First call - open file
      *
     C     *IN01         IFEQ      '0'                                          IF 1 1'st time
     C                   SETON                                        01          Set ind.
     C**********         OPEN      SDNWRKL1                             91        Open file MD058830
     C******IN91         CABEQ     '1'           T@SKIP                   LR      Open errorMD058830
     C                   ENDIF                                                  FI 1

      ** Last call - close file and terminate program
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 2 Free
     C**********         CLOSE     SDNWRKL1                             92        Close fileMD058830
     C******IN92         CABEQ     '1'           T@SKIP                   LR      Close erroMD058830
     C                   SETON                                        LR          Set ind.
     C                   ENDIF                                                  FI 2

      ** Caller requests first record
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 First rec
     C******LOVAL        SETLL     SDNWRKD1                           9390        Set file  MD058830
     C******IN93         CABEQ     '1'           T@SKIP                           Empty fileMD058830
     C******IN90         CABEQ     '1'           T@SKIP                   LR      File errorMD058830
     C                   eval      P@NWR1 = P@NWRK                                          MD058830
      * if *FIRST, read first one                                                           MD058830
     C/EXEC SQL                                                                             MD058830
     C+ close ACursor                                                                       MD058830
     C/END-EXEC                                                                             MD058830
                                                                                            MD058830
     C/EXEC SQL                                                                             MD058830
     C+ declare ACursor insensitive scroll cursor for                                       MD058830
     C+ select * from SDNWKJW0                                                              MD058830
     C+ where EDNWRK > :P@NWR1                                                              MD058830
     C+ order by EDNWRK                                                                     MD058830
     C/END-EXEC                                                                             MD058830
                                                                                            MD058830
     C/EXEC SQL                                                                             MD058830
     C+ open ACursor                                                                        MD058830
     C/END-EXEC                                                                             MD058830
                                                                                            MD058830
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   ENDIF                                                  FI 3

      ** Caller requests next record
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 Next rec
     C**********         READ      SDNWRKD1                             9094      Read recorMD058830
     C******IN94         CABEQ     '1'           T@SKIP                           End of filMD058830
     C******IN90         CABEQ     '1'           T@SKIP                   LR      File errorMD058830
                                                                                            MD058830
     C/EXEC SQL                                                                             MD058830
     C+ fetch next from ACursor into :D@FMT                                                 MD058830
     C/END-EXEC                                                                             MD058830
                                                                                            MD058830
     C                   Setoff                                       9094                  MD058830
     C                   If        SQLCODE = 100                                            MD058830
     C                   SETON                                        94                    MD058830
     C                   ENDIF                                                              MD058830
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058830
     C                   SETON                                        90                    MD058830
     C                   ENDIF                                                              MD058830
                                                                                            MD058830
     C                   ENDIF                                                  FI 4

      ** Caller requests last record
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 Last rec
     C******HIVAL        SETGT     SDNWRKD1                             90        Set file  MD058830
     C******IN90         CABEQ     '1'           T@SKIP                   LR      File errorMD058830
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   ENDIF                                                  FI 5

      ** Caller requests previous record
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 Prev rec
     C**********         READP     SDNWRKD1                             9094      Read recorMD058830
     C******IN94         CABEQ     '1'           T@SKIP                           End of filMD058830
     C******IN90         CABEQ     '1'           T@SKIP                   LR      File errorMD058830
     C                   ENDIF                                                  FI 6

      ** Caller requests record indicated by key
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 Keyed
     C     P@OPTN        OREQ      '*VERIFY'                                     OR

     C                   IF        %Scan('?':W@SL01:1) <> 0                     IF 8 selection
     C                   CALL      'SD200102'                           98        <SELECT>
     C                   PARM      *BLANK        P@RTC2            7              B:Return code
     C                   PARM      *BLANK        P@NWRK                           B:Key

     C     P@RTC2        COMP      *BLANK                             97          No selection
     C     *IN97         CABEQ     '1'           T@SKIP                           No selection
     C     *IN98         CABEQ     '1'           T@SKIP                           Program error
     C                   ENDIF                                                  FI 8

     C*****P@NWRK        CHAIN     SDNWRKD1                           9590        Get recordMD058830
     C                   eval      P@NWR1 = P@NWRK                                          MD058830
     C/EXEC SQL                                                                             MD058830
     C+ SELECT *                                                                            MD058830
     C+ into :D@FMT                                                                         MD058830
     C+ from SDNWKJW0                                                                       MD058830
     C+ where EDNWRK = :P@NWR1                                                              MD058830
     C/END-EXEC                                                                             MD058830
     C                   Setoff                                       9095                  MD058830
     C                   If        SQLCODE = 100                                            MD058830
     C                   SETON                                        95                    MD058830
     C                   ENDIF                                                              MD058830
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058830
     C                   SETON                                        90                    MD058830
     C                   ENDIF                                                              MD058830
                                                                                            MD058830
     C     *IN95         CABEQ     '1'           T@SKIP                           No rec found
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   ENDIF                                                  FI 7

     C     P@OPTN        IFNE      '*KEY   '                                    IF 8 invalid
     C     P@OPTN        ANDNE     '*NEXT  '                                     parameter
     C     P@OPTN        ANDNE     '*PREV  '
     C     P@OPTN        ANDNE     '*VERIFY'                                     AND
     C     P@OPTN        ANDNE     '*FREE  '                                     AND
     C                   SETON                                          96        Parm error
     C                   ENDIF                                                  FI 8

      ** No record found or End of file - return error code
      *
     C     T@SKIP        TAG                                                    +++ SKIP +++
      *    ----------    ------
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

      ** Caller requests message sent to program queue
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

     C                   CALLB     'ZASNMG'                                       <SND MSG>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PSProcPgm     P@PGNM           10              I:Prog name
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Msg ID
     C                   PARM      *BLANK        P@MSGF           10              I:Msg file
     C                   PARM      *BLANK        P@MGKY            4              O:Msg key
     C                   PARM                    P@MGDA           50              I:Msg data
     C                   PARM      '*DIAG'       P@MGTP            7              I:Msg type
     C                   ENDIF                                                  FI 9

      ** Caller Requests DB Error Handling
      *
     C     W@RTCD        IFEQ      '*DBERR'                                     IF
     C     P@RTCD        ANDNE     *BLANK                                         AND
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   END                                                    FI

     C     P@OPTN        IFNE      '*VERIFY'
     C     P@OPTN        ANDNE     '*FREE'
     C     P@RTCD        ANDNE     '*OPTION'
     C                   MOVEL     D@FMT         P@FMT
     C                   END

      ** Return to caller
      *
     C                   RETURN
      *========================================================================*
**CTDATA @MG
SDNWRKPD  AONWRKR1  NWRK DESC
