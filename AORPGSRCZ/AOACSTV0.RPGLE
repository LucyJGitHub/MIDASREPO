     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Check account status')
      *****************************************************************
      *                                                               *
      * This Program Has Been Created With The Ignore Decimal Data    *
      * Error Parameter As *YES Due To a Decimal Data Error In File   *
      * ACCNTL0                                                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Midas   ACCESS OBJECTS                                       *
      *                                                               *
      *  AOACSTV0  -  Check Account Status                            *
      *                                                               *
      *  Function - This program returns a value to the calling       *
      *             program depending on the account status. The      *
      *             possible values returned are:                     *
      *                                                               *
      *             O   OPEN     Open account                         *
      *             C   CLOSED   Closed account                       *
      *             F   FLAGGED  Account flagged for closure today    *
      *             E   ERROR    Invalid account specified,   or      *
      *                          Invalid account status on file       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 154206  *CREATE    Date 21Jul99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  154206 - New program to return details of account status.    *
      *                                                               *
     F*****************************************************************
     F*
     F* ID F  C  H  L     FUNCTION OF INDICATORS
     F*
     F*       01       OPEN FILE
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
     FACCNTL0   IF   E           K DISK    USROPN
     F                                     RENAME(ACCNTABF:@ACCL0)
      * IN  - ACCNTABF Account details (CNUM¦CCY¦ACOD¦ACSQ¦BRCA)
      *...........................................................
     FACCNTL1   IF   E           K DISK    USROPN
     F                                     RENAME(ACCNTABF:@ACCL1)
      * IN  - ACCNTABF Account details (ACNO)
      ************************************************************
      /EJECT
     D*ESTART
      ****************************************************************
     D*
     D* Description     : Copyright notice for inclusion in all ACT programs
     D********************************************************************
      /EJECT
     D*ISTART
      ************************************************************
     D* Description     : Copyright notice for inclusion in all ACT programs
     D*
     D A@CPY           DS
     D* ACT Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              ACT Copyright array
     D*
     D PGMDS          SDS
      * Program Status data structure
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0
      *
     D P@RETL          DS
      * Retail key character->numeric conversion data structure
     D  W@RETL                 1     10  0
      *
     D*P@CNUM****      DS                                                                     CSD027
      **Customer*number*key*character->numeric*conversion*data*structure
     D**W@CNUM**               1      6  0                                                    CSD027
      *
     D P@ACCD          DS
      * Account code key character->numeric conversion data structure
     D***W@ACCD*                1      4  0                                                   CGL029
     D  W@ACCD                 1     10  0                                                    CGL029
      *
     D P@ACSQ          DS
      * Account sequence key character->numeric conversion data structure
     D  W@ACSQ                 1      2  0
      *
     D P@BRCA          DS
      * Branch code key definition
     D  W@BRCA                 1      3
      *
     D P@ACST          DS
      * Account Status parameter for return to calling pgm
     D  W@ACST                 1      1
      *
     D P@MGDA          DS
     D  @MG                    1     50
     D                                     DIM(1) CTDATA PERRCD(1)
      *
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    P@RETL           10            I:Retail key
     C                   PARM                    P@CNUM            6            I:Key field 1
     C                   PARM                    P@CUCD            3            I:Key field 2
     C**********         PARM                    P@ACCD            4            I:Key field 3 CGL029
     C                   PARM                    P@ACCD           10                          CGL029
     C                   PARM                    P@ACSQ            2            I:Key field 4
     C                   PARM                    P@BRCA            3            I:Key field 5  S0111
     C                   PARM                    P@ACST                         O:OUTPUT
      *****************************************************
      *MAIN
     C     K@L0          KLIST
     C***********        KFLD                    W@CNUM                                       CSD027
     C                   KFLD                    P@CNUM                                       CSD027
     C                   KFLD                    P@CUCD
     C                   KFLD                    W@ACCD
     C                   KFLD                    W@ACSQ
     C                   KFLD                    W@BRCA                                        S0111
      *
     C     P@OPTN        IFEQ      '*SAME   '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      T@SKIP
     C                   END
      *
      *MAIN
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       939495     ¦ error
     C                   SETOFF                                       969798     ¦ indicators
     C                   SETOFF                                       50         Key indicators
      *
      * Check key to determine file to use :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF KEYED ACCESS
     C     P@OPTN        OREQ      '*VERIFY'                                    IF KEYED ACCESS
      *                    ¦
     C     P@RETL        IFNE      *BLANK                                       IF RETAIL KEY
     C                   SETON                                        50          Retail ind.
     C                   END                                                    FI
      *                    ¦
     C     P@CNUM        IFNE      *BLANK                                       IF FULL ACCOUNT
     C     P@CUCD        ANDNE     *BLANK                                        AND
     C     P@ACCD        ANDNE     *BLANK                                        AND
     C     P@ACSQ        ANDNE     *BLANK                                        AND
     C     P@BRCA        ANDNE     *BLANK                                        AND           S0111
     C                   SETOFF                                       50          Full a/c ind.
     C                   ELSE                                                   EL
     C     *IN50         CABEQ     '0'           T@SKIP                   97      No keys given
     C                   END                                                    FI
      *                    ¦
     C                   ELSE                                                   EL NOT KEYED
     C                   SETOFF                                       50          Full a/c seq.
     C                   END                                                    FI
      *
      * First call - open files :
      *
     C     *IN50         IFEQ      '0'                                          IF FULL ACCOUNT
     C     *IN01         ANDEQ     '0'                                          AND FIRST TIME
     C                   SETON                                        01          Set ind.
     C                   OPEN      ACCNTL0                              91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   END                                                    FI
      *
     C     *IN50         IFEQ      '1'                                          IF RETAIL
     C     *IN02         ANDEQ     '0'                                          AND FIRST TIME
     C                   SETON                                        02          Set ind.
     C                   OPEN      ACCNTL1                              91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   END                                                    FI
      *
      * Last call - close files and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 6 FREE PROGRAM
     C   01              CLOSE     ACCNTL0                              92        Close file
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C   02              CLOSE     ACCNTL1                              92        Close file
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   SETON                                        LR          Set ind.
     C                   END                                                    FI 6
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 FIRST RECORD
     C     *LOVAL        SETLL     @ACCL0                             9390        Set file
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   END                                                    FI 3
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 NEXT RECORD
     C                   READ      @ACCL0                               9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 4
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 LAST RECORD
     C     *HIVAL        SETGT     @ACCL0                               90        Set file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   END                                                    FI 5
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 PREV.RECORD
     C                   READP     @ACCL0                               9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 6
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 KEYED ACCESS
     C     P@OPTN        OREQ      '*VERIFY'                                     OR            S0123
     C  N50K@L0          CHAIN     @ACCL0                             9590        Get record
     C   50W@RETL        CHAIN     @ACCL1                             9590        Get record
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
     C/COPY WNCPYSRC,AOACCTR0C1
     C                   CALLB     'ZASNMG'                                       <SEND MESSAGE>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Program name
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Message ID
     C                   PARM      *BLANK        P@MSGF           10              I:Message file
     C                   PARM      *BLANK        P@MGKY            4              O:Message key
     C                   PARM                    P@MGDA           50              I:Message data
     C                   PARM      '*DIAG'       P@MGTP            7              I:Message type
     C/COPY WNCPYSRC,AOACCTR0C2
     C                   END                                                    FI 9
      * Caller Requests DB Error Handling
      *
     C     W@RTCD        IFEQ      'DBERR'
     C     P@RTCD        ANDNE     *BLANK
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   END
      *
      *  Return account status
      *
     C     P@OPTN        IFNE      '*VERIFY'
     C     P@OPTN        ANDNE     '*FREE  '                                                   S0116
     C     P@RTCD        ANDNE     '*OPTION'
      *
      *  Determine account status. Possible options are:
      *  O    Open      Valid open account
      *  C    Closed    Valid closed account
      *  F    Flagged   Valid open flagged for closure today
      *  E    Error     Account status invalid/error
      *
 if1 C     RECI          IFNE      'D'
     C     RECI          ANDNE     'C'
     C     ACST          ORNE      ' '
     C     ACST          ANDNE     'C'
     C                   MOVE      'E'           P@ACST                         Error
 x1  C                   ELSE
if2  C     ACST          IFEQ      'C'
if3  C     RECI          IFEQ      'D'
     C                   MOVE      'F'           P@ACST                         Flagged for closure
x3   C                   ELSE
     C                   MOVE      'C'           P@ACST                         Closed account
fi3  C                   END
 x2  C                   ELSE
if3  C     RECI          IFEQ      'D'
     C                   MOVE      'O'           P@ACST                         Valid open account
x3   C                   ELSE
     C                   MOVE      'E'           P@ACST                         Error
fi3  C                   END
fi2  C                   END
fi1  C                   END
      *
fi1  C                   END
      *
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
ACCNTAB   AOACCTR0  GENERAL LEDGER ACCOUNT DETAILS
**CTDATA CPY@
(c) Finastra International Limited 2001
