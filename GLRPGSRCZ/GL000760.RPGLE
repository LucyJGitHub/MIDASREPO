     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Extract Program for Reporting')               *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000760 - Midas GL Extract Program for Reporting            *
      *                                                               *
      *  Function: This is run and create extract necessary for       *
      *            CRS Report Management details.                     *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. MD045190           Date 07Apr17               *
      *  Prev Amend No. CGL177  *CREATE    Date 11Jan16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD045190 - Other Closed FATCA Transaction records besides    *
      *             Closed Retail Accounts are deleted after FATCA    *
      *             EOY COB (Recompile)                               *
      *  CGL177 - CRS Reporting Phase 2                               *
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
      *  SRAccCRSD     - Access CRS Customer Details File             *
      *  SRCAPA        - Get GL Customer Activity/Payment Amounts     *
      *  SRCSBA        - Get GL Customer Balances Collection          *
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

      ** Midas SD CRS Customer Details Header File
     FSDCRSHL0  IF   E           K DISK    INFSR(*PSSR)

      ** Midas SD Customer Details Ext C
     FSDCUSXL0  IF   E           K DISK    INFSR(*PSSR)

      ** Midas GL FATCA Customer Activity/Payment Amounts
     FGLCAPAL0  IF   E           K DISK    INFSR(*PSSR)

      ** Midas GL FATCA Customer Balance Collection File
     FGLCSBAL0  IF   E           K DISK    INFSR(*PSSR)

      ** Midas GL Report Management Extract File
     FGLCRMXPD  O    E           K DISK    INFSR(*PSSR)

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
     D GLCRMX        E DS                  EXTNAME(GLCRMXPD)

      ** External data structure for Switchable Features Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External data structure for Country Codes
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)

      ** External data structure for Country Codes
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** External data structure for Country Codes
     D SDACUS        E DS                  EXTNAME(SDACUSPD)

      ** External data structure for Branch Code Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D QQDFA1        E                     EXTFLD(QQDFAC)

      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Second DS for access programs, long data structure
     D DSLDY         E DS                  EXTNAME(DSLDY)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** AOCUSTR0 Parameters
     D PCNST           S              7

     D PCUST           S             10
     D PMODE           S              1
     D PRTCD           S              7
     D PCtry           S              2
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

     C                   EXSR      SRCAPA
     C                   EXSR      SRCSBA

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
     C                   CLEAR                   GLCRMX
     C                   EVAL      EXFILE = 'CAPA'
     C                   EVAL      PCUST  = *BLANKS
     C                   MOVE      CPCUSD        PCUST
     C                   EXSR      SRAccCust
     C                   EXSR      SRAccCountry
     C                   EXSR      SRAccACUS
     C                   EXSR      SRAccCRSD
     C                   EXSR      SRAccCUSX
     C                   ENDIF

     C                   EVAL      EXCOLC = BBCOLC
     C                   ELSE
     C                   CLEAR                   GLCRMX
     C                   EVAL      EXFILE = 'CAPA'
     C                   ENDIF
     C                   EVAL      EXBRCH = CPBRCH
     C                   EVAL      EXCUSD = CPCUSD
     C                   EVAL      EXACNO = CPACNO
     C                   EVAL      EXCCY  = CPCCY
     C                   EVAL      EXPSTA = CPPSTA
     C                   EVAL      EXVDAT = CPVDAT
     C                   EVAL      EXETYP = CPTYPE
     C                   EVAL      EXPAYT = CPPAYT
     C                   EVAL      EXJANO = CPJANO
     C                   EVAL      EXCUSD = CPACHL
     C                   EVAL      EXACTY = CPACTY
     C                   EVAL      EXJATP = CPJATP

     C                   WRITE     GLCRMXD0
     C                   READ      GLCAPAL0

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
     C                   CLEAR                   GLCRMX
     C                   EVAL      EXFILE = 'CSBA'
     C                   EVAL      PCUST  = *BLANKS
     C                   MOVE      CBCUST        PCUST
     C                   EXSR      SRAccCust
     C                   EXSR      SRAccCountry
     C                   EXSR      SRAccACUS
     C                   EXSR      SRAccCRSD
     C                   EXSR      SRAccCUSX
     C                   ENDIF

     C                   EVAL      EXCOLC = BBCOLC

     C                   ELSE
     C                   CLEAR                   GLCRMX
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

     C                   WRITE     GLCRMXD0
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
     C                   EVAL      EXTINO = E5TINO
     C                   EVAL      EXISCT = E5ISCT
     C                   EVAL      EXDBTH = E5DBTH
     C                   EVAL      EXBTHC = E5BTHC
     C                   EVAL      EXBTHT = E5BTHT
     C                   EVAL      EXCNA1 = E5CNA1
     C                   EVAL      EXCNA2 = E5CNA2
      *
     C                   EVAL      EXCITY = E5CITY
     C                   EVAL      EXCNA3 = E5CNA3
     C                   EVAL      EXCNA4 = E5CNA4
     C                   EVAL      EXZIPC = E5ZIPC
     C                   ELSE
     C                   EVAL      EXTINO = *BLANKS
     C                   EVAL      EXISCT = *BLANKS
     C                   EVAL      EXDBTH = *BLANKS
     C                   EVAL      EXBTHC = *BLANKS
     C                   EVAL      EXBTHT = *BLANKS
     C                   EVAL      EXCNA1 = *BLANKS
     C                   EVAL      EXCNA2 = *BLANKS
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
      * SRAccCRSD - Access CRS Customer Details File                  *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     SRAccCRSD     BEGSR

     C     BBCUST        CHAIN     SDCRSHL0

     C                   EVAL      EXTYPE = CRTYPE
     C                   EVAL      EXSTYP = CRSTYP
     C                   EVAL      EXHVAL = CRHVAL
     C                   EVAL      EXEXMP = CREXMP
     C                   EVAL      EXEXMR = CREXMR
     C                   EVAL      EXEXMD = CREXMD
     C                   EVAL      EXEXMT = CREXMT
     C                   EVAL      EXINFO = CRINFO
     C                   EVAL      EXEXMG = CREXMG
     C                   EVAL      EXEXMI = CREXMI

     C                   IF        EXTYPE <> 'P'
     C                   EVAL      EXCNA1 = BBCNA1
     C                   ENDIF

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

     C                   EVAL      DBPGM = 'GL000760'

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
