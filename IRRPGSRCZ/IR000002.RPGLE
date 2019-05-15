     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas IR Data Take-On')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Module                                       *
      *                                                               *
      *  IR000002 - Midas IR Data Take-On                             *
      *                                                               *
      *  Function:  This module will initialise the Deal              *
      *             Authorisation Status in records from files        *
      *             DEALSDG and DLGHISPD.                             *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7411            Date 01Jun05               *
      *                 CDL028             Date 07Feb05               *
      *                 CAS008             Date 16Jun04               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CIR008  *CREATE    Date 13Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG7411- CDL028 fields missing from DLGHISPD (Recompile)     *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CAS008 - IAS 39 Enhancements (Recompile)                     *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CIR008 - FRA/IRS Deals Authorisation                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    15         Error in reading file                           *
      *    25         End of File                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrAudit    - Write Audit Report                              *
      *  SrDeal     - Process Records from file DEALSDG               *
      *  SrFAIS     - Process Records from file SDFAISPD              *
      *  SrHist     - Process Records from file DLGHISPD              *
      *  *PSSR      - Program exception error routine                 *
      *  *INZSR     - Initial First Cycle processing                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas DL FRA/IRS Deals
     FDEALSDG   UF   E             DISK    INFSR(*PSSR) COMMIT
 
      ** Midas DL Historic FRA/IRS Deals
     FDLGHISPD  UF   E             DISK    INFSR(*PSSR) COMMIT
     F                                     PREFIX(H)
 
      ** Midas SD FRA/IRS ICD data
     FSDFAISPD  UF   E             DISK    INFSR(*PSSR) COMMIT
 
      ** Audit file
     FIR000002AUO    E             PRINTER
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D WkFIAU          C                   CONST('FRA/IRS Authorisation +
     D                                     Required Flag')
     D WkFIRA          C                   CONST('FRA/IRS Re-authorisation +
     D                                     Required Flag')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  ErrorOnFl             15     15
     D  EndOfFile             25     25
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
 
      ** Work Variables
     D WRun            S              1A
     D PRtcd           S              7A
     D POptn           S              7A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Process records from file DEALSDG
 
     C                   EXSR      SrDeal
 
      ** Process records from file DLGHISPD
 
     C                   EXSR      SrHist
 
      ** Process records from file SDFAISPD
 
     C                   EXSR      SrFAIS
 
     C                   COMMIT
 
      ** Write File Controls Report
 
     C                   EXSR      SRAudit
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRDeal - Process Records from file DEALSDG                   *
      *****************************************************************
     C     SrDeal        BEGSR
 
     C                   EVAL      RCount1 = *ZERO
 
     C                   READ      DEALSDG                              1525
 
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBFile = 'DEALSDG'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Do while end of file not reached
 
     C                   DOW       EndOfFile = False
 
     C                   IF        FIDSTS = *BLANKS
 
     C                   IF        RECI = 'M'
     C                   EVAL      FIDSTS = 'M'
     C                   ELSE
     C                   EVAL      FIDSTS = 'A'
     C                   ENDIF
 
     C                   UPDATE    DEALSDGF
 
     C                   EVAL      RCount1 = RCount1 + 1
     C                   ENDIF
 
     C                   READ      DEALSDG                              1525
 
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*SECOND'
     C                   EVAL      DBFile = 'DEALSDG'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRHist - Process Records from file DLGHISPD                  *
      *****************************************************************
     C     SrHist        BEGSR
 
     C                   EVAL      RCount2 = *ZERO
 
     C                   READ      DLGHISPD                             1525
 
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBFile = 'DLGHISPD'
     C                   EVAL      DBase = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Do while end of file not reached
 
     C                   DOW       EndOfFile = False
 
     C                   IF        HFIDSTS = *BLANKS
 
     C                   IF        HRECI = 'M'
     C                   EVAL      HFIDSTS = 'M'
     C                   ELSE
     C                   EVAL      HFIDSTS = 'A'
     C                   ENDIF
 
     C                   UPDATE    DLGHISD0
 
     C                   EVAL      RCount2 = Rcount2 + 1
     C                   ENDIF
 
     C                   READ      DLGHISPD                             1525
 
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*SECOND'
     C                   EVAL      DBFile = 'DLGHISPD'
     C                   EVAL      DBase = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrFAIS - Process Records from file SDFAISPD                  *
      *****************************************************************
     C     SrFAIS        BEGSR
 
     C                   READ      SDFAISPD                             1525
 
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBFile = 'SDFAISPD'
     C                   EVAL      DBase = 005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        BQFIAU = *BLANKS OR
     C                             BQFIRA = *BLANKS
 
     C                   IF        BQFIAU = *BLANKS
     C                   EVAL      BQFIAU = 'N'
     C                   EVAL      RField1 = WkFIAU
     C                   ENDIF
     C                   IF        BQFIRA = *BLANKS
     C                   EVAL      BQFIRA = 'N'
     C                   EVAL      RField2 = WkFIRA
     C                   ENDIF
 
     C                   UPDATE    SDFAISD0
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRAudit - Subroutine to Write Audit Report                    *
      *****************************************************************
     C     SrAudit       BEGSR
 
      ** Write File Control Report Heading
 
     C                   WRITE     HEADAU
 
     C                   IF        RCount1 <> *ZERO OR
     C                             RCount2 <> *ZERO OR
     C                             RField1 <> *BLANKS OR
     C                             RField2 <> *BLANKS
     C                   WRITE     CONTROL
     C                   ELSE
     C                   WRITE     NODTLS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Subroutine for Initial First Cycle processing        *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 006
     C                   EVAL      DBKEY = POPTN
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR  - Program exception error routine                      *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANKS
 
     C                   EVAL      WRun = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   DUMP
 
     C                   WRITE     HEADAU
     C                   WRITE     DBERROR
 
     C                   RETURN
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
