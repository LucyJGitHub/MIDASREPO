     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Journal Entry User Audit Report')             *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL0082   - Journal Entry User Audit Report                   *
      *                                                               *
      *  Function:  This program produces a report showing all        *
      *             Batches inserted, amended, deleted or accepted    *
      *             and the user and time the event occured.          *
      *                                                               *
      *  Called By: GLC0082 - Journal Entry Audit Report              *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. CGL082  *CREATE    Date 02Nov21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL082 - Journal Entry User Audit                            *
      *                                                               *
      *****************************************************************
     FGLJEAUL0  IF   E           K DISK    INFSR(*PSSR)
      * Journal Entry Extension file
      *
     FGL0082AU  O    E             PRINTER
     F                                     INFDS(SPOOLU)
     FGL0082P1  O    E             PRINTER
     F                                     INFDS(SPOOL1)
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   37  - Multibranching ON                                     *
      *   30  -  Called in I/C                                        *
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
      *  PROC1  - File Processing                                     *
      *  REPORT - Process Report Lines                                *
      *                                                               *
      *  WP1END - Write End of Report                                 *
      *                                                               *
      *  AUDIT  - Produce Audit Report and End Program                *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *  RCFP1  - RCF Processing for P1 Report                        *
      *  RCFAU  - RCF Processing for Audit Report                     *
      *                                                               *
      *****************************************************************
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
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
     D                 DS
     D  AUTIME                 1      6  0
     D  LHH                    1      2  0
     D  LMM                    3      4  0
     D  LSS                    5      6  0
     D SPOOL1          DS
      *
      **  File Information Data Structure for GL0082P1.
      *
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
     D SPOOLU          DS
      *
      **  File Information Data Structure for GL0082AU.
      *
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
      **  Dummy Data Structures used by Access Programs.
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      **  External data structures for Bank Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS Short DS to pass Access Object Details
      *
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      **  Perform Initialisation.
      *
     C                   EXSR      INIT
      *
      **  Perform Report Processing.
      *
     C                   EXSR      PROC1
      *
      **  Perform Program End
      *
     C                   EXSR      END
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
      *  RCFAU  - RCF Processing for Audit Report                     *
      *  RCFP1  - RCF Processing for Detail Report                    *
      *  AOBANKR0 Access Program                                      *
      *                                                               *
      *****************************************************************
      *
     C     INIT          BEGSR                                                  ***  INIT  ***
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Receive Parameter List.
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSEQ              5
     C                   PARM                    PENT              3
     C                   PARM                    PHASE             1
      *
      ** Initialise LDA field.
      *
     C                   MOVEL     'GL0082'      DBPGM
      *
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Handle Database Error.
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'SDBANKPD'    DBFILE                         ***************
     C                   Z-ADD     001           DBASE                          * DB ERROR 01 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
      *
      **  Check System Date Format, DDMMYY (*IN98 off)
      **                            MMDDYY (*IN98 on).
      *
     C     BJDFIN        IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
      *
      ** If report run in I/C SETON *IN30 to print 'INTERIM'.
      *
     C     PHASE         IFEQ      'A'
     C                   SETON                                        30
     C                   ENDIF
      *
      ** RCF Processing for Audit File.
      *
     C                   EXSR      RCFAU
      *
      ** RCF Processing for Detail File.
      *
     C                   EXSR      RCFP1
      *
      ** Report Work fields.
      *
     C                   Z-ADD     0             RQDLN1            3 0
     C                   Z-ADD     0             DIFLN1            3 0
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/PROC1
      *****************************************************************
      *                                                               *
      *  PROC1  - Subroutine to do the File Processing.               *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     PROC1         BEGSR                                                  *** PROC1  ***
      *
      ** Read through GLJEAUL0. This is keyed on Batch Number and Time
      ** print out the Insertion information, any amendment info and
      ** finally the Delete or Accept info.
      *
     C                   READ      GLJEAUL0                               89
      *
      ** Do Until End of File.
      *
     C     *IN89         DOUEQ     *ON
      *
      ** Write report record
      *
     C                   EXSR      REPORT
      *
     C                   ENDDO
      *
     C                   EXSR      WP1END
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/REPORT
      *****************************************************************
      *                                                               *
      *  REPORT - Subroutine to Write a Detail record to the Report.  *
      *                                                               *
      *  Called By: PROC1                                             *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     REPORT        BEGSR                                                  *** REPORT ***
      *
      ** Blank out report fields.
      *
     C                   MOVE      *BLANKS       L#BTNB
     C                   MOVE      *BLANKS       L#BDES
     C                   MOVE      *BLANKS       L#BRCA
     C                   MOVE      *BLANKS       L#DPCD
     C                   MOVE      *BLANKS       L#USID
     C                   MOVE      *BLANKS       L#ACTN
     C                   MOVE      *BLANKS       L#HH
     C                   MOVE      *BLANKS       L#MM
     C                   MOVE      *BLANKS       L#SS
      *
      ** Save Batch Number
      *
     C                   MOVEL     AUBTNB        LBATCH            3
      *
      ** Move file fields to Report fields.
      ** If Action is not Insert then move blanks to Batch Number,
      ** Batch Description and Branch.
      *
     C                   MOVEL     AUBTNB        L#BTNB
     C                   MOVE      AUDSCR        L#BDES
     C                   MOVEL     AUBRCA        L#BRCA
     C                   MOVEL     AUDPCD        L#DPCD
     C                   MOVE      AUUSID        L#USID
      *
      ** Format Action type
      *
     C                   SELECT
     C     AUACTN        WHENEQ    'I'
     C                   MOVE      'INSERT'      L#ACTN
     C     AUACTN        WHENEQ    'A'
     C                   MOVEL     'AMEND'       L#ACTN
     C     AUACTN        WHENEQ    'D'
     C                   MOVE      'DELETE'      L#ACTN
     C     AUACTN        WHENEQ    'X'
     C                   MOVE      'ACCEPT'      L#ACTN
     C     AUACTN        WHENEQ    'S'
     C                   MOVE      'SUBMIT'      L#ACTN
     C                   ENDSL
      *
      ** Format Time.
      *
     C                   MOVE      LHH           L#HH
     C                   MOVE      LMM           L#MM
     C                   MOVE      LSS           L#SS
      *
     C     AUACTN        IFNE      'I'
     C                   MOVE      *BLANKS       L#BTNB
     C                   ENDIF
      *
      ** If the first time through write out headers.
      *
     C     RQDLN1        IFEQ      0
     C                   WRITE     HEADPY
     C                   WRITE     HEADDT
     C                   ENDIF
      *
      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.
      *
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADPY
     C                   WRITE     HEADDT
      *
      ** Need also to display Batch, Number, Batch Description and
      ** Branch.
      *
     C                   MOVEL     AUBTNB        L#BTNB
     C                   MOVE      AUDSCR        L#BDES
     C                   MOVEL     AUBRCA        L#BRCA
     C                   ENDIF
      *
      ** Write out Detail Record.
      *
     C                   WRITE     DETAIL
      *
      ** Read next record on Extension file.
      *
     C                   READ      GLJEAUL0                               89
      *
      ** Want to have a blank line if Batch Number has changed
      *
     C     AUBTNB        IFNE      LBATCH
      *
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   ELSE
     C                   WRITE     DETBLK
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/WP1END
      *****************************************************************
      *                                                               *
      *  WP1END - Subroutine to Write End of Report.                  *
      *                                                               *
      *  Called By: PROC1                                             *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     WP1END        BEGSR                                                  *** WP1END ***
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     4             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADPY
     C                   ENDIF
      *
      **  Write out Total Format.
      *
     C                   WRITE     TRAILPY
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/AUDIT
      *****************************************************************
      *                                                               *
      *  AUDIT  - Subroutine to Output Audit report and End Program.  *
      *                                                               *
      *  Called By: *PSSR                                             *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     AUDIT         BEGSR                                                  *** AUDIT  ***
      *
      ** Output Report Header and File Controls.
      *
     C                   WRITE     HEADAU
      *
      ** If there is a DB Error, Output the DB Error Information.
      *
     C     *INU7         IFEQ      *ON
     C                   WRITE     DBERROR
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
      *
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   EXSR      AUDIT
     C                   ENDIF
      *
      ** If *PSSR already run, then just end the program here.
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/*END
      *****************************************************************
      *                                                               *
      *  END - End Program                                            *
      *                                                               *
      *****************************************************************
      *
     C     END           BEGSR                                                  ** END **
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/RCFP1
      *****************************************************************
      *                                                               *
      *  RCFP1  - Subroutine to register the P1 Printer File via RCF. *
      *                                                               *
      *****************************************************************
      *
     C     RCFP1         BEGSR                                                   *** RCFP1  ***
      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUM1        ZSNUM             6 0
     C                   MOVEL     PENT          SENTY
      *
     C                   CALL      'ZSFILE'
     C                   PARM      PSEQ          SEQ               5
     C                   PARM                    SENTY             3
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/RCFAU
      *****************************************************************
      *                                                               *
      *  RCFAU  - Subroutine to register the AU Printer File via RCF. *
      *                                                               *
      *****************************************************************
      *
     C     RCFAU         BEGSR                                                   *** RCFAU  ***
      *
      ** Ensure Audit Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUMU        ZSNUMU            6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM      PSEQ          SEQ
     C                   PARM      *BLANKS       SENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM      *BLANK        ZSERR
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2021
