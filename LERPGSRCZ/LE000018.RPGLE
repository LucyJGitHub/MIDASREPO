     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Initialisation program for CAS009(AYACAI)')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  RPGLE/LE000018 - Lending Initialisation program for CAS009   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CLE164             Date 18Aug14               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CLE042             Date 06Sep05               *
      *                 CAS011             Date 04May04               *
      *                 231566  *CREATE    Date 12Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c             *
      *           (Recompile)                                         *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1. Apply 231566.     *
      *  231566 - Initiase Amortised Cost Accounting Indicator for    *
      *           Loan Types/Sub-types file (SDLOANPD)                *
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
      *  SRAudit    - Write Audit Report                              *
      *  *PSSR      - Program exception error routine                 *
      *  *INZSR     - Initial First Cycle processing                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas LE Loan Types/Sub-types Update index
     FSDLOANL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Midas LE initialisation program (AYACAI) - Audit file
     FLE000018AUO    E             PRINTER
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** Copyright statement array
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
 
      ** Process Loan Types/Sub-types File
     C     *LOVAL        SETLL     SDLOANL0
     C                   READ      SDLOANL0
 
     C                   DOW       NOT %EOF(SDLOANL0)
     C                   EVAL      WCOUNT = WCOUNT + 1
 
      ** Set all blank AYACAI to 'N'
     C                   IF        AYACAI = *BLANK
     C                   EVAL      AYACAI = 'N'
     C                   UPDATE    @AYRECK
     C                   EVAL      WPROCESSED = WPROCESSED + 1
     C                   ENDIF
 
     C                   READ      SDLOANL0
     C                   ENDDO
 
      ** Commit changes
     C                   COMMIT
 
      ** Write audit report
     C                   EXSR      SRAudit
 
     C                   EVAL      *INLR = *ON
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAudit - Subroutine to Write Audit Report                    *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
      ** Write audit report header
     C                   WRITE     HEADAU
 
      ** Write audit report details
     C                   IF        WCOUNT <> 0
     C                   WRITE     CONTROL
     C                   ELSE
     C                   WRITE     NODTLS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Subroutine for initial processing                    *
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
     C                   EVAL      DBPGM  = 'LE000018'
     C                   EVAL      DBASE = *ZERO
     C                   OUT       LDA
 
      ** Access bank details
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
     C                   EVAL      WCOUNT  = *ZERO
     C                   EVAL      WPROCESSED = *ZERO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WDUMP = *BLANKS
     C                   EVAL      WDUMP = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
 
      ** Write audit report header
     C                   WRITE     HEADAU
 
      ** Write database error details
     C                   WRITE     DBERROR
 
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
     C****************************************************************
** WCPY@
(c) Misys International Banking Systems Ltd. 2005
