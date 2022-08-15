     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058085
/*STD *  RPGSQLBND                                                    *                     MD058085
/*EXI *  TEXT('Midas AO CI Transaction Types access object')
      *****************************************************************
      *                                                               *
      *  Midas Access Objects Module                                  *
      *                                                               *
      *  AOBAITR0 - Read Access to Transaction Types File             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058085           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CRT003  *CREATE    Date 22Jul96               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD058085 - Deliverable Data Split for Standing Data          *
      *  MD046248 - Finastra Rebranding                               *
      *  CRT003 - Cashier Interface                                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L     FUNCTION OF INDICATORS                      *
      *                                                               *
      *       01       OPEN FILE                                      *
      *       90       FILE ERROR                                     *
      *       91       OPEN ERROR                                     *
      *       92       CLOSE ERROR                                    *
      *       93       EMPTY FILE                                     *
      *       94       END OF FILE                                    *
      *       95       NO RECORD FOUND                                *
      *       96       OPTION ERROR                                   *
      *       97       NO SELECTION                                   *
      *       98       CALL ERROR                                     *
      *       99       SEND MESSAGE ERROR                             *
      *                                                               *
      *****************************************************************
      /EJECT
     F*FSTART
      ************************************************************
     F*SDBAITL1* IF   E           K DISK    USROPN                                          MD058085
     F**********                           RENAME(@BAITL1:@BAIT)                            MD058085
      * IN  - @BAITL1 Tran. Types      (FXBAIT) Transaction Types
      *...........................................................
     F*SDBAITL2* IF   E           K DISK    USROPN                                          MD058085
     F**********                           RENAME(@BAITL2:@TTFC)                            MD058085
      * IN  - @BAITL2 Tran. Types      (FXTTFC) Function Code
      ************************************************************
      /SPACE 3
     D*ESTART
      ***************************************************
      * Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
      ************************************************************
      *-----------------------------------------------------------
      ***************************************************
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
     D*D@FMT****     E DS                  EXTNAME(SDBAITPD)                                MD058085
     D D@FMT         E DS                  EXTNAME(SDBATJW0)                                MD058085
     D X@KEY           S             10A                                                    MD058085
      * @TTYP - BAI transaction type record format data structure
      *
     D P@FMT         E DS                  EXTNAME(DSFDY)
     D* External Data structure to hold the outgoing record format
     D* of the file.
      *
     D P@KEY1          DS
      * Key input data structure
     D  @IN                    1     10
     D                                     DIM(10) ASCEND                       Input array
     D  W@BAIT                 1     10
     D  W@INIT                 1      1
     D  W@SP                   1      2
     D  W@TTFC                 1      3
     D  W@BLNK                 4     10
      *
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
     C                   PARM                    P@KEY1                         I:Key field
     C                   PARM                    P@KYST            7            O:Key status
     C                   PARM                    P@FMT                          O:Format
      *****************************************************
      *MAIN
      *
     C                   eval      X@KEY  = P@KEY1                                          MD058085
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
     C                   SETOFF                                       505152     Test indicator
     C                   SETOFF                                       535455     Selection inds.
     C                   MOVE      *BLANK        P@KYST                          Key status
     C                   MOVE      *BLANK        W@ALGN           10             Align key
      *
      * Check key to determine file to use :
      *
      *    1. Check for first two characters if SP        -> BAI Tran Type
      *    2. Otherwise, key field is in error
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF KEYED ACCESS
     C     P@OPTN        OREQ      '*VERIFY'                                    OR VERIFY
      *                    ¦
      * a) Align and check transaction type or function code:
      *                    ¦
     C                   Z-ADD     1             P1                3 0            Set pointer
     C     *BLANK        LOOKUP    @IN(P1)                            97          First non-blank
     C     *IN97         CABEQ     '0'           T@SKIP                   97      -> Key is blank
      *                    ¦
     C                   MOVEA     @IN(P1)       W@ALGN                           ¦ Align
     C                   MOVE      W@ALGN        P@KEY1                           ¦ left
      *                    ¦
     C     W@SP          IFEQ      'SP'                                         IF 'SP'
     C                   MOVE      '*TTYP  '     P@KYST                           Tran Type
     C                   ELSE                                                   EL 2 Func. Code
     C     W@BLNK        CABNE     *BLANK        T@SKIP               9797        -> Chars.>3
     C                   SETON                                        50          Func Code ind.
     C                   MOVE      '*TTFC  '     P@KYST                   97      Func Code
     C                   END                                                    FI 2
      *                    ¦
     C                   END                                                    FI 1
      *
      * First call - open files :
      *
     C     *IN50         IFEQ      '0'                                          IF 3 TRAN TYPE
     C     *IN01         IFEQ      '0'                                          IF 4 FIRST TIME
     C                   SETON                                        01          Set ind.
     C**********         OPEN      SDBAITL1                             91        Open file MD058085
     C******IN91         CABEQ     '1'           T@SKIP                   LR      Open errorMD058085
     C                   END                                                    FI 4
     C                   ELSE                                                   EL 3 FUNC CODE
     C     *IN02         IFEQ      '0'                                          IF 5 FIRST TIME
     C                   SETON                                        02          Set ind.
     C**********         OPEN      SDBAITL2                             91        Open file MD058085
     C******IN91         CABEQ     '1'           T@SKIP                   LR      Open errorMD058085
     C                   END                                                    FI 5
     C                   END                                                    FI 3
      *
      * Last call - close files and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 6 FREE PROGRAM
     C***01*****         CLOSE     SDBAITL1                             92        Close fileMD058085
     C******IN92         CABEQ     '1'           T@SKIP                   LR      Close erroMD058085
     C***02*****         CLOSE     SDBAITL2                             92        Close fileMD058085
     C******IN92         CABEQ     '1'           T@SKIP                   LR      Close erroMD058085
     C                   SETON                                        LR          Set ind.
     C                   RETURN                                                   Return
     C                   END                                                    FI 6
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 FIRST RECORD
     C******LOVAL        SETLL     @BAIT                              9390        Set file  MD058085
     C******IN93         CABEQ     '1'           T@SKIP                           Empty fileMD058085
     C******IN90         CABEQ     '1'           T@SKIP                   LR      File errorMD058085
     C**********         MOVE      '*NEXT  '     P@OPTN                           Force *NexMD058085
     C                   END                                                    FI 3
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 NEXT RECORD
     C**********         READ      @BAIT                                9094      Read recorMD058085
     C******IN94         CABEQ     '1'           T@SKIP                           End of filMD058085
     C******IN90         CABEQ     '1'           T@SKIP                   LR      File errorMD058085
     C                   END                                                    FI 4
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 LAST RECORD
     C******HIVAL        SETGT     @BAIT                                90        Set file  MD058085
     C******IN90         CABEQ     '1'           T@SKIP                   LR      File errorMD058085
     C**********         MOVE      '*PREV  '     P@OPTN                           Force *PreMD058085
     C                   END                                                    FI 5
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 PREV.RECORD
     C**********         READP     @BAIT                                9094      Read recorMD058085
     C******IN94         CABEQ     '1'           T@SKIP                           End of filMD058085
     C******IN90         CABEQ     '1'           T@SKIP                   LR      File errorMD058085
     C                   END                                                    FI 6
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 KEYED ACCESS
     C     P@OPTN        OREQ      '*VERIFY'                                     OR
     C**N50W@BAIT        CHAIN     @BAIT                              9590        Get recordMD058085
     C                   IF        *IN50 = *OFF                                             MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :D@FMT                                                                         MD058085
     C+ from SDBATJW0                                                                       MD058085
     C+ where FXBAIT = :X@KEY                                                               MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       9095                  MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   SETON                                        95                    MD058085
     C                   ENDIF                                                              MD058085
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058085
     C                   SETON                                        90                    MD058085
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
     C                   ELSE                                                               MD058085
     C***50W@TTFC        CHAIN     @TTFC                              9590        Get recordMD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :D@FMT                                                                         MD058085
     C+ from SDBATJW0                                                                       MD058085
     C+ where FXTTFC = :X@KEY                                                               MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       9095                  MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   SETON                                        95                    MD058085
     C                   ENDIF                                                              MD058085
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058085
     C                   SETON                                        90                    MD058085
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
     C                   ENDIF                                                              MD058085
      *
      * Deleted Transaction Type not valid.
      *
     C     FXTYLC        IFEQ      'D'                                          IF DELETED
     C                   SETON                                        95          No record found
     C                   END                                                    FI
      *
     C     *IN95         CABEQ     '1'           T@SKIP                           No record found
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 7
      *
     C     P@OPTN        IFNE      '*KEY   '                                    IF 8 NOT KEYED
     C     P@OPTN        ANDNE     '*NEXT  '                                     AND NOT SEQ.
     C     P@OPTN        ANDNE     '*PREV  '                                     AND
     C     P@OPTN        ANDNE     '*VERIFY'                                     AND
     C     P@OPTN        ANDNE     '*FREE  '                                     AND
     C                   SETON                                          96        Parameter error
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
     C   97              MOVE      '*KEY   '     P@RTCD                         Invalid key
     C   54              MOVE      '*NOSEL '     P@RTCD                         No selection
     C   55              MOVE      '*CALL  '     P@RTCD                         Call error
     C   97              MOVE      '*ERROR '     P@KYST                         Key status
      *
      * Caller requests message sent to program queue :
      *
     C     W@RTCD        IFEQ      '*MSG   '                                    IF 9 SEND MESSAGE
     C     P@RTCD        ANDNE     *BLANK                                        AND ERROR
     C   90              MOVE      'ACO1001'     P@MGID                           File error
     C   91              MOVE      'ACO1002'     P@MGID                           Open error
     C   92              MOVE      'ACO1003'     P@MGID                           Close error
     C   93              MOVE      'ACO1004'     P@MGID                           Empty file
     C   94              MOVE      'ACO1005'     P@MGID                           End of file
     C   95              MOVE      'ACO1006'     P@MGID                           No record found
     C   96              MOVE      'ACO1007'     P@MGID                           Option error
     C   97              MOVE      'ACO1008'     P@MGID                           Invalid key
     C   54              MOVE      'ACO1009'     P@MGID                           No selection
     C   55              MOVE      'ACO1010'     P@MGID                           Call error
     C                   CALL      'ZASNMG'                                       <SEND MESSAGE>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Program name
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Message ID
     C                   PARM      *BLANK        P@MSGF           10              I:Message file
     C                   PARM      *BLANK        P@MGKY            4              O:Message key
     C                   PARM                    P@MGDA           50              I:Message data
     C                   PARM      '*DIAG'       P@MGTP            7              I:Message type
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
     C     P@RTCD        ANDNE     '*OPTION'                                      AND
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
SDBAITPD  AOBAITR0  Transaction Types Detail
**CTDATA CPY@
(c) Finastra International Limited 2001
