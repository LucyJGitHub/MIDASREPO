     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Correspondence Manager ICD access object')
      *****************************************************************
      *                                                               *
      *  Midas  ACCESS OBJECTS                                        *
      *                                                               *
      *     AOCORMR0 - CORRESPONDENCE MANAGER                         *
      *                I.C.D ACCESS OBJECT                            *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CCG015  *CREATE    Date 21Mar02               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CCG015 - Correspondence Manager                              *
      *                                                               *
      *****************************************************************
      * ID F  C  H  L  FUNCTION OF INDICATORS                         *
      *                                                               *
      *       01       OFF ON THE FIRST RUN                           *
      *       90       FILE ERROR                                     *
      *       91       OPEN ERROR                                     *
      *       92       CLOSE ERROR                                    *
      *       93       EMPTY FILE                                     *
      *       96       OPTION ERROR                                   *
      *****************************************************************
      /EJECT
      *
      ** Correspondence Manager file detail
     FSDCORMPD  IF   E           K DISK    USROPN
     D P@MGDA          DS
     D  @MG                    1     50
     D                                     DIM(1) CTDATA PERRCD(1)
      *
      ** Program Status data structure
     D PGMDS          SDS
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0
      *
      ** Parameter data structures
     D D@FMT         E DS                  EXTNAME(SDCORMPD)
     D P@FMT         E DS                  EXTNAME(DSLDY)
      *
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7
     C                   PARM                    P@OPTN            7
     C                   PARM      D@FMT         P@FMT
      *
      ** Main
     C                   SETOFF                                       909192
     C                   SETOFF                                       9396
     C     P@OPTN        IFEQ      '*FIRST '
     C     *IN01         IFEQ      '0'
     C                   SETON                                        01
     C                   OPEN      SDCORMPD                             91
     C     *IN91         CABEQ     '1'           T@SKIP                   LR
     C  N93              READ      SDCORMPD                               93
     C                   CLOSE     SDCORMPD                             92
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
**CTDATA @MG
SDCORMPD  AOCORMR0  Correspondence Manager
