     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Withholding Tax Basket Defaulting')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading  Module                           *
      *                                                               *
      *  SEPWHTBDFT - Treaty Withholding Tax Basket Defaulting        *
      *                                                               *
      *  Function:  This program will find the tax basket for a given *
      *             customer/beneficial owner.                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Last Amend No. CSD079             Date 05Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185811   *CREATE   Date 02Nov00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD079 - Enhanced Customer Maintenance API (Recompile)       *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  185811 - Set up default tax basket for manual position       *
      *           settlement                                          *
      *           (Part of CSE023 - Treaty Withholding Tax)           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicators                          *
      *                                                               *
      *    21     Record missing from SECTYD                          *
      *    22     Record missing from INVTPD                          *
      *                                                               *
      *    31     Record not found in SDWHTTPD                        *
      *    32     Record not found in SDWTCSPD                        *
      *    33     Record not found in SDBNFOL1                        *
      *                                                               *
      *   LR :    Last record                                         *
      *   U7/U8 : Database error                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRCustInfo - Get Customer withholding Tax details             *
      * SRBenInfo - Get Beneficial Owner Information                  *
      * SRTaxDetail - Get Treaty Withholding Tax Details              *
      * *INZSR      Initialise                                        *
      * *PSSR       Error processing                                  *
      *                                                               *
      *****************************************************************
 
     FSECTY     IF   E           K DISK
      ** Security Detail
     F                                     PREFIX(SE_)
     FINVTP     IF   E           K DISK
      ** Investment type Detail
     FSDWTCSL1  IF   E           K Disk
      ** Customer Withholding Tax detail - WH
     FSDWHTTL0  IF   E           K Disk
      ** Treaty Withholding Tax Detail - WT
     FSDBNFOL2  IF   E           K Disk
      ** Beneficial Owner Detail
 
      *****************************************************************
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
      **    False      logical = *off (for indicator processing)
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
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
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
 
      ** ICD/SD Data Structures
      ** ----------------------
 
      ** Customer file
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
                                                                                CAP004
      ** Data Structure for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** DS for Access Programs, Short DS
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @Loc            S                   LIKE(BBCOLC)
     D @NoDoc          S              1
     D @NoTax          S              1
     D @SetExCode      S              1
     D @SITP           S                   LIKE(SE_SITP)
     D @TreatyTax      S              1
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Get Security Details
      *
 
     C     InSecty       CHAIN     SECTY                              21
     C     *IN21         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SECTYD'
     C                   EVAL      DBKEY  =  InSecty
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  102
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'MAIN'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If no error and Country of Tax Treaty in the security detail
      ** is equal to *BLANK, then output the original record to file.
      *
     C     SE_CRTT       IFEQ      *BLANK
     C                   EVAL      @TreatyTax = 'N'
     C                   ELSE
     C                   EVAL      @TreatyTax = 'Y'
 
     C                   ENDIF
      *
      ** If Treaty Tax processing is needed
      *
     C                   IF        @TreatyTax = 'Y'
      *
      ** Get Investment Details
      *
     C     InvestKey     CHAIN     INVTP                              22
     C     *IN22         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'INVTPD'
     C                   EVAL      DBKEY  =  SE_SITP
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  103
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'MAIN'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Get Customer Detail
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      InCustNo      @KEY1            10
     C                   PARM                    @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** If Customer detail not found, issue DB error.
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  @KEY1
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  104
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SRCustInfo'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If Beneficial Owner number is *BLANK then get customer information
      *
     C                   IF        InBen = *BLANK
 
     C                   EXSR      SRCustInfo
      *
      ** ELSE get Beneficial Owner information.
      *
     C                   ELSE
     C                   EXSR      SRBenInfo
      *
     C                   ENDIF
      *
      ** END of Processing
      *
     C                   ENDIF
      *
     C                   SETON                                        LR
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCustInfo - Get Customer withholding Tax details             *
      *                                                               *
      * Called by: SRCust                                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SRCustInfo    BEGSR
      *
      ** Get withholding tax information for
      ** Country of Treaty, Investment type and location.
      *
     C                   MOVE      SE_SITP       @SITP
     C                   EVAL      @Loc = BBCOLC
     C                   EXSR      SRTaxDetail
      *
      ** Get Customer Withholding Tax detail
      *
     C     Wt_CustKey    CHAIN     SDWTCSL1                           32
      *
      ** If no record found, then treat the customer as no documentation
      ** and donot need to set up exemtion code.
      *
     C     *IN32         IFEQ      '1'
     C                   EVAL      @NoDoc = 'Y'
     C                   EVAL      @SetExCode = 'Y'
     C                   ELSE
      *
      ** Set up recipient Code if the position settlement is for
      ** Customer position.
      *
     C                   EVAL      OutRecd = WHRPCD
      *
      ** Check if Customer is exempted from Tax.
      ** CASE 1
      ** If security is interest bearing, ie processing type is 1,3,5,6,8,9
      ** and allow for portfolio income exemption is 'Y' and customer
      ** documentation is 'L'or 'Y', then it is exempt from Tax.
      *
     C                   IF        SE_APIE = 'Y'
 
     C                   IF        WHDCRC = 'L' or WHDCRC = 'Y'
 
     C                   IF        PROT = '1' OR PROT = '3' or PROT = '5'
     C                             OR PROT = '6' OR PROT = '8' or PROT = '9'
     C                   EVAL      @NoTax = 'Y'
      *
      ** Tax basket = Default Portfolio Exemption Tax Basket
      *
     C                   EVAL      OutBasket = WTPFEX
      *
      ** Set up Exemption Code
      ** IF exemption code on customer detail = *BLANK
      ** THEN use exemption code from Treaty detail.
      *
     C                   EVAL      @SetExCode = 'Y'
     C                   IF        WHEXCD <> *BLANK
     C                   EVAL      OutExcd = WHEXCD
     C                   ELSE
     C                   EVAL      OutExcd = WTEXPI
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
      *
      ** If the customer documentation is 'E' then the customer is exempted
      ** from Tax.
      *
     C                   IF        WHDCRC = 'E'
     C                   EVAL      @NoTax = 'Y'
      *
      ** Tax basket = Customer Tax Basket
      *
     C                   EVAL      OutBasket = WHTXBS
      *
      ** Set up Exemption Code
      ** If exemption code on customer detail = *BLANK then use exemption
      ** code from treaty detail.
      *
     C                   EVAL      @SetExCode = 'Y'
 
     C                   IF        WHEXCD <> *BLANKS
     C                   EVAL      OutExcd = WHEXCD
     C                   ELSE
     C                   EVAL      OutExcd = WTEXCD
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Get Tax rate for Customer with no documentation.
      *
     C                   IF        WHDCRC = 'N' or @NoDoc = 'Y'
 
     C                   EVAL      OutBasket  = WTDBDC
      *
      ** If position settlement is for Maturity and OID indicator is 'S'
      ** then use Backup withholding tax rate.
      *
     C                   EVAL      OutExcd = ' '
     C                   EVAL      @SetExCode = 'Y'
     C                   IF        InEvent = 'MT' and SE_OIDI = 'S'
     C                   EVAL      OutBasket  = WTDRBW
     C                   ENDIF
 
     C                   ELSE
      *
      ** Get Tax rate for Undeclared Customer - Backup withholding tax rate
      *
     C                   IF        WHDCRC = 'U'
     C                   EVAL      OutExcd = ' '
     C                   EVAL      @SetExCode = 'Y'
     C                   EVAL      OutBasket  = WTDRBW
     C                   ELSE
      *
      ** Get Tax rate for Customer with completed documentation
      ** If Tax basket on Customer detail = *BLANK then use tax basket from
      ** treaty detail.
      *
     C                   IF        WHTXBS <> *BLANKS
     C                   EVAL      OutBasket  = WHTXBS
     C                   ELSE
     C                   EVAL      OutBasket  = WTTXBS
     C                   ENDIF
      *
      ** Set up Exemption Code
      ** If Exemption Code from customer is *BLANK then use exemption
      ** Code from the treaty
      *
     C                   If        @SetExCode = 'N'
     C                   If        OutBasket  = WHTXBS or WHEXCD <> *BLANKS
     C                   EVAL      OutExcd = WHEXCD
     C                   ELSE
     C                   EVAL      OutExcd = WTEXCD
     C                   ENDIF
     C                   EVAL      @SetExCode = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBenInfo - Get Beneficial Owner Information                  *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SRBenInfo     BEGSR
 
     C                   EVAL      @BenNo = *BLANKS
     C                   MOVEL     InCustNo      @BenNo
     C                   MOVE      InBen         @BenNo
     C     SDBNFOKey     CHAIN     SDBNFOL2                           33
      *
      ** If no record found, then Database error
      *
     C     *IN31         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBNFOPD'
     C                   EVAL      DBKEY  =  InCustNo + SE_CRTT + InBen
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  110
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SRBenInfo'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If Beneficial Owner record found
      *
     C                   IF        *IN33 = '0'
      *
      ** Set Up Recipient Code for Beneficial Owner
      *
     C                   EVAL      OutRecd = BNRPCD
      *
      ** Get withholding tax information for
      ** Country of Treaty, Investment type and location.
      ** with location from the benefical owner detail if not *BLANK
      *
     C                   IF        BNCTRS <> *BLANKS
     C                   MOVE      SE_SITP       @SITP
     C                   EVAL      @Loc = BNCTRS
      *
      ** ELSE if country of Residence is *BLANK, then use the location
      **         from the Customer.
      *
     C                   ELSE
 
     C                   EVAL      @Loc = BBCOLC
     C                   ENDIF
 
     C                   EXSR      SRTaxDetail
      *
      ** Check if Customer is exempted from Tax.
      *
      ** If security is interest bearing, ie processing type is 1,3,5,6,8,9
      ** and allow for portfolio income exemption is 'Y' and customer
      ** documentation is 'L'or 'Y', then it is exempt from Tax.
      *
     C                   IF        SE_APIE = 'Y'
 
     C                   IF        BNDCRC = 'L' or BNDCRC = 'Y'
 
     C                   IF        PROT = '1' OR PROT = '3' or PROT = '5'
     C                             OR PROT = '6' OR PROT = '8' or PROT = '9'
 
     C                   EVAL      @NoTax = 'Y'
      *
      ** Tax basket = Default Portfolio Exemption Tax Basket
      *
     C                   EVAL      OutBasket = WTPFEX
      *
      ** Set up Exemption Code
      ** If exemption code on customer detail = *BLANK then use exemption
      ** code from treaty detail.
      *
     C                   EVAL      @SetExCode = 'Y'
     C                   IF        BNEXCD <> *BLANK
     C                   EVAL      OutExcd = BNEXCD
     C                   ELSE
     C                   EVAL      OutExcd = WTEXPI
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
      *
      ** If the customer documentation is 'E' then the customer is exempted
      ** from Tax.
      *
     C                   IF        BNDCRC = 'E'
     C                   EVAL      @NoTax = 'Y'
      *
      ** Tax basket = Customer Tax Basket
      *
     C                   EVAL      OutBasket = BNTXBS
      *
      ** Set up Exemption Code
      ** If exemption code on customer detail = *BLANK then use exemption
      ** code from treaty detail.
      *
     C                   EVAL      @SetExCode = 'Y'
 
     C                   IF        BNEXCD <> *BLANKS
     C                   EVAL      OutExcd = BNEXCD
     C                   ELSE
     C                   EVAL      OutExcd = WTEXCD
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Get Tax rate for Customer with no documentation.
      *
     C                   IF        BNDCRC = 'N' or @NoDoc = 'Y'
 
     C                   EVAL      OutBasket  = WTDBDC
      *
      ** If position settlement is for Maturity and OID indicator is 'S'
      ** then use Backup withholding tax rate.
      *
     C                   EVAL      OutExcd = ' '
     C                   EVAL      @SetExCode = 'Y'
     C                   IF        InEvent = 'MT' and SE_OIDI = 'S'
     C                   EVAL      OutBasket  = WTDRBW
     C                   ENDIF
 
     C                   ELSE
      *
      ** Get Tax rate for Undeclared Customer - Backup withholding tax rate
      *
     C                   IF        BNDCRC = 'U'
     C                   EVAL      OutExcd = ' '
     C                   EVAL      @SetExCode = 'Y'
     C                   EVAL      OutBasket  = WTDRBW
     C                   ELSE
      *
      ** Get Tax rate for Customer with completed documentation
      ** If Tax basket on Customer detail = *BLANK then use tax basket from
      ** treaty detail.
      *
     C                   IF        BNTXBS <> *BLANKS
     C                   EVAL      OutBasket  = BNTXBS
     C                   ELSE
     C                   EVAL      OutBasket  = WTTXBS
     C                   ENDIF
      *
      ** Set up Exemption Code
      ** If Exemption Code from customer is *BLANK then use exemption
      ** Code from the treaty
      *
     C                   If        @SetExCode = 'N'
     C                   If        OutBasket  = BNTXBS or BNEXCD <> *BLANKS
     C                   EVAL      OutExcd = BNEXCD
     C                   ELSE
     C                   EVAL      OutExcd = WTEXCD
     C                   ENDIF
     C                   EVAL      @SetExCode = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *IN33 = '1'
      *
      ** 1. No Docoumentation - use the no documentation basket
      ** 2. Use tax basket from Treaty if none set up for above.
      *
      ** CASE 1
     C                   IF        @NoDoc = 'Y'
     C                   EVAL      OutExcd = '  '
     C                   EVAL      @SetExCode = '  '
     C                   EVAL      OutBasket  = WTDBDC
 
     C                   ELSE
      ** CASE 2
     C                   EVAL      OutBasket  = WTTXBS
     C                   IF        @SetExCode = 'N'
     C                   EVAL      OutExcd = WTEXCD
     C                   EVAL      @SetExCode = 'Y'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTaxDetail - Get Treaty Withholding Tax Details              *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SRTaxdetail   BEGSR
      *
      ** Get withholding tax information for
      ** Country of Treaty, Investment type and location.
      *
     C                   MOVE      SE_SITP       @SITP
 
     C     Wt_TreatKy    CHAIN     SDWHTTL0                           31
      *
      ** If no record found, then check if there is a record for general use
      ** Country of Treaty,  *BLANK (Investment) and location.
      *
     C     *IN31         IFEQ      '1'
     C                   MOVE      '0'           *IN31
     C                   MOVE      '   '         @SITP
     C     Wt_TreatKy    CHAIN     SDWHTTL0                           31
     C                   ENDIF
      *
      ** If no record found, then check if there is a record for general use
      ** Country of Treaty, Investment type and *BLANK (Location)
      ** to get default tax basket for No Documentation.
      *
     C     *IN31         IFEQ      '1'
     C                   MOVE      '0'           *IN31
     C                   MOVE      SE_SITP       @SITP
     C                   EVAL      @NoDoc = 'Y'
     C     Wt_TreatPky   CHAIN     SDWHTTL0                           31
     C                   ENDIF
      *
      ** If no record found, then check if there is a record for general use
      ** Country of Treaty, *BLANK (Investment) and *BLANK (Location)
      ** to get default tax basket for No Documentation.
      *
     C     *IN31         IFEQ      '1'
     C                   MOVE      '0'           *IN31
     C                   MOVE      *BLANKS       @SITP
     C                   EVAL      @NoDoc = 'Y'
     C     Wt_TreatPky   CHAIN     SDWHTTL0                           31
     C                   ENDIF
      *
      ** If no record found, then Data Base Error
      *
     C     *IN31         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDWHTTPD'
     C                   EVAL      DBKEY  =  SE_CRTT + SE_SITP + @Loc
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  105
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SRTaxDetail'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *InzSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     *InzSR        BEGSR
      *
      ** Key Lists for Withholding Tax Customer detail
      *
     C     Wt_CustKey    KLIST
     C                   KFLD                    InCustNo
     C                   KFLD                    SE_CRTT
      *
      ** Key Lists for Withholding Tax Treaty detail
      *
     C     Wt_TreatKy    KLIST
     C                   KFLD                    SE_CRTT
     C                   KFLD                    @SITP
     C                   KFLD                    @Loc
      *
      ** Partial Key Lists for Withholding Tax Treaty detail
      *
     C     Wt_TreatPky   KLIST
     C                   KFLD                    SE_CRTT
     C                   KFLD                    @SITP
      *
      ** Key Lists for Investment Type
      *
     C     InvestKey     KLIST
     C                   KFLD                    SE_NMCY
     C                   KFLD                    SE_SITP
      *
      ** Key Lists for Beneficial Owner Detail - SDBNFOL2
      *
     C     SDBNFOKey     KLIST
     C                   KFLD                    InCustNo
     C                   KFLD                    SE_CRTT
     C                   KFLD                    @BenNo           26
      *
      ** Program Input Paramenters
      *
     C     *Entry        PLIST
      *
      ** INPUT fields
      *
      ** Counterparty Number
      *
     C                   PARM                    InCustNo          6
      *
      ** Security Shortname
      *
     C                   PARM                    InSecty          10
      *
      ** Beneficial Owner
      *
     C                   PARM                    InBen            20
      *
      ** Event Type
      *
     C                   PARM                    InEvent           2
      *
      ** OUTPUT fields
      *
     C                   PARM                    OutBasket         2
     C                   PARM                    OutExcd           2
     C                   PARM                    OutRecd           2
     C                   PARM                    PgmErr            1
     C
      *
      ** Initialize Output fields
      *
     C                   EVAL      OutBasket = *BLANKS
     C                   EVAL      OutExcd = *BLANKS
     C                   EVAL      OutRecd = *BLANKS
     C                   EVAL      PgmErr= 'N'
      *
      ** Initialise work fields
      *
     C                   EVAL      @NoTax = 'N'
     C                   EVAL      @NoDoc = 'N'
     C                   EVAL      @SetExCode = 'N'
 
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
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   MOVE      'Y'           PgmErr
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
