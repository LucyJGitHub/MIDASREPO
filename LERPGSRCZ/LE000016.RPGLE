     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Initialisation program for CAS009(FCOD)')     *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  RPGLE/LE000016 - Lending Initialisation program for CAS009   *
      *                   Fee Code                                    *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CLE139             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 231568             Date 10Jan05               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  231568 - Additional Validation For ADJY in Fee Codes         *
      *           Maintenance                                         *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators                                            *
      *                                                               *
      *  LR - Last record indicator (program termination)             *
      *  U7 and U8 - DB error processing indicator                    *
      *                                                               *
      *****************************************************************
      /SPACE
      *****************************************************************
      *                                                               *
      *  Subroutine Index                                             *
      *                                                               *
      *  SRDfltADJY - Initialise Adjustment to Yield(FEADJY)          *
      *  SRAudit    - Write Audit Report                              *
      *  *PSSR      - Program exception error routine                 *
      *  *INZSR     - Initial First Cycle processing                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Fees File
     FLEFEEDL1  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Fee Codes File
     FSDFEEL0   IF   E           K DISK    INFSR(*PSSR)
 
      ** Audit file
     FLE000016AUO    E             PRINTER
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** Array containing Copyright statement
     D WCPY@           S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Program Status Data Structure
     D PSDS           SDS
 
     D  ##PGM            *PROC
     D  JOB                  244    253
     D  WSID                 244    246
     D  USER                 254    263
 
      ** Parameters for access object programs
     D PRTCD           S              7
     D POPTN           S              7
 
      ** Other work fields
     D WBIS@           S             80
     D WDUMP           S              1
 
     ******************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main Processing                                        *
      *                                                               *
      *****************************************************************
 
      ** Process Fee File(LEFEED)
 
     C     *LOVAL        SETLL     LEFEEDL1
     C                   READ      LEFEEDL1
     C                   DOW       NOT %EOF(LEFEEDL1)
 
     C                   IF        FERECI = 'D'
     C**********                   AND FELOAN <> 0                                     231568 CLE148
     C                             AND FELOAN <> *BLANKS                                      CLE148
 
      ** If a live record
 
     C                   EVAL      WCOUNTF = WCOUNTF + 1
 
      ** Call subroutine that defaults values for adjustment to yield
 
     C                   EXSR      SRDfltADJY
 
     C                   ENDIF
 
     C                   READ      LEFEEDL1
     C                   ENDDO
 
     C                   COMMIT
     C                   EVAL      *INLR = *ON
 
      ** Write File Controls Report.
 
     C                   EXSR      SRAudit
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDfltADJYY - Initialise Adjustment to Yield(FEADJY)          *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRDfltADJY    BEGSR
 
     C                   IF        FEFCOD <> *ZERO
     C                   MOVEL     FEFCOD        WkFECD
     C     WkFECD        CHAIN     SDFEEL0
 
     C                   IF        %FOUND(SDFEEL0)
     C**********         IF        AUADJY = 'Y'                                               231568
     C                   EVAL      FEADJY = AUADJY
     C                   UPDATE    LEFEEDF
     C                   EVAL      WCOUNTFEE = WCOUNTFEE + 1
     C**********         ENDIF                                                                231568
 
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDFEEL0 '
     C                   EVAL      DBASE  = 2
     C                   EVAL      DBKEY  = WkFECD
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAudit - Subroutine to Write Audit Report                    *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
      ** Write File Control Report Heading
 
     C                   WRITE     HEADAU
 
     C                   IF        WCOUNTF <> 0
     C                   WRITE     CONTROL
 
     C                   ELSE
     C                   WRITE     NODTLS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Subroutine for Initial First Cycle processing        *
      *                                                               *
      * Called by: Automatically called upon entry to the module      *
      *                                                               *
      * Calls: SR/*PSSR                                               *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C                   MOVEA     WCPY@         WBIS@
 
      **  Set up Local Data Area (LDA)
 
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY  = *BLANKS
     C                   EVAL      DBPGM  = *BLANKS
     C                   EVAL      DBPGM  = 'LE000016'
     C                   EVAL      DBASE = 0
     C                   OUT       LDA
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBKEY  = POPTN
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialise counters
 
     C                   EVAL      WCOUNTF = 0
     C                   EVAL      WCOUNTFEE = 0
     C     *LIKE         DEFINE    AUFECD        WkFECD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WDUMP = *BLANKS
     C                   EVAL      WDUMP = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
 
      ** Write File Control Report Heading
 
     C                   WRITE     HEADAU
 
      ** Write Database error
 
     C                   WRITE     DBERROR
 
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
     C****************************************************************
** WCPY@
(c) Finastra International Limited 2004
