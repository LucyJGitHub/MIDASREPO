     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055891
/*STD *  RPGSQLBND                                                    *                     MD055891
/*EXI *  TEXT('Midas AO COB components')
     F********************************************************************
     F*                                                                  *
     F*  Midas  ACCESS OBJECTS
     F*                                                                  *
     F*     AOCMPNPD - CLOSE OF BUSINESS COMPONENTS                      *
     F*                                                                  *
      *  (c) Finastra International Limited 2001                      *
     F*                                                                  *
      *  Last Amend No. MD058986           Date 11Oct21               *
      *  Prev Amend No. MD055891           Date 01Sep20               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 S01407             Date 23Jan93               *
     F*                                                                  *
     F********************************************************************
     F*                                                                  *
      *  MD058986 - Add Logical Delete for components and dependencies*
      *  MD055891 - Deliverable Data Split for COB                    *
      *  MD046248 - Finastra Rebranding                               *
     F*     S01407 - SWITCHABILITY ENHANCEMENTS                          *
     F*                                                                  *
     F********************************************************************
     F*
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
     F*CBCMPNL1* IF   E           K DISK    USROPN                                          MD055891
      * IN  - @DHREGH
      ************************************************************
      /EJECT
      *ESTART
      ************************************************************
      ************************************************************
     D* Description     : Copyright notice for inclusion in all programs
      *
      ********************************************************************
      ********************************************************************
      /EJECT
      *ISTART
      ************************************************************
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright     arr
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
     D*D@FMT****     E DS                  EXTNAME(CBCMPNPD)                                MD055891
     D D@FMT         E DS                  EXTNAME(CBCMPJW0)                                MD055891
     D                                     PREFIX(@)                                        MD055891
      * CBCMPND0-
      *
     D CBCMPN        E DS                  EXTNAME(CBCMPJW0)                                MD055891
     D P@FMT         E DS                  EXTNAME(DSFDY)
      *
     D P@KEY1          DS
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
     D P@KEY2          DS
     D  W@SL11                 1      1
     D  W@SL12                 2      2
     D  W@SL13                 3      3
     D  W@SL14                 4      4
     D  W@SL15                 5      5
      ************************************************************
      /EJECT
      *CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    P@KEY1           10            I:Compnt name
     C                   PARM                    P@KEY2            5            I:Compnt seq no
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
     C**********         OPEN      CBCMPNL1                             91        Open file MD055891
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   END                                                    FI 1
      *
      * Last call - close file and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 2 FREE PGM
     C**********         CLOSE     CBCMPNL1                             92        Close fileMD055891
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   SETON                                        LR          Set ind.
     C                   END                                                    FI 2
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 FIRST REC
     C******LOVAL        SETLL     @DHREGH                            9390        Set file  MD055891
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   END                                                    FI 3
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 NEXT REC
     C**********         READ      @DHREGH                              9094      Read recorMD055891
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 4
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 LAST REC
     C******HIVAL        SETGT     @DHREGH                              90        Set file  MD055891
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   END                                                    FI 5
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 PREV.REC
     C**********         READP     @DHREGH                              9094      Read recorMD055891
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 6
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 KEYED ACC
     C     P@OPTN        OREQ      '*VERIFY'                                      OR
     C     W@SL01        IFEQ      '?'                                          IF ? ENTETED
     C     W@SL02        OREQ      '?'                                            OR
     C     W@SL03        OREQ      '?'                                            OR
     C     W@SL04        OREQ      '?'                                            OR
     C     W@SL05        OREQ      '?'                                            OR
     C     W@SL06        OREQ      '?'                                            OR
     C     W@SL07        OREQ      '?'                                            OR
     C     W@SL08        OREQ      '?'                                            OR
     C     W@SL09        OREQ      '?'                                            OR
     C     W@SL10        OREQ      '?'                                            OR
     C     W@SL11        OREQ      '?'                                            OR
     C     W@SL12        OREQ      '?'                                            OR
     C     W@SL13        OREQ      '?'                                            OR
     C     W@SL14        OREQ      '?'                                            OR
     C     W@SL15        OREQ      '?'                                            OR
     C                   CALL      '???????'                            98        <SELECT>
     C                   PARM      *BLANK        P@RTC2            7              B:Return code
     C                   PARM      *BLANK        P@KEY1                           B:Key
     C                   PARM      *BLANK        P@KEY2                           B:Key
     C     P@RTC2        COMP      *BLANK                             97          No selection
     C     *IN97         CABEQ     '1'           T@SKIP                           No selection
     C     *IN98         CABEQ     '1'           T@SKIP                           Program error
     C                   END                                                    FI 8
     C*****P@DSNB        CHAIN     @DHREGH                            9590        Get recordMD055891
     C                   MOVEL     P@KEY1        KEY1             10                        MD055891
     C                   MOVEL     P@KEY2        KEY2              5                        MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBCMPN                                                                        MD055891
     C+ from CBCMPJW0                                                                       MD055891
     C+ where DHCOTT = :KEY1   and DHCSEQ = :KEY2                                           MD055891
     C/END-EXEC                                                                             MD055891
     C                   Setoff                                       9095                  MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        95                    MD055891
     C                   ENDIF                                                              MD055891
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD055891
     C                   SETON                                        90                    MD055891
     C                   ENDIF                                                              MD055891
                                                                                            MD055891
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
     C                   eval      D@FMT = CBCMPN                                           MD055891
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
CBCMPNPD  AOCMPNR0  Close of Business Components
**CTDATA CPY@
(c) Finastra International Limited 2001
