     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Save Options Configuration File')             *
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  AOSVOPTR0 - Read Access to Save Options Configuration File   *
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
     FSCSVOPTPD IF   E           K DISK    USROPN
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
     D D@FMT         E DS                  EXTNAME(SCSVOPTPD)
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
     C                   PARM      D@FMT         P@FMT                          O:OUTPUT
      *****************************************************************
      *
      ** MAIN PROCESSING
      *
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       94         ¦ error ind
      *
     C                   OPEN      SCSVOPTPD                            91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   READ      SCSVOPTF                             9094      Read File
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   CLOSE     SCSVOPTPD                            92        Close file
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
      *
      ** No record found or End of file - return error code
      *          _____________
     C     T@SKIP        TAG                                                    +++ SKIP +++
      *          ~~~~~~~~~~~~~
     C                   MOVE      *BLANK        P@RTCD                         No Errors
     C   90              MOVE      '*ERROR '     P@RTCD                         File error
     C   91              MOVE      '*OPEN  '     P@RTCD                         Open error
     C   92              MOVE      '*CLOSE '     P@RTCD                         Close error
     C   94              MOVE      '*EOF   '     P@RTCD                         End of file
      *
      ** Caller requests message sent to program queue
      *
     C     W@RTCD        IFEQ      '*MSG   '                                    IF 9 SEND MESSAGE
     C     P@RTCD        ANDNE     *BLANK                                        AND ERROR
     C   90              MOVE      'ACO1001'     P@MGID                           File error
     C   91              MOVE      'ACO1002'     P@MGID                           Open error
     C   92              MOVE      'ACO1003'     P@MGID                           Close error
     C   94              MOVE      'ACO1005'     P@MGID                           End of file
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
      ** Return to caller
      *
     C                   RETURN
      *
      *****************************************************************
**CTDATA @MG
SCSVOPTPD AOSVOPTR0 Backup/Schemas Libraries
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2011
