     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO A/C Transfer Type/Subtype Access Object')
      *****************************************************************
      *                                                               *
      *  Midas  Access Object                                         *
      *                                                               *
      *  AOATSTR0 - Read Access to Account Transfer Type/Subtype      *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BUG27394           Date 26Apr10               *
      *                 CAP204A            Date 10Mar10               *
      *                 CAP204  *CREATE    Date 20Jan10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27394 - Add new field Record ID to allow logical deletion *
      *             of this file (Recompile)                          *
      *  CAP204A - Teller Related APIs - Account Transfer: Change     *
      *            Request 027 - Add new field Wash Account Code      *
      *            (Recompile)                                        *
      *  CAP204 - Retail Account Transfer                             *
      *                                                               *
      *****************************************************************
 
     FSDATSTL1  IF   E           K DISK    USROPN
 
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
 
      ** Account Transfer Type/SubType
 
     D D@FMT         E DS                  EXTNAME(SDATSTPD)
 
      ** External Data structure to hold the outgoing record format of
      ** the file
 
     D P@FMT         E DS                  EXTNAME(DSLDY)
 
      ** Enrty parameters
 
     D P@RTCD          S              7A
     D P@OPTN          S              7A
     D P@TRTY          S              2A
     D P@TRST          S              5A
 
      ** ZASNMG entry parameters
 
     D W@RTCD          S              7A
     D P@PGNM          S             10A
     D P@DEST          S              5A
     D P@MGID          S              7A
     D P@MSGF          S             10A
     D P@MGKY          S              4A
     D P@MGTP          S              7A
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD
     C                   PARM                    P@OPTN
     C                   PARM                    P@TRTY
     C                   PARM                    P@TRST
     C                   PARM                    P@FMT
 
     C     K@CRES        KLIST
     C                   KFLD                    P@TRTY
     C                   KFLD                    P@TRST
 
      ** Access Option *SAME input
 
     C                   IF        P@OPTN = '*SAME '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      T@SKIP
     C                   ENDIF
 
      ** Reset error indicators
 
     C                   SETOFF                                       909192
     C                   SETOFF                                       939495
     C                   SETOFF                                       969798
 
      ** First call - open file :
 
     C                   IF        *IN01 = '0'
     C                   SETON                                        01
     C                   OPEN      SDATSTL1                             91
     C     *IN91         CABEQ     '1'           T@SKIP                   LR
     C                   ENDIF
 
      ** Last call - close file and terminate program :
 
     C                   IF        P@OPTN = '*FREE  '
     C                   CLOSE     SDATSTL1                             92
     C     *IN92         CABEQ     '1'           T@SKIP                   LR
     C                   SETON                                        LR
     C                   ENDIF
 
      ** Caller requests first record :
 
     C                   IF        P@OPTN = '*FIRST '
     C     *LOVAL        SETLL     SDATSTL1                           9390
     C     *IN93         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   MOVE      '*NEXT  '     P@OPTN
     C                   ENDIF
 
      ** Caller requests next record :
 
     C                   IF        P@OPTN = '*NEXT  '
     C                   READ      SDATSTL1                             9094
     C     *IN94         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   ENDIF
 
      ** Caller requests last record :
 
     C                   IF        P@OPTN = '*LAST  '
     C     *HIVAL        SETGT     SDATSTL1                             90
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   MOVE      '*PREV  '     P@OPTN
     C                   ENDIF
 
      ** Caller requests previous record :
 
     C                   IF        P@OPTN = '*PREV  '
     C                   READP     SDATSTL1                             9094
     C     *IN94         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   ENDIF
 
      ** Caller requests record indicated by key :
 
     C                   IF        P@OPTN = '*KEY   ' or
     C                             P@OPTN = '*VERIFY'
     C     K@CRES        CHAIN     SDATSTL1                           9590
     C     *IN95         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   ENDIF
 
     C                   IF        P@OPTN <> '*KEY   ' AND
     C                             P@OPTN <> '*NEXT  ' AND
     C                             P@OPTN <> '*PREV  ' AND
     C                             P@OPTN <> '*VERIFY' AND
     C                             P@OPTN <> '*FREE  '
     C                   SETON                                          96
     C                   ENDIF
 
      ** No record found or End of file - return error code :
 
     C     T@SKIP        TAG
 
     C                   EVAL      P@RTCD = *BLANK
     C   90              EVAL      P@RTCD = '*ERROR '
     C   91              EVAL      P@RTCD = '*OPEN  '
     C   92              EVAL      P@RTCD = '*CLOSE '
     C   93              EVAL      P@RTCD = '*EMPTY '
     C   94              EVAL      P@RTCD = '*EOF   '
     C   95              EVAL      P@RTCD = '*NRF   '
     C   96              EVAL      P@RTCD = '*OPTION'
     C   97              EVAL      P@RTCD = '*NOSEL '
 
      ** Caller requests message sent to program queue :
 
     C                   IF        W@RTCD = '*MSG   ' AND
     C                             P@RTCD = *BLANK
     C   90              EVAL      P@MGID = 'ACO1001'
     C   91              EVAL      P@MGID = 'ACO1002'
     C   92              EVAL      P@MGID = 'ACO1003'
     C   93              EVAL      P@MGID = 'ACO1004'
     C   94              EVAL      P@MGID = 'ACO1005'
     C   95              EVAL      P@MGID = 'ACO1006'
     C   96              EVAL      P@MGID = 'ACO1007'
     C   97              EVAL      P@MGID = 'ACO1009'
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
 
      ** Caller Requests DB Error Handling
 
     C                   IF        W@RTCD = '*DBERR' AND
     C                             P@RTCD = *BLANK
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   IF        P@OPTN <> '*VERIFY' AND
     C                             P@OPTN <> '*FREE'   AND
     C                             P@RTCD <> '*OPTION'
     C                   MOVEL     D@FMT         P@FMT
     C                   ENDIF
 
      ** Return to caller :
 
     C                   RETURN
 
