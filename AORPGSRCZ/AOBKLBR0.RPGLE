     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Backup Schemas/Libraries File')               *
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  AOBKLBR0 - Read Access to Backup/Schemas Libraries File      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CBF002  *CREATE    Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CBF002 - BF Infrastructure: Backup and Recovery              *
      *                                                               *
      *****************************************************************
      *
      * ID F  C  H  L     FUNCTION OF INDICATORS
      *
      *       01       OPEN FILE
      *       90       FILE ERROR
      *       91       OPEN ERROR
      *       92       CLOSE ERROR
      *       93       EMPTY FILE
      *       94       END OF FILE
      *       95       NO RECORD FOUND
      *       96       OPTION ERROR
      *       97       NO SELECTION
      *       99       SEND MESSAGE ERROR
      *
      *****************************************************************
     F/EJECT
      *FSTART
      *****************************************************************
     FSCBKLBL0  IF   E           K DISK    USROPN
      * IN  - ACCNTABF Account details (IBAN)
      *****************************************************************
      /EJECT
      *ESTART
      *****************************************************************
      *
      * Description: Copyright notice for inclusion in all programs
      *
      *****************************************************************
      /EJECT
      *ISTART
      *****************************************************************
      *
      * Description: Copyright notice for inclusion in all programs
      *
      *****************************************************************
      *
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
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
     D D@FMT         E DS                  EXTNAME(SCBKLBPD)
      * ACCNTABF - Account details record format data structure
      *
     D P@MGDA          DS
     D  @MG                    1     50
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     D P@FMT         E DS                  EXTNAME(DSFDY)
      *
      * EXTERNAL DATA STRUCTURE TO HOLD THE OUTGOING RECORD FORMAT OF
      * THE FILE
      *****************************************************************
      /EJECT
      *CSTART
      *****************************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM      D@FMT         P@FMT                          O:OUTPUT
      *****************************************************************
      *
     C     P@OPTN        IFEQ      '*SAME   '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      T@SKIP
     C                   END
      *
      ** MAIN PROCESSING
      *
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       939495     ¦ error
     C                   SETOFF                                       9697       ¦ indicators
      *
      ** Check key to determine file to use
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF KEYED ACCESS
     C     P@OPTN        OREQ      '*VERIFY'                                    IF KEYED ACCESS
      *                    ¦
     C                   SETON                                        97
     C                   GOTO      T@SKIP                                         No keys given
     C                   END                                                    FI
      *
      ** First call - open files
      *
     C     *IN01         IFEQ      '0'                                          IF  FIRST TIME
     C                   SETON                                        01          Set ind.
     C                   OPEN      SCBKLBL0                             91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   END                                                    FI
      *
      ** Last call - close files and terminate program
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 6 FREE PROGRAM
     C   01              CLOSE     SCBKLBL0                             92        Close file
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   SETON                                        LR          Set ind.
     C                   END                                                    FI 6
      *
      ** Caller requests first record
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 FIRST RECORD
     C     *LOVAL        SETLL     SCBKLBF                            9390        Set file
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   END                                                    FI 3
      *
      ** Caller requests next record
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 NEXT RECORD
     C                   READ      SCBKLBF                              9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 4
      *
      ** Caller requests last record
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 LAST RECORD
     C     *HIVAL        SETGT     SCBKLBF                              90        Set file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   END                                                    FI 5
      *
      ** Caller requests previous record
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 PREV.RECORD
     C                   READP     SCBKLBF                              9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 6
      *
     C     P@OPTN        IFNE      '*KEY   '                                    IF 8 NOT KEYED
     C     P@OPTN        ANDNE     '*NEXT  '                                     AND NOT SEQ.
     C     P@OPTN        ANDNE     '*PREV  '                                     AND
     C     P@OPTN        ANDNE     '*VERIFY'                                     AND
     C     P@OPTN        ANDNE     '*FREE  '                                     AND
     C                   SETON                                          96        Parameter error
     C                   END                                                    FI 8
      *
      ** No record found or End of file - return error code :
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
      ** Caller requests message sent to program queue
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
     C                   CALLB     'ZASNMG'                                       <SEND MESSAGE>
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
      ** Caller Requests DB Error Handling
      *
     C     W@RTCD        IFEQ      'DBERR'
     C     P@RTCD        ANDNE     *BLANK
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   END
      *
      *
      *
     C     P@OPTN        IFNE      '*VERIFY'
     C     P@OPTN        ANDNE     '*FREE  '
     C     P@RTCD        ANDNE     '*OPTION'
     C                   MOVEL     D@FMT         P@FMT
     C                   END
      *
      ** Return to caller
      *
     C                   RETURN
      *
      *****************************************************************
**CTDATA @MG
SCBKLBPD  AOBKLBR0  Backup/Schemas Libraries
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2011
