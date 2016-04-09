     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Update Backup Schemas/Libraries File-RSTR')   *
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  AOBKLBR2 - Update Backup Schemas/Libraries File - Restore    *
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
     FSCBKLBL1  UF   E           K DISK    USROPN
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
     D P@MGDA          DS
     D  @MG                    1     50
     D                                     DIM(1) CTDATA PERRCD(1)
      *****************************************************************
      /EJECT
      *CSTART
      *****************************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return Code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    P@RDAT            5 0          I:System Date
     C                   PARM                    P@LKEY           10            I:Library Name
      *****************************************************************
      *
      * MAIN PROCESSING
      *
     C     K@L1          KLIST
     C                   KFLD                    P@LKEY
      *
     C     '*FIRST '     IFEQ      P@OPTN
     C                   OPEN      SCBKLBL1                             91
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C     K@L1          CHAIN     SCBKLBF                            9590        Get record
     C     *IN95         CABEQ     '1'           T@SKIP                           No record found
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      ' '           SLRSTT
     C
     C                   UPDATE    SCBKLBF
     C                   CLOSE     SCBKLBL1                             92
     C                   ENDIF
      *
     C     '*LAST  '     IFEQ      P@OPTN
     C                   OPEN      SCBKLBL1                             91
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C     K@L1          CHAIN     SCBKLBF                            9590        Get record
     C     *IN95         CABEQ     '1'           T@SKIP                           No record found
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      'F'           SLRSTT
     C
     C                   UPDATE    SCBKLBF
     C                   CLOSE     SCBKLBL1                             92
     C                   ENDIF
      *
     C     '*FIRST '     IFNE      P@OPTN
     C     '*LAST  '     ANDNE     P@OPTN
     C                   SETON                                          96      Option error
     C                   ENDIF
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
      *          _____________
     C     T@SKIP        TAG                                                    +++ SKIP +++
      *          ~~~~~~~~~~~~~
     C                   MOVE      *BLANK        P@RTCD                         No Errors
     C   90              MOVE      '*ERROR '     P@RTCD                         File error
     C   91              MOVE      '*OPEN  '     P@RTCD                         Open error
     C   92              MOVE      '*CLOSE '     P@RTCD                         Close error
     C   95              MOVE      '*NRF   '     P@RTCD                         No record found
     C   96              MOVE      '*OPTION'     P@RTCD                         Option error
      *
      * Caller requests message sent to program queue
      *
     C     W@RTCD        IFEQ      '*MSG   '                                    IF 9 SEND MESSAGE
     C     P@RTCD        ANDNE     *BLANK                                        AND ERROR
     C   90              MOVE      'ACO1001'     P@MGID                           File error
     C   91              MOVE      'ACO1002'     P@MGID                           Open error
     C   92              MOVE      'ACO1003'     P@MGID                           Close error
     C   95              MOVE      'ACO1006'     P@MGID                           No record found
     C   96              MOVE      'ACO1007'     P@MGID                           Option error
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
      * Caller Requests DB Error Handling
      *
     C     W@RTCD        IFEQ      'DBERR'
     C     P@RTCD        ANDNE     *BLANK
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   END
      *
      * Return to caller
      *
     C                   RETURN
      *
      *****************************************************************
**CTDATA @MG
SCBKLBPD  AOBKLBR2  Backup Schemas/Libraries
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2011
