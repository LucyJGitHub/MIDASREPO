     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas DL Initialisation program for CAS009')           *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  RPGLE/DL000019 - Dealing Initialisation program for CAS009   *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 233545             Date 18May05               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  233545 - Cut-off Date                                        *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators                                            *
      *                                                               *
      *  10 - End of File                                             *
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
      *  SRDfltBOF  - Initialise fields in Back Office File (DEALSDD) *
      *  SRAudit    - Write Audit Report                              *
      *  *PSSR      - Program exception error routine                 *
      *  *INZSR     - Initial First Cycle processing                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** FRA/IRS Deals
     FDEALS     UF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDCF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDGF)
     F                                     IGNORE(DEALSDFF)
     F                                     COMMIT

      ** Deal Types/Subtypes Retrieval Index
     FFDDTSTL1  IF   E           K DISK    INFSR(*PSSR)

      ** Midas SD Hedging ICD File                                                            233545
     FSDHEDGPD  UF   E             DISK    INFSR(*PSSR)                                       233545
                                                                                              233545
      ** Audit file
     FDL000019AUO    E             PRINTER

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

      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

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
     D WkDTYP          S              2
     D WkDLST          S              2
     D WDUMP           S              1
      ****************************************************************
      *  MAIN PROCESSING                                             *
      ****************************************************************

      ** Process DEALSDD

     C     *LOVAL        SETLL     DEALS
     C                   READ      DEALS
     C                   DOW       NOT %EOF(DEALS)

     C                   IF        RECI = 'D'

      ** If a live IRS deal is found

     C                   EVAL      WCOUNTF = WCOUNTF + 1

      ** Default values

     C                   EXSR      SRDfltBOF
     C                   ENDIF

     C                   READ      DEALS
     C                   ENDDO

     C                   COMMIT

     C     1             SETLL     SDHEDGPD                                                   233545
     C                   READ      SDHEDGPD                               90                  233545
                                                                                              233545
     C                   IF        *IN90 = *OFF                                               233545
     C                   EVAL      FSSWDT = BJRDNB                                            233545
     C                   UPDATE    SDHEDGD0                                                   233545
     C                   ENDIF                                                                233545
                                                                                              233545
     C                   EVAL      *INLR = *ON

      ** Write File Controls Report.

     C                   EXSR      SRAudit

      ** Subroutines

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDfltBOF - Default Values                                    *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRDfltBOF     BEGSR

      ** Access the Deal Type/Subtype file

     C                   EVAL      WkDTYP = DTYP
     C                   EVAL      WkDLST = DLST

     C     KyDeal        CHAIN     FDDTSTL1                           01
     C                   IF        %FOUND(FDDTSTL1) AND
     C                             FSACAI = 'Y'
     C                   EVAL      TFDP  = DISA
     C                   EVAL      TFDPA = DISA
     C                   EVAL      TFAM  = DISA

     C                   UPDATE    DEALSDDF
     C                   EVAL      WCOUNTDD = WCOUNTDD + 1
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
     C                   EVAL      DBPGM  = 'DL000019'
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
     C                   EVAL      WCOUNTDD = 0

      ** Key List for Deal types/subtypes file

     C     KyDeal        KLIST
     C                   KFLD                    WkDTYP
     C                   KFLD                    WkDLST

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
