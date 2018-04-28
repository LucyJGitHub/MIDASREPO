     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP AO Zones')
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  GPAOZONER0 - Read access to global zones file                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2007            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 249175  *CREATE    Date 26Jul07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  249175 - Check zone entered is defined on GPZONEPD.          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *                                                               *
      *                                                               *
      *    01        *OFF 1st time round                              *
      *    90         File Error                                      *
      *    91         File Open Error                                 *
      *    92         Error on File Close                             *
      *    93         File Empty                                      *
      *    94         Eof                                             *
      *    95         No Record Found                                 *
      *    96         Parameter Error                                 *
      *    97         If no selection                                 *
      *    98         Error on Program Call (GP000181SS)              *
      *    LR         Last Record                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      ************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FGPZONEL1  IF   E           K DISK    USROPN
      *
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     D A@CPY           DS
      ** Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
 
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
 
     D D@FMT         E DS                  EXTNAME(GPZONEPD)
 
     D P@FMT         E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ C-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7
     C                   PARM                    P@OPTN            7
     C                   PARM                    P@ZONE           10
     C                   PARM                    P@FMT
 
      ** Main Processing
      ** Access Option *SAME input
 
     C     P@OPTN        IFEQ      '*SAME  '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      T@SKIP
     C                   END
 
     C                   SETOFF                                       909192
     C                   SETOFF                                       939495
     C                   SETOFF                                       969798
 
      ** First call - open file :
 
     C     *IN01         IFEQ      '0'
     C                   SETON                                        01
     C                   OPEN      GPZONEL1                             91
     C     *IN91         CABEQ     '1'           T@SKIP                   LR
     C                   END
 
      ** Last call - close file and terminate program :
 
     C     P@OPTN        IFEQ      '*FREE  '
     C                   CLOSE     GPZONEL1                             92
     C     *IN92         CABEQ     '1'           T@SKIP                   LR
     C                   SETON                                        LR
     C                   END
 
      ** Caller requests first record :
 
     C     P@OPTN        IFEQ      '*FIRST '
     C     *LOVAL        SETLL     GPZONED0                           9390
     C     *IN93         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   MOVE      '*NEXT  '     P@OPTN
     C                   END
 
      ** Caller requests next record :
 
     C     P@OPTN        IFEQ      '*NEXT  '
     C                   READ      GPZONED0                             9094
     C     *IN94         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   END
 
      ** Caller requests last record :
 
     C     P@OPTN        IFEQ      '*LAST  '
     C     *HIVAL        SETGT     GPZONED0                             90
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   MOVE      '*PREV  '     P@OPTN
     C                   END
 
      ** Caller requests previous record :
 
     C     P@OPTN        IFEQ      '*PREV  '
     C                   READP     GPZONED0                             9094
     C     *IN94         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   END
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 KEY ACCESS
     C     P@OPTN        OREQ      '*VERIFY'                                     OR
     C     P@ZONE        CHAIN     GPZONEL1                           9590        Get record
     C     *IN95         CABEQ     '1'           T@SKIP                           No rec found
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 7
 
     C     P@OPTN        IFNE      '*KEY   '
     C     P@OPTN        ANDNE     '*NEXT  '
     C     P@OPTN        ANDNE     '*PREV  '
     C     P@OPTN        ANDNE     '*VERIFY'
     C     P@OPTN        ANDNE     '*FREE  '
     C                   SETON                                          96
     C                   END
 
      ** No record found or End of file - return error code :
 
     C     T@SKIP        TAG
 
     C                   MOVE      *BLANK        P@RTCD
     C   90              MOVE      '*ERROR '     P@RTCD
     C   91              MOVE      '*OPEN  '     P@RTCD
     C   92              MOVE      '*CLOSE '     P@RTCD
     C   93              MOVE      '*EMPTY '     P@RTCD
     C   94              MOVE      '*EOF   '     P@RTCD
     C   95              MOVE      '*NRF   '     P@RTCD
     C   96              MOVE      '*OPTION'     P@RTCD
     C   97              MOVE      '*NOSEL '     P@RTCD
     C   98              MOVE      '*CALL  '     P@RTCD
 
      ** Caller requests message sent to program queue :
 
     C     W@RTCD        IFEQ      '*MSG   '
     C     P@RTCD        ANDNE     *BLANK
     C   90              MOVE      'ACO1001'     P@MGID
     C   91              MOVE      'ACO1002'     P@MGID
     C   92              MOVE      'ACO1003'     P@MGID
     C   93              MOVE      'ACO1004'     P@MGID
     C   94              MOVE      'ACO1005'     P@MGID
     C   95              MOVE      'ACO1006'     P@MGID
     C   96              MOVE      'ACO1007'     P@MGID
     C   97              MOVE      'ACO1009'     P@MGID
     C   98              MOVE      'ACO1010'     P@MGID
 
     C                   CALL      'ZASNMG'
     C                   PARM      *BLANK        W@RTCD            7
     C                   PARM      PGNAME        P@PGNM           10
     C                   PARM      '*PRV'        P@DEST            5
     C                   PARM                    P@MGID            7
     C                   PARM      *BLANK        P@MSGF           10
     C                   PARM      *BLANK        P@MGKY            4
     C                   PARM                    P@MGDA           50
     C                   PARM      '*DIAG'       P@MGTP            7
     C                   END
 
      ** Caller Requests DB Error Handling
 
     C     W@RTCD        IFEQ      '*DBERR '
     C     P@RTCD        ANDNE     *BLANK
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   END
 
     C     P@OPTN        IFNE      '*VERIFY'
     C     P@OPTN        ANDNE     '*FREE  '
     C     P@RTCD        ANDNE     '*OPTION'
     C                   MOVEL     D@FMT         P@FMT
     C                   END
 
      ** Return to caller :
 
     C                   RETURN
      *****************************************************
**CTDATA @MG
GPZONEPD  GPAOZONER0  Zones
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2007
