     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas DL Interest History Purge Utility')              *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  UTDL0503 - Interest History Purge Utility                    *
      *                                                               *
      *  Function: The utility will purge all records in HISTSAA      *
      *            that has no counter part in DEALSDC                *
      *                                                               *
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. MD051650 *CREATE   Date 12Sep18               *
      *  Prev Amend No. Xxxxxxxx           Date ddMmmyy
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD051650 - Utility program to purge old records in HISTSAA   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SrSQLStm1  - To get the records in HISTSAA that have no      *
      *               counterpart in DEALSDC                          *
      *  SrSQLFetch - To fetch next record from recordset             *
      *  SrSQLClose - To close the cursor                             *
      *  SrWP1End   - To write the End of Report                      *
      *  SrSQLStm2  - To count all the records in file HISTSAA        *
      *               before purging                                  *
      *  SrSQLStm3  - To purge records in HISTSAA that have no        *
      *               counterpart in DEALSALL                         *
      *  SrAudit    - To write to audit report UTDL0503AU             *
      *  *INZSR     - Program initialisation                          *
      *  *PSSR      - Error handling subroutine                       *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FUTDL0503P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)

     FUTDL0503AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Short DS for Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** File information DS for UTDL0503P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0

      ** File information DS for UTDL0503AU
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0

      ** DS for SQL cursor C1
     D dsC1            DS
     D RecordType              1      2
     D Customer                3      8
     D DealNumber              9     14  0
     D DealType               15     16
     D DealSubType            17     18
     D Branch                 19     21
     D Currency               22     24

      ** DS for SQL cursor C2
     D dsC2            DS
     D WCTR                    1     10  0

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D RetCode         S              7A
     D Option          S              7A
     D WRun            S              1A
     D WCount          S              3P 0
     D SqlStm1         S           2000A
     D SqlStm2         S           2000A
     D SqlStm3         S           2000A
     D WDelCtr         S             10  0 INZ(*ZEROS)
     D Mode            S              1A

      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

     C                   EXSR      SrSQLStm1

     C                   DOW       SQLCODE = *ZEROS

     C                   EXSR      SQLFetch

     C                   IF        SQLCODE = *ZEROS
     C                   EVAL      WDelCtr = WDelCtr + 1
     C                   EXSR      SrFormat
     C                   ENDIF

     C                   ENDDO

     C                   EXSR      SQLClose
     C                   EXSR      SrWP1End
     C                   EXSR      SrSqlStm2
     C                   IF        Mode = 'U' or Mode = 'u'
     C                   EXSR      SrSqlStm3
     C                   ENDIF
     C                   EXSR      SrAudit

     C                   EVAL      *INLR = *ON
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSQLStm1 - Subroutine to get the records in HISTSAA that    *
      *              have no counterpart in DEALSDC                   *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrSQLStm1     BEGSR

     C                   EVAL      SqlStm1 = 'SELECT ' +
     C                             'A.RTYP, ' +
     C                             'A.CNUM, ' +
     C                             'A.DLNO, ' +
     C                             'A.DTYP, ' +
     C                             'A.DLST, ' +
     C                             'A.BRCA, ' +
     C                             'A.CCY '   +
     C                             'FROM HISTSAA A WHERE '          +
     C                             'CONCAT(CONCAT(CONCAT(CONCAT('   +
     C                             'CONCAT(CONCAT(A.RTYP,A.CNUM), ' +
     C                             'A.DLNO), A.DTYP), A.DLST), '    +
     C                             'A.BRCA), A.CCY) IN (SELECT '    +
     C                             'CONCAT(CONCAT(CONCAT(CONCAT('   +
     C                             'CONCAT(CONCAT(H.RTYP,H.CNUM), ' +
     C                             'H.DLNO), H.DTYP), H.DLST), '    +
     C                             'H.BRCA), H.CCY) FROM HISTSAA H '+
     C                             'INNER JOIN DEALSDC D '          +
     C                             'ON H.DLNO = D.DLNO WHERE '      +
     C                             '(D.RECI = ''D'' AND '           +
     C                             '(D.CNUM <> H.CNUM OR' +
     C                             ' D.DTYP <> H.DTYP OR' +
     C                             ' D.DLST <> H.DLST OR' +
     C                             ' D.BRCA <> H.BRCA OR' +
     C                             ' D.CCY  <> H.CCY )))' +
     C                             'OR A.DLNO NOT IN '    +
     C                             '(SELECT Z.DLNO FROM DEALSDC Z)'

     C/EXEC SQL
     C+ PREPARE STATEMENT1
     C+   FROM :SqlStm1
     C/END-EXEC

     C/EXEC SQL
     C+ DECLARE C1 CURSOR
     C+   FOR STATEMENT1
     C/END-EXEC

     C/EXEC SQL
     C+  OPEN C1
     C/END-EXEC

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSQLStm2 - Subroutine to count all the records in table     *
      *              HISTSAA before purging                           *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrSQLStm2     BEGSR

      ** Select all records from HISTSAA

     C                   EVAL      SqlStm2 = 'SELECT COUNT(*) ' +
     C                             'FROM HISTSAA'

     C/EXEC SQL
     C+ PREPARE STATEMENT2
     C+   FROM :SqlStm2
     C/END-EXEC

     C/EXEC SQL
     C+ DECLARE C2 CURSOR
     C+   FOR STATEMENT2
     C/END-EXEC

     C/EXEC SQL
     C+  OPEN C2
     C/END-EXEC

     C/EXEC SQL
     C+ EXECUTE STATEMENT2
     C/END-EXEC

     C/EXEC SQL
     C+  FETCH NEXT FROM C2 INTO :dsC2
     C/END-EXEC

     C/EXEC SQL
     C+  CLOSE C2
     C/END-EXEC

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSQLStm3 - Subroutine to purge records in HISTSAA that      *
      *              have no counterpart in DEALSDC                   *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrSQLStm3     BEGSR

     C                   EVAL      SqlStm3 = 'DELETE ' +
     C                             'FROM HISTSAA A WHERE '          +
     C                             'CONCAT(CONCAT(CONCAT(CONCAT('   +
     C                             'CONCAT(CONCAT(A.RTYP,A.CNUM), ' +
     C                             'A.DLNO), A.DTYP), A.DLST), '    +
     C                             'A.BRCA), A.CCY) IN (SELECT '    +
     C                             'CONCAT(CONCAT(CONCAT(CONCAT('   +
     C                             'CONCAT(CONCAT(H.RTYP,H.CNUM), ' +
     C                             'H.DLNO), H.DTYP), H.DLST), '    +
     C                             'H.BRCA), H.CCY) FROM HISTSAA H '+
     C                             'INNER JOIN DEALSDC D '          +
     C                             'ON H.DLNO = D.DLNO WHERE '      +
     C                             '(D.RECI = ''D'' AND '           +
     C                             '(D.CNUM <> H.CNUM OR' +
     C                             ' D.DTYP <> H.DTYP OR' +
     C                             ' D.DLST <> H.DLST OR' +
     C                             ' D.BRCA <> H.BRCA OR' +
     C                             ' D.CCY  <> H.CCY )))' +
     C                             'OR A.DLNO NOT IN '    +
     C                             '(SELECT Z.DLNO FROM DEALSDC Z)'

     C/EXEC SQL
     C+ PREPARE STATEMENT3
     C+   FROM :SqlStm3
     C/END-EXEC

     C/EXEC SQL
     C+ EXECUTE STATEMENT3
     C/END-EXEC

     C                   IF        SQLCODE < 0 AND SQLSTATE <> '22023'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SQLFetch - Subroutine to fetch next record from recordset    *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SQLFetch      BEGSR

     C/EXEC SQL
     C+  FETCH NEXT FROM C1 INTO :dsC1
     C/END-EXEC

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFormat - Subroutine to format and move the details to      *
      *             printer fields                                    *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: SrRCFP1                                               *
      *                                                               *
      *****************************************************************
     C     SrFormat      BEGSR

     C                   IF        NOT %OPEN(UTDL0503P1)
     C                   OPEN      UTDL0503P1

     C                   SELECT
     C                   WHEN      Mode = 'A' or Mode = 'a'
     C                   EVAL      RMODE = 'Audit Mode'
     C                   WHEN      Mode = 'U' or Mode = 'u'
     C                   EVAL      RMODE = 'Update Mode'
     C                   ENDSL

     C                   WRITE     HEADP1
     C                   ENDIF

     C                   EVAL      RRTYP   =  RecordType
     C                   EVAL      RCNUM   =  Customer
     C                   EVAL      RDLNO   =  DealNumber
     C                   EVAL      RDTYP   =  DealType
     C                   EVAL      RDLST   =  DealSubType
     C                   EVAL      RBRCA   =  Branch
     C                   EVAL      RCCY    =  Currency

     C                   IF        OFLLN1 <= PRTLN1 + 4
     C                   WRITE     HEADP1
     C                   ENDIF

     C                   WRITE     DETAIL1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SQLClose - Subroutine to close the cursor                    *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SQLClose      BEGSR

     C/EXEC SQL
     C+  CLOSE C1
     C/END-EXEC

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrWP1End - Subroutine to write End of Report                  *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrWP1End      BEGSR

     C                   IF        %OPEN(UTDL0503P1)

     C                   IF        OFLLN1 <= PRTLN1 + 3
     C                   WRITE     HEADP1
     C                   ENDIF

     C                   WRITE     TRAILP1
     C                   CLOSE     UTDL0503P1

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAudit - Subroutine to write to audit report UTDL0503AU      *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrRCFAU                                                *
      *                                                               *
      *****************************************************************
     C     SrAudit       BEGSR

     C                   WRITE     HEADAU

     C                   IF        (WDelCtr = 0) AND (*INU7 = *OFF)
     C                   WRITE     NODTLS
     C                   ELSE
     C                   EVAL      RBFREC = WCtr
     C                   EVAL      RBFDEL = WDelCtr
     C                   WRITE     CONTROL
     C                   ENDIF

     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    Mode

      ** Initialize program name

     C                   EVAL      DBPGM = 'UTDL0503'

      ** Access Bank Details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       RetCode
     C                   PARM      '*FIRST '     Option
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database Error

     C                   IF        RetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = Option
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR

      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************

     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      ********************************************************************
