     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SD Local Tax Office Statement')
      *****************************************************************
      *                                                               *
      *  Midas - German Withholding Tax Module                        *
      *                                                               *
      *  SD200205 - Local Tax Office Statement                        *
      *                                                               *
      *  Function:  This report shows a summary line per Tax Type of  *
      *             the credit interest generated within the Retail   *
      *             and Dealing Money Market modules and manual       *
      *             postings entered via Journal Entry with narrative *
      *             'K3' since the first of the current month for all *
      *             customer whether liable to Withholding tax or not *
      *                                                               *
      *  (phase(s)) Call during End of Month Processing               *
      *                                                               *
      *  Called By: RPG/SDC200205 - Local Tax Office Statement        *
      *                                                               *
      *  (C) Copyright Midas-Kapiti International Ltd. 2009           *
      *                                                               *
      *  Last Amend No. MD034216           Date 24Apr15               *
      *  Prev Amend No. AR752509           Date 01May11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG25533           Date 19Aug09               *
      *                 BUG24672B          Date 17Jul09               *
      *                 BUG24672A          Date 14Jul09               *
      *                 BUG24672           Date 03Jul09               *
      *                 CER054  *CREATE    Date 07Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD034216 - SDC200205 Failed during COB run                   *
      *  AR752509 - SDCHTXPD and SDWTGSPD are empty (Child:AR752510)  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG25533 - Non Generation of Withholding Tax per Federal     *
      *             State Report during Input Cycle and after COB     *
      *             (Applied BUG24714 fix)                            *
      *  BUG24714 - Non Generation of Withholding Tax per Federal     *
      *             State Report during Input Cycle and after COB     *
      *  BUG24672B - Local Tax Office Summary shows 'No details to    *
      *             report'                                           *
      *  BUG24672A - Local Tax Office Summary shows 'No details to    *
      *             report'                                           *
      *  BUG24672 - Local Tax Office Summary shows 'No details to     *
      *             report'                                           *
      *  CER054 - German Feature - Church Tax                         *
      *                                                               *
      *****************************************************************
      /TITLE FUNCTION OF INDICATORS
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *  ===========================================                  *
      *                                                               *
      *   88  - Access File                                           *
      *   89  - End of File                                           *
      *                                                               *
      *   98  - Date Format: DDMMYY (off); MMDDYY (on)                *
      * 90-99 - Used by Standard Subroutines                          *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      /TITLE SUBROUTINE INDEX
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *  ===============================                              *
      *                                                               *
      *  INIT   - Program Initialisation                              *
      *  PROCES - Detail Processing                                   *
      *  BRBRK  - Subroutine to process a change in branch            *
      *  TXBRK  - Subroutine to Write a Detail record to the Report.  *
      *  CUMUL  - Subroutine to Add the amounts and the totals        *
      *  TOTAL  - Subroutine to Write a Total record to the Report.   *
      *                                                               *
      *  WP1REC - Format and Write a Detail Record to the Report      *
      *  WP1END - Write End of Report                                 *
      *                                                               *
      *  AUDIT  - Produce Audit Report and End Program                *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *  RCFP1  - RCF Processing for P1 Report                        *
      *  RCFAU  - RCF Processing for Audit Report                     *
      *                                                               *
      *  ZDATE2 - Convert Midas Day Number into Date (DDMMYY/MMDDYY)  *
      *  ZDAT10 - Convert YYYYMMDD to Midas Day number.               *                    BUG24672B
      *  ZSEDIT - Edit an Amount                                      *
      *                                                               *
      *****************************************************************
      /TITLE FILES DESCRIPTION
      *****************************************************************
      *
      ** Local Tax Office File:Retrieve Index
     FSDLTOFL1  IF   E           K DISK
      *                                                                                     BUG24714
      ** Midas FC Report Requests Requests by Rep/Seq                                       BUG24714
     FFCRREQL1  IF   E           K DISK                                                     BUG24714
      *
      ** Midas CB COB Compnts by Name & Seq. No.                                            BUG24714
     FCBCOMSL0  IF   E           K DISK                                                     BUG24714
      *                                                                                     BUG24714
      ** Religious Affiliation
     FSDRLAFPD  IT   F   77        DISK
      *
      ** Federal State Codes
     FSDGESTPD  IT   F   78        DISK
      *
      ** Extract Files
     FSDCHTXPD  O    E           K DISK
     FSDWTGSPD  O    E           K DISK
     FSDCTGSPD  O    E           K DISK                                                     BUG24714
      *
     FSD200205AUO    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
      *
     FSD200205P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
      *****************************************************************
      /TITLE E-SPECIFICATIONS
      *****************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D ZYDY            S              4  0 DIM(4) CTDATA PERRCD(4)              ZDATE1/2 SR.ARRAY
     D ZMDY            S              3  0 DIM(13) CTDATA PERRCD(13)            ZDATE1/2 SR.ARRAY
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)            ZDATE2 SR. ARRAY
     D MON             S             15    DIM(12) CTDATA PERRCD(1)
     D ZS2             S              1    DIM(21)
      *
      *** Tables for Additional spreadsheet
      *
     D***ARC             S             77    DIM(40) FROMFILE(SDRLAFPD) PERRCD(1)           MD034216
     D***ARCT            S             15  0 DIM(40)                                        MD034216
     D***ARCO            S             15  0 DIM(40)                                        MD034216
     D***ARCS            S             15  0 DIM(40)                                        MD034216
     D***ARCB            S             15  0 DIM(40)                                        MD034216
     D***ARB             S             78    DIM(20) FROMFILE(SDGESTPD) PERRCD(1)           MD034216
     D***ARBT            S             15  0 DIM(20)                                        MD034216
     D***ARBO            S             15  0 DIM(20)                                        MD034216
     D***ARBS            S             15  0 DIM(20)                                        MD034216
     D***ARBB            S             15  0 DIM(20)                                        MD034216
      *
     D***ARDT            S             15  0 DIM(20)                               BUG24714 MD034216
     D***ARDO            S             15  0 DIM(20)                               BUG24714 MD034216
     D***ARDS            S             15  0 DIM(20)                               BUG24714 MD034216
     D***ARDB            S             15  0 DIM(20)                               BUG24714 MD034216
      *                                                                                     BUG24714
     D ARC             S             77    DIM(95) FROMFILE(SDRLAFPD) PERRCD(1)             MD034216
     D ARCT            S             15  0 DIM(95)                                          MD034216
     D ARCO            S             15  0 DIM(95)                                          MD034216
     D ARCS            S             15  0 DIM(95)                                          MD034216
     D ARCB            S             15  0 DIM(95)                                          MD034216
      *                                                                                     MD034216
     D ARB             S             78    DIM(90) FROMFILE(SDGESTPD) PERRCD(1)             MD034216
     D ARBT            S             15  0 DIM(90)                                          MD034216
     D ARBO            S             15  0 DIM(90)                                          MD034216
     D ARBS            S             15  0 DIM(90)                                          MD034216
     D ARBB            S             15  0 DIM(90)                                          MD034216
                                                                                            MD034216
     D ARDT            S             15  0 DIM(90)                                          MD034216
     D ARDO            S             15  0 DIM(90)                                          MD034216
     D ARDS            S             15  0 DIM(90)                                          MD034216
     D ARDB            S             15  0 DIM(90)                                          MD034216
      *                                                                                     MD034216
     D WCSEQ           S              5A                                                    BUG24714
     D KRNAM           S             10A                                                    BUG24714
     D KRQSQ           S              5A                                                    BUG24714
     D KCOMP           S             10A                                                    BUG24714
     D KCSEQ           S              5A                                                    BUG24714
      *                                                                                     BUG24714
     C/COPY ZSRSRC,ZDATE9Z1LE
     C/COPY ZSRSRC,ZDAT10Z1LE                                                              BUG24672B
      *
      *****************************************************************
      /TITLE I-SPECIFICATIONS
      *****************************************************************
      *
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
      ** Program data structure.
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      *
      ** File Information Data Structure for SD200205P1.
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
      ** File Information Data Structure for SD200205AU.
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
      **  Dummy Data Structures used by Access Programs.
      *
      ** DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS for Religious Affiliation Code File Format
     D SDRLAF        E DS                  EXTNAME(SDRLAFPD)
      *
      ** External DS for Federal State Code File Format
     D SDGEST        E DS                  EXTNAME(SDGESTPD)
      *
      **
     D SDCSIN        E DS                  EXTNAME(SDCSINPD)
      *
      **
     D SDACTX        E DS                  EXTNAME(SDACTXPD)
      *
     D                 DS
     D  WORK15                 1     15  0
     D  ZS1                    1     15  0
     D                                     DIM(15)
      *
     D PParm           DS           100
     D**WFRDT***               1      8                                                    BUG24672A
     D**WTODT***               9     16                                                    BUG24672A
     D**WFRDT***               1      6                                          BUG24672A BUG24672B
     D**WTODT***               7     12                                          BUG24672A BUG24672B
     D  WFRDT                  1      8                                                    BUG24672B
     D  WTODT                  9     16                                                    BUG24672B
      *
      **   Declared variables
      *
     D CER054          S              1A
     D CPY2@           S             80A
     D PRSeq           S              5A
     D PRLev           S              1A
     D PREnt           S              3A
     D PRAct           S              1A
     D PRCmd           S              1A
     D ZSERR           S              1A
     D WRTREC          S              1A
     D ISFND           S              1A
     D ZECODE          S              1A
     D WWTAXT          S              2A
     D WWBRCA          S              3A
     D @RTCD           S              7A
     D @OPTN           S              7A
     D @SARD           S              6A
     D WRTCD           S              7A
     D WOPTN           S              7A
     D WRUN            S              1
     D WFIRST          S              1
     D I               S              2  0
     D ZDECS           S              1  0
     D ZFLD15          S             15  0
     D ZSNUM           S              6  0
     D ZSNUMU          S              6  0
     D @@DAYN          S              5  0
     D RQDLN1          S              3  0
     D DIFLN1          S              3  0
     D WCOUNT          S             15  0
     D WFRDAT          S              8A                                                   BUG24672A
     D WTODAT          S              8A                                                   BUG24672A
     D WYEAR           S              2A                                                   BUG24672A
     D WDAYS           S              2A                                                   BUG24672A
     D WMNTH           S              2A                                                   BUG24672A
     D WNYEAR          S              4A                                                   BUG24672A
      *
     C/COPY ZSRSRC,ZDATE9Z2LE
      *
      /EJECT
      *****************************************************************
      **         P R O G R A M    S T A R T                           *
      *****************************************************************
      *
      ** SQL error trapping
     C/EXEC SQL WHENEVER SQLERROR GO TO TAGSQLERR
     C/END-EXEC
      *
      * Declare pointer
     C/EXEC SQL DECLARE CSIN_CURSOR CURSOR FOR
     C+ SELECT
     C+ TSIPDT, TSBRCA, AXETXS, TSGINC,
     C+ TSTXSC, TSNINC, TSSTDT, TSTTDT,
     C+ TSRLAF, TSSTCD, TSTTDO, TSTTDS,
     C+ TSTTDB, TSTXSR, TSTXSS, TSTXSB,
     C+ TSTCDP
     C+ FROM SDCSINPD JOIN SDACTXPD
     C+ ON TSCUST = AXCUST AND TSCTRT = AXCTTX
     C+ ORDER BY TSBRCA, AXETXS, TSIPDT
     C/END-EXEC
      *
      ** Execute query
     C/EXEC SQL
     C+ OPEN CSIN_CURSOR
     C/END-EXEC
      *
      ** Execute initial processing
     C                   EXSR      INIT
      *                                                                                     BUG24714
      ** For Mandatory Reports                                                              BUG24714
     C                   EXSR      SRMandRep                                                BUG24714
      *                                                                                     BUG24714
      ** Perform Detail Processing.
     C                   EXSR      PROCES
      *
      ** Disable pointer
     C/EXEC SQL
     C+ CLOSE CSIN_CURSOR
     C/END-EXEC
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C     TAGSQLERR     TAG
     C                   EXSR      *PSSR
      *
      *****************************************************************
      **         P R O G R A M    E N D                               *
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
     C     PROCES        BEGSR
      *
      ** Read first record from File.
     C/EXEC SQL
     C+ FETCH CSIN_CURSOR INTO
     C+ :TSIPDT, :TSBRCA, :AXETXS, :TSGINC,
     C+ :TSTXSC, :TSNINC, :TSSTDT, :TSTTDT,
     C+ :TSRLAF, :TSSTCD, :TSTTDO, :TSTTDS,
     C+ :TSTTDB, :TSTXSR, :TSTXSS, :TSTXSB,
     C+ :TSTCDP
     C/END-EXEC
      *
      ** Do while End of File.
     C     SQLCOD        DOWEQ     0
      *
      ** Only include records with a posting date in this month
      *
     C**********         MOVE      TSIPDT        ZDAYNO                                    BUG24672B
     C                   MOVE      TSIPDT        ZZDTIN                                    BUG24672B
     C                   EXSR      ZDAT10                                                  BUG24672B
     C                   MOVE      ZZMDNO        ZDAYNO                                    BUG24672B
     C                   EXSR      ZDATE2
      *
     C*****PParm         IFNE      *BLANKS                                                 BUG24672B
     C                   IF        WFRDT <> *BLANKS AND                                    BUG24672B
     C                             WTODT <> *BLANKS                                        BUG24672B
     C*****TSIPDT        IFGE      WFRDT                                                   BUG24672A
     C*****TSIPDT        ANDLE     WTODT                                                   BUG24672A
     C*****TSIPDT        IFGE      WFRDAT                                        BUG24672A BUG24672B
     C*****TSIPDT        ANDLE     WTODAT                                        BUG24672A BUG24672B
     C     TSIPDT        IFGE      WFRDT                                                   BUG24672B
     C     TSIPDT        ANDLE     WTODT                                                   BUG24672B
     C                   MOVE      'Y'           WRTREC
     C                   ELSE
     C                   MOVE      'N'           WRTREC
     C                   ENDIF
      *
     C                   ELSE
      *
     C     ZMTH          IFEQ      ZRMNTH
     C                   MOVE      'Y'           WRTREC
     C                   ELSE
     C                   MOVE      'N'           WRTREC
     C                   ENDIF
     C                   ENDIF
      *
     C     WRTREC        IFEQ      'Y'
      *
      ** Count records read.
     C                   ADD       1             WCOUNT
      *
      ** If first time processing
     C                   IF        WCSEQ = '00001' OR WCSEQ = '10001'                       BUG24714
     C     WFIRST        IFEQ      'Y'                                          - B3
     C                   MOVE      'N'           WFIRST
     C                   EXSR      BRBRK
     C                   ELSE                                                   - X3
      *
      ** If change of branch
     C     TSBRCA        IFNE      WWBRCA                                       - B4
     C                   EXSR      TXBRK
     C                   EXSR      TOTAL
     C                   EXSR      BRBRK
     C                   ELSE                                                   - X4
      *
      ** If change of Tax type
     C     AXETXS        IFNE      WWTAXT                                       - B5
     C                   EXSR      TXBRK
     C                   ENDIF                                                  - E5
     C                   ENDIF                                                  - E4
     C                   ENDIF                                                  - E3
     C                   ENDIF                                                              BUG24714
      *
      ** Add the amounts and totals
     C                   EXSR      CUMUL
     C                   ENDIF                                                  - E2
      *
      ** Read next record.
     C/EXEC SQL
     C+ FETCH CSIN_CURSOR INTO
     C+ :TSIPDT, :TSBRCA, :AXETXS, :TSGINC,
     C+ :TSTXSC, :TSNINC, :TSSTDT, :TSTTDT,
     C+ :TSRLAF, :TSSTCD, :TSTTDO, :TSTTDS,
     C+ :TSTTDB, :TSTXSR, :TSTXSS, :TSTXSB,
     C+ :TSTCDP
     C/END-EXEC
      *
     C                   ENDDO                                                  - E1
      *
      ** Last record
     C     WCOUNT        IFNE      0                                            - B1
     C                   IF        WCSEQ = '00001' OR WCSEQ = '10001'                       BUG24714
     C                   EXSR      TXBRK
     C                   EXSR      TOTAL
     C                   ENDIF                                                              BUG24714
      *
      ***  German Withholding Tax - Church Tax Processing
      *
     C     CER054        IFEQ      'Y'
      *
      *** Summary by Religious Affiliation code
      *
     C                   IF        WCSEQ = '00003' OR WCSEQ = '10003'                       BUG24714
     C                   EXSR      CONFES
     C                   ENDIF                                                              BUG24714
      *                                                                                     BUG24714
      *** Summary by Church Tax - State Code                                                BUG24714
      *                                                                                     BUG24714
     C                   IF        WCSEQ = '00004' OR WCSEQ = '10004'                       BUG24714
     C                   EXSR      CHSTATE                                                  BUG24714
     C                   ENDIF                                                              BUG24714
      *                                                                                     BUG24714
     C                   ENDIF
      *
      *** Summary by State code
      *
     C                   IF        WCSEQ = '00002' OR WCSEQ = '10002'                       BUG24714
     C                   EXSR      BUNDES
     C                   ENDIF                                                              BUG24714
      *
     C                   CLOSE     SD200205P1
      *
      ** Audit Reporting (No Records)
     C                   ELSE                                                   - X1
     C                   EXSR      AUDIT
     C                   ENDIF                                                  - E1
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/CUMUL
      *****************************************************************
      *                                                               *
      *  CUMUL  - Subroutine to Add the amounts and the totals        *
      *                                                               *
      *  Called By: PROCES                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     CUMUL         BEGSR
      *
      ** Totals Taxe Type
     C                   ADD       TSGINC        WGINTD
     C                   ADD       TSTXSC        WWHTB
     C                   ADD       TSNINC        WNINTD
     C                   ADD       TSSTDT        WSCNB
      *
     C     CER054        IFEQ      'Y'
     C                   ADD       TSTTDT        WCHTB
     C                   ENDIF
      *
      ** Total of the overall amounts
     C                   ADD       TSGINC        TGINTD
     C                   ADD       TSTXSC        TWHTB
     C                   ADD       TSNINC        TNINTD
     C                   ADD       TSSTDT        TSCNB
      *
     C     CER054        IFEQ      'Y'
     C                   ADD       TSTTDT        TCHTB
     C                   ENDIF
      *
      ***  Store Total for Additional Sheets
      *
     C     CER054        IFEQ      'Y'
      *
      ***  Search Religious Affiliation
      *
     C                   Z-ADD     1             I
     C                   MOVE      'N'           ISFND
     C     ISFND         DOWEQ     'N'
     C                   MOVEA     ARC(I)        SDRLAF
     C     AFRLAF        IFEQ      TSRLAF
     C                   MOVE      'Y'           ISFND
     C                   ELSE
     C     AFRLAF        IFEQ      '  '
     C                   MOVE      'S'           ISFND
     C                   ELSE
     C                   ADD       1             I
     C*****I****         IFGT      40                                                       MD034216
     C     I             IFGT      95                                                       MD034216
     C                   MOVE      'Z'           ISFND
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
      ***  Cumulate the Church Tax Amounts
      *
     C     ISFND         IFEQ      'Y'
     C                   ADD       TSTTDT        ARCT(I)
     C                   ENDIF
     C                   ADD       TSTTDO        ARCO(I)
     C                   ADD       TSTTDS        ARCS(I)
     C                   ADD       TSTTDB        ARCB(I)
     C                   ENDIF
      *
     C                   Z-ADD     1             I
     C                   MOVE      'N'           ISFND
     C     ISFND         DOWEQ     'N'
     C                   MOVEA     ARB(I)        SDGEST
     C     GESTCD        IFEQ      TSSTCD
     C                   MOVE      'Y'           ISFND
     C                   ELSE
     C     GESTCD        IFEQ      '  '
     C                   MOVE      'S'           ISFND
     C                   ELSE
     C                   ADD       1             I
     C*****I****         IFGT      20                                                       MD034216
     C     I             IFGT      90                                                       MD034216
     C                   MOVE      'Z'           ISFND
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
      ***  Cumulate the Withholding Tax Amounts
      *
     C     ISFND         IFEQ      'Y'
     C                   ADD       TSTXSC        ARBT(I)
     C                   ADD       TSTXSR        ARBO(I)
     C                   ADD       TSTXSS        ARBS(I)
     C                   ADD       TSTXSB        ARBB(I)
     C                   ENDIF
      *
     C     CER054        IFEQ      'Y'                                                      BUG24714
     C                   ADD       TSTTDT        ARDT(I)                                    BUG24714
     C                   ADD       TSTTDO        ARDO(I)                                    BUG24714
     C                   ADD       TSTTDS        ARDS(I)                                    BUG24714
     C                   ADD       TSTTDB        ARDB(I)                                    BUG24714
     C                   ENDIF                                                              BUG24714
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/TXBRK
      *****************************************************************
      *                                                               *
      *  TXBRK  - Subroutine to Write a Detail record to the Report.  *
      *                                                               *
      *  Called By: PROCES                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     TXBRK         BEGSR
      *
      *
      ** Format the fields
     C                   Z-ADD     TSTCDP        ZDECS
     C                   MOVE      'J'           ZECODE
      *
     C                   MOVEL     WWTAXT        PRCTAX
      *
     C                   Z-ADD     WGINTD        ZFLD15
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        PRGIND
      *
     C                   Z-ADD     WWHTB         ZFLD15
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        PRTXDD
      *
     C                   Z-ADD     WNINTD        ZFLD15
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        PRNIND
      *
     C                   Z-ADD     WSCNB         ZFLD15
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        PRSOZD
      *
     C     CER054        IFEQ      'Y'
     C                   Z-ADD     WCHTB         ZFLD15
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        PRCHTB
     C                   ENDIF
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
     C                   Z-ADD     2             RQDLN1
      *
     C     CER054        IFEQ      'Y'
     C                   ADD       1             RQDLN1
     C                   ENDIF
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
      *
      ** Write out Detail Record.
     C                   WRITE     DETAIL
      *
      ** Initialize fields
     C                   MOVEL     AXETXS        WWTAXT
     C                   Z-ADD     0             WGINTD
     C                   Z-ADD     0             WWHTB
     C                   Z-ADD     0             WNINTD
     C                   Z-ADD     0             WSCNB
      *
     C     CER054        IFEQ      'Y'
     C                   Z-ADD     0             WCHTB
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/TOTAL
      *****************************************************************
      *                                                               *
      *  TOTAL  - Subroutine to Write a Total record to the Report.   *
      *                                                               *
      *  Called By: PROCES                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     TOTAL         BEGSR
      *
      ** Format the fields
     C                   Z-ADD     TSTCDP        ZDECS
     C                   MOVE      'J'           ZECODE
      *
     C                   Z-ADD     TGINTD        ZFLD15
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        PRGIND
      *
     C                   Z-ADD     TWHTB         ZFLD15
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        PRTXDD
      *
     C                   Z-ADD     TNINTD        ZFLD15
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        PRNIND
      *
     C                   Z-ADD     TSCNB         ZFLD15
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        PRSOZD
      *
     C     CER054        IFEQ      'Y'
     C                   Z-ADD     TCHTB         ZFLD15
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        PRCHTB
     C                   ENDIF
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
     C                   Z-ADD     2             RQDLN1
      *
     C     CER054        IFEQ      'Y'
     C                   ADD       1             RQDLN1
     C                   ENDIF
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
      *
      ** Write out Total Record.
     C                   WRITE     TOTALP1
      *
      ** Initialize fields
     C                   Z-ADD     0             TGINTD
     C                   Z-ADD     0             TWHTB
     C                   Z-ADD     0             TNINTD
     C                   Z-ADD     0             TSCNB
      *
     C     CER054        IFEQ      'Y'
     C                   Z-ADD     0             TCHTB                          Church Tax Overall
     C                   ENDIF
      *
      ** Write out End Record.
     C                   EXSR      WP1END
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/BRBRK
      *****************************************************************
      *                                                               *
      *  BRBRK  - Subroutine to process a change in branch            *
      *                                                               *
      *  Called By: PROCES                                            *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
     C     BRBRK         BEGSR
      *
     C                   CLOSE     SD200205P1
     C                   OPEN      SD200205P1
      *
     C                   MOVEL     TSBRCA        WWBRCA
     C                   MOVEL     AXETXS        WWTAXT
      *
      ** Access Extension file
     C     TSBRCA        CHAIN     SDLTOFL1                           88
     C     *IN88         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      'SDLTOFL1'    DBFILE                         ***************
     C                   Z-ADD     004           DBASE                          * DB ERROR 04 *
     C                   MOVEL     TSBRCA        DBKEY                          ***************
     C                   MOVEL     'SD200205'    DBPGM
     C                   SETON                                          U7U8
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Ensure Report Spool File recorded by RCF
      ** A report by branch and ALL branch must be printed
     C                   MOVE      TSBRCA        PREnt
      *
     C                   EXSR      RCFP1
      *
      ** Output report header
     C                   MOVEL     MON(ZMTH)     PRMONT
     C                   MOVEL     TSBRCA        PRBRCA
     C                   MOVEL     LTOFNM        PRTONA
     C                   MOVEL     LTOFRN        PRTONO
     C                   WRITE     HEADP1
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/CONFES
      *****************************************************************
      *                                                               *
      *  CONFES - Sheet 1 - Monthly Control Report -                  *
      *  ------   Total By Religious Affiliation                      *
      *                                                               *
      *****************************************************************
     C     CONFES        BEGSR
      *
      ***  Create a new Spool as it is not Branch dependent
      *
     C                   CLOSE     SD200205P1
     C                   OPEN      SD200205P1
     C                   MOVE      'ALL'         PREnt
      *
     C                   EXSR      RCFP1
      *
     C                   MOVEL     MON(ZMTH)     PRMONT
      *
      ***  Output Header Sheet 1
      *
     C                   WRITE     SHT1HP1
      *
      ***  For every Religious Affiliation, output Total of Church Tax
      *
     C                   Z-ADD     TSTCDP        ZDECS                                     BUG24714
     C                   MOVE      'J'           ZECODE                                    BUG24714
     C                   Z-ADD     1             I
     C*****I****         DOWLT     40                                                       MD034216
     C     I             DOWLT     95                                                       MD034216
      *
     C                   MOVEA     ARC(I)        SDRLAF
     C     AFRLAF        IFNE      '  '
     C                   MOVEL     AFRLAF        PRFCOD
     C                   MOVEL     AFNARR        PRFDSC
     C                   Z-ADD     ARCT(I)       ZFLD15
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        PRCHTX
      *
      ***  Output Detail Sheet 1
      *
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     SHT1HP1
     C                   ENDIF
      *
     C                   WRITE     SHT1DP1
      *
     C*****PParm         IFEQ      *BLANKS                                                  AR752509
     C                   IF        WFRDT = *BLANKS AND                                      AR752509
     C                             WTODT = *BLANKS                                          AR752509
     C                   EXSR      EXTRRA
     C                   ENDIF
      *
     C                   ELSE
     C**********         Z-ADD     40            I                                          MD034216
     C                   Z-ADD     95            I                                          MD034216
     C                   ENDIF
      *
     C                   ADD       1             I
     C                   ENDDO
      *
      ***  Output total of Church Tax for the whole Religious Affiliation
      *
     C                   XFOOT     ARCT          ZFLD15
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        PRTOTC
      *
      ***  Output Total  Sheet 1
      *
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     SHT1HP1
     C                   ENDIF
      *
     C                   WRITE     SHT1TP1
      *
      ***  Output Trailer Sheet 1
      *
     C                   Z-ADD     4             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     SHT1HP1
     C                   ENDIF
      *
     C                   WRITE     TRAILP1
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/BUNDES
      *****************************************************************
      *                                                               *
      *  BUNDES - Sheet 2 - Monthly Control Report -                  *
      *  ------   Total By State Code                                 *
      *                                                               *
      *****************************************************************
     C     BUNDES        BEGSR
      *
      ***  Create a new Spool as it is not Branch dependent
      *
     C                   CLOSE     SD200205P1
     C                   OPEN      SD200205P1
     C                   MOVE      'ALL'         PREnt
      *
     C                   EXSR      RCFP1
      *
     C                   MOVEL     MON(ZMTH)     PRMONT
      *
      ***  Output Header Sheet 2
      *
     C                   WRITE     SHT2HP1
      *
      ***  For every Federal State Code, Output Total of Withholding Tax
      *
     C                   Z-ADD     TSTCDP        ZDECS                                     BUG24714
     C                   MOVE      'J'           ZECODE                                    BUG24714
     C                   Z-ADD     1             I
     C*****I****         DOWLT     20                                                       MD034216
     C     I             DOWLT     90                                                       MD034216
      *
     C                   MOVEA     ARB(I)        SDGEST
     C     GESTCD        IFNE      '  '
     C     ARBT(I)       ORNE      0
     C     GESTCD        IFNE      '  '
     C                   MOVEL     GESTCD        PRLCOD
     C                   MOVEL     GESTNM        PRLBND
     C                   ELSE
     C                   MOVEL     'ND'          PRLCOD
     C     'NOT DEFI'    CAT(P)    'NED':0       PRLBND
     C                   ENDIF
     C                   Z-ADD     ARBT(I)       ZFLD15
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        PRWHTX
      *
      ***  Output Detail Sheet 2
      *
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     SHT2HP1
     C                   ENDIF
      *
     C                   WRITE     SHT2DP1
      *
     C*****PParm         IFEQ      *BLANKS                                                  AR752509
     C                   IF        WFRDT = *BLANKS AND                                      AR752509
     C                             WTODT = *BLANKS                                          AR752509
     C                   EXSR      EXTRGS
     C                   ENDIF
      *
     C                   ELSE
     C**********         Z-ADD     20            I                                          MD034216
     C                   Z-ADD     90            I                                          MD034216
     C                   ENDIF
      *
     C                   ADD       1             I
     C                   ENDDO
      *
      ***  Output total of Church Tax for the whole Religious Affiliation
      *
     C                   XFOOT     ARBT          ZFLD15
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        PRTOTB
      *
      ***  Output Total  Sheet 2
      *
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     SHT2HP1
     C                   ENDIF
      *
     C                   WRITE     SHT2TP1
      *
      ***  Output Trailer Sheet 1
      *
     C                   Z-ADD     4             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     SHT2HP1
     C                   ENDIF
      *
     C                   WRITE     TRAILP1
      *
     C                   ENDSR
      *****************************************************************                     BUG24714
      /TITLE SR/CHSTATE                                                                     BUG24714
      *****************************************************************                     BUG24714
      *                                                               *                     BUG24714
      *  CHSTATE - Sheet 3 - Monthly Control Report -                 *                     BUG24714
      *  ------    Total By Church Tax State Code                     *                     BUG24714
      *                                                               *                     BUG24714
      *****************************************************************                     BUG24714
     C     CHSTATE       BEGSR                                                              BUG24714
      *                                                                                     BUG24714
      ***  Create a new Spool as it is not Branch dependent                                 BUG24714
      *                                                                                     BUG24714
     C                   CLOSE     SD200205P1                                               BUG24714
     C                   OPEN      SD200205P1                                               BUG24714
     C                   MOVE      'ALL'         PREnt                                      BUG24714
      *                                                                                     BUG24714
     C                   EXSR      RCFP1                                                    BUG24714
      *                                                                                     BUG24714
     C                   MOVEL     MON(ZMTH)     PRMONT                                     BUG24714
      *                                                                                     BUG24714
      ***  Output Header Sheet 3                                                            BUG24714
      *                                                                                     BUG24714
     C                   WRITE     SHT3HP1                                                  BUG24714
      *                                                                                     BUG24714
      ***  For every Federal State Code, Output Total of Church Tax                         BUG24714
      *                                                                                     BUG24714
     C                   Z-ADD     TSTCDP        ZDECS                                      BUG24714
     C                   MOVE      'J'           ZECODE                                     BUG24714
     C                   Z-ADD     1             I                                          BUG24714
     C*****I****         DOWLT     20                                              BUG24714 MD034216
     C     I             DOWLT     90                                                       MD034216
      *                                                                                     BUG24714
     C                   MOVEA     ARB(I)        SDGEST                                     BUG24714
     C     GESTCD        IFNE      '  '                                                     BUG24714
     C     ARDT(I)       ORNE      0                                                        BUG24714
     C     GESTCD        IFNE      '  '                                                     BUG24714
     C                   MOVEL     GESTCD        PRSTCD                                     BUG24714
     C                   MOVEL     GESTNM        PRSTNM                                     BUG24714
     C                   ELSE                                                               BUG24714
     C                   MOVEL     'ND'          PRSTCD                                     BUG24714
     C     'NOT DEFI'    CAT(P)    'NED':0       PRSTNM                                     BUG24714
     C                   ENDIF                                                              BUG24714
     C                   Z-ADD     ARDT(I)       ZFLD15                                     BUG24714
     C                   EXSR      ZSEDIT                                                   BUG24714
     C                   MOVE      ZOUT21        PR3DTX                                     BUG24714
      *                                                                                     BUG24714
      ***  Output Detail Sheet 3                                                            BUG24714
      *                                                                                     BUG24714
     C                   Z-ADD     1             RQDLN1                                     BUG24714
     C     OFLLN1        SUB       PRTLN1        DIFLN1                                     BUG24714
     C     DIFLN1        IFLE      RQDLN1                                                   BUG24714
     C                   WRITE     SHT3HP1                                                  BUG24714
     C                   ENDIF                                                              BUG24714
      *                                                                                     BUG24714
     C                   WRITE     SHT3DP1                                                  BUG24714
      *                                                                                     BUG24714
     C     PParm         IFEQ      *BLANKS                                                  BUG24714
     C                   EXSR      EXTRGSCT                                                 BUG24714
     C                   ENDIF                                                              BUG24714
      *                                                                                     BUG24714
     C                   ELSE                                                               BUG24714
     C**********         Z-ADD     20            I                                 BUG24714 MD034216
     C                   Z-ADD     90            I                                          MD034216
     C                   ENDIF                                                              BUG24714
      *                                                                                     BUG24714
     C                   ADD       1             I                                          BUG24714
     C                   ENDDO                                                              BUG24714
      *                                                                                     BUG24714
      ***  Output total of Church Tax for the whole State Code                              BUG24714
      *                                                                                     BUG24714
     C                   XFOOT     ARDT          ZFLD15                                     BUG24714
     C                   EXSR      ZSEDIT                                                   BUG24714
     C                   MOVE      ZOUT21        PRTOTD                                     BUG24714
      *                                                                                     BUG24714
      ***  Output Total  Sheet 3                                                            BUG24714
      *                                                                                     BUG24714
     C                   Z-ADD     1             RQDLN1                                     BUG24714
     C     OFLLN1        SUB       PRTLN1        DIFLN1                                     BUG24714
     C     DIFLN1        IFLE      RQDLN1                                                   BUG24714
     C                   WRITE     SHT3HP1                                                  BUG24714
     C                   ENDIF                                                              BUG24714
      *                                                                                     BUG24714
     C                   WRITE     SHT3TP1                                                  BUG24714
      *                                                                                     BUG24714
      ***  Output Trailer Sheet 3                                                           BUG24714
      *                                                                                     BUG24714
     C                   Z-ADD     4             RQDLN1                                     BUG24714
     C     OFLLN1        SUB       PRTLN1        DIFLN1                                     BUG24714
     C     DIFLN1        IFLE      RQDLN1                                                   BUG24714
     C                   WRITE     SHT3HP1                                                  BUG24714
     C                   ENDIF                                                              BUG24714
      *                                                                                     BUG24714
     C                   WRITE     TRAILP1                                                  BUG24714
      *                                                                                     BUG24714
     C                   ENDSR                                                              BUG24714
      *****************************************************************
      /TITLE SR/RCFP1
      *****************************************************************
      *                                                               *
      *  RCFP1  - Subroutine to register the P1 Printer File via RCF. *
      *                                                               *
      *****************************************************************
     C     RCFP1         BEGSR
      *
      ** Ensure Report Spool File recorded by RCF.
     C                   Z-ADD     SFNUM1        ZSNUM
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PRSeq
     C                   PARM                    PREnt
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM      *BLANKS       ZSERR
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
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
     C     WP1END        BEGSR
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
     C                   Z-ADD     4             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
      *
      ** Write out Total Format.
     C                   WRITE     TRAILP1
      *
     C                   ENDSR
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
     C     AUDIT         BEGSR
      *
      ***  RCF Processing
      *
     C                   OPEN      SD200205AU
     C                   EXSR      RCFAU
      *
      ** If there is a DB Error, Output the DB Error Information.
     C     *INU7         IFEQ      *ON
     C     *INU8         OREQ      *ON
     C                   WRITE     HEADAU
     C                   WRITE     DBERROR
     C                   ELSE
      *
      ** Or, if no records read, Output "No Details" message.
     C     WCOUNT        IFEQ      0
     C                   WRITE     HEADAU
     C                   WRITE     NODTLS
     C                   ENDIF
     C                   ENDIF
      *
      ** End Program and Return.
     C                   CLOSE     SD200205AU
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/EXTRRA
      *****************************************************************
      *                                                               *
      *  EXTRRA - Subroutine which will write the third tax amounts   *
      *           per Religious Affiliation to new output file        *
      *           SDCHTXPD.                                           *
      *                                                               *
      *  Called By: CONFES                                            *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
     C     EXTRRA        BEGSR
      *
     C                   MOVE      AFRLAF        CXRLAF
     C                   MOVE      AFNARR        CXNARR
     C                   MOVE      ARCO(I)       CXTTDO
     C                   MOVE      ARCS(I)       CXTTDS
     C                   MOVE      ARCT(I)       CXTTDT
     C                   MOVE      ARCB(I)       CXTTDB
      *
     C                   WRITE     SDCHTXD0
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/EXTRGS
      *****************************************************************
      *                                                               *
      *  EXTRGS - Subroutine which will write the withholding tax     *
      *           amounts per State to a new output file SDWTGSPD.    *
      *                                                               *
      *  Called By: BUNDES                                            *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
     C     EXTRGS        BEGSR
      *
     C                   MOVE      GESTCD        GSSTCD
     C                   MOVE      GESTNM        GSSTNM
     C                   MOVE      ARBO(I)       GSTXSR
     C                   MOVE      ARBS(I)       GSTXSS
     C                   MOVE      ARBT(I)       GSTXSC
     C                   MOVE      ARBB(I)       GSTXSB
      *
     C                   WRITE     SDWTGSD0
      *
     C                   ENDSR
      *
      *****************************************************************                     BUG24714
      /TITLE SR/EXTRGSCT                                                                    BUG24714
      *****************************************************************                     BUG24714
      *                                                               *                     BUG24714
      *  EXTRGSCT - Subroutine which will write the third tax amounts *                     BUG24714
      *             per State to a new output file SDCTGSPD.          *                     BUG24714
      *                                                               *                     BUG24714
      *  Called By: CHSTATE                                           *                     BUG24714
      *  Calls: None.                                                 *                     BUG24714
      *                                                               *                     BUG24714
      *****************************************************************                     BUG24714
     C     EXTRGSCT      BEGSR                                                              BUG24714
      *                                                                                     BUG24714
     C                   MOVE      GESTCD        GTSTCD                                     BUG24714
     C                   MOVE      GESTNM        GTSTNM                                     BUG24714
     C                   MOVE      ARBO(I)       GTTXSR                                     BUG24714
     C                   MOVE      ARBS(I)       GTTXSS                                     BUG24714
     C                   MOVE      ARBT(I)       GTTXSC                                     BUG24714
     C                   MOVE      ARBB(I)       GTTXSB                                     BUG24714
      *                                                                                     BUG24714
     C                   WRITE     SDCTGSD0                                                 BUG24714
      *                                                                                     BUG24714
     C                   ENDSR                                                              BUG24714
      *                                                                                     BUG24714
      *****************************************************************
      /TITLE SR/INIT
      *****************************************************************
      *                                                               *
      *  INIT   - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *  RCFAU  - RCF Processing for Audit Report                     *
      *  AOBANKR0 Access Program                                      *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Set up copyright parameter
     C                   MOVEA     CPY@          CPY2@
      *
      ***  Initialise LDA field.
     C     *DTAARA       DEFINE                  LDA
      *
      ***  Witholding Tax Enhancement for Church Tax Processing
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CER054'      @SARD
      *
     C                   MOVE      'N'           CER054
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CER054
     C                   MOVE      *ON           *IN51
     C                   ENDIF
      *
     C                   Z-ADD     *ZEROS        ARCT
     C                   Z-ADD     *ZEROS        ARCO
     C                   Z-ADD     *ZEROS        ARCS
     C                   Z-ADD     *ZEROS        ARCB
      *
     C                   Z-ADD     *ZEROS        ARBT
     C                   Z-ADD     *ZEROS        ARBO
     C                   Z-ADD     *ZEROS        ARBS
     C                   Z-ADD     *ZEROS        ARBB
      *
      ***  Call Access Program for Bank Details - Title, Run Date and
      ***  Run Day Number.
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     WRTCD
     C                   PARM      '*FIRST '     WOPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     WRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      'SDBANKPD'    DBFILE                         ***************
     C                   Z-ADD     001           DBASE                          * DB ERROR 01 *
     C                   MOVEL     *BLANKS       DBKEY                          ***************
     C                   MOVEL     'SD200205'    DBPGM
     C                   SETON                                          U7U8
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Check System Date Format, DDMMYY (*IN98 off)
      ***                            MMDDYY (*IN98 on).
     C     BJDFIN        IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
      *
      ** Format Rundate
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZMTH          ZRMNTH
      *
      ** Set up print of month
     C                   MOVEL     MON(ZMTH)     PRMONT
      *
     C                   MOVE      BJRDNB        @@DAYN
     C                   EXSR      ZDATE9
     C                   MOVEL     @@VDT         CXXDAT
     C                   MOVEL     @@VDT         GSXDAT
      *
     C     PParm         IFNE      *BLANKS
     C                   SETOFF                                       53
     C                   ELSE
     C                   SETON                                        53
     C                   ENDIF
      *                                                                                    BUG24672A
      ** Convert date parameters from DDMMYY to YYYYMMDD                                   BUG24672A
      *                                                                                    BUG24672A
      ** From Date                                                                         BUG24672A
     C                   EVAL      WDAYS = %SUBST(WFRDT:1:2)                               BUG24672A
     C                   EVAL      WMNTH = %SUBST(WFRDT:3:2)                               BUG24672A
     C                   EVAL      WYEAR = %SUBST(WFRDT:5:2)                               BUG24672A
     C                   IF        WYEAR >= '90'                                           BUG24672A
     C                   EVAL      WNYEAR = '19' + WYEAR                                   BUG24672A
     C                   ELSE                                                              BUG24672A
     C                   EVAL      WNYEAR = '20' + WYEAR                                   BUG24672A
     C                   ENDIF                                                             BUG24672A
     C                   EVAL      WFRDAT = WNYEAR + WMNTH + WDAYS                         BUG24672A
      *                                                                                    BUG24672A
      * To Date                                                                            BUG24672A
     C                   EVAL      WDAYS = %SUBST(WTODT:1:2)                               BUG24672A
     C                   EVAL      WMNTH = %SUBST(WTODT:3:2)                               BUG24672A
     C                   EVAL      WYEAR = %SUBST(WTODT:5:2)                               BUG24672A
     C                   IF        WYEAR >= '90'                                           BUG24672A
     C                   EVAL      WNYEAR = '19' + WYEAR                                   BUG24672A
     C                   ELSE                                                              BUG24672A
     C                   EVAL      WNYEAR = '20' + WYEAR                                   BUG24672A
     C                   ENDIF                                                             BUG24672A
     C                   EVAL      WTODAT = WNYEAR + WMNTH + WDAYS                         BUG24672A
      *
      ** Report Work fields.
     C                   Z-ADD     0             RQDLN1
     C                   Z-ADD     0             DIFLN1
     C                   Z-ADD     0             WCOUNT
     C                   MOVE      'Y'           WFIRST
      *
      ** FIELDS
     C     *LIKE         DEFINE    ZMTH          ZRMNTH
      *
     C     *LIKE         DEFINE    TSGINC        WGINTD          + 1            BY TAX TYPE
     C     *LIKE         DEFINE    TSGINC        TGINTD          + 1            OVERALL
      *
     C     *LIKE         DEFINE    TSNINC        WNINTD          + 1            BY TAX TYPE
     C     *LIKE         DEFINE    TSNINC        TNINTD          + 1            OVERALL
      *
     C     *LIKE         DEFINE    TSTXSC        WWHTB           + 1            BY TAX TYPE
     C     *LIKE         DEFINE    TSTXSC        TWHTB           + 1            OVERALL
      *
     C     *LIKE         DEFINE    TSSTDT        WSCNB           + 1            BY TAX TYPE
     C     *LIKE         DEFINE    TSSTDT        TSCNB           + 1            OVERALL
      *
      ***  Church Tax enhancement
      *
     C     CER054        IFEQ      'Y'
     C     *LIKE         DEFINE    TSTTDT        WCHTB           + 1            BY TAX TYPE
     C     *LIKE         DEFINE    TSTTDT        TCHTB           + 1            OVERALL
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************                     BUG24714
      /TITLE SR/SROnReq                                                                     BUG24714
      *****************************************************************                     BUG24714
      *                                                               *                     BUG24714
      *  SROnReq - Subroutine that will check the component sequence  *                     BUG24714
      *            for On Request Reports                             *                     BUG24714
      *                                                               *                     BUG24714
      *  Called By: SRMandRep                                         *                     BUG24714
      *  Calls: None                                                  *                     BUG24714
      *                                                               *                     BUG24714
      *****************************************************************                     BUG24714
     C     SROnReq       BEGSR                                                              BUG24714
      *                                                                                     BUG24714
     C                   EVAL      KRNAM = 'SD200205'                                       BUG24714
     C                   EVAL      KRQSQ = PRSeq                                            BUG24714
      *                                                                                     BUG24714
     C     KFCRREQ       KLIST                                                              BUG24714
     C                   KFLD                    KRNAM                                      BUG24714
     C                   KFLD                    KRQSQ                                      BUG24714
      *                                                                                     BUG24714
     C     KFCRREQ       CHAIN     FCRREQL1                                                 BUG24714
     C                   IF        %FOUND                                                   BUG24714
     C                   EVAL      WCSEQ = D5CSEQ                                           BUG24714
     C                   ELSE                                                               BUG24714
     C                   EVAL      DBKEY  = KRNAM                                           BUG24714
     C                   EVAL      DBFILE = 'FCRREQPD'                                      BUG24714
     C                   EVAL      DBASE  =  002                                            BUG24714
     C                   EXSR      *PSSR                                                    BUG24714
     C                   ENDIF                                                              BUG24714
      *                                                                                     BUG24714
     C                   ENDSR                                                              BUG24714
      *                                                                                     BUG24714
      *****************************************************************                     BUG24714
      /TITLE SR/SRMandRep                                             *                     BUG24714
      *****************************************************************                     BUG24714
      *                                                               *                     BUG24714
      *  SRMandRep - Subroutine that will assign the component sequence                     BUG24714
      *              for Mandatory Reports                            *                     BUG24714
      *                                                               *                     BUG24714
      *  Called By: MAIN                                              *                     BUG24714
      *  Calls: None                                                  *                     BUG24714
      *                                                               *                     BUG24714
      *****************************************************************                     BUG24714
     C     SRMandRep     BEGSR                                                              BUG24714
      *                                                                                     BUG24714
     C                   EVAL      KCOMP = 'SDC200205'                                      BUG24714
     C                   EVAL      KCSEQ = PRSeq                                            BUG24714
      *                                                                                     BUG24714
     C     KCBCMPN       KLIST                                                              BUG24714
     C                   KFLD                    KCOMP                                      BUG24714
     C                   KFLD                    KCSEQ                                      BUG24714
      *                                                                                     BUG24714
     C     KCBCMPN       CHAIN     CBCOMSL0                                                 BUG24714
     C                   IF        %FOUND                                                   BUG24714
     C                   EVAL      PRSeq = *BLANKS                                          BUG24714
     C                   EVAL      WCSEQ = DHCSEQ                                           BUG24714
     C                   ELSE                                                               BUG24714
     C                   EXSR      SROnReq                                                  BUG24714
     C                   ENDIF                                                              BUG24714
      *                                                                                     BUG24714
     C                   ENDSR                                                              BUG24714
      *                                                                                     BUG24714
      *****************************************************************
      /TITLE SR/RCFAU
      *****************************************************************
      *                                                               *
      *  RCFAU  - Subroutine to register the AU Printer File via RCF. *
      *                                                               *
      *****************************************************************
     C     RCFAU         BEGSR
      *
      ** Ensure Audit Spool File recorded by RCF.
     C                   Z-ADD     SFNUMU        ZSNUMU
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PRSeq
     C                   PARM      *BLANKS       PREnt
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM      *BLANK        ZSERR
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
      ** Check to see that *PSSR has not already been called.
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN
      *
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   EXSR      AUDIT
     C                   DUMP
     C                   ENDIF
      *
      ** If *PSSR already run, then just end the program here.
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PRSeq
     C                   PARM                    PRLev
     C                   PARM                    PREnt
     C                   PARM                    PParm                                      BUG24672
     C                   PARM                    PRAct
     C                   PARM                    PRCmd
 
     C                   ENDSR
      *****************************************************************
     C/COPY ZSRSRC,ZDATE2Z2LE
     C/COPY ZSRSRC,ZSEDITZ3LE
     C/COPY ZSRSRC,ZDATE9Z3LE
     C/COPY ZSRSRC,ZDAT10Z2LE                                                              BUG24672B
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2009
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
**
JANUARY
FEBRUARY
MARCH
APRIL
MAY
JUNE
JULY
AUGUST
SEPTEMBER
OCTOBER
NOVEMBER
DECEMBER
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN
00366007310109601461
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
