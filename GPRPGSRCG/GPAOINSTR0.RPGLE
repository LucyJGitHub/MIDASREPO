     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Access Object to retrieve Global Instrument Codes')
      *****************************************************************
      *                                                               *
      *  Midas - Global Access Objects                                *
      *                                                               *
      *  GPAOINSTR0 - Global Instrument code file                     *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *        D F C H L   FUNCTION INDICATOR                         *
      *                                                               *
      *        01     INITIALISATION                                  *
      *        90     FILE ERROR                                      *
      *        91     FILE OPEN ERROR                                 *
      *        92     FILE CLOSE ERROR                                *
      *        93     FILE EMPTY                                      *
      *        94     END OF FILE                                     *
      *        95     NO RECORD FOUND                                 *
      *        96     OPTION ERROR                                    *
      *        99     ERROR ON CALL ZASNMG                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR     -  Initialisation Subroutine                      *
      *                                                               *
      *  The *INZSR subroutine will only get called automatically     *
      *  on entry to the module the first time it is run              *
      *  (unless you end the program with LR on).  Similarly          *
      *  D-spec initialisation only happens the first time.           *
      *                                                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FGPINSTL0  IF   E           K DISK    USROPN
     ** GPINSTL0 logical built over the global Instrument code file
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
     D D@FMT         E DS                  EXTNAME(GPINSTPD)
      * GPINSTPD - Global Instrument code Detail Record format data structure
      *
     D P@FMT         E DS                  EXTNAME(DSSDY)
      *
      * External Data Structure to hold the outgoing record format of
      * the file
 
     D W@RTCD          S              7
     D P@PGNM          S             10
     D P@DEST          S              5
     D P@MGID          S              7
     D P@MSGF          S             10
     D P@MGKY          S              4
     D P@MGTP          S              7
     D P@RTCD          S              7
     D P@OPTN          S              7
     D P@GINS          S             10
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main processing                                        *
      *                                                               *
      *****************************************************************
 
     C     P@OPTN        IFEQ      '*SAME '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      T@SKIP
     C                   ENDIF
     C                   SETOFF                                       909192
     C                   SETOFF                                       939495
     C                   SETOFF                                       969798
      *
      ** First call - open file
      *
     C     *IN01         IFEQ      '0'
     C                   SETON                                        01
     C                   OPEN      GPINSTL0                             91
     C     *IN91         CABEQ     '1'           T@SKIP                   LR
     C                   ENDIF
      *
      ** Last call - close file and terminate program
      *
     C     P@OPTN        IFEQ      '*FREE  '
     C                   CLOSE     GPINSTL0                             92
     C     *IN92         CABEQ     '1'           T@SKIP                   LR
     C                   SETON                                        LR
     C                   ENDIF
      *
      ** Caller requests first record
      *
     C     P@OPTN        IFEQ      '*FIRST '
     C     *LOVAL        SETLL     GPINSTL0                           9390
     C     *IN93         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   MOVE      '*NEXT  '     P@OPTN
     C                   ENDIF
      *
      ** Caller requests next record
      *
     C     P@OPTN        IFEQ      '*NEXT  '
     C                   READ      GPINSTL0                             9094
     C     *IN94         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   ENDIF
      *
      ** Caller requests last record
      *
     C     P@OPTN        IFEQ      '*LAST  '
     C     *HIVAL        SETGT     GPINSTL0                             90
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   MOVE      '*PREV  '     P@OPTN
     C                   ENDIF
      *
      ** Caller requests previous record
      *
     C     P@OPTN        IFEQ      '*PREV  '
     C                   READP     GPINSTL0                             9094
     C     *IN94         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   ENDIF
      *
      ** Caller requests record indicated by key
      *
     C     P@OPTN        IFEQ      '*KEY   '
     C     P@OPTN        OREQ      '*VERIFY'
     C     P@GINS        CHAIN     GPINSTL0                           9590
     C     *IN95         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   ENDIF
      *
     C     P@OPTN        IFNE      '*KEY   '
     C     P@OPTN        ANDNE     '*NEXT  '
     C     P@OPTN        ANDNE     '*PREV  '
     C     P@OPTN        ANDNE     '*VERIFY'
     C     P@OPTN        ANDNE     '*FREE  '
     C                   SETON                                          96
     C                   ENDIF
      *
      ** No record found or End of file - return error code
      *          _____________
     C     T@SKIP        TAG
      *          ~~~~~~~~~~~~~
     C                   MOVE      *BLANK        P@RTCD
     C   90              MOVE      '*ERROR '     P@RTCD
     C   91              MOVE      '*OPEN  '     P@RTCD
     C   92              MOVE      '*CLOSE '     P@RTCD
     C   93              MOVE      '*EMPTY '     P@RTCD
     C   94              MOVE      '*EOF   '     P@RTCD
     C   95              MOVE      '*NRF   '     P@RTCD
     C   96              MOVE      '*OPTION'     P@RTCD
      *
      ** Caller requests message sent to program queue
      *
     C     W@RTCD        IFEQ      '*MSG   '
     C     P@RTCD        ANDNE     *BLANK
     C   90              MOVE      'ACO1001'     P@MGID
     C   91              MOVE      'ACO1002'     P@MGID
     C   92              MOVE      'ACO1003'     P@MGID
     C   93              MOVE      'ACO1004'     P@MGID
     C   94              MOVE      'ACO1005'     P@MGID
     C   95              MOVE      'ACO1006'     P@MGID
     C   96              MOVE      'ACO1007'     P@MGID
 
     C                   CALL      'ZASNMG'
     C                   PARM      *BLANK        W@RTCD
     C                   PARM      PGNAME        P@PGNM
     C                   PARM      '*PRV'        P@DEST
     C                   PARM                    P@MGID
     C                   PARM      *BLANK        P@MSGF
     C                   PARM      *BLANK        P@MGKY
     C                   PARM                    P@MGDA
     C                   PARM      '*DIAG'       P@MGTP
     C                   ENDIF
      *
      ** Caller requests DB error handling
      *
     C     W@RTCD        IFEQ      'DBERR'
     C     P@RTCD        ANDNE     *BLANK
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
      *
     C     P@OPTN        IFNE      '*VERIFY'
     C     P@OPTN        ANDNE     '*FREE  '
     C     P@RTCD        ANDNE     '*OPTION'
     C                   MOVEL     D@FMT         P@FMT
     C                   ENDIF
      *
      ** Return to caller
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Subroutine                                  *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
     C     W@RTCD        PARM                    P@RTCD
     C                   PARM                    P@OPTN
     C                   PARM                    P@GINS
     C                   PARM                    P@FMT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**CTDATA @MG
GPINSTL0  GPAOINSTR0  Global Instrument code
