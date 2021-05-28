     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SD Housekeeping of ARR Daily Rates file')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module        *
      *                                                               *
      *  SD001015 - Housekeeping of ARR Daily Rates file.             *
      *             Transactions in historical file must be housekept *
      *             as well during the housekeeping of main           *
      *             transaction file.                                 *
      *                                                               *
      *  Function: This program will delete the transaction in ARR    *
      *            Daily Rates file if the main transaction is deleted*
      *            in main transaction file.                          *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. CSD103    *CREATE  Date 10Aug20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *                                                               *
      *****************************************************************
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** +--------------------------------------+
      ** ¦ Variable declaration                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+
     D thisSQL         S            500
     D thisSQL1        S            500
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      * Initialization of indicators
     C                   SETOFF                                           90
     C                   SETOFF                                           91
      *
      ** Main Processing
      ** Housekeeping of Lending Records
      *
     C                   EVAL      thisSQL = 'Delete from SDHSDRTD where +
     C                              CMODID = ''LE'' AND CTRNID not in +
     C                              (select LNRF from CLOANCL) AND CTRNID +
     C                              not in (select LNRF from MCLONCL)'
     C                   EVAL      thisSQL1 = 'Delete from SDARRLOGTD where +
     C                              SJMODI = ''LE'' AND SJTREF not in +
     C                              (select LNRF from CLOANCL)'
      *
     C/EXEC SQL
     C+ EXECUTE IMMEDIATE :thisSQL
     C/END-EXEC
     C                   IF         SQLCOD <> 0 AND SQLCOD <> 100
     C                   SETON                                            90
     C                   EXSR      *PSSR
     C                   ENDIF
     C/EXEC SQL
     C+ EXECUTE IMMEDIATE :thisSQL1
     C/END-EXEC
     C                   IF         SQLCOD <> 0 AND SQLCOD <> 100
     C                   SETON                                            91
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C/EXEC SQL
     C+ EXECUTE IMMEDIATE :thisSQL2
     C/END-EXEC
     C/EXEC SQL
     C+ EXECUTE IMMEDIATE :thisSQL3
     C/END-EXEC
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      *  *PSSR - Subroutine to handle error conditions                *
      *                                                               *
      *  Called from:  After abnormal operation occurs                *
      *                                                               *
      *  Calls: Nothing                                               *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C   90              MOVE      'SDHSDRTD'    DBFILE
     C   91              MOVE      'SDARRLOGTD'  DBFILE
     C                   EVAL      DBKEY  = 'SQL ERROR'
     C                   EVAL      DBPGM  = 'SD001015'
     C                   EVAL      DBASE  = SQLCODE
      *
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EVAL      *INLR = '1'
     C                   DUMP
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2020
