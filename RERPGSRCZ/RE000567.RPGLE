     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Accounts becoming effective today report')    *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE000567 - Accounts becoming effective today report          *
      *                                                               *
      *  Function:  This module will produce a report automatically   *
      *             in close of business showing details of retail    *
      *             accounts becoming effective today.                *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR762866           Date 26May11               *
      *                 CRE075  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR762866 - Incorrect account codes in the report (Recompile) *
      *  CRE075 - Effective Date for Retail Accounts                  *
      *                                                               *
      *****************************************************************
     FACCBR     IF   E           K DISK
      ** Accounts master
 
     FRE000567AUO    E             PRINTER INFDS(SPOOLU)
      ** Audit Report
 
     FRE000567P1O    E             PRINTER INFDS(SPOOL1) USROPN
      ** Accounts becoming effective today
 
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   10  - No records processing                                 *
      *   11  - Total records processed                               *
      *   12  - New spool file indicator                              *
      *                                                               *
      *   89  - End of File                                           *
      *                                                               *
      *   98  - Date Format: DDMMYY (off); MMDDYY (on)                *
      * 90-99 - Used by Standard Subroutines                          *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  INIT   - Program Initialisation                              *
      *  PROCES - Detail Processing                                   *
      *  REPORT - Process Report Lines                                *
      *                                                               *
      *  WP1REC - Format and Write a Detail Record to the Report      *
      *  WP1END - Write End of Report                                 *
      *  RCFP1  - Subroutine to register the Printer File via RCF     *
      *  RCFAU  - Subroutine to register the AU Printer File via RCF  *
      *  AUDIT  - Produce Audit Report and End Program                *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
      *
      ** Data Area giving Installation Control Details
      *
     DPSDS            SDS
      *
      ** Program Status Data Structure
      *
     DWSID                   244    253
     DUSER                   254    263
      *
      ** File Information Data Structure for RE000567P1.
      *
     DSPOOL1           DS
     DSFILE1                  83     92
     DSFNUM1                 123    124B 0
     DOFLLN1                 188    189B 0
     DPRTLN1                 367    368B 0
      *
     DSPOOLU           DS
      ** File Information Data Structure for RE000567AU.
     DSFILEU                  83     92
     DSFNUMU                 123    124B 0
 
      ** EXTERNAL DS FOR BANK DETAILS
 
     DSDBANK         E DS                  EXTNAME(SDBANKPD)
     DSDCUST         E DS                  EXTNAME(SDCUSTPD)
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
     D JNSTAT        E DS                  EXTNAME(JNSTAT)
      *
      ** Dummy Data Structures used by Access Programs.
      *
      ** First DS for Access programs, short Data Structure
 
     DDSFDY          E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access programs, Long Data Structure
 
     DDSSDY          E DS                  EXTNAME(DSSDY)
 
      ** Midas Switchable Features Accessed Via Access Program
 
     DSCSARD         E DS                  EXTNAME(SCSARDPD)
 
      ** External data structures for Bank Details
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PSEQ            S              5A
     D SEQ             S              5A
     D SENTY           S              3A
     D ZFILE           S             10A
     D ZSERR           S              1A
     D ZSNUM           S              6  0
     D SETN            S              2  0
 
      *TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ** Perform Initialisation.
      *
     C                   EXSR      INIT
      *
      ** Perform Detail Processing.
      *
     C                   EXSR      PROCES
      *
      ** Output Audit Report and End Program.
      *
     C                   EXSR      AUDIT
     C                   EVAL      *INLR = *ON
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      *                                                               *
      *  INIT   - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  AOBANKR0 Access Program                                      *
      *                                                               *
      *****************************************************************
      *
     C     INIT          BEGSR                                                  *** INIT ***
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  JNSTAT
     C                   IN        RUNDAT
     C                   IN        JNSTAT
     C                   Z-ADD     AGRDNB        CURDAT            5 0
     C                   Z-ADD     PRUN          PRVDAT            5 0
      *
      ** Prepare LDA.
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'RE000567'
     C                   OUT       LDA
      *
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     WRTCD             7
     C                   PARM      '*FIRST '     WOPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Handle Database Error.
      *
     C                   IF        WRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'                            ***************
     C                   EVAL      DBASE = 001                                    * DB ERROR 01 *
     C                   EXSR      *PSSR                                          ***************
     C                   ENDIF
      *
      ** Report Work fields.
      *
     C                   Z-ADD     0             RQDLN1            3 0
     C                   Z-ADD     0             DIFLN1            3 0
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/PROCES
      *****************************************************************
      *                                                               *
      *  PROCES - Subroutine to do the Detail Processing.             *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *  AUDIT  - Produce Audit Report and End Program                *
      *  REPORT - Process Report Lines                                *
      *                                                               *
      *****************************************************************
      *
     C     PROCES        BEGSR                                                  *** PROCES ***
      *
      ** Read first record from File.
      *
     C                   READ      ACCBR                                  89
      *
      ** If End of Records, (*IN89), Perform: Audit Reporting (No
      ** Records).
      *
     C                   IF        *IN89 = *ON
     C                   EXSR      AUDIT
     C                   ENDIF
      *
      ** Initialize Record Counts to zero.
      *
     C                   Z-ADD     0             RCOUNT                         *** Branch count ***
     C                   Z-ADD     0             RCOUNT2           5 0          *** Audit count  ***
      *
      ** Do Until End of File.
      *
     C                   DOU       *IN89 = *ON
      *
      ** Check if effective date is today.
      *
     C                   IF        ATYP = 'R' AND
     C                             ACEFDT <= CURDAT AND
     C                             ACEFDT > PRVDAT
      *
      ** Count records read.
      *
     C                   ADD       1             RCOUNT
     C                   ADD       1             RCOUNT2
      *
      ** Process Report Lines.
      *
     C                   EXSR      REPORT
     C                   ENDIF
      *
      ** Note branch for no records processing.
      *
     C                   MOVE      BRCA          PRBRCA            3
     C                   MOVE      BRNM          PRBRNM           20
      *
      ** Read next record.
      *
     C                   READ      ACCBR                                  89
      *
      ** Set branch to blank if end of file is reached.
      *
     C                   IF        *IN89 = *ON
     C                   EVAL      BRCA = *BLANKS
     C                   ENDIF
      *
      ** Check if branch has no records.
      *
     C                   IF        PRBRCA <> BRCA AND
     C                             RCOUNT = 0
     C                   SETON                                        10
     C                   EXSR      REPORT
     C                   WRITE     RE000567F2
     C                   SETOFF                                       10
     C                   Z-ADD     60            PRTLN1
     C                   CLOSE     RE000567P1
     C                   SETOFF                                       12
     C                   ENDIF
      *
      ** Check if Last Record for Branch.
      *
     C                   IF        PRBRCA <> BRCA AND
     C                             RCOUNT <> 0
     C                   SETON                                        1011
     C                   EXSR      REPORT
     C                   WRITE     RE000567F1
     C                   WRITE     RE000567F2
     C                   Z-ADD     0             RCOUNT
     C                   SETOFF                                       1011
     C                   Z-ADD     60            PRTLN1
     C                   CLOSE     RE000567P1
     C                   SETOFF                                       12
     C                   ENDIF
      *
      ** End of Do Until End of Valid Records.
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/REPORT
      *****************************************************************
      *                                                               *
      *  REPORT - Process Report Lines.                               *
      *                                                               *
      *  Called By: PROCES                                            *
      *  Calls:                                                       *
      *  WP1REC - Format and Write a Detail Record to the Report      *
      *                                                               *
      *****************************************************************
      *
     C     REPORT        BEGSR                                                  *** REPORT ***
      *
      *----------------------------------------------------------------
      *
      *    Perform any necessary processing before writing detail line
      *
      *----------------------------------------------------------------
      *
      ** Write out the record.
      *
     C                   EXSR      WP1REC
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/WP1REC
      *****************************************************************
      *                                                               *
      *  WP1REC - Subroutine to Write a Detail record to the Report.  *
      *                                                               *
      *  Called By: PROCES                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     WP1REC        BEGSR                                                  *** WP1REC ***
      *
      *----------------------------------------------------------------
      *
      ** Perform any formatting before printing via ZDATE2, ZSEDIT
      *
      *----------------------------------------------------------------
     C                   CALL      'ZDATE2'
     C                   PARM      DACO          ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVE      ZADATE        NDACO             7
      *
      ** Call Access Program for Customer Details - Customer Report Name
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      CNUM          @CNUM            10
     C                   PARM      *BLANKS       @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** Handle Database Error.
      *
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCUSTPD'                            ***************
     C                   EVAL      DBASE = 002                                    * DB ERROR 02 *
     C                   EXSR      *PSSR                                          ***************
     C                   ENDIF
      *
      ** Move Customer Report Name to Report.
      *
     C                   MOVE      BBCRNM        CRNM             20
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
      *
      ** Check that each branch is placed on a separate spool file.
      *
     C                   IF        *IN12 = *OFF
     C                   OPEN      RE000567P1
      *
      ** Register to RCF.
      *
     C                   EXSR      RCFP1
     C                   SETON                                        12
     C                   ENDIF
      *
      ** Write out Header Record.
      *
     C                   WRITE     RE000567HR
     C                   ENDIF
      *
      ** Write out Detail Record.
      *
     C                   WRITE     DETAIL
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/AUDIT
      *****************************************************************
      *                                                               *
      *  AUDIT  - Subroutine to Output Audit report and End Program.  *
      *                                                               *
      *  Called By: Main Processing, PROCES, *PSSR                    *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     AUDIT         BEGSR                                                  *** AUDIT ***
      *
      ** Output Report Header and File Controls.
      *
     C                   EXSR      RCFAU
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
      *
      ** If there is a DB Error, Output the DB Error Information.
      *
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
      *
      ** Or, if no records read, Output "No Details" message.
      *
     C                   IF        RCOUNT2 = 0
     C                   WRITE     NODTLS
     C                   ENDIF
     C                   ENDIF
      *
      ** End Program and Return.
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RCFP1 - SR to register the P1 PRTF via RCF.                   *
      *                                                               *
      * Called by: PROCES                                             *
      *                                                               *
      * Calls: ZSFILE                                                 *
      *                                                               *
      *****************************************************************
      *
     C     RCFP1         BEGSR
      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   EVAL      ZSNUM = SFNUM1
     C                   EVAL      ZFILE = SFILE1
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQ
     C                   PARM                    SENTY
     C                   PARM                    ZFILE
     C                   PARM                    ZSNUM
     C                   PARM      *BLANK        ZSERR
      *
      ** If error occurs during  SFILE processing, then return to the
      ** calling program.
      *
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *on
     C                   EVAL      *INU8 = *on
     C                   EVAL      *INLR = *on
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RCFAU - SR to register the AU PRTF via RCF.                  *
      *                                                               *
      *  Called by: *INZSR                                            *
      *                                                               *
      *  Calls: ZSFILE                                                *
      *                                                               *
      *****************************************************************
      *
     C     RCFAU         BEGSR
      *
      ** Ensure Audit Spool File recorded by RCF.
      *
     C                   EVAL      ZSNUM = SFNUMU
     C                   EVAL      ZFILE = SFILEU
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQ
     C                   PARM                    SENTY
     C                   PARM                    ZFILE
     C                   PARM                    ZSNUM
     C                   PARM      *BLANK        ZSERR
      *
      ** If error occurs during ZSFILE processing, then return to the
      ** calling program.
      *
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  *** PSSR ***
      *
      ** Check to see that *PSSR has not already been called.
      *
     C                   IF        WRUN = *BLANK
     C                   MOVE      'Y'           WRUN              1
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   EXSR      AUDIT
     C                   ENDIF
      *
      ** If *PSSR already run, then just end the program here.
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
