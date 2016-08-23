     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Market data feeds access object')
      *****************************************************************
      *                                                               *
      *     Midas - Midas Access Objects                              *
      *                                                               *
      *     AOMDFCR0 - Market Data Feeds Access Object                *
      *                                                               *
      *  Function:  This module is called by various programs         *
      *             to access Market Data Feeds ICD details           *
      *                                                               *
      *  Component of: AOMDFCR0                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Last Amend No. CSD006  *CREATE    Date 06Sep00               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CSD006 - Market Data Feeds                                   *
      *                                                               *
      *****************************************************************
      /EJECT
      /SPACE 3
      ***************** FOR EACH DATABASE ERROR *************************
      *
     FSDMDFCL0  IF   E           K DISK    USROPN
      *
      *****************************************************************
      *
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
     D D@FMT         E DS                  EXTNAME(SDMDFCPD)
      * SDMDFCD0 - Market Data Feeds record format data structure
      *
     D P@FMT         E DS                  EXTNAME(DSSDY)
      * External Data structure to hold the outgoing record format
      * of the file.
      *
      * Description     : Copyright notice for inclusion in all programs
      *
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      ************************************************************
      /EJECT
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7
     C                   PARM                    P@OPTN            7
     C                   PARM      D@FMT         P@FMT
      *****************************************************
      *MAIN
     C                   SETOFF                                       909192
     C                   SETOFF                                       9396
     C     P@OPTN        IFEQ      '*KEY   '
     C     P@OPTN        OREQ      '*FIRST '
     C     P@OPTN        OREQ      '*LAST  '
     C     P@OPTN        OREQ      '*NEXT  '
     C     P@OPTN        OREQ      '*PREV  '
     C     P@OPTN        OREQ      '*SAME  '
     C     P@OPTN        OREQ      '*VERIFY'
     C     *IN01         IFEQ      '0'                                            IF2 1'st time
     C                   SETON                                        01
     C                   OPEN      SDMDFCL0                             91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C     *LOVAL        SETLL     SDMDFCD0                           9390        Set file
     C  N93              READ      SDMDFCD0                               93
     C                   CLOSE     SDMDFCL0                             92        Close file
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   END                                                      FI2
     C                   ELSE
      *
     C     P@OPTN        IFEQ      '*FREE  '
     C                   SETON                                        LR
     C                   RETURN
     C                   ELSE
      *
     C                   SETON                                        96          Parm error
     C                   END
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
     C                   CALLB     'ZASNMG'                                       <SND MSG>
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
      *      CALLER REQUESTS DB HANDLING
      *
     C     W@RTCD        IFEQ      '*DBERR'                                     IF DB ERROR
     C     P@RTCD        ANDNE     *BLANK                                       AND
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   END                                                    FI
      *
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
**CTDATA @MG
SDMDFCPD  AOMDFCR0  Market Data Feed Details
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2001
