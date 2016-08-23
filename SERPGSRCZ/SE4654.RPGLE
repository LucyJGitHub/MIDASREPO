     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Transaction - Extract')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE4654 - Midas SE Transaction Extract                        *
      *                                                               *
      *  Function:  This module extracts the details of Transaction   *
      *                                                               *
      *  Called By   : SEC4651 - SE Statement Processing              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CCB020             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 CSW208             Date 15Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW207             Date 09Jul07               *
      *                 234300             Date 26Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG11193           Date 02May06               *
      *                 BUG11164           Date 06Apr06               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CSE040   *CREATE   Date 10Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CCB020 - COB Restructure - Secondary COB Infrastructure      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  234300 - Recompiled over changed in PF/HSTTRD.               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG11193 - Purchased Interest not calculated on BackValued   *
      *             Trade. (Recompile)                                *
      *  BUG11164 - A Serious Midas Error on SETRAD insert/amend      *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CSE040 - Securities Statement Processing                     *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSESDRVL7  UF   E           K DISK    COMMIT       INFSR(*PSSR)
      ** Midas SE Holding - Driver file by Request
 
     FTRADCL1   IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Ccy and history trades by cust/sec/brch
     F                                     INFDS(INFDS1)
     F                                     RENAME(SEDVPRD0:ClDVPRD0)
     F                                     RENAME(POSETDF:ClPOSETD)
 
     FTRADCL2   IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Ccy and history trades by depot/sec/brch
     F                                     INFDS(INFDS2)
 
     FTRADS     IF   E           K DISK    INFSR(*PSSR) PREFIX(Rtv_)
      ** Midas SE Trades
     F                                     RENAME(TRADSDF:Rtv_TRADS)
 
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
 
     FSETFINPD  O    E             DISK    COMMIT       INFSR(*PSSR)
      ** Midas SE Transaction - Financial Instruments
 
     FSETPRTPD  O    E             DISK    COMMIT       INFSR(*PSSR)
      ** Midas SE Transaction - Transaction Party
 
     FSETINDPD  O    E             DISK    COMMIT       INFSR(*PSSR)
      ** Midas SE Transaction - Transaction Indicator
 
     FSETTRAPD  O    E             DISK    COMMIT       INFSR(*PSSR)
      ** Midas SE Transaction - Transaction Details
 
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
 
     D*Dta_MPHAS*****E DS                  EXTNAME(MPHAS)  DTAARA(MPHAS)                      CCB020
      ***Midas*SC*Phase*of*day                                                                CCB020
 
      ** Decision Table
     D TbArgmt         S             18    DIM(157) CTDATA PERRCD(1)
     D TbResult        S             11    DIM(157) ALT(TbArgmt)
 
     D DSBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details
 
     D DSGELR        E DS                  EXTNAME(SDGELRPD)
     D  QQPLA1       E                     EXTFLD(QQPLAC)                                     CGL029
      ** General Ledger Details
 
     D DSSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** Securities trading ICD data
 
     D DSCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
 
     D DSCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Customer Details
 
     D DSBOOK        E DS                  EXTNAME(SDBOOKPD)
      ** Book Details
 
     D INFDS1          DS
      ** File information data structure.
     D   RcdFmt1         *RECORD
 
     D INFDS2          DS
      ** File information data structure.
     D   RcdFmt2         *RECORD
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS (short) used as output parameter for Access Objects
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS (long) used as output parameter for Access Objects
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** DS (longest) used as output parameter for Access Objects
 
     D DsArgmt         DS
      ** DS to define the argument to search in decision table
      *
      ** Customer Class (Client/Market)
     D   WkCnumClass                  1
     D   WkA1                         1    INZ(' ')                             Filler
      *
      ** Transaction type
     D   WkTransType                  2
     D   WkA2                         1    INZ(' ')                             Filler
      *
      ** Counterparty Class or Beneficiary Class (Client/Market)
     D   WkCountClass                 1
     D   WkA3                         1    INZ(' ')                             Filler
      *
      ** Deliver To or In Depot (X/ )
     D   WkInCust                     1
     D   WkA4                         1    INZ(' ')                             Filler
      *
      ** Deliver From or Out Depot (X/ )
     D   WkOutCust                    1
     D   WkA5                         1    INZ(' ')                             Filler
      *
      ** Relation between Deliver From/To or In/Out Depot (=/<>/ )
     D   WkRelation                   2
     D   WkA6                         1    INZ(' ')                             Filler
      *
      ** Leg of depot (IN/OUT/  )
     D   WkLeg                        3
     D   WkA7                         1    INZ(' ')                             Filler
 
     D DsResult        DS
      ** DS to define the result of the search in decision table
      *
      ** Report (Y/N)
     D   WkReport                     1
     D   WkR1                         1    INZ(' ')                             Filler
      *
      ** Decrease/Increase indicator (D/I/ )
     D   WkDeInInd                    1
     D   WkR2                         1    INZ(' ')                             Filler
      *
      ** Position type (Customer/User/Our/ )
     D   WkPositType                  1
     D   WkR3                         1    INZ(' ')                             Filler
      *
      ** Transaction (Trade/Depot/    )
     D   WkTrans                      5
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WTran2Rpt       S              1                                         Transact. to report
     D WFinDtlFnd      S              1                                         Financial Dtl Found
     D WkProcess       S              1                                         Process transaction
 
     D WPrSESN         S                   LIKE(TR_SESN)                        Previous Security
     D WTrnBySec       S              5U 0                                      Trans. Seq by Secur.
     D*WkCust***       S              6  0                                      Customer Numb CSD027
     D WkCust          S              6                                         Customer Numb CSD027
     D WkCustClass     S              1                                         Customer Class
     D WkCountCust     S              6                                         Count/Benef. Custome
     D WkBBCSID        S                   LIKE(BBCSID)                         Save 1 address
     D WkBckValDate    S              5  0                                      Back Value Date
 
     D KPriceTyp       S                   LIKE(Pr_PPRT)                        Price Type
     D KValDate        S                   LIKE(Pr_PVDT)                        Value Date
     D KCustNb         S                   LIKE(Pr_PCNM)                        Customer No.
     D KEventTyp       S                   LIKE(Ev_SNET)                        Event Type
 
     D NCD             S              5  0                                      Next Coupon Date
     D NCDP            S              1  0                                      Nom. Ccy Dec. Posit
     D ZECD            S              5  0                                      Event Control Date
     D ZSDATE          S              5  0                                      Start date
     D ZEDATE          S              5  0                                      End date
     D DADJN           S              1
     D ZDDAYS          S              5P 0                                      No. of days in time
     D ZAMTCI          S             15  0                                      Amount In
     D ZEXCH           S             13  8                                      Cross Exchange Rate
     D ZMD             S              1                                         Cross Mult/Div Ind.
     D ZCCYI           S              3                                         Currency In
     D ZCCYO           S              3                                         Currency Out
     D ZCDPI           S              1  0                                      Nb. Decimal In
     D ZCDPO           S              1  0                                      Nb. Decimal Out
     D ZAMTCO          S             15  0                                      Amount Out
 
     D Idx             S              5U 0
 
     D @RUN            S              1
     D @CURR           S              3                                         Currency
 
     D WkRcdFmt        S              8                                         Record Format
     D Prtcd           S              7                                                       CSW207
     D CSW207          S              1A                                                      CSW207
     D CSW208          S              1A                                                      CSW208
 
     ITRADSDF
     I              RECI                        TR_RECI                         Record ID
     I              TDSS                        TR_SESN                         Security
     I              TDTP                        TR_TYPE                         Transaction Type
     I              TCNR                        TR_COBE                         CounterPart/Benefic.
     I              LCD                         TR_LCD                          Last change date
 
     IHSTTRDF
     I              RECI                        TR_RECI                         Record ID
     I              TDSS                        TR_SESN                         Security
     I              TDTP                        TR_TYPE                         Transaction Type
     I              TCNR                        TR_COBE                         CounterPart/Benefic.
     I              LCD                         TR_LCD                          Last change date
 
     IDPTMVDF
     I              RECI                        TR_RECI                         Record ID
     I              DPSS                        TR_SESN                         Security
     I              DPMV                        TR_TYPE                         Transaction Type
     I              DPBN                        TR_COBE                         CounterPart/Benefic.
     I              LCD                         TR_LCD                          Last change date
 
     IClDVPRD0
     I              DVRECI                      TR_RECI                         Record ID
     I              DVSESN                      TR_SESN                         Security
     I              DVTYPE                      TR_TYPE                         Transaction Type
     I              DVCNUM                      TR_COBE                         CounterPart/Benefic.
     I              DVLCD                       TR_LCD                          Last change date
 
     IClPOSETD
     I              RECI                        TR_RECI                         Record ID
     I              PSSH                        TR_SESN                         Security
     I              PEVT                        TR_TYPE                         Transaction Type
     I              PCPY                        TR_COBE                         CounterPart/Benefic.
     I              LCD                         TR_LCD                          Last change date
 
     ITRADTO
     I              RECI                        TR_RECI                         Record ID
     I              TDSS                        TR_SESN                         Security
     I              TDTP                        TR_TYPE                         Transaction Type
     I              TCNR                        TR_COBE                         CounterPart/Benefic.
     I              LCD                         TR_LCD                          Last change date
 
     ITRADFR
     I              RECI                        TR_RECI                         Record ID
     I              TDSS                        TR_SESN                         Security
     I              TDTP                        TR_TYPE                         Transaction Type
     I              TCNR                        TR_COBE                         CounterPart/Benefic.
     I              LCD                         TR_LCD                          Last change date
 
     IHSTTRTO
     I              RECI                        TR_RECI                         Record ID
     I              TDSS                        TR_SESN                         Security
     I              TDTP                        TR_TYPE                         Transaction Type
     I              TCNR                        TR_COBE                         CounterPart/Benefic.
     I              LCD                         TR_LCD                          Last change date
 
     IHSTTRFR
     I              RECI                        TR_RECI                         Record ID
     I              TDSS                        TR_SESN                         Security
     I              TDTP                        TR_TYPE                         Transaction Type
     I              TCNR                        TR_COBE                         CounterPart/Benefic.
     I              LCD                         TR_LCD                          Last change date
 
     IDPTMVIN
     I              RECI                        TR_RECI                         Record ID
     I              DPSS                        TR_SESN                         Security
     I              DPMV                        TR_TYPE                         Transaction Type
     I              DPBN                        TR_COBE                         CounterPart/Benefic.
     I              LCD                         TR_LCD                          Last change date
 
     IDPTMVOU
     I              RECI                        TR_RECI                         Record ID
     I              DPSS                        TR_SESN                         Security
     I              DPMV                        TR_TYPE                         Transaction Type
     I              DPBN                        TR_COBE                         CounterPart/Benefic.
     I              LCD                         TR_LCD                          Last change date
 
     ISEDVPRD0
     I              DVRECI                      TR_RECI                         Record ID
     I              DVSESN                      TR_SESN                         Security
     I              DVTYPE                      TR_TYPE                         Transaction Type
     I              DVCNUM                      TR_COBE                         CounterPart/Benefic.
     I              DVLCD                       TR_LCD                          Last change date
 
     IPOSETDF
     I              RECI                        TR_RECI                         Record ID
     I              PSSH                        TR_SESN                         Security
     I              PEVT                        TR_TYPE                         Transaction Type
     I              PCPY                        TR_COBE                         CounterPart/Benefic.
     I              LCD                         TR_LCD                          Last change date
 
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
      *  ----------------
 
     C     *LOVAL        SETLL     SESDRVL7
     C                   READ      SESDRVL7
     C                   DOW       NOT %EOF(SESDRVL7)
 
     C                   EVAL      WkRcdFmt = *Blanks                           Current format Read
     C                   EVAL      WPrSESN  = *Blanks                           Previous Financial
     C                   MOVE      SPCUST        WkCust                         Customer
     C                   EVAL      WFinDtlFnd  = 'N'                            Financial Dtl Found
 
      ** If cancellation, do not extract the holding
 
     C                   IF        SPCANC <> *Blanks
     C                   GOTO      EndExtract
     C                   ENDIF
 
      ** Retrieve the Customer Class of the Safekeeping Customer.
      *  --------------------------------------------------------
 
     C     SPCUST        CHAIN     SDSECSL1
     C                   IF        NOT %FOUND(SDSECSL1)
     C                   GOTO      NextRequest
     C                   ENDIF
 
     C                   IF        BFCLAS = 'S'                                 Safe Custody
     C                             OR BFCLAS = 'D'                              Discretionary
     C                   EVAL      WkCustClass = 'C'                            Client
     C                   ELSE
     C                   EVAL      WkCustClass = 'M'                            Market
     C                   ENDIF
 
      ** If the Safekeeping Customer is a Safe Custody or a Discretionary,
 
     C                   IF        WkCustClass = 'C'
     C     WkCust        SETLL     TRADCL1
     C     WkCust        READE     TRADCL1
     C                   EVAL      WkRcdFmt = RcdFmt1
 
      ** Otherwise,
 
     C                   ELSE
     C     WkCust        SETLL     TRADCL2
     C     WkCust        READE     TRADCL2
     C                   EVAL      WkRcdFmt = RcdFmt2
     C                   ENDIF
 
      ** Main Loop
 
     C                   DOW       NOT %EOF
 
      ** Check if the transaction has to be reported.
 
     C                   CLEAR                   DsArgmt
     C                   CLEAR                   DsResult
 
     C     1             DO        2
 
     C                   EXSR      $CheckTrns
 
     C                   SELECT
 
      **   If transaction has not be reported due to exclusion details
 
     C                   WHEN      WTran2Rpt = 'N'
     C                             AND DsArgmt = *Blanks
     C                   LEAVE
 
      **   If transaction has not be reported due to Conditional details
 
     C                   WHEN      WTran2Rpt = 'N'
     C                   ITER
     C                   ENDSL
 
      ** Retrieve and Load Financial Instrument corresponding to the transaction
 
     C                   EXSR      $FinDtl
 
      **   If details do not exist, process next transaction.
 
     C                   IF        WFinDtlFnd = 'N'
     C                   LEAVE
     C                   ENDIF
 
      ** Load transaction details
 
     C                   EXSR      $LdTransact
 
     C                   ENDDO
 
      ** Read next transaction according the Safekeeping Customer Classe.
 
     C                   IF        WkCustClass = 'C'
     C     WkCust        READE     TRADCL1
     C                   EVAL      WkRcdFmt = RcdFmt1
 
      ** Otherwise,
 
     C                   ELSE
     C     WkCust        READE     TRADCL2
     C                   EVAL      WkRcdFmt = RcdFmt2
     C                   ENDIF
 
     C                   ENDDO
 
     C     EndExtract    TAG
 
      ** Update Drive file
 
     C                   EVAL      SPEXTF = 'Y'
     C                   UPDATE    SESDRVD0
     C                   COMMIT
 
      ** Read next request (Driver file).
 
     C     NextRequest   TAG
 
     C                   READ      SESDRVL7
 
     C                   ENDDO
 
     C                   EXSR      $ExitMod
 
      **********************************************************************
      /EJECT
      **********************************************************************
      * $CheckTrns - Check if the transaction has to be reported.          *
      **********************************************************************
 
     C     $CheckTrns    BEGSR
      *    ----------    -----
 
      ** Default result of transaction check
 
     C                   EVAL      WTran2Rpt = 'N'
 
      ** First call
      *  ==========
 
     C                   IF        DsArgmt = *Blanks
 
      ** Exclusion transastion details
      *  -----------------------------
 
      ** If Security is specified,
      ** process only this one.
 
     C                   IF        SPSESN <> *BLANKS
     C                             AND SPSESN <> TR_SESN
 
      ** Process the transaction with a last action date between the start date and the end date.
 
     C                             OR TR_LCD < SPMSTD                           Request Start Date
     C                             AND TR_TYPE <> 'MT'
     C                             OR TR_LCD > SPMETD                           Request End Date
     C                             AND TR_TYPE <> 'MT'
 
      ** Process the matured security with a due date between the start date and the end date.
 
     C                             OR  TR_TYPE = 'MT'
     C                             AND PDUD   < SPMSTD                          Request Start Date
     C                             OR  TR_TYPE = 'MT'
     C                             AND PDUD   > SPMETD                          Request End Date
 
      ** Process only authorized transactions
 
     C                             OR TR_RECI = 'L'
 
     C                   EVAL      WTran2Rpt = 'N'
     C                   LEAVESR
     C                   ENDIF
 
      ** Process only deleted trades with a value date in the back value period
 
     C                   IF            TR_RECI = '*'
     C                             AND WkBckValDate > TDVD
 
     C                   IF            WkRcdFmt = 'TRADSDF'
     C                             OR  WkRcdFmt = 'TRADTO'
     C                             OR  WkRcdFmt = 'TRADFR'
 
     C                   EVAL      WTran2Rpt = 'N'
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
 
      ** Conditional transastion details
      *  -------------------------------
 
      ** Retrieve the Customer Class
 
     C                   EVAL      WkCnumClass = WkCustClass
 
      ** Retrieve the transaction type
 
     C                   EVAL      WkTransType = TR_TYPE
 
      ** Retrieve the Class of the Counterparty trade or the Beneficiary Depot
 
      **   If the customer of the request has a class 'S' ro 'D', the processing considers
      **   only the transactions where the customer is the Counterparty of the trade or the
      **   Beneficiary of the depot.
      **   Thus, the class of the Counterparty/Beneficiary is already known.
 
     C                   IF        WkCustClass = 'C'                            Client
     C                   EVAL      WkCountClass = WkCustClass
     C                   ELSE
 
      **   Otherwise, the processing considers only the transactions where the customer is
      **   the Deliver To/From of trade, or In Depot/Out Depot of depot
 
     C                   MOVE      TR_COBE       WkCountCust                    Count/Benef. Cust.
     C     WkCountCust   CHAIN     SDSECSL1
     C                   IF        NOT %FOUND(SDSECSL1)
     C                   CLEAR                   DsArgmt
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        BFCLAS = 'S'                                 Safe Custody
     C                             OR BFCLAS = 'D'                              Discretionary
     C                   EVAL      WkCountClass = 'C'                           Client
     C                   ELSE
     C                   EVAL      WkCountClass = 'M'                           Market
     C                   ENDIF
     C                   ENDIF
 
      ** Retrieve if the Customer is the Deliver To or In Depot
      **   For customer with a Class 'S' or 'D', the Deliver To and In Depot are not considered.
 
     C                   EVAL      WkInCust     = *Blanks
     C                   IF        WkCustClass  = 'M'                           Market
     C                   IF            WkRcdFmt = 'TRADTO'                      Deliver To
     C                             OR  WkRcdFmt = 'HSTTRTO'                     Deliver To
     C                             OR  WkRcdFmt = 'DPTMVIN'                     In Depot
     C                   EVAL      WkInCust     = 'X'
     C                   ENDIF
     C                   ENDIF
 
      ** Retrieve if the Customer is the Deliver From or Out Depot
      **   For customer with a Class 'S' or 'D', the Deliver From and Out Depot are not considered.
 
     C                   EVAL      WkOutCust    = *Blanks
     C                   IF        WkCustClass  = 'M'                           Market
     C                   IF            WkRcdFmt = 'TRADFR'                      Deliver From
     C                             OR  WkRcdFmt = 'HSTTRFR'                     Deliver From
     C                             OR  WkRcdFmt = 'DPTMVOU'                     Out Depot
     C                   EVAL      WkOutCust    = 'X'
     C                   ENDIF
     C                   ENDIF
 
      ** Retrieve the relation between the Deliver To and From, OR In and Out Depot
      **   For customer with a Class 'S' or 'D', this relation is not considered.
 
     C                   EVAL      WkRelation   = *Blanks
     C                   IF        WkCustClass  = 'M'                           Market
     C                   SELECT
     C                   WHEN          WkRcdFmt = 'TRADFR'                      Deliver From
     C                             OR  WkRcdFmt = 'TRADTO'                      Deliver To
     C                             OR  WkRcdFmt = 'HSTTRFR'                     Deliver From
     C                             OR  WkRcdFmt = 'HSTTRTO'                     Deliver To
     C                   IF        DELF = DELT
     C                   EVAL      WkRelation   = '='
     C                   ELSE
     C                   EVAL      WkRelation   = '<>'
     C                   ENDIF
     C                   WHEN          WkRcdFmt = 'DPTMVIN'                     In Depot
     C                             OR  WkRcdFmt = 'DPTMVOU'                     Out Depot
     C                   IF        DPID = DPOD
     C                   EVAL      WkRelation   = '='
     C                   ELSE
     C                   EVAL      WkRelation   = '<>'
     C                   ENDIF
     C                   ENDSL
     C                   ENDIF
 
      ** Retrieve the leg of Depot.
 
     C                   EVAL      WkLeg = *Blanks
     C                   IF           WkRcdFmt = 'DPTMVDF'
     C                             OR WkRcdFmt = 'DPTMVIN'
     C                             OR WkRcdFmt = 'DPTMVOU'
     C                   IF        TR_TYPE = 'WO'
     C                   EVAL      WkLeg = 'OUT'
     C                   ELSE
     C                   EVAL      WkLeg = 'IN'
     C                   ENDIF
     C                   ENDIF
 
      ** Second call
      *  ===========
 
     C                   ELSE
 
      ** Check if the second leg of depot has to be reported
 
     C                   IF        WkTrans     = 'DEPOT'                        Depot
     C                             AND TR_TYPE <> 'WI'                          Not Walk In
     C                             AND WkLeg   = 'IN'                           First leg
     C                   EVAL      WkLeg       = 'OUT'                          Second Leg
     C                   ELSE
     C                   EVAL      WTran2Rpt = 'N'
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
 
      ** Check in decision table if the movement has to be reported and how it
      ** updates the position.
 
     C                   EVAL      Idx = 1
     C     DsArgmt       LOOKUP    TbArgmt(Idx)                           99
     C   99              EVAL      DsResult = TbResult(Idx)
     C                   IF        NOT *IN99
     C                             OR WkReport <> 'Y'
     C                   EVAL      WTran2Rpt = 'N'
     C                   LEAVESR
     C                   ENDIF
 
      ** Set the transaction as to be reported.
 
     C                   EVAL      WTran2Rpt = 'Y'
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $FinDtl - Retrieve and Load Financial Instrument Details           *
      **********************************************************************
 
     C     $FinDtl       BEGSR
      *    -------       -----
 
     C                   EVAL      WFinDtlFnd  = 'N'                            Financial Dtl Found
 
      ** Check if the Financial Instrument has not yet been extracted for the request
 
     C                   IF        WPrSESN = TR_SESN
     C                   EVAL      WFinDtlFnd  = 'Y'                            Financial Dtl Found
     C                   LEAVESR
     C                   ENDIF
 
      ** Extract the Financial Instrument.
 
     C                   CLEAR                   SETFIND0
 
      ** Retrieve the security details
 
     C     TR_SESN       CHAIN     SECTY
     C                   IF        NOT %FOUND(SECTY)
     C                   LEAVESR
     C                   ENDIF
 
      ** Retrieve the investment details
 
     C     KInvTyp       CHAIN     INVTP
     C                   IF        NOT %FOUND(INVTP)
     C                   LEAVESR
     C                   ENDIF
 
      ** Calculate Security Details
 
     C                   EXSR      $CalcSecDtl
 
      ** Load security details
 
     C                   EXSR      $LdSecurity
 
      ** Load Price
 
     C                   EXSR      $LdPrice
 
      ** Load Place: Source of Price
 
     C                   EXSR      $LdPlace
 
      ** Load Date/Time of Price Quotation
 
     C                   EXSR      $LdPrDate
 
      ** Load Balance
 
     C                   EXSR      $LdBalance
 
      ** Write the Financial Instrument details
 
     C                   EVAL      TFEXTR =  *ZEROS
     C                   EVAL      TFDATE =  SPDATE
     C                   EVAL      TFRSEQ =  SPRSEQ
     C                   WRITE     SETFIND0
 
     C                   EVAL      WFinDtlFnd  = 'Y'                            Financial Dtl Found
     C                   EVAL      WPrSESN     = TR_SESN                        Previous Financial
     C                   EVAL      WTrnBySec   = *Zeros                         Trans. Seq By Secur.
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdTransact - Load Transaction details                             *
      **********************************************************************
 
     C     $LdTransact   BEGSR
      *    -----------   -----
 
     C                   EVAL      WTrnBySec = WTrnBySec + 1                    Trans. Seq By Secur.
 
     C                   CLEAR                   SETTRAD0
 
      ** Load Trade Details
 
     C                   EXSR      $LdTradeDtl
 
      ** Load Reference
 
     C                   EXSR      $LdRef
 
      ** Load Posting Quantity
 
     C                   EXSR      $LdPostQua
 
      ** Load Accrual Days
 
     C                   EXSR      $LdAccDay
 
      ** Load Accrual Amount
 
     C                   EXSR      $LdAccAmt
 
      ** Load Posting Amount
 
     C                   EXSR      $LdPostAmt
 
      ** Load Dates
 
     C                   EXSR      $LdDates
 
      ** Load Movement Status
 
     C                   EXSR      $LdMvtsts
 
      ** Load Transaction Details Narrative
 
     C                   EXSR      $LdTrsNarr
 
      ** Load Increase/Decrease Indicator
 
     C                   EXSR      $LdTrsNarr
 
      ** Load Corporate Action Event Indicator
 
     C                   EXSR      $LdCAEVInd
 
      ** Load Payment Indicator
 
     C                   EXSR      $LdPayInd
 
      ** Load Receive/Deliver Indicator
 
     C                   EXSR      $LdReCeInd
 
      ** Load Type of Settlement Transaction Indicator
 
     C                   EXSR      $LdSETRInd
 
      ** Load Transaction Indicator
 
     C                   EXSR      $LdTranInd
 
      ** Load Party Details
 
     C                   EXSR      $LdPrtyDtl
 
      ** Add record to extract file
 
     C                   EVAL      TTSIZE = TTSIZE + 24                         Block TRAN
     C                                             + 24                         Block TRANSDET
     C                                             + 24                         Block SETPRTY
     C                   EVAL      TTEXTR =  *ZEROS                             Extract Reference
     C                   EVAL      TTDATE =  SPDATE                             Request Date
     C                   EVAL      TTRSEQ =  SPRSEQ                             Request Sequence
     C                   EVAL      TTSESN =  Se_SESN                            Security shortname
     C                   EVAL      TTTSEQ =  WTrnBySec                          Transaction Sequence
 
     C                   WRITE     SETTRAD0
 
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
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdSecurity - Load security details                                *
      **********************************************************************
 
     C     $LdSecurity   BEGSR
      *    -----------   -----
 
     C                   EVAL      TFSESN = Se_SESN                             Security shortname
     C                   EVAL      TFSRPN = Se_SRPN                             Security Report Name
     C                   EVAL      TFSFN1 = Se_SFN1                             Security Full Name 1
     C                   EVAL      TFSFN2 = Se_SFN2                             Security Full Name 2
     C                   EVAL      TFNMCY = Se_NMCY                             Nominal Currency
     C                   EVAL      TFNMDP = Se_NMDP                             Nominal decimal plac
     C                   EVAL      TFSCOR = Se_SCOR                             Country of risk
     C                   EVAL      TFSREF = Se_SREF                             Sedol (Extel) Ref
     C                   EVAL      TFT2RF = Se_T2RF                             Telekurs (Valoren) R
     C                   EVAL      TFCSPN = Se_CSPN                             Cusip Number
     C                   EVAL      TFISIN = Se_ISIN                             ISIN
     C                   EVAL      TFSPBS = Se_SPBS                             Price Basis
     C                   EVAL      TFSTBS = Se_STBS                             Trade Basis
     C                   EVAL      TFSYBS = Se_SYBS                             Yield Basis
     C                   EVAL      TFSWTP = Se_SWTP                             SWIFT Security Type
     C                   EVAL      TFPROT = In_PROT                             Processing Type
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   EVAL      TFSIZE = TFSIZE + 33                         Static fields
     C                                             + %LEN(%TRIM(TFSRPN))        Security Report Name
     C                                             + %LEN(%TRIM(TFSFN1))        Security Full Name 1
     C                                             + %LEN(%TRIM(TFSFN2))        Security Full Name 2
     C                                             + %LEN(%TRIM(TFSCOR))        Country of risk
     C                                             + 17                         ISIN
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdPrice  - Load Price                                             *
      **********************************************************************
 
     C     $LdPrice      BEGSR
      *    ---------     -----
 
      ** Qualifier
      *  ---------
 
     C                   EVAL      TFPQUA = 'MRKT'                              MRKT or INDC
 
      ** Currency
      *  --------
 
      ** The price currency is the nominal currency of the security.
 
     C                   IF        Se_SPBS = 'U'
     C                   EVAL      TFPCCY = Se_NMCY
     C                   ENDIF
 
      ** Decimal Position
      *  ----------------
 
      ** The price has 8 decimal positions
 
     C                   EVAL      TFPDPS = 8
 
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
 
     C                   EVAL      TFPRIC = ZY1
 
     C                   GOTO      @LdPrice
     C                   ENDIF
     C                   ENDIF
 
      ** Retrieve the lastest Market Price for Security
 
     C                   EVAL      KPriceTyp = 'V '                             Price Type
     C                   EVAL      KValDate  = *ZEROS                           Value Date
     C**********         EVAL      KCustNb   = *ZEROS                           Customer Numb CSD027
     C                   EVAL      KCustNb   = *BLANKS                          Customer Numb CSD027
 
     C     KPosPrice     SETLL     PRICT
     C                   DOU       %EOF(PRICT) OR Pr_RECI = 'D'
     C     KPrice        READE     PRICT
     C                   ENDDO
 
      ** If price found
 
     C                   IF        NOT %EOF(PRICT)
 
      ** Lastest price from Prices file
 
     C                   EVAL      TFPRIC = Pr_PPRC
 
      ** Otherwise,
 
     C                   ELSE
 
      ** Market Price from Security
 
     C                   EVAL      TFPRIC = Se_MKPR
     C                   ENDIF
 
     C     @LdPrice      TAG
 
      ** Code
      *  ----
 
      ** The code depends of 'Trade Basis' and 'Price Basis' indicator.
 
     C                   SELECT
     C                   WHEN      TFPRIC = *ZEROS                              No Price
     C                   EVAL      TFPCOD = 'UKWN'
     C                   WHEN      Se_STBS = 'Y'                                Yield
     C                   EVAL      TFPCOD = 'YIEL'
     C                   WHEN      Se_STBS = 'D'                                Discount
     C                   EVAL      TFPCOD = 'DISC'
     C                   WHEN      Se_STBS = 'P'                                Price Basis
     C                   IF        Se_SPBS = 'P'
     C                   EVAL      TFPCOD = 'PRCT'                              Percentage
     C                   ELSE
     C                   EVAL      TFPCOD = 'ACTU'                              Actual Amount
     C                   ENDIF
     C                   ENDSL
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   EVAL      TFSIZE = TFSIZE + 18                         Static fields
     C                                             + %LEN(TFPQUA)               Qualifier
     C                                             + %LEN(TFPCOD)               Code
     C                                             + %LEN(TFPCCY)               Currency
     C                                             + %LEN(%CHAR(TFPRIC)) + 2    Price + Comma + Sign
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdPlace  - Load Place: Source of Price                            *
      **********************************************************************
 
     C     $LdPlace      BEGSR
      *    --------      -----
 
     C                   EVAL      TFPLCD = *BLANKS                             Place Code
     C                   EVAL      TFPLAC = *BLANKS                             Place
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   IF        TFPLCD <> *BLANKS
     C                   EVAL      TFSIZE = TFSIZE + 19                         Static fields
     C                                             + %LEN(TFPLCD)               Place Code
     C                                             + %LEN(%TRIM(TFPLAC))        Place
     C                   ENDIF
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdPrDate - Load Date/Time of Price Quotation                      *
      **********************************************************************
 
     C     $LdPrDate     BEGSR
      *    ---------     -----
 
     C                   EVAL      TFPQDT = *ZEROS                              Price Quotation Date
     C                   EVAL      TFPQTM = *ZEROS                              Price Quotation Time
 
     C                   EVAL      KEventTyp = 'PR'                             Price event
     C     KQuotDat      SETLL     SECEO
     C     KQuotDat      READE     SECEO
     C                   IF        NOT %EOF(SECEO)
     C                   EVAL      TFPQDT = Ev_SNDT                             Event Date
     C                   ENDIF
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   IF        TFPQDT <> *ZEROS
     C                   EVAL      TFSIZE = TFSIZE + 14                         Static fields
     C                                             + 8                          Quotation Date
     C                   IF        TFPQTM <> *ZEROS
     C                   EVAL      TFSIZE = TFSIZE + 6                          Quotation Time
     C                   ENDIF
     C                   ENDIF
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdBalance - Load Balance                                          *
      **********************************************************************
 
     C     $LdBalance    BEGSR
      *    ----------    -----
 
      ** This routine prepares the balance details. The balance is calculated in SE4656.
 
      * Balance Code
      * ------------
 
      ** Load the Code according the Price Basis
 
     C                   IF        Se_SPBS = 'P'                                Percentage
     C                   EVAL      TFBLCD = 'FAMT'                              Face Value
     C                   ELSE
     C                   EVAL      TFBLCD = 'UNIT'                              Unit
     C                   ENDIF
 
      ** Opening Balance
      *  ---------------
 
     C                   EVAL      TFOBLC = *BLANKS
     C                   EVAL      TFOBAL = *ZEROS
 
      ** Closing Balance
      *  ---------------
 
     C                   EVAL      TFCBLC = *BLANKS
     C                   EVAL      TFCBAL = *ZEROS
 
      ** Number of Decimal Position
      *  --------------------------
 
     C                   EVAL      TFBLDP = Se_NMDP
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   EVAL      TFSIZE = TFSIZE + 20                         Static fields
     C                                             + %LEN(TFBLCD)               Balance Code
     C                                             + %LEN(TFBLCD)               Balance Code
     C                                             + %LEN(TFOBLC)               Opening Code
     C                                             + %LEN(TFCBLC)               Closing Code
     C                                             + 15 + 2                     Opening Balance
     C                                             + 15 + 2                     Closing Balance
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdTradeDtl - Load Trade Details                                   *
      **********************************************************************
     C     $LdTradeDtl   BEGSR
      *    -----------   -----
 
     C                   EVAL      TTTYPE = TR_TYPE                             Type of transaction
 
      ** For position settlement - maturity, the deliver or recieve indicator
      ** is according the sign of the nominal.
 
     C                   SELECT
     C                   WHEN      WkTrans = 'POSET'                            Position settlement
     C                   IF        PNMP  >= *Zeros                              Nominal Position
     C                   EVAL      WkDeInInd = 'D'                              Deliver
     C                   ELSE
     C                   EVAL      WkDeInInd = 'I'                              Receive
     C                   ENDIF
     C                   ENDSL
 
     C                   EVAL      TTTYPE = TR_TYPE                             Type of transaction
     C                   EVAL      TTINDE = WkDeInInd                           Increase/Decrease P.
     C                   EVAL      TTOWNP = WkPositType                         Customer/Our/User P.
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdRef    - Load References                                        *
      **********************************************************************
 
     C     $LdRef        BEGSR
      *    ------        -----
 
      **   Trade
 
     C                   SELECT
     C                   WHEN      WkTrans = 'TRADE'                            Trade
     C                   EVAL      TTRFTR = TDRF                                Deal Reference
 
      **   Depot
 
     C                   WHEN      WkTrans = 'DEPOT'                            Depot
     C                   EVAL      TTRFTR = DPRN                                Deal Reference
 
      **   DVP/RVP
 
     C                   WHEN      WkTrans = 'DVP  '                            DVP/RVP
     C                   EVAL      TTRFTR = DVREF                               Deal Reference
 
      **   Position Settlement
 
     C                   WHEN      WkTrans = 'POSET'                            Position Settlement
     C                   EVAL      TTRFAS =  TR_SESN                            Account Servicer Ref
 
     C                   ENDSL
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   EVAL      TTSIZE = TTSIZE + 22                         Static fields
     C                                             + %LEN(%TRIM(TTRFPO))        Pool Reference
     C                                             + %LEN(%TRIM(TTRFPR))        Previous Reference
     C                                             + %LEN(%TRIM(TTRFRE))        Related Reference
     C                                             + %LEN(%TRIM(TTRFTR))        Depot Reference
     C                                             + %LEN(%TRIM(TTRFCO))        Front Office Ref.
     C                                             + %LEN(%TRIM(TTRFAS))        Account Servicer Ref
 
     C                   IF        TTRFPO <> *Blanks                            Pool Reference
     C                   EVAL      TTSIZE = TTSIZE + 14                         Static fields
     C                   ENDIF
     C                   IF        TTLKPR <> *Blanks                            Link Prev. Ref. Type
     C                   EVAL      TTSIZE = TTSIZE + 14                         Static fields
     C                   ENDIF
     C                   IF        TTRFPR <> *Blanks                            Previous Reference
     C                   EVAL      TTSIZE = TTSIZE + 14                         Static fields
     C                   ENDIF
     C                   IF        TTLKRE <> *Blanks                            Link Rel. Ref. Type
     C                   EVAL      TTSIZE = TTSIZE + 14                         Static fields
     C                   ENDIF
     C                   IF        TTRFRE <> *Blanks                            Related Reference
     C                   EVAL      TTSIZE = TTSIZE + 14                         Static fields
     C                   ENDIF
     C                   IF        TTRFTR <> *Blanks                            Deal Reference
     C                   EVAL      TTSIZE = TTSIZE + 14                         Static fields
     C                   ENDIF
     C                   IF        TTRFCO <> *Blanks                            Common Reference
     C                   EVAL      TTSIZE = TTSIZE + 14                         Static fields
     C                   ENDIF
     C                   IF        TTRFAS <> *Blanks                            Account Servicer Ref
     C                   EVAL      TTSIZE = TTSIZE + 14                         Static fields
     C                   ENDIF
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdPostQua - Load Posting Quantity                                 *
      **********************************************************************
 
     C     $LdPostQua    BEGSR
      *    ----------    -----
 
      * Quantity Type
      * -------------
 
      ** Load the Code according the Price Basis
 
     C                   IF        Se_SPBS = 'P'                                Percentage
     C                   EVAL      TTPQTY = 'FAMT'                              Face Value
     C                   ELSE
     C                   EVAL      TTPQTY = 'UNIT'                              Unit
     C                   ENDIF
 
      ** Quantity
      *  --------
 
     C                   SELECT
     C                   WHEN      WkTrans = 'TRADE'                            Trade
     C                   EVAL      TTPQUA = NOML
 
     C                   WHEN      WkTrans = 'DEPOT'                            Depot
     C                   EVAL      TTPQUA = DPNA
 
     C                   WHEN      WkTrans = 'DVP  '                            DVP/RVP
     C                   EVAL      TTPQUA = DVNOML
 
     C                   WHEN      WkTrans = 'POSET'                            Positio Settlement
     C                   EVAL      TTPQUA = PNMP
     C                   ENDSL
 
      ** Number of Decimal Position
      *  --------------------------
 
     C                   EVAL      TTPQDC = Se_NMDP
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   EVAL      TTSIZE = TTSIZE + 18                         Static fields
     C                                             + %LEN(TTPQTY)               Quantity Type
     C                                             + %LEN(%CHAR(TTPQUA)) + 1    Quantity + Comma
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdAccDay - Load Accrual Days                                      *
      **********************************************************************
 
     C     $LdAccDay     BEGSR
      *    ---------     -----
 
     C                   EVAL      TTNBDY = *ZEROS
 
     C                   SELECT
 
     C                   WHEN      WkTrans = 'TRADE'                            Trade
     C                             AND ITRA <> *ZEROS                           Interest Amount
     C                             OR WkTrans = 'DVP'                           DVP/RVP
     C                             AND DVITRA <> *ZEROS                         Interest Amount
 
     C                   SELECT
     C                   WHEN      WkTrans = 'TRADE'                            Trade
     C                   MOVE      TDVD          ZECD              5 0          Value Date
     C                   MOVE      TDVD          ZEDATE                         Value Date
     C                   WHEN      WkTrans = 'DVP'                              DVP/RVP
     C                   MOVE      DVVDAT        ZECD              5 0          Value Date
     C                   MOVE      DVVDAT        ZEDATE                         Value Date
     C                   ENDSL
 
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
     C                   PARM                    ZECD
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
 
      ** Retrieve Next Coupon Date after Control Date
      *  --------------------------------------------
 
     C                   CALLB     'ZNCD'
 
      * INPUTS
 
     C                   PARM                    Se_ITLD                        Initial Date
     C                   PARM                    Se_FCPN                        First Coupon Date
     C                   PARM                    Se_MATY                        Maturity Date
     C                   PARM                    CDArr                          Div. or Coupon Rate
     C                   PARM                    CRArr                          Coupon/Rate Indicat.
      *
     C                   PARM                    ZECD                           Midas Start Date
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
 
      ** Calcule number of days between two dates
      *  ----------------------------------------
 
     C                   CALLB     'ZDAYS'
      * INPUTS
      * start date
      * end date
     C                   PARM      ZZLCD         ZSDATE                         Last Coupon Date bef
     C                   PARM                    ZEDATE                         Value Date
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
 
     C                   Z-ADD     ZDDAYS        TTNBDY
 
     C                   ENDSL
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   IF        TTNBDY <> *ZEROS
     C                   EVAL      TTSIZE = TTSIZE + 14                         Static fields
     C                                             + %LEN(%CHAR(TTNBDY))        Accrual Days
     C                   ENDIF
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdAccAmt - Load Accrual Amount                                    *
      **********************************************************************
 
     C     $LdAccAmt     BEGSR
      *    ---------     -----
 
      ** MMM does not process transaction details if the first field (in alphabetique order)
      ** is empty. To avoid the problem, the processing feeds the file TTAICY - Accrued Currency
 
     C                   EVAL      TTAICY = TNMC                                Nominal Currency
 
      **   Trade
 
     C                   SELECT
 
     C                   WHEN      WkTrans = 'TRADE'                            Trade
     C                             AND ITRA <> *ZEROS                           Interest Amount
 
      ** Accrued Amount Currency
      *  -----------------------
 
     C                   EVAL      TTAICY = TNMC                                Nominal Currency
 
      ** Accrued Amount Decimal Position
      *  -------------------------------
 
     C                   EVAL      TTAIDP = TNMD                                Nominal decimal plac
 
      ** Accrued Amount
      *  --------------
 
     C                   EVAL      TTAIMT = ITRA                                Interest Amount (Pur
 
      **   DVP/RVP
 
     C                   WHEN      WkTrans = 'DVP'                              DVP/RVP
     C                             AND DVITRA <> *ZEROS                         Interest Amount
 
      ** Accrued Amount Currency
      *  -----------------------
 
     C                   EVAL      TTAICY = DVNMCY                              Nominal Currency
 
      ** Accrued Amount Decimal Position
      *  -------------------------------
 
     C                   EVAL      TTAIDP = DVNMDP                              Nominal decimal plac
 
      ** Accrued Amount
      *  --------------
 
     C                   EVAL      TTAIMT = DVITRA                              Interest Amount (Pur
 
     C                   ENDSL
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   IF        TTAIMT <> *Zeros
     C                   EVAL      TTSIZE = TTSIZE + 18                         Static fields
     C                                             + %LEN(TTAICY)               Accrued Currency
     C                                             + %LEN(%CHAR(TTAIMT)) + 2    Accrued Amnt + Comma
     C                   ENDIF
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdPostAmt - Load Posting Amount                                   *
      **********************************************************************
 
     C     $LdPostAmt    BEGSR
      *    ----------    -----
 
      **   Trade
      *    -----
 
     C                   SELECT
 
     C                   WHEN      WkTrans = 'TRADE'                            Trade
 
      ** Retrieve the number of decimal position of the Settlement Currency.
 
     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      SETC          @CURR
     C     DSCURR        PARM      DSCURR        DSSDY
 
      ** Posting Currency
      *  ----------------
 
     C                   EVAL      TTPACY = SETC                                Settlement Currency
 
      ** Posting Amount Decimal Position
      *  -------------------------------
 
     C                   EVAL      TTPADP = A6NBDP
 
      ** Posting Amount
      *  --------------
 
     C                   EVAL      ZAMTCI = TCTR                                Contervalue in Nomi.
 
     C                   CALLB     'ZCONV'
     C                   PARM                    ZAMTCI                         Amount In
     C                   PARM      TDER          ZEXCH                          Cross Exchange Rate
     C                   PARM      TMDI          ZMD                            Cross Mult/Div Ind.
     C                   PARM      TNMC          ZCCYI                          Currency In
     C                   PARM      SETC          ZCCYO                          Currency Out
     C                   PARM      NCDP          ZCDPI                          Nb. Decimal In
     C                   PARM      TTPADP        ZCDPO                          Nb. Decimal Out
     C                   PARM      *ZEROS        ZAMTCO                         Amount Out
 
     C                   EVAL      TTPAMT = ZAMTCO
 
      **   DVP/RVP
      *    -------
 
     C                   WHEN      WkTrans = 'DVP'                              DVP/RVP
 
      ** Retrieve the number of decimal position of the Settlement Currency.
 
     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DVSETC        @CURR
     C     DSCURR        PARM      DSCURR        DSSDY
 
      ** Posting Currency
      *  ----------------
 
     C                   EVAL      TTPACY = DVSETC                              Settlement Currency
 
      ** Posting Amount Decimal Position
      *  -------------------------------
 
     C                   EVAL      TTPADP = A6NBDP
 
      ** Posting Amount
      *  --------------
 
     C                   EVAL      TTPAMT = DVSCVL                              Countervalue Set.Ccy
 
      **   Position Settlement
      *    -------------------
 
     C                   WHEN      WkTrans = 'POSET'                            Position Settlement
 
      ** Retrieve the number of decimal position of the Settlement Currency.
 
     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      PNCY          @CURR
     C     DSCURR        PARM      DSCURR        DSSDY
 
      ** Posting Currency
      *  ----------------
 
     C                   EVAL      TTPACY = PNCY                                Nominal Currency
 
      ** Posting Amount Decimal Position
      *  -------------------------------
 
     C                   EVAL      TTPADP = A6NBDP
 
      ** Posting Amount
      *  --------------
 
     C                   EVAL      TTPAMT = PAMD                                Amount Due
 
     C                   ENDSL
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   IF        TTPACY <> *Blanks
     C                   EVAL      TTSIZE = TTSIZE + 18                         Static fields
     C                                             + %LEN(TTPACY)               Posting Amount Ccy
     C                                             + %LEN(%CHAR(TTPAMT)) + 2    Posting Amount+Comma
     C                   ENDIF
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdDates  - Load Dates                                             *
      **********************************************************************
 
     C     $LdDates      BEGSR
      *    --------      -----
 
      ** Trade
      *  -----
 
     C                   SELECT
 
     C                   WHEN      WkTrans = 'TRADE'                            Trade
 
      ** Effective Settlement Date
     C                   EVAL      TTESDT = TDVD                                Value Date
      ** Settlement Date
     C                   EVAL      TTSEDT = TDFS                                Date Fully Settled
      ** Trade Date
     C                   EVAL      TTTRDT = TDDT                                Trade Date
 
      ** In Depot
      *  --------
 
     C                   WHEN      WkTrans = 'DEPOT'                            In Depot
     C                             AND WkLeg = 'IN'
 
      ** Effective Settlement Date
     C                   EVAL      TTESDT = DPMD                                Movement Date In
      ** Settlement Date
     C                   EVAL      TTSEDT = DPMD                                Movement Date In
      ** Trade Date
     C                   SELECT
     C                   WHEN      TR_TYPE = 'WI'                               Walk In
     C                   IF        CSE015 = 'Y'
     C                   EVAL      TTTRDT = DMTD                                Trade date
     C                   ELSE
     C                   EVAL      TTTRDT = DPMD                                Movement Date In
     C                   ENDIF
      *
     C                   OTHER                                                  Other Depot Type
     C                   EVAL      TTTRDT = ORED                                Original Entry Date
     C                   ENDSL
 
      ** Out Depot
      *  ---------
 
     C                   WHEN      WkTrans = 'DEPOT'                            Out Depot
     C                             AND WkLeg = 'OUT'
 
      ** Effective Settlement Date
     C                   IF        TR_TYPE = 'DT'
     C                   EVAL      TTESDT = DPMD                                Movement Date In
     C                   ELSE
     C                   EVAL      TTESDT = DPDO                                Movement Date Out
     C                   ENDIF
      ** Settlement Date
     C                   IF        TR_TYPE = 'DT'
     C                   EVAL      TTSEDT = DPMD                                Movement Date In
     C                   ELSE
     C                   EVAL      TTSEDT = DPDO                                Movement Date Out
     C                   ENDIF
      ** Trade Date
     C                   SELECT
     C                   WHEN      TR_TYPE = 'WO'                               Walk Out
     C                   IF        CSE015 = 'Y'
     C                   EVAL      TTTRDT = DMTD                                Trade date
     C                   ELSE
     C                   EVAL      TTTRDT = DPMD                                Movement Date In
     C                   ENDIF
      *
     C                   OTHER                                                  Other Depot Type
     C                   EVAL      TTTRDT = ORED                                Original Entry Date
     C                   ENDSL
 
      ** DVP/RVP
      *  -------
 
     C                   WHEN      WkTrans = 'DVP'                              DVP/RVP
 
      ** Effective Settlement Date
     C                   EVAL      TTESDT = DVVDAT                              Value Date
      ** Settlement Date
     C                   EVAL      TTSEDT = DVDFST                              Date Fully Settled
      ** Trade Date
     C                   EVAL      TTTRDT = DVTDAT                              Trade Date
 
      ** Position Settlment
      *  ------------------
 
     C                   WHEN      WkTrans = 'POSET'                            Position Settlement
 
      ** Effective Settlement Date
     C                   EVAL      TTESDT = PSVL                                Value Date
      ** Settlement Date
     C                   EVAL      TTSEDT = PDUD                                Due Date
     C                   ENDSL
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
      ** Effective Settlement
 
     C                   SELECT
     C                   WHEN      TTESDT <> *Zeros                             Effective Settl Date
     C                   EVAL      TTSIZE = TTSIZE + 14                         Static fields
     C                                             + 8                          Date
     C                   IF        TTESTM <> *Zeros                             Effective Settl Time
     C                   EVAL      TTSIZE = TTSIZE + 6                          Time
     C                   ENDIF
     C                   WHEN      TTESCD <> *Blanks                            Effective Settl Code
     C                   EVAL      TTSIZE = TTSIZE + 14                         Static fields
     C                                             + %LEN(TTESCD)               Code
     C                   ENDSL
 
      ** Settlement
 
     C                   SELECT
     C                   WHEN      TTSEDT <> *Zeros                             Settlement Date
     C                   EVAL      TTSIZE = TTSIZE + 14                         Static fields
     C                                             + 8                          Date
     C                   IF        TTSETM <> *Zeros                             Settlement Time
     C                   EVAL      TTSIZE = TTSIZE + 6                          Time
     C                   ENDIF
     C                   WHEN      TTSECD <> *Blanks                            Settlement Code
     C                   EVAL      TTSIZE = TTSIZE + 14                         Static fields
     C                                             + %LEN(TTSECD)               Code
     C                   ENDSL
 
      ** Trade
 
     C                   SELECT
     C                   WHEN      TTTRDT <> *Zeros                             Trade Date
     C                   EVAL      TTSIZE = TTSIZE + 14                         Static fields
     C                                             + 8                          Date
     C                   IF        TTTRTM <> *Zeros                             Trade Time
     C                   EVAL      TTSIZE = TTSIZE + 6                          Time
     C                   ENDIF
     C                   WHEN      TTTRCD <> *blanks                            Trade Code
     C                   EVAL      TTSIZE = TTSIZE + 14                         Static fields
     C                                             + %LEN(TTTRCD)               Code
     C                   ENDSL
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdMvtSts - Load Movement Status                                   *
      **********************************************************************
 
     C     $LdMvtSts     BEGSR
      *    ---------     -----
 
     C                   IF        TR_RECI = 'C'
     C                             OR TR_RECI = '*'
     C                             OR TR_RECI = 'R'
     C                             AND WkTrans = 'DEPOT'                        Depot
     C                   EVAL      TTMOVS = 'REVE'
     C                   ENDIF
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   IF        TTMOVS <> *Blanks
     C                   EVAL      TTSIZE = TTSIZE + 14                         Static fields
     C                                             + %LEN(%TRIM(TTMOVS))        Movement Status
     C                   ENDIF
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdTrsNarr - Load Transaction Details Narrative                    *
      **********************************************************************
 
     C     $LdTrsNarr    BEGSR
      *    ----------    -----
 
     C                   EVAL      TTNAR1 = *BLANKS                             Narrative 1
     C                   EVAL      TTNAR2 = *BLANKS                             Narrative 2
     C                   EVAL      TTNAR3 = *BLANKS                             Narrative 3
     C                   EVAL      TTNAR4 = *BLANKS                             Narrative 4
     C                   EVAL      TTNAR5 = *BLANKS                             Narrative 5
     C                   EVAL      TTNAR6 = *BLANKS                             Narrative 6
     C                   EVAL      TTNAR7 = *BLANKS                             Narrative 7
     C                   EVAL      TTNAR8 = *BLANKS                             Narrative 8
     C                   EVAL      TTNAR9 = *BLANKS                             Narrative 9
     C                   EVAL      TTNA10 = *BLANKS                             Narrative 10
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   IF        TTNAR1 <> *BLANKS                            Narrative 1
     C                   EVAL      TTSIZE = TTSIZE + 14                         Static fields
     C                                             + %LEN(%TRIM(TTNAR1))        Narrative 1
     C                                             + %LEN(%TRIM(TTNAR2))        Narrative 2
     C                                             + %LEN(%TRIM(TTNAR3))        Narrative 3
     C                                             + %LEN(%TRIM(TTNAR4))        Narrative 4
     C                                             + %LEN(%TRIM(TTNAR5))        Narrative 5
     C                                             + %LEN(%TRIM(TTNAR6))        Narrative 6
     C                                             + %LEN(%TRIM(TTNAR7))        Narrative 7
     C                                             + %LEN(%TRIM(TTNAR8))        Narrative 8
     C                                             + %LEN(%TRIM(TTNAR9))        Narrative 9
     C                                             + %LEN(%TRIM(TTNA10))        Narrative 10
     C                   ENDIF
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdCAEVInd - Load Corporate Action Event Indicator.                *
      **********************************************************************
 
     C     $LdCAEVInd    BEGSR
      *    ----------    -----
 
     C                   CLEAR                   SETINDD0
 
      ** Qualifier
 
     C                   EVAL      TIQUAL = 'CAEV'
 
      ** Indicator
 
     C                   SELECT
 
     C                   WHEN      WkTrans = 'TRADE'                            Trade
     C                             AND %SUBST(TDNR:34:2) = 'ER'                 Early Redemption
     C                   EVAL      TIINDC = 'PCAL'                              Partial Call
 
     C                   WHEN      WkTrans = 'DEPOT'                            Depot
     C                             AND %SUBST(DPNR:34:2) = 'ER'                 Early Redemption
     C                   EVAL      TIINDC = 'PCAL'                              Partial Call
 
     C                   WHEN      WkTrans = 'POSET'                            Position settlement
     C                   EVAL      TIINDC = 'REDM'                              Final Maturity
     C                   ENDSL
 
      ** If no detail to extract, do not add details
 
     C                   IF        TIINDC = *Blanks
     C                   LEAVESR
     C                   ENDIF
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   EVAL      TISIZE = TISIZE + 10                         Static fields
     C                                             + %LEN(TIQUAL)               Qualifier
     C                                             + %LEN(TIINDC)               Indicator
     C                   EVAL      TTSIZE = TTSIZE + TISIZE                     Transaction length
 
      ** Add record to extract file
      *  ---------------------------
 
     C                   EVAL      TIEXTR =  *ZEROS                             Extract Reference
     C                   EVAL      TIDATE =  SPDATE                             Request Date
     C                   EVAL      TIRSEQ =  SPRSEQ                             Request Sequence
     C                   EVAL      TISESN =  Se_SESN                            Security shortname
     C                   EVAL      TITSEQ =  WTrnBySec                          Transaction Sequence
 
     C                   WRITE     SETINDD0
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdPayInd  - Load Payment Indicator                                *
      **********************************************************************
 
     C     $LdPayInd     BEGSR
      *    ---------     -----
 
     C                   CLEAR                   SETINDD0
 
      ** Qualifier
 
     C                   EVAL      TIQUAL = 'PAYM'
 
      ** Indicator
 
     C                   SELECT
     C                   WHEN      WkTrans = 'TRADE'                            Trade
 
     C                   SELECT
     C                   WHEN      PCOD = '1' OR PCOD = '5'
     C                   EVAL      TIINDC = 'APMT'                              Against Payment
     C                   WHEN      PCOD = '3'
     C                   EVAL      TIINDC = 'FREE'                              Free of Payment
     C                   WHEN      PCOD = '2' OR PCOD = '4'
     C                   EVAL      TIINDC = '    '
     C                   ENDSL
 
     C                   WHEN      WkTrans = 'DVP'                              DVP/RVP
     C                   EVAL      TIINDC = 'APMT'                              Against Payment
 
     C                   WHEN      WkTrans = 'DEPOT'                            Depot
     C                   EVAL      TIINDC = 'FREE'                              Free of Payment
 
     C                   WHEN      WkTrans = 'POSET'                            Position settlement
     C                   EVAL      TIINDC = 'APMT'                              Against Payment
     C                   ENDSL
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   EVAL      TISIZE = TISIZE + 10                         Static fields
     C                                             + %LEN(TIQUAL)               Qualifier
     C                                             + %LEN(TIINDC)               Indicator
     C                   EVAL      TTSIZE = TTSIZE + TISIZE                     Transaction length
 
 
      ** Add record to extract file
      *  ---------------------------
 
     C                   EVAL      TIEXTR =  *ZEROS                             Extract Reference
     C                   EVAL      TIDATE =  SPDATE                             Request Date
     C                   EVAL      TIRSEQ =  SPRSEQ                             Request Sequence
     C                   EVAL      TISESN =  Se_SESN                            Security shortname
     C                   EVAL      TITSEQ =  WTrnBySec                          Transaction Sequence
 
     C                   WRITE     SETINDD0
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdRECEInd - Load Receive/Deliver Indicator                        *
      **********************************************************************
 
     C     $LdReCeInd    BEGSR
      *    ----------    -----
 
     C                   CLEAR                   SETINDD0
 
      ** Qualifier
 
     C                   EVAL      TIQUAL = 'REDE'
 
      ** Indicator
 
     C                   SELECT
     C                   WHEN      WkDeInInd = 'I'                              Increase Position
     C                   EVAL      TIINDC = 'RECE'                              Receive
     C                   WHEN      WkDeInInd = 'D'                              Decrease Position
     C                   EVAL      TIINDC = 'DELI'                              Deliver
     C                   ENDSL
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   EVAL      TISIZE = TISIZE + 10                         Static fields
     C                                             + %LEN(TIQUAL)               Qualifier
     C                                             + %LEN(TIINDC)               Indicator
     C                   EVAL      TTSIZE = TTSIZE + TISIZE                     Transaction length
 
      ** Add record to extract file
      *  ---------------------------
 
     C                   EVAL      TIEXTR =  *ZEROS                             Extract Reference
     C                   EVAL      TIDATE =  SPDATE                             Request Date
     C                   EVAL      TIRSEQ =  SPRSEQ                             Request Sequence
     C                   EVAL      TISESN =  Se_SESN                            Security shortname
     C                   EVAL      TITSEQ =  WTrnBySec                          Transaction Sequence
 
     C                   WRITE     SETINDD0
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdSETRInd - Load Type of Settlement Transaction Indicator         *
      **********************************************************************
 
     C     $LdSETRInd    BEGSR
      *    ----------    -----
 
     C                   CLEAR                   SETINDD0
 
      ** Qualifier
 
     C                   EVAL      TIQUAL = 'SETR'
 
      ** Indicator
 
     C                   SELECT
 
      ** Trade
      *  -----
 
     C                   WHEN      WkTrans = 'TRADE'                            Trade
      *
      ** If Corporate action or Early Redemption, the type of settlement transaction is not reported
      *
     C                   IF        %SUBST(TDNR:1:16) = 'CORPORATE ACTION'       Corporate Action
     C                             OR %SUBST(TDNR:34:2) = 'ER'                  Early Redemption
     C                   LEAVESR
     C                   ENDIF
      *
      ** According the book, the transaction is a trade or a buy/sell
      *
     C                   CALL      'AOBOOKR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      TDBK          @BKCD             2
     C     DSBOOK        PARM      *Blanks       DSFDY
      *
     C                   IF        @RTCD = *Blanks
     C                   SELECT
      *
     C                   WHEN      BDBYSL <> 'Y'                                Not Buy-Sell Book
     C                   EVAL      TIINDC = 'TRAD'                              Trade
      *
     C                   WHEN      BDBYSL =  'Y'                                 Buy-Sell Book
     C     LKRF          CHAIN     TRADS
     C                   IF        %FOUND(TRADS)
     C                   IF        CSW207 = 'N'                                               CSW207
     C                   SELECT
     C                   WHEN      TDVD < Rtv_TDVD
     C                   EVAL      TIINDC = 'BSBO'                              Buy Sell Back Open
     C                   WHEN      TDVD > Rtv_TDVD
     C                   EVAL      TIINDC = 'BSBC'                              Buy Sell Back Close
     C                   WHEN      TDRF < LKRF
     C                   EVAL      TIINDC = 'BSBO'                              Buy Sell Back Open
     C                   WHEN      TDRF > LKRF
     C                   EVAL      TIINDC = 'BSBC'                              Buy Sell Back Close
     C                   ENDSL
     C                   ELSE                                                                 CSW207
     C                   EVAL      TIINDC = 'BSBK'                                            CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF
     C                   ENDSL
     C                   ENDIF
 
      ** DVP/RVP
      *  -------
 
     C                   WHEN      WkTrans = 'DVP'                              DVP/RVP
     C                   EVAL      TIINDC = 'TRAD'                              Trade
 
      ** Depot
      *  -----
 
     C                   WHEN      WkTrans = 'DEPOT'                            Depot
      *
      ** If Corporate action or Early Redemption, the type of settlement transaction is not reported
      *
     C                   IF        %SUBST(DPNR:1:16) = 'CORPORATE ACTION'       Corporate Action
     C                             OR %SUBST(DPNR:34:2) = 'ER'                  Early Redemption
     C                   LEAVESR
     C                   ENDIF
      *
     C                   SELECT
     C                   WHEN      TR_TYPE = 'RR' OR TR_TYPE = 'RP'             Repo/Reverse Repo
     C                   EVAL      TIINDC = 'REPU'                              Repo
      *
     C                   WHEN      TR_TYPE = 'PD' OR TR_TYPE = 'PL'             Pledged Loan/Deposit
     C                   IF        CSW208 = 'Y'                                               CSW208
      *                                                                                       CSW208
     C                   IF        TR_TYPE = 'PD'                                             CSW208
     C                   EVAL      TIINDC = 'COLO'                                            CSW208
     C                   ELSE                                                                 CSW208
     C                   EVAL      TIINDC = 'COLI'                                            CSW208
     C                   ENDIF                                                                CSW208
      *                                                                                       CSW208
     C                   ELSE                                                                 CSW208
     C                   EVAL      TIINDC = 'COLL'                              Collateral
     C                   ENDIF                                                                CSW208
 
     C                   WHEN      TR_TYPE = 'BB' OR TR_TYPE = 'BL'             Bond Borrowing/Lend.
     C                   EVAL      TIINDC = 'SECL'                              Securities Lending
 
     C                   WHEN      TR_TYPE = 'WI' OR TR_TYPE = 'WO'             Walk In / Out
     C                   EVAL      TIINDC = 'OWNE'                              Ext. Own Acc. Transf
 
     C                   WHEN      TR_TYPE = 'DT'                               Depot transfer
      *
      ** According the SWIFT address of the both depots, it is a internal or
      ** external own account transfer.
      *
     C                   MOVEL     DPID          @KEY1                          In Depot
     C                   CALL      'AOCUSTR0'
     C                   PARM      *Blanks       @RTCD                          B:Return code
     C                   PARM      '*KEY'        @OPTN                          I:Option
     C                   PARM                    @KEY1            10            I:Key field
     C                   PARM                    @KYST             7            O:Key status
     C     DSCUST        PARM      *BLANKS       DSSDY                          O:Format
      *
     C                   IF        @RTCD = *Blanks
      *
     C                   MOVE      BBCSID        WkBBCSID                       Save 1 address
      *
     C                   MOVEL     DPOD          @KEY1            10            Out Depot
     C                   CALL      'AOCUSTR0'
     C                   PARM      *Blanks       @RTCD                          B:Return code
     C                   PARM      '*KEY'        @OPTN                          I:Option
     C                   PARM                    @KEY1            10            I:Key field
     C                   PARM                    @KYST             7            O:Key status
     C     DSCUST        PARM      *Blanks       DSSDY                          O:Format
      *
     C                   IF        @RTCD = *Blanks
      *
     C                   SELECT
     C                   WHEN      BBCSID = WkBBCSID                            Same SWIFT address
     C                   EVAL      TIINDC = 'OWNI'                              Int. Own Acc. Transf
     C                   OTHER
     C                   EVAL      TIINDC = 'OWNE'                              Ext. Own Acc. Transf
     C                   ENDSL
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDSL
 
     C                   WHEN      WkTrans = 'POSET'                            Position settlement
     C                   EVAL      TIINDC = 'CORP'                              Corporate Action Act
     C                   ENDSL
 
      ** If no detail to extract, do not add details
 
     C                   IF        TIINDC = *Blanks
     C                   LEAVESR
     C                   ENDIF
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   EVAL      TISIZE = TISIZE + 10                         Static fields
     C                                             + %LEN(TIQUAL)               Qualifier
     C                                             + %LEN(TIINDC)               Indicator
     C                   EVAL      TTSIZE = TTSIZE + TISIZE                     Transaction length
 
      ** Add record to extract file
      *  ---------------------------
 
     C                   EVAL      TIEXTR =  *ZEROS                             Extract Reference
     C                   EVAL      TIDATE =  SPDATE                             Request Date
     C                   EVAL      TIRSEQ =  SPRSEQ                             Request Sequence
     C                   EVAL      TISESN =  Se_SESN                            Security shortname
     C                   EVAL      TITSEQ =  WTrnBySec                          Transaction Sequence
 
     C                   WRITE     SETINDD0
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdTranInd - Load Transaction Indicator                            *
      **********************************************************************
 
     C     $LdTranInd    BEGSR
      *    ----------    -----
 
     C                   CLEAR                   SETINDD0
 
      ** Qualifier
 
     C                   EVAL      TIQUAL = 'TRAN'
 
      ** Indicator
 
     C                   SELECT
     C                   WHEN      WkTrans = 'TRADE'                            Trade
     C                   IF        %SUBST(TDNR:1:16) = 'CORPORATE ACTION'
     C                   EVAL      TIINDC = 'CORP'                              Corporate Action Act
     C                   ELSE
     C                   EVAL      TIINDC = 'SETT'                              Settlement/Clearing
     C                   ENDIF
      *
     C                   WHEN      WkTrans = 'DVP'                              DVP/RVP
     C                   EVAL      TIINDC = 'SETT'                              Settlement/Clearing
      *
     C                   WHEN      WkTrans = 'DEPOT'                            Depot
     C                   IF        %SUBST(DPNR:1:16) = 'CORPORATE ACTION'
     C                   EVAL      TIINDC = 'CORP'                              Corporate Action Act
     C                   ELSE
     C                   EVAL      TIINDC = 'SETT'                              Settlement/Clearing
     C                   ENDIF
 
     C                   WHEN      WkTrans = 'POSET'                            Position settlement
     C                   EVAL      TIINDC = 'CORP'                              Corporate Action Act
     C                   ENDSL
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   EVAL      TISIZE = TISIZE + 10                         Static fields
     C                                             + %LEN(TIQUAL)               Qualifier
     C                                             + %LEN(TIINDC)               Indicator
     C                   EVAL      TTSIZE = TTSIZE + TISIZE                     Transaction length
 
      ** Add record to extract file
      *  ---------------------------
 
     C                   EVAL      TIEXTR =  *ZEROS                             Extract Reference
     C                   EVAL      TIDATE =  SPDATE                             Request Date
     C                   EVAL      TIRSEQ =  SPRSEQ                             Request Sequence
     C                   EVAL      TISESN =  Se_SESN                            Security shortname
     C                   EVAL      TITSEQ =  WTrnBySec                          Transaction Sequence
 
     C                   WRITE     SETINDD0
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdPrtyDtl - Load Party Details                                    *
      **********************************************************************
 
     C     $LdPrtyDtl    BEGSR
      *    ----------    -----
 
      ** The party details will be extracted later for DVP/RVP transactions
 
     C                   CLEAR                   SETPRTD0
 
      ** Load Party (Mandatory)
 
     C                   EXSR      $LdParty
 
      ** Load Safekeeping Account (Optional)
 
     C                   EXSR      $LdSafe
 
      ** If no detail to extract, do not add details
 
     C                   IF        TPQUAL = *Blanks
     C                   LEAVESR
     C                   ENDIF
 
      ** Add record to extract file
      *  ---------------------------
 
     C                   EVAL      TPEXTR =  *ZEROS                             Extract Reference
     C                   EVAL      TPDATE =  SPDATE                             Request Date
     C                   EVAL      TPRSEQ =  SPRSEQ                             Request Sequence
     C                   EVAL      TPSESN =  Se_SESN                            Security shortname
     C                   EVAL      TPTSEQ =  WTrnBySec                          Transaction Sequence
 
     C                   WRITE     SETPRTD0
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdParty   - Load Party                                            *
      **********************************************************************
 
     C     $LdParty      BEGSR
      *    --------      -----
 
     C                   SELECT
 
     C                   WHEN      WkTrans = 'DVP'                              DVP/RVP
 
      ** Qualifier
 
     C                   IF        TR_TYPE = 'DP'                               Deliver / Paiement
     C                   EVAL      TPQUAL =  'BUYR'                             Buyer
     C                   ELSE                                                   Recieve / Paiement
     C                   EVAL      TPQUAL =  'SELL'                             Seller
     C                   ENDIF
 
      ** Indicator
 
     C                   MOVE      DVCTYN        TPPRTC                         Counterparty Cust Nb
     C                   EVAL      TPPRT1 = DVCPTY                              Counterparty
     C                   EVAL      TPPRT2 = DVCPT1                              CParty Address 1
     C                   EVAL      TPPRT3 = DVCPT2                              CParty Address 2
     C                   EVAL      TPPRT4 = DVCPT3                              CParty Address 3
 
     C                   ENDSL
 
      ** If no detail to extract, do not add details
 
     C                   IF        TPQUAL = *Blanks
     C                   LEAVESR
     C                   ENDIF
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
     C                   EVAL      TPSIZE = TPSIZE + 10                         Static fields
     C                                             + %LEN(TPQUAL)               Qualifier
     C                                             + 140                        Name & Address
     C                   EVAL      TTSIZE = TTSIZE + TPSIZE                     Transaction length
 
      *                  -----
     C                   ENDSR
      **********************************************************************
      * $LdSafekeeping Account                                             *
      **********************************************************************
 
     C     $LdSafe       BEGSR
      *    -------       -----
 
 
      ** Evaluate the SWIFT message length
      *  ---------------------------------
 
      ** If no detail to extract, do not add details
 
     C                   IF        TPSAF1 = *Blanks
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      TPSIZE = TPSIZE + 18                         Static fields
     C                                             + %LEN(%TRIM(TPSAF1))        Safekeeping Acc 1
     C                                             + %LEN(%TRIM(TPSAF2))        Safekeeping Acc 2
     C                                             + %LEN(%TRIM(TPSAF3))        Safekeeping Acc 3
     C                                             + %LEN(%TRIM(TPSAF4))        Safekeeping Acc 4
     C                   EVAL      TTSIZE = TTSIZE + TPSIZE                     Transaction length
 
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
 
      ** Access General Ledger details                                                        FIXPA
 
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD                                        FIXPA
     C                   PARM      '*FIRST '     @OPTN                                        FIXPA
     C*****DSGELR        PARM      DSGELR        DSFDY                                        CGL029
     C     DSGELR        PARM      DSGELR        DSSDY                                        CGL029
 
      ** Access Securities Trading ICD data                                                   FIXPA
 
     C                   CALL      'AOSTRDR0'                                                 FIXPA
     C                   PARM      '*DBERR '     @RTCD                                        FIXPA
     C                   PARM      '*FIRST '     @OPTN                                        FIXPA
     C     DSSTRD        PARM      DSSTRD        DSSDY                                        FIXPA
 
      ** Access Switchable features
 
      **  CSE015 - Forward Valued Depot Movements
 
     C                   MOVEL     'N'           CSE015            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSE015'      @SARD             6
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CSE015
     C                   ENDIF
                                                                                              CSW207
      ** Check if SWIFT 2007 is installed                                                     CSW207
                                                                                              CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM                    PRtCd                                        CSW207
                                                                                              CSW207
     C                   IF        PRtCd = 'CSW2007'                                          CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSW207 = 'N'                                               CSW207
     C                   ENDIF                                                                CSW207
      *                                                                                       CSW208
      ** Check if SWIFT 2008 is installed                                                     CSW208
      *                                                                                       CSW208
     C                   CALL      'SWIF2008'                                                 CSW208
     C                   PARM                    PRtCd                                        CSW208
      *                                                                                       CSW208
     C                   IF        PRtCd = 'CSW2008'                                          CSW208
     C                   EVAL      CSW208 = 'Y'                                               CSW208
     C                   ELSE                                                                 CSW208
     C                   EVAL      CSW208 = 'N'                                               CSW208
     C                   ENDIF                                                                CSW208
 
      ** Initialize LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  PSProcName
     C                   OUT       LDA
 
      ***Retrieve*the*Midas*Phase                                                             CCB020
 
     C**********         IN        Dta_MPHAS                                                  CCB020
      *                                                                                       CCB020
      ** CBFLAGQT Phase Check                                                                 CCB020
      *                                                                                       CCB020
     C                   CALL      'CBC001001'                                                CCB020
     C                   PARM      *BLANKS       COBST             4                          CCB020
 
      ** Retrieve the Back Value Date
 
     C**********         IF        MPHAS <> 'A'                                 COB           CCB020
     C                   IF        COBST = '*YES'                                             CCB020
 
     C                   IF        BKAPDT >=  BJDNWD
     C                   EVAL      WkBckValDate = BJDNWD - 1 - BVBVP
     C                   ELSE
     C                   EVAL      WkBckValDate = BKAPDT - BVBVP
     C                   ENDIF
 
     C                   ELSE                                                   I/C Cycle
 
     C                   EVAL      WkBckValDate = BJRDNB - 1 - BVBVP
 
     C                   ENDIF
 
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
**CTDATA TbArgmt
C TP C            Y D C TRADE
C TS C            Y I C TRADE
C DP C            Y D C DVP
C RV C            Y I C DVP
C MT C            Y   C POSET
C WI C        IN  Y I C DEPOT
C WO C        OUT Y D C DEPOT
C BB C        IN  Y D C DEPOT
C BB C        OUT Y I C DEPOT
C BL C        IN  Y I C DEPOT
C BL C        OUT Y D C DEPOT
C PD C        IN  Y I C DEPOT
C PD C        OUT Y D C DEPOT
C PL C        IN  Y D C DEPOT
C PL C        OUT Y I C DEPOT
C RP C        IN  Y I C DEPOT
C RP C        OUT Y D C DEPOT
C RR C        IN  Y D C DEPOT
C RR C        OUT Y I C DEPOT
M TP M X   =      Y I U TRADE
M TP M X   <>     Y I U TRADE
M TP M   X =      N I C TRADE
M TP M   X <>     N I C TRADE
M TP C X   =      N     TRADE
M TP C X   <>     Y I U TRADE
M TP C   X =      N     TRADE
M TP C   X <>     Y D U TRADE
M TS M X   =      N I C TRADE
M TS M X   <>     N I C TRADE
M TS M   X =      Y D U TRADE
M TS M   X <>     Y D U TRADE
M TS C X   =      N     TRADE
M TS C X   <>     Y I U TRADE
M TS C   X =      N     TRADE
M TS C   X <>     Y D U TRADE
M DP C            Y D C DVP
M RV C            Y I C DVP
M MT C            Y   U POSET
M DP M            N     DVP
M RV M            N     DVP
M MT M            Y   U POSET
M WI M X   <> IN  Y I O DEPOT
M WI C X   <> IN  Y I O DEPOT
M WO M   X <> OUT Y D O DEPOT
M WO C   X <> OUT Y D O DEPOT
M DT C X   =  IN  Y I O DEPOT
M DT C X   =  OUT N     DEPOT
M DT C X   <> IN  Y I O DEPOT
M DT C X   <> OUT N     DEPOT
M DT C   X =  IN  N     DEPOT
M DT C   X =  OUT Y D O DEPOT
M DT C   X <> IN  N     DEPOT
M DT C   X <> OUT Y D O DEPOT
M DT M X   =  IN  Y I O DEPOT
M DT M X   =  OUT N     DEPOT
M DT M X   <> IN  Y I O DEPOT
M DT M X   <> OUT N     DEPOT
M DT M   X =  IN  N     DEPOT
M DT M   X =  OUT Y D O DEPOT
M DT M   X <> IN  N     DEPOT
M DT M   X <> OUT Y D O DEPOT
M BB C X   =  IN  N     DEPOT
M BB C X   =  OUT N     DEPOT
M BB C X   <> IN  Y I O DEPOT
M BB C X   <> OUT Y D O DEPOT
M BB C   X =  IN  N     DEPOT
M BB C   X =  OUT N     DEPOT
M BB C   X <> IN  Y D O DEPOT
M BB C   X <> OUT Y I O DEPOT
M BB M X   =  IN  Y I O DEPOT
M BB M X   =  OUT Y D O DEPOT
M BB M X   <> IN  Y I O DEPOT
M BB M X   <> OUT Y D O DEPOT
M BB M   X =  IN  N     DEPOT
M BB M   X =  OUT N     DEPOT
M BB M   X <> IN  N     DEPOT
M BB M   X <> OUT N     DEPOT
M BL C X   =  IN  N     DEPOT
M BL C X   =  OUT N     DEPOT
M BL C X   <> IN  Y D O DEPOT
M BL C X   <> OUT Y I O DEPOT
M BL C   X =  IN  N     DEPOT
M BL C   X =  OUT N     DEPOT
M BL C   X <> IN  Y I O DEPOT
M BL C   X <> OUT Y D O DEPOT
M BL M X   =  IN  Y D O DEPOT
M BL M X   =  OUT Y I O DEPOT
M BL M X   <> IN  Y D O DEPOT
M BL M X   <> OUT Y I O DEPOT
M BL M   X =  IN  N     DEPOT
M BL M   X =  OUT N     DEPOT
M BL M   X <> IN  N     DEPOT
M BL M   X <> OUT N     DEPOT
M PD C X   =  IN  N     DEPOT
M PD C X   =  OUT N     DEPOT
M PD C X   <> IN  Y D O DEPOT
M PD C X   <> OUT Y I O DEPOT
M PD C   X =  IN  N     DEPOT
M PD C   X =  OUT N     DEPOT
M PD C   X <> IN  Y I O DEPOT
M PD C   X <> OUT Y D O DEPOT
M PD M X   =  IN  Y D O DEPOT
M PD M X   =  OUT Y I O DEPOT
M PD M X   <> IN  Y D O DEPOT
M PD M X   <> OUT Y I O DEPOT
M PD M   X =  IN  N     DEPOT
M PD M   X =  OUT N     DEPOT
M PD M   X <> IN  N     DEPOT
M PD M   X <> OUT N     DEPOT
M PL C X   =  IN  N     DEPOT
M PL C X   =  OUT N     DEPOT
M PL C X   <> IN  Y I O DEPOT
M PL C X   <> OUT Y D O DEPOT
M PL C   X =  IN  N     DEPOT
M PL C   X =  OUT N     DEPOT
M PL C   X <> IN  Y D O DEPOT
M PL C   X <> OUT Y I O DEPOT
M PL M X   =  IN  Y I O DEPOT
M PL M X   =  OUT Y D O DEPOT
M PL M X   <> IN  Y I O DEPOT
M PL M X   <> OUT Y D O DEPOT
M PL M   X =  IN  N     DEPOT
M PL M   X =  OUT N     DEPOT
M PL M   X <> IN  N     DEPOT
M PL M   X <> OUT N     DEPOT
M RP C X   =  IN  N     DEPOT
M RP C X   =  OUT N     DEPOT
M RP C X   <> IN  Y D O DEPOT
M RP C X   <> OUT Y I O DEPOT
M RP C   X =  IN  N     DEPOT
M RP C   X =  OUT N     DEPOT
M RP C   X <> IN  Y I O DEPOT
M RP C   X <> OUT Y D O DEPOT
M RP M X   =  IN  Y D O DEPOT
M RP M X   =  OUT Y I O DEPOT
M RP M X   <> IN  Y D O DEPOT
M RP M X   <> OUT Y I O DEPOT
M RP M   X =  IN  N     DEPOT
M RP M   X =  OUT N     DEPOT
M RP M   X <> IN  N     DEPOT
M RP M   X <> OUT N     DEPOT
M RR C X   =  IN  N     DEPOT
M RR C X   =  OUT N     DEPOT
M RR C X   <> IN  Y I O DEPOT
M RR C X   <> OUT Y D O DEPOT
M RR C   X =  IN  N     DEPOT
M RR C   X =  OUT N     DEPOT
M RR C   X <> IN  Y D O DEPOT
M RR C   X <> OUT Y I O DEPOT
M RR M X   =  IN  Y I O DEPOT
M RR M X   =  OUT Y D O DEPOT
M RR M X   <> IN  Y I O DEPOT
M RR M X   <> OUT Y D O DEPOT
M RR M   X =  IN  N     DEPOT
M RR M   X =  OUT N     DEPOT
M RR M   X <> IN  N     DEPOT
M RR M   X <> OUT N     DEPOT
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2003
