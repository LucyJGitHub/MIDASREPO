     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas AO Account Pooling ICD Details')                 *
      *****************************************************************
      *                                                               *
      *  Midas - ACCESS OBJECTS                                       *
      *                                                               *
      ***AOPICDR0*-*Midas*AO Account Pooling ICD Details***************         JMI108
      *  XXPICDR0 - Midas AO Account Pooling ICD Details              *         JMI108
      *                                                               *
      ***(c)*Misys*International*Banking*Systems*Ltd.*2007*************         JMI108
      *  (c) Finastra International Limited 2018                      *         JMI108
      *                                                               *
      *  Last Amend No. JMI108             Date 31May18               *
      *  Prev Amend No. TFJ011  *CREATE    Date 23Jan07               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  TFJ011 - Account Balance Pooling. Upgrade to FBM 2.1         *
      *  TFJ011 - Account Pooling                                     *
      *                                                               *
      *****************************************************************
      *
      * ID F  C  H  L  FUNCTION OF INDICATORS
      *
      *       01       OFF ON THE FIRST RUN
      *       90       FILE ERROR
      *       91       OPEN ERROR
      *       92       CLOSE ERROR
      *       93       EMPTY FILE
      *       96       OPTION ERROR
      *
      /EJECT
      *FSTART
      ************************************************************
     F***SDPICDV0  IF   E           K DISK    USROPN                            JMI108
      *** IN - SDPICDD0 Accunt Pooling Details                                  JMI108
     FXXPICDV0  IF   E           K DISK    USROPN                               JMI108
      * IN - XXPICDD0 Accunt Pooling Details                                    JMI108
      *
      /EJECT
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
     D***D@FMT         E DS                  EXTNAME(SDPICDPP)                  JMI108
     D D@FMT         E DS                  EXTNAME(XXPICDPP)                    JMI108
      * Pooling ICD Record Format Data Structure
      *
     D P@FMT         E DS                  EXTNAME(DSSDY)
      * External Data structure to hold the outgoing record format
      * of the file.
      *
      ************************************************************
      /EJECT
      * START
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM      D@FMT         P@FMT                          O:Format       S0111
      *****************************************************
      *MAIN
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       9396       ¦ error
     C     P@OPTN        IFEQ      '*KEY   '
     C     P@OPTN        OREQ      '*FIRST '
     C     P@OPTN        OREQ      '*LAST  '
     C     P@OPTN        OREQ      '*NEXT  '
     C     P@OPTN        OREQ      '*PREV  '
     C     P@OPTN        OREQ      '*FREE  '
     C     P@OPTN        OREQ      '*VERIFY'
     C     P@OPTN        OREQ      '*SAME  '
     C     *IN01         IFEQ      '0'                                            IF2
     C                   SETON                                        01
     C****************** OPEN      SDPICDV0                             91        Open file  JMI108
     C                   OPEN      XXPICDV0                             91        Open file  JMI108
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C******LOVAL        SETLL     SDPICDD0                           9390        Set file   JMI108
     C**N93              READ      SDPICDD0                               93                 JMI108
     C******             CLOSE     SDPICDV0                             92        Close file JMI108
     C     *LOVAL        SETLL     XXPICDD0                           9390        Set file   JMI108
     C  N93              READ      XXPICDD0                               93                 JMI108
     C                   CLOSE     XXPICDV0                             92        Close file JMI108
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   END                                                      FI2
     C                   ELSE
     C                   SETON                                        96          Parm error
     C                   END
      *
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
     C   96              MOVE      '*OPTION'     P@RTCD                         No selection
      *
      * Caller requests message sent to program queue :
      *
     C     W@RTCD        IFEQ      '*MSG   '                                    IF 9 SND MSG
     C     P@RTCD        ANDNE     *BLANK                                        AND ERROR
     C   90              MOVE      'ACO1001'     P@MGID                           File error
     C   91              MOVE      'ACO1002'     P@MGID                           Open error
     C   92              MOVE      'ACO1003'     P@MGID                           Close error
     C   93              MOVE      'ACO1004'     P@MGID                           Empty file
     C   96              MOVE      'ACO1007'     P@MGID
     C                   CALL      'ZASNMG'                                       <SND MSG>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Prog name
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Msg ID
     C                   PARM      *BLANK        P@MSGF           10              I:Msg file
     C                   PARM      *BLANK        P@MGKY            4              O:Msg key
     C                   PARM                    P@MGDA           50              I:Msg data
     C                   PARM      '*DIAG'       P@MGTP            7              I:Msg type
     C                   END                                                    FI 9
      *
      * Caller requests DB error handling :
      *
     C     W@RTCD        IFEQ      '*DBERR '                                    IF 10
     C     P@RTCD        ANDNE     *BLANK                                         AND
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   END                                                    FI 10
      *
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
XXPICDPP  XXPICDR0  Account Pooling ICD Details
