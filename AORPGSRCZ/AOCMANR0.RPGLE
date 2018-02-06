     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Cash Management ICD access object')
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  AOCMANR0 - Cash Management ICD                               *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
      *  Use of indicators.                                           *
      *
      *    01         Off on the first run
      *    90         File error
      *    91         Open error
      *    92         Close error
      *    93         Empty file
      *    96         Option error
      *
      /EJECT
      ************************************************************
     FSDCMANL0  IF   E           K DISK    USROPN
      ************************************************************
      /EJECT
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
     D D@FMT         E DS                  EXTNAME(SDCMANPD)
      *
     D P@FMT         E DS                  EXTNAME(DSSDY)
     D* External Data structure to hold the outgoing record format of
     D* the file
      *
      ************************************************************
      /EJECT
      *****************************************************
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
     C     *IN01         IFEQ      '0'
     C                   SETON                                        01
     C                   OPEN      SDCMANL0                             91
     C     *IN91         CABEQ     '1'           T@SKIP                   LR
     C     *LOVAL        SETLL     SDCMAND0                           9390
     C  N93              READ      SDCMAND0                               93
     C                   CLOSE     SDCMANL0                             92
     C     *IN93         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C     *IN92         CABEQ     '1'           T@SKIP                   LR
     C                   END
     C                   ELSE
      *
     C     P@OPTN        IFEQ      '*FREE  '
     C                   SETON                                        LR
     C                   RETURN
     C                   ELSE
      *
     C                   SETON                                        96
     C                   END
     C                   END
      *
      *
      * No record found or End of file - return error code :
      *          _____________
     C     T@SKIP        TAG
      *          ~~~~~~~~~~~~~
     C                   MOVE      *BLANK        P@RTCD
     C   90              MOVE      '*ERROR '     P@RTCD
     C   91              MOVE      '*OPEN  '     P@RTCD
     C   92              MOVE      '*CLOSE '     P@RTCD
     C   93              MOVE      '*EMPTY '     P@RTCD
     C   96              MOVE      '*OPTION'     P@RTCD
      *
      * Caller requests message sent to program queue :
      *
     C     W@RTCD        IFEQ      '*MSG   '
     C     P@RTCD        ANDNE     *BLANK
     C   90              MOVE      'ACO1001'     P@MGID
     C   91              MOVE      'ACO1002'     P@MGID
     C   92              MOVE      'ACO1003'     P@MGID
     C   93              MOVE      'ACO1004'     P@MGID
     C   96              MOVE      'ACO1007'     P@MGID
     C                   CALLB     'ZASNMG'
     C                   PARM      *BLANK        W@RTCD            7
     C                   PARM      PGNAME        P@PGNM           10
     C                   PARM      '*PRV'        P@DEST            5
     C                   PARM                    P@MGID            7
     C                   PARM      *BLANK        P@MSGF           10
     C                   PARM      *BLANK        P@MGKY            4
     C                   PARM                    P@MGDA           50
     C                   PARM      '*DIAG'       P@MGTP            7
     C                   END
      *
      *      CALLER REQUESTS DB HANDLING
      *
     C     W@RTCD        IFEQ      '*DBERR'
     C     P@RTCD        ANDNE     *BLANK
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   END
      *
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
SDCMANPD  AOCMANR0  Cash Management Details
