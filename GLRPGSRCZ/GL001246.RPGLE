     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Risk weighted assets allocation program')     *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL001246 - Risk Weighted Assets Allocation Program           *
      *                                                               *
      *  Function:  This module will access the RWA weightings for the*
      *             account and call a program to calculate the Risk  *
      *             Weighted Balance for accounts.                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. CSD079             Date 05Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 242239             Date 18Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 220004             Date 24Jul03               *
      *                 219657             Date 22Jul03               *
      *                 218585             Date 10Jul03               *
      *                 CGL018  *CREATE    Date 27Sep02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSD079 - Enhanced Customer Maintenance API (Recompile)       *
      *  242239 - Only write today's details to GLRWARPD.             *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  220004 - Change call to AOCURRR0 to use DSSDY not DSFDY.     *
      *  219657 - Get the allocation/Percentage indicator to check the*
      *           value to pass to field WWCollValAmt. This is then   *
      *           used as the amount in the calculation of the RWA    *
      *           balance.                                            *
      *  218585 - Exclude ALL retail liab accnts with credit balances *
      *           regardless of whether there are RWA codes attached  *
      *           to them.                                            *
      *  CGL018 - Risk Weighted Assets                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX        Function of indicator                            *
      *                                                               *
      *    01        EOF for SDCRWAL2                                 *
      *    02        EOF for SDRWACL1                                 *
      *    03        EOF for GLCOLLL6                                 *
      *    04        EOF for GLORWAL2                                 *
      *    05        EOF for GLARWAL2                                 *
      *    06        EOF for GLCOLAL6                                 *
      *    07        EOF for GLCOLLL1                                 *
      *                                                               *
      *    20        No Collateral Record found in GLCOLLL6           *
      *    21        No Collateral Record found in GLCOLAL6           *
      *    22        Terminate and return to calling program          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
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
      **
     FSDCRWAL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(CR)
     FSDRWACL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(PW)
     FGLARWAL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(AR)
     FGLORWAL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(GL)
     FGLCOLLL6  IF   E           K DISK    INFSR(*PSSR)
     FGLCOLLL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L1)
     F                                     RENAME(GLCOLLD0:GLCOLLD1)
     FGLCOLAL6  IF   E           K DISK    INFSR(*PSSR)
     FGLRWARPD  O    E             DISK
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
 
 
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array for Collateral Weighting Percentage (Alphanumeric)
      *
     D CollWeight      S              5A   Dim(15)
 
      ** Array for Collateral Weighting Percentage (Numeric)
      *
     D CollWPN         S              5P 0 Dim(15)
 
      ** Array for Collateral Balance
      *
     D CollBal         S             15P 0 Dim(15)
 
      ** Array for Collateral Reference
      *
     D CollRef         S             10A   Dim(15)
 
      ** Array for Collateral Currency
      *
     D CollCcy         S              3A   Dim(15)
 
      ** Array for later use of RWA Codes of the Collateral References
      *
     D CollCodes       S              2A   Dim(15)
 
      ** Array for the returned values of the Collateral RWA Balances
      *
     D CollRWA         S             15P 0 Dim(15)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work fields used by ZXRATE
     D ZRATE1          S             13P 8
     D ZRATE2          S             13P 8
     D ZMDI1           S              1A
     D ZMDI2           S              1A
     D ZRATEX          S             13P 8
     D ZMDIX           S              1A
 
     D @RUN            S              1
 
      ** External DS for Currency details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for Account Code details                                                 218585
     D SDACOD        E DS                  EXTNAME(SDACODPD)                                  218585
                                                                                              218585
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for Access Objects - long data structure                                          220004
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     220004
                                                                                              220004
      ** Data area for message file to use
     D ZADFMF        E DS                  EXTNAME(Y2MGFLA)
 
     D                 DS
      ** Data Structure Redefining Accnt Key Fields
 
     D***AKEYF                  1     18                                                      CGL029
     D  AKEYF                  1     24                                                       CGL029
     D**NCust***               1      6  0                                                    CSD027
     D  NCust                  1      6A                                                      CSD027
     D  NCusta                 1      6
     D  NCcy                   7      9
     D***NAcod**               10     13  0                                                   CGL029
     D***NAcoda*               10     13                                                      CGL029
     D***NAcsq**               14     15  0                                                   CGL029
     D***NAcsqa*               14     15                                                      CGL029
     D***NBrca**               16     18                                                      CGL029
     D  NAcod                 10     19  0                                                    CGL029
     D  NAcoda                10     19                                                       CGL029
     D  NAcsq                 20     21  0                                                    CGL029
     D  NAcsqa                20     21                                                       CGL029
     D  NBrca                 22     24                                                       CGL029
                                                                                              CGL029
     D WWAcctRef       S             24A                                                      CGL029
 
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
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   EXSR      MAIN
 
     C                   EVAL      *INLR = *ON
 
      **********************************************************************
 
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main Processing                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     MAIN          BEGSR
 
     C                   EXSR      GETCUSTREF
 
     C                   EXSR      GETACCTREF
 
     C                   EXSR      GETCOLLREF
      *
      **  Continue procesing if *IN22 is off, otherwise terminate program
      *
     C     *IN22         IFEQ      '0'
 
     C                   EXSR      READYPARM
 
     C                   EXSR      CALCPGM
 
     C                   EXSR      RETURNEDVAL
 
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * GETCUSTREF - Retrieve Customer Weighted Percentage            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     GETCUSTREF    BEGSR
      *
      **  Using the passed customer and set number, get the RWA Code in
      **  Customer Risk Weighted Assets Codes File
      *
     C     KCRREC        CHAIN     SDCRWAL2                           01
 
     C     *IN01         IFEQ      '0'
     C                   MOVE      CRRWCODE      TempCode
     C                   ENDIF
      *
      **  If the customer does not have a RWA record for the set number, use
      **  the default RWA code to read the Risk Weighted Assets Codes file.
      **  (default RWA Code is *Blanks) Do the same if Customer not found.
      *
     C     TempCode      IFEQ      *BLANKS
     C     *IN01         OREQ      '1'
     C                   MOVE      *BLANKS       WWCRWACode
     C                   MOVE      *BLANKS       CustRWACode
     C                   MOVE      WWSetNum      WWCRWSetNum
     C                   ELSE
     C                   MOVE      TempCode      WWCRWACode
     C                   MOVE      TempCode      CustRWACode
     C                   MOVE      WWSetNum      WWCRWSetNum
     C                   ENDIF
     C                   MOVE      *BLANKS       TempCode
 
     C                   EXSR      GETPERCENT
     C                   Z-ADD     TempPWtg      WPCustPWtg
     C                   MOVEL     TempPWtg      WWCustPWtg
 
     C                   Z-ADD     *ZERO         TempPWtg
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * GETPERCENT - Retrieve the Percentage Weighting of this RWA    *
      *              code and set for this customer/acct collateral   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     GETPERCENT    BEGSR
      *
      **  Access SDRWACL1
      *
     C     KRWREC        CHAIN     SDRWACL1                           02
 
     C     *IN02         IFEQ      '0'
     C                   Z-ADD     PWRWRWAP      TempPWtg
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * GETACCTREF - Retrieve Account RWA Code                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     GETACCTREF    BEGSR
      *
      **  Using the passed account and set number, get the RWA Code in
      **  Accounts Risk Weighted Assets Codes File
      *
     C     KARREC        CHAIN     GLARWAL2                           05
 
     C     *IN05         IFEQ      '0'
     C                   MOVE      ARRWCODE      TempCode
     C                   ENDIF
      *
      **  If the account does not have a RWA record for the set number, use
      **  the default RWA code to read the Risk Weighted Assets Codes file.
      **  (default RWA Code is *Blanks) Do the same if Account not found.
      *
     C     TempCode      IFEQ      *BLANKS
     C     *IN05         OREQ      '1'
     C                   MOVE      *BLANKS       WWCRWACode
     C                   MOVE      *BLANKS       AcctRWACode
     C                   MOVE      WWSetNum      WWCRWSetNum
     C                   ELSE
     C                   MOVE      TempCode      WWCRWACode
     C                   MOVE      TempCode      AcctRWACode
     C                   MOVE      WWSetNum      WWCRWSetNum
     C                   ENDIF
     C                   MOVE      *BLANKS       TempCode
 
     C                   EXSR      GETPERCENT
     C                   Z-ADD     TempPWtg      WPAcctPWtg
     C                   MOVEL     TempPWtg      WWAcctPWtg
 
     C                   Z-ADD     *ZERO         TempPWtg
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * GETCOLLREF - Retrieve the Collateral Reference of the passed  *
      *              account from the core collateral file, GLCOLLL6  *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     GETCOLLREF    BEGSR
      *                                                                                       218585
      ** Read account code details via access program                                         218585
      *                                                                                       218585
     C                   CALL      'AOACODR0'                                                 218585
     C                   PARM      '*MSG   '     @RTCD             7                          218585
     C                   PARM      '*KEY   '     @OPTN             7                          218585
     C**********         PARM      NAcoda        @AFNB             4                   218585 CGL029
     C                   PARM      NAcoda        @AFNB            10                          CGL029
     C     SDACOD        PARM      SDACOD        DSFDY                                        218585
      *                                                                                       218585
      ** Database error                                                                       218585
      *                                                                                       218585
     C     @RTCD         IFNE      *BLANK                                                     218585
     C                   MOVE      '002'         DBASE                                        218585
     C                   MOVEL     @OPTN         DBOPTN            7                          218585
     C                   MOVEL     @AFNB         DBKEY                                        218585
     C                   MOVEL     'SDACODPD'    DBFILE                                       218585
     C                   EXSR      *PSSR                                                      218585
     C                   END                                                                  218585
      *                                                                                       218585
     C                   MOVEL     A5ACSC        WACSC             2                          218585
      *
      **  Access GLCOLLL6
      *
     C                   MOVE      WWGLREind     WWModSec
 
     C                   MOVEA     *blanks       CollRef
     C                   MOVEA     *blanks       CollCcy
 
     C     KGCREC        SETLL     GLCOLLL6
     C     KGCREC        READE     GLCOLLL6                               03
 
     C     *IN03         DOWEQ     '0'
     C                   MOVEL     CDCREF        WWCollRef
     C                   MOVEL     CDCCY         WWCollCcy
     C**********         Z-ADD     CDVAMT        WWCollValAmt                                 219657
     C                   Z-ADD     CDLAMT        WWCollValAmt                                 219657
     C                   EVAL      W = W + 1
 
     C                   EXSR      GETCOLLRISK
      *
      ** Store collateral reference & currency
      *
     C                   EVAL      CollRef(W) = WWCollRef
     C                   EVAL      CollCcy(W) = WWCollCcy
      *
      **  If Collateral Ccy is not equal to the account ccy, convert the
      **  Collateral Amount (CDVAMT) to the ccy of the account using the
      **  Spot Rates in the currency file.
      *
     C     WWCollCcy     IFNE      NCcy
     C                   Z-ADD     WWCollValAmt  INPAMT
     C                   EXSR      CONVERT1
     C                   EXSR      CONVERT2
     C                   Z-ADD     OUTAMT        WWNewValAmt
     C                   Z-ADD     WWNewValAmt   CollBal(W)
     C                   ELSE
     C                   Z-ADD     WWCollValAmt  CollBal(W)
     C                   ENDIF
 
     C     KGCREC        READE     GLCOLLL6                               03
     C                   ENDDO
      *
      **  If not found in GLCOLLL6 try GLCOLAL6
      *
     C     *IN03         IFEQ      '1'
     C     W             ANDEQ     0
     C                   MOVEL     '1'           *IN20
     C                   EXSR      GETCOLAREF
     C                   ENDIF
      *
      **  If no collateral found in GLCOLLL6 or GLCOLAL6, AND RWA codes for
      **  both Account and Customer are blanks (default), AND 'RE' Account,
      **  set indicator off (continue processing even with zero collateral
      **  weighting percentages and balances)
      *
     C     *IN20         IFEQ      '1'
     C     *IN21         ANDEQ     '1'
     C     WWGLREind     ANDEQ     'RE'
     C     AcctRWACode   ANDEQ     *BLANKS
     C     CustRWACode   ANDEQ     *BLANKS
     C     *IN20         OREQ      '0'
     C     *IN21         OREQ      '0'
     C                   MOVEL     '0'           *IN22
     C                   ENDIF
      *                                                                                       218585
      ** If liability account and ledger balance is a credit, then abort processing           218585
      *                                                                                       218585
     C     WWGLREind     IFEQ      'RE'                                                       218585
     C     WACSC         ANDEQ     'LI'                                                       218585
     C     WWAsetBal     ANDLE     0                                                          218585
     C                   MOVEL     '1'           *IN22                                        218585
     C                   ENDIF                                                                218585
      *
      **  If no collateral found in GLCOLLL6 or GLCOLAL6, AND RWA codes for
      **  Account are blank (default), AND 'GL' Account,
      **  set indicator off, exit and return to calling program
      *
     C     *IN20         IFEQ      '1'
     C     *IN21         ANDEQ     '1'
     C     WWGLREind     ANDEQ     'GL'
     C     AcctRWACode   ANDEQ     *BLANKS
     C                   MOVEL     '1'           *IN22
     C                   ENDIF
      *
      **  Set indicator for collaterals processing
      *
     C     *IN20         IFEQ      '1'
     C     *IN21         ANDEQ     '1'
     C     *IN22         ANDEQ     '0'
     C                   MOVEL     '1'           *IN23
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * GETCOLLRISK - Retrieve Collateral Risk Weighted Asset for each*
      *               collateral of the account.                      *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     GETCOLLRISK   BEGSR
      *
      **  Using the retrieved collateral reference and the passed Set Num,
      **  access the Collateral Risk Weighted Asset file, LF/GLORWAL2
      **  to get the RWA code for the set.
      *
     C     KGLREC        CHAIN     GLORWAL2                           04
 
     C     *IN04         IFEQ      '0'
     C                   MOVE      GLRWCODE      TempGLCode
     C                   ENDIF
      *
      **  If the coll ref does not have a RWA record for the set number, use
      **  the default RWA code to read the Risk Weighted Assets Codes file.
      **  (default RWA Code is *Blanks)
      *
     C     TempGLCode    IFEQ      *BLANKS
     C     *IN04         OREQ      '1'
     C                   MOVE      *BLANKS       WWCRWACode
     C                   MOVE      WWSetNum      WWCRWSetNum
     C                   MOVE      *BLANKS       CollCodes(W)
     C                   ELSE
     C                   MOVE      TempGLCode    WWCRWACode
     C                   MOVE      WWSetNum      WWCRWSetNum
     C                   MOVE      TempGLCode    CollCodes(W)
     C                   ENDIF
     C                   MOVE      *BLANKS       TempGLCode
 
     C                   EXSR      GETPERCENT
     C                   Z-ADD     TempPWtg      CollWPN(W)
     C                   MOVEL     TempPWtg      CollWeight(W)
 
     C                   Z-ADD     *ZERO         TempPWtg
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * GETCOLAREF - Retrieve the Collateral Details from the Accounts*
      *              Collateral General Allocation File.              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     GETCOLAREF    BEGSR
      *                                                                                       219657
     C     *LIKE         DEFINE    CAPCNT        Pcnt                                         219657
     C     *LIKE         DEFINE    CDVAMT        TempVal                                      219657
      *
      **  Access GLCOLAL6
      *
     C     KCAREC        SETLL     GLCOLAL6
     C     KCAREC        READE     GLCOLAL6                               06
 
     C     *IN06         DOWEQ     '0'
 
     C                   MOVEL     CACREF        WWCollRef
     C                   MOVEL     CAAPCT        WWAmtPcnt         1                          219657
      *
      **  Get Amount and Currency for this collateral from specific core
      **  Collateral File (GLCOLLL1)
      *
     C     WWCollRef     CHAIN     GLCOLLL1                           07
 
     C     *IN07         IFEQ      '0'
 
     C                   MOVEL     L1CDCCY       WWCollCcy
      *                                                                                       219657
      ** Use the Allocation amount/percentage Indicator. If indicator is                      219657
      ** an 'A', use the allocation amount from GLCOLAPD. If indicator                        219657
      ** is 'P', get the percentage of the Lending amount from GLCOLLPD                       219657
      *                                                                                       219657
     C     WWAmtPcnt     IFEQ      'A'                                                        219657
     C                   Z-ADD     CAAMT         WWCollValAmt                                 219657
     C                   ELSE                                                                 219657
     C                   EVAL      Pcnt = CAPCNT / 100                                        219657
     C                   EVAL      TempVal = L1CDLAMT * Pcnt                                  219657
     C                   Z-ADD     TempVal       WWCollValAmt                                 219657
     C**********         Z-ADD     L1CDVAMT      WWCollValAmt                                 219657
     C                   ENDIF                                                                219657
      *                                                                                       219657
     C                   EVAL      W = W + 1
 
     C                   EXSR      GETCOLLRISK
      *
      ** Store collateral reference & currency
      *
     C                   EVAL      CollRef(W) = WWCollRef
     C                   EVAL      CollCcy(W) = WWCollCcy
      *
      **  If Collateral Ccy is not equal to the account ccy, convert the
      **  Collateral Amount (CDVAMT) to the ccy of the account using the
      **  Spot Rates in the currency file.
      *
     C     WWCollCcy     IFNE      NCcy
     C                   Z-ADD     WWCollValAmt  INPAMT
     C                   EXSR      CONVERT1
     C                   EXSR      CONVERT2
     C                   Z-ADD     OUTAMT        WWNewValAmt
     C                   Z-ADD     WWNewValAmt   CollBal(W)
     C                   ELSE
     C                   Z-ADD     WWCollValAmt  CollBal(W)
     C                   ENDIF
 
     C                   ENDIF
 
     C     KCAREC        READE     GLCOLAL6                               06
     C                   ENDDO
      *
      **  If also not found in GLCOLAL6, set indicator on
      *
     C     *IN06         IFEQ      '1'
     C     W             ANDEQ     0
     C                   MOVEL     '1'           *IN21
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * CONVERT1 - 1st part of conversion from one currency to        *
      *            another. This part gets xrate and mult/divide ind. *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     CONVERT1      BEGSR
      *
      ** From currency
      ** Access Collateral Currency Details
      *
     C                   CALL      'AOCURRR0'
     C                   Parm      *BLANKS       @RTCD             7
     C                   Parm      '*KEY   '     @OPTN             7
     C                   Parm      WWCollCcy     @CCY              3
     C*****SDCURR        Parm      SDCURR        DSFDY                                        220004
     C     SDCURR        Parm      SDCURR        DSSDY                                        220004
 
     C                   MOVEL     A6NBDP        FRMDEC
     C                   EVAL      ZRATE1 = A6SPRT
     C                   EVAL      ZMDI1  = A6MDIN
      *
      ** To currency
      ** Access Account Currency Details
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      NCcy          @CCY
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
 
     C                   MOVEL     A6NBDP        TODEC
     C                   EVAL      ZRATE2 = A6SPRT
     C                   EVAL      ZMDI2  = A6MDIN
 
     C                   EVAL      OUTAMT = 0
      *
      ** Work out xrate between to and from currencies
      *
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
     C                   PARM                    ZRATEX
     C                   PARM                    ZMDIX
 
     C                   EVAL      CVTRAT = ZRATEX
     C                   EVAL      BASMD = ZMDIX
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * Convert2 - 2nd part of conversion from one currency to        *
      *            another. This part calcs new amount from parms     *
      *            supplied via Convert1.                             *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     Convert2      BEGSR
 
      * If base currency
     C                   If        (BaseCcy = FRMCCY    And
     C                             ZMDI1    = 'M'       And
     C                             ZMDI2    = 'M'       And
     C                             ZRATEX   < 1   )     Or
     C                             (BaseCcy = TOCCY     And
     C                             ZMDI1    = 'M'       And
     C                             ZMDI2    = 'M'       And
     C                             ZRATEX   < 1   )
 
     C                   Eval      BASMD = 'D'
 
     C                   Endif
 
 
     C                   CALLB     'ZCONVZ1'
     C                   PARM                    INPAMT           15 0
     C                   PARM                    CVTRAT           13 8
     C                   PARM                    BASMD             1
     C                   PARM                    FRMCCY            3
     C                   PARM                    TOCCY             3
     C                   PARM                    FRMDEC            1 0
     C                   PARM                    TODEC             1 0
     C                   PARM                    OUTAMT           15 0
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * READYPARM - Have the parameters ready for the call to the     *
      *             calculation program                               *
      *                                                               *
      * Called by: CALCPGM                                            *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
      *
     C     READYPARM     BEGSR
      *
      ** Collateral Weight Percentages
      ** Only if a collateral is found
      *
     C     *IN23         IFEQ      '0'
 
     C                   MOVEL     CollWeight(1) CollWt1
     C                   MOVEL     CollWeight(2) CollWt2
     C                   MOVEL     CollWeight(3) CollWt3
     C                   MOVEL     CollWeight(4) CollWt4
     C                   MOVEL     CollWeight(5) CollWt5
     C                   MOVEL     CollWeight(6) CollWt6
     C                   MOVEL     CollWeight(7) CollWt7
     C                   MOVEL     CollWeight(8) CollWt8
     C                   MOVEL     CollWeight(9) CollWt9
     C                   MOVEL     CollWeight(10)CollWt10
     C                   MOVEL     CollWeight(11)CollWt11
     C                   MOVEL     CollWeight(12)CollWt12
     C                   MOVEL     CollWeight(13)CollWt13
     C                   MOVEL     CollWeight(14)CollWt14
     C                   MOVEL     CollWeight(15)CollWt15
 
      ** Collateral Balances
 
     C                   Z-ADD     CollBal(1)    CollBl1
     C                   Z-ADD     CollBal(2)    CollBl2
     C                   Z-ADD     CollBal(3)    CollBl3
     C                   Z-ADD     CollBal(4)    CollBl4
     C                   Z-ADD     CollBal(5)    CollBl5
     C                   Z-ADD     CollBal(6)    CollBl6
     C                   Z-ADD     CollBal(7)    CollBl7
     C                   Z-ADD     CollBal(8)    CollBl8
     C                   Z-ADD     CollBal(9)    CollBl9
     C                   Z-ADD     CollBal(10)   CollBl10
     C                   Z-ADD     CollBal(11)   CollBl11
     C                   Z-ADD     CollBal(12)   CollBl12
     C                   Z-ADD     CollBal(13)   CollBl13
     C                   Z-ADD     CollBal(14)   CollBl14
     C                   Z-ADD     CollBal(15)   CollBl15
 
     C                   ENDIF
 
     C                   ENDSR
 
 
      /EJECT
      *****************************************************************
      *                                                               *
      * CALCPGM - Call Calculation Program                            *
      *                                                               *
      * Calls: AOSREFR0, ZA001240                                     *
      *                                                               *
      *****************************************************************
 
     C     CALCPGM       BEGSR
      *
      ** Clear variables for the next call
      *
     C                   MOVEL     *BLANKS       P@RTCD
     C                   MOVEL     *BLANKS       P@OP01
     C                   MOVEL     *BLANKS       P@VL01
      *
      ** To find out which calculation program to call, concatenate the
      ** calling program and the calculation method to make one field,
      ** this will be the second parm in calling AOSREFR0.
      *
     C                   EVAL      P@OP01 = 'RiskWeightAssetGL' + WWCalcMet
 
     C                   CALLB     'AOSREFR0'
     C                   PARM                    P@RTCD            7
     C                   PARM                    P@OP01           30
     C                   PARM                    P@VL01          200
     C                   PARM                    P@OP02           30
     C                   PARM                    P@VL02          200
     C                   PARM                    P@OP03           30
     C                   PARM                    P@VL03          200
     C                   PARM                    P@OP04           30
     C                   PARM                    P@VL04          200
     C                   PARM                    P@OP05           30
     C                   PARM                    P@VL05          200
     C                   PARM                    P@OP06           30
     C                   PARM                    P@VL06          200
     C                   PARM                    P@OP07           30
     C                   PARM                    P@VL07          200
     C                   PARM                    P@OP08           30
     C                   PARM                    P@VL08          200
     C                   PARM                    P@OP09           30
     C                   PARM                    P@VL09          200
     C                   PARM                    P@OP10           30
     C                   PARM                    P@VL10          200
 
     C     P@RTCD        IFNE      *BLANKS
     C                   MOVEL     'USR1241'     WMSGI
     C                   MOVEL     'SDUSRMSG'    WMSGF
     C                   EXSR      SRMSGF
     C                   ENDIF
      *
      ** If Return Code is blank, call the program returned from third parm
      *
     C     P@RTCD        IFEQ      *BLANKS
 
     C                   EVAL      NCalcPgm = P@VL01
 
     C                   CALL      NCalcPgm
     C                   PARM                    WWAsetBal
     C                   PARM                    WWCustPWtg
     C                   PARM                    WWAcctPWtg
     C                   PARM                    CollWt1
     C                   PARM                    CollWt2
     C                   PARM                    CollWt3
     C                   PARM                    CollWt4
     C                   PARM                    CollWt5
     C                   PARM                    CollWt6
     C                   PARM                    CollWt7
     C                   PARM                    CollWt8
     C                   PARM                    CollWt9
     C                   PARM                    CollWt10
     C                   PARM                    CollWt11
     C                   PARM                    CollWt12
     C                   PARM                    CollWt13
     C                   PARM                    CollWt14
     C                   PARM                    CollWt15
     C                   PARM                    CollBl1
     C                   PARM                    CollBl2
     C                   PARM                    CollBl3
     C                   PARM                    CollBl4
     C                   PARM                    CollBl5
     C                   PARM                    CollBl6
     C                   PARM                    CollBl7
     C                   PARM                    CollBl8
     C                   PARM                    CollBl9
     C                   PARM                    CollBl10
     C                   PARM                    CollBl11
     C                   PARM                    CollBl12
     C                   PARM                    CollBl13
     C                   PARM                    CollBl14
     C                   PARM                    CollBl15
     C                   PARM                    RetRiskWB
     C                   PARM                    RetCustRWA
     C                   PARM                    RetAcctRWA
     C                   PARM                    RetCollRWA1
     C                   PARM                    RetCollRWA2
     C                   PARM                    RetCollRWA3
     C                   PARM                    RetCollRWA4
     C                   PARM                    RetCollRWA5
     C                   PARM                    RetCollRWA6
     C                   PARM                    RetCollRWA7
     C                   PARM                    RetCollRWA8
     C                   PARM                    RetCollRWA9
     C                   PARM                    RetCollRWA10
     C                   PARM                    RetCollRWA11
     C                   PARM                    RetCollRWA12
     C                   PARM                    RetCollRWA13
     C                   PARM                    RetCollRWA14
     C                   PARM                    RetCollRWA15
 
     C                   Eval      WWRiskWABal = RetRiskWB
 
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * RETURNEDVAL - Check the returned values from the calculation  *
      *               program.  If not equal to zeroes, output to file*
      *               for reporting purposes.                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     RETURNEDVAL   BEGSR
      *
      **  Check Interim RWA Balance for the Customer
      *
     C     RetCustRWA    IFNE      *ZERO
     C     WWWrtRWAR     ANDEQ     'Y'                                                        242239
     C                   EXSR      OUTCUST
     C                   ENDIF
      *
      **  Check Interim RWA Balance for the Account
      *
     C     RetAcctRWA    IFNE      *ZERO
     C     WWWrtRWAR     ANDEQ     'Y'                                                        242239
     C                   EXSR      OUTACCT
     C                   ENDIF
      *
      **  Move the Returned RWA Balance for the Collateral References
      **  Only if a collateral is found
      *
     C     *IN23         IFEQ      '0'
      *
     C                   EXSR      MOVERETCOLL
      *
      **  Check Interim RWA Balance for the Collateral References
      *
     C                   Z-ADD     1             N
 
     C     N             DOUEQ     16
 
     C     CollRWA(N)    IFNE      *ZERO
     C     WWWrtRWAR     ANDEQ     'Y'                                                        242239
     C                   EXSR      OUTCOLL
     C                   ENDIF
     C                   EVAL      N = N + 1
 
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * OUTCUST - Output details to GLRWARL0 for this customer        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     OUTCUST       BEGSR
      *
      ** Calculate the Interim RWA Balance Adjusted Amount
      *
     C                   EVAL (H)  TmpAdjA = (WPCustPWtg * RetCustRWA) / 100
      *
      ** Set up values for output to file
      *
     C                   EVAL      RWRECI = 'D'
     C                   EVAL      RWMOD = 'GL'
     C                   EVAL      RWSETN = WWSetNum
     C                   EVAL      RWTRAN = WWAcctRef
     C                   EVAL      RWAMNT = WWAsetBal
     C                   EVAL      RWCCY = NCcy
     C                   EVAL      RWWSRC = 'CUSTOMER'
     C                   EVAL      RWCODE = CustRWACode
     C                   EVAL      RWPERC = WPCustPWtg
     C                   EVAL      RWIAMT = RetCustRWA
     C                   EVAL      RWADJA = TmpAdjA
     C                   EVAL      RWABAL = RetRiskWB
     C                   EVAL      RWCCCY = *blanks
     C                   EVAL      RWCREF = *blanks
 
      ** Write to file
     C                   WRITE     GLRWARP0
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * OUTACCT - Output details to GLRWARL0 for this account         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     OUTACCT       BEGSR
      *
      ** Calculate the Interim RWA Balance Adjusted Amount
      *
     C                   EVAL (H)  TmpAdjA = (WPAcctPWtg * RetAcctRWA) / 100
      *
      ** Set up values for output to file
      *
     C                   EVAL      RWRECI = 'D'
     C                   EVAL      RWMOD = 'GL'
     C                   EVAL      RWSETN = WWSetNum
     C                   EVAL      RWTRAN = WWAcctRef
     C                   EVAL      RWAMNT = WWAsetBal
     C                   EVAL      RWCCY = NCcy
     C                   EVAL      RWWSRC = 'ACCOUNT'
     C                   EVAL      RWCODE = AcctRWACode
     C                   EVAL      RWPERC = WPAcctPWtg
     C                   EVAL      RWIAMT = RetAcctRWA
     C                   EVAL      RWADJA = TmpAdjA
     C                   EVAL      RWABAL = RetRiskWB
     C                   EVAL      RWCCCY = *blanks
     C                   EVAL      RWCREF = *blanks
 
      ** Write to file
     C                   WRITE     GLRWARP0
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * MOVERETCOLL- Move the returned RWA Balances for the collateral*
      *              references into an array                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     MOVERETCOLL   BEGSR
 
     C                   EVAL      CollRWA(1) = RetCollRWA1
     C                   EVAL      CollRWA(2) = RetCollRWA2
     C                   EVAL      CollRWA(3) = RetCollRWA3
     C                   EVAL      CollRWA(4) = RetCollRWA4
     C                   EVAL      CollRWA(5) = RetCollRWA5
     C                   EVAL      CollRWA(6) = RetCollRWA6
     C                   EVAL      CollRWA(7) = RetCollRWA7
     C                   EVAL      CollRWA(8) = RetCollRWA8
     C                   EVAL      CollRWA(9) = RetCollRWA9
     C                   EVAL      CollRWA(10) = RetCollRWA10
     C                   EVAL      CollRWA(11) = RetCollRWA11
     C                   EVAL      CollRWA(12) = RetCollRWA12
     C                   EVAL      CollRWA(13) = RetCollRWA13
     C                   EVAL      CollRWA(14) = RetCollRWA14
     C                   EVAL      CollRWA(15) = RetCollRWA15
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * OUTCOLL - Output details to GLRWARL0 for this Collateral Ref. *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     OUTCOLL       BEGSR
      *
      **  Calculate the Interim RWA Balance Adjusted Amount
      *
     C                   EVAL (H)  TmpAdjA = (CollRWA(N) * CollWPN(N)) / 100
      *
      **  Set up values for output to file
      *
     C                   EVAL      RWRECI = 'D'
     C                   EVAL      RWMOD = 'GL'
     C                   EVAL      RWSETN = WWSetNum
     C                   EVAL      RWTRAN = WWAcctRef
     C                   EVAL      RWAMNT = WWAsetBal
     C                   EVAL      RWCCY = NCcy
     C                   EVAL      RWWSRC = 'COLLATERAL'
     C                   EVAL      RWCODE = CollCodes(N)
     C                   EVAL      RWPERC = CollWPN(N)
     C                   EVAL      RWIAMT = CollRWA(N)
     C                   EVAL      RWADJA = TmpAdjA
     C                   EVAL      RWABAL = RetRiskWB
     C                   EVAL      RWCCCY = CollCcy(N)
     C                   EVAL      RWCREF = CollRef(N)
 
      ** Write to file
     C                   WRITE     GLRWARP0
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMSGF - Message Handling Subroutine                          *
      *                                                               *
      * Called by: CALCPGM                                            *
      *                                                               *
      * Calls    : ZA0340                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRMSGF        BEGSR
      *
     C     WMSGF         IFEQ      *BLANKS
     C                   MOVE      ZADFMF        WMSGF
     C                   ENDIF
      *
     C                   CALL      'ZA0340'
     C                   PARM                    WMSGF
     C                   PARM                    WMSGI
 
     C                   MOVE      *BLANKS       WMSGF
 
     C                   ENDSR
 
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
 
     C     *entry        PLIST
     C**********         PARM                    WWAcctRef        18                          CGL029
     C                   PARM                    WWAcctRef                                    CGL029
     C                   PARM                    WWAsetBal
     C                   PARM                    WWSetNum
     C                   PARM                    WWCalcMet
     C                   PARM                    WWRiskWABal
     C                   PARM                    WWGLREind
     C                   PARM                    WWWrtRWAR         1                          242239
 
     C                   EVAL      AKEYF = WWAcctRef
 
      ** Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SR/*INZSR'   DBPROC
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Get Base Currency
 
     C                   MOVEL     BJCYCD        BaseCcy
 
     C     *LIKE         DEFINE    CRRWSETN      WWSetNum
     C     *LIKE         DEFINE    CRRWCHTP      WWCalcMet
     C     *LIKE         DEFINE    CRRWCODE      WWCRWACode
     C     *LIKE         DEFINE    CRRWCODE      TempCode
     C     *LIKE         DEFINE    CRRWCODE      TempGLCode
     C     *LIKE         DEFINE    CRRWSETN      WWCRWSetNum
     C     *LIKE         DEFINE    PWRWRWAP      TempPWtg
     C     *LIKE         DEFINE    CDMODS        WWModSec
     C     *LIKE         DEFINE    CDMODS        WWGLREind
     C     *LIKE         DEFINE    CDCREF        WWCollRef
     C     *LIKE         DEFINE    CDCCY         WWCollCcy
     C     *LIKE         DEFINE    CDVAMT        WWRiskWABal
     C     *LIKE         DEFINE    CDVAMT        WWCollValAmt
     C     *LIKE         DEFINE    CDVAMT        WWNewValAmt
     C     *LIKE         DEFINE    CDVAMT        WWAsetBal
     C     *LIKE         DEFINE    BJCYCD        BaseCcy
 
     C                   MOVE      '0'           *IN20
     C                   MOVE      '0'           *IN21
     C                   MOVE      '0'           *IN22
     C                   MOVE      '0'           *IN23
     C                   Z-ADD     *ZERO         WPCustPWtg        5 2
     C                   Z-ADD     *ZERO         WPAcctPWtg        5 2
     C                   Z-ADD     *ZERO         W                 2 0
     C                   Z-ADD     *ZERO         N                 2 0
     C                   Z-ADD     *ZERO         TmpAdjA          15 0
     C                   MOVEA     *BLANKS       CollWeight
     C                   MOVEA     *ZERO         CollBal
     C                   MOVEA     *BLANKS       CollRef
     C                   MOVEA     *BLANKS       CollCcy
     C                   MOVEA     *BLANKS       CollCodes
     C                   MOVEA     *ZERO         CollRWA
     C                   MOVE      *BLANKS       NCalcPgm         10
     C                   MOVE      *BLANKS       CustRWACode       2
     C                   MOVE      *BLANKS       AcctRWACode       2
     C                   MOVE      *BLANKS       WMSGI            10
     C                   MOVE      *BLANKS       WMSGF            10
     C                   MOVE      *BLANKS       WWCustPWtg        5
     C                   MOVE      *BLANKS       WWAcctPWtg        5
     C                   MOVE      *BLANKS       CollWt1           5
     C                   MOVE      *BLANKS       CollWt2           5
     C                   MOVE      *BLANKS       CollWt3           5
     C                   MOVE      *BLANKS       CollWt4           5
     C                   MOVE      *BLANKS       CollWt5           5
     C                   MOVE      *BLANKS       CollWt6           5
     C                   MOVE      *BLANKS       CollWt7           5
     C                   MOVE      *BLANKS       CollWt8           5
     C                   MOVE      *BLANKS       CollWt9           5
     C                   MOVE      *BLANKS       CollWt10          5
     C                   MOVE      *BLANKS       CollWt11          5
     C                   MOVE      *BLANKS       CollWt12          5
     C                   MOVE      *BLANKS       CollWt13          5
     C                   MOVE      *BLANKS       CollWt14          5
     C                   MOVE      *BLANKS       CollWt15          5
     C                   Z-ADD     *ZERO         CollBl1          15 0
     C                   Z-ADD     *ZERO         CollBl2          15 0
     C                   Z-ADD     *ZERO         CollBl3          15 0
     C                   Z-ADD     *ZERO         CollBl4          15 0
     C                   Z-ADD     *ZERO         CollBl5          15 0
     C                   Z-ADD     *ZERO         CollBl6          15 0
     C                   Z-ADD     *ZERO         CollBl7          15 0
     C                   Z-ADD     *ZERO         CollBl8          15 0
     C                   Z-ADD     *ZERO         CollBl9          15 0
     C                   Z-ADD     *ZERO         CollBl10         15 0
     C                   Z-ADD     *ZERO         CollBl11         15 0
     C                   Z-ADD     *ZERO         CollBl12         15 0
     C                   Z-ADD     *ZERO         CollBl13         15 0
     C                   Z-ADD     *ZERO         CollBl14         15 0
     C                   Z-ADD     *ZERO         CollBl15         15 0
     C                   Z-ADD     *ZERO         RetRiskWB        15 0
     C                   Z-ADD     *ZERO         RetCustRWA       15 0
     C                   Z-ADD     *ZERO         RetAcctRWA       15 0
     C                   Z-ADD     *ZERO         RetCollRWA1      15 0
     C                   Z-ADD     *ZERO         RetCollRWA2      15 0
     C                   Z-ADD     *ZERO         RetCollRWA3      15 0
     C                   Z-ADD     *ZERO         RetCollRWA4      15 0
     C                   Z-ADD     *ZERO         RetCollRWA5      15 0
     C                   Z-ADD     *ZERO         RetCollRWA6      15 0
     C                   Z-ADD     *ZERO         RetCollRWA7      15 0
     C                   Z-ADD     *ZERO         RetCollRWA8      15 0
     C                   Z-ADD     *ZERO         RetCollRWA9      15 0
     C                   Z-ADD     *ZERO         RetCollRWA10     15 0
     C                   Z-ADD     *ZERO         RetCollRWA11     15 0
     C                   Z-ADD     *ZERO         RetCollRWA12     15 0
     C                   Z-ADD     *ZERO         RetCollRWA13     15 0
     C                   Z-ADD     *ZERO         RetCollRWA14     15 0
     C                   Z-ADD     *ZERO         RetCollRWA15     15 0
 
     C     KCRREC        KLIST
     C                   KFLD                    NCusta
     C                   KFLD                    WWSetNum
 
     C     KRWREC        KLIST
     C                   KFLD                    WWCRWACode
     C                   KFLD                    WWCRWSetNum
 
     C     KGCREC        KLIST
     C                   KFLD                    WWModSec
     C                   KFLD                    NCust
     C                   KFLD                    NCcy
     C                   KFLD                    NAcod
     C                   KFLD                    NAcsq
     C                   KFLD                    NBrca
 
     C     KGLREC        KLIST
     C                   KFLD                    WWCollRef
     C                   KFLD                    WWSetNum
 
     C     KARREC        KLIST
     C                   KFLD                    NBrca
     C                   KFLD                    NCust
     C                   KFLD                    NCcy
     C                   KFLD                    NAcod
     C                   KFLD                    NAcsq
     C                   KFLD                    WWSetNum
 
     C     KCAREC        KLIST
     C                   KFLD                    NBrca
     C                   KFLD                    NCust
     C                   KFLD                    NCcy
     C                   KFLD                    NAcod
     C                   KFLD                    NAcsq
 
     C                   ENDSR
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
