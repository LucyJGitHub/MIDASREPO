     H OPTION(*NODEBUGIO:*SRCSTMT)
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas Purge BF Teller Journal Extension')
      *****************************************************************
      *                                                               *
      *  Midas - BankFusion Module                                    *
      *                                                               *
      *  BF004610 - Purge BF Teller Journal Extension Records         *
      *                                                               *
      *  Function:  This program will purge all records in MITB_JRNEX *
      *             that has no counter part in BTTB_EJHEADER         *
      *                                                               *
      *  Called By: BFC004610 - Purge BF Teller Journal Extension     *
      *                         Records Control                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. CRE071  *CREATE    Date 05Oct10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE071 - BankFusion Midas Teller CBS related changes         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SrSQLStm1  - To get the records in MITB_JRNEX that have no   *
      *               counterpart in BTTB_EJHEADER table              *
      *  SrSQLFetch - To fetch next record from recordset             *
      *  SrSQLClose - To close the cursor                             *
      *  SrWP1End   - To write the End of Report                      *
      *  SrSQLStm2  - To count all the records in table MITB_JRNEX    *
      *               before purging                                  *
      *  SrSQLStm3  - To purge records in MITB_JRNEX that have no     *
      *               counterpart in BTTB_EJHEADER                    *
      *  SrAudit    - To write to audit report BF004610AU             *
      *  *INZSR     - Program initialisation                          *
      *  *PSSR      - Error handling subroutine                       *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FBF004610P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
 
     FBF004610AUO    E             PRINTER INFSR(*PSSR)
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
 
      ** File information DS for BF004610P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
      ** File information DS for SD009823AU
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
      ** DS for SQL cursor C1
     D dsC1            DS
     D TellerTransRef          1     22
     D FrontOfficeID          23     44
     D APIName                45     50
     D Stage                  51     53
 
      ** DS for SQL cursor C2
     D dsC2            DS
     D WCTR                    1      5  0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for ZSFILE
     D PSENTY          S              3
     D PSFILE          S             10
     D PZSNUM          S              6  0
     D PZSERR          S              1
     D PSEQ            S              5A
 
      ** Parameters for AOSVALR0
     D PSysVal         S             20    DIM(10)
     D PCurSet         S            200    DIM(10)
 
     D RetCode         S              7A
     D Option          S              7A
     D WRun            S              1A
     D WCount          S              3P 0
     D SqlStm1         S           2000A
     D SqlStm2         S           2000A
     D SqlStm3         S           2000A
     D SCHEMA1         S             10A
     D SCHEMA2         S             10A
     D WDelCtr         S              5  0 INZ(*ZEROS)
 
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
     C                   EXSR      SrSqlStm3
     C                   EXSR      SrAudit
 
     C                   EVAL      *INLR = *ON
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSQLStm1 - Subroutine to get the records in MITB_JRNEX that *
      *              have no counterpart in BTTB_EJHEADER table       *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrSQLStm1     BEGSR
 
     C                   EVAL      SqlStm1 = 'SELECT MITTRE, MIFOID, ' +
     C                             'MIAPI, MISTAG FROM ' +
     C                             %TRIM(SCHEMA1) + '/' + 'MITB_JRNEX' +
     C                             ' WHERE NOT EXISTS(SELECT * FROM ' +
     C                             %TRIM(SCHEMA2) + '/' +
     C                             'BTTB_EJHEADER' + ' WHERE ' +
     C                             'BTTB_EJHEADER.BTTXNREF = ' +
     C                             'MITB_JRNEX.MITTRE)'
 
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
      *              MITB_JRNEX before purging                        *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrSQLStm2     BEGSR
 
      ** Select all records from MITB_JRNEX
 
     C                   EVAL      SqlStm2 = 'SELECT COUNT(*) AS ' +
     C                             'WCtr FROM ' + %TRIM(SCHEMA1) +
     C                             '/' + 'MITB_JRNEX'
 
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
      *  SrSQLStm3 - Subroutine to purge records in MITB_JRNEX that   *
      *              have no counterpart in BTTB_EJHEADER             *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrSQLStm3     BEGSR
 
     C                   EVAL      SqlStm3 =
     C                             'DELETE FROM' + ' ' +
     C                             %TRIM(SCHEMA1) + '/' + 'MITB_JRNEX' +
     C                             ' WHERE NOT EXISTS(SELECT * FROM ' +
     C                             %TRIM(SCHEMA2) + '/' + 'BTTB_EJHEADER' +
     C                             ' WHERE BTTB_EJHEADER.BTTXNREF = ' +
     C                             'MITB_JRNEX.MITTRE)'
 
     C/EXEC SQL
     C+ PREPARE STATEMENT3
     C+   FROM :SqlStm3
     C/END-EXEC
 
     C/EXEC SQL
     C+ EXECUTE STATEMENT3
     C/END-EXEC
 
     C                   IF        SQLCODE < *ZEROS
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
 
      ** Open and register P1 report via RCF
 
     C                   IF        NOT %OPEN(BF004610P1)
     C                   OPEN      BF004610P1
     C                   EXSR      SrRCFP1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   EVAL      RTTRE   =  TellerTransRef
     C                   EVAL      RFOID   =  FrontOfficeID
     C                   EVAL      RAPI    =  APIName
     C                   EVAL      RSTAGE  =  Stage
 
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
      * SrRCFP1 - Register the P1 Printer File via RCF                *
      *                                                               *
      * Called by: SrFormat                                           *
      *                                                               *
      * Calls: ZSFILE                                                 *
      *                                                               *
      *****************************************************************
     C     SrRCFP1       BEGSR
 
     C                   Z-ADD     SFNUM1        PZSNUM
 
     C                   CALL      'ZSFILE'
     C                   PARM      PSEQ          PSEQ
     C                   PARM      *BLANKS       PSENTY
     C                   PARM      SFILE1        PSFILE
     C                   PARM                    PZSNUM
     C                   PARM      *BLANK        PZSERR
 
     C                   IF        PZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
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
 
     C                   IF        %OPEN(BF004610P1)
 
     C                   IF        OFLLN1 <= PRTLN1 + 3
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   WRITE     TRAILP1
     C                   CLOSE     BF004610P1
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRCFAU - Subroutine to register BF004610AU via RCF           *
      *                                                               *
      * Called by: SrAudit                                            *
      *                                                               *
      * Calls: ZSFILE                                                 *
      *                                                               *
      *****************************************************************
     C     SrRCFAU       BEGSR
 
     C                   Z-ADD     SFNUMU        PZSNUM
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       PSEQ
     C                   PARM      *BLANKS       PSENTY
     C                   PARM      SFILEU        PSFILE
     C                   PARM                    PZSNUM
     C                   PARM      *BLANK        PZSERR
 
     C                   IF        PZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAudit - Subroutine to write to audit report BF004610AU      *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrRCFAU                                                *
      *                                                               *
      *****************************************************************
     C     SrAudit       BEGSR
 
     C                   EXSR      SrRCFAU
 
     C                   WRITE     HEADAU
 
     C                   IF        (WDelCtr = 0) AND (*INU7 = *OFF)
     C                   WRITE     NODTLS
     C                   ELSE
     C                   EVAL      RBFREC = WCtr
     C                   EVAL      RBFDEL = WDelCtr
     C                   WRITE     CONTROL
     C                   ENDIF
 
     C                   IF        (*INU7)
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
 
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'BF004610'
 
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
 
     C                   EVAL      PSysVal(1) = 'HostIntLayerSchema'
     C                   EVAL      PSysVal(2) = 'BranchTellerSchema'
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       RetCode
     C                   PARM                    PSysVal(1)
     C                   PARM                    PCurSet(1)
     C                   PARM                    PSysVal(2)
     C                   PARM                    PCurSet(2)
     C                   PARM                    PSysVal(3)
     C                   PARM                    PCurSet(3)
     C                   PARM                    PSysVal(4)
     C                   PARM                    PCurSet(4)
     C                   PARM                    PSysVal(5)
     C                   PARM                    PCurSet(5)
     C                   PARM                    PSysVal(6)
     C                   PARM                    PCurSet(6)
     C                   PARM                    PSysVal(7)
     C                   PARM                    PCurSet(7)
     C                   PARM                    PSysVal(8)
     C                   PARM                    PCurSet(8)
     C                   PARM                    PSysVal(9)
     C                   PARM                    PCurSet(9)
     C                   PARM                    PSysVal(10)
     C                   PARM                    PCurSet(10)
 
     C                   FOR       WCount = 1 to 2
 
     C                   IF        PCurSet(WCount) = '*NRF' OR
     C                             RetCode <> *BLANKS  AND
     C                             RetCode <> '*NRF'
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY   = PSysVal(WCount)
     C                   EVAL      DBFILE  = 'SDSVALPD'
     C                   EVAL      DBASE   = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDFOR
 
     C                   EVAL      SCHEMA1 = %TRIM(PCurSet(1))
     C                   EVAL      SCHEMA2 = %TRIM(PCurSet(2))
 
     c                   ENDSR
 
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
**  CPY@
(c) Misys International Banking Systems Ltd. 2010
