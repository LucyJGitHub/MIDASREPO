     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ER Account Codes Decision Table List')           *
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting Module                            *
      *                                                               *
      *  ER000175 - Midas ER Account Codes Decision Table List        *
      *                                                               *
      *  Function: This program generates audit or lists details      *
      *            report of Account Code Decision table file.        *
      *                                                               *
      *  Called By: ERC000175 - Midas ER Account Codes Decision Table *
      *                         List.                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG26779           Date 27Nov09               *
      *                 CER045  *CREATE    Date 20Jul09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26779 - Change Request on GSART Table                     *
      *  CER045 - German Features - Reporting Bundesbank              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   50  - Mode = 'A'                                            *
      *  N50  - Mode = 'L'                                            *
      *                                                               *
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
      *  *INZSR   - Program Initialisation                            *
      *                                                               *
      *  SRPROC   - Detail Processing                                 *
      *  SRAUDIT  - Trailer and Database Error Reporting Routine      *
      *  SRFORMAT - File to Reporting Format Conversion               *
      *  SRWRTDET - Write a Detail record to the Report               *
      *                                                               *
      *  SRRCFAU - Registers the AU Printer File via RCF              *
      *  SRRCFP1 - Registers the P1 Printer File via RCF              *
      *                                                               *
      *  SRWRTEND - Write End of Report                               *
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *****************************************************************
 
      ** Midas ER Account Code Decision Table Printer file - Audit
 
     FER000175AUO    E             PRINTER
     F                                     INFDS(SPOOLU)
 
      ** Midas ER Account Code Decision Table Printer file - Details
 
     FER000175P1O    E             PRINTER
     F                                     USROPN
     F                                     INFDS(SPOOL1)
 
      ** Midas ER Account Code Decision Table
 
     FERDEACL1  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      ** Data Area giving Installation Control Details
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program Status Data Structure
 
     D SPOOL1          DS
 
      ** File Information Data Structure for ER000175P1
 
     D  OPNIN1                 9      9
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
     D SPOOLU          DS
 
      ** File Information Data Structure for ER000175AU
 
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
      ** External data structures for Bank Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structures for Account Codes
 
     D SDACOD        E DS                  EXTNAME(SDACODPD)
 
      ** Data structure for Access Objects
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D PMODE           S              1
     D PSEQ            S              5
 
      ** Parameters for Access Object Programs
 
     D PRtcd           S              7A
     D POptn           S              7A
     D PAccd           S             10A
 
     D WRun            S              1    INZ(*BLANK)
     D WSeq            S              5
     D WSenty          S              3
     D WZSNum1         S              6  0
     D WZSNumU         S              6  0
     D WSFile          S             10
     D WZSErr          S              1
     D WCount          S              5  0
     D RQDLN1          S              3  0
     D DIFLN1          S              3  0
     D ZFIELD          S             16
     D ZADEC           S              1P 0
     D ZDAYNO          S              5P 0
     D ZDATFMT         S              1
     D ZDATE           S              6P 0
     D ZCDATE          S              7
 
     D WEDTTME         C                   '  :  '
 
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
 
      ** Perform Detail Processing.
 
     C                   EXSR      SRPROC
 
      ** Output Audit Report and End Program.
 
     C                   EXSR      SRAUDIT
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
      *
      *****************************************************************
      /TITLE SR/SRPROC
      *****************************************************************
      *                                                               *
      *  SRPROC - Subroutine to do the Detail Processing.             *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:                                                       *
      *  SRAUDIT  - Produce Audit Report and End Program              *
      *  SRRCFP1  - Register the P1 Printer File via RCF              *
      *  SRFORMAT - File to Reporting Format Conversion               *
      *                                                               *
      *****************************************************************
     C     SRPROC        BEGSR
 
      ** Find first record to print.
 
     C     *LOVAL        SETLL     ERDEACL1
 
     C                   DOU       %EOF(ERDEACL1)  OR
     C                             PMODE = 'L'     OR
     C                             PMODE = 'A'     AND
     C                             N3LCD = BJRDNB
     C                   READ      ERDEACL1
     C                   ENDDO
 
      ** If End of Records, Perform: Audit Reporting (No Records)
      ** Register P1 printer file via RCF via SR/SRRCFP1
 
     C                   IF        NOT %EOF
 
     C                   EXSR      SRRCFP1
 
      ** Set the header
 
     C                   EVAL      *IN50 = *ON
     C                   IF        PMODE = 'L'
     C                   EVAL      *IN50 = *OFF
     C                   ENDIF
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Process all records until end of file
 
     C                   DOW       NOT %EOF(ERDEACL1)
 
     C                   IF        PMODE = 'L'     OR
     C                             PMODE = 'A'     AND
     C                             N3LCD = BJRDNB
 
      ** Count records read
 
     C                   EVAL      WCount = WCount + 1
 
      ** Process Report Lines
 
     C                   EXSR      SRFORMAT
 
     C                   ENDIF
 
      ** Read next record
 
     C                   READ      ERDEACL1
 
      ** End of Do Until End of Valid Records
 
     C                   ENDDO
 
      ** Write final records and Totals to Report.
 
     C                   IF        OPNIN1 = '1'
     C                   EXSR      SRWRTEND
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRAUDIT
      *****************************************************************
      *                                                               *
      *  SRAUDIT - Trailer and Database Error Reporting Routine       *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  SRPROC - Detail Processing                                   *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *  Calls:                                                       *
      *  SRRCFAU - Registers the AU Printer File via RCF              *
      *                                                               *
      *****************************************************************
     C     SRAUDIT       BEGSR
 
      ** Register AU Printer File via RCF through SR/SRRCFAU
 
     C                   EXSR      SRRCFAU
 
      ** Output Report Header and File Controls
 
     C                   WRITE     HEADAU
 
      ** If there is a DB Error, Output the DB Error Information
 
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
 
      ** Or, if no records read, Output "No Details" message
 
     C                   IF        WCount = 0
     C                   WRITE     NODTLS
     C                   ELSE
     C                   EVAL      RCOUNT = WCount
     C                   WRITE     CONTROL
     C                   ENDIF
     C                   ENDIF
 
      ** End Program and Return
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRFORMAT
      *****************************************************************
      *                                                               *
      *  SRFORMAT - File to Reporting Format Conversion               *
      *                                                               *
      *  Called By:                                                   *
      *  SRPROC - Subroutine to do the Detail Processing.             *
      *                                                               *
      *  Calls:                                                       *
      *  ZDATE2 - Convert Midas Day Number into Date (DDMMYY/MMDDYY)  *
      *  SRWRTDET - Write a Detail record to the Report               *
      *                                                               *
      *****************************************************************
     C     SRFORMAT      BEGSR
 
     C                   CLEAR                   DETAIL
 
      ** Format file fields for report
 
     C                   EVAL      R3ACOD = N3ACOD
 
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      N3ACOD        PAccd
     C     SDACOD        PARM      SDACOD        DSFDY
 
     C                   EVAL      R3ACCN = A5ACCN
     C                   EVAL      R3ACTY = A5ACTY
 
     C                   EVAL      R3GRI  = N3GRI
     C                   EVAL      R3BUCL = N3BUCL
     C                   MOVE      N3BUSU        R3BUSU
     C                   EVAL      R3BUTY = N3BUTY                                          BUG26779
 
     C                   CALL      'ZDATE2'
     C                   PARM      N3LCD         ZDAYNO
     C                   PARM      BJDFIN        ZDATFMT
     C                   PARM      *ZEROS        ZDATE
     C                   PARM      *BLANK        ZCDATE
     C                   EVAL      R3LCD  = ZCDATE
 
     C                   SELECT
     C                   WHEN      N3TYLC = 'I'
     C                   EVAL      R3CHTP = 'INSERT'
     C                   WHEN      N3TYLC = 'A'
     C                   EVAL      R3CHTP = 'AMEND'
     C                   ENDSL
 
      ** Write out the record
 
     C                   EXSR      SRWRTDET
 
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRWRTDET
      *****************************************************************
      *                                                               *
      *  SRWRTDET - Subroutine to Write a Detail record to the Report *
      *                                                               *
      *  Called By:                                                   *
      *  SRFORMAT - File to Reporting Format Conversion               *
      *                                                               *
      *  Calls:                                                       *
      *  None.                                                        *
      *                                                               *
      *****************************************************************
     C     SRWRTDET      BEGSR
 
      ** Check that sufficient lines remain for the Format, if not,
      ** write out the Main Headings on a new page
 
     C                   EVAL      RQDLN1  = 3
     C                   EVAL      DIFLN1  = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Write out Detail Record
 
     C                   WRITE     DETAIL
 
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRRCFAU
      *****************************************************************
      *                                                               *
      *  SRRCFAU - Subroutine to register the AU Printer File via RCF *
      *                                                               *
      *  Called By:                                                   *
      *  SRAUDIT  - Trailer and Database Error Reporting Routine      *
      *                                                               *
      *  Calls:                                                       *
      *  ZSFILE                                                       *
      *                                                               *
      *****************************************************************
     C     SRRCFAU       BEGSR
 
      ** Ensure Audit Spool File recorded by RCF
 
     C                   Z-ADD     SFNUMU        WZSNumU
 
     C                   CALL      'ZSFILE'
     C                   PARM      PSEQ          WSeq
     C                   PARM      *BLANKS       WSenty
     C                   PARM                    SFILEU
     C                   PARM                    WZSNumU
     C                   PARM      *BLANK        WZSErr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program
 
     C                   IF        WZSErr = 'Y'
     C                   EVAL      *INU7  = *ON
     C                   EVAL      *INU8  = *ON
     C                   EVAL      *INLR  = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRRCFP1
      *****************************************************************
      *                                                               *
      *  SRRCFP1 - Subroutine to register the P1 Printer File via RCF *
      *                                                               *
      *  Called By:                                                   *
      *  SRPROC   - Detail Processing                                 *
      *                                                               *
      *  Calls:                                                       *
      *  None.                                                        *
      *                                                               *
      *****************************************************************
     C     SRRCFP1       BEGSR
 
     C                   OPEN      ER000175P1
 
      ** Ensure Report Spool File recorded by RCF
 
     C                   Z-ADD     SFNUM1        WZSNum1
 
     C                   CALL      'ZSFILE'
     C                   PARM      PSEQ          WSeq
     C                   PARM                    WSenty
     C                   PARM                    SFILE1
     C                   PARM                    WZSNum1
     C                   PARM                    WZSErr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program
 
     C                   IF        WZSErr = 'Y'
     C                   EVAL      *INU7  = *ON
     C                   EVAL      *INU8  = *ON
     C                   EVAL      *INLR  = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /TITLE SR/SRWRTEND
      *****************************************************************
      *                                                               *
      *  SRWRTEND - Subroutine to Write End of Report                 *
      *                                                               *
      *  Called By:                                                   *
      *  SRPROC   - Detail Processing                                 *
      *                                                               *
      *  Calls:                                                       *
      *****************************************************************
     C     SRWRTEND      BEGSR
 
     C                   EVAL      RQDLN1 = 4
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Write out Total Format
 
     C                   WRITE     TRAILP1
     C                   CLOSE     ER000175P1
 
     C                   ENDSR
      *****************************************************************
      /TITLE SR/PROCES
      *****************************************************************
      *                                                               *
      *  *INZSR - Subroutine to do Program Initialisation.            *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Receive Parameter List
 
     C     *ENTRY        PLIST
     C                   PARM                    PMODE
     C                   PARM                    PSEQ
 
      ** Setup local dataarea (LDA)
 
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  = 'ER000175'
     C                   EVAL      DBASE  = *ZEROS
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY  = *BLANKS
     C                   EVAL      DBMOD  = *BLANKS
     C                   EVAL      DBPROC = *BLANKS
     C                   OUT       LDA
 
      ** Call Access Program for Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtcd  <>  *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE  =   'SDBANKPD'
     C                   EVAL      DBASE   =   002
     C                   EVAL      DBKEY   =   POptn
     C                   EVAL      DBPGM   =   'ER000175'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialize work fields
 
     C                   EVAL      WCount   = 0
 
     C                   ENDSR
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
 
      ** Check to see that *PSSR has not already been called.
 
     C                   IF        WRUN = *BLANKS
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
     C                   EXSR      SRAUDIT
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
