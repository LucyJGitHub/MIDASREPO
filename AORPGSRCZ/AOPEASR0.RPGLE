     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas AO PEA System Status access object')             *
      *****************************************************************
      *                                                               *
      *  Midas Access Object                                          *
      *                                                               *
      *  AOPEASR0  - Access Object for PEA System Status              *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSC054  *CREATE    Date 23Feb12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC054 - Period End Adjustments                              *
      *                                                               *
      *---------------------------------------------------------------*
 
      *****************************************************************
      * ID F  C  H  L  FUNCTION OF INDICATORS
      *
      *       01       OFF ON THE FIRST RUN
      *       90       FILE ERROR
      *       91       OPEN ERROR
      *       92       CLOSE ERROR
      *       93       EMPTY FILE
      *       96       OPTION ERROR
      *****************************************************************
 
      /EJECT
 
      ** Midas SC PEA System Status
     FSCPEASL1  IF   E           K DISK    USROPN
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D P@MGDA          DS
     D  @MG                    1     50
     D                                     DIM(1) CTDATA PERRCD(1)
     D PGMDS          SDS
      ** Program Status data structure
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0
 
     D D@FMT         E DS                  EXTNAME(SCPEASPD)
      ** PEA System Status
      *
     D P@FMT         E DS                  EXTNAME(DSFDY)
      ** External Data structure to hold the outgoing record format of
      ** the file.
 
      ** Entry Parameters
     D  P@Rtcd         S              7A
     D  P@Optn         S              7A
     D  P@CnCd         S              2A
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     *ENTRY        PLIST
     C     W@Rtcd        PARM                    P@Rtcd
     C                   PARM                    P@Optn
     C                   PARM      D@FMT         P@FMT
 
     C                   EVAL      *IN90 = *OFF
     C                   EVAL      *IN91 = *OFF
     C                   EVAL      *IN92 = *OFF
     C                   EVAL      *IN93 = *OFF
     C                   EVAL      *IN96 = *OFF
     C     P@OPTN        IFEQ      '*KEY   '
     C     P@OPTN        OREQ      '*FIRST '
     C     P@OPTN        OREQ      '*LAST  '
     C     P@OPTN        OREQ      '*NEXT  '
     C     P@OPTN        OREQ      '*PREV  '
     C     P@OPTN        OREQ      '*SAME  '
     C     P@OPTN        OREQ      '*VERIFY'
     C     *IN01         IFEQ      '0'
     C                   SETON                                        01
     C                   OPEN      SCPEASL1                             91
     C     *IN91         CABEQ     '1'           T@SKIP                   LR
     C     *LOVAL        SETLL     SCPEASD0                           9390
     C  N93              READ      SCPEASD0                               93
     C                   CLOSE     SCPEASL1                             92
     C     *IN93         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C     *IN92         CABEQ     '1'           T@SKIP                   LR
     C                   ENDIF
     C                   ELSE
      *
     C     P@OPTN        IFEQ      '*FREE  '
     C                   SETON                                        LR
     C                   RETURN
     C                   ELSE
      *
     C                   SETON                                        96
     C                   ENDIF
     C                   ENDIF
      *
      ** No record found or End of file - return error code :
      *
     C     T@SKIP        TAG
      *
     C                   MOVE      *BLANK        P@RTCD
     C   90              MOVE      '*ERROR '     P@RTCD
     C   91              MOVE      '*OPEN  '     P@RTCD
     C   92              MOVE      '*CLOSE '     P@RTCD
     C   93              MOVE      '*EMPTY '     P@RTCD
     C   96              MOVE      '*OPTION'     P@RTCD
      *
      ** Caller requests message sent to program queue :
      *
     C     W@RTCD        IFEQ      '*MSG   '
     C     P@RTCD        ANDNE     *BLANK
     C   90              MOVE      'ACO1001'     P@MGID
     C   91              MOVE      'ACO1002'     P@MGID
     C   92              MOVE      'ACO1003'     P@MGID
     C   93              MOVE      'ACO1004'     P@MGID
     C   96              MOVE      'ACO1007'     P@MGID
     C                   CALL      'ZASNMG'
     C                   PARM      *BLANK        W@RTCD            7
     C                   PARM      PGNAME        P@PGNM           10
     C                   PARM      '*PRV'        P@DEST            5
     C                   PARM                    P@MGID            7
     C                   PARM      *BLANK        P@MSGF           10
     C                   PARM      *BLANK        P@MGKY            4
     C                   PARM                    P@MGDA           50
     C                   PARM      '*DIAG'       P@MGTP            7
     C                   ENDIF
      *
      ** Caller requests DB handling
      *
     C     W@RTCD        IFEQ      '*DBERR'
     C     P@RTCD        ANDNE     *BLANK
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
      *
      ** Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
SCPEASPD  AOPEASR0  PEA System Details
