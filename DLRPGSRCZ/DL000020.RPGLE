     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas DL Initialisation program for CAS009(FSACAI)')   *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  RPGLE/DL000020 - Dealing Initialisation program for CAS009   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 231563  *CREATE    Date 12Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c             *
      *           (Recompile)                                         *
      *  231563 - Initiase Amortised Cost Accounting Indicator for    *
      *           Deal Types/Sub-types file (FDDTSTPD)                *
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
 
      ** Midas FD Deal Type/Subtype
     FFDDTSTL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Midas DL initialisation program (FSACAI) - Audit file
     FDL000020AUO    E             PRINTER
 
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
     C     *LOVAL        SETLL     FDDTSTL0
     C                   READ      FDDTSTL0
 
     C                   DOW       NOT %EOF(FDDTSTL0)
     C                   EVAL      WCOUNT = WCOUNT + 1
 
      ** Set all blank AYACAI to 'N'
     C                   IF        FSACAI = *BLANK
     C                   EVAL      FSACAI = 'N'
     C                   UPDATE    FDDTSTPD
     C                   EVAL      WPROCESSED = WPROCESSED + 1
     C                   ENDIF
 
     C                   READ      FDDTSTL0
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
     C                   EVAL      DBPGM  = 'DL000020'
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
