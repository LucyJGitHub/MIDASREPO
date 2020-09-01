     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Effective Interest Rate Period Split')        *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE004600 - Midas LE Effective Interest Rate Period Update    *
      *                                                               *
      *  Function:  This program defines the start and end date of    *
      *             the Effective Interest Rate (EIR) period and      *
      *             writes and updates the EIR details file           *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE154             Date 07Aug12               *
      *                 CLE141             Date 08Feb16               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CLE139             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG13731           Date 18Apr07               *
      *                 BUG13530           Date 08Mar07               *
      *                 BUG13140A          Date 05Mar07               *
      *                 BUG13082A          Date 28Feb07               *
      *                 BUG13079A          Date 26Feb07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 BUG13305           Date 20Feb07               *
      *                 BUG13140           Date 05Feb07               *
      *                 BUG13079           Date 23Jan07               *
      *                 BUG13038           Date 18Jan07               *
      *                 BUG13044           Date 17Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 239178             Date 19Jul06               *
      *                 BUG10875A (Reopen) Date 12May06               *
      *                 BUG10875           Date 16Mar06               *
      *                 CLE042             Date 06Sep05               *
      *                 233545             Date 18May05               *
      *                 233578             Date 19May05               *
      *                 CAS011             Date 16May05               *
      *                 232771             Date 21Mar05               *
      *                 232770             Date 15Mar05               *
      *                 232769             Date 14Mar05               *
      *                 232630             Date 14Mar05               *
      *                 232628             Date 14Mar05               *
      *                 232348             Date 21Feb05               *
      *                 232313             Date 28Feb05               *
      *                 231710             Date 26Jan05               *
      *                 231568             Date 10Jan05               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE154 - Loan Repayment Schedule Enhancement (Recompile)     *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  BUG13731  - EIR is reflected as zero in LE004620P1 &         *
      *              LE004620P2 reports                               *
      *  BUG13530  - Incorrect Amount Reflected in TFDP and TFDPA     *
      *  BUG13140A - Doubling of amounts of Total Adj. to yield fees  *
      *              and Total FDP on LE004620P1 report               *
      *  BUG13082A - Fee totals on the EIR records are not updated    *
      *              when fee is backvalued. Applied fix for 238569.  *
      *  BUG13079A - Discount/Premiums was included in Total Adj.     *
      *              to yield fees.                                   *
      *                 - Error originally reported in BUG13079       *
      *                   was incorrect.                              *
      *                 - Reverse BUG13079                            *
      *  BUG13305 - Future-valued loan excluded in the report         *
      *  BUG13140 - Doubling of amounts of Total Adj. to yield fees   *
      *             and Total FDP on LE004620P1 report                *
      *  BUG13079 - Non-linear fee not included in the "total F/D/P"  *
      *             in the LE004620P1                                 *
      *  BUG13038 - accruing fees Total recurred amount not displyed  *
      *  BUG13044 - Create EIR detail file for new loans only if      *
      *             value date has started                            *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  239178 - Allow negative fee.                                 *
      *  BUG10875A (Reopen) - Receiver value too small to hold result *
      *                       (Recompile)                             *
      *  BUG10875 - Receiver value too small to hold result           *
      *  CLE042 - Extended Loan Sub Type                              *
      *  233545 - Cut-off Date (Recompile)                            *
      *  233578 - Ensure correct discount amount for loans maturing   *
      *           today and include maturing loans today in 232348    *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  232771 - Include fees on maturity on the last period         *
      *  232770 - Ensure that no dummy records (EISTDT = EIENDT)      *
      *           are written in LEEIRDPD                             *
      *  232769 - Include loans that are maturing today               *
      *  232630 - Incorrect non-linear amortization.                  *
      *  232628 - CAS009 Rollover patch (LE).                         *
      *  232348 - Introduce cut-off date for non-linear amortisation  *
      *  232313 - EIDSTD is updated incorrectly                       *
      *  231710 - All Fees should Amortise at EIR Start Date          *
      *  231568 - Removed reference to LEFEEDL6                       *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas LE Loans by Type/Sub Type
     F***CLOANL9   UF   E           K DISK    INFSR(*PSSR)                                    CAS011
     FCLOANL10  UF   E           K DISK    INFSR(*PSSR)                                       CAS011

      ** Midas LE Loans by Loan Reference
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(CK)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCLF)
     F                                     IGNORE(CLOANZ1F)

      ** Midas SD Loan type/subtype file FSACAI = 'Y'
     FSDLOANL3  IF   E           K DISK    INFSR(*PSSR)

      ** Midas LE Effective Interest Rate Details
     FLEEIRAL0  UF A E           K DISK    INFSR(*PSSR)

      ** Midas LE Effective Interest Rate Details
     FLEEIRAL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEEIRAD0:LEEIRAD1)

      ** Midas LE Effective Interest Rate Details
     FLEEIRAL2  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEEIRAD0:LEEIRAD2)

      ** Midas LE Effective Interest Rate Details
     FLEEIRAL4  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEEIRAD0:LEEIRAD4)

      ** Midas LE Effective Interest Rate Period
     F***LEEIRDL0  UF A E           K DISK    INFSR(*PSSR)                                    232769
     FLEEIRDL8  UF A E           K DISK    INFSR(*PSSR)                                       232769

      ** Midas LE Effective Interest Rate Period
     FLEEIRDL1  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEEIRDD0:LEEIRDD1)
     F                                     RENAME(LEEIRHD0:LEEIRHD1)

      ** Midas LE Effective Interest Rate Period
     FLEEIRDL2  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEEIRDD0:LEEIRDD2)
     F                                     RENAME(LEEIRHD0:LEEIRHD2)

      ** Midas LE Effective Interest Rate Period
     FLEEIRDL4  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEEIRDD0:LEEIRDD4)
     F                                     RENAME(LEEIRHD0:LEEIRHD4)

      ** Midas LE Effective Interest Rate History File
     FLEEIRHPD  UF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(HI:2)

      ** Midas LE Fees
     F***LEFEEDLD  UF   E           K DISK    INFSR(*PSSR)                                    CAS011
     FLEFEEDLE  UF   E           K DISK    INFSR(*PSSR)                                       CAS011
     F                                     RENAME(LEFEEDF:LEFEEDDD)
     F                                     PREFIX(LD)

      ** Midas LE Fees
     F***LEFEEDL6  IF   E           K DISK    INFSR(*PSSR)                                    231568
     F**********                           RENAME(LEFEEDF:LEFEEDD6)                           231568
     F**********                           PREFIX(L6)                                         231568

      ** Midas LE Fees
     F***LEFEEDL7  UF   E           K DISK    INFSR(*PSSR)                                    CAS011
     FLEFEEDL8  UF   E           K DISK    INFSR(*PSSR)                                       CAS011
     F                                     RENAME(LEFEEDF:LEFEEDD7)
     F                                     PREFIX(L7)

      ** Midas LE Fees
     F***LEFEEDL8  UF   E           K DISK    INFSR(*PSSR)                                    CAS011
     FLEFEEDL9  UF   E           K DISK    INFSR(*PSSR)                                       CAS011
     F                                     RENAME(LEFEEDF:LEFEEDD8)
     F                                     PREFIX(L8)

      ** Midas LE Fees
     F***LEFEEDL9  IF   E           K DISK    INFSR(*PSSR)                                    CAS011
     FLEFEEDLA  IF   E           K DISK    INFSR(*PSSR)                                       CAS011
     F                                     RENAME(LEFEEDF:LEFEEDD9)
     F                                     PREFIX(L9)

      ** Midas LE Cashflows File
     F***LECFLAL2  IF   E           K DISK    INFSR(*PSSR)                                    231710
     FLECFLFL0  IF   E           K DISK    INFSR(*PSSR)                                       231710
     F                                     PREFIX(CF:2)

      ** Midas MM Effective Interest Rate Details
     FLEHISTL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(HS)

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

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Long Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** External data structure for Midas SD Bank details ICD file
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External data structure for Midas General Ledger ICD file
     D SDGELR        E DS                  EXTNAME(SDGELRPD)

      ** External data structure for Currency Details File
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)

      ** External data structure for Currency Details File
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** External data structure for Customer Details File
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** External data structure for Midas Hedging ICD file                                   232348
     D SDHEDG        E DS                  EXTNAME(SDHEDGPD)                                  232348
                                                                                              232348
      ** External data structure for EIR File (Current)
     D EIRCurrFmt    E DS                  EXTNAME(LEEIRDPD)

      ** External data structure for EIR File (New)
     D EIRNewFmt     E DS                  EXTNAME(LEEIRDPD)
     D                                     PREFIX(NW:2)

      ** External data structure for EIR File (History)
     D EIRHistFmt    E DS                  EXTNAME(LEEIRHPD)
     D                                     PREFIX(HI:2)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D*KLnRf****       S              6S 0                                                    CLE148
     D KLnRf           S              6A                                                      CLE148
     D KFSeq           S              2S 0
     D KDate           S              5P 0

     D PRetCode        S              7A
     D POption         S              7A
     D PCurrency       S              3A
     D PBaseRate       S              2A

     D PAmount         S             15P 0
     D POutAmount      S             15P 0
     D PFrXRate        S             13P 8
     D PToXRate        S             13P 8
     D POutXRat        S             13P 8
     D PFrCurrency     S              3A
     D PToCurrency     S              3A
     D PFrMDIn         S              1A
     D PToMDIn         S              1A
     D POutMDIn        S              1A
     D PFrDecPlace     S              1P 0
     D PToDecPlace     S              1P 0

     D WEvCD           S              5P 0
     D WNextDate       S              5P 0
     D WPrevDate       S              5P 0
     D WEndDate        S              5P 0
     D WAmortAmnt      S             15P 0
     D WDAccAmount     S             15P 0
     D WAccAmount      S             15P 0
     D WRepAmount      S             15P 0
     D WRepamountfdpa  S             15P 0                                                  BUG13038
     D WTempAmount     S             15P 0
     D WCurrPrincipal  S             15P 0
     D*WFees***        S             15P 0                                        BUG13079 BUG13079A
     D*WTotalInterest  S             15P 0                                        BUG13079 BUG13079A

      ** Temporary Fields for Initial Exchange Rate                                           231710
     D***WExchangeRte    S             11P 7                                         231710 BUG10875
     D WExchangeRte    S             13P 8                                           231710 BUG10875
     D WMultDivInd     S              1A                                                      231710
                                                                                              231710
     D WLoopDoneF      S              1A
     D WLoopOnceF      S              1A
     D WAdjAmortF      S              1A
     D WUpdateOnlyF    S              1A
     D WAdjustmentF    S              1A
     D WUpdEIRD        S              1A                                                   BUG13082A
     D WLONUpd         S              1A   INZ('Y')                                         BUG13731

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** Read Deal Type/Sub Type combinations to index deals file
     C     *LOVAL        SETLL     SDLOANL3
     C                   READ      SDLOANL3

     C                   DOW       NOT %EOF(SDLOANL3)
     C*****KLoanType     SETLL     CLOANL9                                                    CAS011
     C*****KLoanType     READE     CLOANL9                                                    CAS011
     C     KLoanType     SETLL     CLOANL10                                                   CAS011
     C     KLoanType     READE     CLOANL10                                                   CAS011

     C**********         DOW       NOT %EOF(CLOANL9)                                          CAS011
     C                   DOW       NOT %EOF(CLOANL10)                                         CAS011
                                                                                              232348
      ** Check if the loan whose Loan Type/Sub Type has been flagged for                      232348
      ** non linear amortisation was entered before the cutoff date                           232348
      ** Include fees maturing today                                                          233578
     C                   IF        FSNLAC > VDAT                                              232348
     C**********                   OR RECI = 'M' AND MDAT <= BJRDNB                    232630 233578
     C                             OR RECI = 'M' AND MDAT < BJRDNB                            233578
     C*****KLoanType     READE     CLOANL9                                             232348 CAS011
     C     KLoanType     READE     CLOANL10                                                   CAS011
     C                   ITER                                                                 232348
     C                   ENDIF                                                                232348

     C                   IF        MCRA = 'Y'
     C     LNRF          CHAIN     CLOANCKF
     C                   ENDIF
      ** Call EIR Processing routine
     C                   EXSR      SrProcEIR
     C                   CLEAR                   CLOANCLF
     C*****KLoanType     READE     CLOANL9                                                    CAS011
     C     KLoanType     READE     CLOANL10                                                   CAS011

     C                   ENDDO
     C                   READ      SDLOANL3
     C                   ENDDO

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrProcEIR - Process EIR Periods                               *
      *                                                               *
      *****************************************************************

     C     SrProcEIR     BEGSR

     C                   EVAL      WAdjustmentF = 'N'
     C                   CLEAR                   EIRNewFmt
     C                   EVAL      WUpdEIRD = 'N'                                          BUG13082A

      ** Check EIR file to obtain current (first) EIR period

     C*****LNRF*         CHAIN     LEEIRDL0                                                   232769
     C     LNRF          CHAIN     LEEIRDL8                                                   232769

     C                   SELECT

     C**********         WHEN      %FOUND(LEEIRDL0) AND                                       232769
     C                   WHEN      %FOUND(LEEIRDL8) AND                                       232769
     C                             EIENDT <= WEvCD AND EIENDT >= BJRDNB
     C                             AND RECI <> 'M'                                            232769
     C                             OR  %FOUND(LEEIRDL8)                                       232769
     C                             AND RECI = 'M' AND MDAT < BJRDNB                           232769

      ** Period might possibly have ended already. Check.
     C                   EXSR      SrEndEIR

     C**********         WHEN      EIADJP = 'Y'                                            BUG13082A
     C                   WHEN      %FOUND(LEEIRDL8) AND                                    BUG13082A
     C                             EIADJP = 'Y'                                            BUG13082A

     C                   EXSR      SrAdjToEIR
                                                                                           BUG13082A
      ** For new fees inserted                                                             BUG13082A
     C                   WHEN      %FOUND(LEEIRDL8) AND                                    BUG13082A
     C                             EIRCAL = 'Y'                                            BUG13082A
     C                   EVAL      EIRNewFmt = EIRCurrFmt                                  BUG13082A
     C                   EVAL      WUpdEIRD = 'Y'                                          BUG13082A

      ** If no existing period is defined check if one can be setup
      ***Create*new*record*if*deal*value*date*has*started***********               BUG13044 BUG13305
                                                                                            BUG13044
     C**********         WHEN      NOT %FOUND(LEEIRDL0)                                       232769
     C                   WHEN      NOT %FOUND(LEEIRDL8)                                       232769
     C**********                   AND VDAT <= WEvCD                               BUG13044 BUG13305

     C                   EXSR      SrNewEIR
     C                   WHEN      %FOUND(LEEIRDL8) AND                                     BUG13731
     C                             VDAT = WEvCd AND DDAT <> VDAT                            BUG13731
     C                             AND EIRCAL <> 'Y'                                        BUG13731
     C                   EVAL      EIRCAL    = 'Y'                                          BUG13731
     C                   EVAL      EIRNewFmt = EIRCurrFmt                                   BUG13731
     C                   EVAL      WUpdEIRD = 'Y'                                           BUG13731
     C                   MOVE      'N'           WLONUpd           1                        BUG13731
     C                   ENDSL

     C                   IF        NWSTDT <> 0 AND NWENDT <> 0
     C                             AND NWSTDT <> NWENDT                                       232770
     C                   EXSR      SrAmortise
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrNewEIR   - Defines a New EIR Period when no period is       *
      *              defined yet for the loan                         *
      *                                                               *
      *****************************************************************

     C     SrNewEIR      BEGSR

      ** Default EIR Period start date to Value Date
     C                   EVAL      NWSTDT = VDAT
     C                   EVAL      NWENDT = MDAT

     C                   IF        RLDT <> 0 AND RLDT < NWENDT AND
     C                             RLDT > NWSTDT
     C                   EVAL      NWENDT = RLDT
      *                                                                                       232628
      ** Start date should be equal to last rollover date.                                    232628
      *                                                                                       232628
     C                   IF        LRLD <> 0                                                  232628
     C                   EVAL      NWSTDT = LRLD                                              232628
     C                   ENDIF                                                                232628
      *                                                                                       232628
     C                   ENDIF

     C                   IF        NWSTDT <> 0 AND NWENDT <> 0

      ** If a valid EIR period has been defined, Amortise
     C                   EVAL      NWRECI = 'D'
     C                   EVAL      NWTRAN = LNRF
     C                   EVAL      NWRCAL = 'Y'
     C                   EVAL      EIRCurrFmt = EIRNewFmt
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrEndEIR - Verifies the end of an EIR record and updates if   *
      *            necessary                                          *
      *                                                               *
      *****************************************************************

     C     SrEndEIR      BEGSR
                                                                                              232628
     C                   IF        EIRECI = 'M'                                               232628
                                                                                              232628
     C                   EVAL      EIRHistFmt = EIRCurrFmt                                    232628
     C                   IF        RLDT = BJRDNB AND CKNCCY <> *BLANKS                        232628
     C                   EVAL      PFrCurrency = CCY                                          232628
     C                   EVAL      PToCurrency = CKNCCY                                       232628
     C                   EVAL      PAmount = TFDP                                             232628
     C                   EXSR      SrConvert                                                  232628
     C                   EVAL      TFDP = POutAmount                                          232628
     C                   EVAL      PAmount = TFDPA                                            232628
     C                   EXSR      SrConvert                                                  232628
     C                   EVAL      TFDPA = POutAmount                                         232628
     C                   EVAL      PAmount = TFAM                                             232628
     C                   EXSR      SrConvert                                                  232628
     C                   EVAL      TFAM = POutAmount                                          232628
     C                   EVAL      PAmount = TFAC                                             232628
     C                   EXSR      SrConvert                                                  232628
     C                   EVAL      TFAC = POutAmount                                          232628
     C                   EVAL      PAmount = AFDP                                             232628
     C                   EXSR      SrConvert                                                  232628
     C                   EVAL      AFDP = POutAmount                                          232628
     C                   EVAL      PAmount = CFDP                                             232628
     C                   EXSR      SrConvert                                                  232628
     C                   EVAL      CFDP = POutAmount                                          232628
     C                   ENDIF                                                                232628
                                                                                              232628
      ** Write Period to History File                                                         232628
     C                   WRITE     LEEIRHD0                                                   232628
     C                   DELETE    LEEIRDD0                                                   232628
                                                                                              232770
      ** Ensure that no details reamin on the EIR DS                                          232770
     C                   CLEAR                   EIRCurrFmt                                   232770
                                                                                              232770
     C                   ELSE                                                                 232628

     C                   EVAL      NWSTDT = EIENDT
     C                   EVAL      NWENDT = MDAT
     C                   EVAL      NWLADT = *ZEROS                                            231710
     C                   EVAL      NWAMAJ = *ZEROS                                            231710

     C                   IF        RLDT <> 0 AND RLDT < NWENDT AND
     C                             RLDT > NWSTDT
     C                   EVAL      NWENDT = RLDT
     C                   ENDIF

     C                   IF        NWSTDT <> 0 AND NWENDT <> 0

     C                   EVAL      NWTRAN = EITRAN

     C**********         IF        BKALDI = 'Y'                                               232628
     C                   EVAL      NWRECI = 'T'
     C                   EVAL      NWRCAL = 'Y'                                               232628
      **********                                                                              232628
     C**********         ELSE                                                                 232628
     C**********         EVAL      NWRECI = 'D'                                               232628
     C**********         EVAL      NWRCAL = 'Y'                                               232628
     C**********         EVAL      EIRHistFmt = EIRCurrFmt                                    232628
     C**********         EVAL      HIRECI = 'M'                                               232628
      **********                                                                              232628
     C**********         IF        RLDT = BJRDNB AND CKNCCY <> *BLANKS                        232628
     C**********         EVAL      PFrCurrency = CCY                                          232628
     C**********         EVAL      PToCurrency = CKNCCY                                       232628
     C**********         EVAL      PAmount = TFDP                                             232628
     C**********         EXSR      SrConvert                                                  232628
     C**********         EVAL      TFDP = POutAmount                                          232628
     C**********         EVAL      PAmount = TFDPA                                            232628
     C**********         EXSR      SrConvert                                                  232628
     C**********         EVAL      TFDPA = POutAmount                                         232628
     C**********         EVAL      PAmount = TFAM                                             232628
     C**********         EXSR      SrConvert                                                  232628
     C**********         EVAL      TFAM = POutAmount                                          232628
     C**********         EVAL      PAmount = TFAC                                             232628
     C**********         EXSR      SrConvert                                                  232628
     C**********         EVAL      TFAC = POutAmount                                          232628
     C**********         EVAL      PAmount = AFDP                                             232628
     C**********         EXSR      SrConvert                                                  232628
     C**********         EVAL      AFDP = POutAmount                                          232628
     C**********         EVAL      PAmount = CFDP                                             232628
     C**********         EXSR      SrConvert                                                  232628
     C**********         EVAL      CFDP = POutAmount                                          232628
     C**********         ENDIF                                                                232628
      **********                                                                              232628
      ***Write*Period to History File                                                         232628
     C**********         WRITE     LEEIRHD0                                                   232628
     C**********         DELETE    LEEIRDD0                                                   232628
     C**********         ENDIF                                                                232628

     C                   MOVE      EIRNewFmt     EIRCurrFmt
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAmortise - Compute amount to amortise for the period        *
      *                                                               *
      *****************************************************************

     C     SrAmortise    BEGSR

     C                   EVAL      WTempAmount = 0
     C                   EVAL      WAmortAmnt = 0
     C***********        EVAL      WTotalInterest = 0                             BUG13140 BUG13079A

      ** Discount Processing
     C                   IF        PTYP = 63 OR PTYP = 65 OR PTYP = 67
     C                   EVAL      WAmortAmnt = TOTI
     C***********        EVAL      WTotalInterest = TOTI                          BUG13079 BUG13079A
     C                   ENDIF

     C                   IF        WAmortAmnt > 0

      ** Remove earlier discount amount to prevent duplicate record on                        233578
      ** LEEIRAPD as in the case of early matured loans                                       233578
     C                   EVAL      KLnRf = LNRF                                               233578
     C                   EVAL      KFSeq = 0                                                  233578
     C     KLnRfFSeq     CHAIN     LEEIRAL4                                                   233578
     C                   IF        %FOUND(LEEIRAL4)                                           233578
     C                   DELETE    LEEIRAD4                                                   233578
     C                   ENDIF                                                                233578
      ** Get Currency details from the currencies file
     C                   EVAL      PAmount = WAmortAmnt
     C                   EVAL      PCurrency = CCY
     C                   EXSR      SrCurr

     C                   EVAL      EARECI = 'D'
     C                   EVAL      EATYPE = 'D'
     C                   EVAL      EATRAN = LNRF
     C                   EVAL      EAFCOD = *ZEROS
     C                   EVAL      EAFSEQ = *ZEROS
     C                   EVAL      EACCY = CCY
     C                   EVAL      EAXRAT = A6SPRT
     C                   EVAL      EAMDIN = A6MDIN
     C                   EVAL      EASTDT = EISTDT
     C                   EVAL      EAENDT = EIENDT
     C                   EVAL      EASDAM = EISTDT
     C                   EVAL      EAEDAM = EIENDT
     C                   MOVE      WAmortAmnt    EAAMNT
     C                   MOVE      TOTI          EAOAMT

     C                   WRITE     LEEIRAD0

     C                   IF        EIRECI = 'D'
     C                             OR EIRECI = 'M' AND EIENDT >= BJRDNB                       233578
     C                             OR EIRECI = 'T'                                            232628
     C**********         EVAL      DSAM = DSAM + WAmortAmnt                                   233578
     C**********         EVAL      EIDSTD = DSAM                                       232313 233578
     C                   EVAL      DSAM = WAmortAmnt - AMDS                                   233578
     C                   EVAL      EIDSTD = WAmortAmnt                                        233578
     C                   ENDIF

     C                   ENDIF

     C                   EVAL      WTempAmount = WAmortAmnt
     C                   EVAL      WAmortAmnt = 0
     C**********         EVAL      WFees = 0                                      BUG13079 BUG13079A

      ** Read through Amortising and One-off fees
     C*****LNRF          SETLL     LEFEEDLD                                                   CAS011
     C*****LNRF          READE     LEFEEDLD                                                   CAS011
     C     LNRF          SETLL     LEFEEDLE                                                   CAS011
     C     LNRF          READE     LEFEEDLE                                                   CAS011

     C                   EVAL      KLnRf = LNRF

     C**********         DOW       NOT %EOF(LEFEEDLD)                                         CAS011
     C                   DOW       NOT %EOF(LEFEEDLE)                                         CAS011

     C**********         IF        LDFEPSTD < EISTDT OR LDFEPSTD > EIENDT              231710 232628
     C                   IF           LDFEPSTD <  EISTDT AND LDFEPYON = 'S'                   232628
     C**********                   OR LDFEPSTD >= EIENDT AND LDFEPYON = 'S'            232628 232771
     C                             OR LDFEPSTD > EIENDT AND LDFEPYON = 'S'                    232771
     C                             OR LDFEPSTD = EIENDT AND LDFEPYON = 'S'                    232771
     C                             AND EIENDT <> MDAT                                         232771
     C                             OR LDFEPSTD <  EISTDT AND LDFEPYON = ' '                   232628
     C**********                   OR LDFEPSTD >= EIENDT AND LDFEPYON = ' '            232628 232771
     C                             OR LDFEPSTD > EIENDT AND LDFEPYON = ' '                    232771
     C                             OR LDFEPSTD = EIENDT AND LDFEPYON = ' '                    232771
     C                             AND EIENDT <> MDAT                                         232771
     C                             OR LDFEPEND <  EISTDT AND LDFEPYON = 'E'                   232628
     C**********                   OR LDFEPEND >= EIENDT AND LDFEPYON = 'E'            232628 232771
     C                             OR LDFEPSTD > EIENDT AND LDFEPYON = 'E'                    232771
     C                             OR LDFEPEND = EIENDT AND LDFEPYON = 'E'                    232771
     C                             AND EIENDT <> MDAT                                         232771
     C*****LNRF          READE     LEFEEDLD                                            231710 CAS011
     C     LNRF          READE     LEFEEDLE                                                   CAS011
     C                   ITER                                                                 231710
     C                   ENDIF                                                                231710
                                                                                              231710
     C                   EVAL      WExchangeRte = *ZERO                                       231710
     C                   EVAL      WMultDivInd = *BLANK                                       231710
     C                   EVAL      KFSeq = LDFEFSEQ
     C     KLnRfFSeq     CHAIN     LEEIRAL4

     C                   IF        %FOUND(LEEIRAL4)                                           231710
     C                   EVAL      WExchangeRte = EAXRAT                                      231710
     C                   EVAL      WMultDivInd = EAMDIN                                       231710
     C                   ENDIF                                                                231710
                                                                                              231710
     C                   DOW       %FOUND(LEEIRAL4)
     C                             AND EATYPE = 'N'
     C                   EVAL      WUpdateOnlyF = 'N'
     C                   DELETE    LEEIRAD4
     C     KLnRfFSeq     CHAIN     LEEIRAL4
     C                   ENDDO

     C     KLnRfFSeq     CHAIN     LEEIRAL4
     C                   IF        %FOUND(LEEIRAL4)
     C                   IF        LDFEPYON = EATYPE
     C                             AND LDFEFCCY = EACCY
     C                             AND LDFEFAMT = EAOAMT
     C                   EVAL      WUpdateOnlyF = 'N'
     C*****LNRF          READE     LEFEEDLD                                                   CAS011
     C     LNRF          READE     LEFEEDLE                                                   CAS011
     C                   ITER
     C                   ELSE
     C                   EVAL      WUpdateOnlyF = 'Y'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WUpdateOnlyF = 'N'
     C                   ENDIF

     C                   EVAL      WAmortAmnt = LDFEFAMT

     C**********         IF        WAmortAmnt > 0                                             239178

     C                   EVAL      PCurrency = LDFEFCCY
     C                   EXSR      SrCurr

      ** Convert Fee Currency when it is not the Deal Currency
     C                   IF        CCY <> LDFEFCCY
     C                   EVAL      PFrCurrency = LDFEFCCY
     C                   EVAL      PToCurrency = CCY
     C                   EVAL      PAmount = WAmortAmnt
     C                   EXSR      SrConvert
     C                   ELSE
                                                                                              231710
      ** If this is not a new record, use Existing exchange Rates                             231710
     C                   IF        WExchangeRte = 0                                           231710
     C                   EVAL      POutXRat = A6SPRT
     C                   EVAL      POutMDIn = A6MDIN
     C                   EVAL      POutAmount = WAmortAmnt
     C                   ELSE                                                                 231710
     C                   EVAL      POutXRat = WExchangeRte                                    231710
     C                   EVAL      POutMDIn = WMultDivInd                                     231710
     C                   ENDIF                                                                231710
     C                   ENDIF

     C**********         EVAL      WFees = POutAmount                             BUG13079 BUG13079A
      *
     C                   IF        LDFEPYON = 'S'
     C                   EVAL      EATYPE = 'S'
     C                   EVAL      EAEDAM = LDFEPEND
     C                   ELSE
     C                   EVAL      EATYPE = ' '
     C                   EVAL      EAEDAM = LDFEPSTD
     C                   ENDIF
     C
     C                   EVAL      EARECI = 'D'
     C                   EVAL      EATRAN = LDFELOAN
     C                   EVAL      EAFCOD = LDFEFCOD
     C                   EVAL      EAFSEQ = LDFEFSEQ
     C                   EVAL      EACCY = LDFEFCCY
     C                   EVAL      EAXRAT = POutXRat
     C                   EVAL      EAMDIN = POutMDIn
     C                   EVAL      EASTDT = EISTDT
     C                   EVAL      EAENDT = EIENDT
     C**********         EVAL      EASDAM = LDFEPSTD                                          231710
     C                   EVAL      EASDAM = EISTDT                                            231710
     C                   EVAL      EAEDAM = EIENDT                                            231710
     C                   MOVE      POutAmount    EAAMNT
     C                   MOVE      WAmortAmnt    EAOAMT

     C                   IF        WUpdateOnlyF = 'Y'
     C                   UPDATE    LEEIRAD4
     C                   ELSE
     C                   WRITE     LEEIRAD0
     C                   ENDIF

      ** If EIR being updated is a current EIR, update LEFEED
     C                   IF        EIRECI = 'D'
     C                             OR EIRECI = 'T'                                            232628
     C**********         EVAL      LDFEFEAM = LDFEFEAM + POutAmount                           231710
     C                   EVAL      LDFEFEAM = POutAmount                                      231710
     C                   UPDATE    LEFEEDDD
     C                   ENDIF

     C**********         ENDIF                                                                239178

     C                   EVAL      WTempAmount = WTempAmount + POutAmount

     C*****LNRF          READE     LEFEEDLD                                                   CAS011
     C     LNRF          READE     LEFEEDLE                                                   CAS011
     C                   ENDDO

     C                   IF        WTempAmount > 0
     C                   EVAL      EIFDPA = WTempAmount + EIFDPA

     C                   EVAL      KDate = EISTDT
     C     KHist         SETLL     LEHISTL4

     C                   IF        %EQUAL(LEHISTL4)
     C                   READ      LEHISTL4
     C                   ELSE
     C     KHIST         READPE    LEHISTL4
     C                   IF        NOT %EOF(LEHISTL4)
     C                   EVAL      WCurrPrincipal = HSPRAM
     C                   ELSE
     C                   EVAL      WCurrPrincipal = CPAM
     C                   ENDIF
     C                   ENDIF

     C**********         EVAL      EIDSTD = WCurrPrincipal - EIFDPA                           232313
     C                   ENDIF

      ** Read through Repeating and Accruing Fees

     C                   EVAL      WTempAmount = 0
     C                   EVAL      WAccAmount = 0

     C*****LNRF          SETLL     LEFEEDL7                                                   CAS011
     C*****LNRF          READE     LEFEEDL7                                                   CAS011
     C     LNRF          SETLL     LEFEEDL8                                                   CAS011
     C     LNRF          READE     LEFEEDL8                                                   CAS011

     C                   EVAL      KLnRf = LNRF

     C**********         DOW       NOT %EOF(LEFEEDL7)                                         CAS011
     C                   DOW       NOT %EOF(LEFEEDL8)                                         CAS011

     C                   IF        L7FEPEND < EISTDT                                          231710
     C                             OR L7FEPEND > EIENDT AND L7FEPYON <> 'N'                   231710
     C                             OR L7FENPYD > EIENDT AND L7FEPYON = 'N'                    231710
     C*****LNRF          READE     LEFEEDL7                                            231710 CAS011
     C     LNRF          READE     LEFEEDL8                                                   CAS011
     C                   ITER                                                                 231710
     C                   ENDIF                                                                231710
                                                                                              231710
     C                   EVAL      WExchangeRte = *ZERO                                       231710
     C                   EVAL      WMultDivInd = *BLANK                                       231710
                                                                                              231710
     C                   EVAL      KFSeq = L7FEFSEQ
     C     KLnRfFSeq     CHAIN     LEEIRAL4

     C                   IF        %FOUND(LEEIRAL4)                                           231710
     C                   EVAL      WExchangeRte = EAXRAT                                      231710
     C                   EVAL      WMultDivInd = EAMDIN                                       231710
     C                   ENDIF                                                                231710
                                                                                              231710
     C                   DOW       %FOUND(LEEIRAL4)
     C                             AND EATYPE = 'N'
     C                   EVAL      WUpdateOnlyF = 'N'
     C                   DELETE    LEEIRAD4
     C     KLnRfFSeq     CHAIN     LEEIRAL4
     C                   ENDDO

     C     KLnRfFSeq     CHAIN     LEEIRAL4
     C                   IF        %FOUND(LEEIRAL4)
     C                   IF        L7FEPYON = EATYPE
     C                             AND L7FEFCCY = EACCY
     C                             AND L7FEFAMT = EAOAMT
     C                   EVAL      WUpdateOnlyF = 'N'
     C*****LNRF          READE     LEFEEDL7                                                   CAS011
     C     LNRF          READE     LEFEEDL8                                                   CAS011
     C                   ITER
     C                   ELSE
     C                   EVAL      WUpdateOnlyF = 'Y'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WUpdateOnlyF = 'N'
     C                   ENDIF

     C                   EVAL      EASTDT = EISTDT
     C                   EVAL      EAENDT = EIENDT
     C                   EVAL      WNextDate = EISTDT
     C                   EVAL      WLoopDoneF = 'N'

     C                   IF        WUpdateOnlyF = 'Y'

     C     KLnRfFSeq     CHAIN     LEEIRAL4

     C                   DOW       %FOUND(LEEIRAL4)
     C                             AND EATYPE = 'N'
     C                   EVAL      WUpdateOnlyF = 'N'
     C                   DELETE    LEEIRAD4
     C     KLnRfFSeq     CHAIN     LEEIRAL4
     C                   ENDDO

     C                   ENDIF

     C                   EVAL      WRepAmount = *ZERO
     C                   EVAL      WRepAmountfdpa = *ZERO                                   BUG13038
     C*****KLnRfFSeq     CHAIN     LECFLAL2                                                   231710
     C     KLnRfFSeq     CHAIN     LECFLFL0                                                   231710
     C                   DOU       WLoopDoneF = 'Y'

     C                   IF        L7FEPYON = 'N'
     C**********                   AND %FOUND(LECFLAL2)                                       231710
     C                             AND %FOUND(LECFLFL0)                                       231710

     C                   EVAL      WPrevDate = WNextDate
     C**********         EVAL      EASDAM = WPrevDate                                         231710

     C*****KLnRfFSeq     READE     LECFLAL2                                                   231710
     C     KLnRfFSeq     READE     LECFLFL0                                                   231710

     C**********         IF        %FOUND(LECFLAL2)                                           231710
     C                   IF        NOT %EOF(LECFLFL0)                                         231710
     C                             AND CFFLDT <= EIENDT                                       231710
     C*****KLnRfFSeq     READPE    LECFLAL2                                                   231710
     C     KLnRfFSeq     READPE    LECFLFL0                                                   231710
     C                   EVAL      WNextDate = CFFLDT
     C                   EVAL      EAEDAM = WNextDate
     C*****KLnRfFSeq     READE     LECFLAL2                                                   231710
     C     KLnRfFSeq     READE     LECFLFL0                                                   231710
     C                   ELSE
     C                   EVAL      WNextDate = EIENDT
     C                   EVAL      EAEDAM = WNextDate
     C                   EVAL      WLoopDoneF = 'Y'
     C                   EVAL      WAccAmount = L7FEFAMT
     C                   ENDIF

     C                   EVAL      EATYPE = 'N'
     C                   EVAL      EAEDAM = L7FELADT
     C**********         EVAL      WAccAmount = CFCAMT                                        231710
     C**********         EVAL      WRepAmount = WAccAmount + CFCAMT                           231710
     C                   EVAL      WAccAmount = L7FEFAMT                                      231710
     C**********         EVAL      WRepAmount = WAccAmount + L7FEFAMT               231710  BUG13038
     C                   EVAL      WRepAmount = WRepAmount + L7FEFAMT                       BUG13038
     C                   IF        L7FEADJY = 'Y'                                           BUG13038
     C                   EVAL      WRepAmountfdpa = WRepAmountfdpa + L7FEFAMT               BUG13038
     C                   ENDIF                                                              BUG13038

     C                   ELSE
     C                   EVAL      EATYPE = 'E'
     C**********         EVAL      EASDAM = EISTDT                                            231710
     C**********         EVAL      EAEDAM = EIENDT                                            231710
     C                   EVAL      WAccAmount = L7FEFAMT
     C                   EVAL      WLoopDoneF = 'Y'
     C                   ENDIF


     C                   EVAL      PCurrency = L7FEFCCY
     C                   EXSR      SrCurr

      ** Convert Fee Currency when it is not the Deal Currency
     C                   IF        CCY <> L7FEFCCY
     C                   EVAL      PFrCurrency = L7FEFCCY
     C                   EVAL      PToCurrency = CCY
     C                   EVAL      PAmount = WAccAmount
     C                   EXSR      SrConvert
     C                   ELSE
                                                                                              231710
      ** If this is not a new record, use Existing exchange Rates                             231710
     C                   IF        WExchangeRte = 0                                           231710
     C                   EVAL      POutXRat = A6SPRT
     C                   EVAL      POutMDIn = A6MDIN
     C                   ELSE                                                                 231710
     C                   EVAL      POutXRat = WExchangeRte                                    231710
     C                   EVAL      POutMDIn = WMultDivInd                                     231710
     C                   ENDIF                                                                231710
     C                   EVAL      POutAmount = WAccAmount
     C                   ENDIF

     C                   EVAL      EARECI = 'D'
     C                   EVAL      EATRAN = L7FELOAN
     C                   EVAL      EAFCOD = L7FEFCOD
     C                   EVAL      EAFSEQ = L7FEFSEQ
     C                   EVAL      EACCY = L7FEFCCY
     C                   EVAL      EAXRAT = POutXRat
     C                   EVAL      EAMDIN = POutMDIn
     C                   EVAL      EASTDT = EISTDT
     C                   EVAL      EAENDT = EIENDT
     C                   EVAL      EASDAM = EISTDT                                            231710
     C                   EVAL      EAEDAM = EIENDT                                            231710
     C                   MOVE      POutAmount    EAAMNT
     C                   MOVE      WAccAmount    EAOAMT

     C                   IF        WUpdateOnlyF = 'Y'
     C                             AND L7FEPYON <> 'N'
     C                   UPDATE    LEEIRAD4
     C                   ELSE
     C                   WRITE     LEEIRAD0
     C                   ENDIF

     C                   ENDDO

     C                   IF        WRepAmount = 0
     C**********         EVAL      WTempAmount = WTempAmount + WAccAmount                     231710
     C                   EVAL      WTempAmount = WTempAmount + POutAmount                     231710
     C                   ELSE
     C**********         EVAL      WTempAmount = WTempAmount + WRepAmount                     231710
     C                   EVAL      POutAmount = WRepAmount
     C                   ENDIF

     C                   EVAL      PCurrency = L7FEFCCY                                       231710
     C                   EXSR      SrCurr                                                     231710
                                                                                              231710
     C                   IF        CCY <> L7FEFCCY AND WRepAmount <> 0
     C                   EVAL      PFrCurrency = L7FEFCCY
     C                   EVAL      PToCurrency = CCY
     C                   EVAL      PAmount = WRepAmount
     C                   EXSR      SrConvert
     C                   EVAL      WTempAmount = WTempAmount + POutAmount                     231710
     C                   ENDIF

      ** If EIR being updated is a current EIR, update LEFEED
     C                   IF        EIRECI = 'D'
     C                             OR EIRECI = 'T'                                            232628
     C**********         EVAL      L7FEFEAM = L7FEFEAM + POutAmount                           231710
     C                   EVAL      L7FEFEAM = POutAmount                                      231710
     C                   UPDATE    LEFEEDD7
     C                   ENDIF

     C*****LNRF          READE     LEFEEDL7                                                   CAS011
     C     LNRF          READE     LEFEEDL8                                                   CAS011
     C                   ENDDO

     C                   IF        WTempAmount > 0
                                                                                              231710
      ** Instead of adding to accruing totals, add to amortising instead                      231710
     C**********         EVAL      EIFDPC = WTempAmount + EIFDPC                              231710
     C                   EVAL      EIFDPA = WTempAmount + EIFDPA                              231710
     C                   ENDIF

      ** Set TFDP Amount if reccuring amount is processed.                                  BUG13038
     C**********         IF        ORED = BKAPDT                                  BUG13140A BUG13530
     C                   IF        BJRDNB = BKAPDT                                          BUG13530
     C                   IF        L7FEPYON = 'N' And                                       BUG13038
     C**********                   WRepAmount > 0                                 BUG13038  BUG13530
     C                             WRepAmount > 0 And                                       BUG13530
     C                             LNRF = L7FELOAN                                          BUG13530
     C                   EVAL      TFDP = WRepAmount + TFDP                                 BUG13038
     C                   EVAL      TFDPA = WRepAmountfdpa + TFDPA                           BUG13038
     C                   ENDIF                                                              BUG13038
     C                   ENDIF                                                             BUG13140A
      *                                                                                     BUG13038
      ***Setup*TFDP amount for non-recurring amounts/fees                         BUG13079 BUG13079A
     C**********         IF        (L7FEPYON = 'S' Or                             BUG13079 BUG13079A
     C**********                    L7FEPYON = 'E' Or                             BUG13079 BUG13079A
     C**********                    L7FEPYON = ' '   ) And                        BUG13079 BUG13079A
     C**********                    WFees > 0                                     BUG13079 BUG13079A
     C**********         EVAL       TFDP = WTotalInterest + WFees                 BUG13079 BUG13079A
     C**********         ENDIF                                                    BUG13079 BUG13079A
      **********                                                                  BUG13079 BUG13079A
      ** Set transaction to mature when Period End Date is less than
      ** or equal to rundate and Accrual starts on First Day
     C                   IF        EIENDT <= BJRDNB AND BKALDI <> 'N'
     C                   EVAL      EIRECI = 'M'
     C                   EVAL      EIRHistFmt = EIRCurrFmt
     C                   WRITE     LEEIRHD0

     C                   ELSE
     C                   IF        EIRECI = ' '                                               232628
     C                   EVAL      EIRECI = 'D'
     C                   ENDIF                                                                232628
      *                                                                                    BUG13082A
     C                   IF        WUpdEIRD = 'Y'                                          BUG13082A
     C                   UPDATE    LEEIRDD0                                                BUG13082A
     C                   ELSE                                                              BUG13082A
     C                   WRITE     LEEIRDD0
     C                   ENDIF                                                             BUG13082A

     C                   IF        (WLONUpd = 'Y')                                          BUG13731
     C                   UPDATE    CLOANCLF
     C                   ELSE                                                               BUG13731
     C                   MOVE      'Y'           WLONUpd                                    BUG13731
     C                   ENDIF                                                              BUG13731

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAdjToEIR - Adjust Periods and flags Old EIR Periods as      *
      *              deleted                                          *
      *                                                               *
      *****************************************************************

     C     SrAdjToEIR    BEGSR

     C                   IF        RLDT <> 0
     C                   EVAL      WEndDate = RLDT
     C                   ELSE
     C                   EVAL      WEndDate = MDAT
     C                   ENDIF

     C                   EVAL      EIADJP = *BLANKS
     C                   EVAL      EIRECI = '*'
     C                   EVAL      EIRHistFmt = EIRCurrFmt
     C                   EVAL      EIRNewFmt = EIRCurrFmt
     C                   IF        EIENDT > BJRDNB OR BKALDI = 'N'
     C                   WRITE     LEEIRHD0
     C                   ENDIF
     C                   DELETE    LEEIRDD0
     C                   EVAL      NWRECI = 'D'
     C                   EVAL      NWENDT = WEndDate
     C                   EVAL      NWADJP = *BLANKS
     C                   EVAL      NWRCAL = 'Y'
     C                   CLEAR                   EIRCurrFmt
     C                   EVAL      EIRCurrFmt = EIRNewFmt

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrConvert - Convert from one currency to another              *
      *                                                               *
      *****************************************************************

     C     SrConvert     BEGSR

      ** Save currency specifics first (Exchange Rate, M/D Indicator
      ** and decimal places) then get the other currency's specifics
      ** from the currencies file

     C                   EVAL      PFrXRate = A6SPRT
     C                   EVAL      PFrMDIn = A6MDIN
     C                   EVAL      PFrDecPlace = A6NBDP

     C                   IF        BJCYCD <> PToCurrency
     C                             AND WExchangeRte = 0                                       231710

      ** If target currency is not the base currency, do cross
      ** currency conevrt

     C                   EVAL      PCurrency = PToCurrency
     C                   EXSR      SrCurr

     C                   EVAL      PToXRate = A6SPRT
     C                   EVAL      PToMDIn = A6MDIN
     C                   EVAL      PToDecPlace = A6NBDP

     C                   CALL      'ZCCYCN'
     C                   PARM                    PAmount
     C                   PARM                    PFrCurrency
     C                   PARM                    PToCurrency
     C                   PARM                    PFrXRate
     C                   PARM                    PToXRate
     C                   PARM                    PFrMDIn
     C                   PARM                    PToMDIn
     C                   PARM                    PFrDecPlace
     C                   PARM                    PToDecPlace
     C                   PARM                    POutAmount
     C                   PARM                    POutXRat
     C                   PARM                    POutMDIn

     C                   ELSE

      ** If Temporary exchange rate is not Zero, use it instead                               231710
     C                   IF        WExchangeRte <> 0                                          231710
     C                   EVAL      PFrXRate = WExchangeRte                                    231710
     C                   EVAL      PFrMDIn = WMultDivInd                                      231710
     C                   ENDIF                                                                231710
                                                                                              231710
      ** In Deal Currency is the base currency, do simple convert
     C                   CALL      'ZCONVZ1'
     C                   PARM                    PAmount
     C                   PARM                    PFrXRate
     C                   PARM                    PFrMDIn
     C                   PARM                    PFrCurrency
     C                   PARM                    PToCurrency
     C                   PARM                    PFrDecPlace
     C                   PARM                    PToDecPlace
     C                   PARM                    POutAmount

     C                   EVAL      POutXRat = PFrXRate
     C                   EVAL      POutMDIn = PFrMDIn

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCurr - Call to AOCCURR0                                     *
      *                                                               *
      *****************************************************************

     C     SrCurr        BEGSR

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PCurrency
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = 'SDCURRPD'
     C                   EVAL      Dbase = 3
     C                   EVAL      DbKey = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial Subroutine                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C/COPY ZACPYSRC,DBFIELDS

      ** Set up Local Data Area

     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = *BLANKS
     C                   EVAL      DbKey = *BLANKS
     C                   EVAL      DbPGM = *BLANKS
     C                   EVAL      DbPGM = 'LE004600'
     C                   EVAL      Dbase = *ZERO
     C                   OUT       LDA

     C     KLoanType     KLIST
     C                   KFLD                    AYLNTY
     C                   KFLD                    AYLNST
     C                   KFLD                    AYLNCL                                       CLE042

     C     KLnRfDate     KLIST
     C                   KFLD                    KLnRf
     C                   KFLD                    KDate

     C     KLnRfFSeq     KLIST
     C                   KFLD                    KLnRf
     C                   KFLD                    KFseq

     C     KHist         KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    LNRF
     C                   KFLD                    KDate

      ** Get Bank ICD
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database Error
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = 'SDBANKPD'
     C                   EVAL      Dbase = 1
     C                   EVAL      DbKey = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C**********         CALLB     'AOGELRR0'                                                 CAS011
     C                   CALLB     'AOGELRR1'                                                 CAS011
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CAS011
     C     SDGELR        PARM      SDGELR        DSSDY                                        CAS011

     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = 'SDGELRPD'
     C                   EVAL      Dbase = 2
     C                   EVAL      DbKey = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access Object for Hedge ICD                                                          232348
     C                   CALLB     'AOHEDGR0'                                                 232348
     C                   PARM      *BLANKS       PRetCode                                     232348
     C                   PARM      '*FIRST '     POption                                      232348
     C     SDHEDG        PARM      SDHEDG        DSFDY                                        232348
                                                                                              232348
     C                   IF        PRetCode <> *BLANKS                                        232348
     C     *LOCK         IN        LDA                                                        232348
     C                   EVAL      DbFile = 'SDHEDGPD'                                        232348
     C                   EVAL      Dbase = 4                                                  232348
     C                   EVAL      DbKey = POption                                            232348
     C                   OUT       LDA                                                        232348
     C                   EXSR      *PSSR                                                      232348
     C                   ENDIF                                                                232348
                                                                                              232348
      ** Calculate Event Control Date

     C                   IF        (BJDNWD - 1) > BKAPDT
     C                   EVAL      WEvCD = BKAPDT
     C                   ELSE
     C                   EVAL      WEvCD = BJDNWD - 1
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************

      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.

      /COPY ZACPYSRC,PSSR_ILE

      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2004
