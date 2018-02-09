     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Price Type Update of Security Collaterals')   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000010 - Price Type Update of Security Collaterals         *
      *                                                               *
      *  Function:  This is a new program to perform the automatic    *
      *             update of the price type of all security          *
      *             collateral items as triggered by a change in the  *
      *             ICD setup for Collaterals. This will produce      *
      *             a report of all successful/unsuccessful updates.  *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE040             Date 05Jul04               *
      *                 BUG3644            Date 12Jul04               *
      *                 CGL014  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE040 - Collateralised Lending Phase 2 (Recompile)          *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  CGL014 - Collaterals Processing                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    05  - Overflow Indicator GL000010P1                        *
      *    06  - Overflow Indicator GL000010P2                        *
      *    15  - UPDATE error indicator                               *
      *                                                               *
      *  U7+U8 - Data Base Error (job switch)                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRMain - Main Processing                                     *
      *  SRTerm - Termination Processing                              *
      *  SRRCFProc - RCF processing                                   *
      *  *PSSR  - Error Handling Subroutine                           *
      *  *INZSR - Initialisation                                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+                     *
      ** ¦ F-specs                              ¦                     *
      ** ¦ =======                              ¦                     *
      ** +--------------------------------------+                     *
 
     FGLCOLLLE  UF   E           K DISK    INFSR(*PSSR)
      ** RTV: Collateral Details by Processing Type
 
     FPMPORTLL  IF   E           K DISK    INFSR(*PSSR)
      ** RTV: Live portfolio definition details
 
     FGL000010P1O    E             PRINTER INFSR(*PSSR)
     F                                     OFLIND(*IN05)
     F                                     USROPN
     F                                     INFDS(SPOOL)
      ** RPT: Unsuccessful Update of Security Collaterals
 
     FGL000010P2O    E             PRINTER INFSR(*PSSR)
     F                                     RENAME(GL0010R0:GL0010X0)
     F                                     RENAME(GL0010R1:GL0010X1)
     F                                     RENAME(GL0010R2:GL0010X2)
     F                                     OFLIND(*IN06)
     F                                     USROPN
     F                                     INFDS(SPOOL2)
      ** RPT: Successful Update of Security Collaterals
 
     FGL000010AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
      ** RPT: Price Type Update of Security Collaterals Audit
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
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
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D WRUN            S              1
     D PRTCD           S              7
     D POPTN           S              7
     D KHXBRC          S              3
     D KHXREF          S             10
     D WRecCount       S              5S 0
     D WErrCount       S              5S 0
     D WSucCount       S              5S 0
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Aacces Programs, Long Data Structure
 
     D SDCOCC        E DS                  EXTNAME(SDCOCCPD)
      ** Collateral and Credit Control Accessed via Access Program
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External DS for Midas modules details
 
     D  @JOB                 244    253
     D  @USER                254    263
 
     D SPOOL           DS
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
      ** SPOOL Information Data Structure for ZSFILE
 
     D SPOOL2          DS
     D  SFILE2                83     92
     D  SFNUM2               123    124B 0
      ** SPOOL Information Data Structure for ZSFILE
 
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      ** SPOOL Information Data Structure for ZSFILE - AU Report
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PSEQ            S              5
     D PLEV            S              1
     D PENTY           S              3
     D PSFILE          S             10
     D PZSNUM          S              6  0
     D PZSERR          S              1
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Main Processing
 
     C                   EXSR      SRMAIN
 
      ** Termination Processing
 
     C                   EXSR      SRTerm
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMain - Main Processing                                     *
      *                                                               *
      *****************************************************************
 
     C     SRMain        BEGSR
 
      ** Process only pledged collateral items
 
     C                   EVAL      CDCOPT = 'P'
 
     C     CDCOPT        SETLL     GLCOLLLE
     C     CDCOPT        READE     GLCOLLLE
 
     C                   DOW       NOT %EOF(GLCOLLLE)
 
     C                   EVAL      RCOLRE = *BLANKS
     C                   EVAL      RBRNCH = *BLANKS
     C                   EVAL      RSCRTY = *BLANKS
     C                   EVAL      RCUSTR = *BLANKS
     C                   EVAL      RPRTFL = *BLANKS
     C                   EVAL      RPRTYP = *BLANKS
 
      ** Format report detail fields
 
     C                   EVAL      RCOLRE = CDCREF
     C                   EVAL      RBRNCH = CDBRCA
     C                   EVAL      RSCRTY = CDCSEC
     C                   MOVE      CDCNUM        RCUSTR
 
     C     CDCNUM        CHAIN     PMPORTLL
     C                   IF        %FOUND(PMPORTLL)
     C                   EVAL      RPRTFL = PNPTFR
     C                   ENDIF
 
     C                   SELECT
     C                   WHEN      CDPRTP = 'B'
     C                   EVAL      RPRTYP = 'Bid'
     C                   WHEN      CDPRTP = 'M'
     C                   EVAL      RPRTYP = 'Mid'
     C                   WHEN      CDPRTP = 'O'
     C                   EVAL      RPRTYP = 'Offer'
     C                   ENDSL
 
     C                   EVAL      CDPRTP = CCDCPS
     C                   UPDATE    GLCOLLD0                             15
 
      ** Error in updating the record
 
     C                   IF        *IN15 = *ON
 
      ** Increment number of unsuccessful updates
 
     C                   ADD       1             WErrCount
 
     C                   IF        WErrCount = 1
     C                   OPEN      GL000010P1
 
      ** Ensure report file is recorded by RCF
 
     C                   Z-ADD     SFNUM         PZSNUM
     C                   MOVE      SFILE         PSFILE
     C                   EXSR      SRRCFProc
 
      ** Write header
 
     C                   WRITE     GL0010R0
     C                   ENDIF
 
      ** If overflow indicator, print header on next page
 
     C                   IF        *IN05 = *ON
     C                   WRITE     GL0010R0
     C                   EVAL      *IN05 = *OFF
     C                   ENDIF
 
     C                   WRITE     GL0010R1
 
     C                   ELSE
 
      ** Increment number of successful updates
 
     C                   ADD       1             WSucCount
 
     C                   IF        WSucCount = 1
     C                   OPEN      GL000010P2
 
      ** Ensure report file is recorded by RCF
 
     C                   Z-ADD     SFNUM2        PZSNUM
     C                   MOVE      SFILE2        PSFILE
     C                   EXSR      SRRCFProc
 
      ** Write header
 
     C                   WRITE     GL0010X0
     C                   ENDIF
 
      ** If overflow indicator, print header on next page
 
     C                   IF        *IN06 = *ON
     C                   WRITE     GL0010X0
     C                   EVAL      *IN06 = *OFF
     C                   ENDIF
 
     C                   WRITE     GL0010X1
     C                   ENDIF
 
      ** Increment number of records processed
 
     C                   ADD       1             WRecCount
 
      ** Read next record
 
     C     CDCOPT        READE     GLCOLLLE
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTerm - Termination processing                              *
      *                                                               *
      *****************************************************************
 
     C     SRTerm        BEGSR
 
      ** Print audit report
 
     C                   Z-ADD     WRecCount     RPCALC
     C                   Z-ADD     WErrCount     RUCALC
     C                   Z-ADD     WSucCount     RSCALC
 
      ** Write header and details
 
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
 
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
     C                   IF        WRecCount = 0
     C                   WRITE     NODTLS
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCFProc - RCF processing                                   *
      *                                                               *
      *****************************************************************
 
     C     SRRCFProc     BEGSR
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM                    PENTY
     C                   PARM                    PSFILE
     C                   PARM                    PZSNUM
     C                   PARM      *BLANK        PZSERR
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     PZSERR        IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PSEQ
     C                   PARM                    PLEV
     C                   PARM                    PENTY
 
      ** Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = '*FIRST'
     C                   EVAL      DBASE  = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Collateral and Credit Control ICD
 
     C                   CALL      'AOCOCCR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDCOCC        PARM      SDCOCC        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCOCCPD'
     C                   EVAL      DBKEY  = '*FIRST'
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Midas Modules file to check if Portfolio Management and/or
      ** Private Banking is on
 
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBKEY  = '*FIRST'
     C                   EVAL      DBASE  = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If Portfolio Management or Private Banking is on,
      ** display/enable Portfolio field in report
 
     C                   IF        BGPFMG = 'Y'  OR  BGN4ST = 'Y'
     C                   EVAL      *IN25 = *ON
     C                   ENDIF
 
      ** Ensure audit report is recorded by RCF
 
     C                   Z-ADD     SFNUMU        PZSNUM
     C                   MOVE      SFILEU        PSFILE
     C                   EXSR      SRRCFProc
 
      ** Initialise record counters
 
     C                   EVAL      WRecCount = 0
     C                   EVAL      WErrCount = 0
     C                   EVAL      WSucCount = 0
 
      ** Key list for LF/GLCOLLQ0
 
     C     KCOLLQ        KLIST
     C                   KFLD                    KHXBRC
     C                   KFLD                    KHXREF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Error handling subroutine                            *
      *          Executes whenever field or program exception         *
      *          error occurs                                         *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        WRUN  = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   EVAL      DBPGM = 'GL000010'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EXSR      SRTerm
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2003
