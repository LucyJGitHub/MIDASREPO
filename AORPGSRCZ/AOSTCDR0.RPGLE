     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Federal State Codes')                         *
      *****************************************************************
      *                                                               *
      *  Midas  Access Object                                         *
      *                                                               *
      *  AOSTCDR0  - Access Object for Federal State Codes            *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER054  *CREATE    Date 07Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax                        *
      *                                                               *
      *****************************************************************
 
      ** Midas SD Federal State Codes by State Code
     FSDGESTL0  IF   E           K DISK    USROPN
 
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
 
     D D@FMT         E DS                  EXTNAME(SDGESTPD)
      ** Customer Details by Country of Tax
 
     D P@FMT         E DS                  EXTNAME(DSFDY)
      ** External Data structure to hold the outgoing record format of
      ** the file.
 
     D P@STCD          DS
      ** Federal State Code key definition
     D  W@StC1                 1      1
     D  W@StC2                 2      2
      *
     D A@CPY           DS
      *
      ** Parameter for ZASNMG
     D  W@Rtcd         S              7A
     D  P@PgNm         S             10A
     D  P@Dest         S              5A
     D  P@MgID         S              7A
     D  P@MsgF         S             10A
     D  P@MgKy         S              4A
     D  P@MgTp         S              7A
      *
      ** Entry Parameters
     D  P@Rtcd         S              7A
     D  P@Optn         S              7A
      *
     D P@Rtc2          S              7A
      *****************************************************************
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST
     C     W@Rtcd        PARM                    P@Rtcd
     C                   PARM                    P@Optn
     C                   PARM                    P@STCD            2
     C                   PARM                    P@FMT
      *
      ** Access Option *SAME input
      *
     C                   IF        P@Optn = '*SAME '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      T@SKIP
     C                   ENDIF
      *
      ** Reset error indicators
      *
     C                   EVAL      *IN90 = *OFF
     C                   EVAL      *IN91 = *OFF
     C                   EVAL      *IN92 = *OFF
     C                   EVAL      *IN93 = *OFF
     C                   EVAL      *IN94 = *OFF
     C                   EVAL      *IN95 = *OFF
     C                   EVAL      *IN96 = *OFF
     C                   EVAL      *IN97 = *OFF
     C                   EVAL      *IN98 = *OFF
      *
      ** First call - open file :
      *
     C                   IF        *IN01 = '0'
     C                   EVAL      *IN01 = *ON
     C                   OPEN      SDGESTL0                             91
     C     *IN91         CABEQ     '1'           T@SKIP                   LR
     C                   ENDIF
      *
      ** Last call - close file and terminate program :
      *
     C                   IF        P@Optn = '*FREE  '
     C                   CLOSE     SDGESTL0                             92
     C     *IN92         CABEQ     '1'           T@SKIP                   LR
     C                   EVAL      *INLR = *ON
     C                   ENDIF
      *
      ** Caller requests first record :
      *
     C                   IF        P@Optn = '*FIRST '
     C     *LOVAL        SETLL     SDGESTD0                           9390
     C     *IN93         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   EVAL      P@Optn = '*NEXT'
     C                   ENDIF
      *
      ** Caller requests next record :
      *
     C                   IF        P@Optn = '*NEXT  '
     C                   READ      SDGESTD0                             9094
     C     *IN94         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   ENDIF
      *
      ** Caller requests last record :
      *
     C                   IF        P@Optn = '*LAST  '
     C     *HIVAL        SETGT     SDGESTD0                             90
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   EVAL      P@Optn = '*PREV'
     C                   ENDIF
      *
      ** Caller requests previous record :
      *
     C                   IF        P@Optn = '*PREV  '
     C                   READP     SDGESTD0                             9094
     C     *IN94         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   ENDIF
      *
      ** Caller requests record indicated by key :
      *
     C                   IF        P@Optn = '*KEY   ' OR
     C                             P@Optn = '*VERIFY'
      *
     C                   IF        W@StC1 = '?' OR
     C                             W@StC2 = '?'
      *
     C                   CALL      'SD000030S'                          98
     C                   PARM      *BLANKS       P@Rtc2
     C                   PARM      *BLANKS       P@STCD
      *
     C                   IF        P@Rtc2 <> *BLANKS
     C                   EVAL      *IN97 = *ON
     C                   ENDIF
     C     *IN97         CABEQ     '1'           T@SKIP
     C     *IN98         CABEQ     '1'           T@SKIP                   LR
     C                   ENDIF
      *
     C     P@STCD        CHAIN     SDGESTD0                           9590
     C     *IN95         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   ENDIF
      *
     C                   IF        P@Optn <> '*KEY   ' AND
     C                             P@Optn <> '*NEXT  ' AND
     C                             P@Optn <> '*PREV  ' AND
     C                             P@Optn <> '*VERIFY' AND
     C                             P@Optn <> '*FREE  '
     C                   EVAL      *IN96 = *ON
     C                   ENDIF
      *
      ** No record found or End of file - return error code :
      *
     C     T@SKIP        TAG
      *
     C                   EVAL      P@Rtcd = *BLANK
     C   90              EVAL      P@Rtcd = '*ERROR '
     C   91              EVAL      P@Rtcd = '*OPEN  '
     C   92              EVAL      P@Rtcd = '*CLOSE '
     C   93              EVAL      P@Rtcd = '*EMPTY '
     C   94              EVAL      P@Rtcd = '*EOF   '
     C   95              EVAL      P@Rtcd = '*NRF   '
     C   96              EVAL      P@Rtcd = '*OPTION'
     C   97              EVAL      P@Rtcd = '*NOSEL '
     C   98              EVAL      P@Rtcd = '*CALL'
      *
      * Caller requests message sent to program queue :
      *
     C                   IF        W@Rtcd = '*MSG   ' AND
     C                             P@Rtcd = *BLANK
     C   90              EVAL      P@MgID = 'ACO1001'
     C   91              EVAL      P@MgID = 'ACO1002'
     C   92              EVAL      P@MgID = 'ACO1003'
     C   93              EVAL      P@MgID = 'ACO1004'
     C   94              EVAL      P@MgID = 'ACO1005'
     C   95              EVAL      P@MgID = 'ACO1006'
     C   96              EVAL      P@MgID = 'ACO1007'
     C   97              EVAL      P@MgID = 'ACO1009'
     C   98              EVAL      P@MgID = 'AC01010'
      *
     C                   CALL      'ZASNMG'
     C                   PARM      *BLANK        W@Rtcd
     C                   PARM      PGNAME        P@PgNm
     C                   PARM      '*PRV'        P@Dest
     C                   PARM                    P@MgID
     C                   PARM      *BLANK        P@MsgF
     C                   PARM      *BLANK        P@MgKy
     C                   PARM                    P@MgDa
     C                   PARM      '*DIAG'       P@MgTp
     C                   ENDIF
      *
      ** Caller Requests DB Error Handling
      *
     C                   IF        W@Rtcd = '*DBERR' AND
     C                             P@Rtcd = *BLANK
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
      *
     C                   IF        P@Optn <> '*VERIFY' AND
     C                             P@Optn <> '*FREE'   AND
     C                             P@Rtcd <> '*OPTION'
     C                   EVAL      P@FMT = D@FMT
     C                   ENDIF
      *
      ** Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
** CPY@
(c) Finastra International Limited 2009
**
SDGESTPD  AOGESTR0  Federal State Codes
