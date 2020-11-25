     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Transactions initialisation program')         *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  RPGLE/LE0012 - Lending Transactions Initialisation program   *
      *               (for all CLOAN records except G'tees Issued)    *
      *                                                               *
      *  Called from: Command Entry line                              *
      *               One-time set-up program.                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE141             Date 08Feb16               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9480            Date 06Jan06               *
      *               . CAS009             Date 16May05               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001  *CREATE    Date 23Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - Libor Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c             *
      *           (Recompile)                                         *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type                              *
      *  BUG9480- Forward Yield Curve is now allowed to be populated  *
      *           even loan not linked to base rate code.             *
      *  CAS009 - EIR/AC Accounting (Recompile)                       *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Function of Indicators                                       *
      *                                                               *
      *  01 - Record not found in SDLOANL1                            *
      *  60 - End of File                                             *
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
      *  SRDfltFlds - Default fields                                  *
      *  SRAudit    - Write Audit Report                              *
      *  *PSSR      - Program exception error routine                 *
      *  *INZSR     - Initial First Cycle processing                  *
      *                                                               *
      *****************************************************************
     FCLOAN     UF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
     F                                     COMMIT
      ** Loans File

     FSDLOANL1  IF   E           K DISK    INFSR(*PSSR)
      ** Loan Types/Subtypes Retrieval Index

     FLE000012AUO    E             PRINTER
      ** Lending Transactions Initialisation Audit Report

      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)

      ** Short Data Structure for Access programs
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

      ** Main Processing

     C     *LOVAL        SETLL     CLOAN
     C                   DOU       *IN60 = *ON
     C                   READ      CLOAN                                  60

      ** Process live transaction details.

     C                   IF        *IN60 = *OFF and RECI = 'D'

      ** Where the CLOANCL record, is NOT a Guarantee Issued.
      ** (not processing type 70, 71 or 72)

     C                             and PTYP <> 70
     C                             and PTYP <> 71
     C                             and PTYP <> 72

     C                   ADD       1             COUNT1

      ** Initialize extension record.

     C                   EXSR      SRDfltFlds

     C                   ENDIF

     C                   ENDDO

     C                   COMMIT

     C                   EVAL      *INLR = *ON

      ** Write File Controls Report.

     C                   EXSR      SRAudit

      *****************************************************************
      *                                                               *
      * SRDfltFlds - Subroutine that default fields                   *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRDfltFlds    BEGSR

      ** Initialise key fields

     C                   EVAL      WkLTYP = LTYP
     C                   EVAL      WkSUTP = SUTP
     C                   EVAL      WkCLAS = CLAS                                              CLE042

     C     KyLOAN        CHAIN     SDLOANL1                           01
     C                   IF        *IN01 = *OFF

      ** If found, default fields

     C                   MOVEL     AYYLDC        FSYLDC

      ****For*'Forward*Yield*Curve',*only*use*the*default*value*if*****                      BUG9480
      ****the*loan*is*linked*to*a*base*rate*code.**********************                      BUG9480

     C**********         IF        BRTT <> 00                                                BUG9480
     C                   MOVEL     AYFYLD        FSFYLD
     C**********         ELSE                                                                BUG9480
     C**********         MOVEL     *blanks       FSFYLD                                      BUG9480
     C**********         ENDIF                                                               BUG9480

     C                   ELSE
     C                   MOVE      *blanks       FSYLDC
     C                   MOVEL     *blanks       FSFYLD
     C                   ENDIF

     C                   UPDATE    CLOANCLF

      ** Increment counter only if fields are initialised with values

     C                   IF        (FSYLDC <> *blanks)  OR (FSFYLD <> *blanks)
     C                   ADD       1             COUNT2
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

     C                   IF        COUNT1 <> 0
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
      * Called by: Automatlically called upon entry to the module     *
      *                                                               *
      * Calls: SR/*PSSR                                               *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C                   MOVEA     CPY@          BIS@             80

      **  Set up Local Data Area (LDA)

     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *blanks       DBFILE
     C                   MOVE      *blanks       DBKEY
     C                   MOVE      *blanks       DBPGM
     C                   MOVEL     'LE000012'    DBPGM
     C                   Z-ADD     0             DBASE
     C                   OUT       LDA

      ** Access Bank details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

      ** If not found, database error

     C     PRTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'LE000012'    DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   Z-ADD     *ZERO         COUNT1
     C                   Z-ADD     *ZERO         COUNT2

      ** Initialize constant fields.

     C                   Z-ADD     *ZEROS        FSURPL
     C                   Z-ADD     *ZEROS        FSPLAM
     C                   Z-ADD     *ZEROS        FSPLDT
     C                   Z-ADD     *ZEROS        FSYUPL

      ** Key List for Loan types/subtypes file

     C     KyLOAN        KLIST
     C                   KFLD                    WkLTYP            2
     C                   KFLD                    WkSUTP            2
     C                   KFLD                    WkCLAS            4                          CLE042

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR - Program exception error routine                       *
      *                                                               *
      * Called by: SR/*INZSR                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WDUMP = *blanks
     C                   MOVE      'Y'           WDUMP             1
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   DUMP

      ** Write File Control Report Heading

     C                   WRITE     HEADAU

      ** Write Database error

     C                   WRITE     DBERROR

     C                   RETURN

     C                   ENDIF

     C                   ENDSR
      ****************************************************************
** CPY@
(c) Finastra International Limited 2001
