     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Initialisation program for CAS008')           *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  RPGLE/DL000018 - Dealing Initialisation program for CAS008   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
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
      *                 CDL038             Date 10May05               *
      *                 CAS008  *CREATE    Date 16Jun04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
      *  CDL038 - Extended Deal Sub Type                              *
      *  CAS008 - IAS 39 Enhancements                                 *
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
      *  SRDfltBOF  - Initialise fields in Back Office File (DEALSDG) *
      *  SRChFile   - Access Deal Type/subtype File                   *
      *  SRAudit    - Write Audit Report                              *
      *  *PSSR      - Program exception error routine                 *
      *  *INZSR     - Initial First Cycle processing                  *
      *                                                               *
      *****************************************************************
      ** FRA/IRS Deals
     FDEALS     UF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDCF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDFF)
     F                                     COMMIT
 
      ** Deal Types/Subtypes Retrieval Index
     FFDDTSTL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Audit file
     FDL000018AUO    E             PRINTER
 
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
     D PSARD           S              6
 
      ** Other work fields
     D CIR003          S              1
     D WBIS@           S             80
     D WCOUNTF         S              9  0
     D WCOUNTDG        S              9  0
     D WkDTYP          S              2
     D WkDLST          S              2
     D WDUMP           S              1
 
      ** Process FRA/IRS deals (DEALSDG)
 
     C                   IF        CIR003 = 'Y'
 
     C     *LOVAL        SETLL     DEALS
     C                   DOU       *IN10 = *ON
     C                   READ      DEALS                                  10
 
     C                   IF        *IN10 = *OFF AND RECI = 'D'
 
      ** If a live IRS deal is found
 
     C                   EVAL      WCOUNTF = WCOUNTF + 1
 
      ** Call subroutine that defaults values for yield curve fields
 
     C                   EXSR      SRDfltBOF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   COMMIT
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
 
      ** Write File Controls Report.
 
     C                   EXSR      SRAudit
 
      ** Subroutines
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDfltBOF - Initialise fields in FRA/IRS file (DEALSDG) for   *
      *             'RX' deals                                        *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: SR/SRChFile                                            *
      *                                                               *
      *****************************************************************
     C     SRDfltBOF     BEGSR
 
      ** Call subroutine to access file for default values of yield curve fields
 
     C                   EXSR      SRChFile
 
     C                   IF        %EOF = *OFF
 
      ** If found, default our and their forward commitment yield curve fields
 
     C                   IF        DTYP = 'RX'
     C                   EVAL      FSOFCC = FSOFCY
     C                   EVAL      FSTFCC = FSTFCY
 
     C                   ELSE
     C                   EVAL      FSOFCC = *BLANKS
     C                   EVAL      FSTFCC = *BLANKS
     C                   ENDIF
 
     C                   IF        DTYP = 'RX'
     C                   UPDATE    DEALSDGF
     C                   IF        FSOFCC <> *BLANKS OR
     C                             FSTFCC <> *BLANKS
     C                   EVAL      WCOUNTDG = WCOUNTDG + 1
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChFile - Subroutine to Access Deal Type/subtype File        *
      *                                                               *
      * Called by: SR/SRDfltBOF                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRChFile      BEGSR
 
      ** Access the Deal Type/Subtype file for default values for the
      ** Buy/Our Yield Curve and Sell/Their Yield Curve
 
     C                   EVAL      WkDTYP = DTYP
     C                   EVAL      WkDLST = DLST
     C                   EVAL      WkCLAS = CLAS                                              CDL038
 
     C     KyDeal        CHAIN     FDDTSTL1                           01
 
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
     C                   EVAL      DBPGM  = 'DL000018'
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
 
      **  Access SAR details file to determine if CIR003 is on.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CIR003'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  = 2
     C                   EVAL      DBKEY  = 'CIR003'
     C                   EXSR      *PSSR
     C                   END
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CIR003 = 'Y'
     C                   ELSE
     C                   EVAL      CIR003 = 'N'
     C                   END
 
      ** Initialise counters
 
     C                   EVAL      WCOUNTF = 0
     C                   EVAL      WCOUNTDG = 0
 
 
      ** Key List for Deal types/subtypes file
 
     C     KyDeal        KLIST
     C                   KFLD                    WkDTYP
     C                   KFLD                    WkDLST
     C                   KFLD                    WkCLAS            4                          CDL038
 
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
(c) Misys International Banking Systems Ltd. 2004
