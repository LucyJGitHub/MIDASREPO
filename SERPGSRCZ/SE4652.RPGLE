     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Holding - Financial Instruments extract')     *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE4652 - Midas SE Statement - Financial Instruments Extract  *
      *                                                               *
      *  Function:  This module extract the details of Financial      *
      *             Instrument                                        *
      *                                                               *
      *  Called By   : SEC4651 - SE Statement Processing              *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CCB020             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG11193           Date 02May06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG11164           Date 06Apr06               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 CGL029             Date 01Sep03               *
      *                 218135             Date 23May03               *
      *                 218078             Date 23May03               *
      *                 218077             Date 23May03               *
      *                 218076             Date 23May03               *
      *                 CSE040   *CREATE   Date 05Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CCB020 - COB Restructure - Secondary COB Infrastructure      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG11193 - Purchased Interest not calculated on BackValued   *
      *             Trade. (Recompile)                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG11164 - A Serious Midas Error on SETRAD insert/amend      *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  218135 - Do not report financial instrument with 0 position  *
      *  218078 - Remove Transalaction table                          *
      *  218077 - Do not report matured security at the request start *
      *           date                                                *
      *  218076 - Apply the current factor to Mortgage Backed         *
      *           Securities                                          *
      *  CSE040 - Securities Statement Processing                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSESDRVL2  UF   E           K DISK    COMMIT       INFSR(*PSSR)
      ** Midas SE Statement - Driver file by Request
 
     FCPOSNL2   IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Customer Positions by CUST/SESN/BRCA/DATE
 
     FDPOSNL2   IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Depot Positions by DEPOT/SESN/BRCA/DATE
 
     FCDEPL2    IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Customer Depot Positions by Customer, ..
 
     FCDEPL3    IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Customer Depot Positions by Depot, Security, Branch, Customer
     F                                     RENAME(CDEPPDF:CDEPPD3)
 
     FUDEPL2    IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE User Depot Positions by Depot, Security, Branch
     F                                     RENAME(CDEPPDF:UDEPPD2)
     F                                     INFDS(INFDS1)
 
     FUDEPL3    IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE User Depot Positions by Depot, Security, Branch, book
     F                                     RENAME(UDEPPDF:UDEPPD3)
 
     FSDSECSL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Securities clients retrieval
 
     FSECTY     IF   E           K DISK    INFSR(*PSSR) PREFIX(Se_)
      ** Midas Security Details
 
     FINVTP     IF   E           K DISK    INFSR(*PSSR) PREFIX(In_)
      ** Midas SE Investment Types
 
     FCPPRIC    IF   E           K DISK    INFSR(*PSSR) PREFIX(Cp_)
      ** Midas SE Commercial Paper Prices
 
     FPRICT     IF   E           K DISK    INFSR(*PSSR) PREFIX(Pr_)
      ** Midas SE Prices file-type/sec/date
 
     FSECEO     IF   E           K DISK    INFSR(*PSSR) PREFIX(Ev_)
      ** Midas SE Secty Events-by Type, desc.Date
     F                                     IGNORE(SEDEVDF)
 
     FSEHLPOPD  UF A E           K DISK    COMMIT       INFSR(*PSSR)
      ** Midas SE Holding - Last Statement Position
 
     FSEHFINPD  O    E             DISK    COMMIT       INFSR(*PSSR)
      ** Midas SE Holding - Financial Instruments
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     D/COPY ZACPYSRC,STD_D_SPEC
 
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
 
      ** Array for No. of days
     D ZND             S              5  0 DIM(25)
     D                                     BASED(Pointer1)
     D  Pointer1       S               *   INZ(%ADDR(Cp_ND01))
 
      ** Array for Yield Rate
     D ZRT             S             15  8 DIM(25)
     D                                     BASED(Pointer2)
     D  Pointer2       S               *   INZ(%ADDR(Cp_YR01))
 
      ** Array for Dividend Payment or Coupon/Rate Day
     D CDArr           S              4S 0 DIM(12)
     D                                     BASED(Pointer3)
     D  Pointer3       S               *   INZ(%ADDR(Se_CD01))
 
      ** Array for Coupon/Rate Indicator
     D CRArr           S              1    DIM(12)
     D                                     BASED(Pointer4)
     D  Pointer4       S               *   INZ(%ADDR(Se_CR01))
 
      ** Array for Branch to process
     D ArrBrch         S              3    DIM(999)
 
     D*Dta_MPHAS*****E DS                  EXTNAME(MPHAS)  DTAARA(MPHAS)                      CCB020
      ***Midas*SC*Phase*of*day                                                                CCB020
 
     D DSSDRV        E DS                  EXTNAME(SESDRVPD)
      ** Midas SE Statement - Driver file
 
     D DSGELR        E DS                  EXTNAME(SDGELRPD)
      ** General Ledger Details
 
     D DSBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details
 
     D DSSECTY       E DS                  EXTNAME(SECTY) PREFIX(Se_)
      ** Midas Security Details
 
     D DSCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
 
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      ** File information data structure.
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS (short) used as output parameter for Access Objects
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS (long) used as output parameter for Access Objects
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** DS (longest) used as output parameter for Access Objects
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Data structure to save the Customer/Security Position.
 
     D DsPosition      DS
     D   DsPosDate                         LIKE(CSDA)                           Position Date
     D   DsNomTrade                        LIKE(CSNT)                           Nominal - Trade Date
     D   DsNomValue                        LIKE(CSNV)                           Nominal - Value Date
     D   DsNomSettle                       LIKE(CSNS)                           Nominal - Settle Dat
 
     D SvCustomer      S                   LIKE(CSCN)                           Customer
     D SvSecurity      S                   LIKE(CSSC)                           Security
 
     D KPriceTyp       S                   LIKE(Pr_PPRT)                        Price Type
     D KValDate        S                   LIKE(Pr_PVDT)                        Value Date
     D KCustNb         S                   LIKE(Pr_PCNM)                        Customer No.
     D KEventTyp       S                   LIKE(Ev_SNET)                        Event Type
 
     D CSE042          S              1                                         Feature CSE042
 
     D ZCPNR           S                   LIKE(Se_CPNR)                        Current Coupon Rate
     D ZPPDI           S                   LIKE(Se_PPDI)                        Partly Paid Indicato
     D ZPPCP           S                   LIKE(Se_CPDP)                        Current Partly Paid
     D ZSFPP           S                   LIKE(Se_SFPP)                        Fully Paid Price
     D ZPROT           S                   LIKE(In_PROT)                        Processing Type
     D ZCFCT           S                   LIKE(Se_CFCT)                        Current Factor
     D IRATE           S             15  9                                      Effective Int. Rate
     D ECD             S              5  0                                      Event Control Date
     D NCD             S              5  0                                      Next Coupon Date
     D NCDP            S                   LIKE(A6NBDP)                         Nom. Ccy Dec. Posit
     D ZAMT            S             15  0                                      Working Amount
     D ZSDATE          S              5  0                                      Start date
     D ZEDATE          S              5  0                                      End date
     D ZCDP            S              1  0                                      Number decimal Pos.
     D ZCDP2           S              1  0                                      Number decimal Pos.
     D ZACCRD          S             15  0                                      Interest Accrued
     D ZACCXD          S             15  1                                      Interest Accrued
     D ZRP             S              1                                         Pay/Rec/Zero Indicat
     D ZDDAYS          S              5P 0                                      No. of days in time
     D ZINTDD          S              5P 0                                      No. of days in inter
     D ZLOC            S              3                                         Location
     D SCUMEX          S              1                                         Cum/Ex coupon ind.
     D ZPRCIN          S             15  8                                      Yield to be convert.
     D ZFDATE          S              5  0                                      Yield Effective Date
     D ZNOML           S             15  0                                      Nominal
     D ZYLDOk          S              1                                         Zyld Ok indicator
     D ZPRCOT          S             15  8                                      Price as Percentage
     D WMPRIC          S             15  8                                      Market Price
     D ZFDAT           S              5  0                                      From Date
     D ZTDAT           S              5  0                                      To Date
     D ZBRCH           S              3                                         Branch
     D ZCUST           S              6                                         Customer
     D*ZDEPT****       S              6  0                                      Depot         CSD027
     D ZDEPT           S              6A                                        Depot         CSD027
     D ZSECT           S             10                                         Security
     D ZIAMT           S             15  0                                      Interest Amount
     D ZIAMTX          S             15  1                                      Interest Amount
     D ZAB             S              1                                         Use CPOSH/DPOSH
     D ZRATE1          S             13  8                                      Spot Rate
     D ZMDI1           S              1                                         Multiply/Divide Ind.
     D ZRATE2          S             13  8                                      Spot Rate
     D ZMDI2           S              1                                         Multiply/Divide Ind.
     D ZRATEX          S             13  8                                      Cross Exchange Rate
     D ZMDIX           S              1                                         Cross Mult/Div Ind.
     D ZAMTCI          S             15  0                                      Amount In
     D ZEXCH           S             13  8                                      Cross Exchange Rate
     D ZMD             S              1                                         Cross Mult/Div Ind.
     D ZCCYI           S              3                                         Currency In
     D ZCCYO           S              3                                         Currency Out
     D ZCDPI           S              1  0                                      Nb. Decimal In
     D ZCDPO           S              1  0                                      Nb. Decimal Out
     D ZAMTCO          S             15  0                                      Amount Out
     D NomCcyDec       S              1P 0                                      Nom. Ccy Dec. Posit.
 
     D @RUN            S              1
     D @CURR           S              3                                         Currency
     D BrchIdx         S              5U 0                                      Index
     D Idx             S              5U 0                                      Index
 
     D*WkCust***       S              6  0                                    Customer Number CSD027
     D WkCust          S              6A                                        Customer Numb CSD027
     D WkNominal       S                   LIKE(CSNT)                           Nominal Amount
     D WkDate          S              5  0                                      Date
     D WRKPI           S             15  9                                      Purchased interest
     D WKWPI           S             15  9                                      Purchased interest
     D WkBalance       S             20  0                                      Balance
     D WkAvailable     S             15  0                                      Available Nominal
     D WkEndOfFile     S              1                                         End of Position File
     D WkUpdPosit      S              1                                         Update Position
 
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
 
      ** Read Driver file
 
     C     *LOVAL        SETLL     SESDRVL2
     C                   READ      SESDRVL2
     C                   DOW       NOT %EOF(SESDRVL2)
 
      ** If cancellation, do not extract the holding
 
     C                   IF        SPCANC <> *Blanks
     C                   GOTO      EndExtract
     C                   ENDIF
 
      ** Retrieve the Customer Classe of the Safekeeping Customer.
 
     C                   MOVE      SPCUST        WkCust
 
     C     SPCUST        CHAIN     SDSECSL1
     C                   IF        NOT %FOUND(SDSECSL1)
     C                   GOTO      NextRequest
     C                   ENDIF
 
      ** Save the Safekeeping Customer, and security
 
     C                   MOVE      SPCUST        SvCustomer
     C                   EVAL      SvSecurity = SPSESN
 
      ** Read position files
 
     C                   EXSR      $ReadPosit
 
      ** Main Loop
 
     C                   DOW       WkEndOfFile = 'N'
 
      ** Clear Holding - Financial Instrument details.
 
     C                   CLEAR                   SEHFIND0
 
      *                                                                                       218135
      ** Do not report the 0 position.                                                        218135
      *                                                                                       218135
     C                   IF           SPTYPE = 'TF'                             Trade Complete218135
     C                             AND DsNomTrade = *Zeros                      Trade Nominal 218135
     C                             OR SPTYPE = 'TC'                             Trade Changes 218135
     C                             AND DsNomTrade = *Zeros                      Trade Nominal 218135
      *                                                                                       218135
     C                             OR SPTYPE = 'VF'                             Value Complete218135
     C                             AND DsNomValue = *Zeros                      Value Nominal 218135
     C                             OR SPTYPE = 'VC'                             Value Changes 218135
     C                             AND DsNomValue = *Zeros                      Value Nominal 218135
      *                                                                                       218135
     C                             OR SPTYPE = 'SF'                             Settle Complet218135
     C                             AND DsNomSettle = *Zeros                     Setlle Nominal218135
     C                             OR SPTYPE = 'SC'                             Settle Changes218135
     C                             AND DsNomSettle = *Zeros                     Setlle Nominal218135
      *                                                                                       218135
     C                   GOTO      NextPosition                                               218135
      *                                                                                       218135
     C                   ENDIF                                                                218135
 
      ** If the information to report is for a change position statement;
      **  - TC Trade Date Changes Position Statement
      **  - VC Value Date Changes Position Statement
      **  - SC Settle Date Changes Position Statement
      ** process only the position updated since the last statement.
 
     C                   IF           SPTYPE = 'TC'
     C                             OR SPTYPE = 'VC'
     C                             OR SPTYPE = 'SC'
     C                   EXSR      $UpdPosit
     C                   IF        WkUpdPosit = 'N'
     C                   GOTO      NextPosition
     C                   ENDIF
     C                   ENDIF
 
      ** Retrieve the security details.
      ** Do not report matured security at the request start date.                            218077
 
     C     SvSecurity    CHAIN     SECTY
     C                   IF        NOT %FOUND(SECTY)
     C                             OR  Se_MATY <> *Zeros                                      218077
     C                             AND Se_MATY <  SPMSTD                                      218077
     C                   GOTO      NextPosition
     C                   ENDIF
 
      ** Retrieve the investment details
 
     C     KInvTyp       CHAIN     INVTP
     C                   IF        NOT %FOUND(INVTP)
     C                   GOTO      NextPosition
     C                   ENDIF
 
      ** Calculate Security Details
 
     C                   EXSR      $CalcSecDtl
 
      ** Load security details
 
     C                   EXSR      $LdSecurity
 
      ** Load Corporate Action Option Code
 
     C                   EXSR      $LdCOAP
 
      ** Load Price
 
     C                   EXSR      $LdPrice
 
      ** Load Place: Source of Price
 
     C                   EXSR      $LdPlace
 
      ** Load Date/Time of Price Quotation
 
     C                   EXSR      $LdPrDate
 
      ** Load Aggregate Balance
 
     C                   EXSR      $LdAggBal
 
      ** Load Accrual details
 
      **   Retrieve the accrual only for security bearing interest.
 
     C                   IF            In_PROT <> '2'                           Commodities
     C                             AND In_PROT <> '4'                           Shares
     C                             AND In_PROT <> '7'                           Unit Trust
     C                             AND Se_DYBS <> '4'                           Day basis
     C                             AND Se_STBS <> 'D'                           Trade Basis
     C                             AND Se_CPNR <> *ZEROS                        Coupon Rate
 
      **   Load Accrual Days
 
     C                   EXSR      $LdAccDay
 
      **   Load Accrual Amount
 
     C                   EXSR      $LdAccAmt
 
     C                   ENDIF
 
      ** Exchange Rate
 
     C                   EXSR      $LdExcRat
 
      ** Load Holding Amount
 
     C                   EXSR      $LdHolAmt
 
      ** Retrieve Blocking Positions
 
     C                   IF        CSE042 = 'Y'
     C                   EXSR      $RtvBlock
     C                   ENDIF
 
      ** Add record to extract file
 
     C                   EVAL      HFEXTR =  *ZEROS
     C                   EVAL      HFDATE =  SPDATE
     C                   EVAL      HFRSEQ =  SPRSEQ
 
     C                   WRITE     SEHFIND0
 
     C     NextPosition  Tag
 
      ** If Security is specified, process only this one.
 
     C                   IF        SPSESN <> *BLANKS
     C                   GOTO      EndExtract
     C                   ENDIF
 
     C                   EXSR      $ReadPosit
 
     C                   ENDDO
 
     C     EndExtract    TAG
 
      ** Update Drive file
 
     C                   EVAL      SPEXTF = 'Y'
     C                   UPDATE    SESDRVD0
     C                   COMMIT
 
      ** Read next request (Driver file).
 
     C     NextRequest   TAG
 
     C                   READ      SESDRVL2
 
     C                   ENDDO
 
     C                   EXSR      $ExitMod
 
      **********************************************************************
      /EJECT
      **********************************************************************
      * $ReadPosit - Read Position files                                   *
      **********************************************************************
 
     C     $ReadPosit    BEGSR
      *    ----------    -----
 
      ** The purpose of this routine is to cummulate the Customer positions for a security
      ** independently of the branch, depot, market, book, ...
 
      ** Set End of File to 'Y'
 
     C                   EVAL      WkEndOfFile = 'Y'
 
      ** Clear position detail by Customer/Security
 
     C                   CLEAR                   DsPosition
     C                   CLEAR                   ArrBrch
     C                   EVAL      BrchIdx = 0
 
      ** If Input Cycle processing,
 
     C**********         IF        MPHAS = 'A'                                                CCB020
     C                   IF        COBST = '*NO'                                              CCB020
 
      ** If the Safekeeping Customer is a Safe Custody or a Discretionary,
 
     C                   IF        BFCLAS = 'S' OR BFCLAS = 'D'
 
      ** Retrieve Input Cycle Position for client
 
     C                   EXSR      $ICRtvClient
 
      ** Calculate Input Cycle Position for client
 
     C                   IF        WkEndOfFile = 'N'
     C                   EXSR      $ICCalClient
     C                   ENDIF
 
      ** Otherwise,
 
     C                   ELSE
 
      ** Retrieve Input Cycle Position for Depot
 
     C                   EXSR      $ICRtvDepot
 
      ** Calculate Input Cycle Position
 
     C                   IF        WkEndOfFile = 'N'
     C                   EXSR      $ICCalDepot
     C                   ENDIF
 
 
     C                   ENDIF
 
      ** If Close of Business processing,
 
     C                   ELSE
 
      ** If the Safekeeping Customer is a Safe Custody or a Discretionary,
 
     C                   IF        BFCLAS = 'S' OR BFCLAS = 'D'
 
      ** Retrieve Close of Business Position for client
 
     C                   EXSR      $CoBRtvClient
 
      ** Calculate Close of Business Position for client
 
     C                   IF        WkEndOfFile = 'N'
     C                   EXSR      $CoBCalClient
     C                   ENDIF
 
      ** Otherwise,
 
     C                   ELSE
 
      ** Retrieve Close of Business Position for depot
 
     C                   EXSR      $CoBRtvDepot
 
      ** Calculate Close of Business Position for depot
 
     C                   IF        WkEndOfFile = 'N'
     C                   EXSR      $CoBCalDepot
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $ICRtvClient  - Retrieve Input Cycle Position for client           *
      **********************************************************************
 
     C     $ICRtvClient  BEGSR
      *    ------------  -----
 
      ** Access the customer position
 
     C                   IF        SPSESN = *BLANKS
     C     KCustSecPos   SETGT     CDEPL2
     C     SvCustomer    READE     CDEPL2
     C                   ELSE
     C     KCustSecPos   SETLL     CDEPL2
     C     KCustSecPos   READE     CDEPL2
     C                   ENDIF
 
      ** If no position, leave the routine
 
     C                   IF        %EOF(CDEPL2)
     C                   LEAVESR
     C                   ENDIF
 
      ** Set End of File to 'N'
 
     C                   EVAL      WkEndOfFile = 'N'
 
      ** Save reference of current security
 
     C                   EVAL      SvSecurity = CDSN
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $ICCalClient  - Calculate Input Cycle Position for client          *
      **********************************************************************
 
     C     $ICCalClient  BEGSR
      *    ------------  -----
 
      ** Process all the customer positions by Security / Branch
 
     C                   DOU       %EOF(CDEPL2)
 
      ** Retrieve the position at the requested date
 
     C                   IF        DDTE <= SPMSTD
 
      ** Save the branches used.
 
     C     CDPA          LOOKUP    ArrBrch                                99
     C                   IF        NOT *IN99
     C                   EVAL      BrchIdx = BrchIdx + 1
     C                   EVAL      ArrBrch(BrchIdx) = CDPA
     C                   ENDIF
 
      ** Set Position Date, keep the lastest date
 
     C                   IF        DsPosDate   < DDTE                           Position Date
     C                   EVAL      DsPosDate   = DDTE                           Position Date
     C                   ENDIF
 
      ** Set Nominal Amounts
 
     C                   EVAL      DsNomTrade  = DsNomTrade  + CDNT             Nominal - Trade Date
     C                                                       + SNPT             Sum Nom - Purchase
     C                                                       + CDST             Sum Nom - Sale
     C                   EVAL      DsNomValue  = DsNomValue  + CDNV             Nominal - Value Date
     C                                                       + CNPV             Sum Nom - Purchase
     C                                                       + CNSV             Sum Nom - Sales
     C                   EVAL      DsNomSettle = DsNomSettle + CDNS             Nominal - Settle Dat
     C                                                       + CNSI             Nominal Settled I/C
 
      ** Access the next customer position by Customer/Security/Branch/Depot/Market
 
     C     KPosCDEPP     KLIST
     C                   KFLD                    CDCN                           Customer
     C                   KFLD                    CDSN                           Security
     C                   KFLD                    CDPA                           Branch
     C                   KFLD                    CDPT                           Depot
     C                   KFLD                    CDMK                           Market
 
     C     KPosCDEPP     SETGT     CDEPL2
 
     C                   ENDIF
 
     C     KCustSecPos   READE     CDEPL2
 
     C                   ENDDO
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $ICRtvDepot   - Retrieve Input Cycle Position for depot            *
      **********************************************************************
 
     C     $ICRtvDepot   BEGSR
      *    -----------   -----
 
      ** Access the customer position
 
     C                   IF        SPSESN = *BLANKS
     C     KCustSecPos   SETGT     UDEPL2
     C     SvCustomer    READE     UDEPL2
     C                   ELSE
     C     KCustSecPos   SETLL     UDEPL2
     C     KCustSecPos   READE     UDEPL2
     C                   ENDIF
 
      ** If no position, leave the routine
 
     C                   IF        %EOF(UDEPL2)
     C                   LEAVESR
     C                   ENDIF
 
      ** Set End of File to 'N'
 
     C                   EVAL      WkEndOfFile = 'N'
 
      ** Save reference of current security according the record format read.
 
     C                   SELECT
     C                   WHEN      @1FFM = 'UDEPPDF'
     C                   EVAL      SvSecurity = UDSN
     C                   WHEN      @1FFM = 'UDEPPD2'
     C                   EVAL      SvSecurity = CDSN
     C                   ENDSL
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $ICCalDepot   - Calculate Input Cycle Position for depot           *
      **********************************************************************
 
     C     $ICCalDepot   BEGSR
      *    -----------   -----
 
      ** Process all the depot positions by Security / Branch / Book
 
     C     KCustSecPos   SETLL     UDEPL3
     C     KCustSecPos   READE     UDEPL3
 
     C                   DOW       NOT %EOF(UDEPL3)
 
      ** Retrieve the position at the requested date
 
     C                   IF        UDDT <= SPMSTD
 
      ** Save the branches used.
 
     C     UDBA          LOOKUP    ArrBrch                                99
     C                   IF        NOT *IN99
     C                   EVAL      BrchIdx = BrchIdx + 1
     C                   EVAL      ArrBrch(BrchIdx) = UDBA
     C                   ENDIF
 
      ** Set Position Date, keep the lastest date
 
     C                   IF        DsPosDate   < UDDT                           Position Date
     C                   EVAL      DsPosDate   = UDDT                           Position Date
     C                   ENDIF
 
      ** Set Nominal Amounts
 
     C                   EVAL      DsNomTrade  = DsNomTrade  + UDNT             Nominal - Trade Date
     C                                                       + UDTP             Sum Nom - Purchase
     C                                                       + UDTS             Sum Nom - Sale
     C                   EVAL      DsNomValue  = DsNomValue  + UDNV             Nominal - Value Date
     C                                                       + UDPV             Sum Nom - Purchase
     C                                                       + UDSV             Sum Nom - Sales
     C                   EVAL      DsNomSettle = DsNomSettle + UDNS             Nominal - Settle Dat
     C                                                       + UNSI             Nominal Settled I/C
 
      ** Access the next depot position by Depot/Security/Branch/Book/Market
 
     C     KPosUDEPL     KLIST
     C                   KFLD                    UDPT                           Depot
     C                   KFLD                    UDSN                           Security
     C                   KFLD                    UDBA                           Branch
     C                   KFLD                    UDBK                           Book
     C                   KFLD                    UDMK                           Market
 
     C     KPosUDEPL     SETGT     UDEPL3
 
     C                   ENDIF
 
     C     KCustSecPos   READE     UDEPL3
 
     C                   ENDDO
 
      ** Process all the depot positions by Security / Branch / Customer
 
     C     KCustSecPos   SETLL     CDEPL3
     C     KCustSecPos   READE     CDEPL3
 
     C                   DOW       NOT %EOF(CDEPL3)
 
      ** Retrieve the position at the requested date
 
     C                   IF        DDTE <= SPMSTD
 
      ** Save the branches used.
 
     C     CDPA          LOOKUP    ArrBrch                                99
     C                   IF        NOT *IN99
     C                   EVAL      BrchIdx = BrchIdx + 1
     C                   EVAL      ArrBrch(BrchIdx) = CDPA
     C                   ENDIF
 
      ** Set Position Date, keep the lastest date
 
     C                   IF        DsPosDate   < DDTE                           Position Date
     C                   EVAL      DsPosDate   = DDTE                           Position Date
     C                   ENDIF
 
      ** Set Nominal Amounts
 
     C                   EVAL      DsNomTrade  = DsNomTrade  + CDNT             Nominal - Trade Date
     C                                                       + SNPT             Sum Nom - Purchase
     C                                                       + CDST             Sum Nom - Sale
     C                   EVAL      DsNomValue  = DsNomValue  + CDNV             Nominal - Value Date
     C                                                       + CNPV             Sum Nom - Purchase
     C                                                       + CNSV             Sum Nom - Sales
     C                   EVAL      DsNomSettle = DsNomSettle + CDNS             Nominal - Settle Dat
     C                                                       + CNSI             Nominal Settled I/C
 
      ** Access the next customer position by Depot/Security/Branch/Customer/Market
 
     C     KPosCDEPL     KLIST
     C                   KFLD                    CDPT                           Depot
     C                   KFLD                    CDSN                           Security
     C                   KFLD                    CDPA                           Branch
     C                   KFLD                    CDCN                           Customer
     C                   KFLD                    CDMK                           Market
 
     C     KPosCDEPL     SETGT     CDEPL3
 
     C                   ENDIF
 
     C     KCustSecPos   READE     CDEPL3
 
     C                   ENDDO
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $CoBRtvClient - Retrieve Close of Business Position for client     *
      **********************************************************************
 
     C     $CoBRtvClient BEGSR
      *    ------------- -----
 
      ** Access the customer position
 
     C                   IF        SPSESN = *BLANKS
     C     KCustSecPos   SETGT     CPOSNL2
     C     SvCustomer    READE     CPOSNL2
     C                   ELSE
     C     KCustSecPos   SETLL     CPOSNL2
     C     KCustSecPos   READE     CPOSNL2
     C                   ENDIF
 
      ** If no position, leave the routine
 
     C                   IF        %EOF(CPOSNL2)
     C                   LEAVESR
     C                   ENDIF
 
      ** Set End of File to 'N'
 
     C                   EVAL      WkEndOfFile = 'N'
 
      ** Save reference of current security
 
     C                   EVAL      SvSecurity = CSSC
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $CoBCalClient - Calculate Close of Business Position for client    *
      **********************************************************************
 
     C     $CoBCalClient BEGSR
      *    ------------- -----
 
      ** Process all the customer positions by Security / Branch
 
     C                   DOU       %EOF(CPOSNL2)
 
      ** Retrieve the position at the requested date
 
     C                   IF        CSDA <= SPMSTD
 
      ** Save the branches used.
 
     C     CSBA          LOOKUP    ArrBrch                                99
     C                   IF        NOT *IN99
     C                   EVAL      BrchIdx = BrchIdx + 1
     C                   EVAL      ArrBrch(BrchIdx) = CSBA
     C                   ENDIF
 
      ** Set Position Date, keep the lastest date
 
     C                   IF        DsPosDate   < CSDA                           Position Date
     C                   EVAL      DsPosDate   = CSDA                           Position Date
     C                   ENDIF
 
      ** Set Nominal Amounts
 
     C                   EVAL      DsNomTrade  = DsNomTrade  + CSNT             Nominal - Trade Date
     C                   EVAL      DsNomValue  = DsNomValue  + CSNV             Nominal - Value Date
     C                   EVAL      DsNomSettle = DsNomSettle + CSNS             Nominal - Settle Dat
 
      ** Access the next customer position by Customer/Security/Branch
 
     C     KPosCPOSN     KLIST
     C                   KFLD                    CSCN                           Customer
     C                   KFLD                    CSSC                           Security
     C                   KFLD                    CSBA                           Branch
 
     C     KPosCPOSN     SETGT     CPOSNL2
 
     C                   ENDIF
 
     C     KCustSecPos   READE     CPOSNL2
 
     C                   ENDDO
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $CoBRtvDepot  - Retrieve Close of Business Position for depot      *
      **********************************************************************
 
     C     $CoBRtvDepot  BEGSR
      *    ------------  -----
 
      ** Access the customer position
 
     C                   IF        SPSESN = *BLANKS
     C     KCustSecPos   SETGT     DPOSNL2
     C     SvCustomer    READE     DPOSNL2
     C                   ELSE
     C     KCustSecPos   SETLL     DPOSNL2
     C     KCustSecPos   READE     DPOSNL2
     C                   ENDIF
 
      ** If no position, leave the routine
 
     C                   IF        %EOF(DPOSNL2)
     C                   LEAVESR
     C                   ENDIF
 
      ** Set End of File to 'N'
 
     C                   EVAL      WkEndOfFile = 'N'
 
      ** Save reference of current security
 
     C                   EVAL      SvSecurity = DSSC
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $CoBCalDepot  - Calculate Close of Business Position for depot     *
      **********************************************************************
 
     C     $CoBCalDepot  BEGSR
      *    ------------  -----
 
      ** Process all the customer positions by Security / Branch
 
     C                   DOU       %EOF(DPOSNL2)
 
      ** Retrieve the position at the requested date
 
     C                   IF        DDTE <= SPMSTD
 
      ** Save the branches used.
 
     C     DSBA          LOOKUP    ArrBrch                                99
     C                   IF        NOT *IN99
     C                   EVAL      BrchIdx = BrchIdx + 1
     C                   EVAL      ArrBrch(BrchIdx) = DSBA
     C                   ENDIF
 
      ** Set Position Date, keep the lastest date
 
     C                   IF        DsPosDate   < DDTE                           Position Date
     C                   EVAL      DsPosDate   = DDTE                           Position Date
     C                   ENDIF
 
      ** Set Nominal Amounts
 
     C                   EVAL      DsNomTrade  = DsNomTrade  + DSNT             Nominal - Trade Date
     C                   EVAL      DsNomValue  = DsNomValue  + DSNV             Nominal - Value Date
     C                   EVAL      DsNomSettle = DsNomSettle + DSNS             Nominal - Settle Dat
 
      ** Access the next customer position by Customer/Security/Branch
 
     C     KPosDPOSN     KLIST
     C                   KFLD                    DDPT                           Customer
     C                   KFLD                    DSSC                           Security
     C                   KFLD                    DSBA                           Branch
 
     C     KPosDPOSN     SETGT     DPOSNL2
 
     C                   ENDIF
 
     C     KCustSecPos   READE     DPOSNL2
 
     C                   ENDDO
 
      *                  -----
     C                   ENDSR
      *************************************************************************
      * $UpdPosit   - Check if Position has been updated since last statement *
      *************************************************************************
 
     C     $UpdPosit     BEGSR
      *    ---------     -----
 
      ** Check if Position has been updated since last statement,
      ** and update the last position for next statement
 
     C                   EVAL      WkUpdPosit = 'N'
 
     C                   SELECT
     C                   WHEN      SPTYPE = 'TC'                                Trade Date - Change
 
      ** Check if the position has been updated
 
     C     KLastStmPos   CHAIN     SEHLPOPD
     C                   IF        NOT %FOUND(SEHLPOPD)
     C                             OR LPDATE <> DsPosDate                       Last statement date
     C                             OR LPNOML <> DsNomTrade                      Last statement posit
     C                   EVAL      WkUpdPosit = 'Y'                             Position updated
 
      ** Update the control file for next statement
 
     C                   EVAL      LPDATE = DsPosDate                           Load last stmt date
     C                   EVAL      LPNOML = DsNomTrade                          Load last stmt posit
     C                   IF        %FOUND(SEHLPOPD)
     C                   UPDATE    SEHLPOD0
     C                   ELSE
     C                   EVAL      LPCUST = SPCUST                              Safekeeping Customer
     C                   EVAL      LPRECP = SPRECP                              Recipient
     C                   EVAL      LPTYPE = SPTYPE                              Type of Statement
     C                   EVAL      LPSESN = SvSecurity                          Security
     C                   WRITE     SEHLPOD0
     C                   ENDIF
     C                   ENDIF
 
     C                   WHEN      SPTYPE = 'VC'                                Value date - Change
 
      ** Check if the position has been updated
 
     C     KLastStmPos   CHAIN     SEHLPOPD
     C                   IF        NOT %FOUND(SEHLPOPD)
     C                             OR LPDATE <> DsPosDate                       Last statement date
     C                             OR LPNOML <> DsNomValue                      Last statement posit
     C                   EVAL      WkUpdPosit = 'Y'                             Position updated
 
      ** Update the control file for next statement
 
     C                   EVAL      LPDATE = DsPosDate                           Load last stmt date
     C                   EVAL      LPNOML = DsNomValue                          Load last stmt posit
     C                   IF        %FOUND(SEHLPOPD)
     C                   UPDATE    SEHLPOD0
     C                   ELSE
     C                   EVAL      LPCUST = SPCUST                              Safekeeping Customer
     C                   EVAL      LPRECP = SPRECP                              Recipient
     C                   EVAL      LPTYPE = SPTYPE                              Type of Statement
     C                   EVAL      LPSESN = SvSecurity                          Security
     C                   WRITE     SEHLPOD0
     C                   ENDIF
     C                   ENDIF
 
     C                   WHEN      SPTYPE = 'SC'                                Settle date - Change
 
      ** Check if the position has been updated
 
     C     KLastStmPos   CHAIN     SEHLPOPD
     C                   IF        NOT %FOUND(SEHLPOPD)
     C                             OR LPDATE <> DsPosDate                       Last statement date
     C                             OR LPNOML <> DsNomSettle                     Last statement posit
     C                   EVAL      WkUpdPosit = 'Y'                             Position updated
 
      ** Update the control file for next statement
 
     C                   EVAL      LPDATE = DsPosDate                           Load last stmt date
     C                   EVAL      LPNOML = DsNomSettle                         Load last stmt posit
     C                   IF        %FOUND(SEHLPOPD)
     C                   UPDATE    SEHLPOD0
     C                   ELSE
     C                   EVAL      LPCUST = SPCUST                              Safekeeping Customer
     C                   EVAL      LPRECP = SPRECP                              Recipient
     C                   EVAL      LPTYPE = SPTYPE                              Type of Statement
     C                   EVAL      LPSESN = SvSecurity                          Security
     C                   WRITE     SEHLPOD0
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSL
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $CalcSecDtl - Calculate Security Details                           *
      **********************************************************************
 
     C     $CalcSecDtl   BEGSR
      *    -----------   -----
 
      ** Retrieve the number of decimal position of the Security Nominal Currency.
 
     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      Se_NMCY       @CURR
     C     DSCURR        PARM      DSCURR        DSSDY
 
     C                   EVAL      NCDP   = A6NBDP                              Nom. Ccy Dec. Posit.
     C                   EVAL      ZRATE1 = A6SPRT                              Spot Rate
     C                   EVAL      ZMDI1  = A6MDIN                              Multiply/Divide Ind.
 
      ** Determine next coupon date
 
     C                   CALLB     'ZNCD'
 
      * INPUTS
 
     C                   PARM                    Se_ITLD                        Initial Date
     C                   PARM                    Se_FCPN                        First Coupon Date
     C                   PARM                    Se_MATY                        Maturity Date
     C                   PARM                    CDArr                          Div. or Coupon Rate
     C                   PARM                    CRArr                          Coupon/Rate Indicat.
      *
     C                   PARM      SPSTTM        ECD                            Midas Start Date
     C                   PARM                    BJDFIN                         Date Format
 
     C                   PARM                    Se_NMCY                        Nominal Currency
     C                   PARM                    Se_SITP                        Security Investment
     C                   PARM                    Se_BCNV                        Effect on Holidays
 
     C                   PARM                    Se_LCPN                        Last Coupon Date
     C                   PARM                    Se_HCY1                                      CSE071
     C                   PARM                    Se_HCY2                                      CSE071
     C                   PARM                    Se_HCY3                                      CSE071
     C                   PARM                    Se_HCY4                                      CSE071
     C                   PARM                    Se_HCY5                                      CSE071
     C                   PARM                    Se_HCY6                                      CSE071
     C                   PARM                    Se_HCY7                                      CSE071
     C                   PARM                    Se_HCY8                                      CSE071
     C                   PARM                    Se_HCY9                                      CSE071
 
      * OUTPUTS
 
     C                   PARM                    NCD                            Next Coupon Date
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdSecurity - Load security details                                *
      **********************************************************************
 
     C     $LdSecurity   BEGSR
      *    -----------   -----
 
     C                   EVAL      HFSESN = Se_SESN                             Security shortname
     C                   EVAL      HFSRPN = Se_SRPN                             Security Report Name
     C                   EVAL      HFSFN1 = Se_SFN1                             Security Full Name 1
     C                   EVAL      HFSFN2 = Se_SFN2                             Security Full Name 2
     C                   EVAL      HFNMCY = Se_NMCY                             Nominal Currency
     C                   EVAL      HFNMDP = Se_NMDP                             Nominal decimal plac
     C                   EVAL      HFSCOR = Se_SCOR                             Country of risk
     C                   EVAL      HFSREF = Se_SREF                             Sedol (Extel) Ref
     C                   EVAL      HFT2RF = Se_T2RF                             Telekurs (Valoren) R
     C                   EVAL      HFCSPN = Se_CSPN                             Cusip Number
     C                   EVAL      HFISIN = Se_ISIN                             ISIN
     C                   EVAL      HFSPBS = Se_SPBS                             Price Basis
     C                   EVAL      HFSTBS = Se_STBS                             Trade Basis
     C                   EVAL      HFSYBS = Se_SYBS                             Yield Basis
     C                   EVAL      HFSWTP = Se_SWTP                             SWIFT Security Type
     C                   EVAL      HFPROT = In_PROT                             Processing Type
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   EVAL      HFSIZE = HFSIZE + 33                         Static fields
     C                                             + %LEN(%TRIM(HFSRPN))        Security Report Name
     C                                             + %LEN(%TRIM(HFSFN1))        Security Full Name 1
     C                                             + %LEN(%TRIM(HFSFN2))        Security Full Name 2
     C                                             + %LEN(%TRIM(HFSCOR))        Country of risk
     C                                             + 17                         ISIN
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdCOAP   - Load Corporate Action Option Code                      *
      **********************************************************************
 
     C     $LdCOAP       BEGSR
      *    -------       -----
 
     C                   EVAL      HFCAOP = *BLANKS
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   IF        HFCAOP <> *BLANKS
     C                   EVAL      HFSIZE = HFSIZE + 14                         Static fields
     C                                             + %LEN(%TRIM(HFCAOP))        Corporate Action Opt
     C                   ENDIF
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdPrice  - Load Price                                             *
      **********************************************************************
 
     C     $LdPrice      BEGSR
      *    ---------     -----
 
      ** Qualifier
      *  ---------
 
     C                   EVAL      HFPQUA = 'MRKT'                              MRKT or INDC
 
      ** Currency
      *  --------
 
      ** The price currency is the nominal currency of the security.
 
     C                   IF        Se_SPBS = 'U'
     C                   EVAL      HFPCCY = Se_NMCY
     C                   ENDIF
 
      ** Decimal Position
      *  ----------------
 
      ** The price has 8 decimal positions
 
     C                   EVAL      HFPDPS = 8
 
      ** Price
      *  -----
 
      ** If processing type 9 and trade basis is 'Yield',
      **   use yield as Market price
 
     C                   IF        In_PROT = '9'
     C                             AND Se_STBS = 'Y'
 
     C     KComPrice     CHAIN     CPPRIC
     C                   IF        %FOUND(CPPRIC)
     C                   EVAL      ZBASD = BJRDNB                               Base date
     C                   EVAL      ZMDAT = Se_MATY                              Maturity Date
 
      ** Retrieve Yield
 
     C                   EXSR      ZYMTX
 
     C                   EVAL      HFPRIC = ZY1
 
     C                   GOTO      @LdPrice
     C                   ENDIF
     C                   ENDIF
 
      ** Retrieve the lastest Market Price for Security
 
     C                   EVAL      KPriceTyp = 'V '                             Price Type
     C                   EVAL      KValDate  = *ZEROS                           Value Date
     C                   EVAL      KCustNb   = *ZEROS                           Customer Number
 
     C     KPosPrice     SETLL     PRICT
     C                   DOU       %EOF(PRICT) OR Pr_RECI = 'D'
     C     KPrice        READE     PRICT
     C                   ENDDO
 
      ** If price found
 
     C                   IF        NOT %EOF(PRICT)
 
      ** Lastest price from Prices file
 
     C                   EVAL      HFPRIC = Pr_PPRC
 
      ** Otherwise,
 
     C                   ELSE
 
      ** Market Price from Security
 
     C                   EVAL      HFPRIC = Se_MKPR
     C                   ENDIF
 
     C     @LdPrice      TAG
 
      ** Code
      *  ----
 
      ** The code depends of 'Trade Basis' and 'Price Basis' indicator.
 
     C                   SELECT
     C                   WHEN      HFPRIC = *ZEROS                              No Price
     C                   EVAL      HFPCOD = 'UKWN'
     C                   WHEN      Se_STBS = 'Y'                                Yield
     C                   EVAL      HFPCOD = 'YIEL'
     C                   WHEN      Se_STBS = 'D'                                Discount
     C                   EVAL      HFPCOD = 'DISC'
     C                   WHEN      Se_STBS = 'P'                                Price Basis
     C                   IF        Se_SPBS = 'P'
     C                   EVAL      HFPCOD = 'PRCT'                              Percentage
     C                   ELSE
     C                   EVAL      HFPCOD = 'ACTU'                              Actual Amount
     C                   ENDIF
     C                   ENDSL
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   EVAL      HFSIZE = HFSIZE + 18                         Static fields
     C                                             + %LEN(%TRIM(HFPQUA))        Qualifier
     C                                             + %LEN(%TRIM(HFPCOD))        Code
     C                                             + %LEN(%TRIM(HFPCCY))        Currency
     C                                             + %LEN(%CHAR(HFPRIC)) + 2    Price + Comma + Sign
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdPlace  - Load Place: Source of Price                            *
      **********************************************************************
 
     C     $LdPlace      BEGSR
      *    --------      -----
 
     C                   EVAL      HFPLCD = *BLANKS                             Place Code
     C                   EVAL      HFPLAC = *BLANKS                             Place
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   IF        HFPLCD <> *BLANKS
     C                   EVAL      HFSIZE = HFSIZE + 19                         Static fields
     C                                             + %LEN(%TRIM(HFPLCD))        Place Code
     C                                             + %LEN(%TRIM(HFPLAC))        Place
     C                   ENDIF
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdPrDate - Load Date/Time of Price Quotation                      *
      **********************************************************************
 
     C     $LdPrDate     BEGSR
      *    ---------     -----
 
     C                   EVAL      HFPQDT = *ZEROS                              Price Quotation Date
     C                   EVAL      HFPQTM = *ZEROS                              Price Quotation Time
 
     C                   EVAL      KEventTyp = 'PR'                             Price event
     C     KQuotDat      SETLL     SECEO
     C     KQuotDat      READE     SECEO
     C                   IF        NOT %EOF(SECEO)
     C                   EVAL      HFPQDT = Ev_SNDT                             Event Date
     C                   ENDIF
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   IF        HFPQDT <> *ZEROS
     C                   EVAL      HFSIZE = HFSIZE + 14                         Static fields
     C                                             + 8                          Quotation Date
     C                   IF        HFPQTM <> *ZEROS
     C                   EVAL      HFSIZE = HFSIZE + 6                          Quotation Time
     C                   ENDIF
     C                   ENDIF
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdAggBal - Load Aggregate Balance                                 *
      **********************************************************************
 
     C     $LdAggBal     BEGSR
      *    ---------     -----
 
      ** Balance Code
      *  ------------
 
      ** Load the Code according the Price Basis
 
     C                   IF        Se_SPBS = 'P'                                Percentage
     C                   EVAL      HFBLCD = 'FAMT'                              Face Value
     C                   ELSE
     C                   EVAL      HFBLCD = 'UNIT'                              Unit
     C                   ENDIF
 
      ** Balance Amount
      *  --------------
 
      ** According the type of statement, retrieve the Nominal Amount
 
     C                   SELECT
 
     C                   WHEN         SPTYPE = 'TF'                             Trade Date Complete
     C                             OR SPTYPE = 'TC'                             Trade Date Changes
     C                   EVAL      HFBALA = DsNomTrade
 
     C                   WHEN         SPTYPE = 'VF'                             Value Date Covelete
     C                             OR SPTYPE = 'VC'                             Value Date Changes
     C                   EVAL      HFBALA = DsNomValue
 
     C                   WHEN         SPTYPE = 'SF'                             Settle Date Complete
     C                             OR SPTYPE = 'SC'                             Settle Date Changes
     C                   EVAL      HFBALA = DsNomSettle
 
     C                   ENDSL
 
      ** Number of Decimal Position
      *  --------------------------
 
     C                   EVAL      HFBDPS = Se_NMDP
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   EVAL      HFSIZE = HFSIZE + 18                         Static fields
     C                                             + %LEN(%TRIM(HFBLCD))        Balance Code
     C                                             + %LEN(%CHAR(HFBALA)) + 2    Bal Amount + Comma
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdAccDay - Load Accrual Days                                      *
      **********************************************************************
 
     C     $LdAccDay     BEGSR
      *    ---------     -----
 
      ** Retrieve Last Coupon Date before Control Date
      *  ---------------------------------------------
 
     C                   CALLB     'ZLCD'
      * INPUTS
      * Security details
     C                   PARM                    Se_ISSD
     C                   PARM                    Se_ITLD
     C                   PARM                    Se_FCPN
     C                   PARM                    Se_MATY
     C                   PARM                    CDArr
     C                   PARM                    CRArr
     C                   PARM                    Se_LCPN                                    BUG11164
      ** Event Control Date
      ** Date Format
     C                   PARM      SPMSTD        ZECD              5 0          Midas Start Date
     C                   PARM                    BJDFIN
      ** Nominal Currency
      ** Security Investment Type
      ** Effect on Holidays on Coupon Dates
     C                   PARM                    Se_NMCY
     C                   PARM                    Se_SITP
     C                   PARM                    Se_BCNV
      ** Effect of Holidays on Dates                                                          CSE071
     C                   PARM                    Se_HCY1                                      CSE071
     C                   PARM                    Se_HCY2                                      CSE071
     C                   PARM                    Se_HCY3                                      CSE071
     C                   PARM                    Se_HCY4                                      CSE071
     C                   PARM                    Se_HCY5                                      CSE071
     C                   PARM                    Se_HCY6                                      CSE071
     C                   PARM                    Se_HCY7                                      CSE071
     C                   PARM                    Se_HCY8                                      CSE071
     C                   PARM                    Se_HCY9                                      CSE071
      * OUTPUTS
      ** Last Coupon Date before Control Date
     C                   PARM                    ZZLCD             5 0
 
      ** Calcule number of days between two dates
      *  ----------------------------------------
 
     C                   CALLB     'ZDAYS'
      * INPUTS
      * start date
      * end date
     C                   PARM      ZZLCD         ZSDATE                         Last Coupon Date bef
     C                   PARM      SPMSTD        ZEDATE                         Midas Start Date
      * Security details
     C                   PARM                    Se_DYBS
     C                   PARM                    Se_ITLD
     C                   PARM                    Se_LCPN
     C                   PARM                    Se_IADJ
     C                   PARM                    Se_CPNR
     C                   PARM                    Se_MATY
     C                   PARM                    NCD                            Next Coupon Date
      * interest days adjustment
     C                   PARM                    DADJN             1
      * day number accrued to
      * accrual type (Y=yield, I=interest, D=discount)
      * accrue last day indicator
     C                   PARM                    ZIDNAT            2 0
     C                   PARM                    ZACLT             1
     C                   PARM                    ACLD              1
      ** Date format indicator
     C                   PARM                    BJDFIN
      * OUTPUTS
      * no of days
     C                   PARM                    ZDDAYS
      * day number accrued to
     C                   PARM                    ZODNAT            2 0
 
     C                   Z-ADD     ZDDAYS        HFNBDY
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   EVAL      HFSIZE = HFSIZE + 14                         Static fields
     C                                             + %LEN(%CHAR(HFNBDY)) + 1    Accrual Days
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdAccAmt - Load Accrual Amount                                    *
      **********************************************************************
 
     C     $LdAccAmt     BEGSR
      *    ---------     -----
 
      ** Accrued Amount Currency
      *  -----------------------
 
     C                   EVAL      HFAACY = Se_NMCY                             Nominal Currency
 
      ** Accrued Amount Decimal Position
      *  -------------------------------
 
     C                   EVAL      HFAADP = NCDP                                Nom. Ccy. Dec. Pos.
 
      ** Accrued Amount
      *  --------------
 
     C                   EVAL      ZFDAT  = ZZLCD                               Last Coupon date
     C                   EVAL      ZTDAT  = SPMSTD                              Event control Date
     C                   MOVE      SvCustomer    ZCUST                          Customer
     C                   EVAL      ZDEPT  = SvCustomer                          Depot
     C                   EVAL      ZSECT  = SvSecurity                          Security
     C                   EVAL      ZCDP   = NCDP                                Nom. Ccy. Dec. Pos.
     C                   EVAL      ZAB    = 'A'                                 Use CPOSH/DPOSH
 
      ** Process accrual for all changes
 
     C                   DO        BrchIdx       Idx
 
     C                   EVAL      ZBRCH  = ArrBrch(Idx)                        Branch
 
     C                   IF        BFCLAS = 'S' OR BFCLAS = 'D'
     C                   CALL      'ZACCRC'
     C                   PARM                    ZFDAT                          From Date
     C                   PARM                    ZTDAT                          To Date
     C                   PARM                    ZBRCH                          Branch
     C                   PARM                    ZCUST                          Customer/Depot
     C                   PARM                    ZSECT                          Security
     C                   PARM                    ZCDP                           Nb. decimal Position
     C                   PARM                    ZIAMT                          Interest Amount
     C                   PARM                    ZAB                            Use CPOSH/DPOSH
     C                   ELSE
     C                   CALL      'ZACCRD'
     C                   PARM                    ZFDAT                          From Date
     C                   PARM                    ZTDAT                          To Date
     C                   PARM                    ZBRCH                          Branch
     C                   PARM                    ZDEPT                          Customer/Depot
     C                   PARM                    ZSECT                          Security
     C                   PARM                    ZCDP                           Nb. decimal Position
     C                   PARM                    ZIAMT                          Interest Amount
     C                   PARM                    ZIAMTX                         Interest Amount
     C                   PARM                    ZAB                            Use CPOSH/DPOSH
     C                   ENDIF
 
     C                   EVAL      HFAAMT = HFAAMT + ZIAMT
 
     C                   ENDDO
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   EVAL      HFSIZE = HFSIZE + 18                         Static fields
     C                                             + %LEN(%TRIM(HFAACY))        Accrued Currency
     C                                             + %LEN(%CHAR(HFAAMT)) + 2    Accrued Amnt + Comma
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdExcRat - Exchange Rate                                          *
      **********************************************************************
 
     C     $LdExcRat     BEGSR
      *    ---------     -----
 
      ** First Currency
      *  --------------
 
     C                   EVAL      HFERC1 = Se_NMCY                             Nominal Currency
 
      ** Second Currency
      *  ---------------
 
     C                   IF        BFPCYC = *BLANKS                             Portfolio currency
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      HFERC2 = BFPCYC
 
      ** Retrieve the number of decimal position of the Second Currency.
 
     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      HFERC2        @CURR
     C     DSCURR        PARM      DSCURR        DSSDY
 
      ** Cross Exchange Rate
      *  -------------------
 
     C                   EVAL      ZCDP2  = A6NBDP                              Cust Ccy Dec. Posit.
     C                   EVAL      ZRATE2 = A6SPRT                              Spot Rate
     C                   EVAL      ZMDI2  = A6MDIN                              Multiply/Divide Ind.
 
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1                         Spot Rate
     C                   PARM                    ZMDI1                          Multiply/Divide Ind.
     C                   PARM                    ZRATE2                         Spot Rate
     C                   PARM                    ZMDI2                          Multiply/Divide Ind.
     C                   PARM                    ZRATEX                         Cross Exchange Rate
     C                   PARM                    ZMDIX                          Cross Mult/Div Ind.
 
     C                   EVAL      HFEXRT = ZRATEX                              Cross Exchange Rate
     C                   EVAL      HFEXMD = ZMDIX                               Cross Mult/Div Ind.
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   EVAL      HFSIZE = HFSIZE + 22                         Static fields
     C                                             + %LEN(%TRIM(HFERC1))        First Currency
     C                                             + %LEN(%TRIM(HFERC2))        Second Currency
     C                                             + %LEN(%CHAR(HFEXRT)) + 1    Exchange Rate +Comma
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdHolAmt - Load Holding Amount                                    *
      **********************************************************************
 
     C     $LdHolAmt     BEGSR
      *    ---------     -----
 
      ** Retrieve Consideration
      *  ----------------------
 
     C                   EVAL      WRKPI     = *ZEROS                           Purchase Interest
     C                   EVAL      SCUMEX    = 'C'                              Cumex Ind.
     C                   EVAL      WkNominal = HFBALA                           Aggregate Balance
 
      **   For Australian Yield basis
 
     C                   IF            Se_STBS   =  'Y'
     C                             AND Se_SYBS   =  'AU'
     C                             AND WkNominal <> *ZEROS
     C                   EXSR      $AustYield
     C                   ENDIF
 
      **   Retrieve Percentage Price
 
     C                   EVAL      WMPRIC = *ZEROS
 
     C                   IF        HFPRIC <> *ZEROS
 
     C                   EVAL      ZNOML = WkNominal
 
     C                   EVAL      ZPRCIN = HFPRIC                              Yield to be convert.
     C                   EVAL      ZFDATE = BJRDNB                              Yield Effective Date
 
     C                   EXSR      $ZPRCI
 
     C                   EVAL      WMPRIC = ZPRCOT                              Market Price
 
     C                   ENDIF
 
      **   Calculate Consideration according the number of decimal position of nominal currency
 
     C                   CALLB     'ZCNSD'
      * INPUTS
     C                   PARM      WkNominal     ZNOML                          Nominal
     C                   PARM      WMPRIC        ZPRC             16 9          Price
     C                   PARM                    Se_SPBS                        Price basis
     C                   PARM                    Se_NMDP                        Nominal decimal plac
     C                   PARM      NCDP          NomCcyDec                      Nominal currecy deci
      * OUTPUTS
     C                   PARM                    ZCONS            15 0          Consideration
 
      ** Holding Amount Currency
      *  -----------------------
 
     C                   EVAL      HFHACY = Se_NMCY                             Nominal Currency
 
      ** Holding Amount Decimal Position
      *  -------------------------------
 
     C                   EVAL      HFHADP = NCDP                                Nom. Ccy. Dec. Pos.
 
      ** Holding Amount
      *  --------------
 
     C                   EVAL      HFHAMT = ZCONS
      *                                                                                       218076
      *  Apply the current factor to Mortgage Backed Securities                               218076
      *                                                                                       218076
     C                   IF        Se_CFCT <> *Zeros                                          218076
     C                   EVAL (H)  HFHAMT = HFHAMT * Se_CFCT                                  218076
     C                   ENDIF                                                                218076
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   EVAL      HFSIZE = HFSIZE + 18                         Static fields
     C                                             + %LEN(%TRIM(HFHACY))        Holding Amount Ccy
     C                                             + %LEN(%CHAR(HFHAMT)) + 2    Holding Amount+Comma
 
      ** Calculate the amount in Portfolio Currency if exist
 
     C                   IF        HFERC2 <> *Blanks                            Customer Currency
 
      ** Holding Amount in Portfolio Currency
      *  ------------------------------------
 
     C                   EVAL      HFHPCY = HFERC2                              Customer Currency
 
      ** Holding Amount Decimal Position in Portfolio Currency
      *  -----------------------------------------------------
 
     C                   EVAL      HFHPDP = ZCDP2                               Cust Ccy. Dec. Pos.
 
      ** Holding Amount in Portfolio Currency
      *  ------------------------------------
 
     C                   EVAL      ZAMTCI = HFHAMT
 
     C                   CALLB     'ZCONV'
     C                   PARM                    ZAMTCI                         Amount In
     C                   PARM      HFEXRT        ZEXCH                          Cross Exchange Rate
     C                   PARM      HFEXMD        ZMD                            Cross Mult/Div Ind.
     C                   PARM      HFERC1        ZCCYI                          Currency In
     C                   PARM      HFERC1        ZCCYO                          Currency Out
     C                   PARM      NCDP          ZCDPI                          Nb. Decimal In
     C                   PARM      ZCDP2         ZCDPO                          Nb. Decimal Out
     C                   PARM                    ZAMTCO                         Amount Out
 
     C                   EVAL      HFHPAM = ZAMTCO
 
     C                   ENDIF
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $RtvBlock - Retrieve Blocking Positions                            *
      **********************************************************************
 
     C     $RtvBlock     BEGSR
      *    ---------     -----
 
     C                   EVAL      WkAvailable = HFBALA                         Available Nominal
 
     C                   CALLB     'SE4653'
     C                   PARM      *BLANKS       ReturnCode                     Return Code
     C                   PARM                    DSSDRV                         Request Parameters
     C                   PARM                    DSSECTY                        Security Details
     C                   PARM                    WkAvailable                    Available Nominal
 
     C                   IF        ReturnCode <> *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF
 
      *                  -----
     C                   ENDSR
      ********************************************************************
      *  Subroutine- ZYMTX
      *  Function  - To calculate yield based on days to maturity
      *
      *
      *  Input  - ZMDAT (5,0) Maturity Date
      *           ZBASD (5,0) Base date
      *           ZND   25 X(5,0) Array of no. of days to maturity
      *           ZRT   25 X(15,8) Array of yield rates
      *
      *  Output - ZY1 (15,8) Yield rate
      *           ZB1 (5,0) Days to maturity
      *           ZB2 (5,0) Previous days to maturity
      *           ZY2 (15,8) Previous yield rate
      *           ZB3 (5,0) Next days to maturity
      *           ZY3 (15,8) Previous yield rate
      *
      ********************************************************************
 
     C     ZYMTX         BEGSR
      *    -----         -----
 
      ** Define and Initialize variables
 
     C                   Z-ADD     0             ZB1               5 0
     C                   Z-ADD     0             ZB2               5 0
     C                   Z-ADD     0             ZB3               5 0
     C                   Z-ADD     0             ZY1              15 8
     C                   Z-ADD     0             ZY2              15 8
     C                   Z-ADD     0             ZY3              15 8
     C                   Z-ADD     0             ZX                2 0
     C                   MOVE      *BLANK        ZIND              1
     C                   Z-ADD     ZBASD         ZBASD             5 0
     C                   Z-ADD     ZMDAT         ZMDAT             5 0
 
      ** Calculate No. of days to maturity
      *
     C     ZMDAT         SUB       ZBASD         ZB1
 
      ** If the maturity date is less than the base date
      ** ie. the security is unfixed and overdue, the yield rate is the
      ** Yield associated with the lowest day No. entry
 
     C     ZMDAT         IFLT      ZBASD
     C                   Z-ADD     ZRT(1)        ZY1
     C                   Z-ADD     0             ZB2
     C                   Z-ADD     0             ZB3
     C                   Z-ADD     0             ZY2
     C                   Z-ADD     0             ZY3
 
      ** Processing if Mat. Date is higher than or equal to base date
 
     C                   ELSE
 
     C                   MOVE      'N'           ZIND
     C                   Z-ADD     1             ZX
 
     C     ZX            DOWLE     25
     C     ZIND          ANDEQ     'N'
 
      ** If No. of days to maturity equals the contents of ZND,ZX
      ** the Yield rate (ZY1) will be the associated Yield rate from
      ** ZRT
 
     C     ZB1           IFEQ      ZND(ZX)
     C                   Z-ADD     ZRT(ZX)       ZY1
     C                   Z-ADD     0             ZB2
     C                   Z-ADD     0             ZB3
     C                   Z-ADD     0             ZY2
     C                   Z-ADD     0             ZY3
     C                   MOVE      'Y'           ZIND
     C                   END
 
      ** If No. of days to maturity is greater than the contents of
      ** ZND,ZX and ZRT=0  the Yield rate will be the Yield rate
      ** ZRT,ZX-1
 
     C     ZB1           IFGT      ZND(ZX)
     C     ZND(ZX)       ANDEQ     0
     C     ZX            SUB       1             ZZ
     C                   Z-ADD     ZRT(ZZ)       ZY1
     C                   MOVE      'Y'           ZIND
     C                   END
 
      ** If No. of days to maturity is less than the contents of
      ** ZND,ZX and ZX <> 1 the Yield rate will calculated by assuming
      ** a uniform change of Yield rate between ZND,ZX-1 and ZND,ZX
 
      * ZZ  = ZX - 1
      *                      (                                     )
      * ZY1 =   ZRT,ZX  -    ( ( ZND,ZX - ZB1)   (ZRT,ZX - ZRT,ZZ) )
      *                      (                X  ~~~~~~~~~~~~~~~~~ )
      *                      (                   (ZND,ZX - ZND,ZZ) )
      *                      (                                     )
      *
     C     ZB1           IFLT      ZND(ZX)
     C     ZX            ANDNE     1
 
     C     ZX            SUB       1             ZZ                2 0
     C     ZND(ZX)       SUB       ZND(ZZ)       ZC                5 0
     C     ZRT(ZX)       SUB       ZRT(ZZ)       ZD               15 8
 
      ** Calculate Yield rate
 
     C     ZND(ZX)       SUB       ZB1           ZH                5 0
     C     ZH            DIV       ZC            ZF               15 8
     C     ZF            MULT      ZD            ZG               15 8
     C     ZRT(ZX)       SUB       ZG            ZY1
     C                   Z-ADD     ZND(ZZ)       ZB2
     C                   Z-ADD     ZRT(ZZ)       ZY2
     C                   Z-ADD     ZND(ZX)       ZB3
     C                   Z-ADD     ZRT(ZX)       ZY3
     C                   MOVE      'Y'           ZIND
     C                   END
 
      ** If No. of days to maturity is less than the contents of
      ** ZND,ZX and ZX = 1 the Yield rate will be ZRT,1
 
     C     ZB1           IFLT      ZND(ZX)
     C     ZX            ANDEQ     1
 
     C                   Z-ADD     ZRT(1)        ZY1
     C                   Z-ADD     0             ZB2
     C                   Z-ADD     0             ZY2
     C                   Z-ADD     ZND(1)        ZB3
     C                   Z-ADD     ZRT(1)        ZY3
     C                   MOVE      'Y'           ZIND
     C                   END
 
     C                   ADD       1             ZX
     C                   END
 
     C                   END
 
      *                  -----
     C                   ENDSR
 
      **********************************************************************
      * $AustYield - Set up fields for Australian Yield basis              *
      **********************************************************************
 
     C     $AustYield    BEGSR
      *    ----------    -----
 
      ** If this is a security traded on an Australian yield basis
      ** then set up fields required for ZPRCI.
      ** (Purch Int = accrued to date/nominal).
 
      ** Calculate effective interest rate
      *  ---------------------------------
 
     C                   CALLB     'ZRATE'
 
      * INPUTS
 
     C                   PARM      Se_CPNR       ZCPNR                          Current Coupon Rate
     C                   PARM      Se_PPDI       ZPPDI                          Partly Paid Indicato
     C                   PARM      Se_CPDP       ZPPCP                          Current Partly Paid
     C                   PARM      Se_SFPP       ZSFPP                          Fully Paid Price
     C                   PARM      In_PROT       ZPROT                          Processing Type
     C                   PARM      Se_CFCT       ZCFCT                          Current Factor
 
      * OUTPUTS
 
     C                   PARM                    IRATE                          Effective Int. Rate
 
      ** Calculate interest between two dates
      *  ------------------------------------
 
     C                   CALLB     'ZACCR'
 
      * INPUTS
 
     C                   PARM      WkNominal     ZAMT                           Principal amount
     C                   PARM                    IRATE                          Interest Rate
     C                   PARM      Se_LCPN       ZSDATE                         Start date
     C                   PARM      BJRDNB        ZEDATE                         End date
      *
     C                   PARM                    DSSECTY                        Security Details
     C                   PARM                    DADJN             1            interest days adjust
     C                   PARM                    NCD                            Next Coupon Date
     C                   PARM      NCDP          ZCDP                           Nominal currency dec
     C                   PARM                    In_PROT                        Processing type
 
     C                   PARM                    BJDFIN                         Date format
 
      * OUTPUTS
 
     C                   PARM                    ZACCRD                         Interest Accrued
     C                   PARM                    ZACCXD                         Interest Accrued
     C                   PARM                    ZRP                            Pay/Rec/Zero Indicat
     C                   PARM                    ZDDAYS                         No. of days in time
     C                   PARM                    ZINTDD                         No. of days in inter
 
     C                   EVAL      WRKPI = ZACCRD / WkNominal
 
      ** Australian yield, check cum or ex coupon date
      *  ---------------------------------------------
 
     C                   CALL      'ZYCE'
 
      * INPUTS
 
     C                   PARM      BJRDNB        WkDate                         Date to be checked
     C                   PARM                    NCD                            Next Coupon Date
     C                   PARM                    Se_EDFT                        Ex Date Default
     C                   PARM                    ZLOC                           Location
     C                   PARM                    Se_NMCY                        Nominal Currency
 
      * OUTPUTS
 
     C                   PARM                    SCUMEX                         Cum/Ex coupon ind.
 
      ** If Ex-coupon then PI passed is the remaining interest tillNCD and is negative.
 
     C                   IF        SCUMEX = 'X'
 
     C                   CALLB     'ZACCR'
 
      * INPUTS
 
     C                   PARM      WkNominal     ZAMT                           Principal amount
     C                   PARM                    IRATE                          Interest Rate
     C                   PARM      Se_LCPN       ZSDATE                         Start date
     C                   PARM      NCD           ZEDATE                         End date
      *
     C                   PARM                    DSSECTY                        Security Details
     C                   PARM                    DADJN             1            interest days adjust
     C                   PARM                    NCD                            Next Coupon Date
     C                   PARM      NCDP          ZCDP                           Nominal currency dec
     C                   PARM                    In_PROT                        Processing type
 
     C                   PARM                    BJDFIN                         Date format
 
      * OUTPUTS
 
     C                   PARM                    ZACCRD                         Interest Accrued
     C                   PARM                    ZACCXD                         Interest Accrued
     C                   PARM                    ZRP                            Pay/Rec/Zero Indicat
     C                   PARM                    ZDDAYS                         No. of days in time
     C                   PARM                    ZINTDD                         No. of days in inter
 
     C                   EVAL      WKWPI = ZACCRD / WkNominal
     C                   EVAL      WRKPI = WRKPI - WKWPI
 
     C                   ENDIF
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $ZPRCI    - Output price as a %age price                           *
      **********************************************************************
 
     C     $ZPRCI        BEGSR
      *    ------        -----
 
     C                   CALLB     'ZPRCI'
 
      * INPUTS
     C                   PARM                    ZPRCIN                         Yield to be convert.
     C                   PARM                    ZFDATE                         Yield Effective Date
 
     C                   PARM                    DSSECTY                        Security Details
     C                   PARM      NCDP          ZCDP                           Nom. Ccy Dec. Pos.
     C                   PARM                    In_PROT                        Processing type
 
     C                   PARM                    ZNOML                          Nominal
     C                   PARM                    WRKPI                          Purchase Interest
     C                   PARM                    SCUMEX                         Cumex ind.
 
     C                   PARM                    BJDFIN                         Date format
 
      * OUTPUTS
     C                   PARM                    ZYLDOk                         Zyld Ok indicator
     C                   PARM                    ZPRCOT                         Price as Percentage
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $ExitMod  - Exit from the module                                   *
      **********************************************************************
 
     C     $ExitMod      BEGSR
      *    ---------     -----
 
     C                   MOVE      *On           *INLR
     C                   RETURN
 
      *                  -----
     C                   ENDSR
      **********************************************************************
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
      *    ------        -----
 
     C     *entry        PLIST
     C                   PARM                    ReturnCode
 
      ** Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     DSBANK        PARM      DSBANK        DSFDY
 
      ** Access Switchable features
 
     C                   EVAL      CSE042 = 'N'
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSE042'      @SARD             6
     C                   IF        @RTCD = *Blanks
     C                   EVAL      CSE042 = 'Y'
     C                   ENDIF
 
      ** Access General Ledger details
 
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****DSGELR        PARM      DSGELR        DSFDY                                        CGL029
     C     DSGELR        PARM      DSGELR        DSSDY                                        CGL029
 
      ** Initialize LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  PSProcName
     C                   OUT       LDA
 
     C**********         IN        Dta_MPHAS                                                  CCB020
      *                                                                                       CCB020
      ** CBFLAGQT Phase Check                                                                 CCB020
      *                                                                                       CCB020
     C                   CALL      'CBC001001'                                                CCB020
     C                   PARM      *BLANKS       COBST             4                          CCB020
 
      ** Key to access the Investment Type
 
     C     KInvTyp       KLIST
     C                   KFLD                    Se_NMCY                        Nominal Currency
     C                   KFLD                    Se_SITP                        Security Investment
 
      ** Key to access the Commercial Paper Prices
 
     C     KComPrice     KLIST
     C                   KFLD                    Se_SITP                        Security Investment
     C                   KFLD                    Se_NMCY                        Nominal Currency
 
      ** Key to access the Market Prices
 
     C     KPosPrice     KLIST
     C                   KFLD                    KPriceTyp                      Price Type
     C                   KFLD                    Se_SESN                        Security
     C                   KFLD                    KValDate                       Value Date
     C                   KFLD                    KCustNb                        Customer Number
 
     C     KPrice        KLIST
     C                   KFLD                    KPriceTyp                      Price Type
     C                   KFLD                    Se_SESN                        Security
 
      ** Key to access Quotation Date
 
     C     KQuotDat      KLIST
     C                   KFLD                    Se_SESN                        Security
     C                   KFLD                    KEventTyp                      Event Type
 
      ** Key to access the next customer position
 
     C     KCustSecPos   KLIST
     C                   KFLD                    SvCustomer
     C                   KFLD                    SvSecurity
 
      ** Key to access the last statement position
 
     C     KLastStmPos   KLIST
     C                   KFLD                    SPCUST                         Safekeeping Customer
     C                   KFLD                    SPRECP                         Recipient
     C                   KFLD                    SPTYPE                         Type of Statement
     C                   KFLD                    SvSecurity                     Security
 
      *                  -----
     C                   ENDSR
 
      *********************************************************************
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
      *    -----         -----
 
     C                   DUMP
 
     C                   EVAL      ReturnCode = '*ERROR*'
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *                  -----
     C                   ENDSR
 
      ********************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2003
