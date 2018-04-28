     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas TI Report duplicate TI accounts')
      *****************************************************************
      *                                                               *
      *  Midas - TI Module                                            *
      *                                                               *
      *  TI000000 - Report duplicate TI Accounts                      *
      *                                                               *
      *  Function:  This program reports duplicate TI accounts.       *
      *                                                               *
      *  Called By: None                                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. BUG27963*RENAMED   Date 09Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 BUG5340 *CREATE    Date 06Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG27963 - Renamed from CN5340.                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG5340 - Report Duplicate TI Accounts                       *
      *                                                               *
      *****************************************************************
     FACCNTTI   IF   E           K DISK    INFSR(*PSSR)
     F*CN5340P1*O    E             PRINTER                                                  BUG27963
     FTI000000P1O    E             PRINTER                                                  BUG27963
     F                                     INFDS(SPOOL1)
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   37  - Multibranching ON                                     *
      *                                                               *
      *   89  - End of File                                           *
      *                                                               *
      *   98  - Date Format: DDMMYY (off); MMDDYY (on)                *
      * 90-99 - Used by Standard Subroutines                          *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      /SPACE 3
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
      *                                                               *
      *  AUDIT  - Produce Audit Report and End Program                *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *  ZSEDIT - Edit an Amount                                      *
      *                                                               *
      *****************************************************************
     D/EJECT
     D*CPY@*****       S             80    DIM(1) CTDATA PERRCD(1)                          BUG27963
      **********                                                                            BUG27963
      ***Array*containing*Copyright*statement*                                              BUG27963
      *
     D LDA           E DS           256    EXTNAME(LDA)
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
     D SPOOL1          DS
      *
      **  File Information Data Structure for MMNNNNPY.
      *
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
      ** Dummy Data Structures used by Access Programs.
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External data structures for Bank Details
      *
     C/TITLE Main Processing
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
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      *                                                               *
      *  INIT   - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *  ZDAT   -
      *  ZDAT   -
      *  AOBANKR0 Access Program                                      *
      *                                                               *
      *****************************************************************
      *
     C     INIT          BEGSR                                                  ***  INIT  ***
      *
      ***Set*up*copyright*parameter*                                                        BUG27963
      **********                                                                            BUG27963
     C**********         MOVEA     CPY@          CPY2@            80                        BUG27963
      *
      ** Initialise LDA field.
      *
     C                   MOVEL     'BUG5340'     DBPGM
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
     C     WRTCD         IFNE      *BLANKS
     C                   MOVE      'SDBANKPD'    DBFILE                         ***************
     C                   Z-ADD     001           DBASE                          * DB ERROR 01 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
      *
      ** Check System Date Format, DDMMYY (*IN98 off)
      **                           MMDDYY (*IN98 on).
      *
     C     BJDFIN        IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
      *
      ** Access RUNDAT for multibranching indicator
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
      ** Report Work fields.
      *
     C                   Z-ADD     0             RQDLN1            3 0
     C                   Z-ADD     0             DIFLN1            3 0
      *
     C                   Z-ADD     0             RCOUNT            6 0
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
      *  WP1END - Write End of Report                                 *
      *                                                               *
      *****************************************************************
      *
     C     PROCES        BEGSR                                                  *** PROCES ***
      *
      ** Read first record from File.
      *
     C                   READ      ACCNTTI                                89
      *
      ** If End of Records, (*IN89), Perform: Audit Reporting (No
      ** Records).
      *
     C     *IN89         IFEQ      *ON
     C                   EXSR      AUDIT
     C                   ENDIF
      *
      ** Do Until End of File.
      *
     C     *IN89         DOUEQ     *ON
     C     A5TIAC        IFEQ      'Y'
      *
      ** Count records read.
      *
     C                   ADD       1             RCOUNT
      *
      ** Process Report Lines.
      *
     C                   EXSR      REPORT
     C                   ENDIF
      *
      ** Read next record.
      *
     C                   READ      ACCNTTI                                89
      *
      ** End of Do Until End of Valid Records.
     C                   ENDDO
      *
      ** Write final records and Totals to Report.
      *
     C                   EXSR      REPORT
     C                   EXSR      WP1END
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
      ** Compare to previous account details
      *
     C     PRBRCA        IFEQ      BRCA
     C     PRTIAN        ANDEQ     A5TIAN
     C     PRTIAS        ANDEQ     A5TIAS
      *
      ** Write out the record.
      *
     C                   EXSR      WP1REC
     C                   MOVE      *OFF          *IN50
      *
     C                   ELSE
     C                   MOVE      *ON           *IN50
     C                   MOVE      BRCA          PRBRCA
     C                   MOVE      CNUM          PRCNUM
     C                   MOVE      CCY           PRCCY
     C                   MOVE      ACOD          PRACOD
     C                   MOVE      ACSQ          PRACSQ
     C     ACNO          IFEQ      0
     C                   MOVE      *BLANKS       PRACNO
     C                   ELSE
     C                   MOVE      ACNO          PRACNO
     C                   ENDIF
     C                   MOVE      A5TIAC        PRTIAC
     C                   MOVE      A5TIAN        PRTIAN
     C                   MOVE      A5TIAS        PRTIAS
     C                   ENDIF
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
     C                   MOVE      BRCA          ZABRCA
     C                   MOVE      CNUM          ZACNUM
     C                   MOVE      CCY           ZACCY
     C                   MOVE      ACOD          ZAACOD
     C                   MOVE      ACSQ          ZAACSQ
     C                   MOVE      ACNO          ZAACNO
     C                   MOVE      A5TIAC        ZATIAC
     C                   MOVE      A5TIAN        ZATIAN
     C                   MOVE      A5TIAS        ZATIAS
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADPY
     C                   ENDIF
      *
      ** Write out Detail Record.
      *
     C                   WRITE     DETAIL
      *
     C                   ENDSR
      *
      *****************************************************************
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
     C     WP1END        BEGSR                                                  *** WP1END ***
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     7             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADPY
     C                   ENDIF
      *
      ** Write out Total Format.
      *
     C                   WRITE     TRAILPY
      *
      *
      ** End Program and Return.
      *
     C                   SETON                                        LR
     C                   RETURN
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
     C     AUDIT         BEGSR                                                  *** AUDIT  ***
      *
      ** If there is a DB Error, Output the DB Error Information.
      *
     C     *INU7         IFEQ      *ON
     C                   WRITE     DBERROR
     C                   ELSE
      *
      ** Or, if no records read, Output "No Details" message.
      *
     C     RCOUNT        IFEQ      0
     C                   WRITE     NODTLS
     C                   ENDIF
     C                   ENDIF
      *
      ** End Program and Return.
      *
     C                   SETON                                        LR
     C                   RETURN
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
     C     *PSSR         BEGSR                                                  ** *PSSR **
      *
      ** Check to see that *PSSR has not already been called.
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
     C                   MOVE      'ACCNTTI'     DBFILE
      *
     C     *DTAARA       DEFINE    LDA           WLDA            256
     C     *LOCK         IN        WLDA
     C                   OUT       WLDA
      *
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   EXSR      AUDIT
     C                   ENDIF
      *
      ***  If *PSSR already run, then just end the program here.
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
