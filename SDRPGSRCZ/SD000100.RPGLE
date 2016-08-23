     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Customer Segmentation Report')                *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000100 - Customer Segmentation Report                      *
      *                                                               *
      *  Function:  This module will produce a report automatically   *
      *             in close of business showing details of retail    *
      *             accounts becoming effective today.                *
      *                                                               *
      *  Last Amend No. AR820987           Date 30Aug11               *
      *  Prev Amend No. CSD090  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR820987 - Other details values in Customer Segmentation     *
      *             List Report are not displayed                     *
      *  CSD090 - Customer Segmentation and Overdraft                 *
      *                                                               *
      *****************************************************************
     FSDCSEGL0  IF   E           K DISK    INFSR(*PSSR)
      ** Customer Segmentation Codes
 
     FSD000100AUO    E             PRINTER INFDS(SPOOLU)
      ** Audit Report
 
     FSD000100P1O    E             PRINTER INFDS(SPOOL1) USROPN
      ** Accounts becoming effective today
 
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
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
      ** File Information Data Structure for SD000100P1.
      *
     DSPOOL1           DS
     DSFILE1                  83     92
     DSFNUM1                 123    124B 0
     DOFLLN1                 188    189B 0
     DPRTLN1                 367    368B 0
      *
     DSPOOLU           DS
      ** File Information Data Structure for SD000100AU.
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
      *                                                                                     AR820987
     DCSTMST           DS                                                                   AR820987
     D DSYYYYMMDD              1     10                                                     AR820987
     D DSHOUR                 12     13  0                                                  AR820987
     D DSMINS                 15     16  0                                                  AR820987
     D DSSECS                 18     19  0                                                  AR820987
      *                                                                                     AR820987
     D                 DS                                                                   AR820987
     D PRHOUR                         2  0                                                  AR820987
     D PRMINS                         2  0                                                  AR820987
     D PRSECS                         2  0                                                  AR820987
     D CSLCTM                  1      6  0                                                  AR820987
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
     C     INIT          BEGSR
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
     C                   EVAL      DBPGM = 'SD000100'
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
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
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
     C     PROCES        BEGSR
      *
      ** Read first record from File.
      *
     C                   READ      SDCSEGL0                               89
      *
      ** If End of Records, (*IN89), Perform: Audit Reporting (No
      ** Records).
      *
     C                   IF        *IN89 = *ON
     C                   EXSR      AUDIT
     C                   ENDIF
      *
      ** Open printer file
      *
     C                   OPEN      SD000100P1
     C                   EXSR      RCFP1
     C                   WRITE     SD000100HR
      *
      ** Initialize Record Counts to zero.
      *
     C                   Z-ADD     0             RCOUNT
      *
      ** Do Until End of File.
      *
     C                   DOU       *IN89 = *ON
      *
      ** Count records read.
      *
     C                   ADD       1             RCOUNT
      *
      ** Process Report Lines.
      *
     C                   EXSR      REPORT
      *
      ** Read next record.
      *
     C                   READ      SDCSEGL0                               89
      *
      ** End of Do Until End of Valid Records.
      *
     C                   ENDDO
      *
      ** Write the footer
      *
     C                   EXSR      WP1END
      *
     C                   ENDSR
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
     C     REPORT        BEGSR
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
     C     WP1REC        BEGSR
      *
      *----------------------------------------------------------------
      *
      ** Perform any formatting before printing via ZDATE2, ZSEDIT
      *
      *----------------------------------------------------------------
      *
      ** Change format for Last Change Date (CSLCDT)
      *
     C                   CALL      'ZDATE2'
     C                   PARM      CSLCDT        ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVE      ZADATE        NCSLCD            7
      *                                                                                     AR820987
     C                   EVAL      CSLCTM = 0                                               AR820987
     C                   IF        CSTMST <> *BLANKS                                        AR820987
     C                   EVAL      PRHOUR = DSHOUR                                          AR820987
     C                   EVAL      PRMINS = DSMINS                                          AR820987
     C                   EVAL      PRSECS = DSSECS                                          AR820987
     C                   ENDIF                                                              AR820987
      *
      ** Convert Change Type to words
      *
     C                   MOVE      *BLANKS       NCSCTP            6
     C                   SELECT
     C     CSLCTY        WHENEQ    'I'
     C                   MOVE      'INSERT'      NCSCTP
     C     CSLCTY        WHENEQ    'A'
     C                   MOVE      'AMEND'       NCSCTP
     C     CSLCTY        WHENEQ    'D'
     C                   MOVE      'DELETE'      NCSCTP
     C                   END
      *
      ***  Check that sufficient lines remain for the Format. If not,
      ***  write out the Main Headings on a new page.
      *
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     SD000100HR
     C                   ENDIF
      *
      ***  Write out Detail Record.
      *
     C                   WRITE     DETAIL
      *
     C                   ENDSR
      *
      *****************************************************************
      *
      /TITLE SR/WP1END
      *****************************************************************
      *                                                               *
      *  WP1END - Subroutine to Write End of Report.                  *
      *                                                               *
      *  Called By: PROCES                                            *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     WP1END        BEGSR
      *
      ***  Check that sufficient lines remain for the Format. If not,
      ***  write out the Main Headings on a new page.
      *
     C                   Z-ADD     4             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     SD000100HR
     C                   ENDIF
      *
      ***  Write out Total Format.
      *
     C                   WRITE     SD000100F1
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
     C     AUDIT         BEGSR
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
     C                   ENDIF
      *
      ** End Program and Return.
      *
     C                   WRITE     ENDREPT
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
     C     *PSSR         BEGSR
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
