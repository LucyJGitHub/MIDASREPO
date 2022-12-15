     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058769
/*STD *  RPGSQLBND                                                    *                     MD058769
/*EXI *  TEXT('Midas AO Narrative codes             *RDR')            *
     F********************************************************************
     F*                                                                  *
     F*  Midas  ACCESS OBJECTS
     F*                                                                  *
     F*     AONARRR0 - READ ACCESS TO NARRATIVE CODES FILE               *
     F*                                                                  *
      *  (c) Finastra International Limited 2001                         *
     F*                                                                  *
      *  Last Amend No. MD058769           Date 21Sep21               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1004679          Date 30Jul12               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ---------------------------------*
      *                 BUG11882           Date 10Aug06               *
      *                    CSD031          Date 10Apr06                  *
      * Midas Release 4 --------------- Base ----------------------------*
      * Midas DBA 3.00 ---------------- Base ----------------------------*
      *                    S01230          Date 23Nov89                  *
     F*                    S01230          Date 06Nov89                  *
     F*                    E01168             DATE 14/02/89              *
     F*                                                                  *
     F********************************************************************
      *                                                                  *
      *  MD058769 - Deliverable Data Split for SDNARRPD and TABLETP      *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1004679 - Program AONARRR0 calls AOSARDR0 every time          *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                   *
      *     BUG11882 - DBase error encountered during CoB in DL0295      *
      *     CSD031 - Enhanced Centralised Static Date                    *
     F*     S01230 - STANDARDISE ACCESS PROGRAMS                         *S01230
     F********************************************************************S01230
     F*
     F* ID F  C  H  L     FUNCTION OF INDICATORS
     F*
     F*       01       OPEN FILE - SDNARRL1
     F*       90       FILE ERROR
     F*       91       OPEN ERROR
     F*       92       CLOSE ERROR
     F*       93       EMPTY FILE
     F*       94       END OF FILE
     F*       95       NO RECORD FOUND
     F*       96       OPTION ERROR
     F*       97       NO SELECTION
     F*       98       CALL ERROR
     F*       99       SEND MESSAGE ERROR
     F*
     F********************************************************************
      /EJECT
     F*FSTART
      ************************************************************
     F*SDNARRL1* IF   E           K DISK    USROPN                                          MD058769
      * IN  - @ALREC0 Narrative codes (NVCD)
     FGPNARRL1  IF   E           K DISK    USROPN
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
     D**********D@FMT     E DSSDNARRD0                                    S01230
     D*D@FMT****     E DS                  EXTNAME(SDNARRPD)                    S01230      MD058769
     D D@FMT         E DS                  EXTNAME(SDNARJW0)                                MD058769
      * @ALREC0 - Narrative code record format data structure
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                       C
      ** Switchable features file                                                            CSD031
      *                                                                                      CSD031
     D P@FMT         E DS                  EXTNAME(DSFDY)                       S01230
     D* EXTERNAL DATA STRUCTURE TO HOLD THE OUTGOING RECORD FORMAT        S01230
     D* OF THE FILE.                                                      S01230
      *                                                                   S01230
     D********P@FMT       DS                             36               S01230
     D********                                1  36 P@DMMY                S01230
      *
     D P@NVCD          DS
      * Key slicing data structure (for Record Selection)
     D  W@SL01                 1      1
     D  W@SL02                 2      2
      *
     D*                                                                   S01230
     D* Description     : Copyright notice for inclusion in all programs  S01230
     D*                                                                   S01230
     D A@CPY           DS                                                       S01230
     D* Copyright array                                                   S01230
     D  CPY@                   1     80                                         S01230
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright     arrS01
     D X@NVCD          S              2A                                                    MD058769
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    P@NVCD            2            I:Key field
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
     C                   SETOFF                                       969798     ¦ indicators
      **********                                                                    CSD031 AR1004679
      ***Check*if Enhanced Centralised Static Data is installed                     CSD031 AR1004679
      **********                                                                    CSD031 AR1004679
     C**********           CALL 'AOSARDR0'                                          CSD031 AR1004679
     C**********           PARM *BLANKS   PRTCD   7                                 CSD031 AR1004679
     C**********           PARM '*VERIFY' POPTN   7                                 CSD031 AR1004679
     C**********           PARM 'CSD031'  PSAR    6                                 CSD031 AR1004679
     C********** SCSARD    PARM SCSARD    P@FMT                                     CSD031 AR1004679
      **********                                                                    CSD031 AR1004679
     C********** PRTCD     IFEQ *BLANKS                                             CSD031 AR1004679
     C**********           MOVE 'Y'       CSD031  1                                 CSD031 AR1004679
     C**********           ELSE                                                     CSD031 AR1004679
     C**********           MOVE 'N'       CSD031                                    CSD031 AR1004679
     C**********           ENDIF                                                    CSD031 AR1004679
      *
      * First call - open file :
      *
     C     *IN01         IFEQ      '0'                                          IF 1 FIRST TIME
     C                   SETON                                        01          Set ind.
      *                                                                                    AR1004679
      ** Check if Enhanced Centralised Static Data is installed                            AR1004679
      *                                                                                    AR1004679
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CSD031'      PSAR              6
     C     SCSARD        PARM      SCSARD        P@FMT
      *                                                                                    AR1004679
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSD031            1
     C                   ELSE
     C                   MOVE      'N'           CSD031
     C                   ENDIF
     C     CSD031        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
     C********** CSD031    OREQ 'Y'                                                  CSD031 BUG11882
     C     *INU5         ANDEQ     *ON
     C                   OPEN      GPNARRL1                             91
     C                   ELSE
     C**********         OPEN      SDNARRL1                             91        Open file MD058769
     C                   ENDIF
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   END                                                    FI 1
      *
      * Last call - close file and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 2 FREE PROG
     C     CSD031        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
     C********** CSD031    OREQ 'Y'                                                  CSD031 BUG11882
     C     *INU5         ANDEQ     *ON
     C                   CLOSE     GPNARRL1                             92
     C                   ELSE
     C**********         CLOSE     SDNARRL1                             92        Close fileMD058769
     C                   ENDIF
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   SETON                                        LR          Set ind.
     C                   END                                                    FI 2
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 FIRST REC
     C     CSD031        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
     C********** CSD031    OREQ 'Y'                                                  CSD031 BUG11882
     C     *INU5         ANDEQ     *ON
     C******LOVAL        SETLL     SDNARRD0                           9390                  MD058769
     C                   ELSE
     C******LOVAL        SETLL     @ALREC0                            9390        Set file  MD058769
     C                   ENDIF
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   END                                                    FI 3
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 NEXT REC
     C     CSD031        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
     C********** CSD031    OREQ 'Y'                                                  CSD031 BUG11882
     C     *INU5         ANDEQ     *ON
     C**********         READ      SDNARRD0                             9094                MD058769
     C                   ELSE
     C**********         READ      @ALREC0                              9094      Read recorMD058769
     C                   ENDIF
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 4
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 LAST REC
     C     CSD031        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
     C********** CSD031    OREQ 'Y'                                                  CSD031 BUG11882
     C     *INU5         ANDEQ     *ON
     C******HIVAL        SETGT     SDNARRD0                             90                  MD058769
     C                   ELSE
     C******HIVAL        SETGT     @ALREC0                              90        Set file  MD058769
     C                   ENDIF
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   END                                                    FI 5
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 PREV.REC
     C     CSD031        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
     C********** CSD031    OREQ 'Y'                                                  CSD031 BUG11882
     C     *INU5         ANDEQ     *ON
     C**********         READP     SDNARRD0                             9094                MD058769
     C                   ELSE
     C**********         READP     @ALREC0                              9094      Read recorMD058769
     C                   ENDIF
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 6
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 KEYED ACC
     C     P@OPTN        OREQ      '*VERIFY'                                      OR        CC
     C     W@SL01        IFEQ      '?'                                          IF 8 SELECT
     C     W@SL02        OREQ      '?'                                           OR
     C*********************CALL 'SDB6SRR'              98    <SELECT>     S01230
     C                   CALL      'SD0081S'                            98        <SELECT>     S0123
     C                   PARM      *BLANK        P@RTC2            7              B:Return code
     C                   PARM      *BLANK        P@NVCD                           B:Key
     C     P@RTC2        COMP      *BLANK                             97          No selection
     C     *IN97         CABEQ     '1'           T@SKIP                           No selection
     C     *IN98         CABEQ     '1'           T@SKIP                           Program error
     C                   END                                                    FI 8
     C     CSD031        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
     C********** CSD031    OREQ 'Y'                                                  CSD031 BUG11882
     C     *INU5         ANDEQ     *ON
     C*****P@NVCD        CHAIN     SDNARRD0                           9590                  MD058769
     C                   eval      X@NVCD = P@NVCD                                          MD058769
     C/EXEC SQL                                                                             MD058769
     C+ SELECT *                                                                            MD058769
     C+ into :D@FMT                                                                         MD058769
     C+ from SDNARJW0                                                                       MD058769
     C+ where ALNVCD = :X@NVCD                                                              MD058769
     C/END-EXEC                                                                             MD058769
     C                   Setoff                                       9095                  MD058769
     C                   If        SQLCODE = 100                                            MD058769
     C                   SETON                                        95                    MD058769
     C                   ENDIF                                                              MD058769
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058769
     C                   SETON                                        90                    MD058769
     C                   ENDIF                                                              MD058769
                                                                                            MD058769
     C                   ELSE
     C*****P@NVCD        CHAIN     @ALREC0                            9590        Get recordMD058769
     C                   eval      X@NVCD = P@NVCD                                          MD058769
     C/EXEC SQL                                                                             MD058769
     C+ SELECT *                                                                            MD058769
     C+ into :D@FMT                                                                         MD058769
     C+ from SDNARJW0                                                                       MD058769
     C+ where ALNVCD = :X@NVCD                                                              MD058769
     C/END-EXEC                                                                             MD058769
     C                   Setoff                                       9095                  MD058769
     C                   If        SQLCODE = 100                                            MD058769
     C                   SETON                                        95                    MD058769
     C                   ENDIF                                                              MD058769
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058769
     C                   SETON                                        90                    MD058769
     C                   ENDIF                                                              MD058769
                                                                                            MD058769
     C                   ENDIF
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
     C   95              MOVE      '*NRF   '     P@RTCD                         No record fnd
     C   96              MOVE      '*OPTION'     P@RTCD                         Option error
     C   97              MOVE      '*NOSEL '     P@RTCD                         No selection
     C   98              MOVE      '*CALL  '     P@RTCD                         Calld Pgm err
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
     C   95              MOVE      'ACO1006'     P@MGID                           No record fnd
     C   96              MOVE      'ACO1007'     P@MGID                           Option error
     C   97              MOVE      'ACO1009'     P@MGID                           No selection
     C   98              MOVE      'ACO1010'     P@MGID                           Call error
     C                   CALL      'ZASNMG'                                       <SEND MSG>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Progm name
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
AONARRPD  AONARRR0  Narrative Codes
**CTDATA CPY@
(c) Finastra International Limited 2001
