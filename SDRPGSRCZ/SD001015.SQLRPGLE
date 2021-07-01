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
      *  Last Amend No. CDL102             Date 01Jun21               *
      *  Prev Amend No. CSD103    *CREATE  Date 10Aug20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL102 - LIBOR Deregulation - Dealing                        *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *                                                               *
      *****************************************************************
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
     D/COPY ZACPYSRC,STD_D_SPEC
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CDL102
      ** External DS for SAR details                                                          CDL102
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CDL102
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                                    CDL102
      *
      ** +--------------------------------------+
      ** ¦ Variable declaration                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+
     D thisSQL         S            500
     D thisSQL1        S            500
     D thisSQL2        S            500                                                       CDL102
     D thisSQL3        S            500                                                       CDL102
                                                                                              CDL102
     D PRtCd           S              7A                                                      CDL102
     D POptn           S              7A                                                      CDL102
     D PSard           S              6A                                                      CDL102
                                                                                              CDL102
      * Switchable features                                                                   CDL102
     D CLE172          S              1A                                                      CDL102
     D CDL102          S              1A                                                      CDL102
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      * Initialization of indicators
     C                   SETOFF                                           90
     C                   SETOFF                                           91
                                                                                              CDL102
      ** Check if switchable feature CLE172 is switched on.                                   CDL102
                                                                                              CDL102
     C                   EVAL      CLE172 = 'N'                                               CDL102
                                                                                              CDL102
     C                   CALL      'AOSARDR0'                                                 CDL102
     C                   PARM      *BLANKS       PRtCd                                        CDL102
     C                   PARM      '*VERIFY'     POptn                                        CDL102
     C                   PARM      'CLE172'      PSard                                        CDL102
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL102
                                                                                              CDL102
     C                   IF        PRtCd = *BLANKS                                            CDL102
     C                   EVAL      CLE172 = 'Y'                                               CDL102
     C                   ENDIF                                                                CDL102
                                                                                              CDL102
      ** Check if switchable feature CDL102 is switched on.                                   CDL102
                                                                                              CDL102
     C                   EVAL      CDL102 = 'N'                                               CDL102
                                                                                              CDL102
     C                   CALL      'AOSARDR0'                                                 CDL102
     C                   PARM      *BLANKS       PRtCd                                        CDL102
     C                   PARM      '*VERIFY'     POptn                                        CDL102
     C                   PARM      'CDL102'      PSard                                        CDL102
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL102
                                                                                              CDL102
     C                   IF        PRtCd = *BLANKS                                            CDL102
     C                   EVAL      CDL102 = 'Y'                                               CDL102
     C                   ENDIF                                                                CDL102
      ** Main Processing
      ** Housekeeping of Lending Records
      *
     C                   IF        CLE172 = 'Y'                                               CDL102
                                                                                              CDL102
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
                                                                                              CDL102
     C                   ENDIF                                                                CDL102
      *                                                                                       CDL102
      ** Housekeeping of Dealing Records                                                      CDL102
      *                                                                                       CDL102
     C                   IF        CDL102 = 'Y'                                               CDL102
                                                                                              CDL102
     C                   EVAL      thisSQL2 = 'Delete from SDHSDRTD where +                   CDL102
     C                              CMODID = ''DL'' AND CTRNID not in +                       CDL102
     C                              (select DLNO from DEALSDC)'                               CDL102
     C                   EVAL      thisSQL3 = 'Delete from SDARRLOGTD where +                 CDL102
     C                              SJMODI = ''DL'' AND SJTREF not in +                       CDL102
     C                              (select DLNO from DEALSDC)'                               CDL102
      *                                                                                       CDL102
     C/EXEC SQL                                                                               CDL102
     C+ EXECUTE IMMEDIATE :thisSQL2                                                           CDL102
     C/END-EXEC                                                                               CDL102
     C                   IF         SQLCOD <> 0 AND SQLCOD <> 100                             CDL102
     C                   SETON                                            90                  CDL102
     C                   EXSR      *PSSR                                                      CDL102
     C                   ENDIF                                                                CDL102
     C/EXEC SQL                                                                               CDL102
     C+ EXECUTE IMMEDIATE :thisSQL3                                                           CDL102
     C/END-EXEC                                                                               CDL102
     C                   IF         SQLCOD <> 0 AND SQLCOD <> 100                             CDL102
     C                   SETON                                            91                  CDL102
     C                   EXSR      *PSSR                                                      CDL102
     C                   ENDIF                                                                CDL102
                                                                                              CDL102
     C                   ENDIF                                                                CDL102
      *                                                                                       CDL102
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
