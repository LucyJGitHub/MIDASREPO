     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas AO Loan types/sub-types')                        *
     F*****************************************************************
     F*                                                               *
     F*     Midas  ACCESS OBJECTS                                     *
     F*                                                               *
     F*     AOLOANR1 - READ ACCESS TO LOAN TYPES/SUB-TYPES FILE       *
     F*                                                               *
      *  (c) Finastra International Limited 2013                      *
     F*                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE164             Date 18Aug14               *
      *                 MD019830A *CREATE  Date 15Apr13               *
     F*                                                               *
     F*****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *           (Recompile)                                         *
      *  MD019830A - Unable to amend authorised Loan (Reopened)       *
      *                                                               *
     F*****************************************************************
     F*                                                               *
     F* ID F  C  H  L     FUNCTION OF INDICATORS
     F*
     F*       01       OPEN FILE - SDLOANL1
     F*       50       CHECK FOR 1ST KEY CONTAINING A ?  LEN: 2 CHARS
     F*       51       CHECK FOR 2ND KEY CONTAINING A ?  LEN: 2 CHAR
     F*       52       CHECK FOR 3RD KEY CONTAINING A ?  LEN: 4 CHAR
     F*       90       FILE ERROR
     F*       91       OPEN ERROR
     F*       92       CLOSE ERROR
     F*       93       EMPTY FILE
     F*       94       END OF FILE
     F*       95       NO RECORD FOUND
     F*       96       OPTION ERROR
     F*       97       NO SELECTION
     F*       98       CALL ERROR
     F*
     F********************************************************************
      /EJECT
     F*FSTART
      ************************************************************
     FSDLOANL1  IF   E           K DISK    USROPN
      * IN  - @AYRECL Loan Types/Sub-Types (LNTY LNST)
      ************************************************************
      /EJECT
     D*ESTART
      ************************************************************
      /EJECT
     D*ISTART
      ************************************************************
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
     D D@FMT         E DS                  EXTNAME(SDLOANPD)
      * @AYRECL - LOAN TYPES/SUB-TYPES RECORD FORMAT DATA STRUCTURE
      *
     D P@FMT         E DS                  EXTNAME(DSSDY)
     D* EXTERNAL DATA STRUCTURE TO HOLD THE OUTGOING RECORD FORMAT
     D* OF THE FILE.
      *
     D P@LNTY          DS
     D  W@SL01                 1      1
     D  W@SL02                 2      2
     D P@LNST          DS
     D  W@SL03                 1      1
     D  W@SL04                 2      2
     D P@LNCL          DS
     D  W@SL05                 1      1
     D  W@SL06                 2      2
     D  W@SL07                 3      3
     D  W@SL08                 4      4
      *
      ************************************************************
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    P@LNTY                         I:Loan type
     C                   PARM                    P@LNST                         I:Loan sub-type
     C                   PARM                    P@LNCL                         I:Loan class
     C                   PARM                    P@FMT                          O:Format
      *****************************************************
      *MAIN
     C     P@OPTN        IFEQ      '*SAME  '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      T@SKIP
     C                   END
      *
     C                   SETOFF                                       52
     C                   SETOFF                                       5051       ¦
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       939495     ¦ error
     C                   SETOFF                                       969798     ¦ indicators
      *
      * DEFINE KEY LIST
      *
     C     K@KEY         KLIST
     C                   KFLD                    P@LNTY
     C                   KFLD                    P@LNST
     C                   KFLD                    P@LNCL
      *
      ** Check if Enhanced Centralised Static Data is installed
      *
      *
      * First call - open file :
      *
     C     *IN01         IFEQ      '0'                                          IF 1 FIRST TIME
     C                   SETON                                        01          Set ind.
     C                   OPEN      SDLOANL1                             91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   END                                                    FI 1
      *
      * Last call - close file and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 2 FREE PROG
     C                   CLOSE     SDLOANL1                             92        Close file
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   SETON                                        LR          Set ind.
     C                   END                                                    FI 2
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 FIRST REC
     C     *LOVAL        SETLL     @AYRECL                            9390        Set file
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   END                                                    FI 3
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 NEXT REC
     C                   READ      @AYRECL                              9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 4
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 LAST REC
     C     *HIVAL        SETGT     @AYRECL                              90        Set file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   END                                                    FI 5
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 PREV.REC
     C                   READP     @AYRECL                              9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 6
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 KEY ACC
     C     P@OPTN        OREQ      '*VERIFY'                                     OR
     C     W@SL01        IFEQ      '?'                                          IF 8 CHK KEY 1
     C     W@SL02        OREQ      '?'                                           OR
     C                   SETON                                        50        KEY 1 = ?
     C                   MOVE      *BLANK        K@KEY1            2            INIT KEY NO.1
     C                   ELSE                                                   OTHERWISE
     C                   MOVE      P@LNTY        K@KEY1                         SET TO INPUT
     C                   END                                                    FI 8
     C     W@SL03        IFEQ      '?'                                          IF 9 SELECT
     C     W@SL04        OREQ      '?'                                          OR
     C                   SETON                                        51        KEY 2 = ?
     C                   MOVE      *BLANK        K@KEY2            2            INIT KEY NO.2
     C                   ELSE                                                   OTHERWISE
     C                   MOVE      P@LNST        K@KEY2                         SET TO INPUT
     C                   END                                                    FI 9
     C     W@SL05        IFEQ      '?'                                          IF 9 SELECT
     C     W@SL06        OREQ      '?'                                          OR
     C     W@SL07        OREQ      '?'                                          OR
     C     W@SL08        OREQ      '?'                                          OR
     C                   SETON                                        52        KEY 3 = ?
     C                   MOVE      *BLANK        K@KEY3            4            INIT KEY NO.3
     C                   ELSE                                                   OTHERWISE
     C                   MOVE      P@LNCL        K@KEY3                         SET TO INPUT
     C                   END                                                    FI 9
     C     *IN50         IFEQ      '1'                                          IF 10
     C     *IN51         OREQ      '1'                                          OR
     C     *IN52         OREQ      '1'                                          OR
     C                   CALL      'SD0280S'                            98        <SELECT>
     C                   PARM      *BLANK        P@RTC2            7              B:Return code
     C                   PARM      K@KEY1        P@LNTY                           B:Key NO 1
     C                   PARM      K@KEY2        P@LNST                           B:Key NO 2
     C                   PARM      K@KEY3        P@LNCL                           B:Key NO 3
     C     P@RTC2        COMP      *BLANK                             97          No selection
     C     *IN97         CABEQ     '1'           T@SKIP                           No selection
     C     *IN98         CABEQ     '1'           T@SKIP                           Program error
     C                   END                                                    FI 10
     C     K@KEY         CHAIN     @AYRECL                            9590        Get record
     C     *IN95         CABEQ     '1'           T@SKIP                           No rec found
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 7
      *
     C     P@OPTN        IFNE      '*KEY   '                                    IF 11 NOT KEYED
     C     P@OPTN        ANDNE     '*NEXT  '                                     AND NOT SEQ.
     C     P@OPTN        ANDNE     '*PREV  '                                     AND
     C     P@OPTN        ANDNE     '*VERIFY'                                     AND
     C     P@OPTN        ANDNE     '*FREE  '                                     AND
     C                   SETON                                          96        Parameter err
     C                   END                                                    FI 11
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
     C   95              MOVE      '*NRF   '     P@RTCD                         No rec found
     C   96              MOVE      '*OPTION'     P@RTCD                         Option error
     C   97              MOVE      '*NOSEL '     P@RTCD                         No selection
     C   98              MOVE      '*CALL  '     P@RTCD                         Called Pgm.err.
      *
      * Caller requests message sent to program queue :
      *
     C     W@RTCD        IFEQ      '*MSG   '                                    IF 12 SEND MSG
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
     C                   CALL      'ZASNMG'                                       <SEND MSG>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Prog name
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Msg ID
     C                   PARM      *BLANK        P@MSGF           10              I:Msg file
     C                   PARM      *BLANK        P@MGKY            4              O:Msg key
     C                   PARM                    P@MGDA           50              I:Msg data
     C                   PARM      '*DIAG'       P@MGTP            7              I:Msg type
     C                   END                                                    FI 12
      *
      * Caller requests DB error handling :
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
SDLOANPD  AOLOANR1  Loan Types / Sub-Types
**CTDATA CPY@
(c) Finastra International Limited 2013
