     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Dealing ICD access object (DSSDY)')
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects Module                                *
      *                                                               *
      *  AODEALR1 - Read Access to Dealing Data Codes File (DSSDY)    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGL029  *CREATE    Date 01Sep03               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L     FUNCTION OF INDICATORS                      *
      *                                                               *
      *       01       Open File - SDDEALL1                           *
      *       90       File Error                                     *
      *       91       Open Error                                     *
      *       92       Close Error                                    *
      *       93       Empty File                                     *
      *       96       Option Error                                   *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
     FSDDEALL1  IF   E           K DISK    USROPN
      * IN - @BNREEI Dealing Data Cde(DLDA)
      *****************************************************************
      /EJECT
      *****************************************************************
     D A@CPY           DS
      ** Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     D P@MGDA          DS
     D  @MG                    1     50
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     D PGMDS          SDS
      ** Program Status data structure
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0
      *
     D D@FMT         E DS                  EXTNAME(SDDEALPD)
      ** @BNREEI - Dealing Data Record Format Data Structure
      *
     D P@FMT         E DS                  EXTNAME(DSSDY)
      ** External Data structure to hold the outgoing record format
      ** of the file.
      *****************************************************************
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7
     C                   PARM                    P@OPTN            7
     C                   PARM      D@FMT         P@FMT
      *
     C                   SETOFF                                       909192
     C                   SETOFF                                       9396
      *
      ** Subsequent calls will return the format
      *
     C     P@OPTN        IFEQ      '*FIRST  '
     C     P@OPTN        OREQ      '*NEXT   '
     C     P@OPTN        OREQ      '*PREV   '
     C     P@OPTN        OREQ      '*LAST   '
     C     P@OPTN        OREQ      '*KEY    '
     C     P@OPTN        OREQ      '*FREE   '
     C     P@OPTN        OREQ      '*SAME   '
     C     P@OPTN        OREQ      '*VERIFY '
      *
     C     *IN01         IFEQ      '0'
     C                   SETON                                        01
     C                   OPEN      SDDEALL1                             91
     C     *IN91         CABEQ     '1'           T@SKIP                   LR
     C                   READ      @BNREEI                              9093
     C                   CLOSE     SDDEALL1                             92
     C     *IN92         CABEQ     '1'           T@SKIP                   LR
     C     *IN93         CABEQ     '1'           T@SKIP                   LR
     C                   SETON                                        LR
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   SETON                                        96
      *
     C                   ENDIF
      *
      ** No record found or End of file - return error code :
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
      ** Caller requests message sent to program queue :
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
     C                   ENDIF
      *
      ** Caller Requests DB Error Handling
      *
     C     W@RTCD        IFEQ      '*DBERR '
     C     P@RTCD        ANDNE     *BLANK
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
      *
      ** Return to caller :
      *
     C                   RETURN
      *****************************************************************
**CTDATA @MG
SDDEALPD  AODEALR0  Dealing Data Codes
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2003
