     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP AO Country Codes')                            *
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  GPAOCTRYR0 - Read access to country codes file               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BG12458  *CREATE   Date 07Nov06               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  BG12458 - COB component DLC0607 00001 failed producing a     *
      *            database error in DL0400AU report                  *
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
     FGPCTRYL1  IF   E           K DISK    USROPN
      * IN  - @A4REBR REGION codes    (CNCD)
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
 
     D D@FMT         E DS                  EXTNAME(GPCTRYPD)
      ** GPCTRYD0 - Region code record format data structure
 
     D P@FMT         E DS                  EXTNAME(DSFDY)
      ** External Data structure to hold the outgoing record format
      ** of the file.
      *
     D P@CNCD          DS
      ** Key slicing data structure (for Record Selection)
     D  W@SL01                 1      1
     D  W@SL02                 2      2
 
      ** +--------------------------------------+
      ** ¦ C-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7
     C                   PARM                    P@OPTN            7
     C                   PARM                    P@CNCD            2
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
     C                   OPEN      GPCTRYL1                             91
     C     *IN91         CABEQ     '1'           T@SKIP                   LR
     C                   END
 
      ** Last call - close file and terminate program :
 
     C     P@OPTN        IFEQ      '*FREE  '
     C                   CLOSE     GPCTRYL1                             92
     C     *IN92         CABEQ     '1'           T@SKIP                   LR
     C                   SETON                                        LR
     C                   END
 
      ** Caller requests first record :
 
     C     P@OPTN        IFEQ      '*FIRST '
     C     *LOVAL        SETLL     GPCTRYD0                           9390
     C     *IN93         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   MOVE      '*NEXT  '     P@OPTN
     C                   END
 
      ** Caller requests next record :
 
     C     P@OPTN        IFEQ      '*NEXT  '
     C                   READ      GPCTRYD0                             9094
     C     *IN94         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   END
 
      ** Caller requests last record :
 
     C     P@OPTN        IFEQ      '*LAST  '
     C     *HIVAL        SETGT     GPCTRYD0                             90
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   MOVE      '*PREV  '     P@OPTN
     C                   END
 
      ** Caller requests previous record :
 
     C     P@OPTN        IFEQ      '*PREV  '
     C                   READP     GPCTRYD0                             9094
     C     *IN94         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   END
 
      ** Caller requests record indicated by key :
 
     C     P@OPTN        IFEQ      '*KEY   '
     C     P@OPTN        OREQ      '*VERIFY'
     C     W@SL01        IFEQ      '?'
     C     W@SL02        OREQ      '?'
     C                   CALL      'GP000181S'                          98
     C                   PARM      *BLANK        P@RTC2            7
     C                   PARM      *BLANK        P@CNCD
     C     P@RTC2        COMP      *BLANK                             97
     C     *IN97         CABEQ     '1'           T@SKIP
     C     *IN98         CABEQ     '1'           T@SKIP
     C                   END
     C     P@CNCD        CHAIN     GPCTRYD0                           9590
     C     *IN95         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   END
 
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
GPCTRYPD  GPAOCTRYR0  Country Codes
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2006
