     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Extract Program for Reporting')               *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000660 - Midas GL Extract Program for Reporting            *
      *                                                               *
      *  Function: This is run and create extract necessary for       *
      *            FATCA Report Management details.                   *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD043973           Date 03Feb17               *
      *                 MD042683           Date 22Nov16               *
      *                 CGL154  *CREATE    Date 13Oct14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD043973 - FATCA Account closed file entries are not         *
      *             transferred to FATCA EOY archive file (Recompile) *
      *  MD042683 - Daily Accounts Closed/Transferred File cant store *
      *             reported closed/transferred Accounts under        *
      *             Joint Account Members                             *
      *  CGL154 - FATCA Reporting                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7  - DBERR                                                *
      *    U8  - DBERR                                                *
      *    LR                                                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRAccACUS     - Access Additional Customer File              *
      *  SRAccCountry  - Access Country Codes File                    *
      *  SRAccCust     - Access Customer Details file                 *
      *  SRAccCUSX     - Access Customer Details Ext C                *
      *  SRAccFTCS     - Access FATCA Customer Details File           *
      *  SRCAPA        - Get GL Customer Activity/Payment Amounts     *
      *  SRCSBA        - Get GL Customer Balances Collection          *
      *  SRFCAB        - Get GL FATCA Closed Account Balance          *
      *                                                               *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
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
 
      ** Midas SD Customer Details File
     FSDFTCSL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Customer Details Ext C
     FSDCUSXL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas GL FATCA Customer Activity/Payment Amounts
     FGLCAPAL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas GL FATCA Account Balance Close
     FGLFCABL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas GL FATCA Customer Balance Collection File
     FGLCSBAL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas GL Report Management Extract File
     FGLRMEXPD  O    E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
 
      ** External data structure for Country Codes
     D GLRMEX        E DS                  EXTNAME(GLRMEXPD)
 
      ** External data structure for Switchable Features Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for Country Codes
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
 
      ** External data structure for Country Codes
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External data structure for Country Codes
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
 
      ** External data structure for Country Codes
     D SDACUS        E DS                  EXTNAME(SDACUSPD)
 
      ** External data structure for Country Codes
     D SDFTCS        E DS                  EXTNAME(SDFTCSPD)
 
      ** External data structure for Country Codes
     D SDFTNH        E DS                  EXTNAME(SDFTNHPD)
 
      ** External data structure for Branch Code Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D QQDFA1        E                     EXTFLD(QQDFAC)
 
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Second DS for access programs, long data structure
     D DSLDY         E DS                  EXTNAME(DSLDY)
 
     D GLFATCA         DS
     D  WFATCAD                1      1
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** AOCUSTR0 Parameters
     D PCNST           S              7
 
     D PCUST           S             10
     D PMODE           S              1
     D PRTCD           S              7
     D PRetrnCode      S              7
     D POPTN           S              7
     D WRun            S              1
     D WCUST           S              6
     D WNAHO           S             10
     D POption         S              7
     D WASeq           S              2
     D WAcod           S             10
 
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
 
      ** Main Program
 
 
      ** Initialise and load subfile page
 
     C                   EXSR      SRCAPA
     C                   EXSR      SRCSBA
 
     C     *LOCK         IN        GLFATCA
     C                   EVAL      WFATCAD = ' '
     C                   OUT       GLFATCA
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCAPA - Get GL Customer Activity/Payment Amounts             *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     SRCAPA        BEGSR
 
     C     *LOVAL        SETLL     GLCAPAL0
     C                   READ      GLCAPAL0
 
      ** Record found.
 
     C                   DOW       NOT %EOF(GLCAPAL0)
 
 
     C                   IF        CPCUSD <> ' '
     C                   IF        PCUST  <> CPCUSD
     C                   CLEAR                   GLRMEX
     C                   EVAL      EXFILE = 'CAPA'
     C                   EVAL      PCUST  = *BLANKS
     C                   MOVE      CPCUSD        PCUST
     C                   EXSR      SRAccCust
     C                   EXSR      SRAccCountry
     C                   EXSR      SRAccACUS
     C                   EXSR      SRAccFTCS
     C                   EXSR      SRAccCUSX
     C                   ENDIF
 
     C                   EVAL      EXCOLC = BBCOLC
     C                   ELSE
     C                   CLEAR                   GLRMEX
     C                   EVAL      EXFILE = 'CAPA'
     C                   ENDIF
     C                   EVAL      EXBRCH = CPBRCH
     C                   EVAL      EXCUSD = CPCUSD
     C                   EVAL      EXACNO = CPACNO
     C                   EVAL      EXCCY  = CPCCY
     C                   EVAL      EXPSTA = CPPSTA
     C                   EVAL      EXVDAT = CPVDAT
     C                   EVAL      EXTYPE = CPTYPE
     C                   EVAL      EXPAYT = CPPAYT
     C                   EVAL      EXJANO = CPJANO
     C                   EVAL      EXCUSD = CPACHL
     C                   EVAL      EXACTY = CPACTY
     C                   EVAL      EXJATP = CPJATP
 
     C                   WRITE     GLRMEXD0
     C                   READ      GLCAPAL0
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFCAB - Get GL FATCA Closed Account Balance                  *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     SRFCAB        BEGSR
 
     C     *LOVAL        SETLL     GLFCABL0
     C                   READ      GLFCABL0
 
      ** Record found.
 
 
     C                   DOW       NOT %EOF(GLFCABL0)
 
 
     C                   MOVE      CBCNUM        WCUST
     C                   IF        PCUST <> WCUST
     C                   CLEAR                   GLRMEX
     C                   EVAL      EXFILE = 'FCAB'
     C                   EVAL      PCUST  = *BLANKS
     C                   MOVE      CBCNUM        PCUST
     C                   EXSR      SRAccCust
     C                   EXSR      SRAccCountry
     C                   EXSR      SRAccACUS
     C                   EXSR      SRAccFTCS
     C                   EXSR      SRAccCUSX
     C                   ENDIF
 
     C                   EVAL      EXCOLC = BBCOLC
     C                   MOVEL     CBCNUM        EXCUSD
     C                   EVAL      EXACTY  = 'CUST'
     C                   EVAL      EXCCY  = CBCURR
     C                   EVAL      EXBRCH = CBBRCH
     C                   EVAL      EXACOD = CBACOD
     C                   EVAL      EXACSQ = CBSEQ
     C                   EVAL      EXBALN = CBAMNT
     C                   EVAL      EXJANO = CCJANO                                          MD042683
     C                   EVAL      EXCUSD = CCACHL                                          MD042683
     C                   EVAL      EXACTY = CCACTY                                          MD042683
     C                   EVAL      EXJATP = CCJATP                                          MD042683
 
     C                   MOVEL     CBACOD        WAcod
     C                   MOVEL     CBACSQ        WASeq
     C                   EVAL      EXACNO = CBBRCH + EXCUSD + CBCURR
     C                                      + WAcod + WASeq
 
     C                   WRITE     GLRMEXD0
     C                   READ      GLFCABL0
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCSBA - Get GL Customer Balances Collection                  *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     SRCSBA        BEGSR
 
     C     *LOVAL        SETLL     GLCSBAL0
     C                   READ      GLCSBAL0
 
      ** Record found.
 
     C                   DOW       NOT %EOF(GLCSBAL0)
 
     C                   IF        CBCUST <> ' '
     C                   IF        PCUST <> CBCUST
     C                   CLEAR                   GLRMEX
     C                   EVAL      EXFILE = 'CSBA'
     C                   EVAL      PCUST  = *BLANKS
     C                   MOVE      CBCUST        PCUST
     C                   EXSR      SRAccCust
     C                   EXSR      SRAccCountry
     C                   EXSR      SRAccACUS
     C                   EXSR      SRAccFTCS
     C                   EXSR      SRAccCUSX
     C                   ENDIF
 
     C                   EVAL      EXCOLC = BBCOLC
 
     C                   ELSE
     C                   CLEAR                   GLRMEX
     C                   EVAL      EXFILE = 'CSBA'
     C                   ENDIF
 
     C                   EVAL      EXCUSD = CBCUST
     C                   EVAL      EXCCY  = CBCURR
     C                   EVAL      EXBRCH = CBBRCH
     C                   EVAL      EXACOD = CBACOD
     C                   EVAL      EXACSQ = CBACSQ
     C                   EVAL      EXBALN = CBBALN
     C                   EVAL      EXTRNN = CBTRNN
     C                   EVAL      EXTTYP = CBTTYP
     C                   EVAL      EXYEAR = CBYEAR
     C                   EVAL      EXJANO = CBJANO
     C                   EVAL      EXCUSD = CBACHL
     C                   EVAL      EXJATP = CBJATP
     C                   EVAL      EXACTY = CBACTY
 
     C                   MOVEL     CBACOD        WAcod
     C                   MOVEL     CBACSQ        WASeq
     C                   IF        CBTRNN = *BLANKS
     C                   IF        CBJATP <> 'M'
     C                   EVAL      EXACNO = CBBRCH + CBCUST + CBCURR
     C                                      + WAcod + WASeq
     C                   ELSE
     C                   EVAL      EXACNO = CBBRCH + CBJANO + CBCURR
     C                                      + WAcod + WASeq
     C                   ENDIF
     C                   ELSE
     C                   EVAL      EXACNO = CBTRNN
     C                   ENDIF
 
     C                   WRITE     GLRMEXD0
     C                   READ      GLCSBAL0
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAccACUS - Access Additional Customer File                   *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     SRAccACUS     BEGSR
 
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCust
     C     SDACUS        PARM      SDACUS        DSLDY
 
     C                   IF        PRTCD  = *BLANKS
     C                   EVAL      EXDBTH = E5DBTH
     C                   EVAL      EXCNA1 = E5CNA1
     C                   EVAL      EXCNA2 = E5CNA2
     C                   EVAL      EXTINO = E5TINO
     C                   EVAL      EXISCT = E5ISCT
     C                   EVAL      EXTIN2 = E5TIN2
     C                   EVAL      EXTNC2 = E5TNC2
     C                   EVAL      EXTIN3 = E5TIN3
     C                   EVAL      EXTNC3 = E5TNC3
     C                   EVAL      EXTIN4 = E5TIN4
     C                   EVAL      EXTNC4 = E5TNC4
     C                   EVAL      EXTIN5 = E5TIN5
     C                   EVAL      EXTNC5 = E5TNC5
     C                   EVAL      EXCITY = E5CITY
     C                   EVAL      EXCNA3 = E5CNA3
     C                   EVAL      EXCNA4 = E5CNA4
     C                   EVAL      EXZIPC = E5ZIPC
     C                   ELSE
     C                   EVAL      EXDBTH = *BLANKS
     C                   EVAL      EXCNA1 = *BLANKS
     C                   EVAL      EXCNA2 = *BLANKS
     C                   EVAL      EXTINO = *BLANKS
     C                   EVAL      EXISCT = *BLANKS
     C                   EVAL      EXTIN2 = *BLANKS
     C                   EVAL      EXTNC2 = *BLANKS
     C                   EVAL      EXTIN3 = *BLANKS
     C                   EVAL      EXTNC3 = *BLANKS
     C                   EVAL      EXTIN4 = *BLANKS
     C                   EVAL      EXTNC4 = *BLANKS
     C                   EVAL      EXTIN5 = *BLANKS
     C                   EVAL      EXTNC5 = *BLANKS
     C                   EVAL      EXCITY = *BLANKS
     C                   EVAL      EXCNA3 = *BLANKS
     C                   EVAL      EXCNA4 = *BLANKS
     C                   EVAL      EXZIPC = *BLANKS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAccCUSX - Access Customer Details Ext C                     *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls    :                                                    *
      *                                                               *
      *****************************************************************
     C     SRAccCUSX     BEGSR
 
      ** Access Customer Extension C details
 
     C     BBCUST        CHAIN     SDCUSXL0
 
     C                   IF        NOT %FOUND(SDCUSXL0)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSXPD'
     C                   EVAL      DBKEY = BBCUST
     C                   EVAL      DBASE = 11
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      EXDRMT = XCDRMT
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAccFTCS - Access FATCA Customer Details File                *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     SRAccFTCS     BEGSR
 
     C     BBCUST        CHAIN     SDFTCSL0
 
     C                   EVAL      EXREPT = FAREPT
     C                   EVAL      EXCSTY = FACSTY
     C                   EVAL      EXCSST = FACSST
     C                   EVAL      EXRPTT = FARPTT
     C                   EVAL      EXEXEM = FAEXEM
     C                   EVAL      EXHVAC = FAHVAC
     C                   EVAL      EXINFC = FAINFC
     C                   EVAL      EXHMOV = FAHMOV
     C                   EVAL      EXMCOV = FAMCOV
     C                   EVAL      EXRPOV = FARPOV
     C                   EVAL      EXCIOV = FACIOV
     C                   EVAL      EXCBOV = FACBOV
     C                   EVAL      EXCDOV = FACDOV
     C                   EVAL      EXGCOV = FAGCOV
     C                   EVAL      EXIDOV = FAIDOV
     C                   EVAL      EXJAOV = FAJAOV
     C                   EVAL      EXTEOV = FATEOV
     C                   EVAL      EXTXOV = FATXOV
     C                   EVAL      EXHMSV = FAHMSV
     C                   EVAL      EXMCSV = FAMCSV
     C                   EVAL      EXRPSV = FARPSV
     C                   EVAL      EXCISV = FACISV
     C                   EVAL      EXCBSV = FACBSV
     C                   EVAL      EXCDSV = FACDSV
     C                   EVAL      EXGCSV = FAGCSV
     C                   EVAL      EXIDSV = FAIDSV
     C                   EVAL      EXJASV = FAJASV
     C                   EVAL      EXTESV = FATESV
     C                   EVAL      EXTXSV = FATXSV
     C                   EVAL      EXGIIN = FAGIIN
     C                   EVAL      EXCSTY = FACSTY
     C                   EVAL      EXEXMA = FAEXMA
 
     C                   IF        FACSTY <> 'P'
     C                   EVAL      EXCNA1 = BBCNA1
     C                   ENDIF
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAccCust - Access Customer Details file                      *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls    :                                                    *
      *                                                               *
      *****************************************************************
     C     SRAccCust     BEGSR
 
      ** Access Customer
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCUST
     C                   PARM      *BLANKS       PCNST
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   EVAL      EXCOLC = BBCOLC
     C                   EVAL      EXCSSN = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAccCountry - Access Country Codes File                      *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls    :                                                    *
      *                                                               *
      *****************************************************************
     C     SRAccCountry  BEGSR
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    BBCOLC
     C     SDCTRY        PARM      SDCTRY        DSFDY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls    : AOBANKR0, AOMMODR0, AOSARDR0                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PRetrnCode
 
     C     *DTAARA       DEFINE                  GLFATCA
     C     *LOCK         IN        GLFATCA
     C                   EVAL      WFATCAD = 'Y'
     C                   OUT       GLFATCA
 
     C                   EVAL      DBPGM = 'GL000660'
 
      ** Call Access Program for Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSSDY
 
     C                   IF        Prtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POption
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR   -  Error Handling Subroutine                         *
      *                                                               *
      *  Called by: Various                                           *
      *                                                               *
      *  Calls    : DBERRCTL - Database Error Control                 *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C     *LOCK         IN        GLFATCA
     C                   EVAL      WFATCAD = ' '
     C                   OUT       GLFATCA
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
