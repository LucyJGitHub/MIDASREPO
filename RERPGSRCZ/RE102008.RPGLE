     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE MT101/MT103 Reconciliation Report')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  RE102008 - MT101/MT103 Unreconciled Report Program           *
      *                                                               *
      *  Function: This program lists all outstanding MT101 and MT103 *
      *            messages. Runs on I/C upon request and in COB      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End of file                                     *
      *    02         Record not found                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRINIT - Initialisation                                       *
      * SRPROC - Detail Processing                                    *
      * SRAUDT - Audit Printing                                       *
      * SRPRNT - Detail Printing                                      *
      * SRRCFAU - Audit Spool File recorded by RCF                    *
      * SRRCFP1 - Detail Spool File recorded by RCF                   *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Input Cycle Zero Balancing/Sweeping Dtls by Reference
     FREICSDL5  IF   E           K DISK    INFSR(*PSSR)
 
      ** Msg Management File by Reference
     FMGOREFL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(MG)
 
      ** GL Account Details - Full A/c Number
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
 
      ** Data Replication Error Log Audit Report
     FRE102008AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
 
      ** Data Replication Error Log Detail Report
     FRE102008P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** Standard D Specification
     D/COPY ZACPYSRC,RECMSTDD
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
 
     D MnthArr         S              3    DIM(12) CTDATA PERRCD(12)
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Externally described DS for retail details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
 
      ** Externally described DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** File Information Data Structure for RE102008P1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0
 
      ** File Information Data Structure for RE102008AU
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
     D WTime           DS             6
     D  WHour                  1      2
     D  WMinute                3      4
     D  WSecond                5      6
 
     D WDate           DS             6
     D  WYear                  1      2
     D  WMonth                 3      4
     D  WDay                   5      6
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for ZSFILE
     D PSequence       S              5
     D PLevel          S              1
     D PEntity         S              3
     D SEntity         S              3
     D PZSnum          S              6  0
     D PZSnumU         S              6  0
     D PZSerr          S              1
 
      ** Parameters for access object programs
     D PRTCD           S              7
     D POPTN           S              7
 
      ** Parameters for ZDATE2
     D PDayNo          S              5  0
     D PDatFmt         S              1
     D PDate           S              6  0
     D PADate          S              7
 
      ** Parameters for ZSEDIT
     D PZFld15         S             15  0
     D PZDecs          S              1  0
     D PZECode         S              1
     D PZOut21         S             21
 
     D RqdLn1          S              3P 0
     D DifLn1          S              4P 0
     D PNoDtl          S              1
 
     D PCurr           S              3
 
     D WBrcd           S              3
     D WCust           S              6
     D***WACOD**         S              4                                                     CGL029
     D WACOD           S             10                                                       CGL029
     D WACSQ           S              2
     D WMnth           S              2  0
     D KBrca           S              3
     D WCount          S              5  0
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   EXSR      SRINIT
 
     C                   EXSR      SRPROC
 
     C                   EXSR      SRAUDT
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initialisation                                       *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRRCFAU                                                *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
      ** RCF Processing for Audit File.
 
     C                   EXSR      SRRCFAU
 
      ** Report Work fields.
 
     C                   EVAL      RqdLn1  = 0
     C                   EVAL      DifLn1  = 0
     C                   EVAL      RCount  = 0
     C                   EVAL      WCount  = 0
     C                   EVAL      PrtLn1  = 0
     C                   EVAL      PNoDtl = *BLANK
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPROC - Detail Processing                                    *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRAUDT, SRSysLevel, SRAllBranch, SRSngBranch           *
      *                                                               *
      *****************************************************************
 
     C     SRPROC        BEGSR
 
      ** Process report according to level requested
 
     C                   SELECT
 
      ** System Level
 
     C                   WHEN      PLevel = 'S'
     C                   EVAL      *IN20 = '0'
     C                   EXSR      SRSysLevel
 
      ** All Branch
 
     C                   WHEN      PLevel = 'B' AND PEntity = 'ALL'
     C                   EVAL      *IN20 = '1'
     C                   EXSR      SRAllBranch
 
      ** Single Branch
 
     C                   WHEN      PLevel = 'B' AND PEntity <> 'ALL'
     C                   EVAL      *IN20 = '1'
     C                   EXSR      SRSngBranch
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSysLevel - System Level Processing                          *
      *                                                               *
      * Called by: SRProc                                             *
      *                                                               *
      * Calls: SRRCFP1, SRAUDT, SRPRNT                                *
      *                                                               *
      *****************************************************************
 
     C     SRSysLevel    BEGSR
 
     C                   CLOSE     RE102008P1
     C                   OPEN      RE102008P1
     C                   EXSR      SRRCFP1
 
     C     *LOVAL        SETLL     REICSDL5
 
      ** Read Input Cycle Zero Balancing/Sweeping - Detail
 
     C                   READ      REICSDL5                               01
 
     C                   DOW       *IN01 = *OFF
     C                   IF        IDTPSW = 'T' AND IDMTYN <> 'Y'
     C                   EXSR      SRPRNT
     C                   ENDIF
     C                   READ      REICSDL5                               01
     C                   ENDDO
 
      ** When EOF, write trailer
 
     C                   IF        *IN01 = *ON
     C                   EVAL      RqdLn1 = 3
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   IF        RCount > 0
     C                   WRITE     TRAILP1
     C                   ENDIF
 
     C                   CLOSE     RE102008P1
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAllBranch - Branch Level - All Branch                       *
      *                                                               *
      * Called by: SRProc                                             *
      *                                                               *
      * Calls: SRRCFP1, SRAUDT, SRPRNT                                *
      *                                                               *
      *****************************************************************
 
     C     SRAllBranch   BEGSR
 
     C                   CLOSE     RE102008P1
     C                   OPEN      RE102008P1
     C                   EXSR      SRRCFP1
 
     C     *LOVAL        SETLL     REICSDL5
 
      ** Read Input Cycle Zero Balancing/Sweeping - Detail
 
     C                   READ      REICSDL5                               01
 
     C                   DOW       *IN01 = *OFF
 
     C                   IF        IDTPSW = 'T' AND IDMTYN <> 'Y'
     C                   EVAL      WBrcd = IDCBRC
     C                   EVAL      RBRCA = IDCBRC
     C                   EXSR      SRPRNT
     C                   ENDIF
     C                   READ      REICSDL5                               01
 
     C                   IF        IDCBRC <> WBrcd AND *IN01 = *OFF
     C                   If        WCount > 0
     C                   WRITE     TRAILP1
     C                   Eval      WCount  =  0
     C                   Endif
     C                   CLOSE     RE102008P1
     C                   OPEN      RE102008P1
     C                   EXSR      SRRCFP1
     C                   ENDIF
 
     C                   ENDDO
 
      ** When EOF, write trailer
 
     C                   IF        *IN01 = *ON
     C                   EVAL      RqdLn1 = 3
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   IF        RCount > 0
     C                   WRITE     TRAILP1
     C                   ENDIF
 
     C                   CLOSE     RE102008P1
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSngBranch - Branch Level - Single Branch                    *
      *                                                               *
      * Called by: SRProc                                             *
      *                                                               *
      * Calls: SRRCFP1, SRAUDT, SRPRNT                                *
      *                                                               *
      *****************************************************************
 
     C     SRSngBranch   BEGSR
 
     C                   CLOSE     RE102008P1
     C                   OPEN      RE102008P1
     C                   EXSR      SRRCFP1
 
     C                   EVAL      KBrca = PEntity
     C     KBrca         SETLL     REICSDL5
 
      ** Read Input Cycle Zero Balancing/Sweeping - Detail
 
     C     KBrca         READE     REICSDL5                               01
 
     C                   DOW       *IN01 = *OFF
 
     C                   IF        IDTPSW = 'T' AND IDMTYN <> 'Y'
     C                   EVAL      RBRCA = IDCBRC
     C                   EXSR      SRPRNT
     C                   ENDIF
     C     KBrca         READE     REICSDL5                               01
 
     C                   ENDDO
 
      ** When EOF, write trailer
 
     C                   IF        *IN01 = *ON
     C                   EVAL      RqdLn1 = 3
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   IF        RCount > 0
     C                   WRITE     TRAILP1
     C                   ENDIF
 
     C                   CLOSE     RE102008P1
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPRNT - Detail Printing                                      *
      *                                                               *
      * Called by: SRSysLevel, SRAllBranch, SRSngBranch               *
      *                                                               *
      * Calls: SRDate                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRPRNT        BEGSR
 
     C                   EVAL      RqdLn1 = 2
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        RCOUNT = 0 OR
     C                             DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Access Message Management File (MGOREFL0)
 
     C     IDOMSR        CHAIN     MGOREFL0                           02
 
     C                   IF        *IN02 = *ON
     C                   EVAL      X_ERMS = 'Record not found in MGOREFL0'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Format printer file fields
 
      ** MT101 Transaction Reference Number
 
     C                   EVAL      R01TRN = IDOMSR
 
      ** Top Account
 
     C                   MOVE      IDCCUS        WCust
     C                   MOVE      IDCACD        WACOD
     C                   MOVE      IDCASN        WACSQ
     C                   EVAL      RTACNT = IDCBRC + '-' + WCust +
     C                                      '-' + IDCCCY + '-' + WACOD +
     C                                      '-' + WACSQ
 
      ** If retail account number required print retail number
 
     C                   IF        BMRANR = 'Y'
     C     KList1        CHAIN     ACCNTABF                           02
     C                   MOVE      ACNO          RRETNM
     C                   ENDIF
 
      ** Posting Narrative
 
     C                   IF        IDTNAR <> *BLANKS
     C                   EVAL      RPNARR = IDTNAR
     C                   ELSE
     C                   SELECT
     C                   WHEN      IDSTYP = 'Z'
     C                   EVAL      RPNARR = 'CMZ' + %SUBST(IDEXA1:2)
     C                   WHEN      IDSTYP = 'S'
     C                   EVAL      RPNARR = 'CMS' + %SUBST(IDEXA1:2)
     C                   ENDSL
     C                   ENDIF
 
      ** Destination
 
     C                   EVAL      RDEST = MGNWDS
 
      ** Value Date
 
     C                   EVAL      PDayNo = IDVALD
     C                   EXSR      SRDate
     C                   EVAL      RVDATE = PADate
 
      ** Swift Amount
 
     C                   Z-ADD     IDSWFA        PZFld15
     C                   EXSR      SRCvtAmt
     C                   MOVE      PZOut21       RSAMNT
 
      ** MT101 Generation Date
 
     C                   MOVE      MGMGDE        WDate
     C                   MOVE      WMonth        WMnth
     C                   EVAL      RGDATE = WDay + MnthArr(WMnth) + WYear
 
      ** MT101 Generation Time
 
     C                   MOVE      MGMGTM        WTime
     C                   EVAL      RGTIME = WHour + ':' + WMinute +
     C                                      ':' + WSecond
 
      ** Reconciliation Status
 
     C                   IF        IDDELD = 'Y'
     C                   EVAL      RRCSTS = 'Stopped'
     C                   ELSE
     C                   EVAL      RRCSTS = 'Not Reconciled'
     C                   ENDIF
 
     C                   EVAL      WCOUNT = WCOUNT + 1
     C                   EVAL      RCOUNT = RCOUNT + 1
 
      ** Write Detail
 
     C                   WRITE     DETAIL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDate - Convert Midas Day Number to DDMMMYY                  *
      *                                                               *
      * Called by: SRPRNT                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRDate        BEGSR
 
      ** Convert Processing Date
 
     C                   CALL      'ZDATE2'
     C                   PARM                    PDayNo
     C                   PARM      BJDFIN        PDatFmt
     C                   PARM                    PDate
     C                   PARM                    PADate
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCvtAmt - Convert Amount                                     *
      *                                                               *
      * Called by: SRPRNT                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRCvtAmt      BEGSR
 
      ** Access currency file to get decimal places
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      IDCCCY        PCURR
     C     SDCURR        PARM      SDCURR        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      X_ERMS = 'Call to AOCURRR0 in error'
     C                   EXSR      *PSSR
     C                   ELSE
     C                   Z-ADD     A6NBDP        PZDecs
     C                   ENDIF
 
      ** Convert Amount
 
     C                   CALL      'ZSEDIT'
     C                   PARM                    PZFld15
     C                   PARM                    PZDecs
     C                   PARM      'J'           PZECode
     C                   PARM                    PZOut21
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAUDT - Audit Printing                                       *
      *                                                               *
      * Called by: Main Processing, SRPROC, *PSSR                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRAUDT        BEGSR
 
      ** Write Audit Header
 
     C                   WRITE     HEADAU
 
     C                   IF        *INU7 = '1' AND
     C                             *INU8 = '1'
 
      ** Write Database Error Report
 
     C                   EVAL      ERRDES = X_ERMS
     C                   IF        ERRDES = *BLANKS
     C                   EVAL      ERRDES = 'Unidentified Error'
     C                   ENDIF
 
     C                   WRITE     DBERROR
     C                   ELSE
 
     C                   IF        RCOUNT = 0
 
      ** Write No Details to Report
 
     C                   WRITE     NODTLS
     C                   EVAL      PNoDtl = 'Y'
     C                   ELSE
 
      ** Write Audit Control Report
 
     C                   WRITE     CONTROL
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      *INLR = '1'
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRCFP1 - Detail Spool File recorded by RCF                   *
      *                                                               *
      * Called by: SRPROC                                             *
      *                                                               *
      * Calls: ZSFILE                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRRCFP1       BEGSR
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      PZSnum = PSFNum1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSequence
     C                   PARM      WBrcd         SEntity
     C                   PARM                    PSFile1
     C                   PARM                    PZSnum
     C                   PARM      *BLANK        PZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C                   IF        PZSerr = 'Y'
     C                   EVAL      X_ERMS = 'Call to ZSFILE in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRCFAU - Audit Spool File recorded by RCF                    *
      *                                                               *
      * Called by: SRINIT                                             *
      *                                                               *
      * Calls: ZSFILE                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRRCFAU       BEGSR
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   EVAL      PZSnumU = PSFNumU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSequence
     C                   PARM      *Blanks       SEntity
     C                   PARM                    PSFileU
     C                   PARM                    PZSnumU
     C                   PARM      *Blank        PZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     PZSerr        IFEQ      'Y'
     C                   EVAL      X_ERMS = 'Call to ZSFILE in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PSequence
     C                   PARM                    PLevel
     C                   PARM                    PEntity
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      X_ERMS = 'Call to AOBANKR0 in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Retail Details
 
     C                   CALLB     'AORETLR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDRETL        PARM      SDRETL        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      X_ERMS = 'Call to AORETLR0 in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Key list to access ACCNTL0
 
     C     KList1        KLIST
     C                   KFLD                    IDCCUS
     C                   KFLD                    IDCCCY
     C                   KFLD                    IDCACD
     C                   KFLD                    IDCASN
     C                   KFLD                    IDCBRC
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
**  MnthArr - Months in short names
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
