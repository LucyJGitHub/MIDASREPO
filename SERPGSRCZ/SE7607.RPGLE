     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE MT565 not sent to depot report')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE7607 - MT565 not sent to depot report                      *
      *                                                               *
      *  Function: This module will list by Security and by depot     *
      *            all the position settlement that do not have       *
      *            MT565 generated.                                   *
      *                                                               *
      *  Component of: SEC7607 - MT565 no sent to depot report        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 193312             Date 18May01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 190204             Date 31May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 187808             Date 21Dec00               *
      *                 187609             Date 21Dec00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023  *CREATE    Date 12Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  193312 - To avoid Database Error if if event is created      *
      *           by using position settelement I/C option            *
      *           In this case, evnet does not exist in file SEDEVD   *
      *  190204 - Changed Dividend per Unit format from 9N0 to 13N8.  *
      *  187808 - Print total for each break instead of a grand total *
      *  187609 - Wrong number of decimal places for Total Holding    *
      *  CSE023 - Treaty Withholding Tax                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End of Report Narrative printing                *
      *   02-03       File processing (CHAIN/READ)                    *
      *    04         Chain fail on SECTY                             *                       187609
      ****05-08*******Total*holdings*amount*format                    *                       187808
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRProc       - Detail Processing                             *
      *  SRChkPrc     - Write record to report                        *
      *  SRRept       - Perform detail processing                     *
      *  SRWrec       - Write record to report                        *
      *  SRTotal      - Write depot total                             *
      *  SRHalfAdj    - Half-adjust amount based on nominal dec places*
      *  SRFmtAmt     - Format Amount                                 *
      *  SRRcAu       - RCF Processing for Audit Report               *
      *  SRRcP1       - RCF Processing for P1 Report                  *
      *  SRAudt       - Produce Audit Report and End Program          *
      *  *INZSR       - Initialise                                    *
      *  *PSSR        - Program Error Processing Subroutine           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Position settlement by Depot without SWIFT details file
     FPOSETW5   IF   E           K DISK    INFSR(*PSSR)
      *
      ** Security events by Type
     FSECED     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F)
      *
      ** Corporate Action Reference
     FSECORFLC  IF   E           K DISK    INFSR(*PsSR)
      *
      ** Corporate Actions Dividend
     FSECODVL2  IF   E           K DISK    INFSR(*PsSR)
      *                                                                                       187609
      ** Securities details                                                                   187609
     FSECTY     IF   E           K DISK    INFSR(*PSSR)                                       187609
     F                                     PREFIX(S_)                                         187609
      *
      ** MT565 not sent to depot report - Details
     FSE7607P1  O    E             PRINTER INFDS(SPOOL1)
     F                                     OFLIND(*IN50)
     F                                     USROPN
      *
      ** MT565 not sent to depot report - Audit
     FSE7607AU  O    E             PRINTER INFDS(SPOOLU)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D SPOOL1          DS
      *
      ** File Information Data Structure for SE7607P1.
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
      *
     D SPOOLU          DS
      *
      ** File Information Data Structure for SE7607AU.
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
      *
      ** Due Date
     D RDDAT           DS
     D  RDAT1                  1      2A
     D  RDAT2                  3      4A
     D  RDAT3                  5      6A
      *
      ** From Date
     D RFDAT           DS
     D  RFMNT                  1      2A
     D  RFDAY                  3      4A
     D  RFYR                   5      6A
      *
      ** To Date
     D RTDAT           DS
     D  RTMNT                  1      2A
     D  RTDAY                  3      4A
     D  RTYR                   5      6A
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Externally described DS for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Objects - very long data structure
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Parameters for module AOCUSTR1.
     D PCust           S             10A
     D PCnCd           S              2A
     D PKyst           S              7A
      *
      ** RCF parameter variables.
     D PPSeq           S              5A
     D PRtcd           S              7A
     D POptn           S              7A
     D PCcy            S              3A
     D WNBDP           S              1P 0
 
     D RQDLN1          S              3P 0
     D DIFLN1          S              3P 0
     D SENTY           S              3A
     D ZSERR           S              1A
     D ZSNUM           S              6P 0
     D ZSNUMU          S              6P 0
      *
      ** Parameter list for ZDATE2.
     D PDateIn         S              5P 0
     D PDateOut        S              6P 0
     D PADateOut       S              7A
      *
      ** Parameter list for ZSEDITF.
     D PAmtIn          S             15P 0
     D WOAmt           S             15P 8
     D WAmt0           S             15P 0
     D WAmt1           S             15P 1
     D WAmt2           S             15P 2
     D WAmt3           S             15P 3
     D WPrtRec         S              1A   INZ('Y')
     D WPevt           S              2A
     D OldPDUD         S              5  0
     D OldPEVT         S              2A
     D PZDecs          S              1P 0
     D PZECode         S              1A
     D PZEChar         S              1A
     D PZOut21         S             21A
      *
      ** Work variables.
     D WCPY            S              6A
     D*WTNMP*****      S             19P 0                                                    187808
     D WTNMP           S             15P 0                                                    187808
     D WCount          S              3P 0
     D WRun            S              1A
     D WriteHead       S              1A
     D W1stRec         S              1A                                                      187808
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Perform detail processing.
      *
     C                   EXSR      SRProc
      *
      ** Return.
      *
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Perform detail processing                           *
      *                                                               *
      *****************************************************************
     C     SRProc        BEGSR
      *
      ** Read first record from file.
      *
     C     *LOVAL        SETLL     POSETW5
     C                   READ      POSETW5                                02
 
     C                   EVAL      WCount = *ZERO
 
     C                   DOW       *IN02 = *OFF
      *
      ** Process record for reporting.
      *
     C                   EVAL      WCount = WCount + 1
     C                   EXSR      SRchkPrc
      *
     C                   IF        WPrtRec = 'Y'
     C                   EXSR      SRRept
     C                   ENDIF
      *
      ** Read next record.
      *
     C                   READ      POSETW5                                02
 
     C                   ENDDO
      *
      ** Perform audit reporting if no records processed. Otherwise,
      ** perform hash totals.
      *
     C                   IF        WCount = *ZERO
     C                   EXSR      SRAudt
     C                   ELSE
     C                   EVAL      *IN01 = *ON
     C                   EXSR      SRTotal
     C                   ENDIF
      *
      ** Close printer file.
      *
     C                   CLOSE     SE7607P1
     C                   EXSR      SRRCP1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkPrc - Check if security is to be reported               *
      *                                                               *
      *****************************************************************
 
     C     SRChkPrc      BEGSR
 
      ** Get dividend/coupon rate amounts from Security events
      ** file using security shortname.
 
     C                   EVAL      WPrtRec = 'Y'
     C                   IF        PEVT = 'CP' OR
     C                             PEVT = 'DV'
      *                                                                                       193312
      * Check if date generated is zero. In this case record does not exists                  193312
      * in diary events file                                                                  193312
      *                                                                                       193312
     C     PDTG          IFEQ      0                                                          193312
     C                   EXSR      SRpos                                                      193312
      *                                                                                       193312
     C                   EVAL      WPevt = PEVT                                               193312
      *                                                                                       193312
     C                   ELSE                                                                 193312
      *                                                                                       193312
     C     KPARM         CHAIN     SECED                              03
 
     ** If record not found, chain for 'CG' event type
 
     C                   IF        *IN03 AND
     C                             PEVT = 'CP'
     C                   EVAL      WPevt = PEVT
     C                   EVAL      PEVT = 'CG'
     C     KPARM         CHAIN     SECED                              03
     C                   EVAL      PEVT = WPevt
     C                   ENDIF
 
      ** database error if not found
 
     C                   IF        *IN03 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PSSH + RDDAT + PEVT
     C                   EVAL      DBFILE = 'SECED   '
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
 
      ** Save coupon rate to be used for output
 
     C                   IF        PEVT = 'CP'
     C                   Z-ADD     FSNCR         WOAmt
     C                   ELSE
     C                   Z-ADD     FSDVA         WOAmt
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                193312
     C                   ELSE
 
      ** If event type is not maturity
 
     C                   IF        PEVT <> 'MT'
     C     KPARM         CHAIN     SECORFD0                           03
 
      ** If record found on Corporate actions file - dividend, check on
      ** Corporate Actions dividend file, otherwise, do not process
 
     C                   IF        NOT *IN03
     C     MACORF        CHAIN     SECODVD0                           03
 
      ** If found, use dividend per unit amount for coupon rate,
      ** otherwise, do not process
 
     C                   IF        NOT *IN03
     C**********         EVAL      WOAmt = MDDIVU                                             190204
     C                   EVAL      WOAmt = MDDIV1                                             190204
     C                   ELSE
     C                   EVAL      WPrtRec = 'N'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WPrtRec = 'N'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRept - Perform detail processing                           *
      *                                                               *
      *****************************************************************
     C     SRRept        BEGSR
 
     C                   EVAL      WriteHead = 'N'
      *
      ** Check if depot changes.
      *
     C                   MOVE      PCPY          WCPY
      *
     C                   IF        WCPY <> RDPOT
      *
      ** If not first record read, process totals for the
      ** customer.
     C                   IF        WPrtRec = 'Y'
     C                   IF        RDPOT <> *BLANKS
     C                   EXSR      SRTotal
     C                   Z-ADD     *ZERO         WTNMP
     C                   ELSE                                                                 187808
     C                   EVAL      W1stRec = 'Y'                                              187808
     C                   ENDIF
     C                   ENDIF
      *
      ** Get depot report name.
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      WCPY          PCust
     C                   PARM      *BLANKS       PKyst
     C     SDCUST        PARM      SDCUST        DSLDY
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = WCPY
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      RDPOT = BBCUST
     C                   EVAL      RDRPN = BBCRNM
 
     C                   EVAL      WriteHead = 'Y'
     C                   ENDIF
      *
      ** Check if Security changes.
      *
     C                   IF        PSSH <> RSESN OR
     C                             PDUD <> OldPDUD OR
     C                             PEVT <> OldPEVT
      *                                                                                       187808
      ** If so, print total.                                                                  187808
      *                                                                                       187808
     C                   IF        W1stRec = 'Y'                                              187808
     C                   EVAL      W1stRec = 'N'                                              187808
     C                   ELSE                                                                 187808
     C                   EXSR      SRTotal                                                    187808
     C                   ENDIF                                                                187808
      *                                                                                       187808
     C                   EVAL      RSESN = PSSH
     C                   EVAL      OldPDUD= PDUD
     C                   EVAL      OldPEVT= PEVT
      *
      ** Format Due date.
     C                   Z-ADD     PDUD          PDateIn
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDateIn
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PDateOut
     C                   PARM      *BLANKS       PADateOut
     C                   MOVEL     PDateOut      RDDAT
      *
      ** Event type.
     C                   EVAL      RETYP = PEVT
      *
      ** Get nominal currency details.
     C                   EVAL      RCCCY = PNCY
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      PNCY          PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Z-ADD     A6NBDP        WNBDP
      *
      ** Amount of Dividend/Coupon Rate.
      *
 
     C                   IF        WPrtRec = 'Y'
 
     C                   EXSR      SRHalfAdj
     C                   Z-ADD     WNBDP         PZDecs
     C                   EXSR      SRFmtAmt
     C                   EVAL      RCDRT = PZout21
 
     C                   WRITE     SE7607H1
     C                   EVAL      WriteHead = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
      ** Write sub-header details.
      *
     C                   IF        WPrtRec = 'Y'
     C                   IF        WriteHead = 'Y'
     C                   WRITE     SE7607H2
     C                   WRITE     SE7607H3
     C                   ENDIF
      *
      ** Process record details.
      *
     C                   EXSR      SRWRec
     C                   ENDIF
     C
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWRec - Process record details                              *
      *                                                               *
      *****************************************************************
     C     SRWRec        BEGSR
      *
      ** Beneficial owner no.
      *
     C                   EVAL      RBOWN = BNFO
      *
      ** Tax basket.
      *
     C                   EVAL      RTXBS = TXBS
      *
      ** Nominal position.
      *
     C     PSSH          CHAIN     SECTY                              04                      187609
                                                                                              187609
     C                   IF        *IN04 = *ON                                                187609
     C     *LOCK         IN        LDA                                                        187609
     C                   EVAL      DBKEY = PSSH                                               187609
     C                   EVAL      DBFILE = 'SECTY   '                                        187609
     C                   EVAL      DBASE = 5                                                  187609
     C                   OUT       LDA                                                        187609
     C                   EXSR      *PSSR                                                      187609
     C                   ENDIF                                                                187609
                                                                                              187609
     C                   Z-ADD     S_NMDP        PZDecs                                       187609
     C                   Z-ADD     PNMP          PAmtIn
     C                   EXSR      SRFmtAmt
     C                   EVAL      RNPOS = PZout21
     C                   ADD       PNMP          WTNMP
      *
      ** Check that sufficient lines remain for the format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     SE7607H1
     C                   WRITE     SE7607H2
     C                   WRITE     SE7607H3
     C                   ENDIF
      *
      ** Write out detail record.
      *
     C                   WRITE     SE7607D1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTotal - Write depot total                                  *
      *                                                               *
      *****************************************************************
     C     SRTotal       BEGSR
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     4             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     SE7607H1
     C                   WRITE     SE7607H2
     C                   ENDIF
      *
      ** Format total holdings total.
      *
     C***********        MOVEA     '0000'        *IN(05)                                      187808
      ***********                                                                             187808
     C***********        SELECT                                                               187808
     C***********        WHEN      WNBDP = 1                                                  187609
     C***********        WHEN      S_NMDP = 1                                          187609 187808
     C***********        EVAL      *IN06 = *ON                                                187808
     C***********        Z-ADD     WTNMP         RTNMP1                                       187808
      ***********                                                                             187808
     C***********        WHEN      WNBDP = 2                                                  187609
     C***********        WHEN      S_NMDP = 2                                          187609 187808
     C***********        EVAL      *IN07 = *ON                                                187808
     C***********        Z-ADD     WTNMP         RTNMP2                                       187808
      ***********                                                                             187808
     C***********        WHEN      WNBDP = 3                                                  187609
     C***********        WHEN      S_NMDP = 3                                          187609 187808
     C***********        EVAL      *IN08 = *ON                                                187808
     C***********        Z-ADD     WTNMP         RTNMP3                                       187808
      ***********                                                                             187808
     C***********        OTHER                                                                187808
     C***********        EVAL      *IN05 = *ON                                                187808
     C***********        Z-ADD     WTNMP         RTNMP0                                       187808
     C***********        ENDSL                                                                187808
                                                                                              187808
     C                   Z-ADD     S_NMDP        PZDecs                                       187808
     C                   Z-ADD     WTNMP         PAmtIn                                       187808
     C                   EXSR      SRFmtAmt                                                   187808
     C                   EVAL      RTotal = PZout21                                           187808
      *
      ** Write subtotal format.
      *
     C                   WRITE     SE7607T1
 
     C                   Z-ADD     *ZERO         WTNMP                                        187808
                                                                                              187808
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHalfAdj - Half adjust 13,8 amounts based on nominal dec.   *
      *              places                                           *
      *                                                               *
      *****************************************************************
     C     SRHalfAdj     BEGSR
 
     C                   Z-ADD     *ZERO         PAmtIn
 
     C                   SELECT
     C                   WHEN      WNBDP = 1
     C                   Z-ADD(H)  WOAmt         WAmt1
     C                   Z-ADD     WAmt1         WOamt
     C                   MOVE      WAmt1         PAmtIn
 
     C                   WHEN      WNBDP = 2
     C                   Z-ADD(H)  WOAmt         WAmt2
     C                   Z-ADD     WAmt2         WOamt
     C                   MOVE      WAmt2         PAmtIn
 
     C                   WHEN      WNBDP = 3
     C                   Z-ADD(H)  WOAmt         WAmt3
     C                   Z-ADD     WAmt3         WOamt
     C                   MOVE      WAmt3         PAmtIn
 
     C                   OTHER
     C                   Z-ADD(H)  WOAmt         WAmt0
     C                   Z-ADD     WAmt0         WOamt
     C                   MOVE      WAmt0         PAmtIn
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtAmt - Format amount for display                         *
      *                                                               *
      *****************************************************************
     C     SRFmtAmt      BEGSR
 
     C                   CALLB     'ZSEDITF'
     C                   PARM                    PAmtIn
     C                   PARM                    PZDecs
     C                   PARM      'J'           PZECode
     C                   PARM      *BLANK        PZEChar
     C                   PARM                    PZOut21
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCAu - Subroutine to register the AU Printer File via RCF. *
      *                                                               *
      *****************************************************************
     C     SRRCAu        BEGSR
 
     C                   Z-ADD     SFNUMU        ZSNUMU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PPSEQ
     C                   PARM      *BLANKS       SENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM      *BLANK        ZSERR
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C
     C     ZSERR         IFEQ      'Y'
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
      *  SRRCP1 - Subroutine to register the P1 Printer File via RCF. *
      *                                                               *
      *****************************************************************
     C     SRRCP1        BEGSR
 
     C                   Z-ADD     SFNUM1        ZSNUM
      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PPSEQ
     C                   PARM                    SENTY
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C
     C     ZSERR         IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudt - Subroutine to Output Audit report and End Program.  *
      *                                                               *
      *****************************************************************
     C     SRAudt        BEGSR
      *
      ** Output Report header.
      *
     C                   WRITE     SE7607A1
      *
      ** If there is a DB Error, Output the DB Error Information.
      *
     C                   IF        *INU7 =  *ON
     C                   WRITE     DBERROR
     C                   ELSE
      *
      ** If no records read, Output "No Details" message.
      *
     C                   IF        WCount = *ZERO
     C                   WRITE     SE7607A2
     C                   ENDIF
     C                   ENDIF
      *
      ** End Program and Return.
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = PSProcPgm
     C                   OUT       LDA
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Generate audit report.
      *
     C                   EXSR      SRRCAU
      *
      ** Report Work fields.
      *
     C                   EVAL      RQDLN1 = *ZERO
     C                   EVAL      DIFLN1 = *ZERO
      *
      ** Define key lists.
      *
     C     KPARM         KLIST
     C                   KFLD                    PSSH
     C                   KFLD                    PDUD
     C                   KFLD                    PEVT
      *
      ** Open printer file.
      *
     C                   OPEN      SE7607P1
     C                   EXSR      SRRCP1
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
      ** Check to see that *PSSR has not already been called.
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   EXSR      SRAudt
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
 
      *********************************************************************                   193312
      /EJECT                                                                                  193312
      *********************************************************************                   193312
      *                                                                   *                   193312
      * SRpos  - Subroutine to retrieve values needed by pgm if           *                   193312
      *          diary event does not exist                               *                   193312
      *                                                                   *                   193312
      * Called by:  SRChkPrc                                              *                   193312
      *                                                                   *                   193312
      * Calls: None                                                       *                   193312
      *                                                                   *                   193312
      *********************************************************************                   193312
     C     SRpos         BEGSR                                                                193312
                                                                                              193312
     C     PSSH          CHAIN     SECTY                              41                      193312
     C                   IF        *IN41                                                      193312
     C     *LOCK         IN        LDA                                                        193312
     C                   EVAL      DBKEY = PSSH                                               193312
     C                   EVAL      DBFILE = 'SECTY'                                           193312
     C                   EVAL      DBASE = 009                                                193312
     C                   OUT       LDA                                                        193312
     C                   EVAL      *INU7 = '1'                                                193312
     C                   EVAL      *INU8 = '1'                                                193312
     C                   EXSR      *PSSR                                                      193312
     C                   ELSE                                                                 193312
     C                   IF        PEVT = 'CP'                                                193312
     C                   EVAL      S_CPNR = FSNCR                                             193312
     C                   EVAL      WOAmt = FSNCR                                              193312
     C                   END                                                                  193312
                                                                                              193312
     C                   IF        PEVT = 'DV'                                                193312
     C     PAMD          DIV       PNMP          FSDVA                                        193312
     C                   EVAL      WOAmt = FSDVA                                              193312
     C                   END                                                                  193312
     C                   END                                                                  193312
                                                                                              193312
     C                   ENDSR                                                                193312
                                                                                              193312
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
