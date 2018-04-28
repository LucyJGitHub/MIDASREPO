     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE CLE025 Aggregated Facility Initialisation')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  RPGLE/LE000049 - CLE025 Aggregated Facility Initialisation   *
      *                   Programe                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 BUG9487            Date 03Dec05               *
      *                 BUG7190            Date 07Jun05               *
      *                 BUG6111            Date 28Feb05               *
      *                 CLE041  *CREATE    Date 11Oct04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9487 - Wrong RCTP for LEAGFZPD.                           *
      *  BUG7190 - LEC000058 failed component due to trailer file     *
      *  BUG6111 - Use 999999 values for trailer file instead of      *
      *            zeros to prevent duplicate data. Include EVAL      *
      *            DBPGM = LE000049 instead of LE000016.              *
      *  CLE041 - Collateralised Lending Phase 2B                     *
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
      *  SrLEAGHHPD - Initialise Aggregate Facilities header          *
      *  SrLEAGFZPD - Initialise Aggregate Facilities trailer         *
      *  SrLEAGAMZZ - Aggregate Facility Amendment transaction trailer*
      *  SRAudit    - Write Audit Report                              *
      *  *PSSR      - Program exception error routine                 *
      *  *INZSR     - Initial First Cycle processing                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Aggregate Facilities Header file
     FLEAGHHPD  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Aggregate Facilities Trailer file
     FLEAGFZPD  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Aggregate Facility Amendment transaction trailer
     FLEAGAMZZ  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Audit file
     FLE000049AUO    E             PRINTER
 
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
 
      ** Initialise Aggregate Facilities header
 
     C                   EXSR      SrLEAGHHPD
 
      ** Initialise Aggregate Facilities trailer
 
     C                   EXSR      SrLEAGFZPD
 
      ** Aggregate Facility Amendment transaction trailer
 
     C                   EXSR      SrLEAGAMZZ
 
     C                   COMMIT
     C                   EVAL      *INLR = *ON
 
      ** Write File Controls Report.
 
     C                   EXSR      SRAudit
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrLEAGHHPD - Initialise Aggregate Facilities header          *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrLEAGHHPD    BEGSR
 
     C                   READ      LEAGHHPD
     C                   IF        %EOF(LEAGHHPD)
     C                   EVAL      RECI = 'H'
     C**********         EVAL      CNUM = *ZEROS                                              CSD027
     C                   EVAL      CNUM = *BLANKS                                             CSD027
     C                   EVAL      FACT = *ZEROS
     C                   EVAL      FCNO = *ZEROS
     C                   EVAL      RCDT = *BLANK
     C                   EVAL      ZZ243 = *BLANKS
 
     C                   WRITE     FCLTYHHF
     C                   EVAL      WLEAGHHPD = 'YES'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrLEAGFZPD - Initialise Aggregate Facilities trailer         *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrLEAGFZPD    BEGSR
 
     C                   READ      LEAGFZPD
     C                   IF        %EOF(LEAGFZPD)
     C                   EVAL      RECI = 'T'
     C**********         EVAL      CNUM = 999999                                       UG6111 CSD027
     C                   EVAL      CNUM = '999999'                                            CSD027
     C                   EVAL      FACT = 999                                                BUG6111
     C                   EVAL      FCNO = 99                                                 BUG6111
     C**********         EVAL      RCTP = *BLANK                                             BUG9487
     C                   EVAL      RCTP = 'Z'                                                BUG9487
     C                   EVAL      ZZ003 = *BLANKS
     C**********         EVAL      NORE = *ZEROS                                             BUG7190
     C                   EVAL      NORE = 2                                                  BUG7190
     C                   EVAL      ZZ003A = *BLANKS
     C                   EVAL      NLRB = *ZEROS
     C                   EVAL      NINS = *ZEROS
     C                   EVAL      NDEL = *ZEROS
     C                   EVAL      NLRA = *ZEROS
     C                   EVAL      VLBF = *ZEROS
     C                   EVAL      VLBL = *ZEROS
     C                   EVAL      VRIF = *ZEROS
     C                   EVAL      VRIL = *ZEROS
     C                   EVAL      VRDF = *ZEROS
     C                   EVAL      VRDL = *ZEROS
     C                   EVAL      VRAF = *ZEROS
     C                   EVAL      VRAL = *ZEROS
     C                   EVAL      VLAF = *ZEROS
     C                   EVAL      VLAL = *ZEROS
     C                   EVAL      ZZ165 =*BLANKS
     C                   EVAL      LCD  = *ZEROS
     C                   EVAL      CHTP = *BLANK
     C                   EVAL      TNLU = *ZEROS
 
     C                   WRITE     FCLTYZZF
     C                   EVAL      WLEAGFZPD = 'YES'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrLEAGAMZZ - Aggregate Facility Amendment transaction trailer*
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrLEAGAMZZ    BEGSR
 
     C                   READ      LEAGAMZZ
     C                   IF        %EOF(LEAGAMZZ)
     C                   EVAL      RECI = 'T'
     C                   EVAL      NORE = *ZEROS
     C                   EVAL      NINS = *ZEROS
     C                   EVAL      NAMD = *ZEROS
     C                   EVAL      NDEL = *ZEROS
     C                   EVAL      NLRB = *ZEROS
     C                   EVAL      NLRA = *ZEROS
     C                   EVAL      VIRF = *ZEROS
     C                   EVAL      VIRL = *ZEROS
     C                   EVAL      VARF = *ZEROS
     C                   EVAL      VARL = *ZEROS
     C                   EVAL      VDRF = *ZEROS
     C                   EVAL      VDRL = *ZEROS
     C                   EVAL      VLBF = *ZEROS
     C                   EVAL      VLBL = *ZEROS
     C                   EVAL      VLAF = *ZEROS
     C                   EVAL      VLAL = *ZEROS
 
     C                   WRITE     LEFCAMZF
     C                   EVAL      WLEAGAMZZ = 'YES'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit    - Write Audit Report                              *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
      ** Write File Control Report Heading
 
     C                   WRITE     HEADAU
 
     C                   IF        WLEAGHHPD = 'YES' OR
     C                             WLEAGFZPD = 'YES' OR
     C                             WLEAGAMZZ = 'YES'
     C                   WRITE     CONTROL
 
     C                   ELSE
     C                   WRITE     NODTLS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR     - Initial First Cycle processing                  *
      *                                                               *
      *  Called by: Automatically called upon entry to the module     *
      *                                                               *
      *  Calls: SR/*PSSR                                              *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C                   MOVEA     WCPY@         WBIS@
 
      ** Set up Local Data Area (LDA)
 
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY  = *BLANKS
     C                   EVAL      DBPGM  = *BLANKS
     C**********         EVAL      DBPGM  = 'LE000016'                                       BUG6111
     C                   EVAL      DBPGM  = 'LE000049'                                       BUG6111
     C                   EVAL      DBASE = *ZERO
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
 
      ** Initialise flags
 
     C                   EVAL      WLEAGHHPD = 'NO '
     C                   EVAL      WLEAGFZPD = 'NO '
     C                   EVAL      WLEAGAMZZ = 'NO '
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR      - Program exception error routine                 *
      *                                                               *
      *  Called by: *INZSR                                            *
      *                                                               *
      *  Calls: None                                                  *
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
(c) Misys International Banking Systems Ltd. 2004
