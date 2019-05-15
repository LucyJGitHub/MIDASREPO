     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL RWA netting groups audit report')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger module                                *
      *                                                               *
      *  GL001247 - RWA Netting groups input and amended today        *
      *                                                               *
      *  Function:  This program list all RWA netting groups          *
      *             input and amended today                           *
      *  I/C On Request report                                        *
      *  COB Automatic AU report                                      *
      *                                                               *
      *  Called By: mmCnnnn - (program name)                          *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 240791             Date 06May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL018  *CREATE    Date 03Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  240791 - Initial coding from R4.1 changed/omitted.           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL018 - Risk Weighted Assets                                *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** | F-specs                              |
      ** | =======                              |
      ** +--------------------------------------+
      *
      **  Reports
      *
     FGL001247AUO    E             PRINTER INFDS(SPOOLU)
     F*
     FGL001247P1O    E             PRINTER INFDS(SPOOL1)  USROPN
     F*
     FGLNETGL2  IF   E           K DISK    INFSR(*PSSR)
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   37  - Multibranching ON                                     *
      *   50  - Audit mode - report today's changes                   *         CGL018
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
      *  *INZSR  - Program Initialisation                             *
      *  *PSSR   - Error processing                                   *
      *                                                               *
      *  PROCES - Detail Processing                                   *
      *  REPORT - Process Report Lines                                *
      *                                                               *
      *  WP1REC - Format and Write a Detail Record to the Report      *
      *  WP1END - Write End of Report                                 *
      *                                                               *
      *  AUDIT  - Produce Audit Report and End Program                *
      *  RCFP1  - RCF Processing for P1 Report                        *
      *  RCFAU  - RCF Processing for Audit Report                     *
      *                                                               *
      *****************************************************************
     D/EJECT
      ** +--------------------------------------+
      ** | D-specs                              |
      ** | =======                              |
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** | Arrays and Data Structures           |
      ** | ==========================           |
      ** +--------------------------------------+
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D SPOOL1          DS
      ***  File Information Data Structure for GL001247P1
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
     D SPOOLU          DS
      ***  File Information Data Structure for GL1247AU.
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
      ***  Dummy Data Structures used by Access Programs.
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D*SDCURR******* E DS                  EXTNAME(SDCURRPD)                    CGL018
      ***  External data structures for Bank Details
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *
      ** +--------------------------------------+
      ** | Declared variables                   |
      ** | ==================                   |
      ** +--------------------------------------+
      *
     D PrimChgF        S              1A                                        CGL018
      *
      *------------------------------------------------------------------------*
      /COPY ZACPYSRC,PSDS
      /COPY ZACPYSRC,STD_D_SPEC
      **  Array For ZEDIT And ZALIGN
      /COPY ZSRSRC,ZALIGNZ1LE
      *------------------------------------------------------------------------*
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** |                                                                |
      ** | Initial processing is performed automatically: the *INZSR is   |
      ** | executed at program activation.                                |
      ** |                                                                |
      ** +----------------------------------------------------------------+
      *
      ***  Perform Detail Processing.
      *
     C                   EXSR      PROCES
      *
      ***  Output Audit Report and End Program.
      *
     C                   EXSR      AUDIT
      *
      /EJECT
      *========================================================================*
      *                    S  U  B  R  O  U  T  I  N  E  S                     *
      *========================================================================*
      *
      *========================================================================*
     C/EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR  - Subroutine to do Program Initialisation.           *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *  RCFAU  - RCF Processing for Audit Report                     *
      *  ZDAT   -
      *  ZDAT   -
      *  AOBANKR0 Access Program                                      *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR                                                  ***  INZSR ***
      *
      **  Entry Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRTNC             7            Return Code
     C                   PARM                    PARSI             1            Audit/Reguest
     C                   PARM                    PRSEQ             5            RCF Seq.number
     C                   PARM                    PLEVL             1            Level
     C                   PARM                    PRENT                          Entity
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Prepare LDA
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'GL001247'    DBPGM
     C                   OUT       LDA
      *
      ***  Call Access Program for Bank Details - Title, Run Date and
      ***  Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*BLANK '     WRTCD             7
     C                   PARM      '*FIRST '     WOPTN             7
     C     SDBANK        PARM      SDBANK        DSLDY
      *
      ***  Handle Database Error.
      *
     C     WRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      'SDBANKPD'    DBFILE
     C                   Eval      DBKEY = @OPTN                                ***************
     C                   Z-ADD     001           DBASE                          * DB ERROR 01 *
     C                   OUT       LDA                                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Check System Date Format, DDMMYY (*IN98 off)
      ***                            MMDDYY (*IN98 on).
      *
     C     BJDFIN        IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
      *
      **   Access RUNDAT for multibranching indicator
      *
     C                   IN        RUNDAT
      *
     C     AGMBIN        IFEQ      'M'
     C                   SETON                                        37                      240791
     C                   END
      *
      ***  RCF Processing for Audit File.
      *
     C                   Exsr      RCFAU
      *
      ***  Report Work fields.
      *
     C                   Z-ADD     0             RQDLN1            3 0
     C                   Z-ADD     0             DIFLN1            3 0
     C                   Z-ADD     0             RCOUNT
     C                   Z-ADD     0             ICOUNT
     C                   Z-ADD     0             ACOUNT
     C                   Move      *BLANK        PRTNC
      *
     C                   ENDSR
      *
      /EJECT
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
      ***  Read first record from File.
      *
     C     *Loval        Setll     GLNETGL2
     C                   READ      GLNETGL2                               89
      *
      ***  If End of Records, (*IN89), Perform: Audit Reporting (No
      ***  Records).
      *
     C     *IN89         IFEQ      *ON
     C                   EXSR      AUDIT
     C                   ENDIF
      *
      **  If record read, ensure spool file P1 recorded by RCF
      *
     C                   Open      GL001247P1
     C                   Exsr      RCFP1
      *                                                                         CGL018
      ***  Check if audit mode                                                  CGL018
      *                                                                         CGL018
     C                   IF        PARSI = 'A'                                  CGL018
     C                   EVAL      *IN50 = *on                                  CGL018
     C                   ENDIF                                                  CGL018
     C                   WRITE     HEADP1                                       CGL018
      *
      ***  Do Until End of File.
      *
     C     *IN89         DowEQ     '0'
      *
      ***  Count records read.
      *
     C                   ADD       1             RCOUNT            5 0
      *
      ***  Process Report Lines.
      *
     C                   EXSR      REPORT
      *
      ***  Read next record.
      *
     C                   READ      GLNETGL2                               89
      *
      ***  End of Do Until End of Valid Records.
     C                   ENDDO
      *
      *
      ***  Write final records and Totals to Report.
      *
     C                   EXSR      WP1END
      *
     C                   ENDSR
      *
      /EJECT
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
      ***  Only today's records.
      *
     C     RWLCD         IFEQ      AGRDNB
     C     RWCHTP        IFEQ      'I'
     C                   ADD       1             ICOUNT
     C                   ELSE
     C                   ADD       1             ACOUNT
     C                   ENDIF
     C                   ENDIF
      *
      ***  Write out the record.
      ***  Report if audit mode & primary changed today, or not audit mode      CGL018
      *
     C                   IF        RWPRIM = 'P'
     C                   Eval      PrimChgF = *blank
     C                   IF        PARSI = 'A' and AGRDNB = RWLCD               CGL018
     C                   Eval      PrimChgF = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        PrimChgF = 'Y'
     C                             or PARSI <> 'A'                              CGL018
     C                   EXSR      WP1REC
     C                   ENDIF                                                  CGL018
      *
     C                   ENDSR
      *
      /EJECT
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
      * secondary account
     C                   MOVE      RWBRCA        LBRCA
     C                   MOVE      RWCUST        LCUST
     C                   MOVE      RWCCY         LCCY
     C                   MOVE      RWACOD        LACOD
     C                   MOVE      RWACSQ        LACSQ
                                                                                CGL018
     C                   IF        RWACNO > *zero                               CGL018
     C                   MOVE      RWACNO        LACNO
     C                   ELSE                                                   CGL018
     C                   EVAL      LACNO = *blanks                              CGL018
     C                   ENDIF                                                  CGL018
      *
      * primary account
     C                   MOVE      RWPRIM        LPRIM
     C                   MOVE      RWPBRCA       LPBRCA
     C                   MOVE      RWPCUST       LPCUST
     C                   MOVE      RWPCCY        LPCCY
     C                   MOVE      RWPACOD       LPACOD
     C                   MOVE      RWPACSQ       LPACSQ
                                                                                CGL018
     C                   IF        RWPACNO > *zero                              CGL018
     C                   MOVE      RWPACNO       LPACNO
     C                   ELSE                                                   CGL018
     C                   EVAL      LPACNO = *blanks                             CGL018
     C                   ENDIF                                                  CGL018
      *
     C                   MOVE      RWCONF        LCONF
     C                   MOVE      RWCHTP        LCHTP
      *
      ***  Check that sufficient lines remain for the Format. If not,
      ***  write out the Main Headings on a new page.
      *
     C                   Z-ADD     3             RQDLN1                                  CGL018
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
      *
      ***  Write out Detail Record.
      *
     C     RWPRIM        IFEQ      'P'
     C                   WRITE     PRIDET
     C                   ELSE
     C                   WRITE     SECDET
     C                   END
      *
     C                   ENDSR
      *
      /EJECT
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
      *                                                                         CGL018
      **  If audit mode and no changes today, print 'no details'.               CGL018
      *                                                                         CGL018
     C                   IF        PARSI = 'A' and ICOUNT = 0 and               CGL018
     C                             ACOUNT = 0                                   CGL018
     C                   WRITE     NORECORD                                     CGL018
     C                   ELSE                                                   CGL018
      *
      ***  Check that sufficient lines remain for the Format. If not,
      ***  write out the Main Headings on a new page.
      *
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
      *
      ***  Write out Total Format.
      *
     C                   WRITE     TRAILPY
      *                                                                         CGL018
     C                   ENDIF                                                  CGL018
      *
     C                   ENDSR
      *
      /EJECT
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
      ***  Output Report Header and File Controls.
      *
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
      *
      ***  If there is a DB Error, Output the DB Error Information.
      *
     C     *INU7         IFEQ      *ON
     C                   WRITE     DBERROR
     C                   ELSE
      *
      ***  Or, if no records read, Output "No Details" message.
      *
     C     RCOUNT        IFEQ      0
     C                   WRITE     NODTLS
     C                   ENDIF
     C                   ENDIF
      *
      ***  End Program and Return.
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR **
      *
      ***  Check to see that *PSSR has not already been called.
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
      *
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   EXSR      AUDIT
     C                   ENDIF
      *
      ***  If *PSSR already run, then just end the program here.
      *
     C                   Eval      PRTNC = 'ERROR'
     C                   SETON                                        U7U8
     C***********        Exsr      AUDIT                                                      240791
     C                   RETURN
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  RCFP1  - Subroutine to register the P1 Printer File via RCF. *
      *                                                               *
      *****************************************************************
      *
     C     RCFP1         BEGSR                                                   *** RCFP1  ***
      *
      ***  Ensure Report Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUM1        ZSNUM             6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM      PRSEQ         PRSEQ             5
     C                   PARM                    PRENT             3
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1
      *
      ***  If Error occurs during ZSFILE processing, then return to the
      ***  Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  RCFAU  - Subroutine to register the AU Printer File via RCF. *
      *                                                               *
      *****************************************************************
      *
     C     RCFAU         BEGSR                                                   *** RCFAU  ***
      *
      ***  Ensure Audit Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUMU        ZSNUMU            6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PRSEQ
     C                   PARM                    PRENT
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM      *BLANK        ZSERR
      *
      ***  If Error occurs during ZSFILE processing, then return to the
      ***  Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
     d/COPY ZSRSRC,ZALIGNZ2LE
**  CPY@
(c) Finastra International Limited 2002
