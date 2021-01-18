     H DEBUG DFTNAME(S01230)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056890
/*STD *  RPGSQLBND                                                    *                     MD056890
/*EXI *  TEXT('Midas AO Access Program: Access Mandatory Window')
     F********************************************************************S01230
     F*                                                                  *S01230
     F*     Midas  ACCESS OBJECTS                                    *S01230
     F*                                                                  *S01230
     F*     AOMREFR0 - READ ACCESS TO MANDATORY WINDOW FILE              *S01230
     F*                                                                  *S01230
      *  (c) Finastra International Limited 2001                      *
      *                                                                  *S01230
      *  Last Amend No. MD056890           Date 11Oct20               *
      *  Prev Amend No. MD055681           Date 31Jul20               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CPK018             Date 19Mar05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 S01314             Date 26Mar91               *S01230
      *                    S01230             DATE 25/10/89               S01230
      *                                                                   S01230
     F********************************************************************
      *                                                                  *S01230
      *  MD056890 - Deliverable Data Split for SDMREFPD               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *       CPK018 - Change to make windows switchable. Replace use of *
      *                - Replace use of SDMREFL1 with SDMREFJ0.          *
      *       S01314  -  CHANGES MADE DURING PTF INCORPORATION           *S01230
      *       S01230  -  STANDARDISE ACCESS PROGRAMS                     *S01230
      *                                                                  *S01230
     F********************************************************************S01230
     F*                                                                   S01230
     F* ID F  C  H  L  FUNCTION OF INDICATORS                             S01230
     F*                                                                   S01230
     F*       01       OFF ON THE FIRST RUN                               S01230
     F*       90       FILE ERROR                                         S01230
     F*       91       OPEN ERROR                                         S01230
     F*       92       CLOSE ERROR                                        S01230
     F*       93       EMPTY FILE                                         S01230
     F*       94       END OF FILE                                        S01230
     F*       95       NO RECORD FOUND                                    S01230
     F*       96       OPTION ERROR                                       S01230
     F*       99       CALL ERROR (ZASNMG)                                S01230
     F*                                                                   S01230
      /EJECT
     F*FSTART
      ************************************************************
     F*SDMREFL1IF*E*****      K        DISK                           UC                      CPK018
     F*SDMREFJ0* IF   E           K DISK    USROPN                                          MD056890
     FSDOREFL1  IF   E           K DISK    USROPN                               S01314
      **IN**-*@DLREGT*Mandatory*Window****************************        S01230              CPK018
      * IN  - @MREFJ0 Mandatory Window                                                        CPK018
      ************************************************************        S01230
      /EJECT                                                              S01230
     D*ESTART                                                             S01230
      ************************************************************        S01230
      ************************************************************        S01230
      /EJECT
     D*ISTART
      ************************************************************
     D P@MGDA          DS                                                       S01230
     D  @MG                    1     50                                         S01230
     D                                     DIM(1) CTDATA PERRCD(1)                               S01
     D PGMDS          SDS
      * Program Status data structure
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0
      *
     D***********************P@FMT     E DSSDMREFPD                       S01230
     D*D@FMT****     E DS                  EXTNAME(SDMREFPD)                    S01230      MD056890
     D D@FMT         E DS                  EXTNAME(SDMRFJW1)                                MD056890
      **@DLREGT*-*Mandatory*Window*record*format*data*structure*************                  CPK018
#     * @MREFJ0 - Mandatory Window record format data structure                               CPK018
      *
     D*@FMT       DS                             45                       S01230
      * INTERNAL - Mandatory Window Record Format Data Structure          S01230
      *                                                                   S01230
     D P@FMT         E DS                  EXTNAME(DSFDY)                       S01230
     D* External Data structure to hold the outgoing record format        S01230
     D* of the file.                                                      S01230
     D P@KEYS          DS
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
     D  W@SL11                11     11
     D  W@SL12                12     12
     D  P@KEY1                 1     10
     D  P@KEY2                11     12
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    P@KEYS                         I:Key fieldS
     C                   PARM                    P@FMT                          O:Format
      *****************************************************
      *MAIN
      *
     C     P@KEYL        KLIST
     C                   KFLD                    P@KEY1
     C                   KFLD                    P@KEY2
     C                   MOVE      *BLANKS       P@KEY2                                        S0131
      *                                                                   S01230
     C     P@OPTN        IFEQ      '*SAME  '                                                   S0123
     C     *IN01         COMP      '0'                                    91                   S0123
     C                   GOTO      T@SKIP                                                      S0123
     C                   END                                                                   S0123
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       939495     ¦ error
     C                   SETOFF                                       969798     ¦ indicators
      *
      * First call - open file :
      *
     C     *IN01         IFEQ      '0'                                          IF 1 FIRST TIME
     C                   SETON                                        01          Set ind.
     C**********           OPEN SDMREFL1               91    Open file                        CPK018
     C**********         OPEN      SDMREFJ0                             91        Open file MD056890
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   END                                                    FI 1
      *
      * Last call - close file and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 2 FREE PROGRAM
     C**********           CLOSESDMREFL1               92    Close file                       CPK018
     C**********         CLOSE     SDMREFJ0                             92        Close fileMD056890
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   SETON                                        LR          Set ind.
     C                   RETURN                                                   Return
     C                   END                                                    FI 2
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 FIRST RECORD
     C********** *LOVAL    SETLL@DLREGT              9390    Set file                         CPK018
     C******LOVAL        SETLL     @MREFJ0                            9390        Set file  MD056890
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   END                                                    FI 3
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 NEXT RECORD
     C**********           READ @DLREGT                9094  Read record                      CPK018
     C**********         READ      @MREFJ0                              9094      Read recorMD056890
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 4
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 LAST RECORD
     C********** *HIVAL    SETGT@DLREGT                90    Set file                         CPK018
     C******HIVAL        SETGT     @MREFJ0                              90        Set file  MD056890
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   END                                                    FI 5
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 PREV.RECORD
     C**********           READP@DLREGT                9094  Read record                      CPK018
     C**********         READP     @MREFJ0                              9094      Read recorMD056890
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 6
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 KEYED ACCESS
     C     P@OPTN        OREQ      '*VERIFY'                                     OR            S0123
     C********** P@KEYL    CHAIN@DLREGT              9590    Get record                       CPK018
     C*****P@KEYL        CHAIN     @MREFJ0                            9590        Get recordMD056890
     C/EXEC SQL                                                                             MD056890
     C+ SELECT *                                                                            MD056890
     C+ into :D@FMT                                                                         MD056890
     C+ from SDMRFJW1                                                                       MD056890
     C+ where DLNMCP = :P@KEY1 and DLSQNB = :P@KEY2                                         MD056890
     C/END-EXEC                                                                             MD056890
     C                   Setoff                                       9095                  MD056890
     C                   If        SQLCODE = 100                                            MD056890
     C                   SETON                                        95                    MD056890
     C                   ENDIF                                                              MD056890
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD056890
     C                   SETON                                        90                    MD056890
     C                   ENDIF                                                              MD056890
                                                                                            MD056890
     C     *IN95         CABEQ     '1'           T@SKIP                           No record found
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error   S0131
     C**********           READ @DLREGT                9094  Read record               S01314 CPK018
     C**********         READ      @MREFJ0                              9094      Read recorMD056890
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error   S0131
     C     P@KEY1        IFNE      DLNMCP                                       IF 8           S0131
     C     *IN94         OREQ      '1'                                                         S0131
     C***THERE*IS*NO*RECORD*ON*SDMREFL1*SO*CHECK*SDOREFL1*FOR*A*RECORD******           S01314 CPK018
     C*  THERE IS NO RECORD ON SDMREFJ0 SO CHECK SDOREFL1 FOR A RECORD                 S01314 CPK018
     C                   OPEN      SDOREFL1                             91        Open file    S0131
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error   S0131
     C     P@KEYL        SETLL     @DMREGW                            9390                     S0131
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file   S0131
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error   S0131
     C                   READ      @DMREGW                              9094                   S0131
     C     *IN94         CABEQ     '1'           T@SKIP                           NO RECORD    S0131
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      FILE ERROR   S0131
     C     P@KEY1        IFNE      DMNMCP                                       IF 9           S0131
     C                   SETON                                        94                       S0131
     C                   GOTO      T@SKIP                                                      S0131
     C                   END                                                    FI 9           S0131
     C                   END                                                    FI 8           S0131
     C                   END                                                    FI 7
      *
     C     P@OPTN        IFNE      '*KEY   '                                    IF 8 NOT KEYED
     C     P@OPTN        ANDNE     '*NEXT  '                                     AND NOT SEQ.
     C     P@OPTN        ANDNE     '*PREV  '                                     AND
     C     P@OPTN        ANDNE     '*VERIFY'                                     AND           S0123
     C     P@OPTN        ANDNE     '*FREE  '                                     AND           S0123
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
     C   97              MOVE      '*NOSEL '     P@RTCD                         No selection   S0131
     C   98              MOVE      '*CALL  '     P@RTCD                         Called Pgm.err.S0131
      *
      * Caller requests message sent to program queue :
      *
     C     W@RTCD        IFEQ      '*MSG   '                                    IF 9 SEND MESSAGE
     C     P@RTCD        ANDNE     *BLANK                                        AND ERROR
     C   90              MOVE      'ACO0001'     P@MGID                           File error
     C   91              MOVE      'ACO0002'     P@MGID                           Open error
     C   92              MOVE      'ACO0003'     P@MGID                           Close error
     C   93              MOVE      'ACO0004'     P@MGID                           Empty file
     C   94              MOVE      'ACO0005'     P@MGID                           End of file
     C   95              MOVE      'ACO0006'     P@MGID                           No record found
     C   96              MOVE      'ACO0007'     P@MGID                           Option error
     C   97              MOVE      'ACO0009'     P@MGID                           No selection S0131
     C   98              MOVE      'ACO0010'     P@MGID                           Call error   S0131
     C                   CALL      'ZASNMG'                             99        <SEND MESSAGE>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Program name
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Message ID
     C                   PARM      *BLANK        P@MSGF           10              I:Message file
     C                   PARM      *BLANK        P@MGKY            4              O:Message key
     C*********************PARM *BLANK    P@MGDA 50          I:Message datS01230
     C                   PARM                    P@MGDA           50              I:Message datS0123
     C                   PARM      '*DIAG'       P@MGTP            7              I:Message type
     C                   END                                                    FI 9
     C                   CLOSE     SDOREFL1                                                    S0131
      *                                                                   S01230
      * Caller Requests DB Error Handling                                 S01230
      *                                                                   S01230
     C     W@RTCD        IFEQ      '*DBERR'                                     IF             S0123
     C     P@RTCD        ANDNE     *BLANK                                         AND          S0123
     C                   DUMP                                                                  S0123
     C                   CALL      'DBERRCTL'                                                  S0123
     C                   END                                                    FI             S0123
      *                                                                   S01230
     C     P@OPTN        IFNE      '*VERIFY'                                                   S0123
     C     P@OPTN        ANDNE     '*FREE'                                                     S0123
     C     P@RTCD        ANDNE     '*OPTION'                                                   S0123
     C                   MOVEL     D@FMT         P@FMT                                         S0123
     C                   END                                                                   S0123
      *
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
SDMREFPD  AOMREFR0  Mandatory Window
